<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<cfset nombre = "Gustavo">
<cfset fecha2 = "1/5/2004">
<cfset fecha = lsdateformat(now(), "dddd, dd mmmm, yyyy")>

<cfoutput>#lsdateformat(now(), "dddd, dd mmmm, yyyy")#</cfoutput> <br>
<cfoutput>#fecha#</cfoutput>
<br>
<BR>
Esta gana:<br>
<cfoutput>#lsdateformat(fecha2, "dddd, dd mmmm, yyyy")#</cfoutput>
<!---<cfset fechaCPinicioGen = LSDateFormat(rsNumCalenPago.PChasta)>--->

</body>
</html>
