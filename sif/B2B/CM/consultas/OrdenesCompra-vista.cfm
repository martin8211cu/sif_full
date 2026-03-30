<html>
<head>
<title>Ordenes de Compra</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfif isdefined("url.EOnumero") and len(url.EOnumero) and not isdefined("form.EOnumero")>
	<cf_rhimprime datos="/sif/B2B/CM/consultas/OrdenesCompra-vistaForm.cfm" paramsuri="&EOnumero=#url.EOnumero#"> 
<cfelse>
	<cf_rhimprime datos="/sif/B2B/CM/consultas/OrdenesCompra-vistaForm.cfm" paramsuri="&EOidorden=#url.EOidorden#"> 
</cfif>
<cfset title = "Orden de Compra">
<cfinclude template="AREA_HEADER.cfm">
<form name="form1">
	<cfinclude template="OrdenesCompra-vistaForm.cfm">
	<cf_botones values="Cerrar" functions="window.close();">
</form>
<cfset title = "Compras">
</body>
</html>
