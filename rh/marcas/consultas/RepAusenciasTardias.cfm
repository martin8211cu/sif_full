<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_ReporteDeInconsistenciasDeMarcas" default="Reporte de Inconsistencias de Marcas" returnvariable="LB_ReporteDeInconsistenciasDeMarcas" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="MSG_FechaDesde" default="Fecha desde" returnvariable="MSG_FechaDesde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_FechaHasta" default="Fecha hasta" returnvariable="MSG_FechaHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_LaFechaHastaNoPuedeSerMayorALaFechaDesde" default="La fecha Hasta no puede ser mayor a la fecha Desde"	 returnvariable="MSG_LaFechaHastaNoPuedeSerMayorALaFechaDesde" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>
  	<cfinclude template="/rh/Utiles/params.cfm">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">	
  	<cfset Session.Params.ModoDespliegue = 1>
  	<cfset Session.cache_empresarial = 0>
	<cf_web_portlet_start border="true" titulo="#LB_ReporteDeInconsistenciasDeMarcas#" skin="#Session.Preferences.Skin#">				  
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">      			    
			<cfoutput>
				<form method="post" name="form1" action="RepAusenciasTardiasForm.cfm">
					<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td width="42%">
								<table width="100%">
									<tr>
										<td height="173" valign="top">																											
											<cf_web_portlet_start border="true" titulo="#LB_ReporteDeInconsistenciasDeMarcas#" skin="info1">
												<div align="justify">
												  <p>
												  <cf_translate  key="AYUDA_EsteReporteMuestraUnListadoDeInconsistenciasDeMarcasDeLosEmpleadosEnUnPeriodoDeterminadoDeTiempo">														  
													  Este reporte muestra un listado de Inconsistencias de Marcas de los empleados en un periodo determinado de tiempo
												  </cf_translate>
												  </p>
											</div>
										  <cf_web_portlet_end>							  
										</td>
									</tr>
							  </table>  
							</td>
							<td width="58%" valign="top">
								<table width="100%" cellpadding="0" cellspacing="0" align="center">										
									<tr><td align="center" colspan="3">&nbsp;</td></tr>		
									<tr>
										<td width="32%" align="right" nowrap><strong><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</strong></td>
										<td width="68%" colspan="3"><cf_rhcfuncional tabindex="1"></td>																				
								  	</tr>
								  	<tr>
										<td width="32%" align="right" nowrap><strong><cf_translate  key="LB_Empleado">Empleado</cf_translate>:&nbsp;</strong></td>
										<td width="68%" colspan="3"><cf_rhempleado tabindex="1"></td>																				
									</tr>
								  	<tr> 
										<td align="right"><strong><cf_translate  key="LB_Desde">Desde</cf_translate>:&nbsp;</strong></td>
										<td nowrap>
											<cfif isdefined("Form.fdesde")>
												<cfset fechaD = Form.fdesde>
												<cfelse>
												<cfset fechaD = "">
											</cfif>
											<cf_sifcalendario form="form1" value="#fechaD#" name="fdesde" tabindex="1">
										</td>
										<td align="right"><strong><cf_translate  key="LB_Hasta">Hasta</cf_translate>:&nbsp;</strong></td>
										<td nowrap>
											<cfif isdefined("Form.fhasta")>
												<cfset fechaH = Form.fhasta>
												<cfelse>
												<cfset fechaH = "">
											</cfif>
											<cf_sifcalendario form="form1" value="#fechaH#" name="fhasta" tabindex="1">
										</td>											
									</tr>
									<!--- 
										TIPOS DE MENSAJE PARA LA ENTRADA
										1 LLEGADA TIEMPO
										2 LLEGADA TARDE
										3 LLEGADA TEMPRANO
										4 LLEGADA TARDE EN SU DIA LIBRE
										5 LLEGADA TEMPRANO EN SU DIA LIBRE
										6 DIA LIBRE
										7 AUSENTE
										
										TIPOS DE MENSAJE PARA LA SALIDA
										1 A TIEMPO
										2 SALIDA TARDE
										3 SALIDA ANTICIPADA
										4 SALIDA TARDE EN SU DIA LIBRE
										5 SALIDA ANTICIPADA EN SU DIA LIBRE
										6 DIA LIBRE
										7 AUSENTE
									 --->
									<tr>
										<td align="right" nowrap><strong><cf_translate key="LB_SituacionDeIngreso">Situaci&oacute;n de Ingreso</cf_translate>:&nbsp;</strong></td>
										<td colspan="3">
											<select name="Ingreso" tabindex="1" style="width:200px">
												<option value="-1"><cf_translate key="CMB_Todas">Todas</cf_translate></option>
												<option value="1"><cf_translate key="CMB_LlegadaATiempo">Llegada a Tiempo</cf_translate></option>
												<option value="2"><cf_translate key="CMB_LlegadaTarde">Llegada Tarde</cf_translate></option>
												<option value="3"><cf_translate key="CMB_LlegadaTemprano">Llegada Temprano</cf_translate></option>
												<option value="4"><cf_translate key="CMB_LlegadaTardeEnSuDiaLibre">Llegada Tarde Día libre</cf_translate></option>
												<option value="5"><cf_translate key="CMB_LlegadaTempranoEnSuDiaLibre">Llegada Temprano Día libre</cf_translate></option>
												<option value="6"><cf_translate key="CMB_DiaLibre">D&iacute;a Libre</cf_translate></option>
												<option value="7"><cf_translate key="CMB_Ausente">Ausente</cf_translate></option>
											</select>
										</td>
									</tr>
									<tr>
										<td align="right" nowrap><strong><cf_translate key="LB_SituacionDeSalida">Situaci&oacute;n de Salida</cf_translate>:&nbsp;</strong></td>
										<td colspan="3">
											<select name="Salida" tabindex="1" style="width:200px">
												<option value="-1"><cf_translate key="CMB_Todas">Todas</cf_translate></option>
												<option value="1"><cf_translate key="CMB_SalidaATiempo">Salida a Tiempo</cf_translate></option>
												<option value="2"><cf_translate key="CMB_SalidaTarde">Salida Tarde</cf_translate></option>
												<option value="3"><cf_translate key="CMB_SalidaAnticipada">Salida Anticipada</cf_translate></option>
												<option value="4"><cf_translate key="CMB_SalidaTardeEnSuDiaLibre">Salida Tarde Día libre</cf_translate></option>
												<option value="5"><cf_translate key="CMB_SalidaTempranoEnSuDiaLibre">Salida Temprano Día libre</cf_translate></option>
												<option value="6"><cf_translate key="CMB_DiaLibre">D&iacute;a Libre</cf_translate></option>
												<option value="7"><cf_translate key="CMB_Ausente">Ausente</cf_translate></option>
											</select>
										</td>
									</tr>
									<tr>
										<td align="right" nowrap><strong><cf_translate key="LB_Ordenamiento">Ordenamiento</cf_translate>:&nbsp;</strong></td>
										<td colspan="3">
											<select name="Orden" tabindex="1" style="width:200px">
												<option value="1"><cf_translate key="CMB_Identificacion">Indentificaci&oacute;n</cf_translate></option>
												<option value="2"><cf_translate key="CMB_Nombre">Nombre</cf_translate></option>
											</select>
										</td>
									</tr>
									
									
									<tr><td align="center" colspan="3">&nbsp;</td></tr>										
									<tr>
										<td align="center" colspan="3">
											<cf_botones values="Generar,Limpiar" tabindex="1">
										</tr>
								</table>
							</td>
						</tr>
					</table>
				</form>
			</cfoutput>			    
			</td>	
		</tr>
	</table>	
	<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms>
	<cf_qformsrequiredfield args="fdesde,#MSG_FechaDesde#">
	<cf_qformsrequiredfield args="fhasta,#MSG_FechaHasta#">
</cf_qforms>
<script type="text/javascript" language="javascript1.2">
function funcValidaFechas(){
	var inicio = document.form1.fdesde.value.split('/');
	var fechainicio = inicio[2] + inicio[1] + inicio[0]
	var hasta = document.form1.fhasta.value.split('/');
	var fechafinal = hasta[2] + hasta[1] + hasta[0]
	if (fechainicio > fechafinal){
		<cfoutput>alert("#MSG_LaFechaHastaNoPuedeSerMayorALaFechaDesde#")</cfoutput>;
		document.form1.fdesde.value = '';
		document.form1.fhasta.value = '';
		return false;
	}				
	return true;
}
function funcGenerar(){
	return funcValidaFechas();
	
}
</script>