
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="Translate"
	method="Translate"
	Key="LB_CurriculumVitae"
	Default="Curriculum Vitae"
	returnvariable="LB_CurriculumVitae"/>

	<cfinvoke component="Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

		<cf_templatecss>
		<link href="../../css/rh.css" rel="stylesheet" type="text/css">
		
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
		<script language="JavaScript1.2" src="/js/utilesMonto.js"></script>
		<cfinclude template="../../../UtilesExt/params.cfm">
		
				
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_CurriculumVitae#'>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top">
						<cfinclude template="curriculum-form.cfm">		
					</td>
				</tr>
		     </table>						
		<cf_web_portlet_end>
	<cf_templatefooter>	