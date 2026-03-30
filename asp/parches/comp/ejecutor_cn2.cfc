<cfcomponent extends="ejecutor" hint="Valida que el conteo de datos de igual">
	
	<cffunction name="ejecuta" hint="Ejecuta la tarea" output="false">
		<cfargument name="num_tarea" type="numeric" required="yes">

		<cfset This.inicio(num_tarea, 'Inicio')>
		
		<cfquery datasource="asp" name="tablas">
			select datasource, tabla, antes
			from APConteo
			where instalacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
			order by datasource, tabla
		</cfquery>
		
		<cfloop query="tablas">
			<cftry>
				<cfquery datasource="#datasource#" name="contar">
					select count(1) as cuenta
					from #tabla#
				</cfquery>
				<cfset contar = contar.cuenta>
			<cfcatch type="any">
				<cfset contar = "">
				<cfset This.logmsg(Arguments.num_tarea, datasource & '.' & tabla, This.WARN,
					cfcatch.Message, cfcatch.Detail)>
			</cfcatch>
			</cftry>
			
			<cfif Len(antes) and (antes neq contar)>
				<cfset This.logmsg(Arguments.num_tarea, datasource & '.' & tabla, This.WARN,
					contar & ' registros, esperaba ' & antes)>
			<cfelseif Len(contar)>
				<cfset This.logmsg(Arguments.num_tarea, datasource & '.' & tabla, This.DEBUG,
					'Cantidad de registros: ' & contar)>
			</cfif>
			<cfquery datasource="asp">
				update APConteo 
				set despues = <cfqueryparam cfsqltype="cf_sql_integer" value="#contar#" null="#Len(contar) EQ 0#">
				where instalacion = 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
				  and datasource = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datasource#">
				  and tabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tabla#">
			</cfquery>
		</cfloop>
		<cfset This.fin(num_tarea)>
	</cffunction>

</cfcomponent>
