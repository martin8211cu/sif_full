<cfcomponent>
	<cffunction name="ALTA" access="public" returntype="numeric">
		<cfargument name="PVcodigo" 		type="string" 	required="yes">
		<cfargument name="PVdescripcion" 	type="string" 	required="no" default="">
		<cfargument name="PVoficial" 		type="string" 	required="no" default="">
		<cfargument name="BMUsucodigo" 		type="numeric" 	required="no" default="#session.usucodigo#">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no" default="#session.Ecodigo#">
			
		<cfquery datasource="#session.dsn#">
			insert into PVehiculos (
				 PVcodigo,
				 PVdescripcion ,
				 PVoficial,
				 BMUsucodigo,   
				 Ecodigo         
			)
   			values(
			    '#arguments.PVcodigo#',
				'#arguments.PVdescripcion#',
				'#arguments.PVoficial#',
				#arguments.BMUsucodigo#,
				#arguments.Ecodigo#
			)
		</cfquery>
			
		<cfquery name="rsSelectId" datasource="#session.dsn#">
			select max(PVid)as id from PVehiculos
		</cfquery>
		<cfreturn #rsSelectId.id#>
	</cffunction>
	

	<cffunction name="CAMBIO" access="public" returntype="numeric">
	    <cfargument name="PVid" 			type="numeric" 	required="yes">
		<cfargument name="PVcodigo" 		type="string" 	required="yes">
		<cfargument name="PVdescripcion" 	type="string" 	required="no" default="">
		<cfargument name="PVoficial" 		type="string" 	required="no" default="">
		<cfargument name="BMUsucodigo" 		type="numeric" 	required="no" default="">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no" default="">
		<cfquery datasource="#session.dsn#">
			update 		PVehiculos
            set 		PVcodigo=		'#arguments.PVcodigo#',
						PVdescripcion=	'#arguments.PVdescripcion#',
						PVoficial=		'#arguments.PVoficial#',
						BMUsucodigo=	#arguments.BMUsucodigo#
			where 		PVid=			#arguments.PVid#
			  and 		Ecodigo=		#arguments.Ecodigo#
		</cfquery>
		<cfreturn #arguments.PVid#>
	</cffunction>
	
	
	<cffunction name="BAJA" access="public" returntype="numeric">
		<cfargument name="PVid" type="numeric" required="yes">
		<cfargument name="PVcodigo" type="string" required="no">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfquery datasource="#session.dsn#">
			delete from PVehiculos
			where 	PVid=	#arguments.PVid#
				and Ecodigo=#arguments.Ecodigo#
		</cfquery>
		<cfreturn #arguments.PVid#>
	</cffunction>
	
	
</cfcomponent>