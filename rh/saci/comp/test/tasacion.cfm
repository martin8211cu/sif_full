<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Prueba de tasación</title>
</head>

<body>
<cfset start_time = GetTickCount()>
<cfset registros_procesados = 1>
<cfset registros_total = 0>

	<cfinvoke component="saci.comp.tasacion" method="tasar"
		servicio="CANDELA-isb-001"
		maxrows="100"
		datasource="isb"
		returnvariable="registros_procesados"/>
	<cfset registros_total = registros_procesados + registros_total>

	<cfset finish_time = GetTickCount()>
	
	<cfoutput>
		Registros procesados: #registros_total#<br />
		Tiempo de proceso: #finish_time - start_time# ms<br />
		<cfif registros_total>
			Promedio: # NumberFormat( (finish_time - start_time) / registros_total , '0.00')# ms / registro<br />
		</cfif>
		<hr />
	</cfoutput>

</body>
</html>
