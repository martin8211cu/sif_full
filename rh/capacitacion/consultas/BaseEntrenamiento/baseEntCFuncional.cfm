<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">

		<cf_templatecss>
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_BaseEntrenamientoPorCentroFuncional"
				Default="Base entrenamiento por Centro Funcional"
				returnvariable="LB_BaseEntrenamientoPorCentroFuncional"/> 
								
				
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_BaseEntrenamientoPorCentroFuncional#">
					<form name="form1" method="get" action="baseEntCFuncional-form.cfm" style="margin:0; " onSubmit="javascript: return validar(this);">
					<table width="100%" border="0" cellpadding="2" cellspacing="1">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr>
							<td width="40%" align="center" valign="top">
								<cf_web_portlet_start border="true" titulo="#LB_BaseEntrenamientoPorCentroFuncional#" skin="info1">
									<table width="100%" align="center">
										<tr><td><p>
										<cf_translate  key="AYUDA_DetallaraLasCapacitacionesRecibidasPorLosFuncionariosDuranteUnPeriodoDeTiempoEstablecido">
											Detallar&aacute; las capacitaciones recibidas por los funcionarios <br>durante un per&iacute;odo de tiempo establecido
										</cf_translate>
										</p></td></tr>
									</table>
								<cf_web_portlet_end>
							</td>
							<td colspan="2" valign="top">
								<table width="90%" align="center" cellpadding="1" cellspacing="0">
									<tr>
										<td nowrap colspan="2" ><strong><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate></strong></td>
									</tr>
									<tr>
										<td colspan="2">
											<table>
												<tr>											
													<td nowrap><cf_rhcfuncional></td>
													<td><input type="checkbox" name="chkDep" value="" id="chkDep"></td>
													<td nowrap="nowrap"><label><cf_translate  key="LB_IncluirDependencias">Incluir dependencias</cf_translate></label></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td nowrap  ><strong><cf_translate  key="LB_Puesto">Tipo de Curso</cf_translate></strong></td>
										<td nowrap ><strong><cf_translate  key="LB_Puesto">Puesto</cf_translate></strong></td>										
									</tr>
									<tr>
										<td>
											<select name="tipo">
												<option value=""><cf_translate  key="LB_Todos">Todos</cf_translate></option>
												<option value="0"><cf_translate  key="LB_Internos" >Internos</cf_translate></option>
												<option value="1"><cf_translate  key="LB_Externos" >Externos</cf_translate></option>
											</select>
										</td>
										<td><cf_rhpuesto></td>
									</tr>
									<tr>
										<td nowrap colspan="2"><strong><cf_translate  key="LB_Empleado">Empleado</cf_translate></strong></td>
									</tr>

									<tr>
										<td colspan="2"><cf_rhempleado size="40"></td>
									</tr>

									<tr>
										<td colspan="2">
											<table width="100%" cellpadding="0" cellspacing="0">
												<tr>
													<td nowrap ><strong><cf_translate  key="LB_Desde">Desde</cf_translate></strong></td>
													<td nowrap ><strong><cf_translate  key="LB_Hasta">Hasta</cf_translate></strong></td>
												</tr>
												<tr>													
													<td><cf_sifcalendario name="RHCfdesde"></td>
													<td><cf_sifcalendario name="RHCfhasta"></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td nowrap colspan="2" ><strong><cf_translate  key="LB_Formato">Formato</cf_translate></strong></td>
									</tr>
									<tr>
										<td>
											<select name="formato">
												<option value="flashpaper"><cf_translate  key="LB_Flashpaper">Flashpaper</cf_translate></option>
												<option value="pdf"><cf_translate  key="LB_PDF">PDF</cf_translate></option>
												<option value="excel"><cf_translate  key="LB_Excel">Excel</cf_translate></option>
											</select>
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
												<input type="submit" name="Consultar" value="#BTN_Consultar#">&nbsp;
												<input type="reset" name="btnLimpiar" value="#BTN_Limpiar#">
											</cfoutput>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					</form>
					
					<script language="javascript1.2" type="text/javascript">
						function validar(form){	}
					</script>
				<cf_web_portlet_end>
			</td></tr>
		</table>
<cf_templatefooter>