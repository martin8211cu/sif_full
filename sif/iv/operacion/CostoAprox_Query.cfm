<cfif isdefined("url.Alm_Aid") and len(trim(url.Alm_Aid)) and isdefined("url.Aid") and len(trim(url.Aid))>
	<cfquery name="dataMonto" datasource="#session.DSN#">
		select a.Ecostou as Ecostou
		from Existencias a
		where a.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Alm_Aid#">
		and a.Aid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Aid#">
	</cfquery>
</cfif>
	
	<cfset MontoDet = 0>
	<cfif isdefined("dataMonto") and dataMonto.recordCount gt 0>
		<cfset MontoDet = dataMonto.Ecostou>
	<cfelse>
		<cfset MontoDet = 0>
	</cfif>

	<script language="JavaScript">
		<cfoutput>
			<cfif isdefined("dataMonto") and dataMonto.recordCount gt 0>
				window.parent.document.requisicion.CostoAprox.value="#LSNumberFormat(MontoDet,',__.____')#";
			<cfelse>
				window.parent.document.requisicion.CostoAprox.value="0.00";
			</cfif>
		</cfoutput>
	</script>				

