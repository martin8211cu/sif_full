<cf_templateheader title="Evaluación de Cuestionarios"> 

 <cf_web_portlet_start border="true" titulo="Evaluación de Cuestionarios" skin="#Session.Preferences.Skin#">
 	<form name="form1" method="post" action="evalCuestionario-reporte.cfm" onsubmit="return Validar(this);">
 	<table>
		<tr>
			<td width="50%">
				<cf_web_portlet_start border="true" titulo="Evaluación de Cuestionarios" skin="info1">
					<div align="justify">
						<p>Este reporte muestra los resultados obtenidos de la aplicación de una evaluación, ya sea por ítem detallado o resumido,
						si la opción seleccionada es Resumido o Observaciones se realiza la consulta de manera general sobre la evaluación, si es detallada
						requiere que se indique el colaborador</p>
					</div>
				<cf_web_portlet_end>
			</td>
			<td width="50%">
				<table border="0" width="100%">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="right">
							Evaluación:
						</td>
						<td>
							<cf_rhevaluacion tipo="2">
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" align="right">
							Empleado:
						</td>
						<td>
							<cf_rhempleadoscap>
						</td>
					</tr>					
					<tr>
						<td colspan="2">
							<table width="100%">
								<tr>
									<td><input type="radio" name="radio1" value="0" id="radio1" checked="checked" />Resumido</td>
									<td><input type="radio" name="radio1" value="1" id="radio1"/>Detallado</td>
									<td><input type="radio" name="radio1" value="2" id="radio1"/>Mostrar Observaciones</td>
								</tr>
							</table>
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

<script language="javascript">
	function Validar(f){
		if (!btnSelected('Limpiar',f)){
		var error_input;
		var error_msg = '';
		
		if (f.RHEEid.value == "") {
		error_msg += "\n - Debe seleccionar una evaluación";
		error_input = f.RHEEid;
		}	
		if (f.radio1.value==1)
		{
		alert(f.radio1.value)
			if (f.DEid.value==''){
			error_msg += "\n - Debe seleccionar un empleado";
			error_input = f.DEid.value;
			}
		}
		
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
		return true;
	}}
</script>