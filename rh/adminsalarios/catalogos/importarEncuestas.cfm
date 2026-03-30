<!--- Como el importador no recibe parametros de entrada se van a usar variables de session para poder indicarle 
que los datos pertenen a una encuesta X --->


<cfset session.Importador.EEid = "">
<cfset session.Importador.ETid = "">
<cfset session.Importador.Eid = "">

<cfset session.Importador.EEid = form.EEid>
<cfset session.Importador.ETid = form.ETid>
<cfset session.Importador.Eid = form.Eid>

<cf_template template="#session.sitio.template#">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
		
	
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<cfoutput>#LB_RecursosHumanos#</cfoutput>
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

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
                  	<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_ImportarEncuesta"
					Default="Importar Encuesta"
					returnvariable="LB_ImportarEncuesta"/>
				  
				  
				  <cf_web_portlet_start border="true" titulo="#LB_ImportarEncuesta#" skin="#Session.Preferences.Skin#">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
				<tr><td colspan="3" align="center">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
				</td></tr>
				<tr><td colspan="3" align="center">&nbsp;</td></tr>
				<tr>
					<td align="center" width="2%">&nbsp;</td>
					<td align="center" valign="top" width="60%">
						<cf_sifFormatoArchivoImpr EIcodigo = 'IMPENCUE'>
					</td>
					
					<td align="center" style="padding-left: 15px " valign="top">
						<cf_sifimportar EIcodigo="IMPENCUE" mode="in" />
					</td>
				</tr>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Regresar"
				Default="Regresar"
				XmlFile="/rh/generales.xml"
				returnvariable="BTN_Regresar"/>
				<cfoutput>
				<tr><td colspan="3" align="center"><input type="button" name="Regresar" value="#BTN_Regresar#" onClick="javascript:location.href='TEncuestadoras.cfm?EEID=#form.EEID#&EID=#form.EID#&PASO=1&TAB=4'"></td></tr>
				<tr><td colspan="3" align="center">&nbsp;</td></tr></cfoutput>
			</table>
	  
	                <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>

