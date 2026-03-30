<!--- <cfinclude template="../Application.cfm"> --->

<cfsetting enablecfoutputonly="yes">

	<cfapplication name="SIF_ASP" 

	sessionmanagement="Yes"

	clientmanagement="Yes"

	setclientcookies="Yes"

	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>

<cfset res = setLocale("English (Canadian)")>

<cfheader name = "Expires" value = "0">

<cfparam name="Session.Idioma" default="ES_CR">

<cfinclude template="../Utiles/SIFfunciones.cfm">

<cfparam name="Session.Preferences.Skin" default="ocean">

<cfparam name="Session.Preferences.SkinMenu" default="ocean">

<cfsetting enablecfoutputonly="no">



	<cfset session.usuario 			= "guest">

	<cfset session.dsn      		= "FONDOSWEB6">

	<cfset session.Conta.dsn 		= "FONDOSWEB6">

<!---

	<cfset session.dsn      		= "sifweb">

	<cfset session.Conta.dsn 		= "sifweb">

--->
