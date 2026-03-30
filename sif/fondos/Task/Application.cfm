<cfsetting enablecfoutputonly="yes">
	<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
<cfheader name="Expires" value="0">

<cfoutput>

	<cfset session.dsn = "FONDOSWEB6">
	<cfset session.Fondos.dsn = "FONDOSWEB6">

</cfoutput>	
