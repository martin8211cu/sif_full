
	<cf_templateheader title="Cuentas por Cobrar Empleados- Consulta de Saldos por Empleado">
	
	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta Saldos por Empleado'>
			
			<cfoutput>
			<form name="form1" method="post" action="DetalleMovimientos.cfm" style="margin: 0">
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td><cfinclude template="../../portlets/pNavegacion.cfm"></td>
					</tr>
					<tr>
						<td nowrap>
							<table width="100%" border="0" cellspacing="0" cellpadding="2" >
								<tr><td colspan="2">&nbsp;</td></tr>
								<tr>
								  <td align="right" width="40%"> <strong>Fecha Inicial:&nbsp;</strong></td>
								  <td><cf_sifcalendario form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="FechaInicial"></td>
							    </tr>
								<tr>
									<td align="right"><strong>Fecha Final:&nbsp;</strong></td>
									<td><cf_sifcalendario form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="FechaFinal"> </td>
							    </tr>
								<tr>
									<td align="right"><strong>Tipo de Deduccion:&nbsp;</strong></td>
									<td>
										<cf_rhtipodeduccion size="40" validate="1" financiada="1" tabindex="1">
									</td>
							    </tr>
								<tr>
									<td nowrap align="center" colspan="2">
										<input type="submit" name="btnFiltro"  value="Consultar">&nbsp;
										<input type="reset" name="btnLimpiar"  value="Limpiar">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</form>
			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>


<!-- MANEJA LOS ERRORES--->
<cf_qforms>
<script language="javascript">
	<!--//
	
    objForm.FechaInicial.description = "Fecha Inicial";
	objForm.FechaFinal.description = "Fecha Final";
		
	function habilitarValidacion(){
	    objForm.FechaInicial.required = true;
		objForm.FechaFinal.required = true;
	}
	
	function deshabilitarValidacion(){
		objForm.FechaInicial.required = false;
		objForm.FechaFinal.required = false;
	}
	
	habilitarValidacion();
	
		
//-->
</script>



