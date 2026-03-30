<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Cancelar"
Default="Cancelar"
returnvariable="LB_Cancelar"/>

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
		<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: funcCancelar2();">
			<img src="/cfmx/rh/imagenes/cancel.gif" border="0" align="top" hspace="2"><cfoutput>#LB_Cancelar#</cfoutput>
		</td>
	</tr>
</table>
