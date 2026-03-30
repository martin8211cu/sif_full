<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		RH - Autogesti&oacute;n
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="../rh/css/rh.css" rel="stylesheet" type="text/css">
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

	  <cfinclude template="../Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 0>
	  <cfset Session.cache_empresarial = 0>

		<br>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<!-- TemplateBeginEditable name="head" -->head<!-- TemplateEndEditable -->	
                    <!-- TemplateBeginEditable name="MenuJS" -->MenuJS<!-- TemplateEndEditable -->					
					<!-- TemplateBeginEditable name="Mantenimiento" -->mantenimiento<!-- TemplateEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>