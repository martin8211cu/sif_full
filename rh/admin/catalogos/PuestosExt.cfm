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

		<script language="JavaScript1.2" type="text/javascript">
			function limpiar(){
				document.filtro.fRHPEcodigo.value = "";
				document.filtro.fRHPEdescripcion.value   = "";
			}
		</script>

		<cfset filtro = " 1=1 ">
		<cfset navegacion = "">
		<cfif isdefined("Url.fRHPEcodigo")>
			<cfparam name="Form.fRHPEcodigo" default="#Url.fRHPEcodigo#">
		<cfelse>
			<cfparam name="Form.fRHPEcodigo" default="">
		</cfif>
		<cfif isdefined("Url.fRHPEdescripcion")>
			<cfparam name="Form.fRHPEdescripcion" default="#Url.fRHPEdescripcion#">
		<cfelse>
			<cfparam name="Form.fRHPEdescripcion" default="">
		</cfif>
		<cfif isdefined("form.fRHPEcodigo") and len(trim(form.fRHPEcodigo)) gt 0 >
			<cfset filtro = filtro & " and upper(RHPEcodigo) like '%#ucase(form.fRHPEcodigo)#%' " >
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE(","), DE("")) & "fRHPEcodigo=" & Form.fRHPEcodigo>
		</cfif>
		<cfif isdefined("form.fRHPEdescripcion") and len(trim(form.fRHPEdescripcion)) gt 0 >
			<cfset filtro = filtro & " and upper(RHPEdescripcion) like '%#ucase(form.fRHPEdescripcion)#%' " >
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE(","), DE("")) & "fRHPEdescripcion=" & Form.fRHPEdescripcion>
		</cfif>
        <!--- <cfset filtro = filtro & " and Ecodigo = " & #Session.Ecodigo# > --->
		<cfset filtro = filtro & "order by RHPEcodigo">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_PuestosExternos"
			Default="Puestos Externos"
			returnvariable="LB_PuestosExternos"/>

		<cf_web_portlet_start titulo="#LB_PuestosExternos#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top" width="50%">
						<form name="filtro" method="post" action="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>">
							<table border="0" width="100%" class="tituloListas">
								<tr> 
									<td nowrap><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></strong></td>
									<td nowrap><strong><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
									<td nowrap>&nbsp;</td>
								</tr>
								<tr> 
									<td nowrap><input type="text" name="fRHPEcodigo" tabindex="1" value="<cfif isdefined("form.fRHPEcodigo") and len(trim(form.fRHPEcodigo)) gt 0 ><cfoutput>#form.fRHPEcodigo#</cfoutput></cfif>" size="5" maxlength="5" onFocus="javascript:this.select();"></td>
									<td nowrap><input type="text" name="fRHPEdescripcion" tabindex="1" value="<cfif isdefined("form.fRHPEdescripcion") and len(trim(form.fRHPEdescripcion)) gt 0 ><cfoutput>#form.fRHPEdescripcion#</cfoutput></cfif>" size="50" maxlength="60" onFocus="javascript:this.select();" ></td>
									<td align="center" nowrap>
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
										<input type="submit" name="Filtrar" tabindex="1" value="#BTN_Filtrar#">
										<input type="button" name="Limpiar" tabindex="1" value="#BTN_Limpiar#" onClick="javascript:limpiar();">
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
							<cfinvokeargument name="tabla" value="RHPuestosExternos"/>
							<cfinvokeargument name="columnas" value="RHPEid, RHPEcodigo, RHPEdescripcion, '#Form.fRHPEcodigo#' as fRHPEcodigo, '#Form.fRHPEdescripcion#' as fRHPEdescripcion"/>
							<cfinvokeargument name="desplegar" value="RHPEcodigo, RHPEdescripcion"/>
							<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
							<cfinvokeargument name="formatos" value="V, V"/>
							<cfinvokeargument name="filtro" value="#filtro#"/>
							<cfinvokeargument name="align" value="left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="irA" value="PuestosExt.cfm"/>
							<cfinvokeargument name="keys" value="RHPEid"/>
							<cfinvokeargument name="maxRows" value="15"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
						</cfinvoke>
					</td>
					<td width="50%" valign="top">
						<cfinclude template="PuestosExt-form.cfm">
					</td>
				</tr>
				<tr>
				  <td colspan="2" valign="top">&nbsp;</td>
			  </tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>	