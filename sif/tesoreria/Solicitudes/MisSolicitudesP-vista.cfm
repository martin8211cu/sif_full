<html>
<head>
<title>Solicitudes</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<cfset title = "Solicitudes de Compra">

<cfoutput>
<form name="form1" method="get">
	<cfif isdefined("url.btnCancelaciones")>
		<cf_rhimprime datos="/sif/cm/consultas/MisSolicitudesCanceladas-vistaForm.cfm" paramsuri="&ESidsolicitud=#url.ESidsolicitud#&ESestado=#url.ESestado#"> 
		<cfinclude template="MisSolicitudesCanceladas-vistaForm.cfm">
		<cf_botones values="Atrás,Cerrar" functions="history.back();,window.close();">
	<cfelse>
		<cf_rhimprime datos="/sif/cm/consultas/MisSolicitudes-vistaForm.cfm" paramsuri="&ESidsolicitud=#url.ESidsolicitud#&ESestado=#url.ESestado#"> 
		<cfinclude template="MisSolicitudes-vistaForm.cfm">
		<cf_botones values="Cerrar,Cancelaciones" functions="window.close();">
	</cfif>
	<input type="hidden" name="ESidsolicitud" value="#url.ESidsolicitud#">
	<input type="hidden" name="ESestado" value="#url.ESestado#">
</form>
</cfoutput>

<cfset title = "Compras">
</body>
</html>