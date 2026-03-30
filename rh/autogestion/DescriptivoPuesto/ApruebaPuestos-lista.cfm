<!--- significado de cada uno de los usuarios 

ASESOR 		es cuando el usario crea un perfil nuevo en estado 10
ASESORM 	es cuando el perfil esta siendo modificado por un asesor 
ASESORSP	es cuando el usuario que crea el perfil es el jefe de asesores
JEFEASESOR	cuando el usuario es el jefe asesor y se encuentra en proceso de aprobacion de un perfil enviado por otro usuario
JEFECF		cuando el usuario es el encargado del centro funcional de un puesto que se encuentra en un perfil.
JEFECFNM	cuando el usuario es el encargado del centro funcional de un puesto que se encuentra en un perfil pero no puede modificar.
 --->
 
<cfquery name="RSTipo" datasource="#session.DSN#">
	select ltrim(rtrim(Pvalor)) as Modo  
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 690				
</cfquery> 
<cfquery name="RS710" datasource="#session.DSN#">
	select ltrim(rtrim(Pvalor)) as modifica  
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 710				
</cfquery> 
 
 
<cfif isdefined("RSTipo") and len(trim(RSTipo.Modo)) and RSTipo.Modo eq 'P'>
	<CFSET USUARIO = 'JEFEASESOR'>
	 
	<cfquery name="RSDeid" datasource="#session.DSN#">
		select ltrim(rtrim(llave)) as Deid  from UsuarioReferencia  
		where  Usucodigo   = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
		and STabla = 'DatosEmpleado'
		and Ecodigo = <cfqueryparam value="#session.EcodigoSDC#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<!--- <cf_dump var="#RSDeid#"> --->
	 
	 <cfinvoke component="rh.Componentes.RH_Funciones" 
		method="DeterminaJefe"
		DEid = "#RSDeid.DEid#"
		fecha = "#Now()#"
		returnvariable="esjefe">
		
	
	<cfif esjefe.jefe eq 0>
		<CFSET USUARIO = 'ASESORM'>
	<cfelse>
		<cfquery name="RSJEFEASESOR" datasource="#session.DSN#">
			select ltrim(rtrim(Pvalor)) as CFID  
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 700				
		</cfquery>
		<cfif RSJEFEASESOR.recordCount GT 0>
			<cfif RSJEFEASESOR.CFID eq esjefe.CFID>
				<CFSET USUARIO = 'JEFEASESOR'>
			<cfelse>
				<cfquery name="RSPuestos" datasource="#session.DSN#">
					select distinct RHPpuesto  
					from RHPlazas                        
					where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#esjefe.CFID#"> 
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHPactiva = 1
				</cfquery>
				<cfset listapuestos ="">
				<cfloop query="RSPuestos">
					<cfset listapuestos = listapuestos & "'"  & RSPuestos.RHPpuesto & "',">
				</cfloop>
				<cfset listapuestos = listapuestos & "'-1'">
				<cfif isdefined("RS710") and len(trim(RS710.modifica)) and RS710.modifica eq 'N'>
					<CFSET USUARIO = 'JEFECFNM'>
				<cfelse>
					<CFSET USUARIO = 'JEFECF'>
				</cfif>
			</cfif> 
		<cfelse>
			<cfquery name="RSPuestos" datasource="#session.DSN#">
				select distinct RHPpuesto  
				from RHPlazas                        
				where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#esjefe.CFID#"> 
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHPactiva = 1
			</cfquery>
			<cfset listapuestos ="">
			<cfloop query="RSPuestos">
				<cfset listapuestos = listapuestos & "'"  & RSPuestos.RHPpuesto & "',">
			</cfloop>
			<cfset listapuestos = listapuestos & "'-1'">		
			<cfif isdefined("RS710") and len(trim(RS710.modifica)) and RS710.modifica eq 'N'>
				<CFSET USUARIO = 'JEFECFNM'>
			<cfelse>
				<CFSET USUARIO = 'JEFECF'>
			</cfif>
			
		</cfif>
	</cfif>
	<cf_template template="#session.sitio.template#">
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
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr> 
					<td valign="top"> 
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_PerfilIdealDelPuesto"
							Default="Perfil ideal del puesto"
							returnvariable="LB_PerfilIdealDelPuesto"/>
	
					   <cf_web_portlet_start border="true" titulo="#LB_PerfilIdealDelPuesto#" skin="#Session.Preferences.Skin#">
							<cfif isdefined("Url.codigoFiltro") and not isdefined("Form.codigoFiltro")>
								<cfparam name="Form.codigoFiltro" default="#Url.codigoFiltro#">
							</cfif>
							<cfif isdefined("Url.descripcionFiltro") and not isdefined("Form.descripcionFiltro")>
								<cfparam name="Form.descripcionFiltro" default="#Url.descripcionFiltro#">
							</cfif>		
							
							<cfif USUARIO eq 'ASESORM'>
								<cfif isdefined("Url.UsuarioFiltro") and not isdefined("Form.UsuarioFiltro")>
									<cfparam name="Form.UsuarioFiltro" default="#Url.UsuarioFiltro#">
								</cfif>
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
							
							 <cfif USUARIO eq 'JEFECF' or  USUARIO eq 'JEFECFNM'>
								<cfset filtro = " and a.CFid = #esjefe.CFID# ">
							<cfelse>
								<cfset filtro = "">
							</cfif> 
							
							<cfset navegacion = "">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
							
							<cfif isdefined("Form.RHDPPid")>
								<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHDPPid=" & #form.RHDPPid#>				
							</cfif>
							
							<cfif isdefined("Form.codigoFiltro") and Len(Trim(Form.codigoFiltro)) NEQ 0>
								<cfset filtro = filtro & " and upper(coalesce(RHPcodigoext,a.RHPcodigo)) like '%" & #UCase(Form.codigoFiltro)# & "%'">
								<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "codigoFiltro=" & Form.codigoFiltro>
							</cfif>
							
							<cfif isdefined("Form.descripcionFiltro") and Len(Trim(Form.descripcionFiltro)) NEQ 0>
								<cfset filtro = filtro & " and upper(a.RHPdescpuesto)  like '%" & UCase(Form.descripcionFiltro) & "%'">
								<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "descripcionFiltro=" & Form.descripcionFiltro>
							</cfif>
							
							<cfif USUARIO eq 'ASESORM'>
								<cfif isdefined("Form.UsuarioFiltro") and Len(Trim(Form.UsuarioFiltro)) NEQ 0>
									<cfset filtro = filtro & " and upper(coalesce(c.Usulogin,'"&UCase(Form.UsuarioFiltro) &"'))  like '%" & UCase(Form.UsuarioFiltro) & "%'">
									<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "UsuarioFiltro=" & Form.UsuarioFiltro>
								<cfelse>
									<cfset filtro = filtro & " and upper(coalesce(c.Usulogin,'"&UCase(session.Usulogin) &"'))  like '%" & UCase(session.Usulogin) & "%'">
									<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "UsuarioFiltro=" & session.Usulogin>
								</cfif>
							</cfif>
							
							
							<cfif isdefined("Form.sel") and form.sel NEQ 1>
								<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "sel=" & form.sel>				
							</cfif>
							<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
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
													<label id="letiqueta3">
													<cfif isdefined("form.RHDPPid")>
													<a href="javascript: reporte();">
													  <cf_translate key="LB_PrevioDelDescriptivoDelPuesto">Previo del descriptivo del puesto</cf_translate>: 
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
										<form name="formFiltroListaEmpl" method="post" action="ApruebaPuestos-lista.cfm">
											<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
											<input type="hidden" name="sel" value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">				
											<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tituloListas">
												<tr> 
												<td width="27%" height="17" ><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></b></td>
													<td width="58%" ><cf_translate key="LB_DescripcionPuestoPuesto">Descripci&oacute;n Puesto</cf_translate></b></td>
													
													
													<td width="10%" >
													<cfif USUARIO eq 'ASESORM'>
														<cf_translate key="LB_Usuario">Usuario</cf_translate>
													</cfif>
													</td>
													
													
													
													<td width="5%" colspan="2" rowspan="2">
														<cfinvoke component="sif.Componentes.Translate"
															method="Translate"
															Key="BTN_Filtrar"
															Default="Filtrar"
															XmlFile="/rh/generales.xml"
															returnvariable="BTN_Filtrar"/>
	
														<input name="btnFiltrar" class="btnFiltrar" type="submit" id="btnFiltrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>" tabindex="1">
													</td>
												</tr>
												<tr>
													<td><input name="codigoFiltro" type="text" id="codigoFiltro" size="30" maxlength="60" tabindex="1" value="<cfif isdefined('form.codigoFiltro')><cfoutput>#form.codigoFiltro#</cfoutput></cfif>"></td>
													<td><input name="descripcionFiltro" type="text" id="descripcionFiltro" size="70" maxlength="260" tabindex="1" value="<cfif isdefined('form.descripcionFiltro')><cfoutput>#form.descripcionFiltro#</cfoutput></cfif>"></td>
													<td><cfif USUARIO eq 'ASESORM'><input name="UsuarioFiltro" type="text" id="UsuarioFiltro" size="20" maxlength="50" tabindex="1" value="<cfif isdefined('form.UsuarioFiltro')><cfoutput>#form.UsuarioFiltro#</cfoutput><cfelse><cfoutput>#session.Usulogin#</cfoutput></cfif>"></cfif></td>
	
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
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="LB_Codigo"
														Default="C&oacute;digo"
														XmlFile="/rh/generales.xml"
														returnvariable="LB_Codigo"/>
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="LB_DescripcionPuesto"
														Default="Descripci&oacute;n Puesto"
														returnvariable="LB_DescripcionPuesto"/>
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="LB_Usuario"
														Default="Usuario"
														returnvariable="LB_Usuario"/>
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="LB_Estado"
														Default="Estado"
														returnvariable="LB_Estado"/>	
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="LB_FechaModificacion"
														Default="Fecha Modificación"
														returnvariable="LB_FechaModificacion"/>	
														
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="LB_EnProceso"
														Default="En proceso"
														returnvariable="LB_EnProceso"/>
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="LB_Aprobado"
														Default="Aprobado"
														returnvariable="LB_Aprobado"/>	
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="LB_Enviado_por_el_asesor"
														Default="Enviado por el asesor"
														returnvariable="LB_Enviado_por_el_asesor"/>
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="LB_Enviado_por_el_encargado_del_centro_funcional_del_puesto"
														Default="Enviado por el encargado del centro funcional del puesto"
														returnvariable="LB_Enviado_por_el_encargado_del_centro_funcional_del_puesto"/>	
													
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="LB_Modificado_por_el_encargado_del_centro_funcional_del_puesto"
														Default="Modificado por el encargado del centro funcional del puesto"
														returnvariable="LB_Modificado_por_el_encargado_del_centro_funcional_del_puesto"/>
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="LB_Rechazado_por_el_encargado_del_centro_funcional_del_puesto"
														Default="Rechazado por el encargado del centro funcional del puesto"
														returnvariable="LB_Rechazado_por_el_encargado_del_centro_funcional_del_puesto"/>			
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="LB_Rechazado_por_el_jefe_del_asesor"
														Default="Rechazado por el jefe del asesor"
														returnvariable="LB_Rechazado_por_el_jefe_del_asesor"/>	
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="LB_Inactivo"
														Default="Inactivo"
														XmlFile="/rh/generales.xml"
														returnvariable="LB_Inactivo"/>		

													<cfset checked = "<img src=''/cfmx/rh/imagenes/checked.gif'' border=''0''>">
													<cfset unchecked = "<img src=''/cfmx/rh/imagenes/unchecked.gif'' border=''0''>">							
	
														
													<cfinvoke 
														component="rh.Componentes.pListas"
														method="pListaRH"
														returnvariable="pListaEmpl">
														<cfif USUARIO eq 'JEFEASESOR'>
														
															<cfinvokeargument name="tabla" value="RHPuestos a
																inner join RHDescripPuestoP  b
																	on a.RHPcodigo = b.RHPcodigo
																	and a.Ecodigo = b.Ecodigo
																	and b.Estado in (30,20)
																inner join Usuario c
																	on b.UsuarioAsesor = c.Usucodigo"/>
															<cfinvokeargument name="columnas" value="b.RHDPPid,a.RHPcodigo as RHPcodigo, coalesce(a.RHPcodigoext, a.RHPcodigo) as RHPcodigoext,a.RHPdescpuesto,b.FechaModAsesor,c.Usulogin,
																case Estado 
																when 20  then {fn concat('#LB_Enviado_por_el_asesor# ',Usulogin)}
																when 30  then '#LB_Enviado_por_el_encargado_del_centro_funcional_del_puesto#' 
																end as estado,
																case a.RHPactivo when 0 then '#checked#' else '#unchecked#' end as RHPactivo,
																'#USUARIO#' as usuario
																"/>
															<cfinvokeargument name="desplegar" value="RHPcodigoext,RHPdescpuesto,RHPactivo,estado"/>
															<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_DescripcionPuesto#,#LB_Inactivo#,&nbsp;"/>
															<cfinvokeargument name="formatos" value="S,S,S,S"/>		
															<cfinvokeargument name="align" value="left,left,left,left"/>															
	
														<cfelseif USUARIO eq 'ASESORM'>
															<cfinvokeargument name="tabla" value="RHPuestos a
																inner join RHDescripPuestoP  b
																	on a.RHPcodigo = b.RHPcodigo
																	and a.Ecodigo = b.Ecodigo
																	and b.Estado in (25,35,40)
																inner join Usuario c
																	on b.UsuarioAsesor = c.Usucodigo"/>
															<cfinvokeargument name="columnas" value="b.RHDPPid,a.RHPcodigo as RHPcodigo, coalesce(a.RHPcodigoext, a.RHPcodigo) as RHPcodigoext,a.RHPdescpuesto,b.FechaModAsesor,c.Usulogin,
																case Estado 
																when 25  then '#LB_Modificado_por_el_encargado_del_centro_funcional_del_puesto#'
																when 35  then '#LB_Rechazado_por_el_encargado_del_centro_funcional_del_puesto#' 
																when 40  then '#LB_Rechazado_por_el_jefe_del_asesor#' 
																end as estado,
																case a.RHPactivo when 0 then '#checked#' else '#unchecked#' end as RHPactivo,
																'#USUARIO#' as usuario
																"/>
															<cfinvokeargument name="desplegar" value="RHPcodigoext, RHPdescpuesto,RHPactivo,Usulogin,FechaModAsesor,estado"/>
															<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_DescripcionPuesto#,#LB_Inactivo#,#LB_Usuario#,#LB_FechaModificacion#,&nbsp;"/>
															<cfinvokeargument name="formatos" value="S,S,S,S,D,S"/>	
															<cfinvokeargument name="align" value="left,left,left,left,center,left"/>
															
														<cfelseif USUARIO eq 'JEFECF' or  USUARIO eq 'JEFECFNM'>
															<!--- and a.RHPcodigo in (#PreserveSingleQuotes(listapuestos)#) --->	
															<cfinvokeargument name="tabla" value="RHPuestos a
																inner join RHDescripPuestoP  b
																	on a.RHPcodigo = b.RHPcodigo
																	and a.Ecodigo = b.Ecodigo
																	and b.Estado in (15)
																inner join Usuario c
																	on b.UsuarioAsesor = c.Usucodigo"/>
															<cfinvokeargument name="columnas" value="b.RHDPPid,a.RHPcodigo as RHPcodigo, coalesce(a.RHPcodigoext, a.RHPcodigo) as RHPcodigoext,a.RHPdescpuesto,b.FechaModAsesor,c.Usulogin,
																case Estado 
																when 15  then {fn concat('#LB_Enviado_por_el_asesor# ',Usulogin)}
																end as estado,
																case a.RHPactivo when 0 then '#checked#' else '#unchecked#' end as RHPactivo,
																'#USUARIO#' as usuario
																"/>
															<cfinvokeargument name="desplegar" value="RHPcodigoext,RHPdescpuesto,RHPactivo,estado"/>
															<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_DescripcionPuesto#,#LB_Inactivo#,&nbsp;"/>
															<cfinvokeargument name="formatos" value="S,S,S,S"/>		
															<cfinvokeargument name="align" value="left,left,left,left"/>	
															
														</cfif>
														<cfinvokeargument name="formName" value="listaPuestos"/>	
														<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo# #filtro# order by a.RHPcodigo, a.RHPdescpuesto"/>
														<cfinvokeargument name="ajustar" value="N"/>
														<cfinvokeargument name="irA" value="ApruebaPerfilPuesto.cfm"/>
														<cfinvokeargument name="keys" value="RHDPPid,RHPcodigo,usuario"/>
													</cfinvoke>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
							</table>
							<script type="text/javascript">
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
								//buscar();
							</script>
						<cf_web_portlet_end>
					</td>	
				</tr>
			</table>	
		</cf_templatearea>
	</cf_template>
<cfelse>	
	<cf_template template="#session.sitio.template#">
		<cf_templatearea name="title">
			<cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate>
		</cf_templatearea>
		
		<cf_templatearea name="body">
			<cf_templatecss>	
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_PerfilIdealDelPuesto"
					Default="Perfil ideal del puesto"
					returnvariable="LB_PerfilIdealDelPuesto"/>
					
			 <cf_web_portlet_start border="true" titulo="#LB_PerfilIdealDelPuesto#" skin="#Session.Preferences.Skin#">
					<table width="100%" border="0">
					  <tr>
							<td colspan="3">
								<cfinclude template="/rh/portlets/pNavegacion.cfm">
							</td>
					  </tr>
					  
					  <tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>
					   <tr>
						<td>&nbsp;</td>
						<td align="center"><b><cf_translate  key="LB_x">Esta opci&oacute;n se puede accesar </cf_translate></b></td>
						<td>&nbsp;</td>
					  </tr>
					   <tr>
						<td>&nbsp;</td>
						<td align="center"><b><cf_translate  key="LB_x">Si en par&aacute;metros generales de Recursos humanos</cf_translate></b></td>
						<td>&nbsp;</td>
					  </tr>
					   <tr>
						<td>&nbsp;</td>
						<td align="center"><b><cf_translate  key="LB_x">Tag M&oacute;dulos, Perfil ideal de puesto</cf_translate></b></td>
						<td>&nbsp;</td>
					  </tr>
					   <tr>
						<td>&nbsp;</td>
						<td align="center"><b><cf_translate  key="LB_x">opci&oacute;n tipo de aprobaci&oacute;n se encuentre por aprobaci&oacute;n</cf_translate></b></td>
						<td>&nbsp;</td>
					  </tr>					  
					</table>

			<cf_web_portlet_end>
		</cf_templatearea>
	</cf_template>
</cfif>