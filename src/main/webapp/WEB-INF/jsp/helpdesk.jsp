<%@ page import="password.pwm.http.JspUtility" %>
<%--
  ~ Password Management Servlets (PWM)
  ~ http://www.pwm-project.org
  ~
  ~ Copyright (c) 2006-2009 Novell, Inc.
  ~ Copyright (c) 2009-2016 The PWM Project
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

<!DOCTYPE html>
<%@ page language="java" session="true" isThreadSafe="true" contentType="text/html" %>
<%@ taglib uri="pwm" prefix="pwm" %>
<html lang="<pwm:value name="<%=PwmValue.localeCode%>"/>" dir="<pwm:value name="<%=PwmValue.localeDir%>"/>">
<%@ include file="/WEB-INF/jsp/fragment/header.jsp" %>
<body class="nihilo">
<div id="wrapper">
    <jsp:include page="/WEB-INF/jsp/fragment/header-body.jsp">
        <jsp:param name="pwm.PageName" value="Title_Helpdesk"/>
    </jsp:include>
    <div id="centerbody" class="wide tall">
        <div id="panel-searchbar" class="searchbar">
            <table class="noborder" style="margin-left: auto; margin-right: auto; width:100px; table-layout: fixed" >
                <tr>
                    <td style="width:15px">
                        <span class="pwm-icon pwm-icon-search"></span>
                    </td>
                    <td style="width:400px">
                        <input placeholder="<pwm:display key="Placeholder_Search"/>" type="search" id="username" name="username" class="helpdesk-input-username" style="width: 400px" <pwm:autofocus/> autocomplete="off"/>
                    </td>
                    <td style="width:20px">
                        <div id="searchIndicator" style="display:none">
                            <span class="pwm-icon pwm-icon-lg pwm-icon-spin pwm-icon-spinner"></span>
                        </div>
                        <div id="maxResultsIndicator" style="display:none">
                            <span style="color: #ffcd59;" class="pwm-icon pwm-icon-lg pwm-icon-exclamation-circle"></span>
                        </div>
                    </td>
                    <% if ((Boolean)JspUtility.getPwmRequest(pageContext).getAttribute(PwmRequest.Attribute.HelpdeskVerificationEnabled) == true) { %>
                    <td style="width: 45px">
                        <button class="btn" id="button-show-current-verifications">Verifications</button>
                    </td>
                    <% } %>
                </tr>
            </table>
            <noscript>
                <span><pwm:display key="Display_JavascriptRequired"/></span>
                <a href="<pwm:context/>"><pwm:display key="Title_MainPage"/></a>
            </noscript>
            <br/>
        </div>
        <div id="helpdesk-searchResultsGrid" class="grid tall">
        </div>
    </div>
    <div class="push"></div>
</div>
<jsp:include page="/WEB-INF/jsp/fragment/footer.jsp"/>
<pwm:script-ref url="/public/resources/js/helpdesk.js"/>
</body>
</html>
