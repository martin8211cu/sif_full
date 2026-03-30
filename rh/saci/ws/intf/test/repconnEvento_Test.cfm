<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Prueba del repconnEvento.cfc</title>
</head>

<body>
<cfparam name="form.evento" default="">
<cfoutput>
<cfif Len(form.evento)>
	<cfinvoke component="saci.ws.intf.repconnEvento" method="repconnEvento" evento="#form.evento#" returnvariable="xxx"/>
	
	<cfif IsDefined('request.errmsg')>
	<div style="color:red; font-weight:bold">
	#request.errmsg#
	</div>
	</cfif>
</cfif>
<form action="" method="post" name="form1"><table border="1" cellspacing="0" cellpadding="2">
  <tr>
    <td>Prueba del repconnEvento </td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">Evento</td>
    <td><textarea name="evento" id="evento" rows="10" cols="50" style="font-family:Georgia, 'Times New Roman', Times, serif">#HTMLEditFormat( form.evento )#</textarea></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input type="submit" name="Submit" value="Submit" />
	<input type="button" value="Quitar comillas dobles" onclick="quitarDobles()" /></td>
    <td>&nbsp;</td>
  </tr>
</table>
</form>
<script type="text/javascript">
<!--
function quitarDobles(){
	document.form1.evento.value = document.form1.evento.value.replace(/""/g, '"');
}
//-->
</script>
</cfoutput>
</body>
</html>
