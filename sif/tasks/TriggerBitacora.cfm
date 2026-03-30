<cfsetting enablecfoutputonly="yes">
	<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>

<cfset StructClear(url)>

<cfinclude template="/asp/admin/bitacora/operacion/trigger/regenerar.cfm">
