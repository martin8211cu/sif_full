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
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ConfiguracionDeReporteDePuestos"
		Default="Configuraci&oacute;n de Reporte de Puestos"
		returnvariable="LB_ConfiguracionDeReporteDePuestos"/>
	
	<cf_web_portlet_start border="true" titulo="#LB_ConfiguracionDeReporteDePuestos#" skin="#Session.Preferences.Skin#">						
	<cfset regresar = "/cfmx/rh/indexPuestos.cfm">
	<cfset navBarItems = ArrayNew(1)>
	<cfset navBarLinks = ArrayNew(1)>
	<cfset navBarStatusText = ArrayNew(1)>
	<cfset navBarItems[1] = "Administraci&oacute;n de Puestos">
	<cfset navBarLinks[1] = "/cfmx/rh/indexPuestos.cfm">
	<cfset navBarStatusText[1] = "/cfmx/rh/indexPuestos.cfm">
	<table width="98%" align="center">
	  	<tr>
			<td>								
				<cfinclude template="/rh/portlets/pNavegacion.cfm">
			</td>	
		</tr>
		<tr>
			<td>
				<cfinclude template="formPuestosConfig.cfm">
			</td>
		</tr>	  				  		
	</table> 
	<cf_web_portlet_end>	
<cf_templatefooter>	