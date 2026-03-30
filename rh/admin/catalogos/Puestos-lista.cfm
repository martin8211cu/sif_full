<cfquery name="RSTipo" datasource="#session.DSN#">
	select ltrim(rtrim(Pvalor)) as Modo
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 690
</cfquery>

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
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
				  <!--- navegacion --->                  <!---
					<cfif isdefined("form.PageNum_lista")>
						<cfset form.pagina = form.PageNum_lista >
					<cfelseif isdefined("url.PageNum_lista")>
						<cfset form.pagina = url.PageNum_lista >
					<cfelseif isdefined("form.PageNum")>
						<cfset form.pagina = form.PageNum >
					<cfelseif isdefined("url.PageNum")>
						<cfset form.pagina = url.PageNum >
					<cfelseif isdefined("url.pagina")>
						<cfset form.pagina = url.pagina >
					<cfelseif not isdefined("form.pagina")>
						<cfset form.pagina = 1 >
					</cfif>
					<cfdump var="La paginacion es: #form.pagina#">
					--->	              <!--- fin nav --->

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Puestos"
						Default="Puestos"
						returnvariable="LB_Puestos"/>

				   <cf_web_portlet_start border="true" titulo="#LB_Puestos#" skin="#Session.Preferences.Skin#">
						<cfif isdefined("Url.codigoFiltro") and not isdefined("Form.codigoFiltro")>
							<cfparam name="Form.codigoFiltro" default="#Url.codigoFiltro#">
						</cfif>
						<cfif isdefined("Url.descripcionFiltro") and not isdefined("Form.descripcionFiltro")>
							<cfparam name="Form.descripcionFiltro" default="#Url.descripcionFiltro#">
						</cfif>

                        <cfif isdefined("Url.RHPactivoFiltro") and not isdefined("Form.RHPactivoFiltro")>
							<cfparam name="Form.RHPactivoFiltro" default="#Url.RHPactivoFiltro#">
						</cfif>

                        <cfif not isdefined("Url.RHPactivoFiltro") and not isdefined("Form.RHPactivoFiltro")>
							<cfparam name="Form.RHPactivoFiltro" default="1">
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
							<cfset filtro = filtro & " and upper(coalesce(RHPcodigoext,a.RHPcodigo)) like '%" & #UCase(Form.codigoFiltro)# & "%'">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "codigoFiltro=" & Form.codigoFiltro>
						</cfif>
						<cfif isdefined("Form.descripcionFiltro") and Len(Trim(Form.descripcionFiltro)) NEQ 0>
							<cfset filtro = filtro & " and upper(RHPdescpuesto)  like '%" & UCase(Form.descripcionFiltro) & "%'">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "descripcionFiltro=" & Form.descripcionFiltro>
						</cfif>

                        <cfif isdefined("Form.RHPactivoFiltro") >
							<cfif isdefined("Form.RHPactivoFiltro") and Len(Trim(Form.RHPactivoFiltro)) NEQ 0>
								<cfset filtro = filtro & " and RHPactivo  = " & UCase(Form.RHPactivoFiltro)>
                            </cfif>
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPactivoFiltro=" & Form.RHPactivoFiltro>
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
									<form name="formFiltroListaEmpl" method="post" action="Puestos-lista.cfm">
										<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
										<input type="hidden" name="sel" value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">
										<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tituloListas">
											<tr>
												<td width="27%" height="17" ><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></td>
												<td width="27%" ><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></td>
                                                <td width="27%" ><cf_translate key="LB_Estatus">Estatus</cf_translate></td>
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
                            					<td>
                                                <select name="RHPactivoFiltro">
                                                	<option value="" <cfif isdefined('form.RHPactivoFiltro') and  form.RHPactivoFiltro eq ''> selected </cfif>><cf_translate key="LB_Estatus">Todos</cf_translate></option>
                                                    <option value="0" <cfif isdefined('form.RHPactivoFiltro') and  form.RHPactivoFiltro eq '0'> selected <cfelseif  not isdefined('form.RHPactivoFiltro')> selected </cfif>><cf_translate key="LB_Inactivo">Inactivo</cf_translate></option>
                                                    <option value="1" <cfif isdefined('form.RHPactivoFiltro') and  form.RHPactivoFiltro eq '1'> selected </cfif>><cf_translate key="LB_Activo">Activo</cf_translate></option>
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


												<cfif isdefined("RSTipo") and len(trim(RSTipo.Modo)) and RSTipo.Modo eq 'P'>
													<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="LB_Aprobacion"
													Default="En Aprobaci&oacute;n"
													returnvariable="LB_Aprobacion"/>

													<cfinvoke
														component="sif.Componentes.pListas"
														method="pListaRH"
														returnvariable="pListaEmpl">
														<cfinvokeargument name="tabla" value="RHPuestos a
																							  left outer join RHDescripPuestoP b
																							  	on a.RHPcodigo = b.RHPcodigo
																								and a.Ecodigo = b.Ecodigo
																								and  Estado < 45 "/>
														<cfinvokeargument name="columnas" value="a.RHPcodigo as RHPcodigo, coalesce(a.RHPcodigoext, a.RHPcodigo) as RHPcodigoext, RHPdescpuesto,
																 case RHPactivo when 0 then '#checked#' else '#unchecked#' end as RHPactivo,
																 case when RHDPPid is not null  then '#checked#' else '&nbsp;' end as Aprobacion,  1 as o,1 as sel"/>
														<cfinvokeargument name="desplegar" value="RHPcodigoext, RHPdescpuesto, RHPactivo,Aprobacion"/>
														<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#, #LB_Inactivo#, #LB_Aprobacion#"/>
														<cfinvokeargument name="formatos" value="S,S,V,V"/>
														<cfinvokeargument name="formName" value="listaPuestos"/>
														<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo# #filtro# order by a.RHPcodigo, RHPdescpuesto"/>
														<cfinvokeargument name="align" value="left,left, center, center"/>
														<cfinvokeargument name="ajustar" value="N"/>
														<cfinvokeargument name="irA" value="Puestos.cfm"/>
														<cfinvokeargument name="navegacion" value="#navegacion#"/>
														<cfinvokeargument name="keys" value="RHPcodigo"/>
													</cfinvoke>
												<cfelse>
													<cfinvoke
														component="sif.Componentes.pListas"
														method="pListaRH"
														returnvariable="pListaEmpl">
														<cfinvokeargument name="tabla" value="RHPuestos a "/>
														<cfinvokeargument name="columnas" value="RHPcodigo as RHPcodigo, coalesce(RHPcodigoext, RHPcodigo) as RHPcodigoext, RHPdescpuesto, case RHPactivo when 0 then '#checked#' else '#unchecked#' end as RHPactivo, 1 as o,1 as sel"/>
														<cfinvokeargument name="desplegar" value="RHPcodigoext, RHPdescpuesto, RHPactivo"/>
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


												</cfif>
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
						</script>
					<cf_web_portlet_end>
				</td>
			</tr>
		</table>
<cf_templatefooter>