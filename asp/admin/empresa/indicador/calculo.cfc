<cfcomponent output="no">
<cfset This.indicadores = 'empleados,asientos,ingresos,egresos,bancos'>
<cfset This.ind_desc = 'Empleados activos,Asientos aplicados en un día,Transacciones diarias Ingreso,Transacciones diarias Egreso,Transacciones Bancos'>

<!---calcular--->
<cffunction name="calcular" output="false" access="public" returntype="void">
	<cfargument name="Ecodigo" type="numeric" default="0">
	<cfargument name="fecha" type="date" default="#Now()#">
	
	<cfset fecha = CreateDate(Year(fecha), Month(fecha), Day(fecha))>
	
	<cfquery datasource="aspmonitor">
		delete from MonEmpresaStats
		where fecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">
		<cfif Arguments.Ecodigo>
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		</cfif>
	</cfquery>
	
	<cfquery datasource="asp" name="emp_q">
		select e.CEcodigo, e.Ecodigo, e.Enombre, c.Ccache, e.Ereferencia
		from Empresa e
				join Caches c
					on e.Cid = c.Cid
				join CuentaEmpresarial ce
					on ce.CEcodigo = e.CEcodigo
			where c.Ccache in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyList(Application.dsinfo)#" list="yes">)
			  and e.Ereferencia is not null
			<cfif Arguments.Ecodigo>
			  and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfif>
	</cfquery>
	
	<cfloop query="emp_q">
		<cfset url.rc = CurrentRow>
		<cfloop list="#This.indicadores#" index="indicador">
			<cfset url.ind = indicador>
			<cftry>
				<cfset Evaluate("valor = indicador_#indicador#(emp_q.Ccache, emp_q.Ereferencia, Arguments.fecha)")>
				<cfset guardar_indicador(emp_q.CEcodigo, emp_q.Ecodigo, Arguments.fecha, indicador, valor)>
			<cfcatch type="any">
				<!--- ignorar errores, no guardar el valor --->
			</cfcatch></cftry>
		</cfloop>
	</cfloop>
</cffunction>

<!---guardar_indicador--->
<cffunction name="guardar_indicador" output="false" access="private" returntype="void">
	<cfargument name="CEcodigo" type="numeric" required="yes">
	<cfargument name="Ecodigo" type="numeric" required="yes">
	<cfargument name="fecha" type="date" required="yes">
	<cfargument name="indicador" type="string" required="yes">
	<cfargument name="valor" type="numeric" required="yes">
	
	<cfquery datasource="aspmonitor">
		insert into MonEmpresaStats (CEcodigo, Ecodigo, fecha, indicador, valor)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.indicador#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.valor#">)
	</cfquery>
</cffunction>

<!--- indicador_empleados (Nómina) --->
<cffunction name="indicador_empleados" output="false" access="private" returntype="numeric">
	<cfargument name="datasource" type="string" required="yes">
	<cfargument name="Ereferencia" type="numeric" required="yes">
	<cfargument name="fecha" type="date" required="yes">
	<!--- Calcula la cantidad de empleados activos en una empresa para una fecha dada --->
	<cfquery datasource="#Arguments.datasource#" name="valor_q">
		select count(1) as valor
		from LineaTiempo lt
		where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ereferencia#">
		  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha#"> between lt.LTdesde and lt.LThasta
	</cfquery>
	<cfreturn valor_q.valor>
</cffunction>

<!--- indicador_asientos (Contabilidad) --->
<cffunction name="indicador_asientos" output="false" access="private" returntype="numeric">
	<cfargument name="datasource" type="string" required="yes">
	<cfargument name="Ereferencia" type="numeric" required="yes">
	<cfargument name="fecha" type="date" required="yes">
	<cfquery datasource="#Arguments.datasource#" name="valor_q">
		select count(1) as valor
		from HEContables
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ereferencia#">
		  and ECfechaaplica >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha#">
		  and ECfechaaplica < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Arguments.fecha)#">
	</cfquery>
	<cfreturn valor_q.valor>
</cffunction>

<!--- indicador_ingresos --->
<cffunction name="indicador_ingresos" output="false" access="private" returntype="numeric">
	<cfargument name="datasource" type="string" required="yes">
	<cfargument name="Ereferencia" type="numeric" required="yes">
	<cfargument name="fecha" type="date" required="yes">
	<cfquery datasource="#Arguments.datasource#" name="valor_q">
		select count(1) as valor
		from BMovimientos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ereferencia#">
		  and ECfechaaplica >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha#">
		  and ECfechaaplica < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Arguments.fecha)#">
	</cfquery>
	<cfreturn valor_q.valor>
</cffunction>

<!--- indicador_egresos --->
<cffunction name="indicador_egresos" output="false" access="private" returntype="numeric">
	<cfargument name="datasource" type="string" required="yes">
	<cfargument name="Ereferencia" type="numeric" required="yes">
	<cfargument name="fecha" type="date" required="yes">
	<cfquery datasource="#Arguments.datasource#" name="valor_q">
		select count(1) as valor
		from BMovimientosCxP
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ereferencia#">
		  and ECfechaaplica >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha#">
		  and ECfechaaplica < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Arguments.fecha)#">
	</cfquery>
	<cfreturn valor_q.valor>
</cffunction>

<!--- indicador_bancos --->
<cffunction name="indicador_bancos" output="false" access="private" returntype="numeric">
	<cfargument name="datasource" type="string" required="yes">
	<cfargument name="Ereferencia" type="numeric" required="yes">
	<cfargument name="fecha" type="date" required="yes">
	<cfquery datasource="#Arguments.datasource#" name="valor_q">
		select count(1) as valor
		from MLibros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ereferencia#">
		  and ECfechaaplica >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.fecha#">
		  and ECfechaaplica < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, Arguments.fecha)#">
	</cfquery>
	<cfreturn valor_q.valor>
</cffunction>

</cfcomponent>