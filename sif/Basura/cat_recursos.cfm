<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Catálogo de Recursos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<form name="form1" method="post" action="">
  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
    <tr>
      <th scope="row">&nbsp;</th>
      <td><input type="text" name="txt_id"></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <th scope="row">&nbsp;</th>
      <td><input type="text" name="txt_fname"></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <th scope="row">&nbsp;</th>
      <td><input type="text" name="txt_lname"></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <th scope="row">&nbsp;</th>
      <td><input type="button" name="but_Ir" value="Ir"></td>
      <td>&nbsp;</td>
    </tr>
  </table>
</form>
</body>
</html>
<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--// //poner a código javascript 
	var form = document.form1;
	form.txt_id.value="1-2345-6789";
	form.txt_fname.value="Juan";
	form.txt_lname.value="Peres";
	//incluye qforms en la página
	// Qforms. especifica la ruta donde el directorio "/qforms/" está localizado
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// Qforms. carga todas las librerías por defecto
	qFormAPI.include("*");
	//inicializa qforms en la página
	qFormAPI.errorColor = "#FFFFCC";
	//FormTransferir
	obj= new qForm("form1");
	obj.txt_id.addEvent("onblur", "	alert(this.value);", true);//true lo pone al final de las instrucciones existentes del evento, false al inicio;
	obj.but_Ir.addEvent("onclick", "	obj.txt_id.obj.focus();obj.txt_fname.obj.focus();", true);//true lo pone al final de las instrucciones existentes del evento, false al inicio;
	//-->
</script>