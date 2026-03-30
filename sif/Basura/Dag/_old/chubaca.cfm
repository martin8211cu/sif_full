<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Chubaca</title>
</head>

<body>
<cfquery name="rsChubaca" datasource="#session.dsn#">
	select Ddocumento, Dtotal, b.Mcodigo, b.Mnombre, convert(varchar,b.Mcodigo) || convert(varchar,b.Mnombre) as Pivote
	from BMovimientos a, Monedas b
	where a.Ecodigo = 1
	and a.SNcodigo = 10045
	and a.Ecodigo = b.Ecodigo 
	and a.Mcodigo = b.Mcodigo
	union
	select Ddocumento, Dtotal / 475 as Dtotal, 2 as Mcodigo, b.Mnombre, convert(varchar,b.Mcodigo) || convert(varchar,b.Mnombre) as Pivote	
	from BMovimientos a, Monedas b
	where a.Ecodigo = 1
	and a.SNcodigo = 10045
	and a.Ecodigo = b.Ecodigo 
	and 2 = b.Mcodigo
	order by 3,1,2
</cfquery>
<cfset QryFinal = QueryNew("Mcodigo,Mnombre,Total")>
<cfoutput query="rsChubaca" group="Pivote">
	<!--- Ciclo solamente por los Mcodigo, Mnombre Distintos --->
	<cfset QueryAddRow(QryFinal,1)>
	<cfset QuerySetCell(QryFinal,"Mcodigo",Mcodigo,QryFinal.RecordCount)>
	<cfset QuerySetCell(QryFinal,"Mnombre",Mnombre,QryFinal.RecordCount)>
	<cfset QuerySetCell(QryFinal,"Total",0.00,QryFinal.RecordCount)>
	<cfoutput>
		<!--- Ciclo solamente por los todos los registros del query --->
		<cfset QuerySetCell(QryFinal,"Total",QryFinal.Total+Dtotal,QryFinal.RecordCount)>
	</cfoutput>
</cfoutput>
<cfdump var="#QryFinal#" label="Chubaca">
</body>
</html>
