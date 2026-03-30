<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Registro de Observaciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>
<form name="form1" method="post">
<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
<tr><td></td></tr>
<tr><td align="center">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" >
		<tr>
			<td align="left"><strong><font size="2">Observaciones</font></strong></td>
		</tr>
		<tr>
			<td align="left"><textarea style=" width:100%" name="observaciones" rows="22" ></textarea></td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr><td><input type="button" style=" font-size:11px" name="Aceptar" value="Aceptar" onClick="javascript:info();"></td></tr>

		<tr><td>&nbsp;</td></tr>
	</table>
</td></tr>
</table>
</form>
</body>
</html>
<script type="text/javascript" language="javascript1.2">
<!--// //poner a código javascript 
	document.form1.observaciones.value = window.opener.document.form1.Observaciones.value;

	function info(){
		window.opener.document.form1.Observaciones.value = document.form1.observaciones.value;
		window.close();
	}
//-->
</script>