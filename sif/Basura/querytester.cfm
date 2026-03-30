<!---
'hola'||replicate(' ',13-{fn LENGTH(left('hola',13))}) as hola,
125125.75 * 100 as salario
--->
<cfquery name="rs" datasource="minisif" maxrows="1">
	select DEid,case when {fn LOCATE('#chr(10)#', DEdireccion)}  >= 2 then substring(DEdireccion, 1, {fn LOCATE('#chr(10)#', DEdireccion)} -2) end as dos
	from DatosEmpleado where Ecodigo = 1
	and case when {fn LOCATE('#chr(10)#', DEdireccion)}  >= 2 then substring(DEdireccion, 1, {fn LOCATE('#chr(10)#', DEdireccion)} -2) end is not null
</cfquery>
<h1>RS</h1><br>
<cfdump var="#rs#">