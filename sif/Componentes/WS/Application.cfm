<cfsetting enablecfoutputonly="yes">
<cfapplication name="SIF_ASP" 
	sessionmanagement="No"
	clientmanagement="No"
	setclientcookies="No"
>

<cflogin>
	<cfset LvarAuthorized = false>

	<cfif isDefined("cflogin") AND isDefined("cflogin.name")>
		<cfset LvarWSsec = createobject("component","sif.Componentes.WS.WSsecurity")>
		<cfset LvarAuthorized = LvarWSsec.Authorized(cflogin.name)> 
	</cfif>
</cflogin>

<cfif not LvarAuthorized>
	<!--- If the user does not pass a username/password, return a 401 error. 
		The browser then prompts the user for a username/password. --->
	<cfheader statuscode="401">
	<cfheader name="WWW-Authenticate" value="Basic realm=""Test""">
	<cfabort>
</cfif>

