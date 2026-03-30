<cfparam name="modo"  default="ALTA">
<cfparam name="action"  default="CuentaPrincipal_tabs.cfm">

<cftransaction>
<cftry>
	<cfif isdefined("form.btnEliminar") and isdefined("form.chk")>
		<cfquery name="activo_usuario" datasource="#session.DSN#">
			<cfloop index="dato" list="#form.chk#">
				<cfset datos = ListToArray(dato,"|") >
				set nocount on

				update UsuarioPermiso
				set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				    BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
				    BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
				    BMfechamod = getDate()
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
				  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#datos[2]#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ecodigo2#">

				delete UsuarioPermiso
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
				  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#datos[2]#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ecodigo2#">
	
				update UsuarioEmpresa
				set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				    BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
				    BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
				    BMfechamod = getDate()
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
				  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#datos[2]#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ecodigo2#">

				delete UsuarioEmpresa
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
				  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#datos[2]#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ecodigo2#">

				set nocount off
			</cfloop>
		</cfquery>

	<cfelseif isdefined("form.btnAgregar") and isdefined("form.chk")>
		<cfquery name="insert_modulo" datasource="#session.DSN#">
			<cfloop index="dato" list="#form.chk#">
				<cfset datos = ListToArray(dato,"|") >
				set nocount on
				insert UsuarioEmpresa ( Usucodigo,Ulocalizacion,cliente_empresarial,Ecodigo,  BMUsucodigo, BMUlocalizacion, BMUsulogin )
				select 	ue.Usucodigo, ue.Ulocalizacion, ue.cliente_empresarial, e.Ecodigo,
				  		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				  		<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
				  		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">
				from UsuarioEmpresarial ue, Empresa e
				where e.cliente_empresarial = ue.cliente_empresarial
				  and ue.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
				  and ue.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#datos[2]#">
				  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ecodigo2#">
				set nocount off
			</cfloop>
		</cfquery>
		<cfset desde = 'conlis'>
		<cfset action = "EmpresaUsuario_conlis.cfm">

	</cfif>
<cfcatch type="database">
	<cfinclude template="../errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>

</cftransaction>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="ecodigo2" type="hidden" value="#form.ecodigo2#">
	<input type="hidden" name="cliente_empresarial" value="<cfif isdefined('form.cliente_empresarial') and form.cliente_empresarial NEQ ''>#form.cliente_empresarial#</cfif>">
	<cfif isdefined("desde")>
		<input type="hidden" name="cerrar" value="cerrar">
	</cfif>
	<input type="hidden" name="Pagina" value="<cfif modo neq 'ALTA' and isdefined("pagina")>#pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>