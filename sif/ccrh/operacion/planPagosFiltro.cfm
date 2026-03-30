<cf_templateheader title="Lista de Planes de Pago">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Lista de Planes de Pago por Empleado'>
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<table border="0" width="100%" cellpadding="4" cellspacing="0">
			<tr>
				<td valign="top">
					<cf_web_portlet_start border="true" titulo="Modificaci&oacute;n del Plan de Pagos" skin="info1">
						<table width="95%" align="center">
							Para trabajar con un plan de pagos debe seleccionar:<br>
							<li>El empleado al que quiere modificar su plan de pagos.</li><br>
							<li>El tipo de deducci&oacute;n asociado al plan de pagos.</li><br><br>
							
							Una vez seleccionados estos datos se mostrar&aacute; la lista de planes de pago relacionados a estos datos.<br><br>
						</table>
					<cf_web_portlet_end><br><br>
				</td>
				<td align="center" valign="top">
					<form name="form1" method="post" style="margin: 0;" action="listaPlanPagos.cfm" onSubmit="return validar();" >
						<table border="0" align="center" width="99%" cellpadding="3" cellspacing="0" >
							<tr>
								<td width="37%" align="right" ><strong>Empleado:&nbsp;</strong></td>
								<td><cf_rhempleado tabindex="1" size = "50"></td>
							</tr>
							<tr>
								<td align="right"  ><strong>Deducci&oacute;n:&nbsp;</strong></td>
								<td><cf_rhtipodeduccion size="50" validate="1" financiada="1" tabindex="1"></td>
							</tr>
							<tr>
								<td colspan="2" align="center"><input type="submit" name="Filtrar" value="Aceptar"></td>
							</tr>
							<tr><td>&nbsp;</td></tr>
						</table>
					</form>
				</td>	
			</tr>	
			<tr><td>&nbsp;</td></tr>
		</table>	
		
		<script type="text/javascript" language="javascript1.2">
			function validar(){
				var error = false;
				var mensaje = 'Se presentaron los siguientes errores:\n';
				if ( document.form1.DEid.value == '' ){
					error = true;
					mensaje += ' - El campo Empleado es requerido.\n';
				}
				if ( document.form1.TDid.value == '' ){
					error = true;
					mensaje += ' - El campo Tipo de Deducción es requerido.\n';
				}
				if (error){
					alert(mensaje);
					return false
				}
				return true;
			}
		</script>
	<cf_web_portlet_end>
<cf_templatefooter>