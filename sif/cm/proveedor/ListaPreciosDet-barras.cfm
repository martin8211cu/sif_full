<cfparam name="url.titulo" default="Detalle de Lista de Precios">
<cfparam name="url.form" default="form1">
<cfparam name="url.codigobarras" default="DLPcodbarras">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Informaci&oacute;n Adicional de la <cfoutput>#url.titulo#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>
<form name="form1" method="post" style="margin: 0; ">
<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
	<tr><td></td></tr>
	<tr>
		<td align="center">
			<table width="98%" cellpadding="0" cellspacing="0" border="0" >
				<tr><td align="left"><strong><font size="2">Registro de c&oacute;digo de barras para el <cfoutput>#url.titulo#</cfoutput></font></strong></td></tr>
				<tr><td><font size="1">Digite aqu&iacute; el c&oacute;digo de barras que quiera agregar a la <cfoutput>#url.titulo#</cfoutput>.</font></td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td align="left"><strong><font size="1">C&oacute;digo de Barras:</font></strong>&nbsp;<input type="text" name="codigobarras" value="" size="40" maxlength="30"></td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td><input type="button" style=" font-size:11px" name="Aceptar" value="Aceptar" onClick="javascript:info();"></td></tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>

<script type="text/javascript" language="javascript1.2">
	<cfoutput>
		<!---Poner a código javascript --->
		document.form1.codigobarras.value = window.opener.document.#url.form#.#url.codigobarras#.value;

		function info(){
			window.opener.document.#url.form#.#url.codigobarras#.value = document.form1.codigobarras.value;
			window.close();
		}
	</cfoutput>
</script>
