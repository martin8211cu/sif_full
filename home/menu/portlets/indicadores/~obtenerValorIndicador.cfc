<cfcomponent>
	<cffunction name="obtenerValorIndicador" access="public" returntype="query" output="true"><!----returntype="string" ----->
		<!---- Definición de Parámetros --->
		<cfargument name='indicador'	type='string' 	required='true'>	
		<cfargument name='parametro'	type='string' 	required='true'>	
		<cfargument name='Conexion' 	type='string' 	required='false'>

		<!--- Obtener el valor de parametro (quitarle la primera coma, porque se recibe ,valor1,valor2,valor3---->		
		<cfset vsParam=''>
		<cfset vsParam = Mid(Arguments.parametro,2,len(Arguments.parametro))>

		<cfif (not isdefined("arguments.Conexion"))>
			<cfset arguments.Conexion = session.dsn>
		</cfif>
		
		<cftransaction>
			<!---and fecha <= (select max(fecha)
				from IndicadorValor
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.indicador = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.indicador#">
					and parametros = <cfqueryparam cfsqltype="cf_sql_char" value="#vsParam#">	
				)--->		
			<!--- Se seleccionan los 2 ultimos registros (2 ultimas fechas)---->	
			<cfquery name="valores" datasource="#Arguments.Conexion#" maxrows="2">
				select 	a.texto,
						a.valor,						
						a.fecha,
						'#vsParam#'as vsParam
				from IndicadorValor a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.indicador = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.indicador#">
					and parametros = <cfqueryparam cfsqltype="cf_sql_char" value="#vsParam#">
				order by fecha desc				
			</cfquery>			
		</cftransaction>											
		<cfreturn valores> 
	</cffunction>
</cfcomponent>