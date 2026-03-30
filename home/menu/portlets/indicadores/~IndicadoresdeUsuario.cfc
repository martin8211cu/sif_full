<cfcomponent>
	<cffunction name="IndicadoresdeUsuario" access="public" returntype="query" output="true"><!----returntype="string" ----->
		<!---- Definición de Parámetros --->
		<cfargument name='Usuario'	type='numeric' 	required='true'>	 	<!--- Codigo del usuario ---->
		<cfargument name='Conexion' type='string' 	required='false'>		<!--- Conexion a la BD's---->
		
		<cfif (not isdefined("arguments.Conexion"))>
			<cfset arguments.Conexion = 'asp' >
		</cfif>

		<cftransaction>
			<cfquery name="indicadores" datasource="#Arguments.Conexion#">
				select 	a.indicador,
						b.parametro,
						b.valor
				from IndicadorUsuario a
					left outer join IndicadorArgumento b
						on a.Usucodigo = b.Usucodigo
						and a.indicador = b.indicador
				where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usuario#">
			</cfquery>				
		</cftransaction>	
		<cfreturn indicadores> 
	</cffunction>
</cfcomponent>