<cfcomponent extends="ejecutor">
	
	<cffunction name="ejecuta" hint="Ejecuta un archivo SQL">
		<cfargument name="num_tarea" type="numeric" required="yes">

		<cfset This.inicio(num_tarea, 'Omitiendo tarea')>
		<cfset This.logmsg(Arguments.num_tarea, Arguments.ruta, This.WARN,
			'Se omite la ejecución de la tarea por instrucciones del usuario.')>
		<cfset This.fin(num_tarea)>
	</cffunction>
	
</cfcomponent>
