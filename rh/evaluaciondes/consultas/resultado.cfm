<cf_templateheader title="Consulta de Evaluaciones"> 

 <cf_web_portlet_start border="true" titulo="Consulta de Evaluaciones" skin="#Session.Preferences.Skin#">
 	<form name="form1" method="post" action="resultado-reporte.cfm">
 	<table>
		<tr>
			<td width="50%">
				<cf_web_portlet_start border="true" titulo="Consulta de Evaluaciones" skin="info1">
					<div align="justify">
						<p>Reporte que muestra el resultado de las evaluaciones por departamento</p>
					</div>
				<cf_web_portlet_end>
			</td>
			<td width="50%">
				<table border="0" width="100%">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td nowrap="nowrap" align="right">
							Centro Funcional:
						</td>
						<td>
							<cf_rhcfuncional>
						</td>
					</tr>
					<tr>
						<td align="right">
							Colaborador:
						</td>
						<td>
							<cf_rhempleado>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<table border="0">
								<tr> 	
									<td width="28%" align="right">
										Fecha inicial:
									</td>
									<td>
										<cf_sifcalendario name="fecha1">
									</td>
									<td>
										Fecha final:
									</td>
									<td>
										<cf_sifcalendario name="fecha2">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td><input type="radio" name="radio1" value="0" />Resumido</td>
						<td><input type="radio" name="radio1" value="1" />Detallado</td>
					</tr>
					<tr>
						<td align="center" colspan="2">
							<cf_botones names="Consultar,Limpiar" values="Consultar,Limpiar">
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</form>
  <cf_web_portlet_end>
<cf_templatefooter>