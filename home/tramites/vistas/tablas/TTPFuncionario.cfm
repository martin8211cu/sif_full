<cfset Lvar_Inst = session.tramites.id_inst>
<cfquery name="rsInst" datasource="#session.tramites.dsn#">
	select id_inst
	from TPDocumento
	where id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Gvar_id_tipo#">
</cfquery>
<cfif rsInst.recordcount and len(rsInst.id_inst)>
	<cfset Lvar_Inst = rsInst.id_inst>
</cfif>
<cfquery name="rsTPFuncionario" datasource="#session.tramites.dsn#">
	select id_funcionario, apellido1 || ' ' || apellido2 || ' ' || nombre as nombre_funcionario
	from TPFuncionario a
	inner join TPPersona b
	on b.id_persona = a.id_persona
	where a.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Inst#">
	order by nombre_funcionario
</cfquery>
<cfoutput>
<select name="#Gvar_name#">
	<cfloop query="rsTPFuncionario">
		<option value="#nombre_funcionario#" <cfif nombre_funcionario eq Gvar_Value>selected</cfif>>#nombre_funcionario#</option>
	</cfloop>
</select>
</cfoutput>