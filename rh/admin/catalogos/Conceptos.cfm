<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">

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
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_ConceptosDeExpediente"
					Default="Conceptos de Expediente"
					returnvariable="LB_ConceptosDeExpediente"/>

                  <cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_ConceptosDeExpediente#">
						<cfset navBarItems = ArrayNew(1)>
						<cfset navBarLinks = ArrayNew(1)>
						<cfset navBarStatusText = ArrayNew(1)>			 
						<cfset navBarItems[1] = "Estructura Organizacional">
						<cfset navBarLinks[1] = "/cfmx/rh/indexEstructura.cfm">
						<cfset navBarStatusText[1] = "/cfmx/rh/indexEstructura.cfm">						
						<cfset Regresar  = "/cfmx/rh/admin/catalogos/Conceptos-lista.cfm">
						<cfinclude template="/rh/portlets/pNavegacion.cfm">
						<cfinclude template="Conceptos-form.cfm">
	                <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>