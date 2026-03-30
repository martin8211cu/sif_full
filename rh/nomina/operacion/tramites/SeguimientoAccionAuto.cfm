<!-- InstanceBegin template="/Templates/LMenuRH2.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		RH - Autogesti&oacute;n
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
	  <cfset Session.Params.ModoDespliegue = 0>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2"  cellspacing="0">
			<tr>
				<td valign="top">
					<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->	
                    <!-- InstanceBeginEditable name="MenuJS" --> 
		  <!-- InstanceEndEditable -->					
					<!-- InstanceBeginEditable name="Mantenimiento" --> 
	  <cf_web_portlet_start titulo="Detalle de Seguimiento de la Acci&oacute;n">
		  <cfset Regresar = "ConTramitesAuto.cfm">
		  <cfif isDefined("Form.tipo") and Len(Trim(Form.tipo)) GT 0 >
		  	<cfset Regresar = Regresar & "?tipo=" & Form.tipo>	
		  </cfif>		
		<cfif isdefined("Form.RHAlinea")>
			<cf_rhreporte principal="#Regresar#" datos="/rh/nomina/operacion/tramites/formSeguimientoAccion.cfm">
		</cfif>
	  <cf_web_portlet_end>
      <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->