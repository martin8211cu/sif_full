<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RegistroDeLasPruebas"
	Default="Registro de las Pruebas"
	returnvariable="LB_RegistroDeLasPruebas"/>
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
		
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_RegistroDeLasPruebas#'>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top">
						<cfinclude template="/rh/portlets/pNavegacion.cfm">				
						<script language="JavaScript1.2" type="text/javascript">
							function limpiar(){
							document.filtro.fRHPdescripcionpr.value = '';
							document.filtro.fRHPcodigopr.value = '';
							}
						</script>
						<cfoutput>
						<table width="100%" cellspacing="0" cellpadding="0">
							<cfif isDefined("session.Ecodigo") and isDefined("Form.RHPcodigopr") and len(trim(#Form.RHPcodigopr#)) NEQ 0>
							     <cf_translatedata name="validar" tabla="RHPruebas" col="RHPdescripcionpr" filtro=" Ecodigo=#session.Ecodigo# and ltrim(rtrim(RHPcodigopr)) = '#trim(Form.RHPcodigopr)#'"/>
							</cfif>     	
							<!---<tr><td>&nbsp;</td></tr>
							<tr> 
								<td colspan="4" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Registro de las Pruebas</strong></td>
							</tr> 
							<tr><td>&nbsp;</td></tr>----->	     
							<tr>
								<td>
									<table align="center" width="98%" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top" width="50%">
												<form style="margin:0" name="filtro" method="post">
													<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
														<tr>
															<td><strong>#LB_Codigo#</strong></td>
															<td><strong>#LB_Descripcion#</strong></td>
														</tr>
														<tr>
															
															<td>
																<input name="fRHPcodigopr" type="text" size="10" maxlength="5" 
																onFocus="this.select();" 
																value="<cfif isdefined("form.fRHPcodigopr")>#form.fRHPcodigopr#</cfif>">
															</td>
															<td>
																<input name="fRHPdescripcionpr" type="text" size="60" maxlength="80" 
																onFocus="this.select();" 
																value="<cfif isdefined("form.fRHPdescripcionpr")>#form.fRHPdescripcionpr#</cfif>">
															</td>
															<td align="center" nowrap>
																<input name="btnFiltrar" type="submit" value="#BTN_Filtrar#">
																<input name="btnLimpiar" type="button" value="#BTN_Limpiar#" 
																	onClick="javascript:limpiar();">
															</td>
															
														</tr>
													</table>
												</form>
									
												<cfset filtro = "Ecodigo=#session.Ecodigo#" >
												<cfset navegacion = "">
												<cfif isdefined("form.fRHPcodigopr") and len(trim(form.fRHPcodigopr)) gt 0>
												<cfset filtro = filtro & " and upper (rtrim(RHPcodigopr)) like '%" & Ucase(trim(form.fRHPcodigopr)) &"%'">
												<cfset navegacion = navegacion & "&fRHPcodigopr=#form.fRHPcodigopr#">
												</cfif>
												<cfif isdefined("form.fRHPdescripcionpr") and len(trim(form.fRHPdescripcionpr)) gt 0>
												<cfset filtro = filtro & " and  upper(rtrim(RHPdescripcionpr)) like '%" & Ucase(trim(form.fRHPdescripcionpr)) & "%'">
												<cfset navegacion = navegacion & "&fRHPdescripcionpr=#form.fRHPdescripcionpr#">
												</cfif>
												<cfset filtro = filtro & " order by RHPdescripcionpr, RHPcodigopr">
												<cf_translatedata name="get" tabla="RHPruebas" col="RHPdescripcionpr" returnvariable="LvarRHPdescripcionpr">
												<cfinvoke component="rh.Componentes.pListas" method="pListaRH" 
														  returnvariable="pListaDed">
													<cfinvokeargument name="tabla" value="RHPruebas"/>
													<cfinvokeargument name="columnas" value="RHPcodigopr, #LvarRHPdescripcionpr# as RHPdescripcionpr, fechaalta"/>
													<cfinvokeargument name="desplegar" value="RHPcodigopr,RHPdescripcionpr"/>
													<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
													<cfinvokeargument name="formatos" value="V, V"/>
													<cfinvokeargument name="filtro" value="#filtro#"/>
													<cfinvokeargument name="align" value="left,left"/>
													<cfinvokeargument name="ajustar" value="N"/>
													<cfinvokeargument name="debug" value="N"/>
													<cfinvokeargument name="irA" value="Pruebas.cfm"/>			
													<cfinvokeargument name="navegacion" value="#navegacion#"/>
													<cfinvokeargument name="keys" value="RHPcodigopr"/>
													<cfinvokeargument name="Maxrows" value="15"/>
												</cfinvoke>		
											</td>
											<cfset action = "Pruebas-SQL.cfm"> 
											<td width="1%">&nbsp;</td>
											<td width="50%" valign="top">
												<cfinclude template="Pruebas-form.cfm"> 
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