<link rel="stylesheet" type="text/css" href="/cfmx/aspAdmin/css/sec.css">
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td>
		<cfparam name="url.cliente_empresarial" default="">
		<cfparam name="form.cliente_empresarial" default="#url.cliente_empresarial#">
		<cfparam name="url.Ecodigo2" default="">
		<cfparam name="form.Ecodigo2" default="#url.Ecodigo2#">
		<cfif form.cliente_empresarial NEQ "" AND form.Ecodigo2 NEQ "" >
			<cfquery name="rsLogoTabs" datasource="#session.DSN#">
				select nombre_comercial as nombre
					, logo
				from Empresa
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo2#">
			</cfquery>
			<table cellpadding="0" cellspacing="0" width="100%">
				<tr>
				<cfoutput>
				<cfif len(rsLogoTabs.logo) GT 0>
					<td width="70" align="center">
					   <cf_sifleerimagen autosize="false" border="false" tabla="Empresa" campo="logo" condicion="Ecodigo = #form.Ecodigo2# " conexion="#session.DSN#" imgname="img" height="60" ruta="/cfmx/aspAdmin/Utiles/sifleerimagencont.cfm"> 
					</td>
				</cfif>
					<td style="font-weight:bold;font-size=14px;">
						Empresa: #rsLogoTabs.nombre#
					</td>
				</cfoutput>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</cfif>
		<cfinvoke 
		 component="aspAdmin.Componentes.pTabs"
		 method="fnTabsInclude">
			<cfinvokeargument name="pTabID" value="TabID2"/>
			<cfinvokeargument name="pTabs" value=
				 #"|Empresa,Empresa_lista.cfm,Trabajar con los Datos de la Empresa"
				& "|Módulos,EmpresaModulo_form.cfm,Habilitar módulos para la Empresa"
				& "|Caches,EmpresaCaches_lista.cfm,Definición de Cachés por Sistema"
				& "|Usuarios,EmpresaUsuario_form.cfm,Asignación de roles a Usuario en la Empresa"
				#
			/> 
			<cfinvokeargument name="pDatos" value="cliente_empresarial=#form.cliente_empresarial#,Ecodigo2=#form.Ecodigo2#"/>
			<cfinvokeargument name="pNoTabs" value=#(form.cliente_empresarial EQ "" OR form.Ecodigo2 EQ "")#/>
			<cfinvokeargument name="pWidth" value="500"/>
		</cfinvoke>
		</td>
	</tr>
</table>
