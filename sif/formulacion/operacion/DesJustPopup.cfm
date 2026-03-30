<cfparam name="url.titulo" 	default="Descripción">
<cfparam name="url.form" 	default="form1">
<cfparam name="url.name" 	default="DPDEdescripcion_ALL">
<cfparam name="url.value" 	default="">
 
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
			<td align="left"><strong><font size="2"><cfoutput>#url.titulo#</cfoutput></font></strong></td>
		</tr>
		<cfif not isdefined("url.sololectura")> <!---- Si se NO se envia por URL el parametro solo lectura SE imprime el mensaje ----->
			<tr><td><font size="1">Digite aquí la <cfoutput>#url.titulo#</cfoutput>.</font></td></tr>
		</cfif>
		<tr><td>&nbsp;</td></tr>
		
		<tr>
			<td align="left"><textarea name="msg" onKeyDown="cantidadCaracteresPermitidos(2000)" onKeyUp="cantidadCaracteresPermitidos(2000)" style="width:100%" rows="8" <cfif isdefined("url.sololectura")>readonly</cfif>></textarea></td><!--- Si se envió el parámetro de sololectura aplica la propiedad de readOnly ---->
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr><td align="center">
		<cfif not isdefined("url.sololectura")>
			<input type="button" class="btnGuardar" name="Aceptar" value="Aceptar" onClick="javascript:info();">
		</cfif>
			<input type="button" class="btnNormal" value="Cerrar" onClick="javascript:window.close();">
		</td></tr>
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
	<cfif len(trim(url.value)) gt 0>
		document.form1.msg.value = "#url.value#";
	<cfelse>
		document.form1.msg.value = window.opener.document.#url.form#.#url.name#.value;
	</cfif>

	document.form1.msg.focus();
	function info(){
		window.opener.document.#url.form#.#url.name#.value = document.form1.msg.value;
		window.close();
	}
	
	function cantidadCaracteresPermitidos(num){
		if(document.form1.msg.value.length > num){   
			document.form1.msg.value = document.form1.msg.value.substr(0,num);
			return false;
		}
	}

	</cfoutput>
//-->
</script>
