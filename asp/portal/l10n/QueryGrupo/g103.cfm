<cfquery datasource="asp" name="grupo">
	select 	{fn concat({fn concat({fn concat({fn concat(rtrim(SScodigo), '.')}, rtrim(SMcodigo))}, '.')}, rtrim(SPcodigo))}  as valor,  <!---rtrim(SScodigo) || '.' || rtrim(SMcodigo) || '.' || rtrim(SPcodigo)--->
			SPdescripcion as descr,
			{fn concat({fn concat(rtrim(SScodigo), '.')}, rtrim(SMcodigo))} as grupo,	<!--- rtrim(SScodigo) || '.' || rtrim(SMcodigo) as grupo, --->
			'' as refer
	from SProcesos
	where 1=1
	<cfif isdefined("url.SScodigo") and len(trim(url.SScodigo))>
		and SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SScodigo#">
	</cfif>
	<cfif isdefined("url.SMcodigo") and len(trim(url.SMcodigo))>
		and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SMcodigo#">
	</cfif>
	order by 1
</cfquery>