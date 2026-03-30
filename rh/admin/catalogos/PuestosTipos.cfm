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
	       			<cfset filtro = "Ecodigo = #Session.Ecodigo#">
				  	<cfif isdefined("form.fRHTPcodigo") and len(trim(form.fRHTPcodigo)) gt 0 >
						<cfset filtro = filtro & " and RHTPcodigo like '%#ucase(form.fRHTPcodigo)#%' " >
		        	</cfif>
					<cfif isdefined("form.fRHTPdescripcion") and len(trim(form.fRHTPdescripcion)) gt 0 >
						<cfset filtro = filtro & " and upper(RHTPdescripcion) like '%#ucase(form.fRHTPdescripcion)#%' " >
		            </cfif>
					<cfset filtro = filtro & " order by RHTPcodigo">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_TiposDePuestos"
						Default="Tipos de Puestos"
						returnvariable="LB_TiposDePuestos"/>
	              	<cf_web_portlet_start titulo="#LB_TiposDePuestos#">
						<cfif isdefined("url.RHTPcodigo") and not isdefined("form.RHTPcodigo")>
							<cfset form.RHTPcodigo = url.RHTPcodigo >
						</cfif>
		
						<cfif isdefined("url.modo") and not isdefined("form.modo")>
							<cfset form.modo = url.modo >
						</cfif>
		
						<cfset regresar = "/cfmx/rh/indexPuestos.cfm">
						<cfset navBarItems = ArrayNew(1)>
						<cfset navBarLinks = ArrayNew(1)>
						<cfset navBarStatusText = ArrayNew(1)>
						<cfset navBarItems[1] = "Administraci&oacute;n de Puestos">
						<cfset navBarLinks[1] = "/cfmx/rh/indexPuestos.cfm">
						<cfset navBarStatusText[1] = "/cfmx/rh/indexPuestos.cfm">
	
						<cfinclude template="/rh/portlets/pNavegacion.cfm">


						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td valign="top" width="50%">
									<form style="margin:0" name="filtro" method="post">
										<table border="0" width="100%" class="tituloListas" cellpadding="0" cellspacing="0	">
											<tr> 
												<td><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></td>
												<td><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></td>
											</tr>
											<tr> 
												<td>
													<input type="text" name="fRHTPcodigo" size="5" maxlength="5" tabindex="1"
													value="<cfif isdefined("form.fRHTPcodigo") and len(trim(form.fRHTPcodigo)) gt 0 ><cfoutput>#form.fRHTPcodigo#</cfoutput></cfif>"
													onFocus="javascript:this.select();">
												</td>
												<td>
													<input type="text" name="fRHTPdescripcion" size="30" maxlength="60" tabindex="1"
													value="<cfif isdefined("form.fRHTPdescripcion") and len(trim(form.fRHTPdescripcion)) gt 0 ><cfoutput>#form.fRHTPdescripcion#</cfoutput></cfif>" 
													onFocus="javascript:this.select();" >
												</td>
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
										<cfinvokeargument name="tabla" value="RHTPuestos"/>
										<cfinvokeargument name="columnas" value="RHTPid, RHTPcodigo, case when len(RHTPdescripcion) > 60 then {fn concat(substring(RHTPdescripcion,1,57),'...')}  else RHTPdescripcion end as RHTPdescripcion" />
										<cfinvokeargument name="desplegar" value="RHTPcodigo, RHTPdescripcion"/>
										<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
										<cfinvokeargument name="formatos" value="V, V"/>
										<cfinvokeargument name="filtro" value="#filtro#"/>
										<cfinvokeargument name="align" value="left, left"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="checkboxes" value="N"/>
										<cfinvokeargument name="irA" value="PuestosTipos.cfm"/>
										<cfinvokeargument name="keys" value="RHTPid"/>
									</cfinvoke>
								</td>
								<td width="50%" valign="top"><cfinclude template="formPuestosTipos.cfm"></td>
							</tr>
						</table>
					<cf_web_portlet_end>                  
					<script   language="javascript" type="text/javascript">
						 function limpiar(){
						 document.filtro.reset();
						 document.filtro.fRHTPcodigo.value = " ";
						 document.filtro.fRHTPdescripcion.value = " ";
						 }
					</script>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>	