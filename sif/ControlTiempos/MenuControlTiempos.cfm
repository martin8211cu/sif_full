<!-- InstanceBegin template="/Templates/LMenu03.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<!-- InstanceBeginEditable name="titulo" --> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle"><cfinclude template="portlets/pEmpresas2.cfm"></td>
          <td width="50%"> 
            <div align="center"><span class="superTitulo"><font size="5">Control de Tiempos</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
            <cfinclude template="jsMenuCT.cfm"></td>
        </tr>
        <tr> 
          <td></td>
          <td></td>
        </tr>
      </table>
      <!-- InstanceEndEditable -->
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
		<br>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td width="1%" valign="top">
					<!-- InstanceBeginEditable name="menu" -->
						<cfinclude template="/sif/menu.cfm">
					<!-- InstanceEndEditable -->
				</td>
			
				<td valign="top">
					<!-- InstanceBeginEditable name="mantenimiento" -->	
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Menú Principal de Control de Tiempos">
	 
			<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
			  <tr> 
				<td width="1%"><font size="2">&nbsp;</font></td>
				<td width="5%" nowrap><font size="2">&nbsp;</font></td>
				<td width="1%" align="right" valign="middle"> <div align="right"></div></td>
				<td width="31%" nowrap><font size="2">&nbsp;</font></td>
				<td width="4%">&nbsp;</td>
				<td width="1%">&nbsp;</td>
				<td width="5%">&nbsp;</td>
				<td width="0%"><div align="left"></div></td>
				<td width="1%" nowrap><font size="2">&nbsp;</font></td>
				<td width="9%">&nbsp;</td>
			  </tr>
			  <tr> 
				<td width="1%"><font size="2"><img src="../imagenes/Computer01_T2.gif"></font></td>
				<td width="5%" nowrap><font size="2"><strong>Operaci&oacute;n</strong>:</font></td>
				<td width="1%" align="right" valign="middle"> <div align="right"></div></td>
				<td nowrap><font size="2">&nbsp;</font></td>
				<td>&nbsp;</td>
				<td width="1%"><font size="2"><img src="../imagenes/Graficos02_T.gif"></font></td>
				<td width="5%" nowrap><font size="2"><strong>&nbsp;Consultas</strong>:</font></td>
				<td align="right" valign="middle"> <div align="left"></div></td>
				<td nowrap><font size="2">&nbsp;</font></td>
				<td>&nbsp;</td>
			  </tr>
			  <tr> 
				<td width="1%"><font size="2">&nbsp;</font></td>
				<td width="5%" nowrap><font size="2">&nbsp;</font></td>
				<td width="1%" align="right" valign="middle"> <div align="right"><a href="operacion/listaTiempos.cfm" ><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
				<td nowrap><font size="2"><a href="operacion/listaTiempos.cfm">Registro 
				  de Control de Tiempos</a></font></td>
				<td>&nbsp;</td>
				<td><font size="2">&nbsp;</font></td>
				<td nowrap><font size="2">&nbsp;</font></td>
				<td width="1%" align="center" valign="middle"> <div align="center"><a href="consultas/ActividadesXUsr.cfm"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
				<td nowrap><font size="2"><a href="consultas/ActividadesXUsr.cfm">Actividades 
				  por Recurso</a></font></td>
				<td>&nbsp;</td>
			  </tr>
			  <tr> 
				<td>&nbsp;</td>
				<td nowrap>&nbsp;</td>
				<td align="right" valign="middle">&nbsp;</td>
				<td nowrap><font size="2">&nbsp;</font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td nowrap><font size="2">&nbsp;</font></td>
				<td width="1%" align="center" valign="middle"> <div align="center"><a href="consultas/ReportesFXUsr.cfm"><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
				<td nowrap><font size="2"><a href="consultas/ReportesFXUsr.cfm">Reportes 
				  Faltantes por Resurso</a></font></td>
				<td>&nbsp;</td>
			  </tr>
			  <tr> 
				<td>&nbsp;</td>
				<td nowrap>&nbsp;</td>
				<td align="right" valign="middle">&nbsp;</td>
				<td nowrap><font size="2">&nbsp;</font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td width="1%" align="center" valign="middle"> <div align="center"><a href="consultas/ChartHorasXPry.cfm"><img src="../imagenes/Recordset.gif" width="18" height="18" border="0" align="absmiddle"></a></div></td>
				<td nowrap><font size="2"><a href="consultas/ChartHorasXPry.cfm">An&aacute;lisis 
				  de Horas Acumuladas por Proyectos</a></font></td>
				<td>&nbsp;</td>
			  </tr>
			  <tr> 
				<td>&nbsp;</td>
				<td nowrap>&nbsp;</td>
				<td align="right" valign="middle">&nbsp;</td>
				<td nowrap><font size="2">&nbsp;</font></td>
				<td>&nbsp;</td>
				<td width="1%">&nbsp;</td>
				<td>&nbsp;</td>
				<td><div align="left"></div></td>
				<td nowrap>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
			  <tr> 
				<td>&nbsp;</td>
				<td nowrap>&nbsp;</td>
				<td align="right" valign="middle">&nbsp;</td>
				<td nowrap><font size="2">&nbsp;</font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td><div align="left"></div></td>
				<td nowrap>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
			  <tr> 
				<td width="1%"><font size="2">&nbsp;<img src="../imagenes/Reporte01_T.gif" width="31" height="31"></font></td>
				<td width="5%" nowrap><font size="2"><strong>&nbsp;Cat&aacute;logos</strong>:</font></td>
				<td width="1%" align="right" valign="middle"> <div align="right"></div></td>
				<td nowrap><font size="2">&nbsp;</font></td>
				<td>&nbsp;</td>
				<td width="1%">&nbsp;</td>
				<td width="5%">&nbsp;</td>
				<td><div align="left"></div></td>
				<td nowrap><font size="2">&nbsp;</font></td>
				<td>&nbsp;</td>
			  </tr>
			  <tr> 
				<td width="1%">&nbsp;</td>
				<td width="5%" nowrap><font size="2">&nbsp;</font></td>
				<td width="1%" align="right" valign="middle"> <div align="right"><a href="catalogos/Proyectos.cfm" ><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
				<td nowrap><font size="2"><a href="catalogos/Proyectos.cfm">Proyectos 
				  </a></font></td>
				<td>&nbsp;</td>
				<td width="1%">&nbsp;</td>
				<td width="5%">&nbsp;</td>
				<td><div align="left"></div></td>
				<td nowrap><font size="2">&nbsp;</font></td>
				<td>&nbsp;</td>
			  </tr>
			  <tr> 
				<td>&nbsp;</td>
				<td nowrap><font size="2">&nbsp;</font></td>
				<td align="right" valign="middle"> <div align="right"><a href="catalogos/Actividades.cfm" ><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
				<td nowrap><font size="2"><a href="catalogos/Actividades.cfm">Actividades 
				  </a></font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td><div align="left"></div></td>
				<td nowrap>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
			  <tr> 
				<td>&nbsp;</td>
				<td nowrap><font size="2">&nbsp;</font></td>
				<td align="right" valign="middle"> <div align="right"><a href="catalogos/Departamentos.cfm" ><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
				<td nowrap><font size="2"><a href="catalogos/Departamentos.cfm">Departamentos 
				  </a></font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td><div align="left"></div></td>
				<td nowrap>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
			  <tr> 
				<td width="1%">&nbsp;</td>
				<td width="5%" nowrap><font size="2">&nbsp;</font></td>
				<td width="1%" align="right" valign="middle"> <div align="right"><a href="catalogos/listaSocios.cfm" ><img src="../imagenes/ftv4doc.gif" width="24" height="22" border="0"></a></div></td>
				<td nowrap><font size="2"><a href="catalogos/listaSocios.cfm">Socios 
				  </a></font></td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td><div align="left"></div></td>
				<td nowrap>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
			  <tr> 
				<td>&nbsp;</td>
				<td nowrap>&nbsp;</td>
				<td align="right" valign="middle">&nbsp;</td>
				<td nowrap>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td><div align="left"></div></td>
				<td nowrap>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
			  <tr> 
				<td width="1%"><font size="2">&nbsp;</font></td>
				<td width="5%" nowrap><font size="2">&nbsp;</font></td>
				<td width="1%" align="right" valign="middle">&nbsp;</td>
				<td nowrap>&nbsp;</td>
				<td>&nbsp;</td>
				<td width="1%">&nbsp;</td>
				<td width="5%">&nbsp;</td>
				<td><div align="left"></div></td>
				<td nowrap><font size="2">&nbsp;</font></td>
				<td>&nbsp;</td>
			  </tr>
			  <tr> 
				<td width="1%"><font size="2">&nbsp;</font></td>
				<td nowrap>&nbsp;</td>
				<td align="right" valign="middle">&nbsp;</td>
				<td nowrap>&nbsp;</td>
				<td>&nbsp;</td>
				<td width="1%">&nbsp;</td>
				<td width="5%">&nbsp;</td>
				<td><div align="left"></div></td>
				<td nowrap><font size="2">&nbsp;</font></td>
				<td>&nbsp;</td>
			  </tr>
			</table>
		
		</cf_web_portlet>
	<!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->