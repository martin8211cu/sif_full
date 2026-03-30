<cfsetting enablecfoutputonly="yes">
	<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="no"
	setclientcookies="no"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
<cfheader name="Expires" value="0">
