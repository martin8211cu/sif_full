<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Donaciones
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="pMenu.cfm">
</cf_templatearea>
<cf_templatearea name="body">
	<cfset navBarItems = ArrayNew(1)>
	<cfset navBarLinks = ArrayNew(1)>
	<cfset navBarStatusText = ArrayNew(1)>
		
	<cfinclude template="pNavegacion.cfm">

	<table width="89%" border="0" cellpadding="0" cellspacing="0" >
    	<tr>
    	  <td width="1%" nowrap><font size="2">&nbsp;<img src="/cfmx/sif/imagenes/Computer01_T2.gif" width="31" height="31"></font></td>
    	  <td colspan="2" nowrap><font size="2"><b>Operaciones</b></font></td>
    	  <td width="1%" nowrap><font size="2"><img src="/cfmx/sif/imagenes/Graficos02_T.gif"></font></td>
    	  <td colspan="2" nowrap><font size="2"><b>Consultas</b></font></td>
   	  </tr>
    	<tr>
    	  <td width="1%" nowrap>&nbsp;</td>
    	  <td width="1%" align="right" valign="middle" nowrap ><a href="donacion_registro.cfm"><img src="/cfmx/sif/imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
    	  <td valign="middle" nowrap><a href="donacion_registro.cfm">Registro de Donaciones</a></td>
    	  <td nowrap>&nbsp;</td>
    	  <td align="right" valign="middle" nowrap><a href="consultas/personas_lista.cfm"><img src="/cfmx/sif/imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
    	  <td valign="middle" nowrap><a href="consultas/personas_lista.cfm">Feligreses</a></td>
   	  </tr>
    	<tr>
    	  <td nowrap>&nbsp;</td>
    	  <td align="right" valign="middle" nowrap><a href="donacion_compromiso.cfm"><img src="/cfmx/sif/imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
    	  <td valign="middle" nowrap><a href="donacion_compromiso.cfm">Registro de Compromisos</a></td>
    	  <td width="1%" nowrap>&nbsp;</td>
<!---     	  <td width="1%" align="right" valign="middle" nowrap><a href="donacion_listado.cfm"><img src="/cfmx/sif/imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
    	  <td valign="middle" nowrap><a href="donacion_listado.cfm">Listado de Donaciones</a></td>
 --->   	  </tr>
    	<tr>
    	  <td nowrap>&nbsp;</td>
    	  <td colspan="2" nowrap>&nbsp;</td>
    	  <td nowrap>&nbsp;</td>
<!---     	  <td align="right" valign="middle" nowrap><a href="donacion_compromiso_listado.cfm"><img src="/cfmx/sif/imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
    	  <td valign="middle" nowrap><a href="donacion_compromiso_listado.cfm">Listado de Compromisos</a></td>
 --->   	  </tr>
    	<tr>
    	  <td nowrap>&nbsp;</td>
    	  <td colspan="2" nowrap>&nbsp;</td>
    	  <td width="1%" nowrap>&nbsp;</td>
    	  <td width="1%" align="right" valign="middle" nowrap><a href="consultas/MejoresDonadores.cfm?tipo=1"><img src="/cfmx/sif/imagenes/Recordset.gif" width="24" height="22" border="0"></a></td>
    	  <td valign="middle" nowrap><a href="consultas/MejoresDonadores.cfm?tipo=1">Mejores Donadores</a></td>
   	  </tr>
    	<tr>
    	  <td nowrap>&nbsp;</td>
    	  <td colspan="2" nowrap>&nbsp;</td>
    	  <td width="1%" nowrap>&nbsp;</td>
    	  <td width="1%" align="right" valign="middle" nowrap><a href="consultas/DonacionProyecto.cfm?tipo=2"><img src="/cfmx/sif/imagenes/Recordset.gif" width="24" height="22" border="0"></a></td>
    	  <td valign="middle" nowrap><a href="consultas/DonacionProyecto.cfm?tipo=2">Donaciones por Proyecto</a></td>
   	  </tr>
    	<tr>
    		<td nowrap>&nbsp;</td>
    		<td colspan="2" nowrap>&nbsp;</td>
    		<td nowrap>&nbsp;</td>
    		<td align="right" valign="middle" nowrap><a href="consultas/DonacionTipoPago.cfm?tipo=2"><img src="/cfmx/sif/imagenes/Recordset.gif" width="24" height="22" border="0"></a></td>
    		<td valign="middle" nowrap><a href="consultas/DonacionTipoPago.cfm?tipo=2">Donaciones
    				por Tipo de Pago </a></td>
    	</tr>

<!---     	<tr>
          <td nowrap>&nbsp;</td>
          <td colspan="2" nowrap>&nbsp;</td>
          <td width="1%" nowrap>&nbsp;</td>
          <td width="1%" align="right" valign="middle" nowrap><a href="consultas/Donaciones.cfm?tipo=3"><img src="/cfmx/sif/imagenes/Recordset.gif" width="24" height="22" border="0"></a></td>
          <td valign="middle" nowrap><a href="consultas/Donaciones.cfm?tipo=3">Gr&aacute;fica de donaciones</a></td>
   	  </tr>
 --->    	<tr>
    	  <td nowrap>&nbsp;</td>
    	  <td colspan="2" nowrap>&nbsp;</td>
    	  <td nowrap>&nbsp;</td>
    	  <td align="right" valign="middle" nowrap><a href="consultas/graph_cumplimientoProyectos.cfm"><img src="/cfmx/sif/imagenes/Recordset.gif" width="24" height="22" border="0"></a></td>
    	  <td valign="middle" nowrap><a href="consultas/graph_cumplimientoProyectos.cfm">Gr&aacute;ficas de cumplimiento de proyetos</a></td>
   	  </tr>
    	<tr>
    	  <td width="1%" nowrap><font size="2">&nbsp;<img src="/cfmx/sif/imagenes/Reporte01_T.gif" width="31" height="31"></font></td>
    	  <td colspan="2" nowrap><font size="2"><b>Cat&aacute;logos</b></font></td>
			<td nowrap>&nbsp;</td>
			<td align="right" valign="middle" nowrap>&nbsp;</td>
			<td valign="middle" nowrap>&nbsp;</td>
    	</tr>
		<tr>
        	<td width="1%" nowrap>&nbsp;</td>
			<td width="1%" align="right" valign="middle" nowrap><a href="donacion_proyecto.cfm"><img src="/cfmx/sif/imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></td>
			<td valign="middle" nowrap><a href="donacion_proyecto.cfm">Proyectos</a></td>
        	<td width="1%" nowrap>&nbsp;</td>
			<td width="1%" align="right" valign="middle" nowrap>&nbsp;</td>		
			<td valign="middle" nowrap>&nbsp;</td>		
		</tr>

		<tr>
        	<td width="1%" nowrap>&nbsp;</td>
			<td align="right" valign="middle" nowrap>&nbsp;</td>
			<td valign="middle" nowrap>&nbsp;</td>
			<td width="1%" nowrap>&nbsp;</td>
			<td width="1%" align="right" valign="middle" nowrap>&nbsp;</td>
			<td valign="middle" nowrap>&nbsp;</td>
		</tr>

		<tr>
        	<td width="1%" nowrap>&nbsp;</td>
			<td valign="middle" nowrap>&nbsp;</a></td>		
			<td valign="middle" nowrap>&nbsp;</a></td>		
        	<td width="1%" nowrap>&nbsp;</td>
			<td width="1%" align="right" valign="middle" nowrap>&nbsp;</td>
			<td valign="middle" nowrap>&nbsp;</td>
		</tr>


<!---
	<table width="89%" border="1" >
		<ul style="font:inherit">
			<tr><td colspan="2" ><li style="font:inherit"><a href="donacion_registro.cfm">Registro de donaciones</a></li></td></tr>
			<tr><td colspan="2" ><li><a href="donacion_listado.cfm">Listado de donaciones</a></li></td></tr>
			<tr><td colspan="2" ><li><a href="donacion_proyecto.cfm">Proyectos de donaciones</a></li></td></tr>
			<tr><td colspan="2"><li>Consultas</li></td></tr>
				<tr><td width="1%">&nbsp;</td><td><li style="clip:rect(auto, auto, auto, auto) "><a href="consultas/MejoresDonadores.cfm">Los diez mejores donadores</a></li></td></tr>
				<tr><td width="1%">&nbsp;</td><td><li><a href="consultas/DonacionProyecto.cfm">Donaciones por proyecto</a></li></td></tr>
				<tr><td width="1%">&nbsp;</td><td><li><a href="consultas/Donaciones.cfm?tipo=3">Gr&aacute;fica de donaciones</a></li></td></tr>
		</ul>
--->
	</table>
</cf_templatearea>
</cf_template>