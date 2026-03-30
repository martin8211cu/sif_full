<cfquery name="rsConocimiento" datasource="#Session.DSN#">
	select RHCid, RHCcodigo, RHCdescripcion
	from RHConocimientos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and upper(RHCcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.codigo))#">
	<cfif isdefined("url.inactivos") and Len(Trim(url.inactivos)) NEQ 0 and url.inactivos eq 1>
		and coalesce(RHCinactivo,0) = 0
	</cfif>
</cfquery>
<script language="JavaScript" type="text/javascript">
	parent.ctlid.value = "<cfoutput>#rsConocimiento.RHCid#</cfoutput>";
	parent.ctlcod.value = "<cfoutput>#rsConocimiento.RHCcodigo#</cfoutput>";
	parent.ctldesc.value = "<cfoutput>#rsConocimiento.RHCdescripcion#</cfoutput>";
</script>