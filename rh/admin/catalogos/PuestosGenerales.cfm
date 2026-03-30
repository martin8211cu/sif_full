<!--- VARIABLES TRADUCCION --->
<cfsilent>
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_CatalogosGenerales" Default="Cat&aacute;logos Generales" returnvariable="LB_CatalogosGenerales" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CatalogosGenerales" Default="Cat&aacute;logos Generales" returnvariable="LB_CatalogosGenerales" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Filtrar" Default="Filtrar" returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Limpiar" Default="Limpiar" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
</cfsilent>
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
	            	<cfset filtro = "Ecodigo = #Session.Ecodigo#">
				  	<cfif isdefined("form.fRHECGcodigo") and len(trim(form.fRHECGcodigo)) gt 0 >
						<cfset filtro = filtro & " and RHECGcodigo like '%#ucase(form.fRHECGcodigo)#%' " >
		            </cfif>
					<cfif isdefined("form.fRHECGdescripcion") and len(trim(form.fRHECGdescripcion)) gt 0 >
						<cfset filtro = filtro & " and upper(RHECGdescripcion) like '%#ucase(form.fRHECGdescripcion)#%' " >
		            </cfif>
					<cfset filtro = filtro & " order by RHECGcodigo">

					<cf_web_portlet_start titulo="#LB_CatalogosGenerales#">
						<cfif isdefined("url.RHECGcodigo") and not isdefined("form.RHECGcodigo")>
							<cfset form.RHECGcodigo = url.RHECGcodigo >
						</cfif>
		
						<cfif isdefined("url.modo") and not isdefined("form.modo")>
							<cfset form.modo = url.modo >
						</cfif>
		
						<cfset regresar = "/cfmx/rh/indexPuestos.cfm">
						<cfset navBarItems = ArrayNew(1)>
						<cfset navBarLinks = ArrayNew(1)>
						<cfset navBarStatusText = ArrayNew(1)>
						<cfset navBarItems[1] = "Administración de Puestos">
						<cfset navBarLinks[1] = "/cfmx/rh/indexPuestos.cfm">
						<cfset navBarStatusText[1] = "/cfmx/rh/indexPuestos.cfm">
		
						<cfinclude template="/rh/portlets/pNavegacion.cfm">

						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td valign="top" width="50%">
									<form style="margin:0" name="filtro" method="post">
										<table border="0" width="100%" class="tituloListas">
											<tr> 
												<td><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></td>
												<td><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></td>
											</tr>
											<tr> 
												<td><input type="text" name="fRHECGcodigo" tabindex="1" value="<cfif isdefined("form.fRHECGcodigo") and len(trim(form.fRHECGcodigo)) gt 0 ><cfoutput>#form.fRHECGcodigo#</cfoutput></cfif>" size="5" maxlength="5" onFocus="javascript:this.select();"></td>
												<td><input type="text" name="fRHECGdescripcion" tabindex="1" value="<cfif isdefined("form.fRHECGdescripcion") and len(trim(form.fRHECGdescripcion)) gt 0 ><cfoutput>#form.fRHECGdescripcion#</cfoutput></cfif>" size="60" maxlength="60" onFocus="javascript:this.select();" ></td>
											</tr>
											<tr>
												<td colspan="2" align="right">
													<cfoutput>
													<input type="submit" name="Filtrar" value="#BTN_Filtrar#">
													<input type="button" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript:limpiar();">
													</cfoutput>
												</td>
											</tr>
										</table>
									</form>			
									<cf_dbfunction name="length" args="RHECGdescripcion" returnvariable="RHECGdescripcion_length">
									<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
									<cf_dbfunction name="sPart" args="RHECGdescripcion,1,57" returnvariable="RHECGdescripcion_sPart">
									<cfinvoke 
									 component="rh.Componentes.pListas"
									 method="pListaRH"
									 returnvariable="pListaRet">
										<cfinvokeargument name="tabla" value="RHECatalogosGenerales"/>
										<cfinvokeargument name="columnas" value="RHECGid, RHECGcodigo, 
																			case when #preservesinglequotes(RHECGdescripcion_length)# > 60 
																			then #preservesinglequotes(RHECGdescripcion_sPart)# #_CAT# '...' else RHECGdescripcion end RHECGdescripcion"/>
										<cfinvokeargument name="desplegar" value="RHECGcodigo, RHECGdescripcion"/>
										<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
										<cfinvokeargument name="formatos" value="V, V"/>
										<cfinvokeargument name="filtro" value="#filtro#"/>
										<cfinvokeargument name="align" value="left, left"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="checkboxes" value="N"/>
										<cfinvokeargument name="irA" value="PuestosGenerales.cfm"/>
										<cfinvokeargument name="keys" value="RHECGid"/>
									</cfinvoke>								
								</td>
								<td width="50%" valign="top"><cfinclude template="formPuestosGenerales.cfm"></td>
							</tr>
						</table>
		            <cf_web_portlet_end>
					<script type="text/javascript" language="javascript1.2">
						function limpiar(){
							document.filtro.reset();
							document.filtro.fRHECGcodigo.value = '';
							document.filtro.fRHECGdescripcion.value = '';
						}
                    </script>		
				</td>	
			</tr>
		</table>	
<cf_templatefooter>	