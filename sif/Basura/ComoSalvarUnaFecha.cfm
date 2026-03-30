<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<cfset bd = 1>
<cfset creada = 2>
<cfset dedondeviene = creada>
<cfif dedondeviene eq bd>
	<cfquery name="rs" datasource="minisif">
		select sysdate as fecha from dual
	</cfquery>
<cfelse>
	<cfset rs = QueryNew("fecha")>
	<cfset temp = QueryAddRow(rs,1)>
	<cfset QuerySetCell(rs,'fecha',CreateDateTime(Year(Now()),Month(Now()),Day(Now()),00,00,00))>
</cfif>
<cfdump var="#rs#">
<cfquery datasource="minisif">
	update SNegocios
	set SNFecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rs.fecha#">
</cfquery>
</body>
</html>
