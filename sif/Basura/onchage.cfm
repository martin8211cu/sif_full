<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<form name="form1" method="post" action="">
  <label>OnChangeTest
  <input type="text" name="textfield" onChange="javascript:document.form1.textfield.value='';">
  <input type="submit" name="Submit" value="Button" onClick="javascript:document.form1.textfield.value='Hola Mundo!';document.form1.textfield.onchange();return false;">
</label>
</form>
</body>
</html>
