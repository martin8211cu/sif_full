<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif isdefined("url.Alm_Aid") and len(trim(url.Alm_Aid)) and isdefined("url.Aid") and len(trim(url.Aid))>
	<cfquery name="dataMonto" datasource="#session.DSN#">
		select #LvarOBJ_PrecioU.enSQL_AS("a.Ecostou")#
		from Existencias a
		where a.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Alm_Aid#">
		and a.Aid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Aid#">
	</cfquery>
	<cfset MontoDet = 0>
	<cfif dataMonto.recordCount gt 0>
		<cfset MontoDet = LvarOBJ_PrecioU.enCF(dataMonto.Ecostou)>
	<cfelse>
		<cfset MontoDet = 0>
	</cfif>
</cfif>

<script language="JavaScript">
	<cfif isdefined("dataMonto") and dataMonto.recordCount gt 0>
		window.parent.document.form1.DSmontoest.value="<cfoutput>#LvarOBJ_PrecioU.enCF_COMAS(MontoDet)#</cfoutput>";
	<cfelse>
		window.parent.document.form1.DSmontoest.value="<cfoutput>#LvarOBJ_PrecioU.enCF(0)#</cfoutput>";
	</cfif>
</script>				

