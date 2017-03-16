<%--
  ~ Password Management Servlets (PWM)
  ~ http://www.pwm-project.org
  ~
  ~ Copyright (c) 2006-2009 Novell, Inc.
  ~ Copyright (c) 2009-2017 The PWM Project
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or
  ~ (at your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful,
  ~ but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ~ GNU General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  --%>

<%@ page import="com.novell.ldapchai.cr.Challenge" %>
<%@ page import="password.pwm.Permission" %>
<%@ page import="password.pwm.bean.ResponseInfoBean" %>
<%@ page import="password.pwm.bean.UserInfoBean" %>
<%@ page import="password.pwm.config.profile.ChallengeProfile" %>
<%@ page import="password.pwm.config.profile.ProfileType" %>
<%@ page import="password.pwm.config.profile.PwmPasswordPolicy" %>
<%@ page import="password.pwm.config.profile.PwmPasswordRule" %>
<%@ page import="password.pwm.http.servlet.admin.UserDebugDataBean" %>
<%@ page import="java.util.Map" %>
<% final PwmRequest debug_pwmRequest = JspUtility.getPwmRequest(pageContext); %>
<!DOCTYPE html>
<%@ page language="java" session="true" isThreadSafe="true" contentType="text/html" %>
<%@ taglib uri="pwm" prefix="pwm" %>
<html lang="<pwm:value name="<%=PwmValue.localeCode%>"/>" dir="<pwm:value name="<%=PwmValue.localeDir%>"/>">
<%@ include file="/WEB-INF/jsp/fragment/header.jsp" %>
<body class="nihilo">
<div id="wrapper">
    <jsp:include page="/WEB-INF/jsp/fragment/header-body.jsp">
        <jsp:param name="pwm.PageName" value="User Debug"/>
    </jsp:include>
    <div id="centerbody" class="wide">
        <div id="page-content-title">User Debug</div>
        <%@ include file="fragment/admin-nav.jsp" %>

        <% final UserDebugDataBean userDebugDataBean = (UserDebugDataBean)JspUtility.getAttribute(pageContext, PwmRequest.Attribute.UserDebugData); %>
        <% if (userDebugDataBean == null) { %>
        <%@ include file="/WEB-INF/jsp/fragment/message.jsp" %>
        <div id="panel-searchbar" class="searchbar">
            <form method="post" class="pwm-form">
                <input id="username" name="username" placeholder="<pwm:display key="Placeholder_Search"/>" title="<pwm:display key="Placeholder_Search"/>" class="helpdesk-input-username" <pwm:autofocus/> autocomplete="off"/>
                <input type="hidden" id="pwmFormID" name="pwmFormID" value="<pwm:FormID/>"/>
                <button type="submit" class="btn"><pwm:display key="Button_Search"/></button>
            </form>
        </div>

        <% } else { %>
        <div class="buttonbar">
            <form method="get" class="pwm-form">
                <button type="submit" class="btn"><pwm:display key="Button_Continue"/></button>
            </form>
        </div>
        <% final UserInfoBean userInfoBean = userDebugDataBean.getUserInfoBean(); %>
        <% if (userInfoBean != null) { %>
        <table>
            <tr>
                <td colspan="10" class="title">Identity</td>
            </tr>
            <tr>
                <td class="key">UserDN</td>
                <td><%=JspUtility.freindlyWrite(pageContext, userInfoBean.getUserIdentity().getUserDN())%></td>
            </tr>
            <tr>
                <td class="key">Ldap Profile</td>
                <td><%=JspUtility.freindlyWrite(pageContext, userInfoBean.getUserIdentity().getLdapProfileID())%></td>
            </tr>
            <tr>
                <td class="key">Username</td>
                <td><%=JspUtility.freindlyWrite(pageContext, userInfoBean.getUsername())%></td>
            </tr>
            <tr>
                <td class="key"><%=PwmConstants.PWM_APP_NAME%> GUID</td>
                <td><%=JspUtility.freindlyWrite(pageContext, userInfoBean.getUserGuid())%></td>
            </tr>
        </table>
        <br/>
        <table>
            <tr>
                <td colspan="10" class="title">Status</td>
            </tr>
            <tr>
                <td class="key">Last Login Time</td>
                <td><%=JspUtility.freindlyWrite(pageContext, userInfoBean.getLastLdapLoginTime())%></td>
            </tr>
            <tr>
                <td class="key">Account Expiration Time</td>
                <td><%=JspUtility.freindlyWrite(pageContext, userInfoBean.getAccountExpirationTime())%></td>
            </tr>
            <tr>
                <td class="key">Password Expiration</td>
                <td><%=JspUtility.freindlyWrite(pageContext, userInfoBean.getPasswordExpirationTime())%></td>
            </tr>
            <tr>
                <td class="key">Password Last Modified</td>
                <td><%=JspUtility.freindlyWrite(pageContext, userInfoBean.getPasswordLastModifiedTime())%></td>
            </tr>
            <tr>
                <td class="key">Email Address</td>
                <td><%=JspUtility.freindlyWrite(pageContext, userInfoBean.getUserEmailAddress())%></td>
            </tr>
            <tr>
                <td class="key">Phone Number</td>
                <td><%=JspUtility.freindlyWrite(pageContext, userInfoBean.getUserSmsNumber())%></td>
            </tr>
            <tr>
                <td class="key">Username</td>
                <td><%=JspUtility.freindlyWrite(pageContext, userInfoBean.getUsername())%></td>
            </tr>
            <tr>
                <td class="key">
                    <pwm:display key="Field_PasswordExpired"/>
                </td>
                <td id="PasswordExpired">
                    <%= JspUtility.freindlyWrite(pageContext, userInfoBean.getPasswordState().isExpired()) %>
                </td>
            </tr>
            <tr>
                <td class="key">
                    <pwm:display key="Field_PasswordPreExpired"/>
                </td>
                <td id="PasswordPreExpired">
                    <%= JspUtility.freindlyWrite(pageContext, userInfoBean.getPasswordState().isPreExpired()) %>
                </td>
            </tr>
            <tr>
                <td class="key">
                    <pwm:display key="Field_PasswordWithinWarningPeriod"/>
                </td>
                <td id="PasswordWithinWarningPeriod">
                    <%= JspUtility.freindlyWrite(pageContext, userInfoBean.getPasswordState().isWarnPeriod()) %>
                </td>
            </tr>
            <tr>
                <td class="key">
                    <pwm:display key="Field_PasswordViolatesPolicy"/>
                </td>
                <td id="PasswordViolatesPolicy">
                    <%= JspUtility.freindlyWrite(pageContext, userInfoBean.getPasswordState().isViolatesPolicy()) %>
                </td>
            </tr>
            <tr>
                <td class="key">
                    Requires New Password
                </td>
                <td>
                    <%= JspUtility.freindlyWrite(pageContext, userInfoBean.isRequiresNewPassword()) %>
                </td>
            </tr>
            <tr>
                <td class="key">
                    Requires Response Setup
                </td>
                <td>
                    <%= JspUtility.freindlyWrite(pageContext, userInfoBean.isRequiresResponseConfig()) %>
                </td>
            </tr>
            <tr>
                <td class="key">
                    Requires OTP Setup
                </td>
                <td>
                    <%= JspUtility.freindlyWrite(pageContext, userInfoBean.isRequiresOtpConfig()) %>
                </td>
            </tr>
            <tr>
                <td class="key">
                    Requires Profile Update
                </td>
                <td>
                    <%= JspUtility.freindlyWrite(pageContext, userInfoBean.isRequiresUpdateProfile()) %>
                </td>
            </tr>
        </table>
        <br/>
        <table>
            <tr>
                <td colspan="10" class="title">Applied Configuration</td>
            </tr>
            <tr>
                <td class="key">Profiles</td>
                <td>
                    <table>
                        <tr>
                            <td class="key">Service</td>
                            <td class="key">ProfileID</td>
                        </tr>
                        <% for (final ProfileType profileType : userDebugDataBean.getProfiles().keySet()) { %>
                        <tr>
                            <td><%=profileType%></td>
                            <td><%=JspUtility.freindlyWrite(pageContext, userDebugDataBean.getProfiles().get(profileType))%></td>
                        </tr>
                        <% } %>
                    </table>
                </td>
            </tr>
            <tr>
                <td class="key">Permissions</td>
                <td>
                    <table>
                        <tr>
                            <td class="key">Permission</td>
                            <td class="key">Status</td>
                        </tr>
                        <% for (final Permission permission : userDebugDataBean.getPermissions().keySet()) { %>
                        <tr>
                            <td><%=permission%></td>
                            <td><%=JspUtility.freindlyWrite(pageContext, userDebugDataBean.getPermissions().get(permission))%></td>
                        </tr>
                        <% } %>
                    </table>
                </td>
            </tr>
        </table>
        <br/>
        <table>
            <tr>
                <td colspan="10" class="title">Password Policy</td>
            </tr>
            <% PwmPasswordPolicy userPolicy = userInfoBean.getPasswordPolicy(); %>
            <% if (userPolicy != null) { %>
            <% PwmPasswordPolicy configPolicy = userDebugDataBean.getConfiguredPasswordPolicy(); %>
            <% PwmPasswordPolicy ldapPolicy = userDebugDataBean.getLdapPasswordPolicy(); %>
            <tr>
                <td>Policy Name</td>
                <td><%=JspUtility.freindlyWrite(pageContext, userPolicy.getDisplayName(JspUtility.locale(request)))%></td>
            </tr>
            <tr>
                <td>Policy ID</td>
                <td><%=JspUtility.freindlyWrite(pageContext, userPolicy.getIdentifier())%></td>
            </tr>
            <tr>
                <td colspan="10">
                    <table>
                        <tr class="title">
                            <td class="key">Rule</td>
                            <td class="key">Rule Type</td>
                            <td class="key">Configured Policy</td>
                            <td class="key">LDAP Policy</td>
                            <td class="key">Effective Policy</td>
                        </tr>
                        <% for (final PwmPasswordRule rule : PwmPasswordRule.values()) { %>
                        <tr>
                            <td><span title="<%=rule.getKey()%>"><%=rule.getLabel(JspUtility.locale(request), JspUtility.getPwmRequest(pageContext).getConfig())%></span></td>
                            <td><%=rule.getRuleType()%></td>
                            <td><%=JspUtility.freindlyWrite(pageContext, configPolicy.getValue(rule))%></td>
                            <td><%=JspUtility.freindlyWrite(pageContext, ldapPolicy.getValue(rule))%></td>
                            <td><%=JspUtility.freindlyWrite(pageContext, userPolicy.getValue(rule))%></td>
                        </tr>
                        <% } %>
                    </table>
                </td>
            </tr>
            <% } %>
        </table>
        <br/>
        <table>
            <tr>
                <td colspan="10" class="title">Stored Responses</td>
            </tr>
            <% final ResponseInfoBean responseInfoBean = userInfoBean.getResponseInfoBean(); %>
            <% if (responseInfoBean == null) { %>
            <tr>
                <td>Stored Responses</td>
                <td><pwm:display key="Display_NotApplicable"/></td>
            </tr>
            <% } else { %>
            <tr>
                <td>Identifier</td>
                <td><%=responseInfoBean.getCsIdentifier()%></td>
            </tr>
            <tr>
                <td>Storage Type</td>
                <td><%=responseInfoBean.getDataStorageMethod()%></td>
            </tr>
            <tr>
                <td>Format</td>
                <td><%=responseInfoBean.getFormatType()%></td>
            </tr>
            <tr>
                <td>Locale</td>
                <td><%=responseInfoBean.getLocale()%></td>
            </tr>
            <tr>
                <td>Storage Timestamp</td>
                <td><%=JspUtility.freindlyWrite(pageContext, responseInfoBean.getTimestamp())%></td>
            </tr>
            <tr>
                <td>Challenges</td>
                <% final Map<Challenge,String> crMap = responseInfoBean.getCrMap(); %>
                <% if (crMap == null) { %>
                <td>
                    n/a
                </td>
                <% } else { %>
                <td>
                    <table>
                        <tr>
                            <td class="key">Type</td>
                            <td class="key">Required</td>
                            <td class="key">Text</td>
                        </tr>
                        <% for (final Challenge challenge : crMap.keySet()) { %>
                        <tr>
                            <td>
                                <%= challenge.isAdminDefined() ? "Admin Defined" : "User Defined" %>
                            </td>
                            <td>
                                <%= JspUtility.freindlyWrite(pageContext, challenge.isRequired())%>
                            </td>
                            <td>
                                <%= JspUtility.freindlyWrite(pageContext, challenge.getChallengeText())%>
                            </td>
                        </tr>
                        <% } %>
                    </table>
                </td>
                <% } %>
            </tr>
            <tr>
                <td>
                    Minimum Randoms Required
                </td>
                <td>
                    <%=responseInfoBean.getMinRandoms()%>
                </td>
            </tr>
            <tr>
                <td>Helpdesk Challenges</td>
                <% final Map<Challenge,String> helpdeskCrMap = responseInfoBean.getHelpdeskCrMap(); %>
                <% if (helpdeskCrMap == null) { %>
                <td>
                <pwm:display key="Display_NotApplicable"/>
                </td>
                <% } else { %>
                <td>
                    <% for (final Challenge challenge : helpdeskCrMap.keySet()) { %>
                    <%= JspUtility.freindlyWrite(pageContext, challenge.getChallengeText())%><br/>
                    <% } %>
                </td>
                <% } %>
            </tr>
            <% } %>
        </table>
        <br/>
        <table>
            <tr>
                <td colspan="10" class="title">Challenge Profile</td>
            </tr>
            <% final ChallengeProfile challengeProfile = userInfoBean.getChallengeProfile(); %>
            <% if (challengeProfile == null) { %>
            <tr>
                <td>Assigned Profile</td>
                <td><pwm:display key="Display_NotApplicable"/></td>
            </tr>
            <% } else { %>
            <tr>
                <td>Display Name</td>
                <td><%=challengeProfile.getDisplayName(JspUtility.locale(request))%></td>
            </tr>
            <tr>
                <td>Identifier</td>
                <td><%=challengeProfile.getIdentifier()%></td>
            </tr>
            <tr>
                <td>Locale</td>
                <td><%=challengeProfile.getLocale()%></td>
            </tr>
            <tr>
                <td>Challenges</td>
                <td>
                    <table>
                        <tr>
                            <td class="key">Type</td>
                            <td class="key">Required</td>
                            <td class="key">Text</td>
                        </tr>
                        <% for (final Challenge challenge : challengeProfile.getChallengeSet().getChallenges()) { %>
                        <tr>
                            <td>
                                <%= challenge.isAdminDefined() ? "Admin Defined" : "User Defined" %>
                            </td>
                            <td>
                                <%= JspUtility.freindlyWrite(pageContext, challenge.isRequired())%>
                            </td>
                            <td>
                                <%= JspUtility.freindlyWrite(pageContext, challenge.getChallengeText())%>
                            </td>
                        </tr>
                        <% } %>
                    </table>
                </td>
            </tr>
            <% } %>
        </table>

        <% } %>
        <div class="buttonbar">
            <form method="get" class="pwm-form">
                <button type="submit" class="btn"><pwm:display key="Button_Continue"/></button>
            </form>
        </div>
        <% } %>
    </div>
    <div class="push"></div>
</div>
<jsp:include page="/WEB-INF/jsp/fragment/footer.jsp"/>
</body>
</html>
