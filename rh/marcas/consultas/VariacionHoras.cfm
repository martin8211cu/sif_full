<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<cf_templatecss>
<!--- <cfset vd_fechaFinal = DateAdd("d", 6, "#LSParseDateTime(form.fdesde)#")>	 --->
  <cfinclude template="/rh/Utiles/params.cfm">
  <cfset Session.Params.ModoDespliegue = 1>
  <cfset Session.cache_empresarial = 0>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">      			    
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_VariacionHoras"
				Default="Reporte Variaci&oacute;n horas vrs planificaci&oacute;n de horario"
				returnvariable="titulo"/>

			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_ListaDeEmpleados"
				Default="Lista de empleados"	
				returnvariable="LB_ListaDeEmpleados"/>	
			
			 <cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Identificacion"
				Default="Identificación"	
				returnvariable="LB_Identificacion"/>	
			
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Nombre"
				Default="Nombre"	
				returnvariable="LB_Nombre"/>	
				
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Centro_Funcional"
				Default="Centro Funcional"	
				returnvariable="LB_Centro_Funcional"/>	
				
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Empleado"
				Default="Empleado"	
				returnvariable="LB_Empleado"/>							
				
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Desde"
				Default="Desde"	
				returnvariable="LB_Desde"/>	
			
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Hasta"
				Default="Hasta"	
				returnvariable="LB_Hasta"/>					

			<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">				  
			<cfinclude template="/rh/portlets/pNavegacion.cfm">			
			<cfoutput>
				<form method="post" name="form1" action="VariacionHoras-vista.cfm">
					<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td width="42%">
								<table width="100%">
									<tr>
										<td height="173" valign="top">																											
											<cf_web_portlet_start border="true" titulo="#titulo#" skin="info1">
												<div align="justify">
												  <p>
												  	<cf_translate  key="AYUDA_EsteReporteSeMuestranLasVariacionHorasPorEmpleadoDelCentroFuncional">														  
													  En &eacute;ste reporte 
													  se muestran la variaci&oacute;n  de horas vrs planificaci&oacute;n de horario, por empleado del centro funcional
													  entre un rango de fechas.
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
								  <tr>
									<td width="32%" align="right" nowrap><strong>#LB_Centro_Funcional#:&nbsp;</strong></td>
									<td width="68%"><cf_rhcfuncional tabindex="1"></td>																				
								  </tr>
								   <tr>
										<td></td>
										<td>
											<table width="100%" cellpadding="0" cellspacing="0">
												<tr>
													<td width="1%" valign="middle"><input type="checkbox" name="dependencias"></td>
													<td valign="middle"><cf_translate  key="LB_IncluyeDependencias">Incluye Dependencias</cf_translate></td>
												</tr>
											</table>
										</td>
									<tr>								  
								  <tr>		
								    <td align="right"><strong>#LB_Empleado#:&nbsp;</strong></td>
									<td nowrap="nowrap">
										<cf_rhempleado tabindex="1" >									
									   </td>								  
								  </tr>
								  							  
								  <tr> 
										<td align="right"><strong>#LB_Desde#:&nbsp;</strong></td>
										<td nowrap>
											<cfif isdefined("Form.fdesde")>
												<cfset fecha = Form.fdesde>
											<cfelse>
												<cfset fecha = "">
											</cfif>
											<cf_sifcalendario form="form1" value="#fecha#" name="fdesde" tabindex="1">
										</td>											
									</tr>
									 <tr> 
										<td align="right"><strong>#LB_Hasta#:&nbsp;</strong></td>
										<td nowrap>
											<cfif isdefined("Form.fHasta")>
												<cfset fecha = Form.fHasta>
											<cfelse>
												<cfset fecha = "">
											</cfif>
											<cf_sifcalendario form="form1" value="#fecha#" name="fHasta" tabindex="1">
										</td>											
									</tr>
									<tr><td align="center" colspan="3">&nbsp;</td></tr>										
									<tr>
										<td align="center" colspan="3">
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Generar"
										Default="Generar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Generar"/>
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Limpiar"
										Default="Limpiar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Limpiar"/>										
										<input type="submit" value="#BTN_Generar#" name="Reporte" tabindex="1">
										<input type="reset"  name="Limpiar" value="#BTN_Limpiar#" tabindex="1"></td>
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
	<cf_qforms form="form1">
	<script type="text/javascript" language="javascript1.2">
		objForm.CFid.required = true;
		objForm.CFid.description="<cfoutput>#LB_Centro_Funcional#</cfoutput>";
		objForm.fdesde.required = true;
		objForm.fHasta.required = true;
		objForm.fdesde.description="<cfoutput>#LB_Desde#</cfoutput>";
		objForm.fHasta.description="<cfoutput>#LB_Hasta#</cfoutput>";
	</script>
	<cf_web_portlet_end>
<cf_templatefooter>	