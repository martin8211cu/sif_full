<!---
	Importador de Deducciones masivas
	Este archivo asume la existencia de la tabla temporal #table_name# "Datos de Entrada"
	Este archivo procesa los datos de entrada y genera el registro de deducciones correspondiente a los mismos.
 --->
 
<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp>

<!--- Valida que el empleado no esté repetido (revisar que no se suba empleados repetidos (con los mismos datos)) ---> 
<cfquery name="rsCheck0" datasource="#session.dsn#">
	--insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  <!------>
	select {fn concat('Empleado repetido: ',cedula)},0
	from #table_name# a
	group by snnumero, cedula, tdcodigo, referencia
	having count(1) > 1
</cfquery>
<!--- Valida que el socio de negocio sea valido --->
<cfquery name="rsCheck1" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)  <!------>
	select distinct 
    {fn concat('Socio de negocio incorrecto. socio :',snnumero)},1
	from #table_name# a
	where not exists(
		select 1
		from SNegocios b
		where ltrim(rtrim(a.snnumero)) = ltrim(rtrim(b.SNnumero))
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    )    
</cfquery>

<!--- Valida que el tipo de Deducción sea valido --->
<cfquery name="rsCheck2" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum) <!--- --->

	select distinct 
    {fn concat('Tipo de Deducción. tipo :',tdcodigo)},2
	from #table_name# a
	where not exists(
		select 1
		from TDeduccion c
		where ltrim(rtrim(a.tdcodigo)) = ltrim(rtrim(c.TDcodigo))
		and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	)
</cfquery>

<!--- Valida que el Empleado sea valido --->
<cfquery name="rsCheck3" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select distinct { fn concat('Empleado no Existe (', { fn concat (cedula,')')})},3
	from #table_name# a
	where not exists(
		select 1
		from DatosEmpleado b
		where a.cedula = b.DEidentificacion
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	)
</cfquery>
<!--- Valida que el metodo o Control de Saldo sea valido , que sea cero o uno--->
<cfquery name="rsCheck4" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select distinct 
	{ fn concat( 'Método o Control de Saldo son incorrectos. Metodo:', { fn concat(<cf_dbfunction name="to_char" args="metodo">, { fn concat('. Control_Saldo:', { fn concat(<cf_dbfunction name="to_char" args="controlsaldo">, '.')})})})},
	4
	from #table_name# a
	where (a.controlsaldo != 0
	and a.controlsaldo != 1)
	or
	(a.metodo != 0
	and a.metodo != 1)
</cfquery>
<!--- Valida que el usuario tenga permiso sobre este Tipo de Deducción --->
<cfquery name="rsCheck5" datasource="#session.dsn#">
	--insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select distinct 
	{fn concat('No tiene permisos sobre este Tipo de Deducción (',{fn concat(a.tdcodigo,')')})} as mensaje,
	5 as numero
	from #table_name# a
	where not exists(
		select 1
		from TDeduccion b, RHUsuarioTDeduccion c
		where ltrim(rtrim(a.tdcodigo)) = ltrim(rtrim(b.TDcodigo))
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and b.Ecodigo = c.Ecodigo
		and b.TDid = c.TDid
		and c.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	)
	and exists (
		select 1
		from TDeduccion b
		where ltrim(rtrim(a.tdcodigo)) = ltrim(rtrim(b.TDcodigo))
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and not exists (
		   select 1 from RHUsuarioTDeduccion d where d.TDid = b.TDid and d.Ecodigo = b.Ecodigo
		))
</cfquery>
<cfquery name="err" datasource="#session.dsn#">
	select Mensaje
	from #ERRORES_TEMP#
	order by Mensaje,ErrorNum
</cfquery>
<!--- si la tabla #ERRORES_TEMP# tiene registro los envia como errores de lo contrario procesa la información --->
<cfif (err.recordcount) EQ 0>

	<cfquery name="rsAgrupador" datasource="#session.dsn#" >
		select distinct snnumero,tdcodigo
		from #table_name# 
	</cfquery>
	
	<cfset TDcodigo = "">
	<cfset snnumero = "">
	<cfloop query="rsAgrupador">
			<cfset TDcodigo = rsAgrupador.TDcodigo>
			<cfset snnumero = rsAgrupador.snnumero>
			
			<cfquery name="rsTDid" datasource="#session.dsn#">
				select TDid 
				from TDeduccion 
				where TDcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#TDcodigo#">
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			
			<cfquery name="rsSNcodigo" datasource="#session.dsn#">
				select SNcodigo
				from SNegocios
				where SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#SNnumero#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>			

			<!--- ANALIZAR Analizar si se quiere sin Empresa realmente --->
			<cfquery name="rsEIDlote" datasource="#session.dsn#">
				select coalesce(max(EIDlote)+1, 1) as EIDlote
				from EIDeducciones
			</cfquery>
			<cftransaction>
				<!--- Registro de Deducciones --->
				<cfquery datasource="#session.dsn#">
					insert into EIDeducciones(EIDlote, Ecodigo, TDid, SNcodigo, Usucodigo, Ulocalizacion, EIDfecha, EIDestado)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEIDlote.EIDlote#">, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTDid.TDid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNcodigo.SNcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
						'00', 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
						0)
				</cfquery>
				<!--- Detalles de Registro de Deducciones --->
				<cfquery datasource="#session.dsn#">
					insert into DIDeducciones ( EIDlote, DIDidentificacion, DIDreferencia, DIDmetodo, DIDvalor, DIDfechaini, DIDfechafin, DIDmonto, DIDcontrolsaldo)
					select <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEIDlote.EIDlote#">, 
						cedula, referencia, metodo, valor, fechaini, fechafin, monto, controlsaldo
					from #table_name#
					where snnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#SNnumero#">
						and tdcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#TDcodigo#">
				</cfquery>
			</cftransaction>	
	</cfloop>
</cfif>
