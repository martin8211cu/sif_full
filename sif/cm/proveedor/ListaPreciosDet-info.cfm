<cfparam name="url.titulo" default="Detalle de Lista de Precios">
<cfparam name="url.form" default="form1">
<cfparam name="url.descalterna" default="DLPdescalterna">
<cfparam name="url.observaciones" default="DLPobservaciones">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Informaci&oacute;n Adicional del <cfoutput>#url.titulo#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>
<form name="form1" method="post" style="margin: 0; ">
<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
<tr><td></td></tr>
<tr><td align="center">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" >
		<tr><td align="left"><strong><font size="2">Registro de datos adicionales para la el <cfoutput>#url.titulo#</cfoutput></font></strong></td></tr>
		<tr>
		  <td><font size="1">Digite aqu&iacute; la descripci&oacute;n alterna y Observaciones que quiera agregar al <cfoutput>#url.titulo#</cfoutput>.</font></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td align="left"><strong><font size="1">Descripci&oacute;n Alterna</font></strong></td></tr>
		<tr><td align="left"><textarea style=" width:100%" name="alterna" rows="10" ></textarea></td></tr>
		<tr><td align="left"><strong><font size="1">Observaciones</font></strong></td></tr>
		<tr><td align="left"><textarea style=" width:100%" name="observaciones" rows="8" ></textarea></td></tr>
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
	<cfoutput>
		<!--- Poner a código javascript --->
		document.form1.alterna.value = window.opener.document.#url.form#.#url.descalterna#.value;
		document.form1.observaciones.value = window.opener.document.#url.form#.#url.observaciones#.value;
	
		function info(){
			window.opener.document.#url.form#.#url.descalterna#.value = document.form1.alterna.value;
			window.opener.document.#url.form#.#url.observaciones#.value = document.form1.observaciones.value;
			window.close();
		}
	</cfoutput>
</script>
