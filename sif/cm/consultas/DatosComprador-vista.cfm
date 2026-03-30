<html>
<head>
<title>Datos del Comprador</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cf_rhimprime datos="/sif/cm/consultas/DatosComprador-vistaForm.cfm" paramsuri="&CMCid=#url.CMCid#"> 
<cfset title = "Datos del Comprador">
<cfinclude template="DatosComprador-vistaForm.cfm">
<form name="form1">
	<cf_botones values="Cerrar" functions="window.close();">
</form>
<cfset title = "Compradores">
</body>
</html>			
