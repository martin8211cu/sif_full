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
	  <cf_web_portlet_start titulo="Reporte de Cargas" >
		<cfif isdefined("Url.RCNid") and not isdefined("Form.RCNid")>
			<cfparam name="Form.RCNid" default="#Url.RCNid#">
		</cfif>
	  		<cfset regresar = "/cfmx/rh/indexReportes.cfm?RCNid="&form.RCNid>
			
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr valign="top"> 
				<td>&nbsp;</td>
			  </tr>
			  <tr valign="top"> 
				<td align="center">
				  <cfinclude template="Cargas-Form.cfm">
				</td>
			  </tr>
			  <tr valign="top"> 
				<td>&nbsp;</td>
			  </tr>
			</table>
	  <cf_web_portlet_end>
      <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->