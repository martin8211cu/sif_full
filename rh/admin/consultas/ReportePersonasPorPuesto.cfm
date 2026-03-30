<!--- -------------------------------------- --->
<!--- Archivo: 	ReportePersonasPorPuesto.cfm --->
<!--- Hecho:	Randall Colomer Villalta     --->
<!--- Fecha:	17 Mayo del 2005             --->
<!--- -------------------------------------- --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_ConsultaDePersonasPorPuesto"
			Default="Consulta de Personas por Puesto"
			returnvariable="LB_ConsultaDePersonasPorPuesto"/>
	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_ConsultaDePersonasPorPuesto#'>		
			<!--- Inicia el pintado de la pantalla --->
			<cfoutput>
				<form name="form1" method="get" action="ReportePersonasPorPuesto-filtro.cfm" >
					<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
						<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr>
							<!--- Pinta el comentario de lo que hace el reporte --->
							<td width="45%">
								<table width="95%" border="0" cellspacing="0" cellpadding="1" align="center">
									<tr>
										<td>
											<cf_web_portlet_start border="true" titulo="#LB_ConsultaDePersonasPorPuesto#" skin="info1">
												<p align="justify"> 
													<cf_translate key="LB_EsteReporteMuestranLosPuestosDeCadaPersonaPorCentroFuncionalSeaQueMuestreTodosLosCentrosFuncionalesConSusPersonasAsociadasOHacerUnFiltroDelCentroFuncionalQueDeseaVer">
													&Eacute;ste reporte muestran los puestos de cada persona por centro funcional. 
													Sea que muestre todos los centros funcionales con sus personas asociadas o hacer un filtro 
													del centro funcional que desea ver.
													</cf_translate>
													</p>
											<cf_web_portlet_end> 
										</td>
									</tr>
								</table>
							</td>
							<!--- Pinta los campos de centro funcional del reporte --->
							<td width="55%">
								<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center">
									<tr><td colspan="2">&nbsp;</td></tr>				
									<tr>
										<td nowrap width="35%" align="right" ><strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:</strong>&nbsp;</td>
										<td nowrap width="65%" ><cf_rhcfuncional tabindex=1></td>
									</tr>

									<tr>
										<td nowrap width="35%" align="right" ><strong><cf_translate key="LB_Puesto" xmlfile="/rh/generales.xml">Puesto</cf_translate>:</strong>&nbsp;</td>
										<td nowrap width="65%" ><cf_rhpuesto tabindex="1"></td>
									</tr>

									<tr>
										<td nowrap width="35%" align="right" ></td>
										<td nowrap width="65%" >
											<table width="100%" cellpadding="0" cellspacing="0">
												<tr>
													<td width="1%" valign="middle"><input type="checkbox" name="dependencias" /></td>
													<td valign="middle"><strong><cf_translate key="LB_Incluir_Dependencias">Incluir Dependencias</cf_translate></strong>&nbsp;</td>
												</tr>
											</table>
										</td>
									</tr>

									<tr><td colspan="2">&nbsp;</td></tr>
									<tr>
							  			<td colspan="2" align="center">
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												Key="BTN_Consultar"
												Default="Consultar"
												XmlFile="/rh/generales.xml"
												returnvariable="BTN_Consultar"/>
											
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												Key="BTN_Limpiar"
												Default="Limpiar"
												XmlFile="/rh/generales.xml"
												returnvariable="BTN_Limpiar"/>
											<input name="Consultar" type="submit" value="#BTN_Consultar#" id="Consultar" tabindex="1">
											<input name="Limpiar" type="reset" value="#BTN_Limpiar#" tabindex="1">
										</td>
									</tr>
									<tr><td colspan="2">&nbsp;</td></tr>
								</table>
							</td>
						</tr>
					</table>
					<input type="hidden" name="regresar" value="/rh/admin/consultas/ReportePersonasPorPuesto.cfm" > 
		 		</form>
		 	</cfoutput>
			<!--- Finaliza el pintado de la pantalla --->
		<cf_web_portlet_end>
<cf_templatefooter>	