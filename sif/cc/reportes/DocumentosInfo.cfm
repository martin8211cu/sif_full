<!--- 
	form.Reporte:
		1 = Documentos sin Aplicar
		2 = Documentos Aplicados

	form.tipoResumen:
		1 = Resumido
		2 = Detallado
 --->

<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_DoctosSAplR 	= t.Translate('LB_DoctosSApl','Documentos sin Aplicar (Resumido)','DocumentosInfo.xml')>
<cfset LB_DoctosSAplD 	= t.Translate('LB_DoctosAplic','Documentos sin Aplicar  (Detallado)','DocumentosInfo.xml')>
<cfset LB_DoctosAplR 	= t.Translate('LB_DoctosSApl','Documentos Aplicados (Resumido)','DocumentosInfo.xml')>
<cfset LB_DoctosAplD 	= t.Translate('LB_DoctosAplic','Documentos Aplicados  (Detallado)','DocumentosInfo.xml')>

<cfif isdefined("url.Reporte") and len(trim(url.Reporte)) and not isdefined("form.Reporte")>
	<cfset form.Reporte = url.Reporte>
</cfif>
<cfif isdefined("url.tipoResumen") and len(trim(url.tipoResumen)) and not isdefined("form.tipoResumen")>
	<cfset form.tipoResumen = url.tipoResumen>
</cfif>


<cfset LvarNombreReporte = ''>

<cfif isdefined("url.Reporte") and url.reporte eq 1> 
	<!--- Sin Aplicar --->
	<cfif isdefined("url.tipoResumen") and url.tipoResumen eq 1>
		<cfset LvarNombreReporte = '#LB_DoctosSAplR#'>
		<cfinclude template="DocumentosSinAplicarRes.cfm">
	<cfelse>
		<cfset LvarNombreReporte = '#LB_DoctosSAplD#'>
		<cfinclude template="DocumentosSinAplicarDet.cfm">
	</cfif>
<cfelse>
	<!--- Aplicados --->
	 <cfif isdefined("url.tipoResumen") and url.tipoResumen eq 1>
		<cfset LvarNombreReporte = '#LB_DoctosAplR#'>
		<cfinclude template="DocumentosAplicadosRes.cfm">
	<cfelse>
		<cfset LvarNombreReporte = '#LB_DoctosAplD#'>
		<cfinclude template="DocumentosAplicadosDet.cfm">
	</cfif> 
</cfif>
