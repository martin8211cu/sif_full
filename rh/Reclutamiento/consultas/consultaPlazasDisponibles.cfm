
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="Consulta de Plazas Disponibles">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_ConsultadePlazas"
				Default="Consulta de Plazas Disponibles"
				returnvariable="LB_ConsultadePlazas"/> 
								
				
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_ConsultadePlazas#">
					<form name="form1" method="post" action="consultaPlazasDisponibles-resultado.cfm" style="margin:0;">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td width="5%">&nbsp;</td>
							<td width="40%" align="center" valign="top">
								<cf_web_portlet_start border="true" titulo="#LB_ConsultadePlazas#" skin="info1">
									<table width="100%" align="center">
										<tr><td><p>
										 <cf_translate  key="AYUDA_ReporteInformacionDetalladaDeConsultadePlazasDisponibles">
											Esta consulta despliega un listado de las plazas que se encuentran actualmente disponibles por centro funcional y/o puesto en un lapso de tiempo</cf_translate> 
										.</p></td></tr>
									</table>
								<cf_web_portlet_end>
							</td>
							<td colspan="2" valign="top">
								<table width="100%" align="center" cellpadding="2" cellspacing="0" >
						
						<tr>
					
											
				<!--- Filtro de Centro Funcionales --->
							<tr>
						
								</tr>			
	
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Curso"><b>Centro Funcional</b></cf_translate>:&nbsp;</td>
										<td><cf_rhcfuncional tabindex="1"></td>
									</tr>
				<!--- Fin Filtro de centro funcionales --->		
	
				
									<!--- INCLUIR DEPENDENCIAS------------------------------>
									
									
		</tr>
		<tr>
			<td nowrap width="35%" align="right" ></td>
			<td nowrap width="65%" >
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%" valign="middle">
							<input type="checkbox" name="dependencias" tabindex="1">
						</td>
						<td valign="middle">
							<cf_translate key="LB_Incluir_Dependencias">Incluir Dependencias</cf_translate>&nbsp;</label></td>
					</tr>
				</table>
			</td>
		</tr>
	<tr>
					<!--- Fin de INCLUIR DEPENDENCIAS------------------------------>
								
								
												
				<!--- Puestos de Centro Funcionales --->
							<tr>
						
								</tr>			
	
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Curso"><b>Puesto</b></cf_translate>:&nbsp;</td>
										<td> <cf_rhpuesto tabindex="1" name="RHPpuesto"></td>
									</tr>
				<!--- Fin Puesto de centro funcionales --->	
				
					
									<tr>
									
									<!--- Filtro de fechas--->
										<tr><td nowrap align="right"> <strong> <cf_translate  key="LB_FechaDesde">Desde</cf_translate> :&nbsp;</strong></td>
			<td><cf_sifcalendario form="form1" tabindex="1" name="FechaDesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" ></td></tr>
	<tr>
				<td nowrap align="right"> <strong> <cf_translate  key="LB_FechaHasta">Hasta</cf_translate> :&nbsp;</strong></td>
			<td><cf_sifcalendario form="form1" tabindex="1" name="FechaHasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" ></td>
									</tr>
									
									<!--- fin de filtro de fechas--->
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
				<cf_web_portlet_end>
			</td></tr>
		</table>
<cf_templatefooter>



