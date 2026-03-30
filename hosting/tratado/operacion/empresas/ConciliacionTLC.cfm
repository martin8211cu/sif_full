<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tratado_De_Libre_Comercio"
	Default="Tratado de Libre Comercio"
	returnvariable="LB_title"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empresas"
	Default="Conciliación de Empresas"
	returnvariable="LB_Empresas"/>
	
<cf_templateheader title="#LB_title#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
	 <link href="/cfmx/sif/rh/css/rh.css" rel="stylesheet" type="text/css">
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
	<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>

	<cfinclude template="../../../../sif/Utiles/params.cfm">
	<cfset regresar = "/cfmx/hosting/tratado/index.cfm">

	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Empresas#'>﻿
		<cfinclude template="ConciliacionTLC_form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>
