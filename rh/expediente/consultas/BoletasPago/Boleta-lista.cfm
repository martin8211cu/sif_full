<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

<cf_templatecss>
<link href="../css/rh.css" rel="stylesheet" type="text/css">
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
			<!----=================== TRADUCCION ========================---->
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Envio_de_boletas_de_pago_aplicadas"
				Default="Envio de boletas de pago aplicadas"	
				returnvariable="LB_Envio_de_boletas_de_pago_aplicadas"/>
				
			  <cf_web_portlet_start border="true" titulo="#LB_Envio_de_boletas_de_pago_aplicadas#" skin="#Session.Preferences.Skin#">
				 <cfinclude template="../../../portlets/pNavegacion.cfm">
				 <cfinclude template="frame-Boletas.cfm">
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>