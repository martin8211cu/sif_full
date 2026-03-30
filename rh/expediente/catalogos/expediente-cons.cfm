	<cfinvoke component="sif.Componentes.TranslateDB"
		method="Translate"
		vsvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
		default="Mantenimiento de Empleados"
		vsgrupo="103"
		returnvariable="nombre_proceso"/>

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_RecursosHumanos"
		default="Recursos Humanos"
		xmlfile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	
		<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<!--- ========================================================= --->
					<!---          T A B S     D E     T R A D U C C I O N          --->
					<!--- ========================================================= --->
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Identificacion"
						xmlfile="/rh/generales.xml"	
						default="Identificaci&oacute;n"
						returnvariable="vIdentificacion"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Nombre"
						xmlfile="/rh/generales.xml"	
						default="Nombre"
						returnvariable="vNombre"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Empleado"
						xmlfile="/rh/generales.xml"	
						default="Empleado"
						returnvariable="vEmpleado"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Filtrar"
						xmlfile="/rh/generales.xml"	
						default="Filtrar"
						returnvariable="vFiltrar"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Nuevo_Empleado"
						default="Nuevo Empleado"
						returnvariable="vNuevoEmpleado"/>
					<!--- ========================================================= --->
					<!---          T A B S     D E     T R A D U C C I O N          --->
					<!--- ========================================================= --->

					<cf_web_portlet_start border="true" titulo="<cfoutput>#nombre_proceso#</cfoutput>" skin="#Session.Preferences.Skin#">
						<!--- Asignación de valores a las variables del form --->
						<cfif isdefined("Url.nombreFiltro") and not isdefined("Form.nombreFiltro")>
							<cfparam name="Form.nombreFiltro" default="#Url.nombreFiltro#">
						</cfif>
						<cfif isdefined("Url.DEidentificacionFiltro") and not isdefined("Form.DEidentificacionFiltro")>
							<cfparam name="Form.DEidentificacionFiltro" default="#Url.DEidentificacionFiltro#">
						</cfif>		
						<cfif isdefined("Url.filtrado") and not isdefined("Form.filtrado")>
							<cfparam name="Form.filtrado" default="#Url.filtrado#">
						</cfif>	
						<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
							<cfparam name="Form.DEid" default="#Url.DEid#">
						</cfif>
						<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
							<cfparam name="Form.sel" default="#Url.sel#">
						</cfif>
						
						<!--- Asignación de la Navegación --->		
						<cfset filtro = "">
						<cfset navegacion = "">
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
						<cfif isdefined("Form.DEid")>
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & #form.DEid#>				
						</cfif>
						<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0>
							<cfset filtro = filtro & " and upper({fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, DEnombre) }) like '%" & #UCase(Form.nombreFiltro)# & "%'">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombreFiltro=" & Form.nombreFiltro>
						</cfif>
						<cfif isdefined("Form.DEidentificacionFiltro") and Len(Trim(Form.DEidentificacionFiltro)) NEQ 0>
							<cfset filtro = filtro & " and upper(DEidentificacion)  like '%" & UCase(Form.DEidentificacionFiltro) & "%'">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEidentificacionFiltro=" & Form.DEidentificacionFiltro>
						</cfif>
						<cfif isdefined("Form.sel") and form.sel NEQ 1>
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "sel=" & form.sel>				
						</cfif>
						<!--- Pintado de la Pantalla --->		
	   					<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<cfif isdefined("form.o") and form.o eq 4 and isdefined("form.DLLinea")>
								<cfset regresar = "javascript:history.back();">
							<cfelse>
								<cfset regresar = "/cfmx/rh/index.cfm">
							</cfif>		
							<tr>
								<td>
									<cfinclude template="/rh/portlets/pNavegacion.cfm">
								</td>
							</tr>	  
							<form name="formBuscar" method="post" action="">			  	  
								<tr> 
									<td valign="middle" align="right">  
								  		<label id="letiqueta1">
											<a href="javascript: buscar();"><cf_translate key="LB_Seleccione_un_Empleado">Seleccione un empleado</cf_translate></a>
										</label>
								  		<a href="javascript: buscar();"><img src="/cfmx/rh/imagenes/iindex.gif" name="imageBusca" border="0" id="imageBusca"></a>
									</td>
								</tr>
							</form>	  							
							<tr style="display: ;" id="verPagina"> 
								<td>
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  								<tr style="display: ;" id="verPagina">
		    								<td>
												<table width="100%" border="0" cellspacing="0" cellpadding="0">
                									<tr>
                  									<td><cfinclude template="header.cfm"></td>
                									</tr>
                									<tr>
                  									<td>
															<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#tabNames[tabChoice]#'>
																<br>
																<cf_tabs width="100%">
																	 <cf_tab text=#tabNames[1]# selected="#tabChoice eq 1#">
																		<cfif tabChoice eq 1>
																			<cfinclude template="datosEmpleado.cfm">
																		</cfif>
																	</cf_tab>
																	
																<cf_tab text=#tabNames[2]# selected="#tabChoice eq 2#">
                      												<cfif tabChoice eq 2 and tabAccess[tabChoice]>
                        												<cfinclude template="direcciones.cfm">
                      												</cfif>
												 				</cf_tab>
																<cf_tab text=#tabNames[3]# selected="#tabChoice eq 3#">
																	<cfif tabChoice eq 3 and tabAccess[tabChoice]>
																		<cfinclude template="familiares.cfm">
																	</cfif>
												 				</cf_tab>
																<cf_tab text=#tabNames[4]# selected="#tabChoice eq 4#">
																	<cfif tabChoice eq 4 and tabAccess[tabChoice]>
																		<cfinclude template="anotaciones.cfm">
																	</cfif>
																</cf_tab>
																<cf_tab text=#tabNames[5]# selected="#tabChoice eq 5#">
																	<cfif tabChoice eq 5 and tabAccess[tabChoice]>
																		<cfinclude template="datosLaborales.cfm">
																	</cfif>
																</cf_tab>
																<cf_tab text=#tabNames[6]# selected="#tabChoice eq 6#">
																	<cfif tabChoice eq 6 and tabAccess[tabChoice]>
																		<cfinclude template="acciones.cfm">
																	</cfif>
																</cf_tab>
																<cf_tab text=#tabNames[7]# selected="#tabChoice eq 7#">
																	<cfif tabChoice eq 7 and tabAccess[tabChoice]>
																		<cfinclude template="cargas.cfm">
																	</cfif>
																</cf_tab>
																<cf_tab text=#tabNames[8]# selected="#tabChoice eq 8#">
																	<cfif tabChoice eq 8 and tabAccess[tabChoice]>
																		<cfinclude template="deducciones.cfm">
																	</cfif>
																</cf_tab>
																<cf_tab text=#tabNames[9]# selected="#tabChoice eq 9#">
																	<cfif tabChoice eq 9 and tabAccess[tabChoice]>
																		<cfquery datasource="#Session.DSN#" name="rsEncabRevisa">
																			select eve.DEid
																			from EVacacionesEmpleado eve, DatosEmpleado de
																			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
																				and eve.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
																				and eve.DEid=de.DEid
																		</cfquery>
																		<cfif rsEncabRevisa.recordCount GT 0>
																			<cfinclude template="vacaciones.cfm">
																		<cfelse>
																			<div align="center"> <br><br><b><cf_translate key="MSG_Este_empleado_no_posee_ENCABEZADO_de_vacaciones">Este empleado no posee ENCABEZADO de vacaciones</cf_translate></b><br><br></div>
																		</cfif>
																	<cfelse>														
																		<div align="center"> <b><cf_translate key="MSG_Este_modulo_no_esta_disponible">Este m&oacute;dulo no est&aacute; disponible</cf_translate></b></div>
																	</cfif>
																</cf_tab>
																<cf_tab text=#tabNames[10]# selected="#tabChoice eq 10#">
																	<cfif tabChoice eq 10 and tabAccess[tabChoice]>
																		<cfinclude template="ObjetosEmpleado.cfm">
																	</cfif>
																</cf_tab>
																<cf_tab text=#tabNames[11]# selected="#tabChoice eq 11#">
																	<cfif tabChoice eq 11 and tabAccess[tabChoice]>
																		<cfinclude template="anualidades.cfm">
																	</cfif>
												 				</cf_tab>
																<cfquery name="rs" datasource="#session.dsn#">
																	select 1
																	from ACParametros
																	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																</cfquery>
																<cfif rs.RecordCount>
																	<cf_tab text=#tabNames[12]# selected="#tabChoice eq 12#">
																		<cfif tabChoice eq 12 and tabAccess[tabChoice]>
																			<cfinclude template="asociados.cfm">
																		</cfif>
																	</cf_tab>
																</cfif>
																</cf_tabs>	</br>
															<cf_web_portlet_end>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<!--- Validaciones por medio de JavaScript --->
						<script type="text/javascript">
							<!--
							function tab_set_current (n){
								validaDEid(escape(n),'expediente-cons.cfm?o='+escape(n)+'&tab='+escape(n)+'&sel=1');
							}
							//-->
						</script>															
						<script language="JavaScript" type="text/javascript">
							var Bandera = "L";
							function buscar() {
								location.href = '/cfmx/rh/expediente/catalogos/expediente-lista.cfm';
								/*
								var connVerLista			= document.getElementById("verLista");
								var connVerPagina			= document.getElementById("verPagina");				
								var connVerFiltroListaEmpl	= document.getElementById("verFiltroListaEmpl");								
								var connVerEtiqueta1		= document.getElementById("letiqueta1");												
								var connVerEtiqueta2		= document.getElementById("letiqueta2");																
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
									document.formBuscar.imageBusca.alt="Mantenimientos";
								}
								else{	//Pagina
									Bandera = "L";				
									connVerLista.style.display = "none";
									connVerFiltroListaEmpl.style.display = "none";					
									connVerPagina.style.display = "";
									document.formBuscar.imageBusca.src="/cfmx/rh/imagenes/iindex.gif";					
									connVerEtiqueta1.style.display = "";
									connVerEtiqueta2.style.display = "none";										
									document.formBuscar.imageBusca.alt="Lista de empleados";
								}
								*/
							}				
						</script>		
					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>
