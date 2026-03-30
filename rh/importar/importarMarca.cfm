<cfscript>
	bcheck1 = false;
	bRHPMid = false;
	bRHPMfproceso = false;
</cfscript>

<!--- Chequear existencia de Tarjetas Correctas --->
<cfquery name="rsCheck1" datasource="#session.DSN#">
	select count(1) as check1
	from #table_name# a
	where not exists(
					select 1
					from DatosEmpleado b
					where b.DEtarjeta = a.Tarjeta
					 and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				)
</cfquery>
<cfset bcheck1 = rsCheck1.check1 LT 1>
<cfif bcheck1>
	<cfquery name="rsDcodigo" datasource="#session.DSN#">
		select min(Dcodigo) as Dcodigo
		from Departamentos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset bDcodigo = rsDcodigo.Dcodigo>
	<cfquery name="rsOcodigo" datasource="#session.DSN#">
		select min(Ocodigo) as Ocodigo
		from Oficinas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset bOcodigo = rsOcodigo.Ocodigo>
	<cfquery name="rsSelectAB" datasource="#session.dsn#">
		select 
			a.Fecha,
			a.Hora,
			b.DEid, 
			b.DEidentificacion, 
			a.RMreloj
		from #table_name# a, DatosEmpleado b
		where a.Tarjeta = b.DEtarjeta
		 and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfloop query="rsSelectAB">
		<cfquery datasource="#session.DSN#">
			insert into RMarcas
				(Ecodigo, RHPMid, RMtiporegis, RMfecha, 
				Dcodigo, Ocodigo, DEid, DEidentificacion, 
				RMreloj, RMmarcaproces, BMUsucodigo, BMfecha)
			values(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				-<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfif DateCompare(CreateDateTime(Year(Now()),Month(Now()),Day(Now()),Mid(rsSelectAB.Hora,1,2),Mid(rsSelectAB.Hora,3,2),Mid(rsSelectAB.Hora,5,2)),CreateDateTime(Year(Now()),Month(Now()),Day(Now()),12,00,00)) LT 0>
					'1'
				<cfelse>
					'2'
				</cfif>,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDateTime(Mid(rsSelectAB.Fecha,1,2),Mid(rsSelectAB.Fecha,3,2),Mid(rsSelectAB.Fecha,5,2),Mid(rsSelectAB.Hora,1,2),Mid(rsSelectAB.Hora,3,2),Mid(rsSelectAB.Hora,5,2))#">, 
				
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#bDcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#bOcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectAB.DEid#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#rsSelectAB.DEidentificacion#">, 
				
				<cfqueryparam cfsqltype="cf_sql_char" value="#rsSelectAB.RMreloj#">, 
				0,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
		</cfquery>
	</cfloop>
<cfelse>
	<cfquery name="ERR" datasource="#session.DSN#">
		select distinct 'No existe nigún empleado con esta tarjeta, nombrado hasta la fecha' as MSG, a.Tarjeta as Tarjeta
		from #table_name# a
		where not exists(
					select 1
					from DatosEmpleado b
					where b.DEtarjeta = a.Tarjeta
					 and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				)
	</cfquery>	
</cfif>