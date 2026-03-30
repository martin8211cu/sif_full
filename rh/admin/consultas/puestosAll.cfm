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
	<cfset titulo = "">
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ReporteDeValoracionDePuestos"
		Default="Reporte de Valoraci&oacute;n de Puestos"
		returnvariable="LB_ReporteDeValoracionDePuestos"/>
	<cfset titulo = LB_ReporteDeValoracionDePuestos>
	<cfif isdefined("form.tipo") and form.tipo eq 1>
		<cfset titulo = LB_ReporteDeValoracionDePuestos>
	</cfif>

	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_AdministracionDePuestos"
						Default="Administración de Puestos"
						returnvariable="LB_AdministracionDePuestos"/>
	
						<cfset regresar = "/cfmx/rh/indexPuestos.cfm">
						<cfset navBarItems = ArrayNew(1)>
						<cfset navBarLinks = ArrayNew(1)>
						<cfset navBarStatusText = ArrayNew(1)>
						<cfset navBarItems[1] = LB_AdministracionDePuestos>
						<cfset navBarLinks[1] = "/cfmx/rh/indexPuestos.cfm">
						<cfset navBarStatusText[1] = "/cfmx/rh/indexPuestos.cfm">
					
						<cfinclude template="/rh/portlets/pNavegacion.cfm">
			
			
						<cfoutput>
						<form method="get" name="form1" action="puestos-rep.cfm" onsubmit="return valida(this);">
							<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
									<td width="50%">
										<table width="100%">
											<tr>
												<td valign="top">	
													<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="LB_ValoracionDePuestos"
													Default="Valoraci&oacute;n de Puestos"
													returnvariable="LB_ValoracionDePuestos"/>
													
													
													<cf_web_portlet_start border="true" titulo="#LB_ValoracionDePuestos#" skin="info1">
														<div align="justify">
															<cf_translate key="MSG_EnEsterReporteSeCalificanAspectosMuyPrecisosYPuntualesDeCadaPuestoEvaluadoEncontraremosDosTiposDeReporteElResumidoYElDetalladoEnElResumidoSeListanLosPuestosDefinidosYElTotalDePuntosObtenidosEnElDetalladoSeMuestraComoSeObtuvoLaCalificacionObtenidaEsteReporteSePuedeGenerarEnVariosFormatosAumentandoAsíSuUtilidadYEficienciaEnElTrasladoDeDatos">
															En &eacute;ste reporte 
														  se califican
														  aspectos muy precisos y puntuales de
														  cada puesto evaluado; Encontraremos
														  dos tipos de reporte, el resumido y
														  el detallado; En el resumido se listan
														  los puestos definidos y el total de
														  puntos obtenidos. En el detallado	se
														  muestra cada uno de los aspectos evaluados para obtener la calificaci&oacute;n.
														  Este reporte se
														  puede generar en varios formatos, aumentando
														  as&iacute; su utilidad
														  y eficiencia en el traslado de datos.
														  </cf_translate>
														</div>
													<cf_web_portlet_end>
												</td>
											</tr>
										</table>  
									</td>
									<td width="50%" valign="top">
										<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
											<tr><td colspan="2">&nbsp;</td></tr>
											<tr>
												<td nowrap="true"><strong><cf_translate key="LB_CentroFuncional"  XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:</strong>&nbsp;</td>
												<td><cf_rhcfuncional tabindex="1"></td>
											</tr>
											<!--- Tipos de Puestos --->
											<cfquery name="rsTipos" datasource="#session.dsn#">
												select RHTPid, RHTPcodigo, RHTPdescripcion
												from RHTPuestos
												where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											</cfquery>
											<tr>
												<td align="right"><strong><cf_translate key="LB_Tipo" XmlFile="/rh/generales.xml">Tipo</cf_translate>:&nbsp;</strong></td>
												<td align="left">
													<select name="RHTPid" tabindex="1">
														<option value=""></option>
													  	<cfloop query="rsTipos">
															<option value="#rsTipos.RHTPid#">
																#rsTipos.RHTPcodigo# - #rsTipos.RHTPdescripcion#
															</option>
													  </cfloop>
													</select>
												</td>
											</tr>
											<tr>
				                            	<td align="right" nowrap>
													<strong><cf_translate key="LB_Formato">Formato</cf_translate>:</strong>&nbsp;
												</td>
												<td>
				                                    <select name="formato" tabindex="1">
				                                      <option value="flashpaper">Flash Paper</option>
				                                      <option value="pdf">Adobe PDF</option>
				                                      <option value="excel">Microsoft Excel</option>
				                                    </select>
												</td>
				                          	</tr>
											<tr><td colspan="2">&nbsp;</td></tr>
											<tr>
												<td align="center" nowrap colspan="2">
													<div align="center">
											    	<input name="tipo1" type="radio" tabindex="1" value="0"  checked onClick="javascript:document.form1.tipo2.checked=false;" id="tipo1">
													<label for=tipo1><cf_translate key="RAD_Resumida">Resumida</cf_translate></label>   
					 						    	<input name="tipo2" type="radio" tabindex="1" value="1" onClick="javascript:	document.form1.tipo1.checked=false;" id="tipo2">
				 						      		<label  for=tipo2><cf_translate key="RAD_Detallada">Detallada</cf_translate></label>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
				 						      		<!--- <input name="tipo" type="hidden" value="<cfif isdefined("form.tipo")>#form.tipo#<cfelse>0</cfif>"> --->
											    	</div>
												</td>
										  	</tr>
											<tr><td colspan="2">&nbsp;</td></tr>
											<tr>
												<td colspan="2" align="center">
													<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="BTN_Generar"
														Default="Generar"
														XmlFile="/rh/generales.xml"
														returnvariable="BTN_Generar"/>
													<input type="submit" name="Reporte" value="#BTN_Generar#" tabindex="1">
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</form>
						</cfoutput>

				</td>	
			</tr>
		</table>	
	  <cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript">
	function valida(formulario){
		var mensaje = '<cfoutput>Se presentaron los siguientes errores</cfoutput>:\n';
		var error = false;
		if ( trim(formulario.CFid.value) == '' ){
				mensaje = mensaje + ' - <cfoutput>El campo Centro Funcional es requerido</cfoutput>\n' 
				formulario.CFid.style.backgroundColor = '#FFFFCC';
				error = true;
			}
		if ( trim(formulario.RHTPid.value) == '' ){
				mensaje = mensaje + ' - <cfoutput>El campo Tipo es requerido</cfoutput>\n' 
				formulario.RHTPid.style.backgroundColor = '#FFFFCC';
				error = true;
			}
		if (error){
			alert(mensaje);
			return false;
		}

		return true;
	
	}
	
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
</script>