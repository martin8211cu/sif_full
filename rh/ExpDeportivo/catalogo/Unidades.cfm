<!--- DE la linea 2 a la  7 es utilizado para agregar la plantilla usara todas la pantallas del sistema  --->
<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatearea name="title">
		<cf_translate key="LB_Expediente_Deportivo" XmlFile="/rh/ExpDeportivo/generales.xml">Expediente Deportivo</cf_translate>
	</cf_templatearea>
	<cf_templatearea name="body">
<!--- Tag para agregar la hoja de estilos utilizada en la pantañña  --->
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

					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr> 
						
							<script language="JavaScript1.2" type="text/javascript">
								function limpiar(){
									document.filtro.fEDUcodigo.value = "";
									document.filtro.fEDUdescripcion.value   = "";
								}
							</script>
							<cfset filtro = "">
							<cfif isdefined("form.fEDUcodigo") and len(trim(form.fEDUcodigo)) gt 0 >
								<cfset filtro = filtro & " and upper(EDUcodigo) like '%#ucase(form.fEDUcodigo)#%' " >
							</cfif>
							<cfif isdefined("form.fEDUdescripcion") and len(trim(form.fEDUdescripcion)) gt 0 >
								<cfset filtro = filtro & " and upper(EDUdescripcion) like '%#ucase(form.fEDUdescripcion)#%' " >
							</cfif>
							<cfset filtro = filtro & "order by EDUcodigo">
						
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Unidades"
							Default="Unidades"
							returnvariable="LB_Unidades"/>

						<td valign="top">
						<cf_web_portlet_start titulo="#LB_Unidades#">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
						 
							<tr> 
							  <td colspan="3" >
									<cfinclude template="/rh/portlets/pNavegacion.cfm">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top" width="50%">
											<!--- AREA DE BUSQUEDA --->
												<form name="filtro" method="post">
													<table border="0" width="100%" class="tituloListas">
														<tr> 
															<td><cf_translate key="LB_Codigo" XmlFile="/rh/ExpDeportivo/generales.xml">C&oacute;digo</cf_translate></td>
															<td colspan="2"><cf_translate key="LB_Descripcion" XmlFile="/rh/ExpDeportivo/generales.xml">Descripci&oacute;n</cf_translate></td>
														</tr>
														<tr> 
															<td><input type="text" name="fEDUcodigo" tabindex="1" value="<cfif isdefined("form.fEDUcodigo") and len(trim(form.fEDUcodigo)) gt 0 ><cfoutput>#form.fEDUcodigo#</cfoutput></cfif>" size="5" maxlength="5" onFocus="javascript:this.select();"></td>
															<td><input type="text" name="fEDUdescripcion" tabindex="1" value="<cfif isdefined("form.fEDUdescripcion") and len(trim(form.fEDUdescripcion)) gt 0 ><cfoutput>#form.fEDUdescripcion#</cfoutput></cfif>" size="40" maxlength="60" onFocus="javascript:this.select();" ></td>
															<td nowrap>
																<cfinvoke component="sif.Componentes.Translate"
																	method="Translate"
																	Key="BTN_Filtrar"
																	Default="Filtrar"
																	XmlFile="/rh/ExpDeportivo/generales.xml"
																	returnvariable="BTN_Filtrar"/>
																
																<cfinvoke component="sif.Componentes.Translate"
																	method="Translate"
																	Key="BTN_Limpiar"
																	Default="Limpiar"
																	XmlFile="/rh/ExpDeportivo/generales.xml"
																	returnvariable="BTN_Limpiar"/>
																<cfoutput>
																<input type="submit" name="Filtrar" value="#BTN_Filtrar#" tabindex="1">
																<input type="button" name="Limpiar" value="#BTN_Limpiar#" tabindex="1" onClick="javascript:limpiar();">
																
																</cfoutput>
															</td>
														</tr>
													</table>
												</form>
												
						<cfquery name="rsLista" datasource="#session.DSN#">
									select EDUid, EDUcodigo, EDUdescripcion
									from EDUnidad
									where 1=1
									#PreserveSingleQuotes(filtro)#
								
						</cfquery>
																	
												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="LB_Codigo"
													Default="C&oacute;digo"
													XmlFile="/rh/ExpDeportivo/generales.xml"
													returnvariable="LB_Codigo"/>
												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="LB_Descripcion"
													Default="Descripci&oacute;n"
													XmlFile="/rh/ExpDeportivo/generales.xml"
													returnvariable="LB_Descripcion"/>
												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="LB_Equivalencia"
													Default="Equivalencia"
													XmlFile="/rh/ExpDeportivo/generales.xml"
													returnvariable="LB_Equivalencia"/>
											
												<cfinvoke 
												 component="rh.Componentes.pListas"
												 method="pListaQuery"
												 returnvariable="pListaRet">
													<cfinvokeargument name="query" value="#rsLista#"/>
													<cfinvokeargument name="columnas" value="EDUid,EDUcodigo, EDUdescripcion"/>
													<cfinvokeargument name="desplegar" value="EDUcodigo, EDUdescripcion"/>
													<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
													<cfinvokeargument name="formatos" value="V, V"/>
													<cfinvokeargument name="filtro" value="#filtro#"/>
													<cfinvokeargument name="align" value="left,left"/>
													<cfinvokeargument name="ajustar" value="N"/>
													<cfinvokeargument name="checkboxes" value="N"/>
													<cfinvokeargument name="irA" value="Unidades.cfm"/>
													<cfinvokeargument name="keys" value="EDUid"/>
												</cfinvoke>
											</td>
											<!--- AREA DE BUSQUEDA --->
											<td width="50%" valign="top"><cfinclude template="formUnidades.cfm"></td>
										</tr>
									</table>
							  </td>
							  <td >&nbsp;</td>
							</tr>
							</table> 
						<cf_web_portlet_end>
						
						  </td>
					  </tr>
					</table>
	</cf_templatearea>
</cf_template>