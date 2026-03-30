<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<form action="temp2.cfm" method="post" enctype="multipart/form-data" name="form1" >
<table>

<!---
	<tr><td colspan="2">CUENTA EMPRESARIAL</tr>
	<tr>
		<td><input type="file" name="logo"  onChange="document.getElementById('img_logo').src = this.value;" ></td>
		<td>
			<cf_leerimagen autosize="true" border="false" tabla="CuentaEmpresarial" campo="CElogo" condicion="CEcodigo = 15 " conexion="asp" imgname="img">
		</td>
	</tr>
--->

	<tr><td colspan="2">EMPRESA</tr>
	<tr>
		<td><input type="file" name="logo"  onChange="document.getElementById('img_logo').src = this.value;" ></td>
		<td>
			<cf_leerimagen autosize="true" border="false" tabla="Empresa" campo="Elogo" condicion="Ecodigo = 2 " conexion="asp" imgname="img">
		</td>
	</tr>

	<tr><td><input type="submit" value="submit" name="submit"></td></tr>
	
	
</table>
</form>

</body>
</html>

