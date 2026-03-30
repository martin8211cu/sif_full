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
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">		  		                   
				<cfinvoke component="sif.Componentes.TranslateDB"
				method="Translate"
				VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
				Default="Importación de Lotes con Aumentos Salariales"
				VSgrupo="103"
				returnvariable="nombre_proceso"/>
				<cf_web_portlet_start border="true" titulo="#nombre_proceso#" skin="#Session.Preferences.Skin#">	              
					<cfset regresar = "RelacionAumento-lista.cfm">	              
					<cfinclude template="/rh/portlets/pNavegacion.cfm">	              
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
						<tr><td colspan="3" align="center">&nbsp;</td></tr>
						<tr>
							<td align="center" width="2%">&nbsp;</td>
							<td align="center" valign="top" width="60%">
								<cf_sifFormatoArchivoImpr EIcodigo = 'RHAUMENTOS'>
							</td>
							<td align="center" style="padding-left: 15px " valign="top">
								<cfoutput>

								<!--- cada vez que importo elimino la variable de session que indica el tipo--->
								<cfif isdefined('session.importarAumento')>
									<cfset structdelete(session,'importarAumento') >
								</cfif>
								<form name="form1" method="post" action="RelacionAumento-import.cfm">
									<table width="100%">
										<tr>
											<td width="1%" nowrap="nowrap" ><strong><cf_translate key="Tipo_de_Aumento">Tipo de Aumento</cf_translate>:</strong>&nbsp;</td>
											<td>
												<select name="tipo" id="tipo">
													<option value="M"><cf_translate key="LB_Monto">Monto</cf_translate></option>
													<option value="P"><cf_translate key="LB_Porcentaje">Porcentaje</cf_translate></option>
												</select>
											</td>
										</tr>
										<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="LB_Siguiente"
											Default="Siguiente"	
											returnvariable="LB_Siguiente"/>
										<tr><td colspan="2" align="center"><input type="submit" class="btnSiguiente" name="btnAplicar" id="btnAplicar" value="#LB_Siguiente#" ></td></tr>
									</table>
								</form> 
								</cfoutput>
							</td>
						</tr>
					</table>	              
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>