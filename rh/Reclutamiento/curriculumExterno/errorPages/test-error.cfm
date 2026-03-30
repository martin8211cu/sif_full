<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>


<cffunction name="zz">

<cftry>
<cfquery datasource="asp">

select uno mas dos
</cfquery>
<cfcatch type="any">
<cfinclude template="BDerror.cfm"></cfcatch>
</cftry>
</cffunction>

<cffunction name="yy">

<cfset zz()>
</cffunction>


<cfset yy()>
</body>
</html>
