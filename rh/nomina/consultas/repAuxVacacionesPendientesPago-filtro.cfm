<cfsetting requesttimeout="8600">
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_ReporteDeVacacionesPendientesPorPagar" default="Reporte de Vacaciones de Pendientes por Pagar" returnvariable="LB_ReporteDeVacacionesPendientesAPagar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Consultar" default="Consultar" returnvariable="BTN_Consultar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke Key="MSG_DebeSeleccionarElConceptoDePagoDeVacaciones" Default="Debe seleccionar el Concepto de Pago de Vacaciones" returnvariable="MSG_DebeSeleccionarElConceptoDePagoDeVacaciones" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

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
		<cfoutput>
		<cf_web_portlet_start titulo="#LB_ReporteDeVacacionesPendientesAPagar#" >
		<cfinclude template="/rh/portlets/pNavegacionPago.cfm">
		<form style="margin:0 " name="form1" method="post" action="repAuxVacacionesPendientesPago-rep.cfm" onsubmit="javascript: return funcValidar();">
						
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td width="40%" valign="top">
					<table width="100%">
						<tr>
							<td height="173" valign="top">	
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="LB_Auxiliar_Vacaciones_pendientes_por_Pagar"
								Default="Auxiliar de vacaciones pendientes por Pagar"
								returnvariable="LB_Auxiliar_Vacaciones_pendientes_por_Pagar"/> 
								
								
								<cf_web_portlet_start border="true" titulo="#LB_Auxiliar_Vacaciones_pendientes_por_Pagar#" skin="info1">
									<div align="justify">
									  <p>
									  <cf_translate  key="LB_AYUDA_Vacaciones_Pendientes_por_Pagar">
									  &Eacute;ste reporte muestra el monto de las vacaciones pendientes por pagar para cada uno de los colaboradores activos, según la fecha de corte o la fecha actual, y filtros que se utilicen en el reporte.
									  </cf_translate>
									  </p>
								</div>
							  <cf_web_portlet_end></td>
						</tr>
					</table>  
				</td>
				<td valign="top">                	
					<table width="100%" cellpadding="1" cellspacing="1" border="0">
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr>
							<td align="right"><strong><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</strong></td>										
							<td>
								<cf_rhcfuncional form="form1" name="CFcodigoI" desc="CFdescripcionI" id="CFidI" codigosize='10' size='40' >
							</td>
						</tr>
						<tr>
							<td align="right">
								<input type="checkbox" name="dependencias" value="dependencias" <cfif isdefined("form.dependencias")>checked</cfif>>										
							</td>
							<td>
								<cf_translate  key="LB_IncluirDependencias">Incluir dependencias</cf_translate>&nbsp;
							</td>
						</tr>
						<tr>
							<td align="right"><strong><cf_translate  key="LB_FechaInicial">Fecha corte</cf_translate>:&nbsp;</strong></td>
							<td>
								<cf_sifcalendario name="FechaCorte" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="5" form="form1">	
							</td>
						</tr>
						<tr>
							<td align="right">
								<input type="checkbox" name="CFagrupamiento" value="CFagrupamiento" <cfif isdefined("form.CFagrupamiento")>checked</cfif>>										
							</td>
							<td nowrap="nowrap">
								<cf_translate  key="LB_Agrupamiento_Centro_Funcional">Agrupamiento por centro funcional</cf_translate>&nbsp;
							</td>
						</tr>
						
						<tr>
							<td align="right"><strong><cf_translate  key="LB_ConceptoVacaciones">Concepto de Vacaciones</cf_translate>:&nbsp;</strong></td>										
							<td>
								<cf_rhCIncidentes IncluirTipo="3" codigosize='10' size='40' >
							</td>
						</tr>
						
						<tr><td>&nbsp;</td></tr>								
						
						<tr>
							<td colspan="2" align="center">
								<input type="submit" name="btn_consultar" value="#BTN_Consultar#"/>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				</td>	
			</tr>
		</table>
		</form>
		<cf_web_portlet_end>
		<script type="text/javascript">
			function funcValidar(){
				if (document.form1.CIcodigo.value == ''){
					alert('#MSG_DebeSeleccionarElConceptoDePagoDeVacaciones#');
					return false;
				}
				return true;
			}
		</script>
		</cfoutput>					
	<cf_templatefooter>