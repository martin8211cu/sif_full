<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
<style type="text/css">
<!--
.style1 {
	font-size: 16px;
	font-weight: bold;
	color: #000099;
}
.style2 {
	color: #000099;
	font-size: 16;
}
-->
</style>
</head>

<body>
<cfoutput>
<form method="post" action="CrearLoginespso-apply.cfm">
<table border="1" cellspacing="0" cellpadding="2">
  <tr>
    <td colspan="2" bordercolor="##FFFFFF" bgcolor="##CCCCCC"><span class="style1">Creación de Logines en asp </span></td>
    <td width="4">&nbsp;</td>
  </tr>
  <tr>
    <td><span class="style1">Roles</span></td>
	<td><select name="rol">
					<option value="AGENTE" selected="selected">AGENTE</option>
					<option value="VENDEDOR">VENDEDOR</option>
					<option value="CLIENTE">CLIENTE</option>
					</select>	
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td class="style1" >Tipo de Generación</td>
    <td><select name="tipoGeneracion">
					<option  value="1">Enviar por Correo</option>
					<option  value="2" selected="selected">Clave igual a Usuario</option>
					</select>	
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td>&nbsp;</td>
    <td><input  name="enviar" type="submit" value="Crear Logines" /></td>
    <td>&nbsp;</td>
  </tr>
</table>
</form>
</cfoutput>
</body>
</html>
