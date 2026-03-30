	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RespuestasDeUnaEvaluacion"
	Default="Respuestas de una evaluación"
	returnvariable="LB_RespuestasDeUnaEvaluacion"/>

<cf_templateheader title="#LB_RecursosHumanos#">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_RespuestasDeUnaEvaluacion#">
					<form name="form1" method="post" action="evaluacion-respuestas.cfm" style="margin:0; " onSubmit="javascript: return validar(this);">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td width="5%">&nbsp;</td>
							<td width="50%" align="center" valign="top">
								<cf_web_portlet_start border="true" titulo="#LB_RespuestasDeUnaEvaluacion#" skin="info1">
									<table width="100%" align="center">
										<tr><td><p>
										<cf_translate  key="Ayuda_EsteReporteMuestraLasRespuestasALasPreguntasQueSeLeRealizaronEnUnaDeterminadaEvaluacion">
											Este reporte muestra las respuestas a las preguntas que se le realizaron en una determinada evaluación			
										</cf_translate>
										</p></td></tr>
									</table>
								<cf_web_portlet_end>
							</td>
							<td colspan="2" valign="top">
								<table width="90%" align="center" cellpadding="2" cellspacing="0">
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Evaluacion">Evaluaci&oacute;n</cf_translate>:&nbsp;</td>
										<td ><cf_rhevaluacion size="60" Cerradas = "S"></td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Empleado">Empleado</cf_translate>:&nbsp;</td>
										<td ><cf_rhempleadoscap></td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Tipo">Tipo</cf_translate>:&nbsp;</td>
										<td >
											<select name="cual" onchange="javascript:cambio_evaluador(this.value);" >
												<option value="A"><cf_translate  key="LB_Autoevaluacion">Autoevaluaci&oacute;n</cf_translate></option>
												<option value="J"><cf_translate  key="LB_Jefe">Jefe</cf_translate></option>
												<option value="O"><cf_translate  key="LB_Otros">Otros</cf_translate></option>
											</select>
										</td>
									</tr>
									
									<tr id="id_otros">
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Evaluador">Evaluador</cf_translate></td>
										<td>
											<select name="DEidotro">
											</select>
										</td>
									</tr>

									<tr>
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Consultar"
										Default="Consultar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Consultar"/>
										
										<td colspan="2" align="center">
											<input type="submit" name="Consultar" value="<cfoutput>#BTN_Consultar#</cfoutput>">
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					</form>
					
					<script language="javascript1.2" type="text/javascript">
						function validar(form){
							var mensaje = '';
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="MSG_ElCampoEvaluacionEsRequerido"
							Default="El campo Evaluación es requerido"
							returnvariable="MSG_ElCampoEvaluacionEsRequerido"/>
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="MSG_ElCampoEmpleadoEsRequerido"
							Default="El campo Empleado es requerido"
							returnvariable="MSG_ElCampoEmpleadoEsRequerido"/>
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="MSG_SePresentaronLosSiguientesErrores"
							Default="Se presentaron los siguientes errores"
							returnvariable="MSG_SePresentaronLosSiguientesErrores"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="MSG_Para_mostrar_el_listado_de_otros_evaluadores_debe_seleccionar_la_Relacion_de_Evaluacion_y_el_Empleado"
							Default="Para mostrar el listado de otros evaluadores debe seleccionar la Relacion de Evaluacion y el Empleado"
							returnvariable="MSG_mensaje1"/>
														
							<cfoutput>
							if ( form.RHEEdescripcion.value == '' ){
								mensaje += ' - #MSG_ElCampoEvaluacionEsRequerido#.\n';
							}
							if ( form.DEid.value == '' ){
								mensaje += ' - #MSG_ElCampoEmpleadoEsRequerido#.\n';
							}

							if ( mensaje != '' ){
								mensaje = '#MSG_SePresentaronLosSiguientesErrores#:\n' + mensaje;
								alert(mensaje);
								return false;
							}
							</cfoutput>
							return true;
						}
						
						function cambio_evaluador( valor ){
							document.getElementById('id_otros').style.display = 'none';
							document.form1.DEidotro.length = 0;
							if ( valor == 'O' ){
								if ( document.form1.DEid.value != '' && document.form1.RHEEid.value != ''){
									document.getElementById('id_otros').style.display = '';
									document.getElementById('iframe_evaluador').src = 'evaluacion-respuestas-frame.cfm?DEid='+ document.form1.DEid.value + '&RHEEid='+ document.form1.RHEEid.value;
								}
								else{
									document.form1.cual.value = 'A';
									alert('<cfoutput>#MSG_mensaje1#</cfoutput>');
								}
							}
						}
						cambio_evaluador( document.form1.cual.value  );
					</script>
				<cf_web_portlet_end>
			</td></tr>
		</table>
		<iframe id="iframe_evaluador" name="iframe_evaluador" width="0" height="0" frameborder="0" style="visibility:hidden;" ></iframe>
<cf_templatefooter>