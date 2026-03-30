<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<script language="javascript" type="text/javascript">
	function funcAnterior(){
		return confirm('Continuar c/ Anterior ?');
	}
	function funcSiguiente(){
		return confirm('Continuar c/ Siguiente ?');
	}
</script>

<cfdump var="#Form#">

<form action="" method="post" name="form1">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td><h1>cf_botones</h1></td>
  </tr>
   <tr>
	<td><cf_botones include="Siguiente" exclude="Baja" modo="CAMBIO"></td>
  </tr>
</table>
</form>
</body>
</html>
