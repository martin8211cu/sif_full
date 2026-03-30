<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_PerfilIdealDelPuesto" Default="Perfil ideal del puesto" returnvariable="LB_PerfilIdealDelPuesto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Filtrar" Default="Filtrar" returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Usuario" Default="Usuario" returnvariable="LB_Usuario" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Estado" Default="Estado" returnvariable="LB_Estado" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_FechaModificacion" Default="Fecha Modificación" returnvariable="LB_FechaModificacion" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_EnProceso" Default="En proceso" returnvariable="LB_EnProceso"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Aprobado" Default="Aprobado" returnvariable="LB_Aprobado" component="sif.Componentes.Translate"method="Translate"/>	
<cfinvoke Key="LB_Inactivo" Default="Inactivo" returnvariable="LB_Inactivo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>	
<cfinvoke Key="LB_Esperando_aprobacion_del_encargado_del_Centro_Funcional" Default="Esperando aprobaci&oacute;n del encargado del centro funcional al que pertenece el puesto" returnvariable="LB_Esperando_aprobacion_del_encargado_del_Centro_Funcional" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke method="Translate" Key="LB_Esperando_aprobacion_del_jefe_del_asesor" Default="Esperando aprobaci&oacute;n del jefe del asesor" returnvariable="LB_Esperando_aprobacion_del_jefe_del_asesor" component="sif.Componentes.Translate"/>	
<cfinvoke Key="LB_En_proceso_de_revisicion_por_rechazo" Default="En proceso de revisici&oacute;n por rechazo " returnvariable="LB_En_proceso_de_revisicion_por_rechazo" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_Asesor" Default="Asesor" returnvariable="LB_Asesor" component="sif.Componentes.Translate" method="Translate"/>		
<cfinvoke Key="ALT_Mantenimientos" Default="Mantenimientos" returnvariable="ALT_Mantenimientos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="ALT_ListaDePuestos" Default="Lista de puestos" returnvariable="ALT_ListaDePuestos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_PerfilIdealDelPuesto" Default="Perfil ideal del puesto" returnvariable="LB_PerfilIdealDelPuesto" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cfquery name="RSTipo" datasource="#session.DSN#">
	select ltrim(rtrim(Pvalor)) as Modo  
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 690				
</cfquery>

<!--- <cfdump var="#session.Usucodigo#"> --->
 
<cfif isdefined("RSTipo") and len(trim(RSTipo.Modo)) and RSTipo.Modo eq 'P'>
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
					   <cf_web_portlet_start border="true" titulo="#LB_PerfilIdealDelPuesto#" skin="#Session.Preferences.Skin#">
							<cfif isdefined("Url.codigoFiltro") and not isdefined("Form.codigoFiltro")>
								<cfparam name="Form.codigoFiltro" default="#Url.codigoFiltro#">
							</cfif>
							<cfif isdefined("Url.descripcionFiltro") and not isdefined("Form.descripcionFiltro")>
								<cfparam name="Form.descripcionFiltro" default="#Url.descripcionFiltro#">
							</cfif>		
							
							<cfif isdefined("Url.UsuarioFiltro") and not isdefined("Form.UsuarioFiltro")>
								<cfparam name="Form.UsuarioFiltro" default="#Url.UsuarioFiltro#">
							</cfif>	
							
							<cfif isdefined("Url.RHPactivoFiltro") and not isdefined("Form.RHPactivoFiltro")>
								<cfparam name="Form.RHPactivoFiltro" default="#Url.RHPactivoFiltro#">
							</cfif>	
							<cfif not isdefined("Url.RHPactivoFiltro") and not isdefined("Form.RHPactivoFiltro")>
								<cfparam name="Form.RHPactivoFiltro" default="1">
							</cfif>
							
							
							<cfif isdefined("Url.EstadoFiltro") and not isdefined("Form.EstadoFiltro")>
								<cfparam name="Form.EstadoFiltro" default="#Url.EstadoFiltro#">
							</cfif>	
							<cfif not isdefined("Url.EstadoFiltro") and not isdefined("Form.EstadoFiltro")>
								<cfparam name="Form.EstadoFiltro" default="">
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
							
							<cfif isdefined("Form.RHPactivoFiltro") >
								<cfif isdefined("Form.RHPactivoFiltro") and Len(Trim(Form.RHPactivoFiltro)) NEQ 0>	
									<cfset filtro = filtro & " and RHPactivo  = " & UCase(Form.RHPactivoFiltro)>
	              </cfif>
								<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPactivoFiltro=" & Form.RHPactivoFiltro>
						  </cfif>		
						  
						  <cfif isdefined("Form.EstadoFiltro") >
								<cfif isdefined("Form.EstadoFiltro") and Len(Trim(Form.EstadoFiltro)) NEQ 0>	
									<cfset filtro = filtro & " and Estado  = " & UCase(Form.EstadoFiltro)>
	              </cfif>
								<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EstadoFiltro=" & Form.EstadoFiltro>
						  </cfif>						
							
							
							
							
							
							<cfif isdefined("Form.UsuarioFiltro") and Len(Trim(Form.UsuarioFiltro)) NEQ 0>
								<cfset filtro = filtro & " and upper(coalesce(c.Usulogin,'"&UCase(Form.UsuarioFiltro) &"'))  like '%" & UCase(Form.UsuarioFiltro) & "%'">
								<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "UsuarioFiltro=" & Form.UsuarioFiltro>
							</cfif>
							
							
							
							
							<cfset filtro = filtro & " and not exists ( select 1 from RHDescripPuestoP x
																		where x.Ecodigo = #Session.Ecodigo# 
																		and a.RHPcodigo = x.RHPcodigo
																		and a.Ecodigo = x.Ecodigo
																		and x.Estado not in (10,45,50) )">
							
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
										<form name="formFiltroListaEmpl" method="post" action="Puestos-lista.cfm">
											<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
											<input type="hidden" name="sel" value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">				
											<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tituloListas">
												<tr> 
												<td width="27%" height="17" ><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></td>
													<td width="27%" ><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></td>
													<td width="27%" ><cf_translate key="LB_Estatus">Estatus</cf_translate></td>
													<td width="27%" ><cf_translate key="LB_Estatus">Estado</cf_translate></td>
													<td width="10%" ><cf_translate key="LB_Usuario">Usuario</cf_translate></td>
													
													
													<td width="5%" colspan="2" rowspan="2">
														<input name="btnFiltrar" class="btnFiltrar" type="submit" id="btnFiltrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>" tabindex="1">
													</td>
												</tr>
												<tr>
													<td><input name="codigoFiltro" type="text" id="codigoFiltro" size="30" maxlength="60" tabindex="1" value="<cfif isdefined('form.codigoFiltro')><cfoutput>#form.codigoFiltro#</cfoutput></cfif>"></td>
													<td><input name="descripcionFiltro" type="text" id="descripcionFiltro" size="70" maxlength="260" tabindex="1" value="<cfif isdefined('form.descripcionFiltro')><cfoutput>#form.descripcionFiltro#</cfoutput></cfif>"></td>
													<td>
													<select name="RHPactivoFiltro">
														<option value="" <cfif isdefined('form.RHPactivoFiltro') and  form.RHPactivoFiltro eq ''> selected </cfif>><cf_translate key="LB_Estatus">Todos</cf_translate></option>
													    <option value="0" <cfif isdefined('form.RHPactivoFiltro') and  form.RHPactivoFiltro eq '0'> selected <cfelseif  not isdefined('form.RHPactivoFiltro')> selected </cfif>><cf_translate key="LB_Inactivo">Inactivo</cf_translate></option>
													    <option value="1" <cfif isdefined('form.RHPactivoFiltro') and  form.RHPactivoFiltro eq '1'> selected </cfif>><cf_translate key="LB_Activo">Activo</cf_translate></option>
													</select>
													</td>	
													<td>
													<select name="EstadoFiltro">
														<option value="" <cfif isdefined('form.EstadoFiltro') and  form.EstadoFiltro eq ''> selected <cfelseif  not isdefined('form.EstadoFiltro')> selected  </cfif>><cf_translate key="LB_Todos">Todos</cf_translate></option>
													    <option value="10" <cfif isdefined('form.EstadoFiltro') and  form.EstadoFiltro eq '10'> selected </cfif>><cf_translate key="LB_EnProceso">En Proceso</cf_translate></option>
													</select>
													</td>
															
													
																							
													<td><input name="UsuarioFiltro" type="text" id="UsuarioFiltro" size="20" maxlength="50" tabindex="1" value="<cfif isdefined('form.UsuarioFiltro')><cfoutput>#form.UsuarioFiltro#</cfoutput></cfif>"></td>
	
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
	
													<CFSET USUARIO = 'ASESOR'>
													<cfquery name="RSDeid" datasource="#session.DSN#">
														select ltrim(rtrim(llave)) as Deid  from UsuarioReferencia  
														where  Usucodigo   = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
														and STabla = 'DatosEmpleado'
														and Ecodigo = <cfqueryparam value="#session.EcodigoSDC#" cfsqltype="cf_sql_numeric">
													</cfquery>
													 <cfinvoke component="rh.Componentes.RH_Funciones" 
														method="DeterminaJefe"
														DEid = "#RSDeid.DEid#"
														fecha = "#Now()#"
														returnvariable="esjefe">
													<cfif esjefe.jefe neq 0>
														<cfquery name="RSJEFEASESOR" datasource="#session.DSN#">
															select ltrim(rtrim(Pvalor)) as CFID  
															from RHParametros
															where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
															and Pcodigo = 700				
														</cfquery>
														<cfif RSJEFEASESOR.recordCount GT 0>
															<cfif RSJEFEASESOR.CFID eq esjefe.CFID>
																<CFSET USUARIO = 'ASESORSP'>
															</cfif>	
														</cfif>					
													</cfif>
													
													<cfset checked = "<img src=''/cfmx/rh/imagenes/checked.gif'' border=''0''>">
													<cfset unchecked = "<img src=''/cfmx/rh/imagenes/unchecked.gif'' border=''0''>">							
													
													<cfinvoke 
														component="rh.Componentes.pListas"
														method="pListaRH"
														returnvariable="pListaEmpl">
														<cfinvokeargument name="tabla" value="RHPuestos a
															left outer join RHDescripPuestoP  b
																on a.RHPcodigo = b.RHPcodigo
																and a.Ecodigo = b.Ecodigo
																and b.Estado in (10)
																
															left outer join Usuario c
																on b.UsuarioAsesor = c.Usucodigo"/>
														<cfinvokeargument name="columnas" value="coalesce(b.RHDPPid,-1) as RHDPPid,a.RHPcodigo as RHPcodigo, coalesce(a.RHPcodigoext, a.RHPcodigo) as RHPcodigoext,a.RHPdescpuesto,b.FechaModAsesor,c.Usulogin,
														case Estado 
															when 10  then '#LB_EnProceso#' 
															else ''
														end as estado,'#USUARIO#' as usuario,
														case a.RHPactivo when 0 then '#checked#' else '#unchecked#' end as RHPactivo
														"/>
														<cfinvokeargument name="desplegar" value="RHPcodigoext, RHPdescpuesto,RHPactivo, Usulogin,FechaModAsesor,estado"/>
														<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,#LB_Inactivo#,#LB_Usuario#,#LB_FechaModificacion#,&nbsp;"/>
														<cfinvokeargument name="formatos" value="S,S,S,S,D,S"/>
														<cfinvokeargument name="formName" value="listaPuestos"/>	
														<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo# #filtro# order by a.RHPcodigo, a.RHPdescpuesto"/>
														<cfinvokeargument name="align" value="left,left,center,left,center,left"/>
														<cfinvokeargument name="ajustar" value="N"/>
														<cfinvokeargument name="irA" value="PerfilPuesto.cfm"/>
														<cfinvokeargument name="keys" value="RHDPPid,RHPcodigo,usuario"/>
														<cfinvokeargument name="MaxRows" value="10"/>
														<cfinvokeargument name="navegacion" value="#navegacion#">
													</cfinvoke>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
								<tr><td>
									
									<fieldset><legend><cf_translate key="LB_Perfiles_en_proceso_de_Aprobacion" >Perfiles en proceso de Aprobaci&oacute;n</cf_translate></legend>
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr><td>
												<cfset filtroAprob = "">
												<cfset navegacion2 = "">
												<cfif isdefined("Form.codigoFiltro") and Len(Trim(Form.codigoFiltro)) NEQ 0>
													<cfset filtroAprob = filtroAprob & " and upper(coalesce(RHPcodigoext,a.RHPcodigo)) like '%" & #UCase(Form.codigoFiltro)# & "%'">
													<cfset navegacion2 = navegacion2 & Iif(Len(Trim(navegacion2)) NEQ 0, DE("&"), DE("")) & "codigoFiltro=" & Form.codigoFiltro>
												</cfif>
												
												<cfif isdefined("Form.descripcionFiltro") and Len(Trim(Form.descripcionFiltro)) NEQ 0>
													<cfset filtroAprob = filtroAprob & " and upper(a.RHPdescpuesto)  like '%" & UCase(Form.descripcionFiltro) & "%'">
													<cfset navegacion2 = navegacion2 & Iif(Len(Trim(navegacion2)) NEQ 0, DE("&"), DE("")) & "descripcionFiltro=" & Form.descripcionFiltro>
												</cfif>
												
												<cfif isdefined("Form.RHPactivoFiltro") >
													<cfif isdefined("Form.RHPactivoFiltro") and Len(Trim(Form.RHPactivoFiltro)) NEQ 0>	
														<cfset filtroAprob = filtroAprob & " and RHPactivo  = " & UCase(Form.RHPactivoFiltro)>
													</cfif>
													<cfset navegacion2 = navegacion2 & Iif(Len(Trim(navegacion2)) NEQ 0, DE("&"), DE("")) & "RHPactivoFiltro=" & Form.RHPactivoFiltro>
											  	</cfif>		
											  
											  	<cfif isdefined("Form.EstadoFiltro") >
													<cfif isdefined("Form.EstadoFiltro") and Len(Trim(Form.EstadoFiltro)) NEQ 0>	
														<cfset filtroAprob = filtroAprob & " and Estado  = " & UCase(Form.EstadoFiltro)>
						             				 </cfif>
													<cfset navegacion2 = navegacion2 & Iif(Len(Trim(navegacion2)) NEQ 0, DE("&"), DE("")) & "EstadoFiltro=" & Form.EstadoFiltro>
											 	 </cfif>						
												<cfif isdefined("Form.UsuarioFiltro") and Len(Trim(Form.UsuarioFiltro)) NEQ 0>
													<cfset filtroAprob = filtroAprob & " and upper(coalesce(c.Usulogin,'"&UCase(Form.UsuarioFiltro) &"'))  like '%" & UCase(Form.UsuarioFiltro) & "%'">
													<cfset navegacion2 = navegacion2 & Iif(Len(Trim(navegacion2)) NEQ 0, DE("&"), DE("")) & "UsuarioFiltro=" & Form.UsuarioFiltro>
												</cfif>
											<cfinvoke component="rh.Componentes.pListas" method="pListaRH" returnvariable="pListaEmpl">
											<cfinvokeargument name="tabla" value="RHPuestos a
												inner join RHDescripPuestoP  b
													on a.RHPcodigo = b.RHPcodigo
													and a.Ecodigo = b.Ecodigo
													and b.Estado in (15,20,30,40,35)
												inner join Usuario c
													on b.UsuarioAsesor = c.Usucodigo"/>
											<cfinvokeargument name="columnas" value="b.RHDPPid,a.RHPcodigo as RHPcodigo, coalesce(a.RHPcodigoext, a.RHPcodigo) as RHPcodigoext,a.RHPdescpuesto,b.FechaModAsesor,c.Usulogin,
											case Estado 
												when 15  then '#LB_Esperando_aprobacion_del_encargado_del_Centro_Funcional#' 
												when 20  then '#LB_Esperando_aprobacion_del_jefe_del_asesor#' 
												when 30  then '#LB_Esperando_aprobacion_del_jefe_del_asesor#'
												when 35  then '#LB_En_proceso_de_revisicion_por_rechazo#'
												when 40  then '#LB_En_proceso_de_revisicion_por_rechazo#'
												else ''
											end as estado,
											case a.RHPactivo when 0 then '#checked#' else '#unchecked#' end as RHPactivo
											"/>
											<cfinvokeargument name="desplegar" value="RHPcodigoext, RHPdescpuesto,RHPactivo,estado,Usulogin"/>
											<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,#LB_Inactivo#,&nbsp;,#LB_Asesor#"/>
											<cfinvokeargument name="formatos" value="S,S,s,S,S"/>
											<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo#  order by a.RHPcodigo, a.RHPdescpuesto"/>
											<cfinvokeargument name="align" value="left,left,left,left,left"/>
											<cfinvokeargument name="formName" value="listaPuestos2"/>
											<cfinvokeargument name="PageIndex" value="2"/>
											<cfinvokeargument name="ajustar" value="N"/>
											 <cfinvokeargument name="showLink" value="FALSE"/><!--- --->
											<cfinvokeargument name="irA" value="PerfilPuesto.cfm"/>
											<cfinvokeargument name="keys" value="RHDPPid,RHPcodigo"/>
											<cfinvokeargument name="MaxRows" value="10"/>
											<cfinvokeargument name="navegacion" value="#navegacion2#">
										</cfinvoke>
										
										
										
										</td></tr>
									</table>
									</fieldset>
								</td></tr>
							</table>

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
