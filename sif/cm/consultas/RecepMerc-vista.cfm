<html>
<head>
<title>Recepci&oacute;n</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cf_rhimprime datos="/sif/cm/consultas/RecepMerc-vistaForm.cfm" paramsuri="&EDRid=#url.EDRid#"> 
<cfset title = "Recepci&oacute;n de Mercader&iacute;a">

<form name="form1">
<cfinclude template="RecepMerc-vistaForm.cfm">
	<cf_botones values="Cerrar" functions="window.close();">
</form>
<cfset title = "Compras">
</body>
</html>