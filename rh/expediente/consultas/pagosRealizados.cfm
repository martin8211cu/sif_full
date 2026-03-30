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
	  <cf_web_portlet_start titulo="Hist&oacute;rico de pagos realizados">
		  	<table width="100%" border="0" cellpadding="0" cellspacing="0">
			  <tr>
				<td>


					<cfif isDefined("Form.DEid") and not isDefined("Form.Regresar")>
						<cfset regresar = "index.cfm">
					<cfelseif isDefined("Form.DEid") and isDefined("Form.Regresar")>
						<cfoutput>
						<form name="Regresar" method="post" action="index.cfm">
							<input type="hidden" name="DEid" value="#Form.DEid#">
						</form>
						</cfoutput>
						<cfset regresar = "javascript: document.Regresar.submit();">
					</cfif>					

					
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
				</td>
			  </tr>
			  <tr>
			  	<td>&nbsp;
				</td>
			  </tr>
		    </table>
			<cfinclude template="pagosRealizadosForm.cfm">
	  <cf_web_portlet_end>
      <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->