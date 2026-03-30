<cftry> 
	<cfapplication name="SIF_ASP" 
		sessionmanagement="Yes"
		clientmanagement="No"
		setclientcookies="Yes"
		sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
		
	<cfsetting 	enablecfoutputonly="yes" 
				requesttimeout="36000">
	<cfset res = setLocale("English (Canadian)")>
	<cfheader name = "Expires" value = "0">
	<cfparam name="Session.Idioma" default="ES_CR">
	
	<cfset GvarMSG = "OK">

	<cfset session.Interfaz.UID 	= "">
	<cfset session.Interfaz.PWD 	= "">
<cfcatch type="any">
	<cfset session.Interfaz.UID 	= "">
	<cfset session.Interfaz.PWD 	= "">
</cfcatch>
</cftry>
