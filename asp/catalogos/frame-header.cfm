<!--- Pantalla --->
<cfif isdefined("Session.Progreso") and isdefined("Session.Progreso.Pantalla") and Len(Trim(Session.Progreso.Pantalla)) NEQ 0>
	<cfif isdefined("Session.Progreso.CEcodigo") and Len(Trim(Session.Progreso.CEcodigo)) NEQ 0>
		<cfquery name="rsImgEmpresa" datasource="asp">
			select ts_rversion, CElogo
			from CuentaEmpresarial
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
		</cfquery>
	</cfif>

	<cfif Session.Progreso.Pantalla EQ "1">
		<cfif isdefined("Session.Progreso.CEcodigo") and Len(Trim(Session.Progreso.CEcodigo)) NEQ 0>
			<cfquery name="rsTitulo" datasource="asp">
				select CEnombre
				from CuentaEmpresarial
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
			</cfquery>
			<cfset titulo = "Trabajando con: " & rsTitulo.CEnombre>
		<cfelse>
			<cfset titulo = "Crear Cuentas Empresariales">
		</cfif>
		<cfset pasoImg = "../imagenes/menu/num#Session.Progreso.Pantalla#_large.gif">
	<cfelseif Session.Progreso.Pantalla EQ "1a">
		<cfset titulo = "Asignación de Módulos a Cuenta Empresarial">
		<cfset pasoImg = "../imagenes/menu/num1_large.gif">
	<cfelseif Session.Progreso.Pantalla EQ "1b">
		<cfset titulo = "Asignación de Caches a Cuenta Empresarial">
		<cfset pasoImg = "../imagenes/menu/num1_large.gif">
	<cfelseif Session.Progreso.Pantalla EQ "1c">
		<cfset titulo = "Opciones de Seguridad">
		<cfset pasoImg = "../imagenes/menu/num1_large.gif">
	<cfelseif Session.Progreso.Pantalla EQ "2">
		<cfif isdefined("Form.Empresa") and Len(Trim(Form.Empresa)) NEQ 0>
			<cfquery name="rsTitulo" datasource="asp">
				select Enombre
				from Empresa
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Empresa#">
				and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
			</cfquery>
			<cfset titulo = "Trabajando con: " & rsTitulo.Enombre>
		<cfelse>
			<cfset titulo = "Crear Empresas">
		</cfif>
		<cfset pasoImg = "../imagenes/menu/num#Session.Progreso.Pantalla#_large.gif">
	<cfelseif Session.Progreso.Pantalla EQ "3">
		<cfif isdefined("Form.Usucodigo") and Len(Trim(Form.Usucodigo)) NEQ 0>
			<cfquery name="rsTitulo" datasource="asp">
				select Pnombre, Papellido1, Papellido2
				from Usuario a, DatosPersonales b
				where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
				and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
				and a.datos_personales = b.datos_personales
			</cfquery>
			<cfset titulo = "Trabajando con: " & rsTitulo.Pnombre & " " & rsTitulo.Papellido1 & " " & rsTitulo.Papellido2>
		<cfelse>
			<cfset titulo = "Crear Usuarios">
		</cfif>
		<cfset pasoImg = "../imagenes/menu/num#Session.Progreso.Pantalla#_large.gif">
	<cfelseif Session.Progreso.Pantalla EQ "4">
		<cfset titulo = "Asignación de Permisos">
		<cfset pasoImg = "../imagenes/menu/num#Session.Progreso.Pantalla#_large.gif">
	<cfelseif Session.Progreso.Pantalla EQ "5">
		<cfset titulo = "Datos de Cuenta Empresarial">
		<cfset pasoImg = "../imagenes/menu/num#Session.Progreso.Pantalla#_large.gif">
	</cfif>
</cfif>

<!--- Hay que obtener los datos del Administrador Correcto --->
<cfquery name="rsAdministrador" datasource="asp">
	select b.Pnombre, b.Papellido1, b.Papellido2
	from Usuario a, DatosPersonales b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#"> 
	and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> 
	and a.datos_personales = b.datos_personales
</cfquery>

<link href="/cfmx/asp/css/asp.css" type="text/css" rel="stylesheet">
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="4">
	  <tr>
		<td width="1%">
			<cfif isdefined("Session.Progreso") and isdefined("Session.Progreso.Pantalla") and Len(Trim(Session.Progreso.Pantalla)) NEQ 0>
				<img border="0" src="#pasoImg#" align="middle">
			<cfelse>
				&nbsp;
			</cfif>
		</td>
		<td style="padding-left: 15px;">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<cfif isdefined("Session.Progreso") and isdefined("Session.Progreso.Pantalla") and Session.Progreso.Pantalla NEQ "1">
			  <tr>
			    <td>
					<table border="0" cellspacing="0" cellpadding="0" class="formatoCuenta">
					  <tr>
						<td valign="middle" align="center" width="1%" style="padding-left: 10px; padding-right: 10px;" nowrap>
							<!---<img border="0" src="../imagenes/logo.gif" width="40" height="40">--->
							<cfif isdefined('rsImgEmpresa') and isdefined("session.progreso.CEcodigo") and Len(Trim(Session.Progreso.CEcodigo)) NEQ 0>
								<cfif Len(rsImgEmpresa.CElogo) gt 1>
									<cfinvoke 
									 component="sif.Componentes.DButils"
									 method="toTimeStamp"
									 returnvariable="tsurl">
										<cfinvokeargument name="arTimeStamp" value="#rsImgEmpresa.ts_rversion#"/>
									</cfinvoke>
									<img src="../../home/public/logo_cuenta.cfm?CEcodigo=#session.progreso.CEcodigo#&ts=#tsurl#" border="0">
								
	<!--- 								<cf_leerimagen autosize="true" border="false" tabla="CuentaEmpresarial" campo="CElogo" condicion="CEcodigo = #session.progreso.CEcodigo# and datalength(CElogo) > 1" conexion="asp" imgname="img" > --->
								</cfif>
							</cfif>
						</td>
						<td class="tituloCuenta"  align="left" nowrap>#cuenta#</td>
					  </tr>
					</table>
				</td>
			  </tr>
			</cfif>
			  <tr>
				<td class="tituloProceso" nowrap>#titulo#</td>
			  </tr>
			  <tr>
			    <td class="tituloPersona" nowrap>
					#rsAdministrador.Pnombre#
					#rsAdministrador.Papellido1#
					#rsAdministrador.Papellido2#
				</td>
			  </tr>
			</table>
		</td>
	  </tr>
	</table>
</cfoutput>
