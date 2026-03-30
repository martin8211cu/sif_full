<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
Default="Adelanto de Cesant&iacute;a"
VSgrupo="103"
returnvariable="proceso"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Iniciar_proceso_de_Adelanto"
	Default="Iniciar proceso de Adelanto"	
	returnvariable="vIniciar"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion_proceso"
	Default="Este proceso va a calcular el pago que debe hacerse al empleado sobre el monto acumulado por cesant&iacute;a y sus inter&eacute;ses. 
			 El c&aacute;lculo se puede realizar a cualquier empleado y requiere de la autorizaci&oacute;n del ente responsable. 
			 <br><br>Por defecto el proceso trabajara con fecha de corte al dia de hoy, y con todos los empleados que hayan cumplido 8 a&ntilde;os 
			 de laborar en al empresa. <br>Si lo desea puede filtrar el proceso:<br><br>
			 <li> Fecha de Corte: fecha m&aacute;xima de calculo de la Cesant&iacute;a</li>
			 <li> Antiguedad(meses): indica la antiguedad m&iacute;nima que deben tener los empleados para ser considerados en el proceso</li>
			 <li> Empleado: si se espec&iacute;fica, trabaja solo con el empleado dado</li>
			 <li> Centro Funcional: si se espec&iacute;fica, trabaja con todos los empleados del Centro Funcional</li>
			 <br>Los filtros por Empleado y Centro Funcional son excluyentes entre si"
	returnvariable="vDescripcionProceso"/>	

<cfquery name="rs_hay_datos" datasource="#session.DSN#">
	select count(1) as registros
	from RHCesantiaLiquidacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and RHCLaprobada = 0
</cfquery>

<cfset fecha_hoy = LSDateFormat(now(), 'dd/mm/yyyy') >
<cf_templateheader title="#proceso#">
	<cf_web_portlet_start titulo="#proceso#">
		<cfoutput>
		<form name="form1" method="post" action="liquidacion-sql.cfm" style="margin:0;"> 
		<input type="hidden" name="btnEliminar" value="1" >
 		<table style="vertical-align:top" width="100%" border="0" align="center" cellpadding="2" cellspacing="2">
			<tr>
				<td valign="top" align="center">
					<table align="center" border="0"  cellpadding="2" cellspacing="0" width="100%"  class="areaFiltro" >
						<tr><td valign="top"><strong>#proceso#:</strong></td></tr>
						<tr><td valign="top">#vDescripcionProceso#</td></tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				</td>
				<cfset fecha = LSDateFormat(now(), 'dd/mm/yyyy') >
				<td width="50%" valign="top">
					<table width="100%" cellpadding="3" cellspacing="1">
						<tr>
							<td width="1%" nowrap="nowrap"><strong><cf_translate key="LB_Fecha_de_Corte">Fecha de Corte</cf_translate>:</strong></td>
							<td><cf_sifcalendario name="fecha_corte" value=#fecha#></td>
						</tr>
						<tr>
							<td width="1%" nowrap="nowrap"><strong><cf_translate key="LB_Antiguedad">Antiguedad(meses)</cf_translate>:</strong></td>
							<td><cf_inputnumber enteros="4" name="meses" decimales="0" size="4" value="96"></td>
						</tr>
						<tr>
							<td colspan="2" bgcolor="##E8E8E8" style="padding:2px;">
								<table width="100%" cellpadding="2" cellspacing="0">
									<tr>
										<td valign="middle" width="1%"><input style="background-color:##CCCCCC;" type="checkbox" name="chk_empleado" onclick="javascript:validar_empleado(this);" /></td>
										<td><strong><label for="chk_empleado" id="chk_empleado">Trabajar con empleado</label></strong></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="2"><cf_rhempleado></td>
						</tr>
						<tr>
							<td colspan="2" bgcolor="##E8E8E8" style="padding:2px;">
								<table width="100%" cellpadding="2" cellspacing="0">
									<tr>
										<td valign="middle" width="1%"><input style="background-color:##CCCCCC;" type="checkbox" name="chk_centro" id="chk_centro" onclick="javascript:validar_centro(this);" /></td>
										<td><strong><label for="chk_centro">Trabajar con empleados de Centro Funcional</label></strong></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="2"><cf_rhcfuncional></td>
						</tr>
						<tr><td colspan="2" align="center">
							<cf_botones values="#vIniciar#" names="Aplicar">
						</td></tr>
					</table>
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>	
		<script language="javascript1.2" type="text/javascript">
			function funcAplicar(){
				<cfoutput>
					if (#rs_hay_datos.registros# > 0){
						if (confirm('Hay un proceso de Adelanto de Cesantia pendiente. \n Desea eliminar los datos e iniciar un nuevo proceso? (Cancelar: trabajar con el proceso ya existente.)')){
							document.form1.btnEliminar.value = 1;
						}
						else{
							document.form1.btnEliminar.value = 0;
						}
					}
				</cfoutput>
				
				if ( document.form1.fecha_corte.value == '' ){
					document.form1.fecha_corte.value = '<cfoutput>#fecha_hoy#</cfoutput>';
				}

				if ( document.form1.meses.value == '' ){
					document.form1.meses.value = 96;
				}

				return true;	
			}
			
			function validar_empleado(obj){
				if ( obj.checked ){
					document.form1.chk_centro.checked = false;
					document.form1.CFid.value = '';
					document.form1.CFcodigo.value = '';
					document.form1.CFdescripcion.value = '';
				}
			}
			function validar_centro(obj){
				if ( obj.checked ){
					document.form1.chk_empleado.checked = false;
					document.form1.DEid.value = '';
					document.form1.DEidentificacion.value = '';
					document.form1.NombreEmp.value = '';
				}
			}
		</script>

	<cf_web_portlet_end>
	
<cf_templatefooter>
