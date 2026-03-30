<!--- 
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
 --->
 <cfinvoke component="sif.Componentes.Translate"
 method="Translate"
 Key="LB_RecursosHumanos"
 Default="Recursos Humanos"
 XmlFile="/rh/generales.xml"
 returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cf_templatecss>

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->	
                    <!-- InstanceBeginEditable name="MenuJS" --> 
		  <!-- InstanceEndEditable -->					
					<!-- InstanceBeginEditable name="Mantenimiento" --> 
	 <cfinvoke component="sif.Componentes.TranslateDB"
		method="Translate"
		VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
		Default="Importación de Lotes con Deducciones"
		VSgrupo="103"
		returnvariable="nombre_proceso"/>
	  <cf_web_portlet_start border="true" titulo="#nombre_proceso#" skin="#Session.Preferences.Skin#">
		<cfset regresar = "ListaDeducciones.cfm">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		
		<cfset importador = 'DEDUC'>
		<cfquery name="rsParametros" datasource="#Session.DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = #Session.Ecodigo#
			and Pcodigo = 840
		</cfquery>
		<cfif rsParametros.recordcount gt 0 and len(trim(rsParametros.Pvalor)) >
			<cfset importador = rsParametros.Pvalor>
		</cfif>
	
		
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
		    <td colspan="3" align="center">&nbsp;</td>
	      </tr>
		  <tr>
		    <td align="center" width="2%">&nbsp;</td>
		    <td align="center" valign="top" width="60%">
			   <cf_sifFormatoArchivoImpr EIcodigo = '#trim(importador)#'>
			</td>
			<td align="center" style="padding-left: 15px " valign="top">
				<cf_sifimportar EIcodigo="#trim(importador)#" mode="in" />
			</td>
		  </tr>
		</table>
	  <cf_web_portlet_end>
		<cf_templatefooter>
<!--- 		
      <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->

 --->