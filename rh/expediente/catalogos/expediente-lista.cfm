<!--- VARIABLES DE TRADUCCION --->
<cfsilent>
<cfinvoke Default="Mantenimiento de Empleados" VSgrupo="103" returnvariable="nombre_proceso" component="sif.Componentes.TranslateDB" method="Translate" VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"/>
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke key="LB_Identificacion" Default="Identificaci&oacute;n" returnvariable="vIdentificacion" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
<cfinvoke key="LB_Nombre" Default="Nombre" returnvariable="vNombre" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
<cfinvoke key="LB_Empleado" Default="Empleado" returnvariable="vEmpleado" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
<cfinvoke key="LB_Filtrar" Default="Filtrar" returnvariable="vFiltrar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
<cfinvoke key="LB_Nuevo_Empleado" Default="Nuevo Empleado" returnvariable="vNuevoEmpleado" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/expediente/catalogos/expediente-cons.xml"/>
<cfinvoke key="LB_Activos" Default="Activos" returnvariable="vActivos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
<cfinvoke key="LB_Inactivos" Default="Inactivos" returnvariable="vInactivos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
<cfinvoke key="LB_Todos" Default="Todos" returnvariable="vTodos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>			
<cfinvoke key="LB_Estado" Default="Estado" returnvariable="vEstado" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"	/>
<cfinvoke key="LB_IdTarjeta" Default="Id Tarjeta" returnvariable="vTarjeta" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>	
</cfsilent>
<!--- FIN VARIABLES DE TRADUCCION --->
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	
		<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">

						
					<!--- ========================================================== --->
					<!--- ========================================================== --->

					<cf_web_portlet_start border="true" titulo="<cfoutput>#nombre_proceso#</cfoutput>" skin="#Session.Preferences.Skin#">
						<cfif isdefined("Url.nombreFiltro") and not isdefined("Form.nombreFiltro")>
							<cfparam name="Form.nombreFiltro" default="#Url.nombreFiltro#">
						</cfif>
						<cfif isdefined("Url.DEidentificacionFiltro") and not isdefined("Form.DEidentificacionFiltro")>
							<cfparam name="Form.DEidentificacionFiltro" default="#Url.DEidentificacionFiltro#">
						</cfif>		
						<cfif isdefined("Url.estadoFiltro") and not isdefined("Form.estadoFiltro")>
							<cfparam name="Form.estadoFiltro" default="#Url.estadoFiltro#">
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
							<cfset filtro = filtro & " and upper({fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, DEnombre) }) like '%" & #TRIM(UCase(Form.nombreFiltro))# & "%'">

							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombreFiltro=" & Form.nombreFiltro>
						</cfif>
						<cfif isdefined("Form.DEidentificacionFiltro") and Len(Trim(Form.DEidentificacionFiltro)) NEQ 0>
							<cfset filtro = filtro & " and upper(DEidentificacion)  like '%" & TRIM(UCase(Form.DEidentificacionFiltro)) & "%'">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEidentificacionFiltro=" & Form.DEidentificacionFiltro>
						</cfif>
						<cfif isdefined("Form.estadoFiltro") and Len(Trim(Form.estadoFiltro)) NEQ 0>
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "estadoFiltro=" & Form.estadoFiltro>
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
												<td width="50%" class="fileLabel"><cfoutput>#vNombre#</cfoutput></td>
												<td width="18%" class="fileLabel"><cfoutput>#vEstado#</cfoutput></td>
												<td width="5%" colspan="2" rowspan="2"><input name="btnFiltrar" class="btnFiltrar" type="submit" id="btnFiltrar" value="<cfoutput>#vFiltrar#</cfoutput>"></td>
											</tr>
											<tr> 
												<td><input name="DEidentificacionFiltro" type="text" id="DEidentificacionFiltro" size="30" maxlength="60" value="<cfif isdefined('form.DEidentificacionFiltro')><cfoutput>#form.DEidentificacionFiltro#</cfoutput></cfif>"></td>
												<td><input name="nombreFiltro" type="text" id="nombreFiltro2" size="60" maxlength="260" value="<cfif isdefined('form.nombreFiltro')><cfoutput>#form.nombreFiltro#</cfoutput></cfif>"></td>
												<td>
													<select name="estadoFiltro" id="estadoFiltro">
														<cfoutput>
														<option value="T" <cfif isdefined("form.estadoFiltro") and form.estadoFiltro eq 'T'>selected</cfif>>#vTodos#</option>
														<option value="A" <cfif isdefined("form.estadoFiltro") and form.estadoFiltro eq 'A'>selected</cfif>>#vActivos#</option>
														<option value="I" <cfif isdefined("form.estadoFiltro") and form.estadoFiltro eq 'I'>selected</cfif>>#vInactivos#</option>														
														</cfoutput>
													</select>
												</td>
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
												
												<cfquery name="rsParam910" datasource="#session.DSN#">
												select coalesce(Pvalor, '0') as Pvalor
												from RHParametros 
												where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												  and Pcodigo = 910 
											  </cfquery>
											     <cfif rsParam910.recordCount GT 0>
													<cfset Param910 =  rsParam910.Pvalor>
												<cfelse>
													<cfset Param910 =  0>
												</cfif>
																					
												<cfquery name="rsLista" result="rsLista_PlistaResult_" datasource="#session.DSN#">
													select DEid,
														   DEidentificacion,
														   DEtarjeta,
														   {fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, DEnombre) } as nombreEmpl, 
														   1 as o, 
														   1 as sel,
														   'ALTA' as modo

													from DatosEmpleado

													where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
													<cfif isdefined("filtro") and len(trim(filtro))>
														#PreserveSingleQuotes(filtro)#
													</cfif>
													
													<cfif isdefined("Form.estadoFiltro") and listfind('A,I', form.estadoFiltro) >
														and <cfif Form.estadoFiltro eq 'I'>not</cfif> exists (	select 1
																												from LineaTiempo lt
																												where lt.DEid = DatosEmpleado.DEid
																												  and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta )
													</cfif>
													
													order by DEidentificacion, {fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, DEnombre) }
												</cfquery>

												<cfinvoke 
										 			component="rh.Componentes.pListas"
										 			method=	"pListaQuery"
										 			returnvariable="pListaEmpl">
										 			<cfinvokeargument name="query" value="#rsLista#"/>
										 			<cfinvokeargument name="useAJAX" value="yes">
										 			<cfinvokeargument name="queryresult" value="#rsLista_PlistaResult_#">
										 			<cfinvokeargument name="datasource" value="#session.DSN#">

													<cfif isdefined("Param910") and Param910 eq 1>
														<cfinvokeargument name="desplegar" value="DEidentificacion, DEtarjeta, nombreEmpl"/>
														<cfinvokeargument name="etiquetas" value="#vIdentificacion#,#vTarjeta#,#vEmpleado#"/>
														<cfinvokeargument name="align" value="left,left,left"/>
													<cfelse>
														<cfinvokeargument name="desplegar" value="DEidentificacion, nombreEmpl"/>
														<cfinvokeargument name="etiquetas" value="#vIdentificacion#,#vEmpleado#"/>
														<cfinvokeargument name="align" value="left,left"/>
													</cfif>																				
													<cfinvokeargument name="formatos" value=""/>
													<cfinvokeargument name="formName" value="listaEmpleados"/>	
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
<cf_templatefooter>
