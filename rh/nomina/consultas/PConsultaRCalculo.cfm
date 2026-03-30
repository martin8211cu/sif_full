<cfif isdefined("Url.RCNid") and not isdefined("Form.RCNid")>
	<cfparam name="Form.RCNid" default="#Url.RCNid#">
</cfif>
<cfif isDefined("Url.Tcodigo") and not isDefined("Form.Tcodigo")>
	<cfset Form.Tcodigo = Url.Tcodigo>
</cfif>
<cfif isDefined("Url.fecha") and not isDefined("Form.fecha")>
	<cfset Form.fecha = Url.fecha>
</cfif>
<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="#LB_RecursosHumanos#">
	
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
			  <!--- Pasa valores del Url al Form --->
				<cfinvoke component="sif.Componentes.TranslateDB"
					method="Translate"
					VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
					Default="Reporte de N&oacute;minas en Proceso"
					VSgrupo="103"
					returnvariable="nombre_proceso"/>
				<cf_web_portlet_start titulo="#nombre_proceso#">
					<cfif isDefined("Url.RCNid") and not isDefined("Form.RCNid")>
						<cfset Form.RCNid = Url.RCNid>
					</cfif>
					<!--- Reporte --->
					 	<script language="JavaScript1.2" type="text/javascript">
						function regresar(){
							location.href='/cfmx/rh/nomina/operacion/ResultadoCalculo-lista.cfm?RCNid=<cfoutput>#Form.RCNid#</cfoutput>';
						}
					</script>
					<cfoutput>
						<form action="/cfmx/rh/nomina/operacion/ResultadoCalculo-lista.cfm" method="get" name="formback">
							<input name="RCNid" type="hidden" value="#Form.RCNid#">
						</form>
					</cfoutput>
					<cfset funcion = "javascript: regresar();">
					<cfset param = '?RCNid=#form.RCNid#'>
					<cfif isdefined('url.fecha')>
						<cfset param = param &"&fecha=#url.fecha#">
					</cfif>
					<cfif isdefined('url.Tcodigo')>
						<cfset param = param & '&Tcodigo=#url.Tcodigo#'>
					</cfif>
					<cfinclude template="PConsultaRCalculo-form.cfm">
					<!--- <cf_rhreporte principal="#funcion#"	datos="/rh/nomina/consultas/PConsultaRCalculo-form.cfm" paramsuri="#param#"> --->
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>