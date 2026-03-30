<!--- <cf_dump var="#form#"> --->

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
    
    <script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	Default="Distribuci&oacute;n contable de rubros por empleado"
	VSgrupo="103"
	returnvariable="nombre_proceso"/>


		<cfinclude template="/rh/Utiles/params.cfm" >
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
		<table width="100%" cellpadding="2" cellspacing="0" >
			<tr>
				<td valign="top">
					<!--- ========================================================= --->
					<!---          T A B S     D E     T R A D U C C I O N          --->
					<!--- ========================================================= --->
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
	   					<table width="100%" border="0" cellspacing="0" cellpadding="0" >
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
                                        <tr colspan="2">
                                                <td><cfinclude template="header.cfm"></td>
                                            </tr>
                                        <tr>
                                        	<td colspan="2">
                                            	<cfinclude template="/rh/portlets/pEmpleado.cfm">
                                            </td>
                                        </tr>
										<tr style="display: ;" id="verPagina" >
                                           <td valign="top"  width="40%">
                                            	<cfinclude template="distribucionHelp.cfm">
                                            </td>
                                           
                                            <td valign="top" >
												<table width="100%" border="0" cellspacing="0" cellpadding="0">

                									<tr>
                  										<td>
															<cf_tabs width="100%">
                      											<cf_tab text=#tabNames[1]# selected="#tabChoice eq 1#">
                      												<cfif tabChoice eq 1>
                        												 <cfinclude template="Salarios.cfm"> <!------>
                      												</cfif>
												 				</cf_tab>
																<cf_tab text=#tabNames[2]# selected="#tabChoice eq 2#">
																	<cfif tabChoice eq 2 >
																		 <cfinclude template="incidencias.cfm"> <!------>
																	</cfif>
												 				</cf_tab>
																<cf_tab text=#tabNames[3]# selected="#tabChoice eq 3#">
																	<cfif tabChoice eq 3 >
																		 <cfinclude template="cargas.cfm"> <!------>
																	</cfif>
																</cf_tab>
															</cf_tabs>		
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
								validaDEid(escape(n),'distribucion.cfm?o='+escape(n)+'&tab='+escape(n)+'&sel=1');
							}
							//-->
						</script>															
						<script language="JavaScript" type="text/javascript">
							var Bandera = "L";
							function buscar() {
								location.href = 'distribucion-lista.cfm';
							}				
						</script>		
					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>
