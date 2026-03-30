<cfparam name="modo"  default="ALTA">
<cfparam name="action"  default="CuentaPrincipal_tabs.cfm">

<cftransaction>
<cftry>
	<cfif isdefined("form.btnEliminar") and isdefined("form.chk")>
		<cfquery name="activo_usuario" datasource="#session.DSN#">
			<cfloop index="dato" list="#form.chk#">
				set nocount on
				update EmpresaModulo
				set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				    BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
				    BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
				    BMfechamod = getDate()
				where modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#dato#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ecodigo2#">

				delete EmpresaModulo
				where modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#dato#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ecodigo2#">
				set nocount off
			</cfloop>
		</cfquery>

	<cfelseif isdefined("form.btnAgregar") and isdefined("form.chk")>
		<cfquery name="insert_modulo" datasource="#session.DSN#">
			<cfloop index="dato" list="#form.chk#">
				<cfset datos = ListToArray(dato,"|") >
				set nocount on
				if not exists ( select Ecodigo from EmpresaID es
				                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ecodigo2#">
				                  and sistema = <cfqueryparam cfsqltype="cf_sql_char" value="#datos[1]#"> )

					insert EmpresaID ( sistema, Ecodigo, BMUsucodigo, BMUlocalizacion, BMUsulogin )
					  values ( 	<cfqueryparam cfsqltype="cf_sql_char" value="#datos[1]#">,
					  			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ecodigo2#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">  )
				  
				insert EmpresaModulo (modulo,Ecodigo,desde,BMUsucodigo,BMUlocalizacion,BMUsulogin)
				  values (  <cfqueryparam cfsqltype="cf_sql_char" value="#datos[2]#">,
						    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ecodigo2#">,
						    getDate(),
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">  )
				set nocount off
			</cfloop>
		</cfquery>
		<cfset desde = 'conlis' >
		<cfset action = "EmpresaModulo_conlis.cfm">

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
	<input name="cliente_empresarial" type="hidden" value="#form.cliente_empresarial#">
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