<cfcomponent>

	<!---
		This.guardar (datasource, indicador, Ecodigo, CEcodigo, fecha, parametros, texto, valor) 
		
		Guarda un registro en la tabla de valores de los Indicadores
		datasource        Nombre del cache por utilizar. Corresponde al session.dsn
		indicador         Código del indicador por almacenar. Llave en la tabla Indicador en ASP
		Ecodigo           Ecodigo local de la empresa. Corresponde al session.Ecodigo
		CEcodigo          CEcodigo de la empresa
		fecha             Fecha de la cual se está almacenando el indicador.
		parametros        Lista de valores de los parametros específicos del indicador, separados por
		                  coma.  Los valores deben estar ordenados por nombre del parámetro.
						  Ejemplo: Ocodigo=15,DEid=4832 se escribiría como "4832,15"
		texto             Texto correspondiente a la descripción de los parámetros, si es que aplica.
		                  Puede contener la descripción de la Oficina, por ejemplo, si en "parametros"
						  se envió un código de oficina.
		valor             Valor numérico del indicador.
		
	--->
<cffunction name="guardar">
	<cfargument name="datasource" type="string"  required="yes" >
	<cfargument name="indicador"  type="string"  required="yes" >
	<cfargument name="Ecodigo"    type="numeric" required="yes" >
	<cfargument name="CEcodigo"   type="numeric" required="yes" >
	<cfargument name="fecha"      type="date"    required="yes" >
	<cfargument name="parametros" type="string"  required="yes" default="-">
	<cfargument name="texto"      type="string"  required="yes" default=" ">
	<cfargument name="valor"      type="numeric" required="yes" default="0">
	
	<cfset Arguments.fecha = CreateDate(Year(Arguments.fecha), Month(Arguments.fecha), Day(Arguments.fecha)) >
	
	<cfquery datasource="#Arguments.datasource#" name="current_values">
		select texto, valor
		from IndicadorValor
		where indicador  = <cfqueryparam cfsqltype="cf_sql_char"      value="#Arguments.indicador#">
		  and Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer"   value="#Arguments.Ecodigo#">
		  and CEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.CEcodigo#">
		  and fecha      = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha#">
		  and parametros = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Arguments.parametros#">
	</cfquery>

	<cfif IsDefined('session.Usucodigo')>
		<cfset Usucodigo_Guardar = session.Usucodigo>
	<cfelse>
		<cfset Usucodigo_Guardar = 0>
	</cfif>
	<cfif current_values.RecordCount Is 0>
		<cfquery datasource="#Arguments.datasource#">
			insert into IndicadorValor (indicador, Ecodigo, CEcodigo, fecha, parametros, texto, valor, BMfecha, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_char"      value="#Arguments.indicador#">,
				<cfqueryparam cfsqltype="cf_sql_integer"   value="#Arguments.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Arguments.parametros#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Arguments.texto#">,
				<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Arguments.valor#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric"   value="#Usucodigo_Guardar#">)
		</cfquery>
	<cfelseif Trim(current_values.texto) Neq Trim(Arguments.texto) Or Trim(current_values.valor) Neq Trim(Arguments.valor)>
		<cfquery datasource="#Arguments.datasource#">
			update IndicadorValor
			set texto        = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Arguments.texto#">
			,   valor        = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Arguments.valor#">
			,   BMfecha      = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			,   BMUsucodigo  = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Usucodigo_Guardar#">
			where indicador  = <cfqueryparam cfsqltype="cf_sql_char"      value="#Arguments.indicador#">
			  and Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer"   value="#Arguments.Ecodigo#">
			  and CEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.CEcodigo#">
			  and fecha      = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha#">
			  and parametros = <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Arguments.parametros#">
		</cfquery>
	</cfif>

</cffunction>

<cffunction name="obtenerEmpleado" returntype="string" >
	<cfargument name="Usucodigo" required="yes" type="string">
	<cfargument name="Ecodigo" required="yes" type="string">
	
	<cfquery name="data" datasource="asp">
		select llave 
		from UsuarioReferencia 
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#" >
		   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#" >
		  and STabla='DatosEmpleado'
	</cfquery>
	<cfreturn trim(data.llave) >
</cffunction>

<cffunction name="obtenerFiltros" returntype="query" >
	<cfargument name="Usucodigo" required="yes" type="string">
	<cfargument name="Ecodigo" required="yes" type="string">
	<cfargument name="EcodigoSDC" required="yes" type="string">
	<cfargument name="dsn" required="yes" type="string">

	<cfset DEid = this.obtenerEmpleado(arguments.Usucodigo, arguments.EcodigoSDC) >

	<cfif len(trim(DEid))>
		<cfquery name="data" datasource="#arguments.dsn#">
			select b.CFid, c.CFdescripcion, a.Ocodigo, d.Odescripcion, a.Dcodigo, e.Ddescripcion
			from LineaTiempo a
			
			inner join RHPlazas b
			on a.RHPid=b.RHPid
			and a.Ecodigo=b.Ecodigo
			
			inner join CFuncional c
			on b.CFid=c.CFid
			and b.Ecodigo=c.Ecodigo
			
			inner join Oficinas d
			on a.Ocodigo=d.Ocodigo
			and a.Ecodigo=d.Ecodigo
	
			inner join Departamentos e
			on a.Dcodigo=e.Dcodigo
			and a.Ecodigo=e.Ecodigo
	
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#" >
			  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between LTdesde and LThasta 
		</cfquery>
	<cfelse>
		<cfset data = QueryNew('CFid,CFdescripcion,Ocodigo,Odescripcion,Dcodigo,Ddescripcion') >
	</cfif>

	<cfreturn data >
</cffunction>

<cffunction name="indicador_tiempos" returntype="query">
	<cfinvoke component="IndicadorTiempos" method="indicador_tiempos" returnvariable="tm" />
	<cfreturn tm>
</cffunction>


<cffunction name="init">
	<cfreturn this >
</cffunction>


<cffunction name="limpiar">
	<cfargument name="datasource"  type="string"  required="yes" >
	<cfargument name="indicador"   type="string"  required="yes" >
	<cfargument name="Ecodigo"     type="numeric" required="yes" >
	<cfargument name="CEcodigo"    type="numeric" required="yes" >
	<cfargument name="fecha_desde" type="date"    required="yes" >
	<cfargument name="fecha_hasta" type="date"    required="yes" >


	<cfquery name="comportamientos_rs" datasource="#Arguments.datasource#">
		delete IndicadorValor
		where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.indicador#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
		  and fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_desde#">
		                and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_hasta#">
	</cfquery>
</cffunction>


<cffunction name="temptable" returntype="string">
	<cfargument name="tablenum" type="numeric" default="1">
	<cfargument name="datasource">

	<cf_dbtemp name="indt#Arguments.tablenum#" returnvariable="temptable_name" datasource="#Arguments.datasource#">
		<cf_dbtempcol name="CFid" type="numeric">
		<cf_dbtempcol name="Ocodigo" type="numeric">
		<cf_dbtempcol name="Dcodigo" type="numeric">
		<cf_dbtempcol name="fecha" type="datetime">
		<cf_dbtempcol name="valor" type="numeric(18,6)">
		
		<cf_dbtempkey cols="CFid,Ocodigo,Dcodigo,fecha">
	</cf_dbtemp>
	
	<cfreturn temptable_name>
</cffunction>

<cffunction name="consolidar">
	<cfargument name="datasource"  type="string"  required="yes" >
	<cfargument name="indicador"   type="string"  required="yes" >
	<cfargument name="Ecodigo"     type="numeric" required="yes" >
	<cfargument name="CEcodigo"    type="numeric" required="yes" >
	<cfargument name="fecha_desde" type="date"    required="yes" >
	<cfargument name="fecha_hasta" type="date"    required="yes" >
	
	<cfquery datasource="#Arguments.datasource#">
		delete from IndicadorValorEmp
		where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.indicador#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
		  and fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_desde#">
		                and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_hasta#">
	</cfquery>
	
	<cfquery datasource="#Arguments.datasource#">
		insert into IndicadorValorEmp (
			indicador, Ecodigo, CEcodigo, fecha,
			valor, total, 
			peso_valor, peso_total)
		select
			indicador, Ecodigo, CEcodigo, fecha,
			sum(valor), sum(total),
			sum(peso_valor), sum(peso_total)
		from IndicadorValor
		where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.indicador#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
		  and fecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_desde#">
		                and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha_hasta#">
		group by 
			indicador, Ecodigo, CEcodigo, fecha
	</cfquery>
	
</cffunction>

</cfcomponent>