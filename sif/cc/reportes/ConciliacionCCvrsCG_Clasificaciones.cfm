<!--- <cfdump var="#url#"> --->
<cfif isdefined("url.SNCDid") and len(trim(url.SNCDid)) and isdefined("url.op") and url.op eq 'I'>
	<cfquery datasource="#session.DSN#">
		insert into CCClasificConciliacionUsr 
			(Usucodigo, 
			 SNCDid, 
			 Ecodigo)
		values 
			(
			#session.Usucodigo#,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid#">,
			#session.Ecodigo#
			)
	</cfquery>
<cfelseif isdefined("url.SNCDid") and len(trim(url.SNCDid)) and isdefined("url.op") and url.op eq 'D'>
	<cfquery datasource="#session.DSN#">
		delete from CCClasificConciliacionUsr
		where Usucodigo = #session.Usucodigo#
		and SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid#">
	</cfquery>
</cfif>