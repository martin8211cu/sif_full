<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CompetenciasPorPuesto" Default="Competencias por Puesto" returnvariable="LB_CompetenciasPorPuesto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteDeCompetenciasPorPuesto" Default="Reporte de Competencias por Puesto" returnvariable="LB_ReporteDeCompetenciasPorPuesto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BNT_Generar" Default="Generar" returnvariable="BNT_Generar"/>
<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_ReporteDeCompetenciasPorPuesto#'>		
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<cfoutput>
		<table width="100%" cellpadding="1" cellspacing="0">
			<tr>
				<!----Titulo--->
				<td width="40%" valign="top">
					<cf_web_portlet_start titulo="#LB_CompetenciasPorPuesto#">
						<p><br><cf_translate key="LB_EsteReporteDeCompetenciasGeneraElTipoDeCompetenciaUnHTML">
							Este reporte permite generar por puesto y tipo de competencia (habilidades o conocimientos) seleccionada, 
							un listado de los pesos asignados.  Este reporte puede ser exportado a excel o ser impreso.
						</cf_translate></p><br>
					<cf_web_portlet_end>
				</td>
				<!----Filtros--->
				<td width="60%" valign="top">
					<form method="post" name="form1" action="ExportarHabilidades-form.cfm">
						<table width="100%" border="0" cellspacing="1" cellpadding="0">				
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td width="34%" align="right" nowrap><b><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:</b>&nbsp;</td>
								<td width="66%">
									<cf_rhcfuncional size="30" tabindex="1">
							  </td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>
									<input type="checkbox" name="dependencias">
									<cf_translate  key="LB_IncluyeDependencias">Incluye Dependencias</cf_translate>
								</td>
							</tr>	
							<tr>
								<td align="right"><b><cf_translate  key="LB_Puesto">Puesto</cf_translate>:</b>&nbsp;</td>
								<td>
									<cf_rhpuesto tabindex="1">
								</td>											
							</tr>
							<tr>
								<td align="right"><b><cf_translate  key="LB_TipoDeCompetencia">Tipo de Competencia</cf_translate>:</b>&nbsp;</td>
								<td>
									<select name="tipocompetencia">
										<option id="0" value="0"><cf_translate key="LB_Todos">Todos</cf_translate></option>
										<option id="1" value="1"><cf_translate key="LB_Habilidades">Habilidades</cf_translate></option>
										<option id="2" value="2"><cf_translate key="LB_Conocimientos">Conocimientos</cf_translate></option>
									</select>
								</td>
							</tr>	
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td colspan="2" align="center">
									<input name="btnFiltrar" class="btnFiltrar" type="submit" id="btnGenerar" value="#BNT_Generar#">
								</td>	
							</tr>
						</table>
					</form>				
				</td>
			</tr>
		</table>
		</cfoutput>	  				
	<cf_web_portlet_end>
<cf_templatefooter>