<html>
<head>
<title>Informaci&oacute;n del Rol</title>
<link href="../sec.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
	function fn(controlname, valor) {
		window.opener.document.form2.rolinfo.value = new String(valor);
		window.close();
	}
</script>
</head>
<body>

<form name="formInfo" action="javascript:fn('rolinfo',document.formInfo.rolinfo.value)" method="post">
<table class="contenido">
	<tr>
		<td style="text-align: center;">
		Digite el texto que aparecer&aacute; en la carta de afiliaci&oacute;n
		para los usuarios con este rol.
		Utilice una l&iacute;nea por cada funci&oacute;n que el usuario pueda realizar dentro del portal, 
		cada una de estas l&iacute;neas aparecer&aacute; en un p&aacute;rrafo separado en la carta.
		</td>
	</tr>
	<tr>
		<td style="text-align: center;">
		<textarea name="rolinfo" rows="10" cols="60"></textarea>
		</td>
	</tr>
	<tr>
		<td style="text-align: center;">
		<input type="submit" name="btnAceptar" value="Aceptar">
		<input type="button" name="btnCancelar" value="Cancelar"
		 onClick="javascript: window.close();">
		<input type="button" name="btnVer" value="Vistar preliminar"
		 onClick="javascript: vistaPreliminar();">
		</td>
	</tr>
	<tr><td><hr></td></tr>
	<tr style="display: none;"><td id="tdVista"></td></tr>
</table>
</form>
<script type="text/javascript">
	if (window.opener.document.form2.rolinfo.value == "") {
		formInfo.rolinfo.value = "Escriba la informacion del rol";
		formInfo.rolinfo.select();
	} else {
		formInfo.rolinfo.value = window.opener.document.form2.rolinfo.value;
	}
	formInfo.rolinfo.focus();
	
	function vistaPreliminar() {
		var td = document.getElementById("tdVista");
		lineas = formInfo.rolinfo.value.split('\n');
		
		// borrar contenido actual
		while (td.hasChildNodes()) {
			td.removeChild(td.firstChild);
		}
		
		// colocar contenido
		var ul = document.createElement("UL");
		for (var i = 0; i < lineas.length; i++) {
			var li = document.createElement("LI");
			var texto = document.createTextNode(lineas[i]);
			li.appendChild(texto);
			ul.appendChild(li);
		}
		td.appendChild(ul);
		td.parentNode.style.display = "";
	}
</script>
</body>
</html>
