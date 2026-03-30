<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Monitor de RS</title>
</head>

<body>


<cfoutput>
Ejecutando @ #Now()#<br />

<cfinvoke component="saci.comp.rs_monitor" method="monitor" datasource="isb" />

Terminado @ #Now()#<br />

</cfoutput>

</body>
</html>
