<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_EvaluacionesPorCentroFuncional" default="Evaluaciones por Centro Funcional" returnvariable="LB_EvaluacionesPorCentroFuncional" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Consultar"default="Consultar" returnvariable="BTN_Consultar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="MSG_SePresentaronLosSiguientesErrores" default="Se presentaron los siguientes errores" returnvariable="MSG_SePresentaronLosSiguientesErrores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_ElCampoCentroFuncionalEsRequerido" default="El campo Centro Funcional es requerido." returnvariable="MSG_ElCampoCentroFuncionalEsRequerido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_ElcampoEvaluacionesRequerido." default="El campo Evaluación es requerido." returnvariable="MSG_ElcampoEvaluacionesRequerido" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">

	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_EvaluacionesPorCentroFuncional#">
				<form name="form1" method="get" action="evaluacion-cf.cfm" style="margin:0; " onsubmit="javascript: return validar(this);">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr>
						<td width="5%">&nbsp;</td>
						<td width="50%" align="center" valign="top">
							<cf_web_portlet_start border="true" titulo="#LB_EvaluacionesPorCentroFuncional#" skin="info1">
								<table width="100%" align="center">
									<tr><td><p><cf_translate key="AYUDA_EstaConsultaMuestraUnListadoDeLosColaboradoresAsocioadosALaRelacion">Esta consulta muestra un listado de los colaboradores asociados a la Relaci&oacute;n de Evaluaci&oacute;n y Centro funcional seleccionado.<br>Los campos Relaci&oacute;n de Evaluaci&oacute;n y Centro Funcional son requeridos por la consulta.</cf_translate></p></td></tr>
								</table>
							<cf_web_portlet_end>
						</td>
						<td colspan="2" valign="top">
							<table width="90%" align="center" cellpadding="2" cellspacing="0">
								<tr>
									<td width="10%" align="right" nowrap ><cf_translate key="LB_Evaluacion" XmlFile="/rh/generales.xml">Evaluaci&oacute;n</cf_translate>:&nbsp;</td>
									<td><cf_rhevaluacion size="60" tabindex="1" tipo="1"></td>
								</tr>
								<tr>
									<td width="10%" align="right" nowrap ><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</td>
									<td ><cf_rhcfuncional tabindex="1"></td>
								</tr>
								<tr>
									<td nowrap width="35%" align="right" ></td>
									<td nowrap width="65%" >
										<table width="100%" cellpadding="0" cellspacing="0">
											<tr>
												<td width="1%" valign="middle">
													<input type="checkbox" name="dependencias" id="dependencias" tabindex="1">
												</td>
												<td valign="middle">
													<label for="dependencias" style="font-style:normal; font-variant:normal; font-weight:normal">
													<cf_translate key="LB_Incluir_Dependencias">Incluir Dependencias</cf_translate>&nbsp;
													</label>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td width="10%" align="right" nowrap ><cf_translate key="LB_Formato" XmlFile="/rh/generales.xml">Formato</cf_translate>:&nbsp;</td>
									<td>
										<select name="formato" tabindex="1">
											<option value="flashpaper"><cf_translate key="LB_Flashpaper" XmlFile="/rh/generales.xml">Flashpaper</cf_translate></option>
											<option value="pdf"><cf_translate key="LB_PDF" XmlFile="/rh/generales.xml">PDF</cf_translate></option>
											<option value="excel"><cf_translate key="LB_Excel" XmlFile="/rh/generales.xml">Excel</cf_translate></option>
										</select>
									</td>
								</tr>
								<tr><td colspan="2" align="center"><input type="submit" name="Consultar" value="<cfoutput>#BTN_Consultar#</cfoutput>" tabindex="1"></td></tr>
							</table>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</table>
				</form>
				<!--- VARIABLES DE TRADUCCION --->
				<script language="javascript1.2" type="text/javascript">
					function validar(form){
						var mensaje = '';
						
						if ( form.RHEEdescripcion.value == '' ){
							mensaje += ' - <cfoutput>#MSG_ElcampoEvaluacionesRequerido#</cfoutput>\n';
						}
						if ( form.CFcodigo.value == '' ){
							mensaje += ' - <cfoutput>#MSG_ElCampoCentroFuncionalEsRequerido#</cfoutput>\n';
						}

						if ( mensaje != '' ){
							mensaje = '<cfoutput>#MSG_SePresentaronLosSiguientesErrores#</cfoutput>:\n' + mensaje;
							alert(mensaje);
							return false;
						}
						
						return true;
						
					}
				</script>
				
				
			<cf_web_portlet_end>
		</td></tr>
	</table>
<cf_templatefooter>