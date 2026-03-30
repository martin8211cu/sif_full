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
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="ErroresNomina"
				Default="Errores en Pago de N&oacute;mina"
				XmlFile="/rh/generales.xml"
				returnvariable="ErroresNomina"/>
							
					
	  <cf_web_portlet_start titulo="#ErroresNomina#" >
		    <cfinclude template="/rh/portlets/pNavegacionPago.cfm">
		    <table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
			  <tr>
				<td nowrap align="center">&nbsp;</td>
			  </tr>
			  <tr>
				<td nowrap align="left" class="fileLabel">
					&nbsp;Seleccione el Registro de Nómina que desee Corregir:
				</td>
			  </tr>
			  <tr>
				<td nowrap align="center">&nbsp;</td>
			  </tr>
			  <tr>
				<td align="center">
					<cfset Form.ERNestado = "9">
					<cfset Form.ERNcapturado = "False">
					<cfset Form.ERNfverifica = "True">
					<cfset Form.PermiteFiltro = "True">
					<cfset Form.Botones = "None">
					<cfset Form.irA = "XNomina.cfm">
					<cfinclude template="formLNomina.cfm">
				</td>
			  </tr>
			</table>
	  <cf_web_portlet_end>
      <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->