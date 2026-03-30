<script language="javascript" type="text/javascript">
	function buttonOver(obj) {
		obj.className="botonDown";
	}

	function buttonOut(obj) {
		obj.className="botonUp";
	}
	
</script>

<table border="0" cellpadding="2" cellspacing="0" style="height: 24px; ">
	<tr>
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcGuardarContinuar();">
			<img src="../imagenes/savego.gif" border="0" align="top" hspace="2">Guardar y Continuar
		</td>
		<td>|</td>
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcGuardarNuevo();">
			<img src="../imagenes/save.gif" border="0" align="top" hspace="2">Guardar y Agregar Otro
		</td>
		<td>|</td>
		<cfif modo EQ "CAMBIO">
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcEliminar();">
			<img src="../imagenes/delete.gif" border="0" align="top" hspace="2">Eliminar
		</td>
		<td>|</td>
		</cfif><!--- Cambio --->
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcCancelar();">
			<img src="../imagenes/cancel.gif" border="0" align="top" hspace="2">Cancelar
		</td>
	</tr>
</table>
