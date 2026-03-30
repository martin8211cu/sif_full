<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_RecursosHumanos"
	Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml"/>
    
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_RecursosHumanos"
	Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" />
    
<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_RegistroDePagoDeNomina"
	Key="LB_RegistroDePagoDeNomina" Default="Registro de Pago de Nómina" />	   
 <link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
	function MM_reloadPage(init) {  //reloads the window if Nav4 resized
	  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
		document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
	  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
	}
	MM_reloadPage(true);
</script>
<cfinclude template="/rh/Utiles/params.cfm">
<cfset Session.Params.ModoDespliegue = 1>
<cfset Session.cache_empresarial = 0>
<cf_templatecss>   
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">	
    <cf_web_portlet_start titulo="#LB_RegistroDePagoDeNomina#" >
        <cfset regresar = "/cfmx/rh/pago/operacion/listaPNomina.cfm">
        <cfinclude template="/rh/portlets/pNavegacionPago.cfm">
        <cfinclude template="formPNomina.cfm">
    <cf_web_portlet_end>
<cf_templatefooter>	