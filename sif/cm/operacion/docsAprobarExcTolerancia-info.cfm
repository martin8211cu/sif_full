<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Aprobación de Exceso de Tolerancia en Documentos de Recepción - Observaciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>
<cfoutput>
<form name="formObservaciones" method="post">
<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="98%" cellpadding="0" cellspacing="0" border="0" >
				<tr>
					<td align="left"><strong><font size="2">Observaciones</font></strong></td>
				</tr>
				<tr>
					<td align="left"><textarea style=" width:100%" name="Observaciones" rows="22" <cfif not url.guardar>readonly</cfif>></textarea></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td align="center"><input type="button" style=" font-size:11px" name="Aceptar" value="Aceptar" onClick="javascript:if(aceptar()){window.close();}"></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</cfoutput>
</body>
</html>

<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>

<script type="text/javascript" language="javascript1.2">
<!--// //poner a código javascript 
	<cfoutput>
		document.formObservaciones.Observaciones.value = window.opener.document.#url.nombreForm#.#url.nombreInput#.value;
		
		function aceptar()
		{
			<cfif url.guardar>
				if(trim(document.formObservaciones.Observaciones.value) == '')
				{
					alert('Debe escribir las observaciones');
					return false;
				}
				window.opener.document.#url.nombreForm#.#url.nombreInput#.value = document.formObservaciones.Observaciones.value;
			</cfif>
			return true;
		}
	</cfoutput>
//-->
</script>
