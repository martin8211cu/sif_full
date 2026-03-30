<cfinvoke key="LB_nav__SPdescripcion" default="Reporte de Competencias/Objetivos Evaluados"  returnvariable="LB_nav__SPdescripcion" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="BTN_Consultar" default="Consultar"  returnvariable="BTN_Consultar" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_FechaInicio" default="Fecha Inicio"  returnvariable="LB_FechaInicio" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_FechaFinaliza" default="Fecha Finaliza"  returnvariable="LB_FechaFinaliza" component="sif.Componentes.Translate"  method="Translate"/>

<cf_templateheader title="#LB_nav__SPdescripcion#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		<table width="98%" cellpadding="3" cellspacing="0">
			<tr>
				<td width="40%" valign="top">
					<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
						<p><br><cf_translate key="LB_SeIndicanLasCompetenciasQueHanSidoEvaluadasEnUnRangoDeFechas">
							Se indican las competencias o los objetivos que han sido evaluadas en un rango de fechas, 
							para un colaborador espec&iacute;fico o para todos.
							</cf_translate>
						</p><br>
					<cf_web_portlet_end>	
				</td>
				<td width="60%" valign="top">
					<form name="form1" method="post" action="graf-competenciasevaluadas-rep.cfm" onSubmit="javascript: return funcValida();">
						<table width="100%" cellpadding="2" cellspacing="0" border="0">														
							<tr>
								<td align="right"><b><cf_translate key="LB_Objetivos">Objetivos</cf_translate>:&nbsp;</b></td>
								<td><input type="radio" value="1" name="opt" id="1" checked></td>
								<td align="right" nowrap><b><cf_translate key="LB_Competencias">Competencias</cf_translate>:&nbsp;</b></td>
								<td><input type="radio" value="2" name="opt" id="2"></td>
							</tr>
							<tr>
								<td align="right" width="5%" nowrap><b><cf_translate key="LB_FechaDesde">Fecha Desde</cf_translate>:</b>&nbsp;</td>
								<td>
									<cf_sifcalendario name="finicio" value="" tabindex="4" form="form1">
								</td>
								<td align="right" width="5%" nowrap><b><cf_translate key="LB_FechaHasta">Fecha Hasta</cf_translate>:</b>&nbsp;</td>
								<td>
									<cf_sifcalendario name="ffin" value="" tabindex="5" form="form1">
								</td>
							</tr>							
							<tr>
								<td nowrap><b><cf_translate key="LB_SeleccionarEmpleado">Seleccionar Empleado</cf_translate>:&nbsp;</b></td>
								<td colspan="3">
									<input type="checkbox" name="persona" value="" onClick="javascript: funcCambio();">
								</td>
							</tr>
							<tr id="empleado" style="display:none;">
								<td align="right"><b><cf_translate key="LB_Empleado">Empleado</cf_translate>:</b>&nbsp;</td>
								<td colspan="3"><cf_rhempleado tabindex="1" size="25" form="form1"></td>
							</tr>																					
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td colspan="4" align="center">
									<cfoutput><input type="submit" name="btnConsultar" value="#BTN_Consultar#"></cfoutput>
								</td>
							</tr>
						</table>
					</form>
				</td>
			</tr>
		</table>
		<cfoutput>
			<script type="text/javascript">
				function funcValida(){					
				}
				
				function funcCambio(){
					/*Mostrar/esconder conlis*/
					if(document.form1.persona.checked){
						document.getElementById('empleado').style.display = '';						
					}
					else{
						/*Limpia el conlis de empleados*/
						document.form1.DEid.value='';				
						document.form1.NombreEmp.value='';
						document.form1.DEidentificacion.value='';
						document.getElementById('empleado').style.display = 'none';
					}				
				}
			</script>
		</cfoutput>
	<cf_web_portlet_end>	
<cf_templatefooter>
<!----
/*if(document.form1.opt[2].checked){//EMPLEADO
						if(document.form1.DEid.value == ''){
							alert('#MSG_DebeSeleccionarUnEmpleado#');
							return false;
						}
					}
					else{
						if (document.form1.opt[1].checked){//OBJETIVO
							if(document.form1.RHOSid.value == ''){
								alert('#MSG_DebeSeleccionarUnObjetivo#');
								return false;				
							}
						}
					}
					return true;*/
----->