<cfparam name="url.Bid" 		type="numeric">	
<cfparam name="url.EcodigoASP" 	type="numeric" default="#session.EcodigoSDC#">	
<cfparam name="url.ERNid" 		type="numeric">	

<cf_dbfunction name="to_char" args="b.DRNliquido" returnvariable="monto">

<cfquery name="ERR" datasource="#session.DSN#">
	select 	{fn concat(ltrim(rtrim(c.DEcuenta)),
			{fn concat('#Chr(9)#',
			{fn concat(ltrim(rtrim(c.DEapellido1)),
			{fn concat(' ',
			{fn concat(ltrim(rtrim(c.DEapellido2)),
			{fn concat(' ',
			{fn concat(ltrim(rtrim(c.DEnombre)),
			{fn concat('#Chr(9)#',
			{fn concat(#monto#,
			{fn concat('#Chr(9)#','41'
			)})})})})})})})})})}
	from ERNomina a
	inner join DRNomina b
		on a.ERNid = b.ERNid								
		inner join Monedas d
			on b.Mcodigo = d.Mcodigo			
		inner join DatosEmpleado c
			on b.DEid = c.DEid
			and c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
	where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
	and b.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> 
	and b.DRNliquido != 0
</cfquery>
