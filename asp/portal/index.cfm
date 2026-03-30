<cf_templateheader title="Index">
	<link href="/cfmx/asp/css/asp.css" type="text/css" rel="stylesheet">
	<cf_web_portlet_start titulo="Menu Principal">
<cfinclude template="/home/menu/pNavegacion.cfm">
		<!--- Finalizar Estructura de Session cuando se sale al menu --->
		<cfset StructDelete(Session, "Progreso")>
		
		<table border="0" width="100%" cellpadding="2" cellspacing="0">
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr>
			  <td class="textoTituloMenuPrincipal" align="center" colspan="4">Configuraci&oacute;n de Aplicaciones del Portal</td>
			</tr>
			<tr>
			  <td width="25%" align="right">&nbsp;</td>
			  <td width="25%">&nbsp;</td>
		      <td width="10%">&nbsp;</td>
		      <td width="40%">&nbsp;</td>
		  </tr>
			<tr>
			  <td align="right"><a href="catalogos/sistemas.cfm"><img src="../imagenes/bullet.gif" border="0"></a></td>
			  <td><a class="textoMenuPrincipal" href="catalogos/sistemas.cfm">Sistemas</a></td>
				<td align="right"><a href="catalogos/roles.cfm"><img src="../imagenes/bullet.gif" border="0"></a></td>
				<td><a class="textoMenuPrincipal" href="catalogos/roles.cfm">Grupos de Permisos</a></td>
		  </tr>

			<tr>
			  <td align="right"><a href="catalogos/modulos.cfm"><img src="../imagenes/bullet.gif" border="0"></a></td>
			  <td><a class="textoMenuPrincipal" href="catalogos/modulos.cfm">M&oacute;dulos</a></td>
				<td align="right"><a href="exportar/exportar.cfm"><img src="../imagenes/bullet.gif" border="0"></a></td>
				<td><a class="textoMenuPrincipal" href="exportar/exportar.cfm">Exportar sistemas </a></td>
			</tr>

			<tr>
			  <td align="right"><a href="catalogos/procesos.cfm"><img src="../imagenes/bullet.gif" border="0"></a></td>
			  <td><a class="textoMenuPrincipal" href="catalogos/procesos.cfm">Procesos</a></td>
				<td align="right">&nbsp;</td>
			    <td>&nbsp;</td>
			</tr>
			<tr>
			  <td align="right"><a href="catalogos/componentes.cfm"><img src="../imagenes/bullet.gif" border="0"></a></td>
			  <td><a class="textoMenuPrincipal" href="catalogos/componentes.cfm">Componentes</a></td>
				<td align="right">&nbsp;</td>
			    <td>&nbsp;</td>
			</tr>
			<tr>
			  <td align="right"><a href="catalogos/listado.cfm"><img src="../imagenes/bullet.gif" border="0"></a></td>
			  <td><a class="textoMenuPrincipal" href="catalogos/listado.cfm">Listado</a></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
			  <td align="right">&nbsp;</td>
			  <td>&nbsp;</td>
			  <td align="right">&nbsp;</td>
			  <td>&nbsp;</td>
			</tr>
			<tr>
			  <td align="right">&nbsp;</td>
			  <td>&nbsp;</td>
			  <td align="right">&nbsp;</td>
			  <td>&nbsp;</td>
		  </tr>
			<tr>
			  <td></td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
