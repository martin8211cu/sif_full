
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templateheader title="Cuentas por Cobrar Empleados">

	
	

<cf_templatecss>

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

	  <cfinclude template="../../Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
						<cfif isdefined("form.CPid") and len(trim(form.CPid))>
							<cfset Regresar = '/cfmx/rh/index.cfm'>
					  		<cfinclude template="../../portlets/pNavegacion.cfm">
							<cf_rhimprime datos="/sif/ccrh/consultas/RebajosAplicados-detalle.cfm" paramsuri="&CPid=#form.CPid#&Tcodigo=#form.Tcodigo#&CPdescripcion=#form.CPdescripcion#">
							<cfinclude template="RebajosAplicados-detalle.cfm">
						<cfelse>
							<cf_web_portlet_start border="true" titulo="Rebajos Aplicados " skin="#Session.Preferences.Skin#">
								<cfset Regresar = '/cfmx/rh/index.cfm'>
								<cfinclude template="../../portlets/pNavegacion.cfm">
								<cfinclude template="RebajosAplicados-filtro.cfm">
							<cf_web_portlet_end>
						</cfif>
	<cf_templatefooter>