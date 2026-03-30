<cfinclude template="/sif/Basura/Application.cfm">
<cfsetting requesttimeout="99999">
<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
<cfset res = setLocale("English (Canadian)")>
<cfheader name = "Expires" value = "0">
<cfparam name="Session.Idioma" default="ES_CR">

<cfinclude template="/home/check/dominio.cfm">
<cfinclude template="/home/check/autentica.cfm">
