<cfquery name="rsValores" datasource="#Session.DSN#">
	select RHDCGid, RHDCGcodigo, RHDCGdescripcion
	from RHDCatalogosGenerales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and upper(RHDCGcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.codigo))#">
	and RHECGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.codigoe#">
</cfquery>
<script language="JavaScript" type="text/javascript">
	parent.ctlid.value = "<cfoutput>#rsValores.RHDCGid#</cfoutput>";
	parent.ctlcod.value = "<cfoutput>#rsValores.RHDCGcodigo#</cfoutput>";
	parent.ctldesc.value = "<cfoutput>#rsValores.RHDCGdescripcion#</cfoutput>";
</script>