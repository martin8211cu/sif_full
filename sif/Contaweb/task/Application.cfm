<cfsetting enablecfoutputonly="yes">
	<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="no"
	setclientcookies="no"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
<cfheader name="Expires" value="0">
<cfset session.dsn      		= "minisif">
<cfset session.Ecodigo      	= "1">
<cfset session.USUARIO      	= "1">
<cfset session.USUCODIGO      	= "1">
<cfset session.SITIO.IP      	= "1">
