<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>	
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">			
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

<!----===========================================---->
<!----TRADUCCION								----->
<!----===========================================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ImportarIncidencias"
	Default="Importar Incidencias"
	returnvariable="LB_ImportarIncidencias"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Regresar"
	Default="Regresar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Regresar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_AplicarIncidenciasImportadas"
	Default="Mostrar Lista de Incidencias Importadas"
	returnvariable="BTN_AplicarIncidencias"/>	
<!----===========================================---->	

		<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
	  
		<cfif isdefined("url.cualimportador") and len(trim(url.cualimportador))>
			<cfset form.cualimportador = url.cualimportador>
		</cfif>
		<cfset session.Incidencias.impcalculo= false>
        <cfset lvarImportar = "INCIDENCIAS">
        <cfif isdefined("form.cualimportador") and len(trim(form.cualimportador))>
        	<cfset lvarImportar = "INCIDENCIASC">
        </cfif>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">                  		  
					<cf_web_portlet_start border="true" titulo="#LB_ImportarIncidencias#" skin="#Session.Preferences.Skin#">
						<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
							<tr><td colspan="3" align="center">
								
								<!---Se genera el llamado desde el proceso de aprobacion de incidencias nuevo --->
								<cfif isdefined("url.proc")>
									<cfset regresar = '/cfmx/rh/nomina/operacion/IncidenciasProceso.cfm' >
								<cfelse>
									<cfset regresar = '/cfmx/rh/nomina/operacion/Incidencias.cfm' >
								</cfif>
								<cfinclude template="/rh/portlets/pNavegacion.cfm">
							</td></tr>
							<tr><td colspan="3" align="center">&nbsp;</td></tr>
							<tr>
								<td align="center" width="2%">&nbsp;</td>
								<td align="center" valign="top" width="60%">
									<cf_sifFormatoArchivoImpr EIcodigo = '#lvarImportar#'>
								</td>							
								<td align="center" style="padding-left: 15px " valign="top">
									<cf_sifimportar EIcodigo="#lvarImportar#" mode="in" />
								</td>
							</tr>													
							<tr>
								<td colspan="3" align="center">
									<input type="button" name="Regresar" value="<cfoutput>#BTN_Regresar#</cfoutput>" 
									<!---Se genera el llamado desde el proceso de aprobacion de incidencias nuevo --->
									<cfif isdefined("url.proc")>
										onClick="javascript:location.href='IncidenciasProceso.cfm'"
									<cfelse>
										onClick="javascript:location.href='Incidencias.cfm'"
									</cfif>
									}>
									<cfif isdefined("form.cualimportador") and len(trim(form.cualimportador))>
										<cfset session.Incidencias.impcalculo= true>	
										<input type="button" name="IrA" value="<cfoutput>#BTN_AplicarIncidencias#</cfoutput>" 
											onClick="javascript:location.href='listadoImportadosIncidenciasCalculo.cfm'">
									</cfif>
								</td>
							</tr>				
							<tr><td colspan="3" align="center">&nbsp;</td></tr>
						</table>
					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>