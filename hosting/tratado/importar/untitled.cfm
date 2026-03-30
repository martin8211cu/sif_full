<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<cfparam name="session.Ecodigo" type="numeric" default="1">
<cfquery name="xx" datasource="#session.dsn#">
	select *,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> from Empresas
</cfquery>

<cfdump var="#xx.getMetaData()#" expand="no">


<table border="1"><tr>

<cfloop from="1" to="#xx.getMetaData().getColumnCount()#" index="col">
	<cfoutput><td>#xx.getMetaData().getColumnName(javacast("int", col))#</td></cfoutput>
</cfloop>
</tr><tr>
<cfloop from="1" to="#xx.getMetaData().getColumnCount()#" index="col">
	<cfoutput><td>#xx.getMetaData().getColumnTypeName(javacast("int", col))#</td></cfoutput>
</cfloop>
</tr></table>


</body>
</html>
