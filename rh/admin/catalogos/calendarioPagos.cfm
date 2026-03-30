<cfinvoke Key="LB_RecursosHumanos"   Default="Recursos Humanos"    XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"   component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CalendarioDePagos" Default="Calendario de Pagos" XmlFile="/rh/generales.xml" returnvariable="LB_CalendarioDePagos" component="sif.Componentes.Translate" method="Translate"/>	
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js">
	function MM_reloadPage(init) {  //reloads the window if Nav4 resized
	  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
		document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
	  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
	}
	MM_reloadPage(true);
</script>

<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
    <table width="100%" cellpadding="2" cellspacing="0">
     	<tr>
        	<td valign="top">
            	<cfif isdefined("Url.Tcodigo") and not isdefined("Form.Tcodigo")>
                	<cfset Form.Tcodigo = Url.Tcodigo>
                </cfif>
                <cf_web_portlet_start titulo="#LB_CalendarioDePagos#" skin="#Session.Preferences.Skin#" border="true">
                    <cfset regresar = "/cfmx/rh/admin/catalogos/TiposNomina.cfm?Tcodigo=#form.Tcodigo#">
                    <cfinclude template="/rh/portlets/pNavegacion.cfm">
                    <cfinclude template="formcalendarioPagos.cfm">
                <cf_web_portlet_end>
            </td>	
        </tr>
    </table>	
<cf_templatefooter>