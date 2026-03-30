<cfset v = 'CS0001-'>
<cfset v1 = 'CS0001-15001'>
<cfset v2 = IsNumeric(MID(v1,LEN(v),5))>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
Es o No es :<cfoutput>#v2#</cfoutput>
</body>
</html>
