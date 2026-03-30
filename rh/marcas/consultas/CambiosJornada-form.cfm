<cf_template template="#session.sitio.template#">
	

	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

<!---
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
--->

	  <cfinclude template="/rh/Utiles/params.cfm">
	 <!---  <cfinclude template="../../expediente/consultas/consultas-frame-header.cfm">

		<cfif isdefined("rsEmpleado")>
			<cfset form.DEid = rsEmpleado.DEid>
		</cfif> --->

		<table width="100%"  border="0" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">			 
					<cfinvoke component="sif.Componentes.TranslateDB"
						method="Translate"
						VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
						Default="Reporte de Cambios de Jornada"
						VSgrupo="103"
						returnvariable="nombre_proceso"/>
					
					<cf_web_portlet_start border="true" titulo="#nombre_proceso#" skin="#Session.Preferences.Skin#">
						<cfinclude template="/rh/portlets/pNavegacion.cfm">
						<cf_rhimprime datos="/rh/marcas/consultas/CambiosJornada-Imprime.cfm"> 
						 <cfinclude template="CambiosJornada-Imprime.cfm"> 					
					<cf_web_portlet_end>	
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>