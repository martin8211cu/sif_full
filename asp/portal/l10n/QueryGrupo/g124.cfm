<!--- este --->
<cfquery datasource="asp" name="grupo">
	select 	id_item as valor, 
			etiqueta_item as descr, 
			{fn concat({fn concat(rtrim(SScodigo), '.')}, rtrim(SMcodigo))} as grupo, <!--- 			rtrim(SScodigo)||'.'||rtrim(SMcodigo)--->
			'' as refer
	from SMenuItem
	where 1=1
	<cfif isdefined("url.SScodigo") and len(trim(url.SScodigo))>
		and SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SScodigo#">
	</cfif>
	<cfif isdefined("url.SMcodigo") and len(trim(url.SMcodigo))>
		and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SMcodigo#">
	</cfif>
	
	order by 1
</cfquery>