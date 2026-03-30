<cfcomponent extends="ejecutor" hint="Verifica la integridad del parche antes de ejecutarlo">
	
	<cffunction name="ejecuta" hint="Ejecuta la tarea" output="false">
		<cfargument name="num_tarea" type="numeric" required="yes">

		<cfset This.inicio(num_tarea, 'Inicio')>
		
		<cfset This.logmsg(Arguments.num_tarea, 'Tarea inhabilitada', This.WARN,
			'La verificación está inhabilitada.')>
<!---
Debe validar:
	md5sum de archivos fuentes 
	md5sum de archivos sql
	md5sum de importadores
	md5sum del archivo JAR
	Existencia del XML del parche
	Que los SQL en el parche sean los mismos, ni más ni menos, que en el XML.
	Que el parche contenga documentación. 
--->
		<cfset This.fin(num_tarea)>
	</cffunction>

</cfcomponent>
