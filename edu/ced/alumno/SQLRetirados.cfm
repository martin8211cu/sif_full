<cfquery name="SQL_AlumnoRetirado" datasource="#Session.Edu.DSN#">
	set nocount on
	insert into AlumnoRetirado (CEcodigo, Ecodigo, ARfecha, ARalta, 
								PRcodigo, PEcodigo, SPEcodigo, Ncodigo, Gcodigo)
	select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ecodigo#">, getDate(), 1, 
	pr.PRcodigo, pr.PEcodigo, pr.SPEcodigo, pr.Ncodigo, pr.Gcodigo
	from Promocion pr
	where pr.PRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRcodigo#">

	update Alumnos set Aretirado=0,
		PRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRcodigo#">
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ecodigo#">
	set nocount off
</cfquery>
<cflocation url="retirados.cfm">
