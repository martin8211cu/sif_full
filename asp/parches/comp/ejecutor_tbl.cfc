<cfcomponent extends="ejecutor" hint="Valida que la estructura de las tablas generadas coincida con lo esperado">
	
	<cffunction name="ejecuta" hint="Ejecuta un archivo SQL" output="false">
		<cfargument name="num_tarea" type="numeric" required="yes">

		<cfset This.inicio(num_tarea, 'Inicio')>
		
		<cfset tablas = XmlSearch(get_xml(),'//tabla')>
		
		<cfloop from="1" to="#ArrayLen(tablas)#" index="i">
			<cfset tabla = tablas[i]>
			<cfset nombre = tabla.XmlAttributes.nombre>
			<cfset esquema = tabla.XmlAttributes.esquema>
			
			<cfinvoke component="asp.parches.comp.misc" method="esquema2dslist"
				esquema="#esquema#" returnvariable="dslist"/>
			
			<cfinvoke component="asp.parches.comp.dbmetadata" method="get_table_from_xml"
				tabla="#tabla#" returnvariable="xmlmd"/>
			
			<cfloop list="#dslist#" index="ds">
				<cfinvoke component="asp.parches.comp.dbmetadata" method="get_table"
					datasource="#ds#" objname="#nombre#" returnvariable="dbmd" />
				
				<cfinvoke component="asp.parches.comp.misc" method="struct_compare"
					a="#xmlmd#" b="#dbmd#"
					name="#nombre#"
					returnvariable="diff">
				<cfif StructCount(dbmd.columna) EQ 0>
					<cfset This.logmsg(Arguments.num_tarea, ds & '.' & nombre, This.WARN,
						'La tabla no existe')>
				<cfelseif ArrayLen(diff)>
					<cfset This.logmsg(Arguments.num_tarea, ds & '.' & nombre, This.WARN,
						'La estructura no coincide', ArrayToList(diff, Chr(13)))>
				<cfelse>
					<cfset This.logmsg(Arguments.num_tarea, ds & '.' & nombre, This.DEBUG,
						'La tabla coincide')>
				</cfif>
			</cfloop>
			
		</cfloop>
		<cfset tablas = ''>

		<cfset This.fin(num_tarea)>
	</cffunction>

</cfcomponent>
