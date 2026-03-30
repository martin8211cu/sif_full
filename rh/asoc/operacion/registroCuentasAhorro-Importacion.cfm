<!---
	Importador IMPCTAAHO
	Importador de Datos para Cuentas de  Ahorro
	Elaborado por: Ana Villavicencio
	Fecha de Creación: 21/08/2007
	Modificaciones Posteriores
	Fecha 		Usuario		Motivo
	DD/MM/YYYY	UUUUUUU		MMMMMM
--->
<!--- Tabla Temporal de Errores --->
<cf_dbtemp name="ERRORESIMPASOC" returnvariable="ERRORESIMPASOC" datasource="#session.dsn#">
	<cf_dbtempcol name="IDEmpleado" 	type="varchar(60)" 	mandatory="no">
	<cf_dbtempcol name="CodAporte"		type="varchar(10)" 	mandatory="no">
	<cf_dbtempcol name="SaldoInicial"	type="money" 		mandatory="no">
	<cf_dbtempcol name="SaldoInt" 		type="money" 		mandatory="no">
	<cf_dbtempcol name="AporteMes" 		type="money" 		mandatory="no">
	<cf_dbtempcol name="IntMes" 		type="money" 		mandatory="no">
	<cf_dbtempcol name="Mensaje" 		type="varchar(255)" mandatory="no">
	<cf_dbtempcol name="DatoIncorrecto" type="varchar(40)" 	mandatory="no">
	<cf_dbtempcol name="ErrorNum" 		type="integer" 		mandatory="no">
</cf_dbtemp>

<!--- VALIDA QUE EL ID DEL EMPLEADO NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #ERRORESIMPASOC# (IDEmpleado, CodAporte, SAldoInicial,SaldoInt,AporteMes,IntMes, Mensaje, DatoIncorrecto, ErrorNum)
	select '', CodTipoAporte,SaldoInicialAporte,SaldoInicialInteres,AporteMes,InteresdelAportedeMes,'Identificación Nulas.', IDEmpleado, 100
	from #table_name#
	where IDEmpleado is null
</cfquery>

<!--- VALIDA QUE EL CODIGO DEL APORTE NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #ERRORESIMPASOC# (IDEmpleado, CodAporte, SAldoInicial,SaldoInt,AporteMes,IntMes, Mensaje, DatoIncorrecto, ErrorNum)
	select IDEmpleado, '',SaldoInicialAporte,SaldoInicialInteres,AporteMes,InteresdelAportedeMes,'Código de Tipo de Aporte Nulos.', CodTipoAporte, 200
	from #table_name#	
	where CodTipoAporte is null
</cfquery>
<!--- VALIDA QUE EL SALDO INICIAL DEL APORTE NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #ERRORESIMPASOC# (IDEmpleado, CodAporte, SaldoInicial,SaldoInt,AporteMes,IntMes, Mensaje, DatoIncorrecto, ErrorNum)
	select IDEmpleado, CodTipoAporte,0,SaldoInicialInteres,AporteMes,InteresdelAportedeMes,'Saldo Inicial del Aporte Nulos.', SaldoInicialAporte, 300
	from #table_name#	
	where SaldoInicialAporte is null
</cfquery>
<!--- VALIDA QUE EL SALDO INICIAL DEL APORTE NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #ERRORESIMPASOC# (IDEmpleado, CodAporte, SaldoInicial,SaldoInt,AporteMes,IntMes, Mensaje, DatoIncorrecto, ErrorNum)
	select IDEmpleado, CodTipoAporte,SaldoInicialAporte,0,AporteMes,InteresdelAportedeMes,'Interes del Saldo Inicial del Aporte Nulos.', SaldoInicialInteres, 400
	from #table_name#	
	where SaldoInicialInteres is null
</cfquery>
<!--- VALIDA QUE EL APORTE DEL MES NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #ERRORESIMPASOC# (IDEmpleado, CodAporte, SaldoInicial, SaldoInt, AporteMes,IntMes, Mensaje, DatoIncorrecto, ErrorNum)
	select IDEmpleado, CodTipoAporte,SaldoInicialAporte,SaldoInicialInteres,0,InteresdelAportedeMes,'Aporte del Mes Nulos.', AporteMes, 500
	from #table_name#	
	where AporteMes is null
</cfquery>
<!--- VALIDA QUE EL INTERES DEL APORTE DEL MES NO VENGA EN BLANCO --->
<cfquery datasource="#session.dsn#">
	insert into #ERRORESIMPASOC# (IDEmpleado, CodAporte, SaldoInicial, SaldoInt, AporteMes,IntMes, Mensaje, DatoIncorrecto, ErrorNum)
	select IDEmpleado, CodTipoAporte,SaldoInicialAporte,SaldoInicialInteres,AporteMes,0,'Interés del Aporte del Mes Nulos.', InteresdelAportedeMes, 600
	from #table_name#	
	where InteresdelAportedeMes is null
</cfquery>

<!--- VALIDA QUE EXISTAN LOS EMPLEADOS --->
<cfquery datasource="#session.dsn#">
	insert into #ERRORESIMPASOC# (IDEmpleado, CodAporte, SaldoInicial, SaldoInt, AporteMes,IntMes, Mensaje, DatoIncorrecto, ErrorNum)
	select IDEmpleado, CodTipoAporte, SaldoInicialAporte, SaldoInicialInteres, AporteMes,InteresdelAportedeMes,'El Empleado no Existe.', IDEmpleado, 700
	from #table_name# a
	where not exists(Select 1
					 from DatosEmpleado b
					 where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					   and b.DEidentificacion = a.IDEmpleado)
</cfquery>
<!--- VALIDA QUE EXISTAN EL TIPO DE APORTE --->
<cfquery name="rsDato" datasource="#session.dsn#">
	insert into #ERRORESIMPASOC# (IDEmpleado, CodAporte, SaldoInicial, SaldoInt, AporteMes,IntMes, Mensaje, DatoIncorrecto, ErrorNum)
	select IDEmpleado, CodTipoAporte, SaldoInicialAporte, SaldoInicialInteres, AporteMes,InteresdelAportedeMes,'El tipo de aporte no Existe.', CodTipoAporte, 800
	from #table_name# a
	where not exists(Select 1
					 from ACAportesTipo b
					 where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					   and rtrim(b.ACATcodigo) = rtrim(a.CodTipoAporte))
</cfquery>

<!--- VALIDA QUE NO EXISTAN LOS EMPLEADOS EN LA TABLA DE ASOCIADOS --->
<cfquery name="rsConsulta" datasource="#session.DSN#">
	insert into #ERRORESIMPASOC# (IDEmpleado, CodAporte, SaldoInicial, SaldoInt, AporteMes,IntMes, Mensaje, DatoIncorrecto, ErrorNum)
	Select IDEmpleado, CodTipoAporte, SaldoInicialAporte, SaldoInicialInteres, AporteMes,InteresdelAportedeMes,'El Empleado no está asociado.', IDEmpleado, 900
	from #table_name# a
	where not exists (Select 1 
				  from DatosEmpleado c
				  inner join ACAsociados b 
				  	on b.DEid = c.DEid
				  where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				    and rtrim(a.IDEmpleado) = rtrim(c.DEidentificacion))
</cfquery>
<!--- VALIDA QUE EL EMPLEADO TENGA LA DEDUCCION ASOCIADA --->
<cfquery name="rsConsulta" datasource="#session.DSN#">
	insert into #ERRORESIMPASOC# (IDEmpleado, CodAporte, SaldoInicial, SaldoInt, AporteMes,IntMes, Mensaje, DatoIncorrecto, ErrorNum)
	Select IDEmpleado, CodTipoAporte, SaldoInicialAporte, SaldoInicialInteres, AporteMes,InteresdelAportedeMes,'El Empleado no tiene la Deducción Asociadas.', IDEmpleado, 900
	from #table_name# a, ACAportesTipo x
	where not exists (select 1
					from ACAportesTipo c, DeduccionesEmpleado b, DatosEmpleado d
					where c.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					  and c.TDid is not null
					  and rtrim(c.ACATcodigo) = rtrim(a.CodTipoAporte)
					  and b.TDid = c.TDid
					  and rtrim(a.IDEmpleado) = rtrim(d.DEidentificacion)
					  and d.Ecodigo = c.Ecodigo
					  and b.DEid = d.DEid
					  and d.Ecodigo = c.Ecodigo
					  and b.DActivo = 1)
	  and rtrim(x.ACATcodigo) = rtrim(a.CodTipoAporte)
	  and x.TDid is not null
</cfquery>

<!--- VALIDA QUE EL EMPLEADO TENGA LA CARGA ASOCIADA --->
<cfquery name="rsConsulta" datasource="#session.DSN#">
	insert into #ERRORESIMPASOC# (IDEmpleado, CodAporte, SaldoInicial, SaldoInt, AporteMes,IntMes, Mensaje, DatoIncorrecto, ErrorNum)
	Select IDEmpleado, CodTipoAporte, SaldoInicialAporte, SaldoInicialInteres, AporteMes,InteresdelAportedeMes,'El Empleado no tiene la Carga Asociadas.', IDEmpleado, 900
	from #table_name# a, ACAportesTipo x
	where not exists (select 1
					from ACAportesTipo c, CargasEmpleado b, DatosEmpleado d
					where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					  and c.DClinea is not null
					  and rtrim(c.ACATcodigo) = rtrim(a.CodTipoAporte)
					  and b.DClinea = c.DClinea
					  and  rtrim(a.IDEmpleado) = rtrim(d.DEidentificacion)
					  and d.Ecodigo = c.Ecodigo
					  and b.DEid = d.DEid)
	  and rtrim(x.ACATcodigo) = rtrim(a.CodTipoAporte)
	  and x.DClinea is not null
</cfquery>

<!--- VALIDA QUE EL EMPLEADO NO TENGA LA CUENTA YA REGISTRADA --->
<cfquery name="rsConsulta" datasource="#session.DSN#">
	insert into #ERRORESIMPASOC# (IDEmpleado, CodAporte, SaldoInicial, SaldoInt, AporteMes,IntMes, Mensaje, DatoIncorrecto, ErrorNum)
	Select IDEmpleado, CodTipoAporte, SaldoInicialAporte, SaldoInicialInteres, AporteMes,InteresdelAportedeMes,'El Empleado ya esta registrado en las cuentas de ahorro', IDEmpleado, 900
	from #table_name# a
	where exists (Select 1 
				  from DatosEmpleado c,ACAsociados b ,ACAportesTipo d, ACAportesAsociado e
				  where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				    and rtrim(a.IDEmpleado) = rtrim(c.DEidentificacion)
					and b.DEid = c.DEid
					and rtrim(d.ACATcodigo) = rtrim(a.CodTipoAporte)
					and e.ACAid = b.ACAid
					and e.ACATid = d.ACATid)
</cfquery>
<!--- Devuelve errores si los hay --->
<cfquery name="err" datasource="#session.dsn#"> 
	select IDEmpleado, CodAporte, SaldoInicial, SaldoInt, AporteMes,IntMes, Mensaje, DatoIncorrecto, ErrorNum
	from #ERRORESIMPASOC#
	order by IDEmpleado,ErrorNum
</cfquery>

<cfif err.recordcount eq 0>
	<cfquery name="r" datasource="#session.dsn#">
		select IDEmpleado, SaldoInicialAporte, SaldoInicialInteres, AporteMes,InteresdelAportedeMes,
			b.DEid, ACAid, ACATid, DClinea, TDid, ACATorigen,ACATdescripcion,ACATtipo
		from #table_name# a
		inner join DatosEmpleado b
			on b.DEidentificacion = a.IDEmpleado
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		inner join ACAsociados c
			on c.DEid = b.DEid
		inner join ACAportesTipo d
			on rtrim(d.ACATcodigo) = rtrim(a.CodTipoAporte)
	</cfquery>
	<cfinvoke component="rh.asoc.Componentes.ACParametros" 	method="init" returnvariable="Parametros">
	<cfinvoke component="rh.asoc.Componentes.ACDeducciones" method="init" returnvariable="Deducciones">
	<cfloop query="r">
		<cfset Lvar_Did = 0>
		<cfset Lvar_DClinea = 0>
		<cfset Lvar_ACAAtipo = 'M'>
		<cfset Lvar_ACAAporcentaje = 0>
		<cfset Lvar_ACAAmonto = 0>
		<cfset Lvar_ACAAfechaInicio = LSDateFormat(now(),'dd/mm/yyyy')>
		<cfif LEN(TRIM(r.TDid))>
			<!--- SE BUSCA LA ULTIMA DEDUCCION DEL TIPO DEL APORTE --->
			<cfquery name="rsDid" datasource="#session.DSN#">
				select max(Did) as Did
				from DeduccionesEmpleado 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#r.DEid#">
				  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#r.TDid#">
				  and Dactivo = 1
				  and DFEchaIni = (select max(DFechaIni)
									from DeduccionesEmpleado 
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
									  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#r.DEid#">
									  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#r.TDid#">
									  and Dactivo = 1)
			</cfquery>
			<cfif rsDid.RecordCount and rsDid.Did GT 0>
				<cfset Lvar_Did = rsDid.Did>
				<cfinvoke component="rh.asoc.Componentes.ACDeducciones" method="init" returnvariable="Deducciones">
				<cfset rsDeduccion = Deducciones.getDeduccionesEmpleadoByDid(Lvar_Did)>
				<cfset Lvar_Did = rsDeduccion.Did>
				<cfset Lvar_DClinea = 0>
				<cfif rsDeduccion.Dmetodo EQ 0><cfset Lvar_ACAAtipo = 'P'><cfelse><cfset Lvar_ACAAtipo = 'M'></cfif>
				<cfif rsDeduccion.Dmetodo EQ 0><cfset Lvar_ACAAporcentaje = rsDeduccion.Dvalor><cfelse><cfset Lvar_ACAAporcentaje = 0.00></cfif>
				<cfif rsDeduccion.Dmetodo EQ 0><cfset Lvar_ACAAmonto =0.00><cfelse><cfset Lvar_ACAAmonto = 0.00></cfif>
				<cfif LEN(TRIM(rsDeduccion.Dfechaini))><cfset Lvar_ACAAfechaInicio = rsDeduccion.Dfechaini></cfif>
			</cfif>
		<cfelseif LEN(TRIM(r.DClinea))>
			<!--- CARGA ASOCIADA AL TIPO DE APORTE --->
			<cfinvoke component="rh.asoc.Componentes.ACCargas" method="init" returnvariable="Cargas">
			<cfset rsCarga = Cargas.getCargasEmpleado(r.DEid,r.DClinea)>
			<cfset Lvar_Did = 0>
			<cfset Lvar_DClinea = rsCarga.DClinea>
			<cfif rsCarga.DCmetodo EQ 0><cfset Lvar_ACAAtipo = 'M'><cfelse><cfset Lvar_ACAAtipo = 'P'></cfif>
			<cfif rsCarga.DCmetodo GT 0><cfif r.ACATorigen EQ 'O'><cfset Lvar_ACAAporcentaje = rsCarga.DCvaloremp><cfelse><cfset Lvar_ACAAporcentaje = rsCarga.DCvalorpat></cfif><cfelse><cfset Lvar_ACAAporcentaje = 0.00></cfif>
			<cfif rsCarga.DCmetodo GT 0><cfif r.ACATorigen EQ 'O'><cfset Lvar_ACAAmonto = rsCarga.DCvaloremp><cfelse><cfset Lvar_ACAAmonto = rsCarga.DCvalorpat></cfif><cfelse><cfset Lvar_ACAAmonto = 0.00></cfif>
			<cfif LEN(TRIM(rsCarga.CEdesde))><cfset Lvar_ACAAfechaInicio = rsCarga.CEdesde></cfif>
		</cfif>
  		<cfinvoke component="rh.asoc.Componentes.ACAportesAsociado" method="Alta" returnvariable="ACAAid"
			ACAid="#r.ACAid#" ACATid="#r.ACATid#" ACAAtipo="#Lvar_ACAAtipo#" ACAAporcentaje="#Lvar_ACAAporcentaje#" 
			ACAAmonto="#Lvar_ACAAmonto#" ACAAfechaInicio="#Lvar_ACAAfechaInicio#" Did="#Lvar_Did#" DClinea="#Lvar_DClinea#"/> 
		<cfset Lvar_Periodo 	= Parametros.Get("10",	"Periodo")>
        <cfset Lvar_Mes 		= Parametros.Get("20",	"Mes")>
		<cfquery name="UpdateSaldos" datasource="#session.DSN#">
			update ACAportesSaldos
			set ACAAsaldoInicial 	= <cfqueryparam cfsqltype="cf_sql_money" value="#r.SaldoInicialAporte#">,
				ACAAaporteMes 	 	= <cfqueryparam cfsqltype="cf_sql_money" value="#r.AporteMes#">,
				ACAAsaldoInicialInt = <cfqueryparam cfsqltype="cf_sql_money" value="#r.SaldoInicialInteres#">,
				ACAAaporteMesInt 	= <cfqueryparam cfsqltype="cf_sql_money" value="#r.InteresdelAportedeMes#">
			where ACAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ACAAid#">
			  and ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">
			  and ACASmes  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">
		</cfquery>
	</cfloop>
</cfif>
