
<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
	<cfset form.DEid = url.DEid >
</cfif>
<cfif isdefined("url.o") and not isdefined("form.o")>
	<cfset form.o = url.o >
</cfif>
<cfif isdefined("url.tab") and not isdefined("form.tab")>
	<cfset form.tab = url.tab >
</cfif>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_ConsultaDeExpedienteLaboral"
Default="Consulta de Expediente Laboral"
xmlfile="/rh/expediente/consultas/expediente-globalcons.xml"
returnvariable="LB_ConsultaDeExpedienteLaboral"/> 

<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cf_translate key="LB_RHAutogestion">RH - Autogesti&oacute;n</cf_translate>
	</cf_templatearea>
	<cf_templatecss>
	<cf_templatearea name="body">
	
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<!--- Query para saber si se pintan o no los TABS de perfil y perfil comparativo --->
	<cfquery name="rsUsatest" datasource="#session.DSN#">
		select Pvalor
		from RHParametros 
		where Pcodigo = 450 
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
	</cfquery>
	
<cf_web_portlet_start titulo="#LB_ConsultaDeExpedienteLaboral#">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
	<tr>
			<td valign="top" width="150"><cfinclude template="../menu.cfm"></td>
			<td valign="top">		
					<table width="100%" cellpadding="2" cellspacing="0">
					<tr>
							<td valign="top">  		     
								 <cfinclude template="/rh/expediente/consultas/consultas-frame-header.cfm">
								 <!---<cfinclude template="iconOptions.cfm">--->	
								 <script language="JavaScript" type="text/javascript">
									function switchPages() {
										var DataPage = document.getElementById("TRDatosEmp");
										var ListPage = document.getElementById("TRBuscarEmp");
										if (DataPage.style.display == "") {
											DataPage.style.display = "none";
											ListPage.style.display = "";
										} else {
											DataPage.style.display = "";
											ListPage.style.display = "none";
										}
									}
								</script>
								<cfset Session.modulo = 'index' >		
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td>
											<cfinclude template="/rh/portlets/pNavegacion.cfm">
										</td>
									</tr>
									<tr>
										<td>
											<cfinclude template="/rh/expediente/consultas/consultas-frame-header.cfm"><cfinclude template="/rh/expediente/consultas/iconOptions.cfm">
										</td>
									</tr>
									<!--- Cuando ya se ha seleccionado un empleado --->
									
									<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
										<tr id="TRDatosEmp">
											<td>
												<cfinclude template="/rh/expediente/consultas/frame-header.cfm">
												<table width="100%" border="0" cellspacing="0" cellpadding="0">
													<tr>
														<td> <!--- class="tabContent" --->
															<cfif isDefined("Form.DEid") and isDefined("Form.Regresar")>
																<cfoutput>
																	<form name="frmRegresar" method="post" action="#Form.Regresar#" style="margin: 0;">
																		<input type="hidden" name="DEid" value="#Form.DEid#">
																		<cfif isdefined("Form.o")>
																			<input type="hidden" name="o" value="#Form.o#">
																		<cfelse>
																			<input type="hidden" name="o" value="1">
																		</cfif>
																	</form>
																</cfoutput>
																<cfset regresar = "javascript: if (window.regresar) { regresar(); } else { document.Regresar.submit(); }">
															</cfif>
														</td>
													</tr>
													<tr>
														<td> 
															<!---class="tabContent"--->
															<cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5,6,7,8,9,10', form.tab) )>
																<cfset form.tab = 1 >
															</cfif>
				
															<cf_tabs width="100%">
																<cf_tab text=#tabNames[1]# selected="#tabChoice eq 1#">
																	<cfif tabChoice eq 1>
																	   <cfif isdefined("Form.dvacemp")>
																			<cfinclude template="/rh/expediente/consultas/expediente-detalleVacaciones.cfm">
																		<cfelse>
																			<cfinclude template="/rh/expediente/consultas/expediente-all.cfm">
																		</cfif>
																	</cfif>
																</cf_tab>
																<cf_tab text=#tabNames[2]# selected="#tabChoice eq 2#">
																	<cfif tabChoice eq 2 and tabAccess[tabChoice]>
																		<cfinclude template="/rh/expediente/consultas/expediente-general.cfm">
																	</cfif>
																</cf_tab>
																<!---
																<cf_tab text=#tabNames[3]# selected="#tabChoice eq 3#">
																	<cfif tabChoice eq 3 and tabAccess[tabChoice]>
																		<cfinclude template="/rh/expediente/consultas/expediente-familiar.cfm">
																	</cfif>	
																</cf_tab>
																--->
																<cf_tab text=#tabNames[4]# selected="#tabChoice eq 4 or tabChoice eq 3#">
																	<cfinclude template="/rh/portlets/pNavegacion.cfm">
																	<cfif (tabChoice eq 4 or tabChoice eq 3 ) and tabAccess[4]>
																		<cfinclude template="/rh/expediente/consultas/expediente-laboral.cfm">
																	</cfif>	
																</cf_tab>
																<cf_tab text=#tabNames[5]# selected="#tabChoice eq 5 or tabChoice eq 4#">
																	<cfif (tabChoice eq 5 or tabChoice eq 4) and tabAccess[5]>
																		<cfinclude template="/rh/expediente/consultas/expediente-cargas.cfm">
																	</cfif>	
																</cf_tab>
																<cf_tab text=#tabNames[6]# selected="#tabChoice eq 6 or tabChoice eq 5#">
																	<cfif tabChoice eq 6 or tabChoice eq 5 and tabAccess[6]>
																		<cfinclude template="/rh/expediente/consultas/expediente-deducciones.cfm">
																	</cfif>	
																</cf_tab>
																<cf_tab text=#tabNames[7]# selected="#tabChoice eq 7 or tabChoice eq 6#">
																	<cfif (tabChoice eq 7 or tabChoice eq 6) and tabAccess[7]>
																		<cfinclude template="/rh/expediente/consultas/expediente-anotaciones.cfm">
																	</cfif>	
																</cf_tab>
																<cf_tab text="" selected="#tabChoice eq 8 or tabChoice eq 7#">
																	<cfif (tabChoice eq 8 or tabChoice eq 7) and tabAccess[6]>
																		<cfinclude template="/rh/expediente/consultas/expediente-deducciones.cfm">	
																	</cfif>	
																</cf_tab>
																<cf_tab text="" selected="#tabChoice eq 9 or tabChoice eq 8#" >
																	<cfif (tabChoice eq 9 or tabChoice eq 8) and tabAccess[6]>
																		<cfinclude template="/rh/expediente/consultas/expediente-deducciones.cfm">	
																	</cfif>	
																</cf_tab>
																<cf_tab text=#tabNames[10]# selected="#tabChoice eq 10 or tabChoice eq 9#">
																	<cfif (tabChoice eq 10 or tabChoice eq 9) and tabAccess[10] and isdefined("rsUsatest") and rsUsatest.Pvalor EQ 1>
																		<cfinclude template="/rh/expediente/consultas/expediente-frbenzinger.cfm">
																	</cfif>	
																</cf_tab>	
																<cf_tab text=#tabNames[11]# selected="#tabChoice eq 11 or tabChoice eq 10#">
																	<cfif (tabChoice eq 11 or tabChoice eq 10) and tabAccess[11] and isdefined("rsUsatest") and rsUsatest.Pvalor EQ 1>
																		<cfinclude template="/rh/expediente/consultas/comparativo-benziger.cfm">
																	</cfif>	
																</cf_tab>
																<!---
																<cf_tab text=#tabNames[12]# selected="#tabChoice eq 12#">
																	<cfif tabChoice eq 12 and tabAccess[12]>
																		<cfinclude template="/rh/expediente/consultas/expediente-beneficios.cfm">
																	</cfif>	
																</cf_tab>
																--->
															</cf_tabs>	
															<script type="text/javascript">
															<!--
																function tab_set_current (n){
																	<cfif Session.Params.ModoDespliegue EQ 1>
																		gotoTab(n, <cfoutput>#JSStringFormat(form.DEid)#</cfoutput>);
																		<!--
																		location.href='/cfmx/rh/gestiontalento/laboral/expediente-globalcons.cfm?DEid=<cfoutput>#JSStringFormat(form.DEid)#</cfoutput>&o='+escape(n);;
																		-->
																	<cfelseif Session.Params.ModoDespliegue EQ 0>
																		location.href='/cfmx/rh/gestiontalento/laboral/expediente-cons.cfm?o='+escape(n)+'&tab='+escape(n);
																	</cfif>	
																		
																}
															//-->
															</script>															
														</td>
													</tr>
												</table>
											</td>
										</tr>
										<tr id="TRBuscarEmp" style="display: none">
											<td>
												<!---<cf_web_portlet_start titulo="#LB_ConsultaDeExpedienteLaboral#">--->
												<table width="100%" border="0" cellspacing="0" cellpadding="0">
													<tr valign="top">
														<td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td>
													</tr>
													<tr valign="top"> 
														<td>&nbsp;</td>
													</tr>
													<tr valign="top"> 
														<td align="center">
															<cfinclude template="/rh/expediente/consultas/frame-Empleados.cfm">
														</td>
													</tr>
													<tr valign="top"> 
														<td>&nbsp;</td>
													</tr>
												</table>
												<!---<cf_web_portlet_end>--->
											</td>
										</tr>
									<!--- Cuando todavia no se ha seleccionado un empleado --->
									<cfelse>				
										<tr>
											<td>
												<!---<cf_web_portlet_start titulo="#LB_ConsultaDeExpedienteLaboral#">--->
													<table width="100%" border="0" cellspacing="0" cellpadding="0">
														<tr valign="top">
															<td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td>
														</tr>
														<tr valign="top"> 
															<td>&nbsp;</td>
														</tr>
														<tr valign="top"> 
															<td align="center">
																<p class="tituloAlterno">
																<cf_translate key="LB_DebeSeleccionarUnEmpleado">Debe seleccionar un empleado</cf_translate></p>
																<cfinclude template="/rh/expediente/consultas/frame-Empleados.cfm">
															</td>
														</tr>
														<tr><td>&nbsp;</td></tr>
													</table>
												<!---<cf_web_portlet_end>--->
											</td>
										</tr>
									</cfif>
								</table>
							</td>	
						</tr>
					</table>
			</td>		
		</tr>	
	</table>
	<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>

