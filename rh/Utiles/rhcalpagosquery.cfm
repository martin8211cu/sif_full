<cfif isdefined("url.CPcodigo") and Len(Trim(url.CPcodigo)) NEQ 0>
	<cfif url.historicos>
		<cfset RCalculoNomina = "HRCalculoNomina">
	<cfelse>
		<cfset RCalculoNomina = "RCalculoNomina">
	</cfif>
	<cfquery name="rsCalPago" datasource="#Session.DSN#">
		select a.CPid, a.CPcodigo, 	case when len(rtrim(ltrim(coalesce(CPdescripcion,RCDescripcion)))) = 0 then RCDescripcion else coalesce(CPdescripcion,RCDescripcion) end as CPdescripcion
		from CalendarioPagos a, #RCalculoNomina# b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.CPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(url.CPcodigo)#">
		and b.RCNid = a.CPid
		<cfif url.historicos>
			and a.CPfcalculo is not null
		</cfif>
		
		<cfif isdefined("url.vTcodigo") >
			and a.Tcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#url.vTcodigo#">
			and b.Tcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#url.vTcodigo#">
		</cfif>		
		<cfif isdefined('url.Excluir') and LEN(TRIM(url.Excluir))>
			and a.CPtipo not in (#url.Excluir#)
		</cfif>
	</cfquery>
	<script language="JavaScript" type="text/javascript">
		parent.ctlid.value = "<cfoutput>#rsCalPago.CPid#</cfoutput>";
		parent.ctlcod.value = "<cfoutput>#rsCalPago.CPcodigo#</cfoutput>";
		parent.ctldesc.value = "<cfoutput>#rsCalPago.CPdescripcion#</cfoutput>";
	</script>
</cfif>