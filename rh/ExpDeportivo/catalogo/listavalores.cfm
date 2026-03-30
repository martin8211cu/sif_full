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
	            	<cfset filtro = "">
				  	<cfif isdefined("form.fEDDcodigo") and len(trim(form.fEDDcodigo)) gt 0 >
						<cfset filtro = filtro & " and EDDcodigo like '%#ucase(form.fEDDcodigo)#%' " >
		            </cfif>
					<cfif isdefined("form.fEDDdescripcion") and len(trim(form.fEDDdescripcion)) gt 0 >
						<cfset filtro = filtro & " and upper(EDDdescripcion) like '%#ucase(form.fEDDdescripcion)#%' " >
		            </cfif>
					<cfset filtro = filtro & " order by EDDcodigo">
	              	<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_ListadeValores"
						Default="Lista de Valores"
						returnvariable="LB_ListadeValores"/>

					<cf_web_portlet_start titulo="#LB_ListadeValores#">
						<cfif isdefined("url.EDDcodigo") and not isdefined("form.EDDcodigo")>
							<cfset form.EDDcodigo = url.EDDcodigo >
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
												<td><input type="text" name="fEDDcodigo" tabindex="1" value="<cfif isdefined("form.fEDDcodigo") and len(trim(form.fEDDcodigo)) gt 0 ><cfoutput>#form.fEDDcodigo#</cfoutput></cfif>" size="5" maxlength="5" onFocus="javascript:this.select();"></td>
												<td><input type="text" name="fEDDdescripcion" tabindex="1" value="<cfif isdefined("form.fEDDdescripcion") and len(trim(form.fEDDdescripcion)) gt 0 ><cfoutput>#form.fEDDdescripcion#</cfoutput></cfif>" size="60" maxlength="60" onFocus="javascript:this.select();" ></td>
											</tr>
											<tr>
												<td colspan="2" align="right">
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
													<input type="submit" name="Filtrar" value="#BTN_Filtrar#">
													<input type="button" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript:limpiar();">
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
										
					<cfquery name="rsLista" datasource="#session.DSN#">
									select EDDid, EDDcodigo, EDDdescripcion
									from EDDatosVariables
									where 1=1
									#PreserveSingleQuotes(filtro)# 
									
						</cfquery>	
										
									<cfinvoke 
									 component="rh.Componentes.pListas"
									 method="pListaQuery"
									 returnvariable="pListaRet">
										<cfinvokeargument name="query" value="#rsLista#"/>
										<cfinvokeargument name="desplegar" value="EDDcodigo, EDDdescripcion"/>
										<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
										<cfinvokeargument name="formatos" value="V, V"/>
										<cfinvokeargument name="filtrar_automatico" value="true"/>
										<cfinvokeargument name="align" value="left, left"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="checkboxes" value="N"/>
										<cfinvokeargument name="irA" value="listavalores.cfm"/>
										<cfinvokeargument name="keys" value="EDDid"/>
									</cfinvoke>		
														
								</td>
								<td width="50%" valign="top"><cfinclude template="listavalores-form.cfm"></td>
							</tr>
						</table>
		            <cf_web_portlet_end>
					<script type="text/javascript" language="javascript1.2">
						function limpiar(){
							document.filtro.reset();
							document.filtro.fEDDcodigo.value = '';
							document.filtro.fEDDdescripcion.value = '';
						}
                    </script>		
				</td>	
			</tr>
		</table>	
<cf_templatefooter>	