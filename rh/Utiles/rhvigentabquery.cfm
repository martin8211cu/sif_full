<cfquery name="rsVigencia" datasource="#Session.DSN#">
	select RHVTid, RHVTcodigo
	from RHVigenciasTabla
	where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.tipo#">
	and RHVTcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.codigo#">
	and RHVTestado = 'A'
</cfquery>
<script language="JavaScript" type="text/javascript">
	parent.ctlid.value = "<cfoutput>#rsVigencia.RHVTid#</cfoutput>";
	parent.ctlcod.value = "<cfoutput>#rsVigencia.RHVTcodigo#</cfoutput>";
</script> 