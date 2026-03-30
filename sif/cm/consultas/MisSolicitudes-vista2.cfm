<html>
<head>
<title>Solicitudes</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cf_rhimprime datos="/sif/cm/consultas/MisSolicitudes-vistaForm.cfm" paramsuri="&ESidsolicitud=#url.ESidsolicitud#&ESestado=#url.ESestado#"> 
<cfset title = "Solicitudes de Compra">

<form name="form1">
	<cfinclude template="MisSolicitudes-vistaForm.cfm">
	<cf_botones values="Cerrar" functions="window.close();">
</form>
<cfset title = "Compras">
</body>
</html>