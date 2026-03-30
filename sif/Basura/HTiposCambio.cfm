<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Untitled Document</title>
<cfquery name="htiposcambio" datasource="minisif">
	select * from Htipocambio a
	where Ecodigo = 1
	and Hfecha = (
		select max(Hfecha) from Htipocambio where Ecodigo = a.Ecodigo
		and Hfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"><!--- CreateDate(2004,6,7) --->
	)
</cfquery>
</head>
<body>
<cfdump var="#htiposcambio#">
</body>
</html>
