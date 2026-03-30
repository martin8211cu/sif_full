<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>
<cfparam name="url.id" type="numeric" default="0">
<cfparam name="url.hash" type="string" default="">

<cfquery datasource="sifcontrol" name="enc">
	select * from IBitacora
	where IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
	  and IBhash = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.hash#">
</cfquery>
<cfif enc.RecordCount EQ 1>
	<cftry>
	<cffile action="read" variable="contents" 
		file="#GetTempDirectory()#/imp-err-#url.id#.html">
	<cfoutput>#contents#</cfoutput><cfcatch>No encontrado</cfcatch></cftry>
</cfif>
</body>
</html>