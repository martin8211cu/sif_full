
<!--- VARIABLES DE TRADUCCION --->
<cfset translates= CreateObject("sif.Componentes.Translate")>

<cfset LB_Titulos= translates.translate('LB_Titulos',"Títulos","/rh/generales.xml")>
<cfset LB_Descripcion= translates.translate('LB_Descripcion',"Descripción","/rh/generales.xml")>
<cfset BTN_Filtrar= translates.translate('BTN_Filtrar',"Filtrar","/rh/generales.xml")>
<cfset BTN_Limpiar= translates.translate('BTN_Limpiar',"Limpiar","/rh/generales.xml")>
<cfset LB_RecursosHumanos= translates.translate('LB_RecursosHumanos',"Recursos Humanos","/rh/generales.xml")>
<cfset LB_NFormal= translates.translate('LB_NFormal',"Capacitacion No Formal","/rh/generales.xml")>
<cf_templateheader template="#session.sitio.template#">	
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
		
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulos#'>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top">
						<cfinclude template="/rh/portlets/pNavegacion.cfm">				
						<script language="JavaScript1.2" type="text/javascript">
							function limpiar(){
							document.filtro.fRHOTDescripcion.value = '';
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
															<td><strong>#LB_NFormal#</strong></td>
														</tr>
														<tr>
															<td>
																<input name="fRHOTDescripcion" type="text" size="60" maxlength="60" 
																onFocus="this.select();" 
																value="<cfif isdefined("form.fRHOTDescripcion")>#form.fRHOTDescripcion#</cfif>">
															</td>
															<td>
																<select id="lb_Educacion" name="lb_Educacion">
																	<option value="0">Ambas</option>
																	<option value="1">Formal</option>
 																	<option value="2">No Formal</option>
																</select>
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
												<cf_translatedata name="get" tabla="RHOTitulo" col="RHOTDescripcion" returnvariable="LvarRHOTDescripcion">
												<cfif isdefined("form.fRHOTDescripcion") and len(trim(form.fRHOTDescripcion)) gt 0>
													<cfset filtro = filtro & " and  upper(rtrim(#LvarRHOTDescripcion#)) like '%" & Ucase(trim(form.fRHOTDescripcion)) & "%'">
													<cfset navegacion = navegacion & "&fRHOTDescripcion=#form.fRHOTDescripcion#">
												</cfif>

												<cfif isdefined("form.lb_Educacion")>
													<cfif form.lb_Educacion EQ 2>
														<cfset filtro = filtro & " and  RHOTnf= 1" >
														<cfset navegacion = navegacion & "&lb_Educacion=#form.lb_Educacion#">
													<cfelseif form.lb_Educacion EQ 1>
															<cfset filtro = filtro & " and  RHOTnf=0">
															<cfset navegacion = navegacion & "&lb_Educacion=#form.lb_Educacion#">
													</cfif>
												
												</cfif>
												<cfset filtro = filtro & " order by #LvarRHOTDescripcion#, RHOTnf ">
												
												<cfinvoke component="rh.Componentes.pListas" method="pListaRH" 
														  returnvariable="pListaDed">
													<cfinvokeargument name="tabla" value="RHOTitulo"/>
													<cfinvokeargument name="columnas" value="RHOTid,#LvarRHOTDescripcion# as RHOTDescripcion,  CASE   
																		      WHEN RHOTnf = 0 THEN 
																			  '<img border=''0'' tittle=''Editar''  src=''/cfmx/rh/imagenes/unchecked.gif''>'
																		      ELSE 
																				'<img border=''0'' tittle=''Editar''  src=''/cfmx/rh/imagenes/checked.gif''>'
																		 	END    as  RHOTnf"/>
													<cfinvokeargument name="desplegar" value="RHOTDescripcion, RHOTnf"/>
													<cfinvokeargument name="etiquetas" value="#LB_Descripcion#, #LB_NFormal#"/>
													<cfinvokeargument name="formatos" value="V,C"/>
													<cfinvokeargument name="filtro" value="#filtro#"/>
													<cfinvokeargument name="align" value="left, center"/>
													<cfinvokeargument name="ajustar" value="N,N"/>
													<cfinvokeargument name="debug" value="N"/>
													<cfinvokeargument name="irA" value="Titulos.cfm"/>			
													<cfinvokeargument name="navegacion" value="#navegacion#"/>
													<cfinvokeargument name="keys" value="RHOTid"/>
													<cfinvokeargument name="translatedatacols" value="RHOTDescripcion"/>
													<cfinvokeargument name="Maxrows" value="15"/>
												</cfinvoke>		
											</td>
											<cfset action = "Industrias-SQL.cfm"> 
											<td width="1%">&nbsp;</td>
											<td width="50%" valign="top">
												<cfinclude template="Titulos-form.cfm"> 
											</td>  
										</tr>
									</table>
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