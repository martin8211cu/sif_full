<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>

<cfquery name="pagos" datasource="#session.DSN#" >
	select ct.DEid, ct.referencia, ct.montores
	from RCuentasTipo ct
	where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFcuenta#">
	and tiporeg = 10
</cfquery>

<cfquery name="cargas" datasource="#session.DSN#" >
	select ct.DEid, ct.referencia, ct.montores, ec.ECdescripcion, de.DEidentificacion, de.DEnombre, de.DEapellido1, de.DEapellido2

	from RCuentasTipo ct

	inner join CargasCalculo ce
	on ce.DClinea = ct.referencia	
	and ce.RCNid=ct.RCNid
	and  ce.DEid=ct.DEid
	and ce.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">

	inner join DCargas dc
	on dc.DClinea = ce.DClinea

	inner join ECargas ec
	on ec.ECid = dc.ECid

	inner join DatosEmpleado de
	on de.DEid = ct.DEid

	where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFcuenta#">
	and tiporeg = 30
</cfquery>

</body>
</html>