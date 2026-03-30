<!---
	Importador de Comisiones
	Este archivo asume la existencia de la tabla temporal #table_name# "Datos de Entrada"
	Este archivo procesa los datos de entrada y genera el registro (s) de relación de cálculo correspondiente a los mismos.
 --->
<!--- DEFINICIONES INICIALES --->

<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp>

<!--- VALIDACIONES --->

<!--- Check1. empleado --->
<cfquery name="rsCheck1" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum) 
	select { fn concat('El empleado no existe. Cédula:', { fn concat(cedula, '.')})},1
	from #table_name# a
	where not exists (	select 1 from DatosEmpleado b
						where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.cedula = b.DEidentificacion)	
</cfquery>
<!--- Check2. incidencias repetidas --->
<cfquery name="ERR" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum) 
	select {fn concat('Existen incidencias repetidas. Incidencia: ',{fn concat(incidencia,{fn concat(' para la cédula :',cedula)})})},2
	from #table_name# a, DatosEmpleado b
	where a.cedula = b.DEidentificacion 
	and  b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	group by cedula, incidencia
	having count(1) > 1	
</cfquery>
<!--- Check3. incidencias  no existe repetidas --->
<cfquery name="ERR" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum) 
	select {fn concat('No Existen Incidencia. Incidencia: ',{fn concat(incidencia,{fn concat(' para la cédula :',cedula)})})},3
	from #table_name# a
	where not exists (	select 1 from CIncidentes b
						where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.incidencia = b.CIcodigo)
</cfquery>
<!--- Check4. Comisiones diferentes en el mismo archivo --->
<cfquery name="ERR" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum) 
	select distinct { fn concat('Diferentes códigos importados: ', { fn concat(incidencia, '. Favor importar un código a la vez.')})},4
	from #table_name# a
	where exists (select 1 from #table_name# b
				  where a.incidencia != b.incidencia)
</cfquery>

<!--- Check5. valida nomina --->
<cfquery name="ERR" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum) 
	select { fn concat('No existe la nómina:', { fn concat(nomina, '.')})},5
	from #table_name# a
	where not exists (
		select 1 
		from TiposNomina b
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and b.Tcodigo = a.nomina
	)
</cfquery>
<!--- Check6. valida fecha del calendario --->
<cfquery name="ERR" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum) 
	select 'No existe un calendario para la fecha dada',6
	from #table_name# a
	where not exists (
		select 1 
		from CalendarioPagos b
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and b.Tcodigo = a.nomina
		and b.CPmes = a.mes
		and b.CPperiodo = a.periodo
	)
	and  exists (
		select 1 
		from TiposNomina x
		where x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and x.Tcodigo = a.nomina)
</cfquery>

<!--- Check7. Valida que no exista una comision insertada para el mismo empleado, mismo calendario y mismo código --->
<cfquery name="ERR" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum) 
	select { fn concat('Ya fue insertado el código: ',{ fn concat(incidencia,{ fn concat(', para el empleado: ', { fn concat(cedula,'.')})})})},7
	from #table_name# a,  DatosEmpleado b, CalendarioPagos c, CIncidentes d
	where
		a.cedula = b.DEidentificacion 
		and c.Tcodigo = a.nomina
		and c.CPmes = a.mes
		and c.CPperiodo = a.periodo
		and d.CIcodigo = a.incidencia
		and exists (select 1 from RHComisionMongeD e
					where e.DEid = b.DEid
					and e.CPid = c.CPid
					and e.CIid = d.CIid)
</cfquery>

<cfquery name="ERR" datasource="#session.dsn#">
	select Mensaje
	from #ERRORES_TEMP#
	order by Mensaje,ErrorNum
</cfquery>
<cfif (err.recordcount) EQ 0>
	<cftransaction>
	
	<!---JCG 1.0) Inserción de datos comisiones DETALLE --->
	
		<cfquery name="rsCalendario" datasource="#session.dsn#">
				select min(CPid) as CPid from CalendarioPagos cp, #table_name# a
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and CPmes = a.mes
							and CPperiodo = a.periodo
							and Tcodigo = a.nomina
							and CPtipo = 0
			</cfquery>
	
	<!---JCG 1.1) Inserción de datos por cada diferente tipo de comisión que carguen --->
	
		<cfquery name="inserta_datos" datasource="#session.dsn#">
			insert INTO RHComisionMongeD (DEid, CPid, CIid, CIcodigo, RHCMmontocomision, Usucodigo, fechaalta)
			select 
				DEid, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCalendario.CPid#">,
				CIid, 
				CIcodigo, 
				comision,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			from #table_name# a
				inner join DatosEmpleado b
					on b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and b.DEidentificacion  = a.cedula
				inner join CIncidentes d
					on d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and d.CIcodigo = a.incidencia
		</cfquery>		
		
		<!---JCG 1.2) Inserta el Encabezado, si no existe --->
	
			<cfquery name="inserta_enc" datasource="#session.dsn#">
				insert INTO RHComisionMonge (DEid, CPid, RHCMminimo, RHCMsalario, RHCMmontobase, RHCMmontocomision, RHCMcomision, RHCMcomisionsegunda, RHCMajuste, RHCMajustesegunda)
				select DEid, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCalendario.CPid#">,
						minimo,
						0, 
						base, 
						comision, 
						0 comision, 
						base Pasar_a_segunda_quincena,
						0 Ajuste,
						0
				from #table_name# a
					inner join DatosEmpleado b
						on b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and b.DEidentificacion  = a.cedula
						and not exists (select 1 from RHComisionMonge c
										where c.DEid = b.DEid
										and c.CPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCalendario.CPid#">
										)
			</cfquery>
	</cftransaction>
</cfif>