<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Untitled Document</title>
</head>

<body>
<cfset LvarSeg = 9>
9
<cfsetting requesttimeout="36000">
<cftry>
	<cfsetting requesttimeout="10">
	<cfinclude template="a2.cfm">
<cfcatch type="any">
	<cfsetting requesttimeout="36000">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>
<cfsetting requesttimeout="36000">
11
<cfset LvarSeg = 11>
<cftry>
	<cfinclude template="a2.cfm">
<cfcatch type="any">
	<cfsetting requesttimeout="36000">
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>
<cfsetting requesttimeout="36000">
</body>
</html>
