<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>Untitled Document</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	</head>
	<body>
		<form name="requisicion">
			<table width="100%">
				<tr><td><cf_sifarticulos form="requisicion" Almacen="500000000000037" ></td></tr>
			</table>
			<input type="button" name="ver" value="ver" onClick="fver()">
		</form>
		<script language="javascript1.2" type="text/javascript">
			function fver(){
				alert(document.requisicion.Aid.value + ' - ' + document.requisicion.Acodigo.value + ' - ' + document.requisicion.Adescripcion.value)
			}
		</script>
	</body>
</html>