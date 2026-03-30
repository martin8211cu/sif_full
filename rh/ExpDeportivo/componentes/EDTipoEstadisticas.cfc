<cfcomponent>
	
	<cffunction name="ALTA" access="public" returntype="query" >
		<cfargument name="EDTEdescripcion" type="string" required="yes"/>
		<cfargument name="conexion2" type="string" required="no" default="#session.dsn#"/>
		<cfargument name="BMUsucodigo" type="numeric" required="no" default="0"/>
		<cfargument name="BMfalta" type="date" required="no" default="#now()#"/>
		
		
	
		<cfquery name="rs" datasource="#arguments.conexion2#">
		insert into EDTipoEstadisticas (EDTEdescripcion, BMfalta, BMUsucodigo)
			values(		'#arguments.EDTEdescripcion#', 					
						#arguments.BMfalta#, 
						#arguments.BMUsucodigo#
									  )
		
	<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>	
	<cf_dbidentity2 datasource="#session.DSN#" name="rs">

		<cfreturn rs>
	</cffunction>
	
<cffunction name="CAMBIO" access="public" returntype="numeric">
		<cfargument name="EDTEid" type="numeric" required="yes"/>
		<cfargument name="EDTEdescripcion" type="string" required="yes"/>
		<cfargument name="conexion" type="string" required="no" default="#session.dsn#"/>
		<cfargument name="BMUsucodigo" type="numeric" required="no" default="0"/>
		<cfargument name="BMfalta" type="date" required="no"/>
		 
		<cfquery datasource="#session.dsn#">
		update EDTipoEstadisticas
		set EDTEdescripcion = '#arguments.EDTEdescripcion#', 
		where EDTEid = #arguments.EDTEid#
			
	</cfquery>
		<cfreturn 1>
	</cffunction>
	
<cffunction name="BAJA" access="public" returntype="numeric">
		<cfargument name="EDTEid" type="numeric" required="yes">
		<cfargument name="conexion" type="string" required="yes" default="#session.dsn#">
		
		<cfquery datasource="#session.DSN#">
		delete EDTipoEstadisticas
		where EDTEid = #arguments.EDTEid#
	</cfquery>	

		<cfreturn 1> 
	</cffunction>
</cfcomponent>
