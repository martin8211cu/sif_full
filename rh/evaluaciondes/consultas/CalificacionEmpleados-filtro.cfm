<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
	<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js" type="text/javascript"></script>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_CalificacionesDeEmpleados"
		Default="Calificaciones de Empleados"
		returnvariable="LB_CalificacionesDeEmpleados"/>
	
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_CalificacionesDeEmpleados#">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_DebeSeleccionarLaFechaDesdeYLaFechaHasta"
			Default="Debe seleccionar la fecha desde y la fecha hasta"
			returnvariable="MSG_DebeSeleccionarLaFechaDesdeYLaFechaHasta"/>
		<script type="text/javascript" language="javascript1.2">								
			function funcValidaciones(){
				if (document.form1.desde.value =='' || document.form1.hasta.value ==''){
					alert("<cfoutput>#MSG_DebeSeleccionarLaFechaDesdeYLaFechaHasta#</cfoutput>");
					return false;
				}
				return true;
			}
		</script>
		<table width="100%" border="0" cellspacing="0">			  
			<tr><td valign="top"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
		  	<tr><td>&nbsp;</td></tr>
		  	<tr>
				<td valign="top">
					<form name="form1" action="CalificacionEmpleados.cfm" method="get" 
						onsubmit="javascript: return funcValidaciones();">
						<table width="100%" cellpadding="1" cellspacing="0">
							<tr>
								<td width="36%" valign="top">															
									<cf_web_portlet_start border="true" titulo="#LB_CalificacionesDeEmpleados#" skin="info1">
										<div align="justify">
										  <p><cf_translate key="AYUDA_ReporteDeCalificacionesDeEmpleadosEnUnPeriodoDado">Reporte de calificaciones de empleados en un per&iacute;odo dado.</cf_translate></p>
										</div>
									<cf_web_portlet_end>
								</td>
								<td width="64%">
									<table width="99%" cellpadding="1" cellspacing="0">
										<tr>
											<td width="63%" align="right"><strong><cf_translate key="LB_FechaDesde">Fecha desde</cf_translate>:&nbsp;</strong></td>
											<td width="37%">                            
												<cf_sifcalendario conexion="#session.DSN#" form="form1" name="desde" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1">
											</td>
										</tr>
										<tr>
											<td width="63%" align="right"><strong><cf_translate key="LB_FechaHasta">Fecha hasta</cf_translate>:&nbsp;</strong></td>
											<td width="37%">                            
												<cf_sifcalendario conexion="#session.DSN#" form="form1" name="hasta" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1">	
											</td>
										</tr>
										<tr>
											<td width="63%" align="right"><strong><cf_translate key="LB_CedulaDesde">C&eacute;dula desde</cf_translate>:&nbsp;</strong></td>
											<td width="37%">                            
												<cf_rhempleado size="30" form="form1" tabindex="1" index="1"  DEid="DEid_desde" DEidentificacion="identificacion_desde" Nombre="Nombre_desde" TipoId="-1" > 
											</td>
										</tr>
										<tr>
											<td width="63%" align="right"><strong><cf_translate key="LB_CedulaHasta">C&eacute;dula hasta</cf_translate>:&nbsp;</strong></td>
											<td width="37%">                            
												<cf_rhempleado size="30" form="form1" tabindex="1" index="2" DEid="DEid_hasta" DEidentificacion="identificacion_hasta" Nombre="Nombre_hasta" TipoId="-1" >	
											</td>
										</tr>
										<tr>
											<td width="63%" align="right">
												<input type="checkbox" name="chk_nota" tabindex="1" 
												onclick="javascript: if(this.checked){document.form1.nota_inferior.disabled = false;}else{document.form1.nota_inferior.value = ''; document.form1.nota_inferior.disabled = true;}"/>
											  <strong><cf_translate key="CHK_MostrarSoloConNotaInferiorA">Mostrar s&oacute;lo con nota inferior a</cf_translate>:&nbsp;</strong>												
											</td>
											<td>
												<input name="nota_inferior" onFocus="javascript:this.select();" type="text" tabindex="1" style="text-align:right" onBlur="javascript:fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="" size="6" maxlength="6">												
											</td>
										</tr>
										<tr>
											<td align="right"><strong><cf_translate key="LB_Formato" XmlFile="/rh/generales.xml">Formato</cf_translate>:&nbsp;</strong></td>
											<td>
												<select name="formato" tabindex="1">
													<option value="FlashPaper"><cf_translate key="LB_" XmlFile="/rh/generales.xml">FlashPaper</cf_translate></option>
													<option value="pdf"><cf_translate key="LB_AdobePDF" XmlFile="/rh/generales.xml">Adobe PDF</cf_translate></option>
													<option value="Excel"><cf_translate key="LB_MicrosoftExcel" XmlFile="/rh/generales.xml">Microsoft Excel</cf_translate></option>
												</select>
											</td>
										</tr>
										<tr><td>&nbsp;</td></tr>
										<tr>
											<td colspan="2" align="center">
												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="BTN_Consultar"
													Default="Consultar"
													XmlFile="/rh/generales.xml"
													returnvariable="BTN_Consultar"/>

												<input type="submit" tabindex="1" name="btn_consultar" value="<cfoutput>#BTN_Consultar#</cfoutput>" />
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</form>
				</td>
		  	</tr>
			<tr><td>&nbsp;</td></tr>
		</table>		
	<cf_web_portlet_end>
<cf_templatefooter>
