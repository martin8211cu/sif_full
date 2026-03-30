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
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_GruposComponentesSalariales"
						Default="Grupos de Componentes Salariales"
						returnvariable="LB_GruposComponentesSalariales"/>	
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_CODIGO"
						Default="C&oacute;digo"
						XmlFile="/rh/generales.xml"
						returnvariable="LB_CODIGO"/>
				
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_DESCRIPCION"
						Default="Descripci&oacute;n"
						XmlFile="/rh/generales.xml"
						returnvariable="LB_DESCRIPCION"/>										  
					  
					  <cf_web_portlet_start titulo="<cfoutput>#LB_GruposComponentesSalariales#</cfoutput>">
						  <cfinclude template="/rh/portlets/pNavegacion.cfm">
						  <cfinclude template="formGComponentes.cfm">
					  <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>