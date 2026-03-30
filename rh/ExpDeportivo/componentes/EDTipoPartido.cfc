<cfcomponent>
	
	<cffunction name="ALTA" access="public" returntype="numeric" >
		<cfargument name="EDTPdescripcion" type="string" required="yes"/>
		<cfargument name="EDTPcodigo" type="string" required="yes"/> 	
		<!--- <cfargument name="BMfalta" type="date" required="no" default="#Session.Ecodigo#"/> --->
		<cfargument name="conexion2" type="string" required="no" default="#session.dsn#"/>
		<cfargument name="BMUsucodigo" type="numeric" required="no" default="0"/>
		<cfargument name="BMfalta" type="date" required="no" default="#now()#"/>
		
	
		<cfquery datasource="#arguments.conexion2#">
		insert into EDTiposPartido (EDTPcodigo, EDTPdescripcion, BMfalta, BMUsucodigo)
			values(		'#arguments.EDTPcodigo#', '#arguments.EDTPdescripcion#', 					
						#arguments.BMfalta#, 
						#arguments.BMUsucodigo#
									  )
	</cfquery>

		<!---<cfquery name="rs" datasource="#arguments.conexion2#">
			select * from EDTiposEquipo where TEid = #arguments.TEid#
		</cfquery>--->
		<cfreturn 1>
	</cffunction>
	
<cffunction name="CAMBIO" access="public" returntype="numeric">
		<cfargument name="EDTPid" type="numeric" required="yes"/>
		<cfargument name="EDTPdescripcion" type="string" required="yes"/>
		<cfargument name="EDTPcodigo" type="string" required="yes"/> 	
		<!--- <cfargument name="BMfalta" type="date" required="no" default="#Session.Ecodigo#"/> --->
		<cfargument name="conexion" type="string" required="no" default="#session.dsn#"/>
		<cfargument name="BMUsucodigo" type="numeric" required="no" default="0"/>
		<cfargument name="BMfalta" type="date" required="no"/>
		 
		<cfquery datasource="#session.dsn#">
		update EDTiposPartido
		set EDTPdescripcion = '#arguments.EDTPdescripcion#', 
		    EDTPcodigo = '#arguments.EDTPcodigo#'
		where EDTPid = #arguments.EDTPid#
			
	</cfquery>
		<!---<cfquery name="rs" datasource="#arguments.conexion#">
			select * from EDTiposEquipo where TEid = #arguments.TEid#
		</cfquery>--->
		<cfreturn 1>
	</cffunction>
	
<cffunction name="BAJA" access="public" returntype="numeric">
		<cfargument name="EDTPid" type="numeric" required="yes">
		<cfargument name="conexion" type="string" required="yes" default="#session.dsn#">
		
		<cfquery datasource="#session.DSN#">
		delete EDTiposPartido
		where EDTPid = #arguments.EDTPid#
	</cfquery>	
	<!---<cfquery name="rs" datasource="#arguments.conexion#">
			select * from EDTiposEquipo where TEid = #arguments.TEid# 
		</cfquery>--->
		<cfreturn 1> 
	</cffunction>
</cfcomponent>
