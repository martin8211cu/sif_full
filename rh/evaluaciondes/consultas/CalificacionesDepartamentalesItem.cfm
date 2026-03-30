<cf_templateheader title="Evaluaci&oacute;n de Cuestionarios"> 

 <cf_web_portlet_start border="true" titulo="Evaluaci&oacute;n de Cuestionarios" skin="#Session.Preferences.Skin#">
 	<form name="form1" method="post" action="CalificacionesDepartamentalesItem-rep.cfm" onsubmit="return Validar(this);"><!---CalificacionesDepartamentalesItem-rep.cfm--->
 	<table>
		<tr>
			<td width="50%">
				<cf_web_portlet_start border="true" titulo="Reporte Evaluaci&oacute;n por Item - Evaluaci&oacute;n del Desempe&ntilde;o" skin="info1">
					<div align="justify">
						<p>Este reporte muestra las respuestas por items y sus ponderaciones realizadas en una determinada evaluci&oacute;n del desempe&ntilde;o</p>
					</div>
				<cf_web_portlet_end>
			</td>
			<td width="50%">
				<table border="0" width="100%">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="right">
							Evaluaci&oacute;n:
						</td>
						<td>
							<cf_rhevaluacion tipo="2"><!------>
						</td>
					</tr>
					<!---<tr>
						<td nowrap="nowrap" align="right">
							Empleado:
						</td>
						<td>
							<cf_rhempleadoscap>
						</td>
					</tr>--->
					<tr>
						<td nowrap="nowrap" align="right">
							Centro Funcional:
						</td>
						<td>
							<cf_rhcfuncional id="CFid" name="CFid" tabindex="1">
						</td>
					</tr>
					<tr>
						<td >&nbsp;</td>
						<td >
							<input 	type="checkbox" 
									name="chkDep" 
									value="" 
									id="chkDep"><label for=chkDep style="font-style:normal; font-variant:normal; font-weight:normal"><cf_translate  key="LB_IncluirDependencias">Incluir dependencias</cf_translate></label>
						</td>									
					</tr>
					<tr>
						<td colspan="2">
							<table width="60%" align="center">
								<tr>
									<td><input type="radio" name="radio1" value="0" id="radio1" checked="checked" />Autoevaluci&oacute;n</td>
									<td><input type="radio" name="radio1" value="1" id="radio1"/>Jefaturas</td>
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
		
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
		return true;
	}}
</script>