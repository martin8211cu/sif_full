<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate>
	</cf_templatearea>
	
	<cf_templatearea name="body">
		<cf_templatecss>
		<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

		<script language="JavaScript" type="text/JavaScript">
		<!--
		function MM_reloadPage(init) {  //reloads the window if Nav4 resized
		  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
			document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
		  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
		}
		MM_reloadPage(true);
		//-->
		</script>

		<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>

						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Puestos"
							Default="Puestos"
							returnvariable="LB_Puestos"/>

   <cf_web_portlet_start border="true" titulo="#LB_Puestos#" skin="#Session.Preferences.Skin#">
	<TABLE width="100%" border="0" cellpadding="2" cellspacing="0">
		<tr>
			<td colspan="2">
				<cfinclude template="/rh/portlets/pNavegacion.cfm">
			</td>
		</tr>	  

		<tr>
			<td valign="top" width="150" >
				<cfinclude template="../menu.cfm">
			</td>
			<td valign="top">
					<table width="100%" cellpadding="2" cellspacing="0">
						<tr> 
							<td valign="top"> 
		
									<cfif isdefined("Url.codigoFiltro") and not isdefined("Form.codigoFiltro")>
										<cfparam name="Form.codigoFiltro" default="#Url.codigoFiltro#">
									</cfif>
									<cfif isdefined("Url.descripcionFiltro") and not isdefined("Form.descripcionFiltro")>
										<cfparam name="Form.descripcionFiltro" default="#Url.descripcionFiltro#">
									</cfif>		
									<cfif isdefined("Url.filtrado") and not isdefined("Form.filtrado")>
										<cfparam name="Form.filtrado" default="#Url.filtrado#">
									</cfif>	
									<cfif isdefined("Url.RHPcodigo") and not isdefined("Form.RHPcodigo")>
										<cfparam name="Form.RHPcodigo" default="#Url.RHPcodigo#">
									</cfif>
									<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
										<cfparam name="Form.sel" default="#Url.sel#">
									</cfif>
									<cfif isdefined("Url.o") and not isdefined("Form.o")>
										<cfparam name="Form.o" default="#Url.o#">
									</cfif>
									<cfset filtro = "">
									<cfset navegacion = "">
									<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
									<cfif isdefined("Form.RHPcodigo")>
										<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPcodigo=" & #form.RHPcodigo#>				
									</cfif>
									<cfif isdefined("Form.codigoFiltro") and Len(Trim(Form.codigoFiltro)) NEQ 0>
										<cfset filtro = filtro & " and upper(RHPcodigo) like '%" & #UCase(Form.codigoFiltro)# & "%'">
										<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "codigoFiltro=" & Form.codigoFiltro>
									</cfif>
									<cfif isdefined("Form.descripcionFiltro") and Len(Trim(Form.descripcionFiltro)) NEQ 0>
										<cfset filtro = filtro & " and upper(RHPdescpuesto)  like '%" & UCase(Form.descripcionFiltro) & "%'">
										<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "descripcionFiltro=" & Form.descripcionFiltro>
									</cfif>
									<cfif isdefined("Form.sel") and form.sel NEQ 1>
										<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "sel=" & form.sel>				
									</cfif>
									<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
										<cfset regresar = "/cfmx/rh/indexPuestos.cfm">
										<cfset navBarItems = ArrayNew(1)>
										<cfset navBarLinks = ArrayNew(1)>
										<cfset navBarStatusText = ArrayNew(1)>
										<cfset navBarItems[1] = "Administraci&oacute;n de Puestos">
										<cfset navBarLinks[1] = "/cfmx/rh/indexPuestos.cfm">
										<cfset navBarStatusText[1] = "/cfmx/rh/indexPuestos.cfm">
										<tr>
											<td valign="middle" align="right">
												<table>
													<tr>
														<td nowrap valign="top">
															<form name="formBuscar" method="post" action="">
																<label id="letiqueta1"><a href="javascript: limpiaFiltrado(); buscar();"><cf_translate xmlfile="/rh/admin/Puestos.xml"  key="LB_SeleccioneUnPuesto">Seleccione un puesto</cf_translate>:  </a></label>
																<label id="letiqueta2"><a href="javascript: limpiaFiltrado(); buscar();"><cf_translate xmlfile="/rh/admin/Puestos.xml"  key="LB_DatosDelPuesto">Datos del puesto</cf_translate>: </a> </label>			  
																<a href="javascript: limpiaFiltrado(); buscar();">
																	<img src="/cfmx/rh/imagenes/iindex.gif" name="imageBusca" border="0" id="imageBusca" height="16" width="16"> 
																</a>
															</form>
														</td>
														<td nowrap valign="top">
															<label id="letiqueta3">
															<cfif isdefined("form.RHPcodigo")>
															<a href="javascript: reporte();">
															  <cf_translate key="LB_Reporte" XmlFile="/rh/generales.xml">Reporte</cf_translate>: 
															</a>
															<a href="javascript: reporte();">
															  <img src="/cfmx/rh/imagenes/printer3.gif" name="imageImpr" border="0" id="imageImpr" height="16" width="16"> 
															</a>
															</cfif>
															</label>			
														</td>
													</tr>
												</table>
											</td>
										</tr>
										<tr style="display: ;" id="verFiltroListaEmpl"> 
											<td> 
												<form name="formFiltroListaEmpl" method="post" action="Puestos.cfm">
													<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
													<input type="hidden" name="sel" value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">				
													<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tituloListas">
														<tr> 
															<td width="27%" height="17" class="fileLabel"><cf_translate  key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></td>
															<td width="68%" class="fileLabel"><cf_translate  key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></td>
															<td width="5%" colspan="2" rowspan="2">
																<cfinvoke component="sif.Componentes.Translate"
																	method="Translate"
																	Key="BTN_Filtrar"
																	Default="Filtrar"
																	XmlFile="/rh/generales.xml"
																	returnvariable="BTN_Filtrar"/>
			
																<input name="btnFiltrar" type="submit" id="btnFiltrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>" tabindex="1">
															</td>
														</tr>
														<tr>
															<td><input name="codigoFiltro" type="text" id="codigoFiltro" size="30" maxlength="60" tabindex="1" value="<cfif isdefined('form.codigoFiltro')><cfoutput>#form.codigoFiltro#</cfoutput></cfif>"></td>
															<td><input name="descripcionFiltro" type="text" id="descripcionFiltro" size="70" maxlength="260" tabindex="1" value="<cfif isdefined('form.descripcionFiltro')><cfoutput>#form.descripcionFiltro#</cfoutput></cfif>"></td>
														</tr>
													</table>
												</form>
											</td>
										</tr>		
										<tr style="display: ;" id="verLista"> 
											<td> 
												<table width="100%" border="0" cellspacing="0" cellpadding="0">
													<tr>
														<td>
															<cfset checked = "<img src=''/cfmx/rh/imagenes/checked.gif'' border=''0''>">
															<cfset unchecked = "<img src=''/cfmx/rh/imagenes/unchecked.gif'' border=''0''>">							
															<cfinvoke component="sif.Componentes.Translate"
																method="Translate"
																Key="LB_Codigo"
																Default="C&oacute;digo"
																XmlFile="/rh/generales.xml"
																returnvariable="LB_Codigo"/>
															<cfinvoke component="sif.Componentes.Translate"
																method="Translate"
																Key="LB_Descripcion"
																Default="Descripci&oacute;n"
																XmlFile="/rh/generales.xml"
																returnvariable="LB_Descripcion"/>
															<cfinvoke component="sif.Componentes.Translate"
																method="Translate"
																Key="LB_Inactivo"
																Default="Inactivo"
																XmlFile="/rh/generales.xml"
																returnvariable="LB_Inactivo"/>
															
															<cfinvoke 
																component="rh.Componentes.pListas"
																method="pListaRH"
																returnvariable="pListaEmpl">
																<cfinvokeargument name="tabla" value="RHPuestos"/>
																<cfinvokeargument name="columnas" value="RHPcodigo, RHPdescpuesto, case RHPactivo when 0 then '#checked#' else '#unchecked#' end as RHPactivo, 1 as o,1 as sel"/>
																<cfinvokeargument name="desplegar" value="RHPcodigo, RHPdescpuesto, RHPactivo"/>
																<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#, #LB_Inactivo#"/>
																<cfinvokeargument name="formatos" value="S, S, V"/>
																<cfinvokeargument name="formName" value="listaPuestos"/>	
																<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro# order by RHPcodigo, RHPdescpuesto"/>
																<cfinvokeargument name="align" value="left,left, center"/>
																<cfinvokeargument name="ajustar" value="N"/>
																<cfinvokeargument name="irA" value="Puestos.cfm"/>
																<cfinvokeargument name="navegacion" value="#navegacion#"/>
																<cfinvokeargument name="keys" value="RHPcodigo"/>
															</cfinvoke>
														</td>
													</tr>
													<tr>
														<td align="center">
															<form name="formNuevoEmplLista" method="post" action="Puestos.cfm">
																<input type="hidden" name="o" value="1">
																<input type="hidden" name="sel" value="1">
																<cfinvoke component="sif.Componentes.Translate"
																	method="Translate"
																	Key="BTN_Nuevo"
																	Default="Nuevo"
																	XmlFile="/rh/generales.xml"
																	returnvariable="BTN_Nuevo"/>
																<input name="btnNuevoLista" type="submit" value="<cfoutput>#BTN_Nuevo#</cfoutput>" tabindex="1">				
															</form>
														</td>
													</tr>
												</table>
											</td>
										</tr>
										<tr style="display: ;" id="verPagina"> 
											<td> 
												<table width="100%" border="0" cellspacing="0" cellpadding="0">
													<tr>
														<td><cfinclude template="/rh/admin/catalogos/formPuestos-header.cfm"></td>
													</tr>
													<tr>
													<td>
													<cf_tabs width="100%">
														<cf_tab text=#tabNames[1]# selected="#tabChoice eq 1#">
															<cfif tabChoice eq 1>
																<table width="100%"  border="0" cellspacing="0" cellpadding="0">
																	<tr>
																		<td colspan="3"><cfinclude template="/rh/admin/catalogos/formPuestos-frinfo.cfm"></td>
																	</tr> 
																	<cfif isdefined("form.RHPcodigo")>
																		<tr>
																			<td>&nbsp;</td>
																			<td class="fileLabel"><cf_translate xmlfile="/rh/admin/Puestos.xml"  key="LB_Mision">Misi&oacute;n</cf_translate></td>
																			<td>&nbsp;</td>
																		</tr>


																		<tr>
																			<td width="10%">&nbsp;</td>
																			<td width="90%"class="texto">
																				<table width="85%"  align="center" border="0" cellspacing="0" cellpadding="0">
																					<tr>
																						<td><cfinclude template="/rh/admin/catalogos/formPuestos-vwmision.cfm"></td>
																					</tr>
																				</table>
																			</td>
																			<td width="10%">&nbsp;</td>
																		 </tr>
																		 <tr>
																			<td colspan="3">&nbsp;</td>
																		 </tr>
																		 <tr>
																			<td>&nbsp;</td>
																			<td class="fileLabel"><cf_translate xmlfile="/rh/admin/Puestos.xml"  key="LB_Responsabilidades">Responsabilidades</cf_translate></td>
																			<td>&nbsp;</td>
																		</tr>
																		<tr>
																			<td width="10%">&nbsp;</td>
																			<td width="90%"class="texto">
																				<table width="85%"  align="center" border="0" cellspacing="0" cellpadding="0">
																					<tr>
																						<td><cfinclude template="/rh/admin/catalogos/formPuestos-vwobjetivos.cfm"></td>
																					</tr>
																				</table>
																			</td>
																			<td width="10%">&nbsp;</td>
																		</tr>
																		<tr>
																			<td colspan="3">&nbsp;</td>
																		</tr>
																		<tr>
																			<td>&nbsp;</td>
																			<td class="fileLabel"><cf_translate xmlfile="/rh/admin/Puestos.xml" 
																			 key="LB_Especificicaciones">Especificaciones</cf_translate></td>
																			<td>&nbsp;</td>
																		</tr>
																		<tr>
																			<td width="10%">&nbsp;</td>
																			<td width="90%"class="texto">
																				<table width="85%"  align="center" border="0" cellspacing="0" cellpadding="0">
																					<tr>
																						<td><cfinclude template="/rh/admin/catalogos/formPuestos-vwespecificaciones.cfm"></td>
																					</tr>
																				</table>
																			</td>
																			<td width="10%">&nbsp;</td>
																		</tr>
																		<tr>
																			<td colspan="3">&nbsp;</td>
																		</tr>
																	</cfif>
																</table>
															</cfif>
														</cf_tab>
														<!---
														<cf_tab text=#tabNames[2]# selected="#tabChoice eq 2#">
															<cfif tabChoice eq 2>
																<cfinclude template="/rh/admin/catalogos/formPuestos-frmision.cfm">
															</cfif>
														</cf_tab>
														<cf_tab text=#tabNames[3]# selected="#tabChoice eq 3#">
															<cfif tabChoice eq 3>
																<cfinclude template="/rh/admin/catalogos/formPuestos-frobjetivos.cfm">
															</cfif>
														</cf_tab>
														<cf_tab text=#tabNames[4]# selected="#tabChoice eq 4#">
															<cfif tabChoice eq 4>
																<cfinclude template="/rh/admin/catalogos/formPuestos-frespecificaciones.cfm">
															</cfif>
														</cf_tab>
														--->
														<cf_tab text=#tabNames[5]# selected="#tabChoice eq 5 or tabChoice eq 2#">
															<cfif tabChoice eq 5 or tabChoice eq 2>
																<cfinclude template="/rh/admin/catalogos/formPuestos-frhabilidades.cfm">
															</cfif>
														</cf_tab>
														
														<cf_tab text=#tabNames[6]# selected="#tabChoice eq 6 or tabChoice eq 3#">
															<cfif tabChoice eq 6 or tabChoice eq 3>
																<cfinclude template="/rh/admin/catalogos/formPuestos-frconocimientos.cfm">
															</cfif>
														</cf_tab>
														<!---
														<cf_tab text=#tabNames[7]# selected="#tabChoice eq 7#">
															<cfif tabChoice eq 7>
																<cfinclude template="/rh/admin/catalogos/formPuestos-frvalores.cfm">
															</cfif>
														</cf_tab>
														--->
														<!---
														<cf_tab text=#tabNames[8]# selected="#tabChoice eq 8#">
															<cfif tabChoice eq 8>
																<cfinclude template="/rh/admin/catalogos/formPuestos-frConsulta.cfm">
															</cfif>
														</cf_tab>
														--->
														<cf_tab text=#tabNames[9]# selected="#tabChoice eq 9 or tabChoice eq 4#">
															<cfif tabChoice eq 9 or tabChoice eq 4>
																<cfinclude template="/rh/admin/catalogos/formPuestos-frbenzinger.cfm">
															</cfif>
														</cf_tab>
													</cf_tabs>
													</td>
													</tr>
												</table>
											</td>
										</tr>
										<tr><td>&nbsp;</td></tr>
									</table>
									<script type="text/javascript">
									<!--
										function tab_set_current (n){
											validaDEid(escape(n),'Puestos.cfm?o='+escape(n)+'&tab='+escape(n)+'&sel=1');
										}
									//-->
									</script>	
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="ALT_Mantenimientos"
									Default="Mantenimientos"
									returnvariable="ALT_Mantenimientos"/>
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="ALT_ListaDePuestos"
									Default="Lista de puestos"
									returnvariable="ALT_ListaDePuestos"/>
			
									<script language="JavaScript" type="text/javascript">
										var Bandera = "L";
										function buscar(){
											var connVerLista			= document.getElementById("verLista");
											var connVerPagina			= document.getElementById("verPagina");
											var connVerFiltroListaEmpl	= document.getElementById("verFiltroListaEmpl");
											var connVerEtiqueta1		= document.getElementById("letiqueta1");
											var connVerEtiqueta2		= document.getElementById("letiqueta2");
											var connVerEtiqueta3		= document.getElementById("letiqueta3");
											if(document.formFiltroListaEmpl.filtrado.value != "")
												Bandera = "L";
											if(document.formFiltroListaEmpl.sel.value == "1")
												Bandera = "P";					
											if(Bandera == "L"){	// Ver Lista
												Bandera = "P";
												connVerLista.style.display = "";
												connVerFiltroListaEmpl.style.display = "";					
												connVerPagina.style.display = "none";
												document.formBuscar.imageBusca.src="/cfmx/rh/imagenes/iindex.gif";
												connVerEtiqueta1.style.display = "none";
												connVerEtiqueta2.style.display = "";
												connVerEtiqueta3.style.display = "none";
												document.formBuscar.imageBusca.alt="#ALT_Mantenimientos#";
											}
											else{	//Pagina
												Bandera = "L";				
												connVerLista.style.display = "none";
												connVerFiltroListaEmpl.style.display = "none";					
												connVerPagina.style.display = "";
												document.formBuscar.imageBusca.src="/cfmx/rh/imagenes/iindex.gif";					
												connVerEtiqueta1.style.display = "";
												connVerEtiqueta2.style.display = "none";
												connVerEtiqueta3.style.display = "";
												document.formBuscar.imageBusca.alt="#ALT_ListaPuestos#";
											}
										}				
										function limpiaFiltrado(){
											document.formFiltroListaEmpl.filtrado.value = "";
											document.formFiltroListaEmpl.sel.value = 0;
										}
										<cfif isdefined("form.RHPcodigo")>
											function reporte(){
												<cfoutput>
													location.href="PuestosReport.cfm?RHPcodigo=#Trim(form.RHPcodigo)#&Regresar=Puestos.cfm?RHPcodigo=#Trim(form.RHPcodigo)#&o=1&sel=1";
												</cfoutput>
											}
										</cfif>
										buscar();
									</script>
							</td>	
						</tr>
					</table>	
		</td></tr>
	</table>			
	<cf_web_portlet_end>	
	</cf_templatearea>
</cf_template>