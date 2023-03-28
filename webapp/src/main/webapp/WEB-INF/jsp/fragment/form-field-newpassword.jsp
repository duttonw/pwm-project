<%--
 ~ Password Management Servlets (PWM)
 ~ http://www.pwm-project.org
 ~
 ~ Copyright (c) 2006-2009 Novell, Inc.
 ~ Copyright (c) 2009-2021 The PWM Project
 ~
 ~ Licensed under the Apache License, Version 2.0 (the "License");
 ~ you may not use this file except in compliance with the License.
 ~ You may obtain a copy of the License at
 ~
 ~     http://www.apache.org/licenses/LICENSE-2.0
 ~
 ~ Unless required by applicable law or agreed to in writing, software
 ~ distributed under the License is distributed on an "AS IS" BASIS,
 ~ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 ~ See the License for the specific language governing permissions and
 ~ limitations under the License.
--%>
<%--
       THIS FILE IS NOT INTENDED FOR END USER MODIFICATION.
       See the README.TXT file in WEB-INF/jsp before making changes.
--%>

<%@ taglib uri="pwm" prefix="pwm" %>

<%@ page import="password.pwm.http.tag.conditional.PwmIfTest" %>
<%@ page import="password.pwm.http.tag.value.PwmValue" %>
<div class="formFieldWrapper" id="formFieldWrapper-password1">
    <div class="formFieldLabel">
        <label for="password1"><pwm:display key="Field_NewPassword"/></label>
        <div class="pwm-icon pwm-icon-question-circle pwm-icon-button nodisplay" id="password-guide-icon"></div>
        <pwm:if test="<%=PwmIfTest.showRandomPasswordGenerator%>">
            <div class="pwm-icon pwm-icon-retweet pwm-icon-button nodisplay" id="autogenerate-icon"></div>
        </pwm:if>
    </div>
    <input type="<pwm:value name="<%=PwmValue.passwordFieldType%>"/>" name="password1" id="password1"
           class="inputfield" <pwm:autofocus/> tabindex="<pwm:tabindex/>"/>
    <pwm:if test="<%=PwmIfTest.showStrengthMeter%>">
        <div id="strengthBox" class="noopacity">
            <div id="strengthLabel">
                <div class="pwm-icon pwm-icon-question-circle pwm-icon-button" id="strength-tooltip-icon"></div>
                <div id="strengthLabelText"><pwm:display key="Display_StrengthMeter"/></div>
            </div>
            <progress id="passwordStrengthProgress" max="100" value="0"></progress>
        </div>
    </pwm:if>
</div>
<div class="formFieldWrapper" id="formFieldWrapper-password2">
    <div class="formFieldLabel">
        <label for="password2"><pwm:display key="Field_ConfirmPassword"/></label>
    </div>
    <input type="<pwm:value name="<%=PwmValue.passwordFieldType%>"/>" name="password2" id="password2"
           class="inputfield" tabindex="<pwm:tabindex/>"/>
    <%-- confirmation mark [not shown initially, enabled by javascript; see also changepassword.js:markConfirmationMark() --%>
    <div id="confirmMarkBox">
        <div class="confirmCheckMark nodisplay" id="confirmCheckMark"></div>
        <div class="confirmCrossMark nodisplay" id="confirmCrossMark"
             title="<pwm:display key="Password_DoesNotMatch" bundle="Error"/>"
             alt="<pwm:display key="Password_DoesNotMatch" bundle="Error"/>"></div>
    </div>
</div>
