<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<cfscript>
	fechastring = '041231';
	fecha1 = CreateDate(Mid(fechastring,1,2),Mid(fechastring,3,2),Mid(fechastring,5,2));
	horastring = '144500';
	fecha2 = CreateDateTime(Year(Now()),Month(Now()),Day(Now()),Mid(horastring,1,2),Mid(horastring,3,2),Mid(horastring,5,2));
	fecha3 = CreateDateTime(Year(Now()),Month(Now()),Day(Now()),12,00,00);
	if (DateCompare(fecha2,fecha3) GT 0)
		fechaMayor = fecha2;
	else 
		fechaMayor = fecha3;
</cfscript>
<cfoutput>
	Fecha1:#fecha1#<br>
	Fecha2:#fecha2#<br>
	FechaMayor:#fechaMayor#<br>
</cfoutput>
</body>
</html>
