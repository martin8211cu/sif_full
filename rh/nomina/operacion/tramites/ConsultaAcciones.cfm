<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DetalleDeTramite"
	Default="Detalle de Tr&aacute;mite"
	returnvariable="LB_DetalleDeTramite"/>

<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
	<link href="../../../css/rh.css" rel="stylesheet" type="text/css">
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
	<cf_web_portlet_start titulo="#LB_DetalleDeTramite#" >
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">


					<cfif isdefined("Url.o") and not isdefined("Form.o")>
						<cfset Form.o = Url.o>
					</cfif>
					<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
						<cfset Form.sel = Url.sel>
					</cfif>
					<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
						<!--- se necesita para que se puede mandar por URL, desde tramites --->
						<cfset Form.DEid = Url.DEid>
					</cfif>
					<cfif isdefined("Url.RHAlinea") and not isdefined("Form.RHAlinea")>
						<!--- se necesita para que se puede mandar por URL, desde tramites --->
						<cfset Form.RHAlinea = Url.RHAlinea>
					</cfif>
					<!--- Parametros necesarios para entrar en modo consulta a la pantalla de acciones --->
					<cfset Form.Cambio = "CAMBIO">
					<cfset Lvar_Tramite = true>
					<cfset Request.ConsultaAcciones = 1>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  		<tr><td>&nbsp;</td></tr>
				  		<tr><td><cfinclude template="/rh/nomina/operacion/Acciones-form.cfm"></td></tr>
				  		<tr><td>&nbsp;</td></tr>
					</table>
				</td>	
			</tr>
		</table>	
	<cf_web_portlet_end>
<cf_templatefooter>