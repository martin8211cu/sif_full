<cf_templateheader title="Index">
	<link href="/cfmx/asp/css/asp.css" type="text/css" rel="stylesheet">
	<cf_web_portlet_start titulo="Menu Principal">
	<cfinclude template="/home/menu/pNavegacion.cfm">
		<!--- Finalizar Estructura de Session cuando se sale al menu --->
		<cfset StructDelete(Session, "Progreso")>
		
		<table border="0" width="100%" cellpadding="2" cellspacing="0">
			<tr><td colspan="5">&nbsp;</td></tr>
			<tr>
			  <td class="textoTituloMenuPrincipal" align="center" colspan="5">Administraci&oacute;n y Operaci&oacute;n del Portal</td>
			</tr>
			<tr>
			  <td colspan="5" align="right">&nbsp;</td>
		  </tr>
			<tr>
			  <td align="right">&nbsp;</td>
			  <td colspan="2" align="left" class="textoMenuPrincipal">Administraci&oacute;n</td>
			  <td colspan="2" align="left" class="textoMenuPrincipal">Operaci&oacute;n</td>
	      </tr>
			<tr>
				<td width="21%" align="right">&nbsp;</td>
				<td width="4%" align="right"><a href="catalogos/caches.cfm"><img src="../imagenes/bullet.gif" border="0"></a></td>
				<td width="25%"><a class="textoMenuPrincipal" href="catalogos/caches.cfm">Caches</a></td>
 				<td width="4%" align="right"><a href="correo/index.cfm"><img src="../imagenes/bullet.gif" border="0"></a></td>
 				<td width="46%"><a class="textoMenuPrincipal" href="correo/index.cfm">Correo</a></td>
		  </tr>

			<tr>
			  <td align="right">&nbsp;</td>
			  <td align="right"><a href="catalogos/dominio.cfm"><img src="../imagenes/bullet.gif" border="0"></a></td>
			  <td><a class="textoMenuPrincipal" href="catalogos/dominio.cfm">Dominios</a></td>
			  <td align="right"><a href="errores/index.cfm"><img src="../imagenes/bullet.gif" border="0"></a></td>
				<td><a class="textoMenuPrincipal" href="errores/index.cfm">Errores</a></td>
			</tr>

			<tr>
			  <td align="right">&nbsp;</td>
			  <td align="right"><a href="catalogos/apariencia.cfm"><img src="../imagenes/bullet.gif" border="0"></a></td>
			  <td><a class="textoMenuPrincipal" href="catalogos/apariencia.cfm">Plantillas</a></td>
			  <td colspan="2" align="left" class="textoMenuPrincipal">Utilitarios</td>
			</tr>
			<tr>
				<td align="right">&nbsp;</td>
				<td align="right">&nbsp;</td>
				<td>&nbsp;</td>
			    <td align="right"><a href="exportar/datos.cfm"><img src="../imagenes/bullet.gif" border="0"></a></td>
			    <td><a class="textoMenuPrincipal" href="exportar/datos.cfm">Exportar tablas</a></td>
			</tr>
			<tr>
				<td align="right">&nbsp;</td>
				<td align="right">&nbsp;</td>
				<td>&nbsp;</td>
				<td align="right">&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
			  <td align="right">&nbsp;</td>
			  <td align="right">&nbsp;</td>
			  <td>&nbsp;</td>
			  <td align="right">&nbsp;</td>
			  <td>&nbsp;</td>
			</tr>
			<tr>
			  <td align="right">&nbsp;</td>
			  <td align="right">&nbsp;</td>
			  <td>&nbsp;</td>
			  <td align="right">&nbsp;</td>
			  <td>&nbsp;</td>
		  </tr>
			<tr>
			  <td></td>
			  <td></td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
