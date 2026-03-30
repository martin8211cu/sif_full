<html>
<head>
<title>Reclamos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cf_rhimprime datos="/sif/cm/consultas/ReclamosHistDet-imprime.cfm" paramsuri="&ERid=#url.ERid#">
<cfset title = "Datos del Reclamo">
<cfinclude template="AREA_HEADER.cfm">
<cfinclude template="ReclamosHistDet-imprime.cfm">
<form name="form1">
	<cf_botones values="Cerrar" functions="window.close();">
</form>
</body>
</html>			
