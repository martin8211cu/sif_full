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
					<!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->	
                    <!-- InstanceBeginEditable name="MenuJS" --><!-- InstanceEndEditable -->					
					<!-- InstanceBeginEditable name="Mantenimiento" -->
					  <cf_web_portlet_start border="true" titulo="Importar Marcas" skin="#Session.Preferences.Skin#">
						<cfquery name="rsScript" datasource="#Session.DSN#">
							select Pvalor as Script
							from RHParametros
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and Pcodigo = 290
						</cfquery>
						
						<cfif Len(Trim(rsScript.Script))>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
							<tr><td colspan="3" align="center">
								<cfinclude template="/rh/portlets/pNavegacion.cfm">
							</td></tr>
							<tr><td colspan="3" align="center">&nbsp;</td></tr>
							<tr>
								<td align="center" width="2%">&nbsp;</td>
								<td align="center" valign="top" width="60%">
									<cf_web_portlet_start border="true" titulo="Pasos para la Importación" skin="info1">
										<li><u>Selecci&oacute;n de archivo:</u> Seleccione el archivo que desea importar presionando el botón de <strong>Browse</strong></li><br>
										<li><u>Importaci&oacute;n:</u> Una vez seleccionado el archivo presione el bot&oacute;n de <strong>Importar</strong></li><br>
										<li><u>Resumen de Importaci&oacute;n:</u> Al importar el archivo se mostrar&aacute; informaci&oacute;n relacionada con la importaci&oacute;n.</li><br>
										<li><u>Revisi&oacute;n:</u> Una vez importado el archivo puede revisar la importaci&oacute;n en Procesamiento de Marcas.<br><br>
									<cf_web_portlet_end><br><br>
								</td>
								<td align="center" style="padding-left: 15px " valign="top">
									<cf_sifimportar EIcodigo="#rsScript.Script#" mode="in" />
								</td>
							</tr>
							<tr><td colspan="3" align="center">&nbsp;</td></tr>
						</table>
						<cfelse>
							<div align="center"><strong>No ha especificado el script para importación de marcas de reloj en los Parámetros Generales</strong></div>
						</cfif>
					  <cf_web_portlet_end>
					<!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->