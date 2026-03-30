<cfif isdefined("Url.RHAlinea") and Len(Trim(Url.RHAlinea))>
	<cfparam name="Form.RHAlinea" default="#Url.RHAlinea#">
</cfif>

<html>
<head>
<title><cf_translate key="LB_Vacaciones">Vacaciones</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="/cfmx/sif/css/web_portlet.css" type="text/css" rel="stylesheet">
</head>

<body>
	
	<cfquery name="rsAccionCese" datasource="#Session.DSN#">
		select *
		from RHAcciones
		where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAlinea#">
	</cfquery>
	<cfset Form.DEid = rsAccionCese.DEid>

	<cfinclude template="/rh/expediente/catalogos/vacaciones.cfm">
</body>
</html>
