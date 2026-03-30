	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteDeAnotaciones"
	Default="Reporte de Anotaciones"
	returnvariable="LB_ReporteDeAnotaciones"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_ReporteDeAnotaciones#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfoutput>
				<form method="get" name="form1" action="Anotaciones-report.cfm" style="margin:0;" >
					<table width="98%" border="0" cellspacing="0" cellpadding="2" align="center">
						<tr>
							<td width="40%" valign="top">
								<table width="100%">
									<tr>
										<td valign="top">
											<cf_web_portlet_start border="true" titulo="#LB_ReporteDeAnotaciones#" skin="info1">
										  		<div align="justify">
										  			<p>
													<cf_translate key="AYUDA_ReporteParaRevisarLasAnotacionesQueSeHanHechoACadaEmpleadoPorCentroFuncionalParaUnRangoDeFechas">
													Reporte para revisar las Anotaciones que se han hecho a cada Empleado por Centro Funcional para un Rango de Fechas
													</cf_translate>
													</p>
												</div>
											<cf_web_portlet_end>
										</td>
									</tr>
								</table>  
							</td>
							<td valign="top">
								<table width="100%" cellpadding="2" cellspacing="2" align="center">
									<tr>
										<td align="right" nowrap>
											<strong><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</strong>
										</td>
										<td colspan="3">
											<cf_rhcfuncional form="form1" tabindex="1">
										</td>
									</tr>
									<tr>
										<td>&nbsp;</td>
										<td align="right" valign="middle">
											<table width="100%" cellpadding="0" cellspacing="0">
											<tr>
												<td width="1%" valign="middle"><input type="checkbox" name="dependencias" id="dependencias" tabindex="1"></td>
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
										<td align="right">
											<strong><cf_translate key="LB_Empleado">Empleado</cf_translate>:&nbsp;</strong>
										</td>
										<td colspan="3">
											<cf_rhempleado form="form1" size="40" validateCFid="true" tabindex="1">
										</td>
									</tr>
									<tr>
										<td align="right">
											<strong><cf_translate key="LB_FechaDesde">Fecha Desde</cf_translate>:&nbsp;</strong>
										</td>
										<td>
											<cf_sifcalendario form="form1" name="Fdesde" tabindex="1">
										</td>
										<td align="right">
											<strong><cf_translate key="LB_FechaHasta">Fecha Hasta</cf_translate>:&nbsp;</strong>
										</td>
									    <td>
											<cf_sifcalendario form="form1" name="Fhasta" tabindex="1">
										</td>
									</tr>
									<tr>
										<td align="right"><strong><cf_translate key="LB_Formato">Formato</cf_translate>:&nbsp;</strong></td>
										<td colspan="3">
											<select name="formato" tabindex="1">
												<option value="flashpaper"><cf_translate key="CMB_Flashpaper">Flashpaper</cf_translate></option>
												<option value="pdf"><cf_translate key="CMB_PDF">PDF</cf_translate></option>
												<option value="excel"><cf_translate key="CMB_Excel">Excel</cf_translate></option>
											</select>
										</td>
								    </tr>
									<tr>
										<td align="center" colspan="4">
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
										
											<input type="submit" name="Consultar" value="#BTN_Consultar#" tabindex="1">
											<input type="reset" name="Limpiar" value="#BTN_Limpiar#" tabindex="1" onClick="javascript: document.form1.DEid.value='';">
										</td>
									</tr>
									<tr>
										<td colspan="4">&nbsp;</td>
									</tr>
								</table>
							</td>	
						</tr>
					</table>
				</form>
			</cfoutput>			
		<cf_web_portlet_end>
	<cf_templatefooter>

