<cfsetting enablecfoutputonly="yes">
<cfcontent type="text/xml">
<cfif Not IsDefined('form.included')>
	<cfheader name="Content-Disposition" value="attachment;filename=importador.definition">
</cfif>
<cfparam name="form.eiid" default="">
<cfif Len(form.eiid) EQ 0><cflocation url="Exportar.cfm"></cfif>
<cfoutput><?xml version="1.0" encoding="ISO-8859-1"?>
<export filtro="#form.eiid#">
</cfoutput>

<cfquery datasource="sifcontrol" name="tiporeg">
	select count(DISTINCT(DItiporeg)) as Tipos from DImportador
    where EIid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.eiid#">)
</cfquery>


<cfquery datasource="sifcontrol" name="enc">
	select 
		EIid, EIcodigo, EImodulo, Ecodigo,
		EIdescripcion, EIdelimitador, EImod_login, EImod_fecha,
		EImod_usucodigo, EImod_ulocalizacion, EIusatemp, EItambuffer,
		EIparcial, EIverificaant, EIexporta, EIimporta, EIcfimporta, EIcfexporta,EIcfparam
	from EImportador
	where EIid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.eiid#">)
</cfquery>

<cfquery datasource="sifcontrol" name="det">
    select 
        EIid,
        <cfif tiporeg.Tipos gt 1>DItiporeg,</cfif> 
        DInumero, DInombre,
        DIdescripcion, DItipo, DIlongitud
    from DImportador
    where EIid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.eiid#">)
    order by DItiporeg, DInumero
</cfquery>


<!---
<cfquery datasource="sifcontrol" name="eis">
	select 
		EIid, EIsql, EIsqlexp
	from EISQL
	where EIid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.eiid#">)
</cfquery>
--->
<cfquery datasource="sifcontrol" name="eis0">
	select 
		EIid, EIsql, EIsqlexp
	from EISQL
	where EIid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#form.eiid#">)
</cfquery>
<cfset eis = QueryNew('EIid,EIsql,EIsqlexp')>
<cfloop query="eis0">
	<cfset QueryAddRow(eis)>
	<cfset QuerySetCell(eis,'EIid', eis0.EIid)>
	<cfset QuerySetCell(eis,'EIsql', eis0.EIsql)>
	<cfset QuerySetCell(eis,'EIsqlexp', eis0.EIsqlexp)>
</cfloop>

<cfoutput>
	<enc><cfwddx action="cfml2wddx" input="#enc#" output="wddxvar">#XMLFormat(wddxvar)#</enc>
	<det><cfwddx action="cfml2wddx" input="#det#" output="wddxvar">#XMLFormat(wddxvar)#</det>
	<eis><cfwddx action="cfml2wddx" input="#eis#" output="wddxvar">#XMLFormat(wddxvar)#</eis>
</cfoutput>
<cfoutput>
</export>
</cfoutput>
