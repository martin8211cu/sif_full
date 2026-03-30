<cfsetting enablecfoutputonly="yes">
<cfcontent type="text/xml">
<cfif Not IsDefined('form.included')>
	<cfheader name="Content-Disposition" value="attachment;filename=importador.definition">
</cfif>
<cfparam name="form.RHRPTNid" default="">
<cfif isdefined('form.chk')><cfset form.RHRPTNid =  form.chk></cfif>
<cfif Len(form.RHRPTNid) EQ 0><cflocation url="ReportesDinamicos-lista.cfm"></cfif>
<cfoutput><?xml version="1.0" encoding="ISO-8859-1"?>
<export filtro="#form.RHRPTNid#">
</cfoutput>

<cfquery datasource="minisif" name="enc">
	select RHRPTNid  ,RHRPTNcodigo, RHRPTNdescripcion, RHRPTNlineas,BMUsucodigo, fechaalta
	from RHReportesNomina
	where RHRPTNid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.RHRPTNid#">)
</cfquery>
<cfquery datasource="minisif" name="det">
	select RHCRPTid, RHRPTNid, RHCRPTcodigo, RHCRPTdescripcion, RHRPTNcolumna, BMUsucodigo, fechaalta
	from RHColumnasReporte
	where RHRPTNid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.RHRPTNid#">)
</cfquery>
<cfoutput>
	<enc><cfwddx action="cfml2wddx" input="#enc#" output="wddxvar">#XMLFormat(wddxvar)#</enc>
	<det><cfwddx action="cfml2wddx" input="#det#" output="wddxvar">#XMLFormat(wddxvar)#</det>
</cfoutput>
<cfoutput>
</export>
</cfoutput>
