<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH = t.Translate('LB_TituloH','Consultas Administrativas')>
<cfset LB_Titulo = t.Translate('LB_Titulo','Men&uacute; Principal de Consultas Administrativas')>
<cfset LB_AntigSaldosCxC = t.Translate('LB_AntigSaldosCxC','Análisis de Antigüedad de Saldos de CxC')>
<cfset LB_AntigSaldosCxP = t.Translate('LB_AntigSaldosCxP','Análisis de Antigüedad de Saldos de CxP')>
<cfset LB_InformacionFinaciera = t.Translate('LB_InformaciónFinaciera','Información Finaciera')>
<cfset LB_IntregacionCuenta = t.Translate('LB_IntregacionCuenta','Integración de cuenta de mayor')>
<cfset LB_EstadoResultadosAdmin = t.Translate('LB_EstadoResultadosAdmin','Estado de Resultados')>
<cfset LB_Almacenamiento = t.Translate('LB_Almacenamiento','Almacenamiento en Base de Datos y FileSystem')>
<cfset LB_ReportDinamic = t.Translate('LB_ReportDinamic','Creación de Reportes Dinámicos')>
<cfset LB_CreCobr = t.Translate('LB_CreCobr','Crédito y Cobro')>
<cfset LB_Otros = t.Translate('LB_Otros','Otros')>
<cfset LB_RepDin = t.Translate('LB_RepDin','Reportes Dinamicos')>

<cf_templateheader title="#LB_TituloH#">
	 <cfinclude template="../portlets/pNavegacionAdmin.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		  <cfinclude template="../Utiles/Parametrizado.cfm">
          	<cfoutput>
			<table width="100%" border="0" align="center" cellpadding="1" cellspacing="0">
				<tr> 
					<cfif acceso_uri("/sif/admin/Consultas/AntigSaldosCxC.cfm") OR
					      acceso_uri("/sif/admin/Consultas/AntigSaldosCxP.cfm")>
                    <td valign="top">
                        <fieldset><legend>#LB_CreCobr#</legend>
						<table width="100%" border="0" align="center" cellpadding="1" cellspacing="0">
							<!---►►Análisis de Antigüedad de Saldos de CxC◄◄--->
							<cfif acceso_uri("/sif/admin/Consultas/AntigSaldosCxC.cfm")>
                                <tr> 
                                    <td width="6%">&nbsp;</td>
                                    <td width="0%">&nbsp;</td>
                                    <td>
                                    	<font size="2">
                                            <a href='/cfmx/sif/admin/Consultas/AntigSaldosCxC.cfm'>
                                                <img src="../imagenes/Recordset.gif" width="18" height="18" border="0" align="absmiddle">
                                            </a>
                                            &nbsp;&nbsp;&nbsp;
                                            <a href='/cfmx/sif/admin/Consultas/AntigSaldosCxC.cfm'>
                                                #LB_AntigSaldosCxC#
                                            </a>
                                        </font>
                                    </td>
                                </tr>
                            </cfif>
                            <!---►►Análisis de Antigüedad de Saldos de CxP◄◄--->
                            <cfif acceso_uri("/sif/admin/Consultas/AntigSaldosCxP.cfm")>
							<tr> 
								<td width="6%">&nbsp;</td>
								<td width="0%">&nbsp;</td>
								<td>
                                	<font size="2">
                                    	<a href='/cfmx/sif/admin/Consultas/AntigSaldosCxP.cfm'>
                                        	<img src="../imagenes/Recordset.gif" width="18" height="18" border="0" align="absmiddle">
                                        </a>
                                        &nbsp;&nbsp;&nbsp;
										<a href='/cfmx/sif/admin/Consultas/AntigSaldosCxP.cfm'>
                                        	#LB_AntigSaldosCxP#
                                        </a>
                                    </font>
                                </td>
							</tr>	
                            </cfif>						
						</table>	
						</fieldset>
					</td>
                    </cfif>
                    <cfif acceso_uri("/sif/cg/consultas/IntregacionCuenta.cfm") OR 
						  acceso_uri("sif/cg/consultas/EstadoResultadosAdmin.cfm")>
					<td  valign="top">
						<fieldset><legend>#LB_InformacionFinaciera#</legend>
						<table width="100%" border="0" align="center" cellpadding="1" cellspacing="0">
							  <cfif acceso_uri("/sif/cg/consultas/IntregacionCuenta.cfm")>
                              <tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>
                                	<font size="2">
                                    	<a href='/cfmx/sif/cg/consultas/IntregacionCuenta.cfm'>
                                        	<img src="../imagenes/TBP_0097.JPG" width="18" height="18" border="0" align="absmiddle">
                                        </a>
										&nbsp;&nbsp;&nbsp;
                                        <a href='/cfmx/sif/cg/consultas/IntregacionCuenta.cfm'>
                                        	#LB_IntregacionCuenta#
                                        </a>
                                    </font>
                                </td>
							  </tr>	
                              </cfif>
                              <!---►►Estado de Resultados◄◄--->
							 <cfif acceso_uri("/sif/cg/consultas/EstadoResultadosAdmin.cfm")>
                              <tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>
                                	<font size="2">
                                    	<a href='/cfmx/sif/cg/consultas/EstadoResultadosAdmin.cfm'>
                                        	<img src="../imagenes/TBP_0097.JPG" width="18" height="18" border="0" align="absmiddle">
                                         </a>
                                         &nbsp;&nbsp;&nbsp;
										 <a href='/cfmx/sif/cg/consultas/EstadoResultadosAdmin.cfm'>
                                         	#LB_EstadoResultadosAdmin#
                                         </a>
                                      </font>
                                </td>
							  </tr>
                              </cfif>							 
						</table>	
						</fieldset>					
					</td>
                   </cfif>
				</tr>
				<tr>
                   <!---►►Almacenamiento en Base de Datos y FileSystem◄◄---> 
                   <cfif acceso_uri("/sif/admin/Consultas/Almacenamiento.cfm")>
					<td  valign="top">
						<fieldset><legend>#LB_Otros#</legend>
						<table width="100%" border="0" align="center" cellpadding="1" cellspacing="0">
						  <tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>
                            	<font size="2">
                                	<a href='/cfmx/sif/admin/Consultas/Almacenamiento.cfm'>
                                    	<img src="../imagenes/Recordset.gif" width="18" height="18" border="0" align="absmiddle">
                                    </a>
                                	&nbsp;&nbsp;&nbsp;
                                	<a href='/cfmx/sif/admin/Consultas/Almacenamiento.cfm'>
										#LB_Almacenamiento#
									</a>
                                </font>
                            </td>
						  </tr>
						</table>							
						</fieldset>
					</td>
                    </cfif>	
                    <!---►►Reportes Dinamicos◄◄--->
                    <cfif acceso_uri("/sif/admin/ReportDinamic/ReportDinamic.cfm")>		
                    <td valign="top">
						<fieldset><legend>#LB_RepDin#</legend>
						<table width="100%" border="0" align="center" cellpadding="1" cellspacing="0">
						  <tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>
                            	<font size="2">
                                    <a href='/cfmx/sif/admin/ReportDinamic/ReportDinamic.cfm'>
                                        <img src="/cfmx/sif/imagenes/report.png" width="18" height="18" border="0" align="absmiddle">
                                    </a>
                                    &nbsp;&nbsp;&nbsp;
                                	<a href='/cfmx/sif/admin/ReportDinamic/ReportDinamic.cfm'>
										#LB_ReportDinamic#
									</a>
                            	</font>
                          	</td>
						  </tr>
						</table>							
						</fieldset>
					</td>	
                    </cfif>
				</tr>
			</table>
            </cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>