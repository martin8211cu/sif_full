<cfquery name="rsTable" datasource="#session.dsn#">
	select Fecha, Hora, Tipo, Tarjeta
	from #table_name#
</cfquery>
<cfloop query="rsTable">
	<cfset Lvar_DateTime = CreateDateTime(Year(Fecha),Month(Fecha),Day(Fecha),ListGetAt(Hora,1,":"),ListGetAt(Hora,2,":"),0)>
	<cfquery datasource="#session.dsn#">
		insert into RHControlMarcas
		(Ecodigo, DEid,	fechahorareloj, tipomarca, registroaut, fechahoramarca, RHJid, BMUsucodigo, BMfecha)
		select 
			a.Ecodigo, 
			a.DEid,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Lvar_DateTime#">, 
			case #Tipo# when 1 then 'E' else 'S' end,
			1,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Lvar_DateTime#">, 
			coalesce(p.RHJid,b.RHJid),
			#Session.Usucodigo#,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		from DatosEmpleado a
			inner join LineaTiempo b
				on b.DEid = a.DEid
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Lvar_DateTime#"> between b.LTdesde and b.LThasta
			left outer join RHPlanificador p
				on  p.DEid = a.DEid
				and <cf_dbfunction name="date_format" args="p.RHPJfinicio,yyyymmdd"> = <cfqueryparam cfsqltype="cf_sql_char" value="#LSDateFormat(Fecha,'yyyymmdd')#">
		where a.DEtarjeta = '#Tarjeta#'
		and a.Ecodigo = #session.Ecodigo#
	</cfquery>
</cfloop>