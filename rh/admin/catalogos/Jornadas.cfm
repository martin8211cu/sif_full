<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Codigo" Default="C&oacute;digo" XmlFile="/rh/generales.xml" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" XmlFile="/rh/generales.xml" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_HorasDiarias" Default="Horas Diarias" returnvariable="LB_HorasDiarias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Jornadas" Default="Jornadas" returnvariable="LB_Jornadas" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
<cf_templatecss>
<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
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
					<cfset filtro = filtro & "order by RHJcodigo">                  
					<cf_web_portlet_start titulo="#LB_Jornadas#">
						<cfset regresar = "/cfmx/rh/indexEstructura.cfm">
						<cfset navBarItems = ArrayNew(1)>
						<cfset navBarLinks = ArrayNew(1)>
						<cfset navBarStatusText = ArrayNew(1)>			 
						<cfset navBarItems[1] = "Estructura Organizacional">
						<cfset navBarLinks[1] = "/cfmx/rh/indexEstructura.cfm">
						<cfset navBarStatusText[1] = "/cfmx/rh/indexEstructura.cfm">
						
					
						<cfif isdefined("Url.fRHJcodigo") and not isdefined("Form.fRHJcodigo")>
							<cfset Form.fRHJcodigo = Url.fRHJcodigo>
						</cfif>	
						<cfif isdefined("Url.fRHJdescripcion") and not isdefined("Form.fRHJdescripcion")>
							<cfset Form.fRHJdescripcion = Url.fRHJdescripcion>
						</cfif>	
						
						<cfset navegacion = "">
						<cfif isdefined("Form.fRHJcodigo") and len(trim(Form.fRHJcodigo)) gt 0 >
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHJcodigo=" & Form.fRHJcodigo>
						</cfif>
						<cfif isdefined("Form.fRHJdescripcion") and len(trim(Form.fRHJdescripcion)) gt 0 >
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHJdescripcion=" & Form.fRHJdescripcion>
						</cfif>
							
						<cfinclude template="/rh/portlets/pNavegacion.cfm">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td valign="top" width="40%">
									<cfinvoke 
									 component="rh.Componentes.pListas"
									 method="pListaRH"
									 returnvariable="pListaRet">
										<cfinvokeargument name="tabla" value="RHJornadas"/>
										<cfinvokeargument name="columnas" value="RHJid, RHJcodigo, RHJdescripcion, RHJhoradiaria"/>
										<cfinvokeargument name="desplegar" value="RHJcodigo, RHJdescripcion, RHJhoradiaria"/>
										<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,#LB_HorasDiarias#"/>
										<cfinvokeargument name="formatos" value="V, V, M"/>
										<cfinvokeargument name="filtro" value="#filtro#"/>
										<cfinvokeargument name="align" value="left, left, left"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="checkboxes" value="N"/>
										<cfinvokeargument name="irA" value="Jornadas-tabs.cfm"/>
										<cfinvokeargument name="keys" value="RHJid"/>
										<cfinvokeargument name="navegacion" value="#navegacion#"/>
										<cfinvokeargument name="maxrows" value="20"/>
										<cfinvokeargument name="mostrar_filtro" value="true"/>
										<cfinvokeargument name="filtrar_automatico" value="true"/>
										<cfinvokeargument name="botones" value="Nuevo"/>
									</cfinvoke>
								</td>
							</tr>
						</table>
	                <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>