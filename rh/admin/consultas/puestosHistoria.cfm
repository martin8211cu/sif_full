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
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_ReporteDeValoracionDePuestosDetallado"
					Default="Reporte de Valoraci&oacute;n de Puestos Detallado"
					returnvariable="LB_ReporteDeValoracionDePuestosDetallado"/>
	
					<cfset titulo = LB_ReporteDeValoracionDePuestosDetallado>                  
					<cfif isdefined("url.tipo") and url.tipo eq 1>
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_ReporteDeValoracionDePuestosResumido"
							Default="Reporte de Valoraci&oacute;n de Puestos Resumido"
							returnvariable="LB_ReporteDeValoracionDePuestosResumido"/>
						<cfset titulo = LB_ReporteDeValoracionDePuestosResumido>
					</cfif>                  
					<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">	              
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_AdministracionDePuestos"
							Default="Administración de Puestos"
							returnvariable="LB_AdministracionDePuestos"/>								  
						<cfoutput>
							<cfset regresar = "/cfmx/rh/indexPuestos.cfm">
							<cfset navBarItems = ArrayNew(1)>
							<cfset navBarLinks = ArrayNew(1)>
							<cfset navBarStatusText = ArrayNew(1)>
							<cfset navBarItems[1] = "LB_AdministracionDePuestos">
							<cfset navBarLinks[1] = "/cfmx/rh/indexPuestos.cfm">
							<cfset navBarStatusText[1] = "/cfmx/rh/indexPuestos.cfm">
							<cfinclude template="/rh/portlets/pNavegacion.cfm">					
							<form method="post" name="form1" action="puestosHistoria-graph.cfm" onSubmit="return validar();">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td align="right" width="40%"><cf_translate key="LB_Puesto">Puesto</cf_translate>:&nbsp;</td><td align="left"><cf_rhpuesto tabindex="1"></td>
									</tr>
									<tr>
										<td align="center" colspan="2">
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												Key="BTN_VerReporte"
												Default="Ver Reporte"
												returnvariable="BTN_VerReporte"/>
							
											<input type="submit" value="#BTN_VerReporte#" name="Reporte" tabindex="1">
										</td>
									</tr>
									<tr><td></td></tr>
								</table>
							</form>
						</cfoutput>
					<cf_web_portlet_end>                  
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_SePresentaronLosSiguientesErroresElCampoPuestoEsRequerido"
					Default="Se presentaron los siguientes errores:\n  - El campo Puesto es requerido"
					returnvariable="MSG_SePresentaronLosSiguientesErroresElCampoPuestoEsRequerido"/>
					  
					<script type="text/javascript" type="text/javascript">
						function validar(){
							if (document.form1.RHPcodigo.value == ''){
								alert("<cfoutput>#MSG_SePresentaronLosSiguientesErroresElCampoPuestoEsRequerido#</cfoutput>.");
							return false;
						}
							return true;
						}
					</script>
      			</td>	
			</tr>
		</table>	
<cf_templatefooter>	