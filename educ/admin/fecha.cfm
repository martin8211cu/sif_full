<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language="javascript">
function domSelectionStart(e,o)
{
	if (document.selection)
	{
		var LvarRan = document.selection.createRange();
		var LvarLon = LvarRan.moveStart(-1,"textedit");
		LvarLon = LvarRan.text.length;
	}
}
function xx(e,o)
{	var s = document.selection.createRange();
	
}

</script>
</head>

<body bgcolor="#00FFFF">
<form name="frmFecha">
<span style="
	border:2px inset; 
	font-size:14px; 
	background-color:#FFFFFF;
	"><input name=""  style="font-size:14px;border:none;margin:none;padding:none; width:14px;" type="text" value="01" maxlength="2">/<input name=""  style="font-size:14px;border:none;margin:none;padding:none; width:14px;" type="text" value="01" maxlength="2">/<input name=""  style="font-size:14px;border:none;margin:none;padding:none; width:28px;" type="text" value="2004" maxlength="4"></span>
hola
<input name=""  type="text" value="01/01/2004" size="100%" onKeyUp="xx(event,this);" onPrueba="fnPrueba();"><br>
**<cf_sifcalendario name="PMfinal" value="01/01/2000" form="frmFecha">**
<input type="submit">
</form>
</body>
</html>
