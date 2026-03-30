<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Puestos" Default="Puestos" returnvariable="LB_Puestos" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN DE VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">

<cfset Aprobacion = 'A'>
<cfquery name="rsAprobacion" datasource="#session.DSN#">
	select coalesce(Pvalor,'A') as Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
	  and Pcodigo = 690
</cfquery>

<cfif rsAprobacion.recordCount GT 0>
	<cfset Aprobacion = rsAprobacion.Pvalor>
</cfif>



<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
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
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr> 
				<td valign="top"> 

				   <cf_web_portlet_start border="true" titulo="#LB_Puestos#" skin="#Session.Preferences.Skin#">
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
								<td>
									<cfinclude template="/rh/portlets/pNavegacion.cfm">
								</td>
							</tr>	  
							<tr>
								<td valign="middle" align="right">
									<table>
										<tr>
											<td nowrap valign="top">
												<form name="formBuscar" method="post" action="">
													<label id="letiqueta1"><a href="javascript: buscar();"><cf_translate key="LB_SeleccioneUnPuesto">Seleccione un puesto</cf_translate>  </a></label>
													<!---<label id="letiqueta2"><a href="javascript: limpiaFiltrado(); buscar();"><cf_translate key="LB_DatosDelPuesto">Datos del puesto</cf_translate>: </a> </label>--->			  
													<a href="javascript: buscar();">
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
							<tr style="display: ;" id="verPagina"> 
								<td> 
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td style="padding-left:20px;">
												<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
													<cfquery name="data" datasource="#session.DSN#">
														select coalesce(RHPcodigoext, RHPcodigo) as RHPcodigo, RHPdescpuesto
														from RHPuestos
														where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
														  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">
													</cfquery>
												<strong><font color="navy"><strong><cf_translate key="LB_Puesto" >Puesto</cf_translate>:<cfoutput>&nbsp;#trim(data.RHPcodigo)# - #data.RHPdescpuesto#</cfoutput></font></strong>
												</cfif>
												<cfinclude template="formPuestos-header.cfm">
											</td>
										</tr>
										<tr>
										<td>
										<cf_tabs width="100%">
											<cf_tab text=#tabNames[1]# selected="#tabChoice eq 1#">
												<cfif tabChoice eq 1>
													<table width="100%"  border="0" cellspacing="0" cellpadding="0">
														<tr>
															<td colspan="3"><cfinclude template="formPuestos-frinfo.cfm"></td>
														</tr> 
														<cfif isdefined("form.RHPcodigo")>
															<tr>
																<td>&nbsp;</td>
																<td class="fileLabel"><cf_translate key="LB_Mision">Misi&oacute;n</cf_translate></td>
																<td>&nbsp;</td>
															</tr>
															<tr>
																<td width="10%">&nbsp;</td>
																<td width="90%"class="texto">
																	<table width="85%"  align="center" border="0" cellspacing="0" cellpadding="0">
																		<tr>
																			<td><cfinclude template="formPuestos-vwmision.cfm"></td>
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
																<td class="fileLabel"><cf_translate key="LB_Responsabilidades">Responsabilidades</cf_translate></td>
																<td>&nbsp;</td>
															</tr>
															<tr>
																<td width="10%">&nbsp;</td>
																<td width="90%"class="texto">
																	<table width="85%"  align="center" border="0" cellspacing="0" cellpadding="0">
																		<tr>
																			<td><cfinclude template="formPuestos-vwobjetivos.cfm"></td>
																		</tr>
																	</table>
																</td>
																<td width="10%">&nbsp;</td>
															</tr>
															<tr>
																<td colspan="3">&nbsp;</td>
															</tr>

															<tr>
																<td colspan="3">&nbsp;</td>
															</tr>
														</cfif>
													</table>
												</cfif>
											</cf_tab>
											<cf_tab text=#tabNames[2]# selected="#tabChoice eq 2#">
												<cfif tabChoice eq 2>
													<cfinclude template="formPuestos-frmision.cfm">
												</cfif>
											</cf_tab>
											<cf_tab text=#tabNames[3]# selected="#tabChoice eq 3#">
												<cfif tabChoice eq 3>
													<cfinclude template="formPuestos-frobjetivos.cfm">
												</cfif>
											</cf_tab>
											<cf_tab text=#tabNames[4]# selected="#tabChoice eq 4#">
												<cfif tabChoice eq 4>
													<cfinclude template="formPuestos-frespecificaciones.cfm">
												</cfif>
											</cf_tab>
											<cf_tab text=#tabNames[5]# selected="#tabChoice eq 5#">
												<cfif tabChoice eq 5>
													<cfinclude template="formPuestos-frhabilidades.cfm">
												</cfif>
											</cf_tab>
											<cf_tab text=#tabNames[6]# selected="#tabChoice eq 6#">
												<cfif tabChoice eq 6>
													<cfinclude template="formPuestos-frconocimientos.cfm">
												</cfif>
											</cf_tab>
											<cf_tab text=#tabNames[7]# selected="#tabChoice eq 7#">
												<cfif tabChoice eq 7>
													<cfinclude template="formPuestos-frvalores.cfm">
												</cfif>
											</cf_tab>
											<cf_tab text=#tabNames[8]# selected="#tabChoice eq 8#">
												<cfif tabChoice eq 8>
													<cfinclude template="formPuestos-frConsulta.cfm">
												</cfif>
											</cf_tab>
											<cf_tab text=#tabNames[9]# selected="#tabChoice eq 9#">
												<cfif tabChoice eq 9>
													<cfinclude template="formPuestos-frbenzinger.cfm">
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
								location.href = '/cfmx/rh/admin/catalogos/Puestos-lista.cfm';
								/*
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
								*/
							}				
							<cfif isdefined("form.RHPcodigo")>
								function reporte(){
									<cfoutput>
										location.href="PuestosReport.cfm?RHPcodigo=#Trim(form.RHPcodigo)#&Regresar=Puestos.cfm?RHPcodigo=#Trim(form.RHPcodigo)#&o=1&sel=1";
									</cfoutput>
								}
							</cfif>
						</script>
					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>