<cf_templateheader title="Index">
	<link href="/cfmx/asp/css/asp.css" type="text/css" rel="stylesheet">
	<cf_web_portlet_start titulo="Men&uacute; Principal">
	<cfinclude template="/home/menu/pNavegacion.cfm">
		<!--- Finalizar Estructura de Session cuando se sale al menu --->
		<cfset StructDelete(Session, "Progreso")>
		
		<table border="0" width="100%" cellpadding="2" cellspacing="0">
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td class="textoTituloMenuPrincipal" align="center" colspan="2">Administraci&oacute;n de Cuentas</td></tr>
			<tr>
			  <td width="35%" align="right">&nbsp;</td>
			  <td>&nbsp;</td>
		  </tr>
		  <cfif acceso_uri('/asp/catalogos/Cuentas.cfm')>
			<tr>
				<td align="right">
					<a href="/cfmx/asp/catalogos/Cuentas.cfm"><img alt="1" src="imagenes/menu/num1.gif" border="0"></a>
				</td>
				<td><a class="textoMenuPrincipal" href="/cfmx/asp/catalogos/Cuentas.cfm">Crear Cuentas Empresariales</a></td>
			</tr></cfif>
			<cfif acceso_uri('/asp/catalogos/Empresas.cfm')>
			<tr>
				<td align="right"><a href="/cfmx/asp/catalogos/Empresas.cfm"><img alt="2" src="imagenes/menu/num2.gif" border="0"></a></td>
				<td><a class="textoMenuPrincipal" href="/cfmx/asp/catalogos/Empresas.cfm">Crear Empresas</a></td>
			</tr></cfif>
			<cfif acceso_uri('/asp/catalogos/Usuarios.cfm')>
			<tr>
				<td align="right"><a href="/cfmx/asp/catalogos/Usuarios.cfm"><img alt="3" src="imagenes/menu/num3.gif" border="0"></a></td>
				<td><a class="textoMenuPrincipal" href="/cfmx/asp/catalogos/Usuarios.cfm">Crear Usuarios</a></td>
			</tr></cfif>
			<cfif acceso_uri('/asp/catalogos/Permisos.cfm')>
			<tr>
				<td align="right"><a href="/cfmx/asp/catalogos/Permisos.cfm"><img alt="4" src="imagenes/menu/num4.gif" border="0"></a></td>
				<td><a class="textoMenuPrincipal" href="/cfmx/asp/catalogos/Permisos.cfm">Asignaci&oacute;n de Permisos</a></td>
			</tr></cfif>
			<tr><td></td><td>&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
