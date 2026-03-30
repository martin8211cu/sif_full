<!---
	Importador IMPEMPASOC
	Importador de Empleados Asociados
	Elaborado por: Ana Villavicencio
	Fecha de Creación: 14/08/2007
	Modificaciones Posteriores
	Fecha 		Usuario		Motivo
	DD/MM/YYYY	UUUUUUU		MMMMMM
--->
<!--- Tabla Temporal de Errores --->
<cf_dbtemp name="ERRORESASOC" returnvariable="ERRORESASOC" datasource="#session.dsn#">
	<cf_dbtempcol name="IDEmpleado" 	type="varchar(60)" 	mandatory="no">
	<cf_dbtempcol name="Fecha" 			type="date" 		mandatory="no">
	<cf_dbtempcol name="Mensaje" 		type="varchar(255)" mandatory="no">
	<cf_dbtempcol name="DatoIncorrecto" type="varchar(40)" 	mandatory="no">
	<cf_dbtempcol name="ErrorNum" 		type="integer" 		mandatory="no">
</cf_dbtemp>
<!--- VALIDA QUE EL ID DEL EMPLEADO NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #ERRORESASOC# (IDEmpleado, Fecha, Mensaje, DatoIncorrecto, ErrorNum)
	select '', '','Identificacion Nulas.', IDEmpleado, 100
	from #table_name#
	where IDEmpleado is null
</cfquery>

<!--- VALIDA QUE LA FECHA NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #ERRORESASOC# (IDEmpleado, Fecha,Mensaje, DatoIncorrecto, ErrorNum)
	select IDEmpleado, '','Fechas Nulas.', IDEmpleado, 200
	from #table_name#
	where Fecha is null
</cfquery>

<!--- VALIDA QUE NO SE REPITAN LOS REGISTROS EN EL ARCHIVO--->
<cfquery name="rsConsulta" datasource="#session.DSN#">
	insert into #ERRORESASOC# (IDEmpleado, Fecha,Mensaje, DatoIncorrecto, ErrorNum)
	Select IDEmpleado, '','El Empleado se repite en el archivo.',  count(IDEmpleado), 300
	from #table_name# a
	group by IDEmpleado
	having count(IDEmpleado) > 1
</cfquery>

<!--- VALIDA QUE EXISTAN LOS EMPLEADOS --->
<cfquery datasource="#session.dsn#">
	insert into #ERRORESASOC# (IDEmpleado, Fecha,Mensaje, DatoIncorrecto, ErrorNum)
	select IDEmpleado, '','El Empleado no Existe.', IDEmpleado, 400
	from #table_name# a
	where not exists(Select 1
					 from DatosEmpleado b
					 where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					   and b.DEidentificacion = a.IDEmpleado)
</cfquery>


<!--- VALIDA QUE NO EXISTAN LOS EMPLEADOS EN LA TABLA DE ASOCIADOS --->
<cfquery name="rsConsulta" datasource="#session.DSN#">
	insert into #ERRORESASOC# (IDEmpleado, Fecha,Mensaje, DatoIncorrecto, ErrorNum)
	Select IDEmpleado, '','El Empleado ya existe.', IDEmpleado, 500
	from #table_name# a
	where exists (Select 1 
				  from DatosEmpleado c
				  inner join ACAsociados b 
				  	on b.DEid = c.DEid
				  where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				    and a.IDEmpleado = c.DEidentificacion)
</cfquery>
<!--- Devuelve errores si los hay --->
<cfquery name="err" datasource="#session.dsn#">
	select IDEmpleado, Fecha, Mensaje, DatoIncorrecto 
	from #ERRORESASOC#
	order by IDEmpleado, Fecha,ErrorNum
</cfquery>

<cfif err.recordcount eq 0>

	<cfquery name="r" datasource="#session.dsn#">
		select b.DEid,Fecha
		from #table_name# a
		inner join DatosEmpleado b
			on b.DEidentificacion = a.IDEmpleado
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
 	<cftransaction>
		<cfloop query="r">
			<cfquery name="rsACAsociados" datasource="#session.DSN#">
				insert into ACAsociados (DEid, ACAestado, ACAfechaIngreso, BMUsucodigo, BMfecha)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">,
					1,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Fecha)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="rsACAsociados">
			<!--- Inserta en la tabla ACLineaTiempoAsociado (Línea del Tiempo) --->
			<cfquery name="rsACLineaTiempoAsociado" datasource="#Session.DSN#">
				insert into ACLineaTiempoAsociado (
					ACAid, ACLTAfdesde, ACLTAfhasta, BMUsucodigo, BMfecha
				)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsACAsociados.identity#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Fecha)#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime('01/01/6100')#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				)
			</cfquery>
		</cfloop>
	</cftransaction>
</cfif>
