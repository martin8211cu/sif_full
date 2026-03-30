<cfcomponent>
	
	<cffunction name="ALTA" access="public" returntype="query" >
		<cfargument name="EDPdescripcion" type="string" required="yes"/>
		<cfargument name="EDPcodigo" type="string" required="yes"/> 	
		<!--- <cfargument name="BMfalta" type="date" required="no" default="#Session.Ecodigo#"/> --->
		<cfargument name="conexion2" type="string" required="no" default="#session.dsn#"/>
		<cfargument name="BMUsucodigo" type="numeric" required="no" default="0"/>
		<cfargument name="BMfalta" type="date" required="no" default="#now()#"/>
		
		
	
		<cfquery name="rs" datasource="#arguments.conexion2#">
		insert into EDPosiciones (EDPcodigo, EDPdescripcion, BMfalta, BMUsucodigo)
			values(		'#arguments.EDPcodigo#', '#arguments.EDPdescripcion#', 					
						#arguments.BMfalta#, 
						#arguments.BMUsucodigo#
									  )
		
	<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>	
	<cf_dbidentity2 datasource="#session.DSN#" name="rs">

		<!--- <cfquery name="rs" datasource="#arguments.conexion2#">
			select * from EDTiposEquipo where TEid = #arguments.TEid#
		</cfquery>  --->
		<cfreturn rs>
	</cffunction>
	
<cffunction name="CAMBIO" access="public" returntype="numeric">
		<cfargument name="EDPid" type="numeric" required="yes"/>
		<cfargument name="EDPdescripcion" type="string" required="yes"/>
		<cfargument name="EDPcodigo" type="string" required="yes"/> 	
		<!--- <cfargument name="BMfalta" type="date" required="no" default="#Session.Ecodigo#"/> --->
		<cfargument name="conexion" type="string" required="no" default="#session.dsn#"/>
		<cfargument name="BMUsucodigo" type="numeric" required="no" default="0"/>
		<cfargument name="BMfalta" type="date" required="no"/>
		 
		<cfquery datasource="#session.dsn#">
		update EDPosiciones
		set EDPdescripcion = '#arguments.EDPdescripcion#', 
		    EDPcodigo = '#arguments.EDPcodigo#'
		where EDPid = #arguments.EDPid#
			
	</cfquery>
		<!---<cfquery name="rs" datasource="#arguments.conexion#">
			select * from EDTiposEquipo where TEid = #arguments.TEid#
		</cfquery>--->
		<cfreturn 1>
	</cffunction>
	
<cffunction name="BAJA" access="public" returntype="numeric">
		<cfargument name="EDPid" type="numeric" required="yes">
		<cfargument name="conexion" type="string" required="yes" default="#session.dsn#">
		
		<cfquery datasource="#session.DSN#">
		delete EDPosiciones
		where EDPid = #arguments.EDPid#
	</cfquery>	
	<!---<cfquery name="rs" datasource="#arguments.conexion#">
			select * from EDTiposEquipo where TEid = #arguments.TEid# 
		</cfquery>--->
		<cfreturn 1> 
	</cffunction>
</cfcomponent>
