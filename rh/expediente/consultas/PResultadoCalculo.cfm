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
Key="LB_ReporteDePagosEnProceso"
Default="Reporte de Pagos en Proceso"
returnvariable="LB_ReporteDePagosEnProceso"/> 					
	  <cf_web_portlet_start titulo="#LB_ReporteDePagosEnProceso#">
		  	<script language="JavaScript1.2" type="text/javascript">
				function regresar(){
					//document.formback.submit();
					location.href="<cfoutput>#url.Regresar#?Tcodigo=#url.Tcodigo#&fecha=#url.fecha#&RCNid=#url.RCNid#</cfoutput>";
					}</script>
			<cfoutput>
			<!--- 
				<form action="#Url.Regresar#" method="post" name="formback">
					<input name="Tcodigo" type="hidden" value="#Url.Tcodigo#">
					<input name="fecha" type="hidden" value="#Url.fecha#">
					<input name="butFiltrar" type="hidden" value="Filtrar">
					<input name="RCNid" type="hidden" value="#Url.RCNid#">
				</form>
			--->	
			</cfoutput>
			<cfset funcion = "javascript: regresar();">
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

			  <tr valign="top"> 
				<td align="center">
					<cf_rhreporte principal="#funcion#" datos="/rh/expediente/consultas/PResultadoCalculo-form.cfm" objetosform="False" paramsuri="?DEid=#url.DEid#&RCNid=#url.RCNid#&Tcodigo=#url.Tcodigo#&fecha=#url.fecha#&Regresar=#url.Regresar#">
				</td>
			  </tr>
			  <tr valign="top"> 
				<td>&nbsp;</td>
			  </tr>
			  <tr valign="top"> 
				<td>&nbsp;</td>
			  </tr>
			</table>
	  <cf_web_portlet_end>
      <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->