<html>
<head>
<title>Datos del Comprador por Rango</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cf_rhimprime datos="/sif/cm/consultas/DatosCompradorRango-Reporte.cfm" paramsuri="&CMCcodigo1=#url.CMCcodigo1#&CMCcodigo2=#url.CMCcodigo2#"> 
<cfset title = "Datos del Comprador por Rango">
<cfinclude template="DatosCompradorRango-Reporte.cfm">
<form name="form1">
	<cf_botones values="Cerrar" functions="window.close();">
</form>
<cfset title = "Compradores">
</body>
</html>			

