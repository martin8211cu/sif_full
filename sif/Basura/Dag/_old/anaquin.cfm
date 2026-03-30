<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Anaquin Test</title>
</head>

<body>
<cfset session.dsn = 'posv6'>
<cfset session.ecodigo = 195>
<cfinvoke component="anaquin" method="doit" returnvariable="what" caja="2" fecha="#now()#" debug="true">
<cfif Not what><cfdump var="#what#"></cfif>
</body>
</html>
