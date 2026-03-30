
<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	<cf_dbtempcol name="codigo"	type="char(15)"  mandatory="no">
	<cf_dbtempcol name="error"	type="char(100)" mandatory="no">
</cf_dbtemp>

<!--- borra la linea de encabezados --->
<cfquery datasource="#session.DSN#">
	delete #table_name# 
	where id = 1
</cfquery>

<!--- quita la comilla sencilla si la trae --->
<cfquery datasource="#session.DSN#">
	update #table_name#
	set Identificacion = (case when substring(Identificacion, 1, 1 ) = '''' then substring(Identificacion, 2, 60 ) else Identificacion end)
</cfquery>

<!--- Valida identificacion del empleado--->
<cfquery datasource="#session.DSN#" >
	insert into #errores#(codigo, error)
	select '100', 'Identificaci&oacute;n de empleado nula' 
	from #table_name#
	where Identificacion is null or rtrim(ltrim(Identificacion)) = ''
</cfquery>

<cfquery datasource="#session.DSN#">
	update #table_name#
	set Identificacion = ltrim(rtrim(Identificacion))
</cfquery>

<cfquery datasource="#session.DSN#" >
	insert into #errores#(codigo, error)
	select '200', <cf_dbfunction name="concat" args="'La identificaci&oacute;n ', a.Identificacion ,' no corresponde a ning&uacute;n empleado'">
	from #table_name# a
	where not exists ( 	select DEidentificacion 
						from DatosEmpleado 
						where DEidentificacion = a.Identificacion
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
</cfquery>

<!--- Valida fecha de inicio del ajuste --->
<cfquery datasource="#session.DSN#" >
	insert into #errores#(codigo, error)
	select '300', 'Fecha de Inicio nula' 
	from #table_name#
	where FechaDesde is null or rtrim(ltrim(FechaDesde)) = ''
</cfquery>

<!--- Devuelve errores si los hay --->
<cfquery name="err" datasource="#session.dsn#">
	select codigo, error
	from #errores#
	order by codigo
</cfquery>

<!--- Recupera el minimo grupo --->
<cfquery name="grupo" datasource="#session.DSN#">
	select coalesce(max(RHVEgrupo), 0) as grupo
	from RHVacacionesEmpleado
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfset id = grupo.grupo >
<cfif len(trim(id)) eq 0>
	<cfset id = 0 >
</cfif>
<cfset id = id + 1 >

<!--- Inicia el proceso si no hay errores --->
<cfif err.recordcount eq 0>
	<cfquery name="data" datasource="#session.DSN#">
		select 	de.DEid, 
				a.Identificacion,
				a.Descripcion, 
				a.Nombre, 
				a.FechaDesde, 
				a.FechaHasta, 
				a.SaldoActual, 
				a.SaldoProyectado, 
				coalesce(a.AjustePositivo, '0') as AjustePositivo, 
				coalesce(a.AjusteNegativo, '0') as AjusteNegativo
		from #table_name# a, DatosEmpleado de
		where de.DEidentificacion = ltrim(rtrim(a.Identificacion))
		and de.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<!---and ( a.AjustePositivo > 0 or abs(a.AjusteNegativo) > 0 )--->
	</cfquery>
	
	<cfoutput query="data">
		<cfif isnumeric(data.AjustePositivo) and isnumeric(data.AjusteNegativo)>
			<cfquery datasource="#session.DSN#">
				insert into RHVacacionesEmpleado( RHVEgrupo,
												  RHVEdescripcion, 
												  DEid, 
												  DVEfecha, 
												  DVEfinicio,
												  DVEffin,
												  DVEdescripcion, 
												  DVEdisfrutados, 
												  DVEcompensados, 
												  DVEenfermedad, 
												  DVEadicionales, 
												  DVEmonto, 
												  Usucodigo, 
												  Ulocalizacion,
												  Ecodigo,
												  DVEfalta,
												  BMUsucodigo )
				values( #id#,
						'#data.descripcion#',
						#data.DEid#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(data.FechaDesde)#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(data.FechaDesde)#">,						
						<cfif data.FechaDesde neq data.FechaHasta>
							<cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(data.FechaHasta)#">,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(data.FechaDesde)#">,
						</cfif>
						'#data.descripcion#',
						<!---<cfif data.FechaDesde neq data.FechaHasta>
							'Ajuste de vacaciones del #data.FechaDesde# al #data.FechaHasta#',
						<cfelse>
							'Ajuste de vacaciones #data.FechaDesde#',
						</cfif>--->
						#abs(data.AjustePositivo) - abs(data.AjusteNegativo)#,
						0,
						0,
						0,
						0,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						'00',
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#"> )
			</cfquery>
		</cfif>
	</cfoutput>
</cfif>