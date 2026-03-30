<cfapplication name="SIF_ASP" 
	sessionmanagement="No"
	clientmanagement="No"
	setclientcookies="No"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>
	<cfinvoke component="asp.admin.empresa.indicador.calculo" method="calcular"
		Ecodigo="0" fecha="#Now()#" />

OK
</body>
</html>
