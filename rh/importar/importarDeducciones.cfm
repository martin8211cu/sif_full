<!---
	Importador de Deducciones
	Este archivo asume la existencia de la tabla temporal #table_name# "Datos de Entrada"
	Este archivo procesa los datos de entrada y genera el registro de deducciones correspondiente a los mismos.
	ANALIZAR Revisar las seccciones que tienen esta etiqueta
 --->
 
<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp>

<cf_dbtemp name="CEDULA_TEMP" returnvariable="CEDULA_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="cedula" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="id" type="integer" mandatory="yes">
</cf_dbtemp>

<cfquery name="rsCedula" datasource="#session.dsn#">
	insert into #Cedula_TEMP# (id,cedula)
	select id,rtrim(ltrim(cedula))
	from #table_name#
</cfquery>
	
<cfquery name="rsCedulaUpdate" datasource="#session.dsn#">
	update #table_name#  set cedula =  b.cedula
	from #table_name# a
	inner join #CEDULA_TEMP# b on a.id=b.id
</cfquery>

<cfquery name="rsCheck1" datasource="#session.dsn#">
		select distinct  
			snnumero
		from #table_name#
</cfquery>

<!--- 
<cfif rsCheck1.RecordCount GT 1>
	<cfquery name="rsCheck1" datasource="#session.dsn#">
			 insert into #ERRORES_TEMP# (Mensaje,ErrorNum) <!------>
			select distinct 
				{ fn concat('El archivo debe contener únicamente un número de socio de negocios(', { fn concat(snnumero, ')')})},1
			from #table_name#
			group by snnumero
			having count(1) > 1		
	</cfquery>
</cfif>
--->

<cfquery name="rsCheck2" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select distinct { fn concat('Socio o Tipo de Deducción son incorrectos. socio :', { fn concat(snnumero,{fn concat(' tipo : ',tdcodigo)})})},2
	from #table_name# a
	where not exists(
		select 1
		from SNegocios b
		where ltrim(rtrim(a.snnumero)) = ltrim(rtrim(b.SNnumero))
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	) or not exists(
		select 1
		from TDeduccion c
		where ltrim(rtrim(a.tdcodigo)) = ltrim(rtrim(c.TDcodigo))
		and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	)
</cfquery>



<cfquery name="rsCheck3" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select distinct { fn concat('Empleado no Existe (', { fn concat (cedula,')')})},3
	from #table_name# a
	where not exists(
		select 1
		from DatosEmpleado b
		where right(concat('00000',a.cedula), 5)  = right(concat('00000',b.DEidentificacion), 5)
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	)
</cfquery>

<cfquery name="rsCheck4" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select distinct 
	{ fn concat( 'Metodo o Control de Saldo son incorrectos. Metodo:', { fn concat(<cf_dbfunction name="to_char" args="metodo">, { fn concat('. Control_Saldo:', { fn concat(<cf_dbfunction name="to_char" args="controlsaldo">, '.')})})})},
	4
	from #table_name# a
	where (a.controlsaldo != 0
	and a.controlsaldo != 1)
	or
	(a.metodo != 0
	and a.metodo != 1)
</cfquery>

<cfquery name="rsCheck5" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select distinct 
	{fn concat('No tiene permisos sobre este Tipo de Deducción (',{fn concat(a.tdcodigo,')')})},
	5
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
	and not exists (
		select 1
		from TDeduccion b
		where ltrim(rtrim(a.tdcodigo)) = ltrim(rtrim(b.TDcodigo))
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and not exists (
		   select 1 from RHUsuarioTDeduccion d where d.TDid = b.TDid and d.Ecodigo = b.Ecodigo
		)
	)
</cfquery>
<!--- VERIFICA SI EXISTE YA LA DEDUCCIÓN DE RENTA --->
<cfquery name="rsCheck6" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select distinct 
	{fn concat('Solo puede haber una deducción de este tipo (',{fn concat(a.tdcodigo,{fn concat(') para el empleado ',cedula)})})},
	6
	from #table_name# a
	where exists(
				select 1
				from DatosEmpleado d
				inner join DeduccionesEmpleado b
					  on b.DEid = d.DEid
					  and b.Ecodigo = d.Ecodigo
				inner join TDeduccion c
					  on c.TDid = b.TDid
					  and c.Ecodigo = d.Ecodigo
				where right(concat('00000',a.cedula), 5)  = right(concat('00000',d.DEidentificacion), 5)
				  and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and b.Dactivo = 1
				  and c.TDrenta = 1
				  and ltrim(rtrim(a.tdcodigo)) = ltrim(rtrim(c.TDcodigo))
	)
</cfquery>

<cfquery name="err" datasource="#session.dsn#">
	select Mensaje
	from #ERRORES_TEMP#
	order by Mensaje,ErrorNum
</cfquery>

<cfif (err.recordcount) EQ 0>

	<cfquery name="rsEncabezado" datasource="#session.dsn#">
		select distinct snnumero as SNnumero, tdcodigo as TDcodigo
		from #table_name# 
	</cfquery>

	<cftransaction>
		<cfloop query="rsEncabezado">

			<cfquery name="rsSNcodigo" datasource="#session.dsn#">
				select SNcodigo
				from SNegocios
				where SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEncabezado.SNnumero#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>

			<cfquery name="rsTDid" datasource="#session.dsn#">
				select TDid 
				from TDeduccion 
				where TDcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEncabezado.TDcodigo#">
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>

			<cfquery name="rsEIDlote" datasource="#session.dsn#">
				select coalesce(max(EIDlote)+1, 1) as EIDlote
				from EIDeducciones
			</cfquery>


			<cfquery name="rsCheck1" datasource="#session.dsn#">
				select distinct snnumero
				from #table_name#
			</cfquery>

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
					cedula, referencia, metodo, valor, fechaini, fechafin, isnull(monto,0), isnull(controlsaldo,0)
				from #table_name#
				where snnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEncabezado.SNnumero#">
				and tdcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEncabezado.TDcodigo#">
			</cfquery>

		</cfloop>	
	</cftransaction>
	
	<!--- ANALIZAR Analizar si se quiere sin Empresa realmente --->
	

	
</cfif>
