<!--- Expirar la sesión --->
<!---
Modificado por: Yu Hui Wen
Fecha: 10 de Marzo del 2003
Por favor NO CAMBIAR
--->
<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,0,0,0)#>
<cftry>
	<cflogout>
	<cfset StructDelete(Session,"Usucodigo")>
	<cfset StructClear(Session)>
	<cfcatch type="any"></cfcatch></cftry>
<cfapplication name="EDU"
	sessionmanagement="Yes"
	clientmanagement="Yes"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,0,0,0)#>
<cftry>
	<cflogout>
	<cfset StructDelete(Session,"Usucodigo")>
	<cfset StructClear(Session)>
	<cfcatch type="any"></cfcatch></cftry>
<cfparam name="url.uri" default="/cfmx/sif/index.cfm">
<cflocation url="#url.uri#">
