<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_ReporteDeHorasDeCapacitacion"
				Default="Reporte de horas de capacitación"
				returnvariable="LB_ReporteDeHorasDeCapacitacion"/> 
								
				
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_ReporteDeHorasDeCapacitacion#">
					<form name="form1" method="get" action="Rep_HorasCapacitacion-form.cfm" style="margin:0; " onSubmit="javascript: return validar(this);">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td width="5%">&nbsp;</td>
							<td width="40%" align="center" valign="top">
								<cf_web_portlet_start border="true" titulo="#LB_ReporteDeHorasDeCapacitacion#" skin="info1">
									<table width="100%" align="center">
										<tr><td><p>
										<cf_translate  key="AYUDA_ReporteDeHorasDeCapacitacion">
											Muestra el total de horas que ha recibido por capacitación, este este reporte se puede ver de dos maneras resumido (horas de capacitación por centro funcional) y detallado (horas de capacitación por empleado)
										</cf_translate>
										.</p></td></tr>
									</table>
								<cf_web_portlet_end>
							</td>
							<td colspan="2" valign="top">
								<table width="100%" align="center" cellpadding="2" cellspacing="0" >
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:</td>
										<td>
											<table cellpadding="0" cellspacing="0">
												<tr>											
													<td nowrap><cf_rhcfuncional tabindex="1"></td>
													<td><input type="checkbox" name="chkDep" tabindex="1" value="" id="chkDep"><label for="chkDep" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate  key="LB_IncluirDependencias">Incluir dependencias</cf_translate></label></td>
												</tr>
											</table>
										</td>
									</tr>

									<tr>
										<td nowrap  align="right" ><cf_translate  key="LB_Puesto">Tipo de Curso</cf_translate></td>
										<td>
											<select name="tipo">
												<option value=""><cf_translate  key="LB_Todos">Todos</cf_translate></option>
												<option value="0"><cf_translate  key="LB_Internos" >Internos</cf_translate></option>
												<option value="1"><cf_translate  key="LB_Externos" >Externos</cf_translate></option>
											</select>
										</td>
									</tr>

									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Puesto">Puesto</cf_translate>&nbsp;:</td>
										<td><cf_rhpuesto tabindex="1"></td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Empleado">Empleado</cf_translate>&nbsp;:</td>
										<td><cf_rhempleado size="50" tabindex="1"></td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Desde">Desde</cf_translate>&nbsp;:</td>
										<td>
											<table width="100%" cellpadding="0" cellspacing="0">
												<tr>													
													<td><cf_sifcalendario name="RHCfdesde" tabindex="1"></td>
													<td width="10%" align="right" nowrap >
														<cf_translate  key="LB_Hasta">Hasta</cf_translate>&nbsp;:
													</td>
													<td><cf_sifcalendario name="RHCfhasta" tabindex="1"></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Formato">Formato</cf_translate>&nbsp;:</td>
										<td>
											<select name="formato" tabindex="1">
												<option value="flashpaper"><cf_translate  key="LB_Flashpaper">Flashpaper</cf_translate></option>
												<option value="pdf"><cf_translate  key="LB_PDF">PDF</cf_translate></option>
												<option value="excel"><cf_translate  key="LB_Excel">Excel</cf_translate></option>
											</select>
										</td>
									</tr>
									<tr>
										<td></td>
										<td>
											<table width="35%" cellpadding="0" cellspacing="0">
												<tr>
													<td width="1%" valign="middle"><input type="radio" checked value="R" name="resumido" tabindex="1" id="R"></td>
													<td valign="middle"><label for="R" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate  key="LB_Resumido">Resumido</cf_translate></label></td>
													<td width="1%" valign="middle"><input type="radio" value="D" name="resumido" tabindex="1"></td>
													<td valign="middle"><label for="D" style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate  key="LB_Detallado">Detallado</cf_translate></label></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td align="center" colspan="2">
											<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="BTN_Limpiar"
											Default="Limpiar"
											XmlFile="/rh/generales.xml"
											returnvariable="BTN_Limpiar"/>
											
											<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="BTN_Consultar"
											Default="Consultar"
											XmlFile="/rh/generales.xml"
											returnvariable="BTN_Consultar"/>
										
											<cfoutput>
												<input type="submit" name="Consultar" value="#BTN_Consultar#" tabindex="1">&nbsp;
												<input type="reset" name="btnLimpiar" value="#BTN_Limpiar#" tabindex="1">
											</cfoutput>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					</form>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_SePresentaronLosSiguientesErrores"
					Default="Se presentaron los siguientes errores"
					XmlFile="/rh/generales.xml"
					returnvariable="MSG_SePresentaronLosSiguientesErrores"/>
					
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_ElCampoFechaDesdeEsRequerido"
					Default="El campo fecha desde es requerido"
					returnvariable="MSG_ElCampoFechaDesdeEsRequerido"/>
					
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_ElCampoFechaHastaEsRequerido"
					Default="El campo fecha hasta es requerido"
					returnvariable="MSG_ElCampoFechaHastaEsRequerido"/>

					
					
					<script language="javascript1.2" type="text/javascript">
						<cfoutput>
						function validar(form){
							var mensaje = '';
							if ( form.RHCfdesde.value == '' ){
								mensaje += ' - #MSG_ElCampoFechaDesdeEsRequerido#.\n';
							}
							if ( form.RHCfhasta.value == '' ){
								mensaje += ' - #MSG_ElCampoFechaHastaEsRequerido#.\n';
							}
							if ( mensaje != '' ){
								mensaje = '#MSG_SePresentaronLosSiguientesErrores#:\n' + mensaje;
								alert(mensaje);
								return false;
							}
							
							return true;
						}
						</cfoutput>
					</script>
				<cf_web_portlet_end>
			</td></tr>
		</table>
<cf_templatefooter>
<script>
	document.form1.CFcodigo.focus();
</script>