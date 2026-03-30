<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfif isdefined('gohttp')>
	<cf_ssl secure="no" url="ssl-test.cfm?s=0">
<cfelseif isdefined('gohttps')>
	<cf_ssl secure="yes" url="ssl-test.cfm?s=1">
<cfelseif isdefined('url.s') and url.s is 0>
	<cf_ssl secure="no" action="check">
<cfelseif isdefined('url.s') and url.s is 1>
	<cf_ssl secure="yes" action="check">
</cfif>
<form action="" method="get">
	<input type="submit" value="http" name="gohttp">
	<input type="submit" value="https" name="gohttps">
</form>

<cfdump var="#session.sitio#">

</body>
</html>
