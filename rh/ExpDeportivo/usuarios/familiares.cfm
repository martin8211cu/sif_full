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
									document.filtro.DEidentificacion.value = "";
									document.filtro.DEnombre.value   = "";
									
								}
							</script>

												
					<cfset filtro = " ">
		<cfif isdefined("form.fDEidentificacion") and len(trim(form.fDEidentificacion)) gt 0 >
		<cfset filtro = filtro & " and upper(fDEidentificacion) like '%#ucase(form.fDEidentificacion)#%' " >
		</cfif>
		<cfif isdefined("form.fDEnombre") and len(trim(form.fDEnombre)) gt 0 >
		<cfset filtro = filtro & " and upper({fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, 		 DEnombre) }) like '%" & #UCase(Form.fDEnombre)# & "%'">
		</cfif> 
							
						
	              	<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_AsignaciondeFamiliares"
						Default="Asignaci&oacute;n de Familiares"
						returnvariable="LB_AsignaciondeFamiliares"/>

					<cf_web_portlet_start titulo="#LB_AsignaciondeFamiliares#">
						<!--- <cfif isdefined("url.fEDCEcod") and not isdefined("form.fEDCEcod")>
							<cfset form.fEDCEcod = url.fEDCEcod >
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
						<cfset navBarStatusText[1] = "/cfmx/rh/indexPuestos.cfm"> --->
		
						<cfinclude template="/rh/portlets/pNavegacion.cfm">

						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td valign="top" width="50%">
									<form style="margin:0" name="filtro" method="post">
										<table border="0" width="100%" class="tituloListas">
											<tr> 
												<td><cf_translate key="LB_Identificacion" XmlFile="/rh/generales.xml">Identificaci&oacute;n</cf_translate></td>
												<td><cf_translate key="LB_Nombre" XmlFile="/rh/generales.xml">Nombre</cf_translate></td>
											</tr>
											<tr> 
												<td><input type="text" name="fDEidentificacion" tabindex="1" value="<cfif isdefined("form.fDEidentificacion") and len(trim(form.fDEidentificacion)) gt 0 ><cfoutput>#form.fDEidentificacion#</cfoutput></cfif>" size="15" maxlength="20" onFocus="javascript:this.select();"></td>
												<td><input type="text" name="fDEnombre" tabindex="1" value="<cfif isdefined("form.fDEnombre") and len(trim(form.fDEnombre)) gt 0 ><cfoutput>#form.fDEnombre#</cfoutput></cfif>" size="30" maxlength="60" onFocus="javascript:this.select();" ></td>
											
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
										Key="LB_Identificacion"
										Default="Identificaci&oacute;n"
										XmlFile="/rh/generales.xml"
										returnvariable="LB_Identificacion"/>
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Nombre"
										Default="Nombre"
										XmlFile="/rh/generales.xml"
										returnvariable="LB_Nombre"/>
										
					<cfquery name="rsLista" datasource="#session.DSN#">
									select DEidentificacion, {fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ', ')}, DEnombre) } as nombreEmpl, DEid
									from EDPersonas
									where 1=1
									#PreserveSingleQuotes(filtro)#
									order by {fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ' ')}, DEnombre) }
						</cfquery>	
										
									<cfinvoke 
									 component="rh.Componentes.pListas"
									 method="pListaQuery"
									 returnvariable="pListaRet">
										<cfinvokeargument name="query" value="#rsLista#"/>
										<cfinvokeargument name="desplegar" value="DEidentificacion, nombreEmpl"/>
										<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_Nombre#"/>
										<cfinvokeargument name="formatos" value="V, V"/>
										<cfinvokeargument name="filtrar_automatico" value="true"/>
										<cfinvokeargument name="align" value="left, left"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="checkboxes" value="N"/>
										<cfinvokeargument name="irA" value="familiares.cfm?alta=s"/>
										<cfinvokeargument name="keys" value="DEid"/>
									</cfinvoke>		
														
								</td>
								<td width="50%" valign="top"><cfinclude template="familiares-form.cfm"></td>
							</tr>
						</table>
		            <cf_web_portlet_end>
					
<cf_templatefooter>	