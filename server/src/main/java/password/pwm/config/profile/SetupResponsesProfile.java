/*
 * Password Management Servlets (PWM)
 * http://www.pwm-project.org
 *
 * Copyright (c) 2006-2009 Novell, Inc.
 * Copyright (c) 2009-2021 The PWM Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package password.pwm.config.profile;

import password.pwm.bean.DomainID;
import password.pwm.config.stored.StoredConfiguration;

public class SetupResponsesProfile extends AbstractProfile
{
    private static final ProfileDefinition PROFILE_TYPE = ProfileDefinition.SetupOTPProfile;

    protected SetupResponsesProfile( final DomainID domainID, final String identifier, final StoredConfiguration storedConfiguration )
    {
        super( domainID, identifier, storedConfiguration );
    }

    @Override
    public ProfileDefinition profileType( )
    {
        return PROFILE_TYPE;
    }

    public static class SetupResponseProfileFactory implements ProfileFactory
    {
        @Override
        public Profile makeFromStoredConfiguration( final StoredConfiguration storedConfiguration, final DomainID domainID,  final String identifier )
        {
            return new SetupResponsesProfile( domainID, identifier, storedConfiguration );
        }
    }
}
