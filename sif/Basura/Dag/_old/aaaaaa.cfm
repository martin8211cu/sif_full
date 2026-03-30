<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>aaaaaaa</title>
</head>

<body>
<cfset Mensaje2 = "Dorian tiene mucha hambre, debería ir a comer algo">
<cfset Mensaje = "">
<cfif Len(Mensaje)>
	<cfoutput>#Left(Mensaje,Find(",",Mensaje,1)-1)#</cfoutput>
<cfelse>
	
</cfif>
</body>
</html>
