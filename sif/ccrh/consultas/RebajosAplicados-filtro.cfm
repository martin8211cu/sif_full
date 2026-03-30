<form style="margin:0 " name="filtro" method="post" action="" onSubmit="return validar();" >
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="right" width="25%"><strong>Calendario de Pago:&nbsp;</strong></td>
			<td><cf_rhcalendariopagos form="filtro" historicos="true" tcodigo="true"></td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<input type="submit" name="Consultar" value="Consultar">
				<input type="reset" name="Limpiar" value="Limpiar">
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
	</table>
</form>
<script type="text/javascript" language="javascript1.2">
	function validar(){
		if ( document.filtro.CPid.value == '' ){
			alert('Se presentaron los siguientes errores:\n - El Campo Calendario de Pago es requerido.');
			return false;
		}
		return true;
	}
</script>