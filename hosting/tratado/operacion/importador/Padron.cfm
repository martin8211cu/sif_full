<cf_template template="#session.sitio.template#">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tratado_De_Libre_Comercio"
	Default="Tratado de Libre Comercio"
	returnvariable="LB_title"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Importar_Padron_Electoral"
	Default="Importar Padr&oacute;n Electoral"
	returnvariable="LB_Importar_Padron_Electoral"/>
		
	
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
	<cf_templatearea name="title">
		<cfoutput>#LB_title#</cfoutput>
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="../../css/rh.css" rel="stylesheet" type="text/css">
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

	  <cfinclude template="../../../../sif/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
				  <cf_web_portlet_start border="true" titulo="#LB_Importar_Padron_Electoral#" skin="#Session.Preferences.Skin#">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
				<tr><td colspan="3" align="center">
					<cfset regresar = "/cfmx/hosting/tratado/index.cfm">
					<cfinclude template="../../../../sif/portlets/pNavegacion.cfm">
				</td></tr>
				<tr><td colspan="3" align="center">&nbsp;</td></tr>
				<tr>
					<td align="center" width="2%">&nbsp;</td>
					<td align="center" valign="top" width="60%">
						<cf_sifFormatoArchivoImpr EIcodigo = 'PADRON'>
					</td>
					
					<td align="center" style="padding-left: 15px " valign="top">
						<cf_sifimportar2 EIcodigo="PADRON" mode="in" />
					</td>
				</tr>
			</table>
	                <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>