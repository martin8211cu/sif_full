<html>
	<head>
		<title>Reporte de Saldos de Consolidados de &Oacute;rdenes de Compra</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<cf_templatecss>
	</head>
	<body>
		<!--- Carga los parámetros que vienen por url --->
		<cfif isdefined("url.ECOCid") and not isdefined("form.ECOCid")>
			<cfset form.ECOCid = url.ECOCid>
		</cfif>
		<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
			<cfset form.SNcodigo = url.SNcodigo>
		</cfif>
		<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo")>
			<cfset form.Mcodigo = url.Mcodigo>
		</cfif>
		<cfif isdefined("url.TipoReporte") and not isdefined("form.TipoReporte")>
			<cfset form.TipoReporte = url.TipoReporte>
		</cfif>
		
		<!--- Crea los parámetros que se le van a enviar al tag de impresión --->
		<cfset parametros = "&imprime=1">
		<cfif isdefined("form.ECOCid") and len(trim(form.ECOCid)) gt 0>
			<cfset parametros = parametros & "&ECOCid=" & form.ECOCid>
		</cfif>
		<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo)) gt 0>
			<cfset parametros = parametros & "&SNcodigo=" & form.SNcodigo>
		</cfif>
		<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo)) gt 0>
			<cfset parametros = parametros & "&Mcodigo=" & form.Mcodigo>
		</cfif>
	
		<!--- Muestra el reporte de acuerdo al tipo --->
		<cfif form.TipoReporte eq 'R'>
			<cf_rhimprime datos="/sif/cm/consultas/ConsolidadoOCs-represum.cfm" paramsuri="#parametros#">
			<cfinclude template="ConsolidadoOCs-represum.cfm">
		<cfelseif form.TipoReporte eq 'D'>
			<cf_rhimprime datos="/sif/cm/consultas/ConsolidadoOCs-repdet.cfm" paramsuri="#parametros#">
			<cfinclude template="ConsolidadoOCs-repdet.cfm">
		</cfif>
		
		<form name="formCerrar">
			<cf_botones values="Cerrar" functions="window.close();">
		</form>
	</body>
</html>
