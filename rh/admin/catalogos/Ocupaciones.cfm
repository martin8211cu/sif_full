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

					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr> 
						<td valign="top" width="1%">
							<script language="JavaScript1.2" type="text/javascript">
								function limpiar(){
									document.filtro.fRHOcodigo.value = "";
									document.filtro.fRHOdescripcion.value   = "";
								}
							</script>
					
							<cfset filtro = " 1=1 ">
							<cfif isdefined("form.fRHOcodigo") and len(trim(form.fRHOcodigo)) gt 0 >
								<cfset filtro = filtro & " and upper(RHOcodigo) like '%#ucase(form.fRHOcodigo)#%' " >
							</cfif>
							<cfif isdefined("form.fRHOdescripcion") and len(trim(form.fRHOdescripcion)) gt 0 >
								<cfset filtro = filtro & " and upper(RHOdescripcion) like '%#ucase(form.fRHOdescripcion)#%' " >
							</cfif>
							<cfset filtro = filtro & "order by RHOcodigo">
						</td>	
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Ocupaciones"
							Default="Ocupaciones"
							returnvariable="LB_Ocupaciones"/>

						<td valign="top">
						<cf_web_portlet_start titulo="#LB_Ocupaciones#">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
						 
							<tr> 
							  <td colspan="3" >
									<cfinclude template="/rh/portlets/pNavegacion.cfm">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top" width="50%">
												<form name="filtro" method="post">
													<table border="0" width="100%" class="tituloListas">
														<tr> 
															<td><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></td>
															<td colspan="2"><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></td>
														</tr>
														<tr> 
															<td><input type="text" name="fRHOcodigo" tabindex="1" value="<cfif isdefined("form.fRHOcodigo") and len(trim(form.fRHOcodigo)) gt 0 ><cfoutput>#form.fRHOcodigo#</cfoutput></cfif>" size="5" maxlength="5" onFocus="javascript:this.select();"></td>
															<td><input type="text" name="fRHOdescripcion" tabindex="1" value="<cfif isdefined("form.fRHOdescripcion") and len(trim(form.fRHOdescripcion)) gt 0 ><cfoutput>#form.fRHOdescripcion#</cfoutput></cfif>" size="40" maxlength="60" onFocus="javascript:this.select();" ></td>
															<td nowrap>
																<cfinvoke component="sif.Componentes.Translate"
																	method="Translate"
																	Key="BTN_Filtrar"
																	Default="Filtrar"
																	XmlFile="/rh/generales.xml"
																	returnvariable="BTN_Filtrar"/>
																
																<cfinvoke component="sif.Componentes.Translate"
																	method="Translate"
																	Key="BTN_Limpiar"
																	Default="Limpiar"
																	XmlFile="/rh/generales.xml"
																	returnvariable="BTN_Limpiar"/>
																<cfoutput>
																<input type="submit" name="Filtrar" value="#BTN_Filtrar#" tabindex="1">
																<input type="button" name="Limpiar" value="#BTN_Limpiar#" tabindex="1" onClick="javascript:limpiar();">
																</cfoutput>
															</td>
														</tr>
													</table>
												</form>						
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
											
												<cfinvoke 
												 component="rh.Componentes.pListas"
												 method="pListaRH"
												 returnvariable="pListaRet">
													<cfinvokeargument name="tabla" value="RHOcupaciones"/>
													<cfinvokeargument name="columnas" value="RHOcodigo, RHOdescripcion"/>
													<cfinvokeargument name="desplegar" value="RHOcodigo, RHOdescripcion"/>
													<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
													<cfinvokeargument name="formatos" value="V, V"/>
													<cfinvokeargument name="filtro" value="#filtro#"/>
													<cfinvokeargument name="align" value="left, left"/>
													<cfinvokeargument name="ajustar" value="N"/>
													<cfinvokeargument name="checkboxes" value="N"/>
													<cfinvokeargument name="irA" value="Ocupaciones.cfm"/>
												</cfinvoke>
											</td>
											<td width="50%" valign="top"><cfinclude template="formOcupaciones.cfm"></td>
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
	<cf_templatefooter>	