<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
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


	<cfif not isdefined("form.tipo")>
		<cfset session.importarAumento.tipo = 'M' >
	<cfelse>
		<cfset session.importarAumento.tipo = form.tipo >
	</cfif>

	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">		  		                   
				<cfinvoke component="sif.Componentes.TranslateDB"
				method="Translate"
				VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
				Default="Importación de Lotes con Aumentos Salariales"
				VSgrupo="103"
				returnvariable="nombre_proceso"/>
				<cf_web_portlet_start border="true" titulo="#nombre_proceso#" skin="#Session.Preferences.Skin#">	              
					<cfset regresar = "RelacionAumento-lista.cfm">	              
					<cfinclude template="/rh/portlets/pNavegacion.cfm">	              
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
						<tr><td colspan="3" align="center">&nbsp;</td></tr>
						<tr>
							<td align="center" width="2%">&nbsp;</td>
							<td align="center" valign="top" width="60%">
								<cf_sifFormatoArchivoImpr EIcodigo = 'RHAUMENTOS'>
							</td>
							<td align="center" style="padding-left: 15px " valign="top">
								<cf_sifimportar EIcodigo="RHAUMENTOS" mode="in" />
							</td>
						</tr>
					</table>	              
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>