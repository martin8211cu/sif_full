<cfparam name="url.titulo" default="Solicitud de Compra">
<cfparam name="url.form" default="form1">
<cfparam name="url.ver" default="NO">
<cfparam name="url.descalterna" default="DSdescalterna">
<cfparam name="url.observaciones" default="DSobservacion">
<cfparam name="url.index" default="">
 
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Informaci&oacute;n Adicional de <cfoutput>#url.titulo#</cfoutput></title>
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
			<td align="left"><strong><font size="2">Datos adicionales de la <cfoutput>#url.titulo#</cfoutput></font></strong></td>
		</tr>
		<cfif not isdefined("url.sololectura")> <!---- Si se NO se envia por URL el parametro solo lectura SE imprime el mensaje ----->
			<tr><td><font size="1">Digite aqu&iacute; la descripci&oacute;n alterna y las observaciones que quiera agregar a la <cfoutput>#url.titulo#</cfoutput>.</font></td></tr>
		</cfif>
		<tr><td>&nbsp;</td></tr>
		<tr><td align="left"><strong><font size="1">Descripci&oacute;n Alterna (M&aacute;ximo 255 Caracteres)</font></strong></td></tr>
		<tr>
			<td align="left"><textarea style="width:100%" name="alterna" rows="8" onKeyUp="return maximaLongitud(this,254)"<cfif isdefined("url.sololectura")>readonly</cfif>></textarea></td><!--- Si se envió el parámetro de sololectura aplica la propiedad de readOnly ---->
		</tr>

		<tr>
			<td align="left"><strong><font size="1">Observaciones (M&aacute;ximo 255 Caracteres)</font></strong></td>
		</tr>
		<tr>
			<td align="left"><textarea style="width:100%" name="observaciones" rows="8" onKeyUp="return maximaLongitud(this,254)"<cfif isdefined("url.sololectura")>readonly</cfif>></textarea></td><!--- Si se envió el parámetro de sololectura aplica la propiedad de readOnly ---->
		</tr>

		<tr><td>&nbsp;</td></tr>
		<cfif isdefined('url.ver') and url.ver EQ 'NO'>
			<tr><td>			
				<input type="button" style=" font-size:11px" name="Aceptar" value="Aceptar" onClick="javascript:info();">
			</td></tr>				
		</cfif>
		<tr><td>&nbsp;</td></tr>
	</table>
</td></tr>
</table>
</form>
</body>
</html>
<script type="text/javascript" language="javascript1.2">
<!--// //poner a código javascript 
	<cfoutput>
	document.form1.observaciones.value = window.opener.document.#url.form#.#url.observaciones##url.index#.value;
	document.form1.alterna.value = window.opener.document.#url.form#.#url.descalterna##url.index#.value;

	function info(){
		window.opener.document.#url.form#.#url.observaciones##url.index#.value = document.form1.observaciones.value;
		window.opener.document.#url.form#.#url.descalterna##url.index#.value = document.form1.alterna.value;
		window.close();
	}
	</cfoutput>
	
	function maximaLongitud(texto,maxlong) {
	var tecla, in_value, out_value;
		if (texto.value.length > maxlong) {
			in_value = texto.value;
			out_value = in_value.substring(0,maxlong);
			texto.value = out_value;
			return false;
		}
		return true;
	}
//-->
</script>