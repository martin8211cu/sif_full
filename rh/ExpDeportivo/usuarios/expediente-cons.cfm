 <cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cfinvoke component="sif.Componentes.TranslateDB"
		method="Translate"
		VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
		Default="Mantenimiento de jugadores"
		VSgrupo="103"
		returnvariable="nombre_proceso"/>

	<!--- <cf_templatearea name="title">
		<cfoutput>#nombre_proceso#</cfoutput>
	</cf_templatearea>
	
	<cf_templatearea name="body">
		<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0> --->
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top"> 
					<!--- ========================================================= --->
					<!---          T A B S     D E     T R A D U C C I O N          --->
					<!--- ========================================================= --->
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Identificacion"
						
						Default="Identificaci&oacute;n"
						returnvariable="vIdentificacion"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Nombre"
						
						Default="Nombre"
						returnvariable="vNombre"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_jugador"
						
						Default="jugador"
						returnvariable="vjugador"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Filtrar"
						
						Default="Filtrar"
						returnvariable="vFiltrar"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Nuevo_jugador"
						Default="Nuevo jugador"
						returnvariable="vNuevojugador"/>
					<!--- ========================================================= --->
					<!---          T A B S     D E     T R A D U C C I O N          --->
					<!--- ========================================================= --->
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Administracion_de_Personas"
Default="Administraci&oacute;n de Personas"
returnvariable="LB_Administracion_de_Personas"/>

<cf_templateheader title="#LB_Administracion_de_Personas#">
	<cfif isdefined("Url.o") and not isdefined("Form.o")>
		<cfset Form.o = Url.o>
	</cfif>
	<script language="javascript" type="text/javascript">
		function showList(arg) {
			var a = document.getElementById("divCuentas");
			var b = document.getElementById("divForm");
			if (a != null && b != null) {
				if (arg) {
					a.style.display = ''
					b.style.display = 'none'
				} else {
					a.style.display = 'none'
					b.style.display = ''
				}
			}
		}
	</script>

	 <!--- Codigo cuando se quiere crear una nueva cuenta empresarial se borra de session --->
	<cfif isdefined("Form.o") and Form.o EQ 2>
		<cfinclude template="Finalizar.cfm">
	</cfif>

	<!--- Archivo que carga datos en session --->
	<cfinclude template="../Proyecto/frame-config.cfm">

	<div id="divCuentas" style="display: none; ">
		<cfinclude template="expediente-lista.cfm">
	</div>
	<div id="divForm">
		<table width="100%" border="0" cellpadding="4" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinclude template="datosEmpleado.cfm">
				</td>
			</tr>
		</table>
		</div>
		<cfif isdefined("Form.o") and Form.o EQ 1>
		<script language="javascript" type="text/javascript">
			showList(true);
		</script>
	</cfif>
<!--- <cf_templatefooter> ---> 
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
											<a href="javascript: buscar();"><cf_translate key="LB_Seleccione_un_jugador">Seleccione un jugador</cf_translate></a>
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
															<cf_tabs width="100%">
																<cf_tab text=#tabNames[1]# selected="#tabChoice eq 1#">
                      												<cfif tabChoice eq 1>
                        												<cfinclude template="datosEmpleado.cfm">
                      												</cfif>
												 				</cf_tab>
																<cf_tab text=#tabNames[2]# selected="#tabChoice eq 2#">
																	
																	<cfif tabChoice eq 2 >
																		<cfinclude template="familiares.cfm">
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
								validaDEid(escape(n),'expediente-cons.cfm?o='+escape(n)+'&tab='+escape(n)+'&sel=1');
							}
							//-->
						</script>															
						<script language="JavaScript" type="text/javascript">
							var Bandera = "L";
							function buscar() {
								location.href = '/cfmx/rh/ExpDeportivo/usuarios/expediente-lista.cfm';

							}				
						</script>		
			
				</td>	
			</tr>
		</table>	

 --->