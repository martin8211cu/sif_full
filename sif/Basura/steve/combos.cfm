<cfinvoke component="cmMisFunciones" 
	returnvariable="rs" 
	method="fnVerMonedas">
	<cfinvokeargument name="top" value="5">
</cfinvoke>

<script language="javascript1.2" type="text/javascript">
	function fnMostrarDatos(valor) {
		var fr = document.getElementById("miFrame");
		fr.src = "combosQuery.cfm?nombre="+valor;
	}

	function fnLimpiarCampos() {
		var n = document.miForm.elements;
		for (i=1;i<=n.length;i++) {
			if (n[i].type == "text") {
				n[i].value = "";
			}
		}
	}
</script>

<form name="miForm" action="combos.cfm" method="post">
	<select name="miCombo" id="miCombo" onChange="javascript:fnMostrarDatos(this.value)">
		<cfoutput query="rs">
			<option value="#rs.Mnombre#">#rs.Mnombre#</option>
		</cfoutput>
	</select>
	<input name="btnLimpiar" type="reset" value="Limpiar" onClick="javascript:fnLimpiarCampos()">
	<br><br>
	<input name="miTexto" type="text" value="" maxlength="60">
	<input name="miTexto2" type="text" value="" maxlength="5">
	<input name="miTexto3" type="text" value="" maxlength="5">	
</form>

<table border="1" width="50%">	
	<tr>
		<td><cf_web_portlet titulo='Monedas'/>
		<cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
			tabla="CtasMayor" 
			conexion="minisif"
			columnas="Cmayor, Cdescripcion"
			desplegar="Cmayor, Cdescripcion"
			etiquetas="Cuenta, Descripción"
			formatos=""
			filtro=""
			align="left,left"
			checkboxes="N"
			keys="Cmayor"
			ira="combosQuery.cfm">
		</cfinvoke>
		</td>
	</tr>
</table>	

<iframe name="miFrame" id="miFrame" src="" frameborder="0" height="0" width="0"></iframe>