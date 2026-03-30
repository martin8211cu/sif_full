<!-- InstanceBegin template="/Templates/LMenuRH1.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<cf_templateheader title="Recursos Humanos">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
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

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_RegistroDeRelacionDeValoracionDePuestos"
			Default="Registro de Relaci&oacute;n de Valoraci&oacute;n de Puestos"
			returnvariable="LB_RegistroDeRelacionDeValoracionDePuestos"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_AdministracionDePuestos"
			Default="Administración de Puestos"
			returnvariable="LB_AdministracionDePuestos"/>
	  <cf_web_portlet_start border="true" titulo="#LB_RegistroDeRelacionDeValoracionDePuestos#" skin="#Session.Preferences.Skin#">
	  		<cfset regresar = "RelacionPuestos-lista.cfm">
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarStatusText = ArrayNew(1)>
			<cfset navBarItems[1] = LB_AdministracionDePuestos>
			<cfset navBarLinks[1] = "/cfmx/rh/indexPuestos.cfm">
			<cfset navBarStatusText[1] = "/cfmx/rh/indexPuestos.cfm">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfinclude template="RelacionPuestos-form.cfm">
	  <cf_web_portlet_end>
      <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
<cf_templatefooter><!-- InstanceEnd -->