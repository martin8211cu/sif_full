<html>
<head>
<title>Traslados de presupuesto</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<cfset title = "Traslados de presupuesto">

<cfoutput>
<form name="form1" method="get">
	<cfif isdefined("url.btnCancelaciones")>
<!---		<cf_rhimprime datos="/sif/presupuesto/consultas/MisSolicitudesCanceladas-vistaForm.cfm" paramsuri="&ESidsolicitud=#url.ESidsolicitud#&ESestado=#url.ESestado#"> 
		<cfinclude template="MisSolicitudesCanceladas-vistaForm.cfm">
		<cf_botones values="Atrás,Cerrar" functions="history.back();,window.close();">
--->	<cfelse>
		<cf_rhimprime datos="/sif/presupuesto/consultas/MisTraslados-vistaForm.cfm" paramsuri="&CPDEid=#url.CPDEid#">
		<cfinclude template="../consultas/MisSolicitudes-vistaForm.cfm">
		<cf_botones values="Cerrar,Cancelaciones" functions="window.close();">
	</cfif>
	<input type="hidden" name="ESidsolicitud" value="#url.CPDEid#">
</form>
</cfoutput>
</body>
</html>