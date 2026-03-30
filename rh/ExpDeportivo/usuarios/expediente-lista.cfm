<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Mantenimiento_de_Jugadores"
	Default="Mantenimiento de Jugadores"
	returnvariable="LB_Mantenimiento_de_Jugadores"/>

	<cf_templatearea name="title">
		<cfoutput>#LB_Mantenimiento_de_Jugadores#</cfoutput>
	</cf_templatearea>
	
	<cf_templatearea name="body">
		<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">

					<!--- ========================================================== --->
					<!--- 						TRADUCCION							 --->
					<!--- ========================================================== --->
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Identificacion"
						xmlfile="/rh/generales.xml"	
						Default="Identificaci&oacute;n"
						returnvariable="vIdentificacion"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Nombre"
						xmlfile="/rh/generales.xml"	
						Default="Nombre"
						returnvariable="vNombre"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Empleado"
						xmlfile="/rh/generales.xml"	
						Default="Empleado"
						returnvariable="vEmpleado"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Filtrar"
						xmlfile="/rh/generales.xml"	
						Default="Filtrar"
						returnvariable="vFiltrar"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Nuevo_Jugador"
						Default="Nuevo Jugador"
						xmlfile="/rh/expediente/catalogos/expediente-cons.xml"
						returnvariable="vNuevoEmpleado"/>
					<!--- ========================================================== --->
					<!--- ========================================================== --->

					<cf_web_portlet_start border="true" titulo="<cfoutput>#LB_Mantenimiento_de_Jugadores#</cfoutput>" skin="#Session.Preferences.Skin#">
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
	   					<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<cfif isdefined("form.o") and form.o eq 4 and isdefined("form.DLLinea")>
								<cfset regresar = "javascript:history.back();">
							<cfelse>
								<cfset regresar = "/cfmx/rh/index.cfm">
							</cfif>		
							<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>	  
							<tr style="display: ;" id="verFiltroListaEmpl"> 
								<td> 
							  		<form name="formFiltroListaEmpl" method="post" action="expediente-lista.cfm">
										<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
										<input type="hidden" name="sel" value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">				
										<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
											<tr> 
												<td width="27%" height="17" class="fileLabel"><cfoutput>#vIdentificacion#</cfoutput></td>
												<td width="68%" class="fileLabel"><cfoutput>#vNombre#</cfoutput></td>
												<td width="5%" colspan="2" rowspan="2"><input name="btnFiltrar" class="btnFiltrar" type="submit" id="btnFiltrar" value="<cfoutput>#vFiltrar#</cfoutput>"></td>
											</tr>
											<tr> 
												<td><input name="DEidentificacionFiltro" type="text" id="DEidentificacionFiltro" size="30" maxlength="60" value="<cfif isdefined('form.DEidentificacionFiltro')><cfoutput>#form.DEidentificacionFiltro#</cfoutput></cfif>"></td>
												<td><input name="nombreFiltro" type="text" id="nombreFiltro2" size="100" maxlength="260" value="<cfif isdefined('form.nombreFiltro')><cfoutput>#form.nombreFiltro#</cfoutput></cfif>"></td>
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
												<cfquery name="rsLista" datasource="#session.DSN#">
													select DEid,
														   DEidentificacion,
														   {fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, DEnombre) } as nombreEmpl, 
														   1 as o, 
														   1 as sel,
														   'ALTA' as modo

													from DatosEmpleado

													where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
													<cfif isdefined("filtro") and len(trim(filtro))>
														#PreserveSingleQuotes(filtro)#
													</cfif>
													order by DEidentificacion, {fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, DEnombre) }
												</cfquery>

												<cfinvoke 
										 			component="rh.Componentes.pListas"
										 			method=	"pListaQuery"
										 			returnvariable="pListaEmpl">
										 			<cfinvokeargument name="query" value="#rsLista#"/>

													<cfinvokeargument name="desplegar" value="DEidentificacion, nombreEmpl"/>
													<cfinvokeargument name="etiquetas" value="#vIdentificacion#,#vEmpleado#"/>
													<cfinvokeargument name="formatos" value=""/>
													<cfinvokeargument name="formName" value="listaEmpleados"/>	
													<cfinvokeargument name="align" value="left,left"/>
													<cfinvokeargument name="ajustar" value="N"/>
													<cfinvokeargument name="irA" value="expediente-cons.cfm"/>
													<cfinvokeargument name="navegacion" value="#navegacion#"/>
													<cfinvokeargument name="keys" value="DEid"/>
												</cfinvoke>
											</td>
								  		</tr>
			  					  		<tr>
								  			<td align="center">
												<form name="formNuevoEmplLista" method="post" action="expediente-cons.cfm">
													<input type="hidden" name="o" value="1">
													<input type="hidden" name="sel" value="1">
													<input name="btnNuevoLista" class="btnNuevo" type="submit" value="<cfoutput>#vNuevoEmpleado#</cfoutput>">
												</form>
											</td>
			 							</tr>
									</table>
		 				 		</td>
        					</tr>

							<!---
							<tr style="display: ;" id="verPagina"> 
         						<td> 
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td><cfinclude template="header.cfm"></td>
										</tr>
										<tr>
											<td>
												<cf_tabs width="100%">
													<cf_tab text=#tabNames[1]# selected="#tabChoice eq 1#">
														<cfif tabChoice eq 1>
															<cfinclude template="datosEmpleado.cfm">
														</cfif>
												 	</cf_tab>
													<cf_tab text=#tabNames[2]# selected="#tabChoice eq 2#">
														<cfif tabChoice eq 2 and tabAccess[tabChoice]>
															<cfinclude template="familiares.cfm">
														</cfif>
													</cf_tab>
													<cf_tab text=#tabNames[3]# selected="#tabChoice eq 3#">
														<cfif tabChoice eq 3 and tabAccess[tabChoice]>
															<cfinclude template="anotaciones.cfm">
														</cfif>
													</cf_tab>
													<cf_tab text=#tabNames[4]# selected="#tabChoice eq 4#">
														<cfif tabChoice eq 4 and tabAccess[tabChoice]>
															<cfinclude template="datosLaborales.cfm">
														</cfif>
													</cf_tab>
													<cf_tab text=#tabNames[5]# selected="#tabChoice eq 5#">
														<cfif tabChoice eq 5 and tabAccess[tabChoice]>
															<cfinclude template="acciones.cfm">
														</cfif>
													</cf_tab>
													<cf_tab text=#tabNames[6]# selected="#tabChoice eq 6#">
														<cfif tabChoice eq 6 and tabAccess[tabChoice]>
															<cfinclude template="cargas.cfm">
														</cfif>
													</cf_tab>
													<cf_tab text=#tabNames[7]# selected="#tabChoice eq 7#">
														<cfif tabChoice eq 7 and tabAccess[tabChoice]>
															<cfinclude template="deducciones.cfm">
														</cfif>
													</cf_tab>
													<cf_tab text=#tabNames[8]# selected="#tabChoice eq 8#">
														<cfif tabChoice eq 8 and tabAccess[tabChoice]>
															<cfquery datasource="#Session.DSN#" name="rsEncabRevisa">
																select eve.DEid
																from EVacacionesEmpleado eve,
																	DatosEmpleado de
																where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
																	and eve.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
																	and eve.DEid=de.DEid
															</cfquery>
															<cfif rsEncabRevisa.recordCount GT 0>
																<cfinclude template="vacaciones.cfm">
															<cfelse>
																<div align="center"> <br><br><b><cf_translate xmlfile="/rh/expediente/catalogos/expediente-cons.xml" key="MSG_Este_empleado_no_posee_ENCABEZADO_de_vacaciones">Este empleado no posee ENCABEZADO de vacaciones</cf_translate></b><br><br></div>
															</cfif>
														<cfelse>														
															<div align="center"> <b><cf_translate xmlfile="/rh/expediente/catalogos/expediente-cons.xml"   key="MSG_Este_modulo_no_esta_disponible">Este m&oacute;dulo no est&aacute; disponible</cf_translate></b></div>
														</cfif>
									 				</cf_tab>
												</cf_tabs>		
											</td>
										</tr>
									</table>
		  						</td>
							</tr>
							--->
     			 		</table>
						<script language="JavaScript" type="text/javascript">
							var Bandera = "L";
							function buscar(){
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
							function limpiaFiltrado(){
								document.formFiltroListaEmpl.filtrado.value = "";
								document.formFiltroListaEmpl.sel.value = 0;
							}
				</script>		
			<cf_web_portlet_end>
		</td>	
	</tr>
</table>	
</cf_templatearea>
</cf_template>