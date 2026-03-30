<cfcomponent extends="ejecutor" hint="Realiza el conteo de datos inicial">
	
	<cffunction name="ejecuta" hint="Ejecuta la tarea" output="false">
		<cfargument name="num_tarea" type="numeric" required="yes">

		<cfset This.inicio(num_tarea, 'Inicio')>
		
		<cfquery datasource="asp">
			delete from APConteo 
			where instalacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
		</cfquery>
		
		<cfset tablas = XMLSearch(get_xml(), '//tabla')>
		
		<cfloop from="1" to="#ArrayLen(tablas)#" index="i">
				<cfset esquema = tablas[i].XmlAttributes.esquema>
				<cfset tabla = tablas[i].XmlAttributes.nombre>
			
				<cfinvoke component="asp.parches.comp.misc" method="esquema2dslist"
					esquema="#esquema#"
					returnvariable="dslist" />
				<cfloop list="#dslist#" index="ds">
					<cftry>
						<cfquery datasource="#ds#" name="contar">
							select count(1) as cuenta
							from #tabla#
						</cfquery>
						<cfset contar = contar.cuenta>
					<cfcatch type="any">
						<cfset contar = "">
						<cfset This.logmsg(Arguments.num_tarea, ds & '.' & tabla, This.WARN,
							cfcatch.Message, cfcatch.Detail)>
					</cfcatch>
					</cftry>
					<cfif Len(contar)>
						<cfset This.logmsg(Arguments.num_tarea, ds & '.' & tabla, This.DEBUG,
							'Cantidad de registros: ' & contar)>
					</cfif>
					<cfquery datasource="asp">
						insert into APConteo 
							(instalacion, datasource, tabla, esquema, antes, despues)
						values (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#ds#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#tabla#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#esquema#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#contar#" null="#Len(contar) EQ 0#">,
							<cfqueryparam cfsqltype="cf_sql_integer" null="yes"> )
					</cfquery>
				</cfloop>
		
		</cfloop>
		
		<!--- permitir trabajar al gc --->
		<cfset tablas = ''>
		<cfset This.fin(num_tarea)>
	</cffunction>

</cfcomponent>
