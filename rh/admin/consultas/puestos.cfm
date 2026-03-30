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
	<cfset titulo = 'Reporte de Valoraci&oacute;n de Puestos Detallado'>
	<cfif isdefined("url.tipo") and url.tipo eq 1>
		<cfset titulo = 'Reporte de Valoraci&oacute;n de Puestos Resumido'>
	</cfif>
	  <cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cfset regresar = "/cfmx/rh/indexPuestos.cfm">
	<cfset navBarItems = ArrayNew(1)>
	<cfset navBarLinks = ArrayNew(1)>
	<cfset navBarStatusText = ArrayNew(1)>
	<cfset navBarItems[1] = "Administración de Puestos">
	<cfset navBarLinks[1] = "/cfmx/rh/indexPuestos.cfm">
	<cfset navBarStatusText[1] = "/cfmx/rh/indexPuestos.cfm">

	<cfinclude template="/rh/portlets/pNavegacion.cfm">


		<cfoutput>
		<form method="post" name="form1" action="puestos-rep.cfm">
	  	<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td width="35%" nowrap align="right">Formato:&nbsp;</td>
				<td width="15%" nowrap align="left" >
					<select name="formato">
						<option value="html">En línea (HTML)</option>
						<option value="pdf">Adobe PDF</option>
						<option value="xls">Microsoft Excel</option>
					</select>
					<input name="tipo" type="hidden" value="<cfif isdefined("url.tipo")>#url.tipo#<cfelse>0</cfif>">
				</td>
				<td align="left"><input type="submit" value="Generar" name="Reporte"></td>
			</tr>
			<tr><td></td></tr>
		</table>
		</form>
		</cfoutput>
	  <cf_web_portlet_end>
      <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->