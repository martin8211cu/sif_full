<cf_templateheader title="Cobro de Cursos"> 

 <cf_web_portlet_start border="true" titulo="Cursos Reprobados" skin="#Session.Preferences.Skin#">
 	<form name="form1" method="post" action="cursosperdidos-reporte.cfm">
 	<table>
		<tr>
			<td width="50%">
				<cf_web_portlet_start border="true" titulo="Consulta de Evaluaciones" skin="info1">
					<div align="justify">
						<p>Reporte que muestra el listado de los Empleados a los que se les realizo una deducción por concepto de cursos reprobados, dicho listado es filtrado por un rango de fechas establecido</p>
					</div>
				<cf_web_portlet_end>
			</td>
			<td width="50%">
				<table border="0" width="100%">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td nowrap="nowrap" align="right">
							Fecha desde:
						</td>
						<td>
							<cf_sifcalendario name="fdesde" index="1">
						</td>
					</tr>
					<tr>
						<td align="right">
							Fecha hasta:
						</td>
						<td>
							<cf_sifcalendario name="fhasta" index="2">
						</td>
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
