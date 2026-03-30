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


	<cflogin>
		<cfif isDefined("cflogin")>
			<cfset session.Interfaz.UID 	= cflogin.name>
			<cfset session.Interfaz.PWD 	= cflogin.password>
		<cfelseif not isdefined("url.WSDL")>
		    <cfheader 	statuscode="401" statustext="Access Denied" /> 
		    <cfheader 	name="WWW-Authenticate" 
				        value="Basic realm=""MyApplication""" />
		</cfif>
	</cflogin>
<cfcatch type="any">
	<cfset session.Interfaz.UID 	= "">
	<cfset session.Interfaz.PWD 	= "">
</cfcatch>
</cftry>
