<cf_templateheader title="Evaluación de Cuestionarios"> 

 <cf_web_portlet_start border="true" titulo="Resultados de una Encuesta o Evaluación" skin="#Session.Preferences.Skin#">
 	<form name="form1" method="post" action="resultadoencuesta-reporte.cfm" onsubmit="return Validar(this);">
 	<table>
		<tr>
			<td width="50%">
				<cf_web_portlet_start border="true" titulo="Resultados de una Encuesta o Evaluación" skin="info1">
					<div align="justify">
						<p>Este reporte muestra  los resultados obtenidos en una encuesta realizada, ya sea por ítem para preguntas de opción variable preguntas abiertas</p>
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
							<cf_rhevaluacion >
						</td>
					</tr>
					<tr><td colspan="3"></td>
                    
<!---						<td nowrap="nowrap" align="right">
							Empleado:
						</td>
						<td>
							<cf_rhempleadoscap>
						</td>
--->					</tr>					
					<tr>
						<td colspan="2">
							<table width="100%">
								<tr>
									<td><input type="radio" name="radio1" value="0" id="radio1" checked="checked" />Todo</td>
									<td><input type="radio" name="radio1" value="1" id="radio1"/>Preguntas de Respuesta Variable</td>
									<td><input type="radio" name="radio1" value="2" id="radio1"/>Preguntas Abiertas</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td align="center" colspan="2">
						<!---	<input type="checkbox" name="omiteAutoE" /> Omitir Autoevaluación--->
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
		//if (f.radio1.value==1)
//		{
//			if (f.DEid.value==''){
//			error_msg += "\n - Debe seleccionar un empleado";
//			error_input = f.DEid.value;
//			}
//		}
		
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
		return true;
	}}
</script>