<script language="javascript" type="text/javascript">
	function buttonOver(obj) {
		obj.className="botonDown";
	}

	function buttonOut(obj) {
		obj.className="botonUp";
	}
	
	function funcGuardar() {
		document.form1.ACCION.value = "1";
		document.form1.submit();
	}

	function funcLista() {
		document.form1.ACCION.value = "2";
		document.form1.submit();
	}

	function funcCancelar() {
		location.href = '/cfmx/asp/index.cfm';
	}

</script>
	
<table border="0" cellpadding="2" cellspacing="0" style="height: 24px; ">
	<tr>
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcGuardar();">
			<img src="../imagenes/save.gif" border="0" align="top" hspace="2">&nbsp;Aceptar
		</td>
		<td>|</td>
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcLista();">
			<img src="../imagenes/users.gif" border="0" align="top" hspace="2">Ver lista de Usuarios
		</td>
		<td>|</td>
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcCancelar();">
			<img src="../imagenes/cancel.gif" border="0" align="top" hspace="2">Cancelar
		</td>
	</tr>
</table>
