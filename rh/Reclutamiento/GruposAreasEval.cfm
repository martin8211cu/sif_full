<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RegistroDeGruposPorArea"
	Default="Registro de Grupos por &Aacute;rea"
	returnvariable="LB_RegistroDeGruposPorArea"/>
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
	Key="LB_Fecha"
	Default="Fecha"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Fecha"/>	
	
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
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_RegistroDeGruposPorArea#'>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cfinclude template="/rh/portlets/pNavegacion.cfm">				
				<script language="JavaScript1.2" type="text/javascript">
				function limpiar(){
				document.filtro.fRHGdescripcion.value = '';
				document.filtro.fRHGcodigo.value = '';
				document.filtro.fRHGfecha.value = '';
				
				}
				</script>
				<cfoutput>
				<table align="center" width="95%" cellspacing="0" cellpadding="0" >
					<!----<tr><td>&nbsp;</td></tr>
					<tr> 
						<td colspan="4" align="center">
							<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
								Registro de los grupos por Área de Evaluaci&oacute;n
							</strong>
						</td>
					</tr>	 
					<tr><td>&nbsp;</td></tr>----->  
					<tr>
						<td>
							<table align="center" width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td valign="top" width="50%">
										<form style="margin:0" name="filtro" method="post">
											<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
												<tr>
													<td><strong>#LB_Codigo#</strong></td>
													<td><strong>#LB_Descripcion#</strong></td>
													<td nowrap><strong>#LB_Fecha# </strong></td>
												</tr>
												<tr>
													<td>
														<input name="fRHGcodigo" type="text" size="10" maxlength="5" 
														onFocus="this.select();"  
														value="<cfif isdefined("form.fRHGcodigo")><cfoutput>#form.fRHGcodigo#</cfoutput></cfif>">
													</td>
													<td>
														<input name="fRHGdescripcion" type="text" size="35" maxlength="35"  
														onFocus="this.select();" 
														value="<cfif isdefined("form.fRHGdescripcion")><cfoutput>#form.fRHGdescripcion#</cfoutput></cfif>">
													</td>
													<td>
														<cfset fechaI = '' >
														<cfif isdefined("form.fRHGfecha")>
															<cfset fechaI = form.fRHGfecha >
														</cfif>
														<cf_sifcalendario form="filtro" name="fRHGfecha" value="#fechaI#">
													</td>
													<td colspan="3" align="center" nowrap>
														<input type="submit" name="btnFiltrar" value="#BTN_Filtrar#">
														<input type="button" name="btnLimpiar" value="#BTN_Limpiar#" 
															onClick="javascript:limpiar();">
														<input name="RHGcodigo" type="hidden" 
														value="<cfif isdefined("form.RHGcodigo")><cfoutput>#form.RHGcodigo#</cfoutput></cfif>">
														<input name="o" type="hidden" value="7">
														<input name="sel" type="hidden" value="1">			
													</td>
												</tr>
											</table>
										</form>
									</td>
								</tr>	
								<tr>
									<td>
										<cfset filtro = "Ecodigo=#session.Ecodigo#" >
										<cfset navegacion = "">
										<cfif isdefined("form.fRHGcodigo") and len(trim(form.fRHGcodigo)) gt 0>
											<cfset filtro = filtro & " and RHGcodigo like '%" & Ucase(trim(form.fRHGcodigo)) &"%'">
											<cfset navegacion = navegacion & "&fRHGcodigo=#form.fRHGcodigo#">
										</cfif>
										<cfif isdefined("form.fRHGdescripcion") and len(trim(form.fRHGdescripcion)) gt 0>
											<cfset filtro = filtro & " and  upper(RHGdescripcion) like '%" & Ucase(trim(form.fRHGdescripcion)) & "%'">
											<cfset navegacion = navegacion & "&fRHGdescripcion=#form.fRHGdescripcion#">
										</cfif>
										
										<cfif isdefined("form.fRHGfecha") and len(trim(form.fRHGfecha)) gt 0 >
											<cfset filtro = filtro & " and RHGfecha between convert(datetime, '#form.fRHGfecha#', 103) and  convert(datetime, '#form.fRHGfecha#', 103)">
											<cfset navegacion = navegacion & "&fRHGfecha=#form.fRHGfecha#">
										</cfif>
										
										<cfset filtro = filtro & " order by RHGdescripcion, RHGcodigo">
										<cf_translatedata name="get" tabla="RHGruposAreasEval" col="RHGdescripcion" returnvariable="LvarRHGdescripcion">
										<cfinvoke component="rh.Componentes.pListas"
											method="pListaRH"
											returnvariable="pListaDed">
											<cfinvokeargument name="tabla" value="RHGruposAreasEval"/>
											<cfinvokeargument name="columnas" value="RHGcodigo, substring(#LvarRHGdescripcion#,1,35) as RHGdescripcion, RHGfecha ,7 as o, 1 as sel"/>
											<cfinvokeargument name="desplegar" value="RHGcodigo,RHGdescripcion, RHGfecha"/>
											<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#, #LB_Fecha# "/>
											<cfinvokeargument name="formatos" value="V, V, D "/>
											<cfinvokeargument name="filtro" value="#filtro#"/>
											<cfinvokeargument name="align" value="left,left,right"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="debug" value="N"/>
											<cfinvokeargument name="irA" value="GruposAreasEval.cfm"/>			
											<cfinvokeargument name="keys" value="RHGcodigo"/>
										</cfinvoke>		
									</td>
									
								</tr>																									  
							</table>
						</td>
						<cfset action = "GruposAreasEval-SQL.cfm"> 
						
						<td width="45%" valign="top">
							<cfinclude template="GruposAreasEval-form.cfm"> 
						</td>															  
					</tr>  		
					<tr><td>&nbsp;</td></tr>
				</table>
				</cfoutput>
			</td>	
		</tr>
	</table>	
<cf_web_portlet_end>
<cf_templatefooter>