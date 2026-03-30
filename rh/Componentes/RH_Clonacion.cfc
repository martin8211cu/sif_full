<cfcomponent>

<!---		
		#arguments.conexion#
		#arguments.Tabla#
		#arguments.Padre#
		
		#arguments.EcodigoNuevo#
		#arguments.EcodigoViejo#
		#arguments.llave#
--->
	<cffunction name="ActualizaDatos" access="public" output="true" >
	
		<cfargument name="conexionO" 			type="string" 	required="yes">
		<cfargument name="conexionD" 			type="string" 	required="yes">
		<cfargument name="Tabla"   				type="string" 	required="yes">
		<cfargument name="Fuente" 				type="string" 	required="yes">
		<cfargument name="EcodigoNuevo" 		type="numeric" 	required="yes">
		<cfargument name="EcodigoViejo" 		type="numeric" 	required="yes">
		<cfargument name="llave" 				type="string" 	required="yes">
		<cfargument name="Padre" 				type="string" 	required="no">
		<cfargument name="temporal" 			type="string" 	required="no">
		
		
		<cfdump var="#arguments.Fuente#">
		
		<cfinclude template="/clonacion/rh/#arguments.Fuente#">
		
		<cfreturn>	
	</cffunction>

</cfcomponent>







