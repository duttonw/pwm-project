<%--
  ~ Password Management Servlets (PWM)
  ~ http://code.google.com/p/pwm/
  ~
  ~ Copyright (c) 2006-2009 Novell, Inc.
  ~ Copyright (c) 2009-2015 The PWM Project
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
<%--  This file is imported by most JSPs, it shows the main 'header' in the html --%>
<%@ page import="password.pwm.http.tag.PwmValue" %>
<%@ page import="password.pwm.http.JspUtility" %>
<%@ page import="password.pwm.http.PwmRequestFlag" %>
<%@ taglib uri="pwm" prefix="pwm" %>

<% if (!JspUtility.isFlag(request, PwmRequestFlag.HIDE_HEADER_WARNINGS)) { %><%@ include file="header-warnings.jsp" %><% } %>
<div id="header">
    <div id="header-company-logo">
    </div>
    <div id="header-balance-div">
        <br/><%-- balance div for ie 6 --%>
    </div>
    <div id="header-right-logo" style="position: absolute">
    </div>
    <div id="header-center">
        <div id="header-center-left">
            <div id="header-page"><pwm:display key="${param['pwm.PageName']}" displayIfMissing="true"/></div>
            <div id="header-title"><pwm:display key="Title_Application"/></div>
        </div>

        <div id="header-center-right">
            <div id="header-menu-wrapper">
                <pwm:if test="<%=PwmIfTest.headerMenuIsVisible%>">
                    <pwm:if test="<%=PwmIfTest.healthWarningsPresent%>">
                        <div id="header-menu-alert"></div>
                    </pwm:if>
                    <pwm:if test="<%=PwmIfTest.usernameHasValue%>">
                        <div id="header-username"><pwm:value name="<%=PwmValue.username%>"/></div>
                        <div id="header-username-caret"></div>
                    </pwm:if>
                    <pwm:if test="<%=PwmIfTest.usernameHasValue%>" negate="true">
                        <div id="header-menu-icon"></div>
                    </pwm:if>
                </pwm:if>

                <pwm:if test="<%=PwmIfTest.headerMenuIsVisible%>" negate="true">
                    <pwm:if test="<%=PwmIfTest.usernameHasValue%>">
                        <div id="header-username"><pwm:value name="<%=PwmValue.username%>"/></div>
                    </pwm:if>
                </pwm:if>
            </div>

            <% if (!JspUtility.isFlag(request, PwmRequestFlag.HIDE_HEADER_BUTTONS)) { %>
            <pwm:if test="<%=PwmIfTest.forcedPageView%>" negate="true">
                <pwm:if test="<%=PwmIfTest.authenticated%>">
                    <pwm:if test="<%=PwmIfTest.showHome%>">
                        <a class="header-button" href="<pwm:value name="<%=PwmValue.homeURL%>"/>" id="HomeButton">
                            <pwm:if test="<%=PwmIfTest.showIcons%>"><span class="btn-icon pwm-icon pwm-icon-home"></span></pwm:if>
                            <pwm:display key="Button_Home"/>
                        </a>
                    </pwm:if>
                    <pwm:if test="<%=PwmIfTest.showLogout%>">
                        <a class="header-button" href="<pwm:url url='<%=PwmServletDefinition.Logout.servletUrl()%>' addContext="true"/>" id="LogoutButton">
                            <pwm:if test="<%=PwmIfTest.showIcons%>"><span class="btn-icon pwm-icon pwm-icon-sign-out"></span></pwm:if>
                            <pwm:display key="Button_Logout"/>
                        </a>
                    </pwm:if>
                </pwm:if>
            </pwm:if>
            <% } %>
        </div>
    </div>
</div>