<cf_template template="#session.sitio.template#">

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templatearea name="title">
		<cfoutput>#LB_RecursosHumanos#</cfoutput>
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
			  <cfif  isDefined("Form.DEid")>
				  <cfset Form.DEid = form.DEid>
			  </cfif>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_ReporteDeHorasExtrasAutorizadas"
				Default="Reporte de Horas Extras Autorizadas"
				returnvariable="titulo"/>


			   <cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
				   	<cfinclude template="/rh/portlets/pNavegacion.cfm">
					<cfif isdefined("form.DEid") and len(trim(form.DEid)) NEQ 0>
						<cf_rhimprime datos="/rh/marcas/consultas/HorasExtras-imprime2.cfm" paramsuri="&DEid=#form.DEid#"> 
					<cfelse>
						<cf_rhimprime datos="/rh/marcas/consultas/HorasExtras-imprime2.cfm"> 
					</cfif>	
					 <cfinclude template="HorasExtras-imprime2.cfm">
	              <cf_web_portlet_end>	
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>