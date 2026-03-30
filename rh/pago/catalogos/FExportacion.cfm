<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_RecursosHumanos"
	Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/sif/rh/generales.xml"/>
   
<cfinvoke component="sif.Componentes.TranslateDB" method="Translate" returnvariable="nombre_proceso"
    VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#" Default="Formatos de Exportación" VSgrupo="103" />

<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_DescripcionDeExportacion"
    Key="LB_DescripcionDeExportacion" Default="Descripción de Exportación"/>	

	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
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
<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_web_portlet_start border="true" titulo="#nombre_proceso#" skin="#Session.Preferences.Skin#">
        <cfinclude template="/rh/portlets/pNavegacionPago.cfm">
        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="30%" valign="top">			
                <cfinvoke component="sif.crm.Componentes.pListas" method="pListaCRM" returnvariable="pListaCRMRet">
                    <cfinvokeargument name="tabla" 		value="RHExportaciones a, Bancos b"/>
                    <cfinvokeargument name="columnas" 	value="a.Bid, a.EIid, a.RHEdescripcion, b.Bdescripcion"/>
                    <cfinvokeargument name="cortes" 	value="Bdescripcion"/>
                    <cfinvokeargument name="desplegar" 	value="RHEdescripcion"/>
                    <cfinvokeargument name="etiquetas" 	value="#LB_DescripcionDeExportacion#"/>
                    <cfinvokeargument name="formatos"	value="S"/>
                    <cfinvokeargument name="filtro" 	value="a.Ecodigo = #Session.Ecodigo# and a.Bid = b.Bid order by Bdescripcion"/>
                    <cfinvokeargument name="align" 		value="left"/>
                    <cfinvokeargument name="ajustar" 	value="N"/>
                    <cfinvokeargument name="irA" 		value="FExportacion.cfm"/>
                </cfinvoke>
            </td>
            <td width="10%">&nbsp;</td>
            <td width="60%" valign="top">
                <cfinclude template="formFExportacion.cfm">
            </td>
          </tr>
        </table>
    <cf_web_portlet_end>
<cf_templatefooter>