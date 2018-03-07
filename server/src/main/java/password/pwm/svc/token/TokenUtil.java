/*
 * Password Management Servlets (PWM)
 * http://www.pwm-project.org
 *
 * Copyright (c) 2006-2009 Novell, Inc.
 * Copyright (c) 2009-2018 The PWM Project
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

package password.pwm.svc.token;

import password.pwm.PwmApplication;
import password.pwm.PwmConstants;
import password.pwm.bean.EmailItemBean;
import password.pwm.bean.SessionLabel;
import password.pwm.bean.TokenDestinationItem;
import password.pwm.bean.UserIdentity;
import password.pwm.config.Configuration;
import password.pwm.config.PwmSetting;
import password.pwm.config.option.MessageSendMethod;
import password.pwm.error.PwmError;
import password.pwm.error.PwmOperationalException;
import password.pwm.error.PwmUnrecoverableException;
import password.pwm.http.PwmRequest;
import password.pwm.ldap.UserInfo;
import password.pwm.util.java.JavaHelper;
import password.pwm.util.java.JsonUtil;
import password.pwm.util.java.TimeDuration;
import password.pwm.util.logging.PwmLogger;
import password.pwm.util.macro.MacroMachine;
import password.pwm.ws.client.rest.RestTokenDataClient;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

public class TokenUtil
{
    private static final PwmLogger LOGGER = PwmLogger.forClass( TokenUtil.class );

    private TokenUtil()
    {
    }


    public static List<TokenDestinationItem> figureAvailableTokenDestinations(
            final PwmApplication pwmApplication,
            final SessionLabel sessionLabel,
            final Locale locale,
            final UserInfo userInfo,
            final MessageSendMethod tokenSendMethod
    )
            throws PwmUnrecoverableException
    {
        if ( tokenSendMethod == null || tokenSendMethod.equals( MessageSendMethod.NONE ) )
        {
            throw PwmUnrecoverableException.newException( PwmError.ERROR_TOKEN_MISSING_CONTACT, "no token send methods configured in profile" );
        }

        List<TokenDestinationItem> tokenDestinations = new ArrayList<>( TokenDestinationItem.allFromConfig( pwmApplication, userInfo ) );

        if ( tokenSendMethod != MessageSendMethod.CHOICE_SMS_EMAIL )
        {
            tokenDestinations = tokenDestinations
                    .stream()
                    .filter( tokenDestinationItem -> tokenSendMethod == tokenDestinationItem.getType().getMessageSendMethod() )
                    .collect( Collectors.toList() );
        }

        final List<TokenDestinationItem> effectiveItems = new ArrayList<>(  );
        for ( final TokenDestinationItem item : tokenDestinations )
        {
            final TokenDestinationItem effectiveItem = invokeExternalTokenDestRestClient( pwmApplication, sessionLabel, locale, userInfo.getUserIdentity(), item );
            effectiveItems.add( effectiveItem );
        }

        LOGGER.trace( sessionLabel, "calculated available token send destinations: " + JsonUtil.serializeCollection( effectiveItems ) );

        if ( tokenDestinations.isEmpty() )
        {
            final String msg = "no available contact methods of type " + tokenSendMethod.name() + " available";
            throw PwmUnrecoverableException.newException( PwmError.ERROR_TOKEN_MISSING_CONTACT, msg );
        }

        return Collections.unmodifiableList( effectiveItems );
    }

    private static TokenDestinationItem invokeExternalTokenDestRestClient(
            final PwmApplication pwmApplication,
            final SessionLabel sessionLabel,
            final Locale locale,
            final UserIdentity userIdentity,
            final TokenDestinationItem tokenDestinationItem
    )
            throws PwmUnrecoverableException
    {
        final RestTokenDataClient.TokenDestinationData inputDestinationData = new RestTokenDataClient.TokenDestinationData(
                tokenDestinationItem.getType() == TokenDestinationItem.Type.email ? tokenDestinationItem.getValue() : null,
                tokenDestinationItem.getType() == TokenDestinationItem.Type.sms ? tokenDestinationItem.getValue() : null,
                tokenDestinationItem.getDisplay()
        );

        final RestTokenDataClient restTokenDataClient = new RestTokenDataClient( pwmApplication );
        final RestTokenDataClient.TokenDestinationData outputDestrestTokenDataClient = restTokenDataClient.figureDestTokenDisplayString(
                sessionLabel,
                inputDestinationData,
                userIdentity,
                locale );

        final String outputValue = tokenDestinationItem.getType() == TokenDestinationItem.Type.email
                ? outputDestrestTokenDataClient.getEmail()
                : outputDestrestTokenDataClient.getSms();

        return TokenDestinationItem.builder()
                .type( tokenDestinationItem.getType() )
                .display( outputDestrestTokenDataClient.getDisplayValue() )
                .value( outputValue )
                .id( tokenDestinationItem.getId() )
                .build();
    }


    public static void initializeAndSendToken(
            final PwmRequest pwmRequest,
            final UserInfo userInfo,
            final TokenDestinationItem tokenDestinationItem,
            final PwmSetting emailToSend,
            final TokenType tokenType,
            final PwmSetting smsToSend

    )
            throws PwmUnrecoverableException
    {
        final Configuration config = pwmRequest.getConfig();
        final UserIdentity userIdentity = userInfo.getUserIdentity();
        final Map<String, String> tokenMapData = new LinkedHashMap<>();

        {
            final Instant userLastPasswordChange = userInfo.getPasswordLastModifiedTime();
            if ( userLastPasswordChange != null )
            {
                final String userChangeString = JavaHelper.toIsoDate( userLastPasswordChange );
                tokenMapData.put( PwmConstants.TOKEN_KEY_PWD_CHG_DATE, userChangeString );
            }
        }

        final EmailItemBean emailItemBean = config.readSettingAsEmail( emailToSend, pwmRequest.getLocale() );
        final MacroMachine.StringReplacer stringReplacer = ( matchedMacro, newValue ) ->
        {
            if ( "@User:Email@".equals( matchedMacro )  )
            {
                return tokenDestinationItem.getValue();
            }

            return newValue;
        };
        final MacroMachine macroMachine = MacroMachine.forUser( pwmRequest, userIdentity, stringReplacer );

        final String tokenKey;
        final TokenPayload tokenPayload;
        try
        {
            tokenPayload = pwmRequest.getPwmApplication().getTokenService().createTokenPayload(
                    tokenType,
                    new TimeDuration( config.readSettingAsLong( PwmSetting.TOKEN_LIFETIME ), TimeUnit.SECONDS ),
                    tokenMapData,
                    userIdentity,
                    Collections.singleton( tokenDestinationItem.getValue() )
            );
            tokenKey = pwmRequest.getPwmApplication().getTokenService().generateNewToken( tokenPayload, pwmRequest.getSessionLabel() );
        }
        catch ( PwmOperationalException e )
        {
            throw new PwmUnrecoverableException( e.getErrorInformation() );
        }

        final String smsMessage = config.readSettingAsLocalizedString( smsToSend, pwmRequest.getLocale() );

        TokenService.TokenSender.sendToken(
                TokenService.TokenSendInfo.builder()
                        .pwmApplication( pwmRequest.getPwmApplication() )
                        .userInfo( userInfo )
                        .macroMachine( macroMachine )
                        .configuredEmailSetting( emailItemBean )
                        .tokenSendMethod( tokenDestinationItem.getType().getMessageSendMethod() )
                        .emailAddress( tokenDestinationItem.getValue() )
                        .smsNumber( tokenDestinationItem.getValue() )
                        .smsMessage( smsMessage )
                        .tokenKey( tokenKey )
                        .sessionLabel( pwmRequest.getSessionLabel() )
                        .build()
        );
    }

}
