<cfset usuarios = structnew() >

<cfif LSIsNumeric(form.password) >
	<cfquery name="validar" datasource="tramites_cr">
		select id_persona from TPPersona where id_persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.password#">
	</cfquery>
</cfif>

<cfif isdefined('validar') and validar.recordcount gt 0 >
	<cfset session.user = trim(validar.id_persona) >
	<cfset session.password = trim(validar.id_persona) >
	
	<cfquery name="funcionario" datasource="tramites_cr">
		select id_funcionario as id, id_inst
		from TPFuncionario
		where id_persona=#session.user#
	</cfquery>

	<cfif len(trim(funcionario.id))>
		<cfset session.tramites.ID_FUNCIONARIO = funcionario.id >
	<cfelse>
		<cfset session.tramites.ID_FUNCIONARIO = 7 >
	</cfif>

	<cfif len(trim(funcionario.id_inst))>
		<cfset session.tramites.ID_INST = funcionario.id_inst >
	<cfelse>
		<cfset session.tramites.ID_INST = 3 >
	</cfif>

	<cfset session.tramites.ID_SUCURSAL = 10 >
	<cfset session.tramites.ID_VENTANILLA = 5 >

	<cfset session.DSN = 'minisif' >
	<cfset session.Usucodigo = 0 >

	<cflocation url="principal.cfm?">
</cfif>

<cflocation url="noautorizado.cfm">