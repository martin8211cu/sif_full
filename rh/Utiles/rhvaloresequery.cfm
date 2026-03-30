<cfquery name="rsValores" datasource="#Session.DSN#">
	select RHECGid, RHECGcodigo, RHECGdescripcion
	from RHECatalogosGenerales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and upper(RHECGcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.codigo))#">
</cfquery>
<script language="JavaScript" type="text/javascript">
	parent.ctlid.value = "<cfoutput>#rsValores.RHECGid#</cfoutput>";
	parent.ctlcod.value = "<cfoutput>#rsValores.RHECGcodigo#</cfoutput>";
	parent.ctldesc.value = "<cfoutput>#rsValores.RHECGdescripcion#</cfoutput>";
	<cfif rsValores.RecordCount eq 0>
		if (parent.ctlidd) parent.ctlidd.value = "";
		if (parent.ctlcodd) parent.ctlcodd.value = "";
		if (parent.ctldescd) parent.ctldescd.value = "";
	</cfif>
</script>