<cfset seg = CreateObject("component", "home.Componentes.Seguridad")><!---Inicializa el componente---->
<cfset funcionario = seg.getUsuarioByCod(session.Usucodigo, session.EcodigoSDC, 'TPFuncionario') >

<cfif not ( funcionario.recordcount gt 0 and len(trim(funcionario.llave)))>
	<cfthrow message="Error. Usuario no definido como funcionario.">
</cfif>

<cfif not isdefined("session.tramites")>
	<cfset session.tramites = structnew()>
	<cfset StructInsert(session.tramites, 'id_funcionario', funcionario.llave ) >
	<cfset StructInsert(session.tramites, 'id_ventanilla', 4 ) >
<cfelse>
	<cfset session.tramites.id_funcionario = funcionario.llave >
	<cfset session.tramites.id_ventanilla = 4 >
</cfif>