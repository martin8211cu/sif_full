
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Orden de Compra - Observaciones</title>
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
			<td align="left"><strong><font size="2">Descripción Alterna</font></strong></td>
		</tr>
		<tr>
			<td align="left"><textarea style=" width:100%" name="descalterna" rows="10" readonly></textarea></td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		
		<tr>
			<td align="left"><strong><font size="2">Observaciones</font></strong></td>
		</tr>
		<tr>
			<td align="left"><textarea style=" width:100%" name="observaciones" rows="10" readonly></textarea></td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="2" align="center"><input type="button" style=" font-size:11px" name="Cerrar" value="Cerrar" onClick="javascript:salir();"></td></tr>

		<tr><td>&nbsp;</td></tr>

	</table>
</td></tr>
</table>
</form>
</body>
</html>
<script type="text/javascript" language="javascript1.2">
	<cfoutput>
	document.form1.observaciones.value = window.opener.document.form2.DOobservaciones.value;
	document.form1.descalterna.value = window.opener.document.form2.DOalterna.value;
	function salir(){
		window.close();
	}
	</cfoutput>
</script>
