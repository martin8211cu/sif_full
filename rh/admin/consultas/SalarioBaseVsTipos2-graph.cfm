<!-- InstanceBegin template="/Templates/LMenuRH1.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">

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
					<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->	
                    <!-- InstanceBeginEditable name="MenuJS" --> 
		  <!-- InstanceEndEditable -->					
					<!-- InstanceBeginEditable name="Mantenimiento" --> 
	  <cfparam name="url.RHTP" default="">
	  <cfset url.RHTPid = REReplace(url.RHTP,'^.+\((\d+)\)$','\1')>
	  <cfset url.RHTPdescripcion = REReplace(url.RHTP, '^(.+)\(\d+\)$', '\1')>
	
	<link type="text/css" rel="stylesheet" href="../../../css/asp.css">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_DiagramaDeDispersionDeSalariosBaseParaPuesto"
			Default="Diagrama de Dispersi&oacute;n de Salarios Base para Puesto"
			returnvariable="LB_DiagramaDeDispersionDeSalariosBaseParaPuesto"/>
		
	<cf_web_portlet_start border="true" titulo="#LB_DiagramaDeDispersionDeSalariosBaseParaPuesto#  #RHTPdescripcion#" skin="#Session.Preferences.Skin#">
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_AdministracionDePuestos"
		Default="Administración de Puestos"
		returnvariable="LB_AdministracionDePuestos"/>

		<cfset regresar = "SalarioBaseVsTipos-graph.cfm?HYERVid=#URLEncodedFormat(url.HYERVid)#">
		<cfset navBarItems = ArrayNew(1)>
		<cfset navBarLinks = ArrayNew(1)>
		<cfset navBarStatusText = ArrayNew(1)>
		<cfset navBarItems[1] = LB_AdministracionDePuestos>
		<cfset navBarLinks[1] = "/cfmx/rh/indexPuestos.cfm">
		<cfset navBarStatusText[1] = "/cfmx/rh/indexPuestos.cfm">
	
		<cfinclude template="/rh/portlets/pNavegacion.cfm">

	  	<table width="100%">
			<tr>
				<td align="center"><cfinclude template="SalarioBaseVsTipos2-graphForm.cfm"></td>
			</tr>
		</table>
	  
	  <cf_web_portlet_end>
      <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->