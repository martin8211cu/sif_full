<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Informaci&oacute;n Adicional de Control de Tiempos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body onUnload="javascript:info_close();" onLoad="info_open();">
<style type="text/css">
.flat, .flattd input {
	border:1px solid gray;
}
</style>

<form name="form1" method="post">
<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
<tr><td></td></tr>
<tr><td align="center">
	<table width="98%" cellpadding="0" cellspacing="0" border="0" >
		<tr>
			<td align="left"><strong><font size="2">Datos adicionales de Control de Tiempos</font></strong></td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr><td align="left"><strong><font size="1">Observaciones</font></strong></td></tr>
		<tr>
			<td align="left"><textarea class="flat" style=" width:100%" name="observaciones" rows="20" onFocus="this.select();" ></textarea></td><!--- Si se envió el parámetro de sololectura aplica la propiedad de readOnly ---->
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr><td><input type="button" style=" font-size:11px" name="Cerrar" value="Cerrar" onClick="javascript:info_close();"></td></tr>

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
	function info_open(){
		document.form1.observaciones.value = window.opener.document.form1.CTTobs_#url.cual#.value;	
	}

	function info_close(){
		window.opener.document.form1.CTTobs_#url.cual#.value = document.form1.observaciones.value;
		
		if( window.opener.document.form1.CTTobs_#url.cual#.value != '' ){
			window.opener.document.getElementById('imagen_#cual#').src = 'iedit.gif';
		}
		else{
			window.opener.document.getElementById('imagen_#cual#').src = 'noedit.gif';
		}
		
		
		window.close();
	}
	</cfoutput>
//-->
</script>

<!--- 			window.opener.document.getElementById('imagen_#cual#').src = 'iedit.gif' --->