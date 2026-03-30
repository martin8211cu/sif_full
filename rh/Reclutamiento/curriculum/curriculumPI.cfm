
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CurriculumVitae"
	Default="Curriculum Vitae"
	returnvariable="LB_CurriculumVitae"/>

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
		
	<cf_templateheader template="#session.sitio.template#">

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
		<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
		<cfinclude template="/rh/Utiles/params.cfm">
		
				
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center">
			<table width="100%" cellpadding="2" cellspacing="0">
				<cfset LvarAuto = true>
				<cfset LvarCPI = true>
						<!--- Instancia del componente de Expediente --->
				<cfinclude template="../../capacitacion/expediente/info-empleado.cfm">		
				<cfinvoke component="rh.capacitacion.expediente.expediente" method="init" returnvariable="expediente"> 
				<cfset puesto = expediente.puestoEmpleado(form.DEid, session.Ecodigo) >
				<cfset cf     = expediente.cfEmpleado(form.DEid, session.Ecodigo) >
				<cfinclude template="../../capacitacion/expediente/competencias-querys.cfm">
				<cfinclude template="../../capacitacion/expediente/querys_generales.cfm">		
				<cfset rsCAprobados = expediente.cursosLlevados(form.DEid, session.Ecodigo) >
				<cfinclude template="../../capacitacion/expediente/expediente-completo.cfm">
		<cf_web_portlet_end>
	<cf_templatefooter>	