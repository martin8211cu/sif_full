<cfsetting requesttimeout="8600">
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate"	method="Translate" Key="LB_Reporte_de_Prestaciones_Legales_por_Pagar" Default="Reporte de Prestaciones Legales por Pagar" returnvariable="LB_Reporte_de_Prestaciones_Legales_por_Pagar"/> <cfinvoke key="BTN_Consultar" default="Consultar" returnvariable="BTN_Consultar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke Key="MSG_DebeSeleccionarElConceptoDePago" Default="Debe seleccionar el Concepto de Pago" returnvariable="MSG_DebeSeleccionarElConceptoDePago" component="sif.Componentes.Translate" method="Translate"/>
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
		<cf_web_portlet_start titulo="#LB_Reporte_de_Prestaciones_Legales_por_Pagar#" >
		<cfinclude template="/rh/portlets/pNavegacionPago.cfm">
		<form style="margin:0 " name="form1" method="post" action="RepPrestacionesLegalesPorPagar-rep.cfm" onsubmit="javascript: return funcValidar();">
						
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td width="50%" valign="top">
					<table width="100%">
						<tr>
							<td valign="top">	
								<cf_web_portlet_start border="true" titulo="#LB_Reporte_de_Prestaciones_Legales_por_Pagar#" skin="info1">
									<div align="justify">
									  <p>
									  <cf_translate  key="LB_AYUDA_Prestaciones_Legales_Por_Pagar">
									  	Éste reporte muestra el monto del Concepto seleccionado pendiente por pagar para cada uno de los colaboradores activos, según la fecha de corte y los filtros que se utilicen en el reporte
									  </cf_translate>.
									  </p>
								</div>
							  <cf_web_portlet_end></td>
						</tr>
					</table>  
				</td>
				<td valign="top">  
					<cf_web_portlet_start border="true" skin="info1">              	
					<table width="100%" cellpadding="1" cellspacing="1" border="0">
						<tr><td colspan="2">&nbsp;</td></tr>
						
						<tr>
							<td colspan="2" align="right" nowrap="nowrap"><strong><cf_translate  key="LB_Concepto_De_Pago">Concepto de Pago</cf_translate>:&nbsp;</strong></td>										
							<td>
								<cf_rhCIncidentes IncluirTipo="3" codigosize='10' size='40' >
							</td>
						</tr>
						
						<tr>
							<td align="right" colspan="2" nowrap="nowrap"><strong><cf_translate  key="LB_FechaInicial">Fecha corte</cf_translate>:&nbsp;</strong></td>
							<td>
								<cf_sifcalendario name="FechaCorte" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="5" form="form1">	
							</td>
						</tr>
						
						<tr>
							<td align="left"> <input type="radio" name="rdForm" value="1" onclick="javascript:activarCombos(this);" /></td>
							<td align="left" nowrap="nowrap"><strong><cf_translate  key="LB_Oficina">Oficina</cf_translate>:&nbsp;</strong></td>										
							<td>
								<cf_sifoficinas form="form1" name="Ocodigo" >
							</td>
						</tr>
						<tr>
							<td align="left"> <input type="radio" name="rdForm" value="2" checked="checked" onclick="javascript:activarCombos(this);"/></td>
							<td align="left" nowrap="nowrap"><strong><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</strong></td>										
							<td>
								<cf_rhcfuncional form="form1" >
							</td>
						</tr>
						<tr>
							<td colspan="2" align="right">
								<input type="checkbox" name="dependencias" value="dependencias" <cfif isdefined("form.dependencias")>checked</cfif>>										
							</td>
							<td >
								<cf_translate  key="LB_IncluirDependencias">Incluir dependencias</cf_translate>&nbsp;
							</td>
						</tr>
					
						<tr>
							<td align="right" colspan="2">
								<input type="checkbox" name="CFagrupamiento" value="CFagrupamiento" <cfif isdefined("form.CFagrupamiento")>checked</cfif>>										
							</td>
							<td nowrap="nowrap">
								<cf_translate  key="LB_Agrupamiento_Centro_Funcional">Agrupamiento por centro funcional</cf_translate>&nbsp;
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>								
						
						<tr>
							<td colspan="3" align="center">
								<input type="submit" name="btn_consultar" value="#BTN_Consultar#" class="btnNormal"/>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					</cf_web_portlet_start>
				</td>	
			</tr>
		</table>
		</form>
		<cf_web_portlet_end>
		<script type="text/javascript">
			function funcValidar(){
				if (document.form1.CIcodigo.value == ''){
					alert('#MSG_DebeSeleccionarElConceptoDePago#');
					return false;
				}
				return true;
			}
			
			function activarCombos(e){
				if(e.value == 1){
					document.form1.Oficodigo.disabled=false;
					document.form1.Odescripcion.disabled=false;
					document.form1.CFcodigo.disabled=true;
					document.form1.CFdescripcion.disabled=true;
					document.form1.dependencias.disabled=true;
					document.form1.dependencias.checked=false;
					document.form1.CFcodigo.value='';
					document.form1.CFdescripcion.value='';
					
				}
				else{
					document.form1.Oficodigo.disabled=true;
					document.form1.Odescripcion.disabled=true;
					document.form1.CFcodigo.disabled=false;
					document.form1.CFdescripcion.disabled=false;
					document.form1.dependencias.disabled=false;
					document.form1.Oficodigo.value='';
					document.form1.Odescripcion.value='';
					
				}

			}
			document.form1.Oficodigo.disabled=true;
			document.form1.Odescripcion.disabled=true;
		</script>
		</cfoutput>					
	<cf_templatefooter>