<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Untitled Document</title>
</head>

<body>
<cfif isdefined("form")>
	<cfdump var="#form#">
</cfif>
<form action="" method="post" name="form1">
<input type="hidden" name="h1" value="1">
<cf_botones>
</form>
<form action="" method="post" name="form2">
<input type="hidden" name="h2" value="2">
<cf_botones>
</form>
</body>
</html>
