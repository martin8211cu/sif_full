	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	returnvariable="LB_RecursosHumanos"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConstanciaDeSalarioEnPeriodoEspecial"
	Default="Constancia de Salario en Periodo Especial"
	returnvariable="LB_ConstanciaDeSalarioEnPeriodoEspecial"/>

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
	  <cfset vparams = "&sel=1" >
	  <cfif isdefined("form.DEid")>
	  	<cfset vparams = vparams & "&DEid=" & form.DEid>
	  </cfif>
	    <cfif isdefined("form.fechaI")>
			<cfset vparams = vparams & "&fechaI=" & form.fechaI>
		</cfif>
		<cfif isdefined("form.fechaF")>
			<cfset vparams = vparams & "&fechaF=" & form.fechaF>
		</cfif>
	  <cfset Regresar = '/cfmx/rh/index.cfm'>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
                	<cf_web_portlet_start border="true" titulo="#LB_ConstanciaDeSalarioEnPeriodoEspecial#" skin="#Session.Preferences.Skin#">
						<cfif isdefined("form.DEid")>
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
							<cf_rhimprime datos="/rh/expediente/consultas/ConstanciaEspecial-detalle.cfm" paramsuri="#vparams#">
							<cfinclude template="ConstanciaEspecial-detalle.cfm">
							<!---<cf_rhimprime principal="#regresar#" datos="/rh/expediente/consultas/ConstanciaEspecial-detalle.cfm" objetosform="false" paramsuri="#vparams#">--->
						<cfelse>
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
							<cfinclude template="ConstanciaEspecial-detalle.cfm">
						</cfif>
				  	<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>