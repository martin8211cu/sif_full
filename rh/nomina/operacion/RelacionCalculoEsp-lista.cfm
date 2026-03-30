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
<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<cf_templateheader title="Recursos Humanos">
	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
				    
					<cfinvoke component="sif.Componentes.TranslateDB"
						method="Translate"
						VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
						Default="Relaciones de C&aacute;lculo Especiales"
						VSgrupo="103"
						returnvariable="nombre_proceso"/>
					<cf_web_portlet_start titulo="#nombre_proceso#">
					  <cfinclude template="/rh/portlets/pNavegacion.cfm">
					  <cfinclude template="RelacionCalculoEsp-listaForm.cfm">
				    <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>