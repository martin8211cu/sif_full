<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_CompetenciasPorColaborador"
		Default="Competencias por Colaborador"
		returnvariable="LB_CompetenciasPorColaborador"/>
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_CompetenciasPorColaborador#">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td ><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
			<tr>
				<td>
					<table width="100%" cellpadding="2" cellspacing="0">
						<tr>
							<td width="50%" align="center" valign="top">
								<cf_web_portlet_start border="true" titulo="#LB_CompetenciasPorColaborador#" skin="info1">
									<table width="100%" align="center">
										<tr>
											<td><p>
											<cf_translate key="AYUDA_EstaConsultaMuestraLasCompetenciasQuePoseeUnEmpleado">Esta consulta muestra las competencias que posee un empleado y su porcentaje de dominio.<br>Adicionalmente la consulta muestra el progreso del colaborador para los planes de sucesi&oacute;n donde esta participando.</cf_translate></p></td></tr>
									</table>
								<cf_web_portlet_end>
							</td>
							
							<td valign="top">
								<form name="form1" method="post" action="competencias-empleado.cfm" onSubmit="return validar(this);">
								<table width="100%" align="center">
									<tr>
										<td align="right" valign="middle" nowrap="nowrap"><cf_translate key="LB_Colaborador">Colaborador</cf_translate>:&nbsp;</td>
										<td valign="middle" ><cf_rhempleado></td>
									</tr>
									<tr>
										<td></td>
										<td><table width="100%" cellpadding="0" cellspacing="0">
												<tr><td width="1%" valign="middle"><input type="checkbox" name="plansucesion" value=""></td><td valign="middle">Mostrar progreso en planes de sucesi&oacute;n</td></tr>
											</table>
										</td>
									</tr>
									<tr>
										<td></td>
										<td align="center">
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												Key="BTN_Consultar"
												Default="Consultar"
												XmlFile="/rh/generales.xml"
												returnvariable="BTN_Consultar"/>
											<cfoutput>
											<input type="submit" name="Consultar" value="#BTN_Consultar#">
											</cfoutput>
										</td>
									</tr>
								</table>
								</form>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ElCampoEmpleadoEsRequerido"
			Default="El campo Empleado es requerido."
			returnvariable="MSG_ElCampoEmpleadoEsRequerido"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_SePresentaronLosSiguientesErrores"
			Default="Se presentaron los siguientes errores"
			returnvariable="MSG_SePresentaronLosSiguientesErrores"/>

		<script language="javascript1.2" type="text/javascript">
			function validar(form){
				var mensaje = '';
				
				if ( form.DEid.value == '' ){
					mensaje += ' - <cfoutput>#MSG_ElCampoEmpleadoEsRequerido#</cfoutput>\n';
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
<cf_templatefooter>