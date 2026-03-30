<link rel="stylesheet" type="text/css" href="/cfmx/aspAdmin/css/sec.css">
<cfif session.tipoRolAdmin NEQ "sys.adminCuenta">
	<table width="100%" border="0" cellpadding="3" cellspacing="0" bgcolor="#DFDFDF">
	  <tr align="left">
		<td nowrap>
			<a href="/cfmx/aspAdmin/index.cfm">Framework</a>
		</td>
	  </tr>
	</table>			
</cfif>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<cfparam name="url.cliente_empresarial" default="">
	<cfparam name="form.cliente_empresarial" default="#url.cliente_empresarial#">
	<cfif session.tipoRolAdmin EQ "sys.adminCuenta">
		<cfquery name="rsCCE" datasource="#session.DSN#">
			select cliente_empresarial
			  from UsuarioEmpresarial
			 where Usucodigo = #session.Usucodigo#
			   and Ulocalizacion = '#session.Ulocalizacion#'
		</cfquery>
		<cfif rsCCE.recordCount EQ 1>
			<cfset form.cliente_empresarial = rsCCE.cliente_empresarial>
		</cfif>
	</cfif>
	<cfif form.cliente_empresarial NEQ "">
	<tr>
		<td>
			<cfquery name="rsLogoTabs" datasource="#session.DSN#">
				select cce.nombre
					, rtrim(u.Usucuenta) as Usucuenta
					, cce.logo
				from Usuario u, CuentaClienteEmpresarial cce
				where cce.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
				  and cce.Usucodigo = u.Usucodigo
				  and cce.Ulocalizacion = u.Ulocalizacion
			</cfquery>
			<table cellpadding="0" cellspacing="0" width="100%">
				<tr><td>&nbsp;</td></tr>
				<tr>
				<cfoutput>
				<cfif len(rsLogoTabs.logo) GT 0>
					<td align="center" width="120">
					   <cf_sifleerimagen autosize="false" border="false" tabla="CuentaClienteEmpresarial" campo="logo" condicion="cliente_empresarial = #form.cliente_empresarial# " conexion="#session.DSN#" imgname="img" height="60" ruta="/cfmx/aspAdmin/Utiles/sifleerimagencont.cfm"> 
					</td>
				</cfif>
					<td style="font-weight:bold;font-size=14px;">
						Cuenta Empresarial: #rsLogoTabs.nombre#<br>(#trim(rsLogoTabs.Usucuenta)#)
					</td>
				</cfoutput>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</td>
	</tr>
		</cfif>
	<tr>
		<td align="center">

		<cfset LvarTabs = "">
		<cfset LvarTabs = LvarTabs
				& "|Cuenta,CuentaPrincipal_lista.cfm,Trabajar con los datos de la cuenta empresarial" >
		<cfif session.tipoRolAdmin NEQ "sys.adminCuenta">
			<cfset LvarTabs = LvarTabs
				& "|Contratos,cuentaContrato_lista.cfm,Contratos Suscritos con la Cuenta Empresarial"
				& "|Funcionarios,usuarioempresarial_lista.cfm,Contactos para la Cuenta Empresarial,ppTipo=C"
				& "|Administradores,UsuarioEmpresarial_lista.cfm,Administradores de la Cuenta Empresarial,ppTipo=A">
		</cfif>
		<cfset LvarTabs = LvarTabs
				& "|Usuarios,UsuarioEmpresarial_lista.cfm,Usuarios de la Cuenta Empresarial,ppTipo=U"
				& "|Empresas,Empresa_tabs.cfm,Empresas de la Cuenta Empresarial">
		<cfif session.tipoRolAdmin NEQ "sys.agente">
			<cfset LvarTabs = LvarTabs
				& "|Formas Pago,cuentaFormaPago.cfm,Definición de Formas de Pago para la Cuenta Empresarial">
		</cfif>

		<cfinvoke 
		 component="aspAdmin.Componentes.pTabs"
		 method="fnTabsInclude">
			<cfinvokeargument name="pTabID" value="TabID"/>
			<cfinvokeargument name="pTabs" value=#LvarTabs#/> 
			<cfinvokeargument name="pDatos" value="cliente_empresarial=#form.cliente_empresarial#"/>
			<cfinvokeargument name="pNoTabs" value=#(form.cliente_empresarial EQ "")#/>
			<cfinvokeargument name="pWidth" value="95%"/>
		</cfinvoke>
		</td>
	</tr>
</table>
