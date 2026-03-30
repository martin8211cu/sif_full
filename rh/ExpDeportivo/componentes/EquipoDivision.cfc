<cfcomponent>
	
	<cffunction name="ALTA" access="public" returntype="query"  >
		<cfargument name="EDid" type="numeric" required="yes"/>
		<cfargument name="TEid" type="numeric" required="yes"/> 	
		<!--- <cfargument name="BMfalta" type="date" required="no" default="#Session.Ecodigo#"/> --->
		<cfargument name="conexion2" type="string" required="no" default="#session.dsn#"/>
		<cfargument name="BMUsucodigo" type="numeric" required="no" default="0"/>
		<cfargument name="BMfalta" type="date" required="no" default="#now()#"/>
		
		
	
		<cfquery name="rs" datasource="#arguments.conexion2#">
		insert into EquipoDivision (EDid, TEid, BMfalta, BMUsucodigo)
			values(		#arguments.EDid#, #arguments.TEid#, 					
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
		<cfargument name="EDvid" type="numeric" required="yes"/>
		<cfargument name="EDid" type="numeric" required="yes"/>
		<cfargument name="TEid" type="numeric" required="yes"/> 	
		<!--- <cfargument name="BMfalta" type="date" required="no" default="#Session.Ecodigo#"/> --->
		<cfargument name="conexion" type="string" required="no" default="#session.dsn#"/>
		<cfargument name="BMUsucodigo" type="numeric" required="no" default="0"/>
		<cfargument name="BMfalta" type="date" required="no"/>
		 
		<cfquery datasource="#session.dsn#">
		update EquipoDivision
		set EDid = #arguments.EDid#, 
		    TEid = #arguments.TEid#
		where EDvid = #arguments.EDvid#
			
	</cfquery>
		<!---<cfquery name="rs" datasource="#arguments.conexion#">
			select * from EDTiposEquipo where TEid = #arguments.TEid#
		</cfquery>--->
		<cfreturn 1>
	</cffunction>
	
<cffunction name="BAJA" access="public" returntype="numeric">
		<cfargument name="EDvid" type="numeric" required="yes">
		<cfargument name="conexion" type="string" required="yes" default="#session.dsn#">
		
		<cfquery datasource="#session.DSN#">
		delete EquipoDivision
		where EDvid = #arguments.EDvid#
	</cfquery>	
	<!---<cfquery name="rs" datasource="#arguments.conexion#">
			select * from EDTiposEquipo where TEid = #arguments.TEid# 
		</cfquery>--->
		<cfreturn 1> 
	</cffunction>
</cfcomponent>
