<cfsetting enablecfoutputonly="yes">
<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
<cfset res = setLocale("English (Canadian)")>
<cfheader name = "Expires" value = "0">
<cfparam name="Session.Idioma" default="ES_CR">

<cfinclude template="/home/check/dominio.cfm">
<!---<cfinclude template="/home/check/autentica.cfm">
<cfinclude template="/home/check/acceso.cfm">
<cfinclude template="/home/check/aspmonitor.cfm">--->
<cfinclude template="/home/check/bienvenido.cfm">

<cfparam name="Session.Preferences.Skin" default="ocean">
<cfparam name="Session.Preferences.SkinMenu" default="ocean">
<!--- --->
<cfif NOT IsDefined("Session.Debug") OR Session.Debug neq true>
<cferror type="exception" template="/home/public/error/handler.cfm">
<cferror type="validation" template="/home/public/error/handler.cfm">
<cferror type="request" template="/home/public/error/handler.cfm">
</cfif>
<cfsetting enablecfoutputonly="no">