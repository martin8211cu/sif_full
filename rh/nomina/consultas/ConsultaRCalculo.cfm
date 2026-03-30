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

	<cfif isdefined('url.HNA')>
		<cfset form.HNA = 1>
	</cfif>

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
<!--- Pasa valores del Url al Form --->
	  
              <cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_HistoricoDeNominasAplicadas"
		Default="Hist&oacute;rico de N&oacute;minas Aplicadas"
		returnvariable="LB_HistoricoDeNominasAplicadas"/>              
		
              <cf_web_portlet_start titulo="#LB_HistoricoDeNominasAplicadas#">
	          <cfif isDefined("Form.butFiltrar")>
				<!--- Reporte --->
				<cfoutput>
				<cfinclude  template="ConsultaRCalculo-form.cfm">
				<!--- <cf_rhreporte principal="ConsultaRCalculo.cfm" 
								datos="/rh/nomina/consultas/ConsultaRCalculo-form.cfm"> --->
				</cfoutput>
			  <cfelse>
				<!--- Filtro --->
				<cfinclude template="/rh/portlets/pNavegacion.cfm">
				<cfinclude template="ConsultaRCalculo-filtro.cfm">
			  </cfif>
              <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>