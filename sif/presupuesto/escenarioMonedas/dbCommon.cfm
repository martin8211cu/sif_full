<!--- Obtiene la información de un escenario --->
<cffunction name="getCVTCEscenario" access="public" returntype="query">
	<cfargument name="CVTid" type="numeric" required="true">
	<cfquery name="rs" datasource="#session.dsn#">
		select CVTid, CVTdescripcion, CVTtipo, CVTaplicado, ts_rversion, 
				' ' as ts
		from CVTipoCambioEscenario
		where Ecodigo = #session.ecodigo#
		and CVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cvtid#">
	</cfquery>
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rs.ts_rversion#" returnvariable="ts">
	<cfset QuerySetCell(rs,'ts',ts)>
	<cfreturn rs>
</cffunction>
<!--- Obtiene la información de un escenario --->
<cffunction name="getCVTCEscenarios" access="public" returntype="query">
	<cfargument name="filtrar_by_descripcion" type="string" required="no" default="">
	<cfargument name="filtrar_by_tipo" type="string" required="no" default="">
	<cfquery name="rs" datasource="#session.dsn#">
		select CVTid, CVTdescripcion, CVTtipo, CVTaplicado, 
			case CVTtipo 
				when 'N' then 'Normal' 
				when 'O' then 'Optimista' 
				when 'P' then 'Pesimista' 
			end as tipo,
			case CVTaplicado 
				when 1 then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>' 
				when 0 then '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>' 
			end as aplicado
		from CVTipoCambioEscenario
		where Ecodigo = #session.ecodigo#
		<cfif isdefined("Arguments.filtrar_by_descripcion") and len(Arguments.filtrar_by_descripcion)>
			and upper(CVTdescripcion) like '%#Ucase(Arguments.filtrar_by_descripcion)#%'
		</cfif>
		<cfif isdefined("Arguments.filtrar_by_tipo") and len(Arguments.filtrar_by_tipo)>
			and upper(CVTtipo) = '#Ucase(Arguments.filtrar_by_tipo)#'
		</cfif>
	</cfquery>
	<cfreturn rs>
</cffunction>
<!--- Obtiene el tipo de cambio de un escenario para un año / mes / moneda --->
<cffunction name="getCVTCEscenarioMes" access="public" returntype="query">
	<cfargument name="CVTid" type="numeric" required="true">
	<cfargument name="CPCano" type="numeric" required="true">
	<cfargument name="CPCmes" type="numeric" required="true">
	<cfargument name="Mcodigo" type="numeric" required="true">
	<cfquery name="rs" datasource="#session.dsn#">
		select 	a.Ecodigo, a.CVTid, a.CPCano, a.CPCmes, a.Mcodigo, b.Mnombre, a.CPTipoCambioCompra, a.CPTipoCambioVenta, a.ts_rversion, 
				' ' as ts
		from CVTipoCambioEscenarioMes a inner join Monedas b on b.Ecodigo = a.Ecodigo and b.Mcodigo = a.Mcodigo
		where a.Ecodigo = #session.ecodigo#
			and a.CVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cvtid#">
			and a.CPCano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cpcano#">
			and a.CPCmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cpcmes#">
			and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mcodigo#">
	</cfquery>
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rs.ts_rversion#" returnvariable="ts">
	<cfset QuerySetCell(rs,'ts',ts)>
	<cfreturn rs>
</cffunction>
<!--- Obtiene los tipos de cambio por moneda o por mes para un escenario y un año. --->
<cffunction name="getCVTCEscenarioMesMonedas" access="public" returntype="query">
	<cfargument name="CVTid" type="numeric" required="true">
	<cfargument name="CPCano" type="numeric" required="true">
	<cfargument name="CPCmes" type="numeric" required="false">
	<cfargument name="Mcodigo" type="numeric" required="false">
	<cfargument name="PAGENUM" type="numeric" required="false">
	<cfquery name="rs" datasource="#session.dsn#">
		select a.Ecodigo, a.CVTid, a.CPCano, a.CPCmes, a.Mcodigo, b.Mnombre, a.CPTipoCambioCompra, a.CPTipoCambioVenta, 
				'*' as mes<cfif isdefined("arguments.PAGENUM")>, #arguments.PAGENUM# as PAGENUM</cfif>, 1 AS btnMeses
		from CVTipoCambioEscenarioMes a 
			inner join Monedas b 
				 on b.Ecodigo = a.Ecodigo 
				and b.Mcodigo = a.Mcodigo
		where a.Ecodigo = #session.ecodigo#
			and a.CVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cvtid#">
			and a.CPCano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cpcano#">
			<cfif isdefined("Arguments.CPCmes") and len(Arguments.CPCmes) and Arguments.CPCmes>
				and a.CPCmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CPCmes#">
			</cfif>
			<cfif isdefined("Arguments.Mcodigo") and len(Arguments.Mcodigo) and Arguments.Mcodigo  and Arguments.Mcodigo NEQ -1>
				and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
			</cfif>
			order by a.Mcodigo
	</cfquery>
	<cfset rs = convertMes(rs,'CPCmes','mes')>
	<cfreturn rs>
</cffunction>
<!--- Obtiene los años en un escenario para una moneda --->
<cffunction name="getAnosFromEscenario" access="public" returntype="query">
	<cfargument name="CVTid" type="numeric" required="true">
	<cfquery name="rs" datasource="#session.dsn#">
		select distinct CPCano as ano
		from CVTipoCambioEscenarioMes
		where Ecodigo = #session.ecodigo#
			and CVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cvtid#">
		order by CPCano
	</cfquery>
	<cfreturn rs>
</cffunction>
<!--- Obtiene las monedas de una empresa --->
<cffunction name="getMonedas" access="public" returntype="query">
	<cfargument name="CVTid" type="numeric" required="true">
	<cfquery name="rs" datasource="#session.dsn#">
		Select distinct a.Mcodigo, b.Mnombre
		from CVTipoCambioEscenarioMes a 
			inner join Monedas b 
				 on a.Ecodigo = b.Ecodigo 
				and a.Mcodigo = b.Mcodigo
		where a.Ecodigo = #session.ecodigo#
			and a.CVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cvtid#">
		order by Mnombre
	</cfquery>
	<cfreturn rs>
</cffunction>
<!--- Convierte el número de mes y le pone la descripción en el campo especificado --->
<cffunction name="convertMes" access="public" returntype="query">
	<cfargument name="rs" type="query" required="true">
	<cfargument name="campoorig" type="string" required="true">
	<cfargument name="campodest" type="string" required="true">
	<cfquery name="rsMeses" datasource="sifControl">
		select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
		from Idiomas a, VSidioma b 
		where a.Icodigo = '#Session.Idioma#'
		and b.VSgrupo = 1
		and a.Iid = b.Iid
		order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
	</cfquery>
	<cfloop query="rs">
		<cfquery name="rsMes" dbtype="query">
			select *
			from rsMeses
			where Pvalor = #rs.CPCmes#
		</cfquery>
		<cfset QuerySetCell(rs,campodest,rsMes.Pdescripcion,CurrentRow)>
	</cfloop>
	<cfreturn rs>
</cffunction>
