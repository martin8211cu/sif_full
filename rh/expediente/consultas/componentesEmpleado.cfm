<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_RecursosHumanos"
Default="Recursos Humanos"
XmlFile="/rh/generales.xml"
returnvariable="LB_RecursosHumanos"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_DetalleDeComponentesPorEmpleado"
Default="Detalle de Componentes por Empleado"
returnvariable="LB_DetalleDeComponentesPorEmpleado"/>

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_DetalleDeComponentesPorEmpleado#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfoutput>
				<form method="get" name="form1" action="componentesEmpleado_report.cfm" onsubmit="return ValidaForm(this);" style="margin:0;" >
					<table width="98%" border="0" cellspacing="0" cellpadding="2" align="center">
						<tr>
							<td width="40%" valign="top">
								<table width="100%">
									<tr>
										<td valign="top">
											<cf_web_portlet_start border="true" titulo="#LB_DetalleDeComponentesPorEmpleado#" skin="info1">
										  		<div align="justify">
										  			<p>
													<cf_translate  key="LB_ReporteDeDetalleDeComponentesPorEmpleado">
														Reporte de Detalle de Componentes por Empleado. 
														El reporte muestra los componentes por rango de empleados, 
														el campo de "Empleado desde" es el empleado inicial del rango, 
														y el "Empleado hasta" es el empleado final del rango. 
														Los campos Empleado desde y Empleado hasta son obligatorios.
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
										<td align="right">
											<strong><cf_translate  key="LB_EmpleadoDesde">Empleado desde</cf_translate>:&nbsp;</strong>
										</td>
										<td colspan="3">
											<cf_rhempleado index=1 form="form1" ><!--- Edesde ---> <!--- validateCFid="true" --->
										</td>
									</tr>
									<tr>
										
										<td align="right">
											<strong><cf_translate  key="LB_EmpleadoHasta">Empleado hasta</cf_translate>:&nbsp;</strong>
										</td>
										<td>
											<cf_rhempleado  index=2 form="form1"><!--- Ehasta --->
										</td>
									
									</tr>
									<tr>
										<td align="right"><strong><cf_translate  key="LB_Formato">Formato</cf_translate>:&nbsp;</strong></td>
										<td colspan="3">
											<select name="formato">
												<option value="flashpaper"><cf_translate  key="LB_Flashpaper">Flashpaper</cf_translate></option>
												<option value="pdf"><cf_translate  key="LB_PDF">PDF</cf_translate></option>
												<option value="excel"><cf_translate  key="LB_Excel">Excel</cf_translate></option>
											</select>
										</td>
								    </tr>
									<tr>
										<td align="center" colspan="4">
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
										
											<input type="submit" name="Consultar" value="#BTN_Consultar#">
											<input type="reset" name="Limpiar" value="#BTN_Limpiar#">											
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
<script language="JavaScript" type="text/javascript">
	
	function ValidaForm(f) {
		var mens = "";
		if (f.DEidentificacion1 && f.DEidentificacion2) {
			if (f.DEidentificacion1.value == '') {
				mens = mens + "Debe seleccionar el Empleado desde. \n";
			}
			if (f.DEidentificacion2.value == '') {
				mens = mens + "Debe seleccionar el Empleado hasta. \n";
			}
			if (mens != "")
			{
				alert(mens);
				return false;
			}
			else return true;
			
		} 
		else 
		{
			return false;
		}
		
		return true;
	}
	
</script>