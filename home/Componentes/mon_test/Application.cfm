<cfsetting enablecfoutputonly="yes">
<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="No"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
<cfset res = setLocale("English (Canadian)")>
<cfheader name="Expires" value="0">
<cfheader name="Cache-control" value="no-cache">
<cfparam name="Session.Idioma" default="es_CR">

<cfif CGI.SCRIPT_NAME NEQ '/cfmx/home/Componentes/mon_test/index.cfm'>
<cfinclude template="/home/check/aspmonitor.cfm">
<cfinclude template="/home/check/dominio.cfm">
<cfinclude template="/home/check/autentica.cfm">
</cfif>
<cfsetting enablecfoutputonly="no">