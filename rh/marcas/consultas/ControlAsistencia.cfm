<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<cf_templatecss>
  <cfinclude template="/rh/Utiles/params.cfm">
  <cfset Session.Params.ModoDespliegue = 1>
  <cfset Session.cache_empresarial = 0>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">      			    
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_CtrlAsistencia"
				Default="Reporte Control de Asistencia"
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
				Key="LB_Empleado"
				Default="Empleado"	
				returnvariable="LB_Empleado"/>							
				
            <cfinvoke Key="LB_FechaDesde" 
                Default="Desde" 
                returnvariable="LB_FechaDesde" 
                component="sif.Componentes.Translate" 
                method="Translate"/>
                
            <cfinvoke Key="LB_FechaHasta" 
            	Default="Hasta" 
                returnvariable="LB_FechaHasta" 
                component="sif.Componentes.Translate" 
                method="Translate"/> 
                
            <cfinvoke Key="LB_Retardos" 
            	Default="Solo mostrar entradas con retardos" 
                returnvariable="LB_Retardos" 
                component="sif.Componentes.Translate" 
                method="Translate"/>    
                            
			<cfquery name="rsJornada" datasource="#session.DSN#">
                select RHJid,RHJdescripcion from RHJornadas
                where Ecodigo =#session.Ecodigo#
            </cfquery>
            
			<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">				  
			<cfinclude template="/rh/portlets/pNavegacion.cfm">			
			<cfoutput>
				<form method="post" name="form1" action="ControlAsistencia-vista.cfm">
					<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td width="42%">
								<table width="100%">
									<tr>
										<td height="50" valign="top">																											
											<cf_web_portlet_start border="true" titulo="#titulo#" skin="info1">
												<div align="justify">
												  <p>
												  	<cf_translate  key="AYUDA_EsteReporteMuestraElControldeAusenciasyRetardos">												
													  En &eacute;ste reporte 
													  se muestran la hora de entrada, incapacidades y faltas por empleado
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
                                        <td align="right"><strong>#LB_Empleado#:&nbsp;</strong></td>
                                        <td nowrap="nowrap">
                                            <cf_rhempleado tabindex="1" >									
                                        </td>								  
								  	</tr>
								  	<tr> 
								  		<td align="right"><strong>#LB_FechaDesde#:&nbsp;</strong></td>
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
								  		<td align="right"><strong>#LB_FechaHasta#:&nbsp;</strong></td>
										<td nowrap>
											<cfif isdefined("Form.fhasta")>
												<cfset fecha = Form.fhasta>
											<cfelse>
												<cfset fecha = "">
											</cfif>
											<cf_sifcalendario form="form1" value="#fecha#" name="fhasta" tabindex="1">
										</td>                                        											
									</tr>
                                </table>
                             </td> 
                          </tr>
                          <tr>
                              <td></td>
                              <td>
                                  <table>
                                        <tr>
                                            <td align="left"><strong>Excluir Jornada</strong></td>
<!---                                            <td colspan="2"></td>
                                            <td align="left"><strong>Excluir Nomina</strong></td>
--->                                    </tr>
                                        <cfloop query="rsJornada">
                                           <tr>
                                           		<td></td>
                                                <td>
                                                <table width="100%" cellpadding="0" cellspacing="0">
                                                	<tr>
                                                    <td  width="1%" align="left"><input type="checkbox" name="ExcluirJ_#RHJid#"></td>
                                                    <td>#RHJdescripcion#</td>
                                                    </tr>
                                                </table>
                                                </td>
                                           </tr> 
                                        </cfloop>
                                        <tr></tr>
                                        <tr>
                                            <td></td>
                                            <td>
                                                <table width="100%" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td width="1%" valign="middle"><input type="checkbox" name="retardos"></td>
                                                        <td valign="middle"><cf_translate  key="LB_Retardos">Solo mostrar entradas con retardo</cf_translate></td>
                                                    </tr>
                                                    <tr>
                                                        <td width="1%" valign="middle"><input type="checkbox" name="weekend"></td>
                                                        <td valign="middle"><cf_translate  key="LB_Retardos">Mostrar fines de semana</cf_translate></td>
                                                    </tr>
                                                    
                                                </table>
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
		objForm.fdesde.required = true;
		objForm.fdesde.description="<cfoutput>#LB_FechaDesde#</cfoutput>";
		objForm.fhasta.required = true;
		objForm.fhasta.description="<cfoutput>#LB_FechaHasta#</cfoutput>";
	</script>
	<cf_web_portlet_end>
<cf_templatefooter>	