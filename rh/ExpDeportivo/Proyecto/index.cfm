<cf_templateheader title="Index">
	<link href="/cfmx/asp/css/asp.css" type="text/css" rel="stylesheet">
	<cf_web_portlet_start titulo="Men&uacute; Principal">
	<cfinclude template="/home/menu/pNavegacion.cfm">
		<!--- Finalizar Estructura de Session cuando se sale al menu --->
		<cfset StructDelete(Session, "Progreso")>
		
		<table border="0" width="100%" cellpadding="2" cellspacing="0">
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td class="textoTituloMenuPrincipal" align="center" colspan="2"><cf_translate key="LB_Administracion_de_Equipos" >Administraci&oacute;n de Instituciones</cf_translate></td></tr>
			<tr>
			  <td width="35%" align="right">&nbsp;</td>
			  <td>&nbsp;</td>
		  </tr>
			<tr>
				<td align="right">
					<a href="Equipos.cfm"><img alt="1" src="/cfmx/rh/imagenes/number1_32.gif" border="0"></a>
				</td>
				<td><a class="textoMenuPrincipal" href="Proyecto.cfm"><cf_translate key="LB_Crear_Proyecto" >Instituciones</cf_translate></a></td>
			</tr>
			<tr>
				<td align="right">
					<a href="Equipos.cfm"><img alt="1" src="/cfmx/rh/imagenes/number2_32.gif" border="0"></a>
				</td>
				<td><a class="textoMenuPrincipal" href="Equipos.cfm">
				<cf_translate key="LB_Equipos" >Equipos</cf_translate>
				</a></td>
			</tr>
				<tr>
				<td align="right">
					<a href="expediente.cfm"><img alt="1" src="/cfmx/rh/imagenes/number2_32.gif" border="0"></a>
				</td>
				<td><a class="textoMenuPrincipal" href="Expedientes.cfm">
				<cf_translate key="LB_Personas" >Personas</cf_translate>
				</a></td>
			</tr>
			
			<!--- <cfif acceso_uri('/asp/catalogos/Usuarios.cfm')>
			<tr>
				<td align="right"><a href="/cfmx/asp/catalogos/Usuarios.cfm"><img alt="3" src="imagenes/menu/num3.gif" border="0"></a></td>
				<td><a class="textoMenuPrincipal" href="/cfmx/asp/catalogos/Usuarios.cfm"><cf_translate key="LB_Crear_Divisiones" >Crear Jugadores</cf_translate></a></td>
			</tr>
			</cfif>
			<cfif acceso_uri('/asp/catalogos/Permisos.cfm')>
			<tr>
				<td align="right"><a href="/cfmx/asp/catalogos/Permisos.cfm"><img alt="4" src="imagenes/menu/num4.gif" border="0"></a></td>
				<td><a class="textoMenuPrincipal" href="/cfmx/asp/catalogos/Permisos.cfm">Asignaci&oacute;n de Permisos</a></td>
			</tr>
			</cfif>
			 --->
			<tr><td></td><td>&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
