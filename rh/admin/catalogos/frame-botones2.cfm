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
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcValidar();">
			<img src="/cfmx/rh/imagenes/iedit.gif" border="0" align="top" hspace="2"><font size="+2">&nbsp;<cf_translate key="LB_ValidarCalculo">Validar c&aacute;lculo</cf_translate></font>
		</td>
		<td>|</td>
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcGuardar();">
			<img src="/cfmx/rh/imagenes/Cfinclude.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_Guardar">Guardar</cf_translate></font>
		</td>
		<td>|</td>
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcRestablecer();">
			<img src="/cfmx/rh/imagenes/undo.small.png" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_RestablecerCalculos">Restablecer c&aacute;lculos</cf_translate></font>
		</td>
		<td>|</td>
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return helpWindow();">
			<img src="/cfmx/rh/imagenes/question.gif" border="0" align="top" hspace="2"><font size="+2"><cf_translate key="LB_AyudaParaElCalculo">Ayuda para el c&aacute;lculo</cf_translate></font>
		</td>
	</tr>
</table>
