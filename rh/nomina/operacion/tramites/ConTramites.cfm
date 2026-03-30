<!-- InstanceBegin template="/Templates/LMenuRH1.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="../../../css/rh.css" rel="stylesheet" type="text/css">
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
		  <cfif isDefined("Url.tipo") >
		  	<cfif Url.tipo EQ "1">	
				<cfset titulo ="Aprobaci&oacute;n de Tr&aacute;mites">
			<cfelseif Url.tipo EQ "2">
				<cfset titulo = "Mis Tr&aacute;mites Pendientes">
			<cfelseif Url.tipo EQ "3">
				<cfset titulo = "Consulta de Mis Tr&aacute;mites Solicitados">
			</cfif>
		  <cfelse>
		  	<cfset titulo = "Consulta de Tr&aacute;mites Pendientes">
		</cfif>
	  <cf_web_portlet_start titulo="#titulo#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">		  
			<cfinclude template="formConTramites.cfm">	  
	  <cf_web_portlet_end> 
      <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->