<cfparam name="lvarSolicitante" default="false">
<html>
<head>
<title>Cotizaci&oacute;n</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cf_rhimprime datos="/sif/cm/operacion/compraProceso-importcoti-vistaform.cfm" paramsuri="&CMPid=#url.CMPid#&ECid=#url.ECid#&"> 
<cfinclude template="compraProceso-importcoti-vistaform.cfm">
<form name="form1">
<cf_botones values="Cerrar" functions="window.close();">
</form>
</body>
</html>