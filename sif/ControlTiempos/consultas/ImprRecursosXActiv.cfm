<html>
<head>
<title>Reporte de horas invertidas por recurso</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
	<cfif isdefined("Url.CTAcodigo") and not isdefined("Form.CTAcodigo")>
		<cfparam name="Form.CTAcodigo" default="#Url.CTAcodigo#">
	</cfif> 
	<cfif isdefined("Url.CTPcodigo") and not isdefined("Form.CTPcodigo")>
		<cfparam name="Form.CTPcodigo" default="#Url.CTPcodigo#">
	</cfif> 
	<cfif isdefined("Url.fecDesde") and not isdefined("Form.fecDesde")>
		<cfparam name="Form.fecDesde" default="#Url.fecDesde#">
	</cfif> 
	<cfif isdefined("Url.fecHasta") and not isdefined("Form.fecHasta")>
		<cfparam name="Form.fecHasta" default="#Url.fecHasta#">
	</cfif>
	<cfif isdefined("Url.Empresa") and not isdefined("Form.Empresa")>
		<cfparam name="Form.Empresa" default="#Url.Empresa#">
	</cfif>		
	<cfinclude template="formRecursosXActiv.cfm">
</body>
</html>
