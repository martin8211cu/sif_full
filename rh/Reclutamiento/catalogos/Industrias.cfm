
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Industrias"
	Default="Industrias"
	returnvariable="LB_Industrias"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
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
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_templatecss>
		<link href="../css/rh.css" rel="stylesheet" type="text/css">
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
		
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Industrias#'>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top">
						<cfinclude template="/rh/portlets/pNavegacion.cfm">				
						<script language="JavaScript1.2" type="text/javascript">
							function limpiar(){
							document.filtro.fRHOIDescripcion.value = '';
							}
						</script>
						<cfoutput>
						<table width="100%" cellspacing="0" cellpadding="0">

							<tr>
								<td>
									<table align="center" width="98%" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top" width="50%">
												<form style="margin:0" name="filtro" method="post">
													<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
														<tr>
															<td><strong>#LB_Descripcion#</strong></td>
														</tr>
														<tr>
															<td>
																<input name="fRHOIDescripcion" type="text" size="60" maxlength="80" 
																onFocus="this.select();" 
																value="<cfif isdefined("form.fRHOIDescripcion")>#form.fRHOIDescripcion#</cfif>">
															</td>
															<td align="center" nowrap>
																<input name="btnFiltrar" type="submit" value="#BTN_Filtrar#">
																<input name="btnLimpiar" type="button" value="#BTN_Limpiar#" 
																	onClick="javascript:limpiar();">
															</td>
															
														</tr>
													</table>
												</form>
									
												<cfset filtro = "CEcodigo=#session.cecodigo#" >
												<cfset navegacion = "">
												<cf_translatedata name="get" tabla="RHOIndustria" col="RHOIDescripcion" returnvariable="LvarRHOIDescripcion">
												<cfif isdefined("form.fRHOIDescripcion") and len(trim(form.fRHOIDescripcion)) gt 0>
													<cfset filtro = filtro & " and  upper(rtrim(#LvarRHOIDescripcion#)) like '%" & Ucase(trim(form.fRHOIDescripcion)) & "%'">
													<cfset navegacion = navegacion & "&fRHOIDescripcion=#form.fRHOIDescripcion#">
												</cfif>
												<cfset filtro = filtro & " order by RHOIDescripcion">
												
												<cfinvoke component="rh.Componentes.pListas" method="pListaRH" 
														  returnvariable="pListaDed">
													<cfinvokeargument name="tabla" value="RHOIndustria"/>
													<cfinvokeargument name="columnas" value="RHOIid,#LvarRHOIDescripcion# as RHOIDescripcion"/>
													<cfinvokeargument name="desplegar" value="RHOIDescripcion"/>
													<cfinvokeargument name="etiquetas" value="#LB_Descripcion#"/>
													<cfinvokeargument name="formatos" value="V"/>
													<cfinvokeargument name="filtro" value="#filtro#"/>
													<cfinvokeargument name="align" value="left"/>
													<cfinvokeargument name="ajustar" value="N"/>
													<cfinvokeargument name="debug" value="N"/>
													<cfinvokeargument name="irA" value="Industrias.cfm"/>			
													<cfinvokeargument name="navegacion" value="#navegacion#"/>
													<cfinvokeargument name="keys" value="RHOIid"/>
													<cfinvokeargument name="translatedatacols" value="RHOIDescripcion"/>
													<cfinvokeargument name="Maxrows" value="15"/>
												</cfinvoke>		
											</td>
											<cfset action = "Industrias-SQL.cfm"> 
											<td width="1%">&nbsp;</td>
											<td width="50%" valign="top">
												<cfinclude template="Industrias-form.cfm"> 
											</td>
										</tr>																									  									</table>
								</td>																									  
							</tr>  		
							<tr><td>&nbsp;</td></tr>
						</table>
					</td>	
				</tr>
			</table>
			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>	