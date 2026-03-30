<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Informaci&oacute;n Adicional de Cotizaciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>
<form name="form1" method="post" style="margin:0;">
<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
<tr><td>&nbsp;</td></tr>
<tr><td align="center">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" >
		<tr>
			<td align="left"><strong><font size="2">Registro de datos adicionales para la Cotizaci&oacute;n</font></strong></td>
		</tr>
		<tr><td align="left"><font size="1">Digite aqu&iacute; las observaciones que quiera agregar a la Cotizaci&oacute;n.</font></td></tr>
		<tr><td>&nbsp;</td></tr>

		<tr>
			<td align="left"><strong><font size="1">Observaciones</font></strong></td>
		</tr>
		<tr>
			<td align="left"><textarea style=" width:100%" name="observaciones" rows="8" ></textarea></td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr><td><input type="button" style=" font-size:11px" name="Aceptar" value="Aceptar" onClick="javascript:updinfo();"></td></tr>

		<tr><td>&nbsp;</td></tr>
	</table>
</td></tr>
</table>
</form>
</body>
</html>
<script type="text/javascript" language="javascript1.2">
	document.form1.observaciones.value = window.opener.document.form1.ECobsprov.value;
	document.form1.observaciones.focus();
	
	function updinfo(){
		window.opener.document.form1.ECobsprov.value = document.form1.observaciones.value;
		window.close();
	}
</script>
