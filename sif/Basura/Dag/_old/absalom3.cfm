<cfinclude template="../../Application.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Prueba de Componente de Revalución de Cuentas</title>
</head>

<body>

<cfset qry = QueryNew("to")>
<cfset QueryAddRow(qry,4)>
<cfset QuerySetCell(qry,"to","anav@soin.co.cr",1)>
<cfset QuerySetCell(qry,"to","dabarca@soin.co.cr",2)>
<cfset QuerySetCell(qry,"to","andreag@soin.co.cr",3)>
<cfset QuerySetCell(qry,"to","marcelm@soin.co.cr",4)>
<cfmail from="anav@soin.co.cr" query="qry" 
	to="#to#" subject="Prueba de correo"
	>
		Esta es una Prueba de Correo!
</cfmail>
	
</body>
</html>
