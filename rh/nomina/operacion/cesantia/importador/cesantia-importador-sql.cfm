<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	<cf_dbtempcol name="codigo"	type="char(15)"  mandatory="no">
	<cf_dbtempcol name="error"	type="char(100)" mandatory="no">
</cf_dbtemp>

<!--- Identificacion nula --->
<cfquery datasource="#session.DSN#" >
	insert into #errores#(codigo, error)
	select '100', 'Identificaci&oacute;n de empleado nula' 
	from #table_name#
	where Identificacion is null or rtrim(ltrim(Identificacion)) = ''
</cfquery>
<!--- Identificacion no corresponde a empleado de la empresa --->
<cfquery datasource="#session.DSN#" >
	insert into #errores#(codigo, error)
	select '200', <cf_dbfunction name="concat" args="'La identificaci&oacute;n ', a.Identificacion ,' no corresponde a ning&uacute;n empleado'">
	from #table_name# a
	where not exists ( 	select DEidentificacion 
						from DatosEmpleado 
						where DEidentificacion = a.Identificacion
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
</cfquery>

<!--- codigo de carga no nulo --->
<cfquery datasource="#session.DSN#" >
	insert into #errores#(codigo, error)
	select '300', 'Carga Obrero Patronal nula' 
	from #table_name#
	where Carga is null or rtrim(ltrim(Carga)) = ''
</cfquery>
<!--- Carga no definida en la empresa --->
<cfquery datasource="#session.DSN#" >
	insert into #errores#(codigo, error)
	select '400', <cf_dbfunction name="concat" args="'La Carga Obrero Patronal ', a.Carga ,' no existe en los catálogos de la empresa.'">
	from #table_name# a
	where not exists ( 	select 1
						from DCargas
						where DCcodigo = a.Carga
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
</cfquery>

<!--- periodo nulo --->
<cfquery datasource="#session.DSN#" >
	insert into #errores#(codigo, error)
	select '500', 'Período nulo' 
	from #table_name#
	where Periodo is null
</cfquery>
<!--- mes nulo --->
<cfquery datasource="#session.DSN#" >
	insert into #errores#(codigo, error)
	select '600', 'Mes nulo' 
	from #table_name#
	where Mes is null
</cfquery>

<!--- Devuelve errores si los hay --->
<cfquery name="err" datasource="#session.dsn#">
	select codigo, error
	from #errores#
	order by codigo
</cfquery>

<!--- Inicia el proceso si no hay errores --->
<cfif err.recordcount eq 0>
	<cfquery name="data" datasource="#session.DSN#">
		insert into RHCesantiaSaldos(DEid, DClinea, RHCSperiodo, RHCSmes, RHCSsaldoInicial, RHCSmontoMes, RHCSsaldoInicialInt, RHCSmontoMesInt, BMUsucodigo, RHCSliquidado, RHCScerrado)
		select 	de.DEid, 
				dc.DClinea,
				a.Periodo, 
				a.Mes, 
				coalesce(a.SaldoInicial, 0.00), 
				0 as monto_mes, 
				coalesce(a.SaldoInicialInteres, 0.00),
				0 as monto_mes_int,
				#session.usucodigo#,
				0,
				0
		from #table_name# a, DatosEmpleado de, DCargas dc
		where de.DEidentificacion = ltrim(rtrim(a.Identificacion))
		  and dc.DCcodigo = ltrim(rtrim(a.Carga))
		  and dc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>