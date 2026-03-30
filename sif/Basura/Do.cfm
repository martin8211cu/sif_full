<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Untitled Document</title>
<script language="javascript" type="text/javascript">
	function Do(number){
		f = document.form1;
		c = f.select1;
		for (i=1;i<c.length;i++){
			c.options[i].selected = false;
		}
		c.options[number].selected = true;
	}
</script>
</head>

<body>
<form action="" method="post" name="form1">
	<select name="select1">
		<option value="0">Uno</option>
		<option value="1">Dos</option>
		<option value="2">Tres</option>
	</select>
	<input name="subUno" type="button" value="Uno" onClick="javascrip:Do(0);">
	<input name="subDos" type="button" value="Dos" onClick="javascrip:Do(1);">
	<input name="subTres" type="button" value="Tres" onClick="javascrip:Do(2);">
</form>
</body>
</html>
