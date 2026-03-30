<cfcomponent>
	<cffunction name="ALTA" access="public" returntype="numeric">
		<cfargument name="Pid" 				type="numeric" 	required="yes" default="">
		<cfargument name="PVid" 			type="numeric" 	required="yes">
		<cfargument name="Mcodigo" 			type="numeric" 	required="yes">
		<cfargument name="PPrecio" 			type="numeric" 	required="no" default="">
		<cfargument name="BMUsucodigo" 		type="numeric" 	required="no" default="#session.usucodigo#">
		
		<cfquery datasource="#session.dsn#">
			insert into PPrecio (
				 Pid,
				 PVid ,
				 Mcodigo,
				 PPrecio,
				 BMUsucodigo   
			)
   			values(
			    #arguments.Pid#,
				#arguments.PVid#,
				#arguments.Mcodigo#,
				#arguments.PPrecio#,				
				#arguments.BMUsucodigo#
			)
		</cfquery>
			
		<cfquery name="rsSelectId" datasource="#session.dsn#">
			select max(ID_PPreciov)as id from PPrecio
		</cfquery>
		<cfreturn #rsSelectId.id#>
	</cffunction>
	
	<cffunction name="CAMBIO" access="public" returntype="numeric">
	    <cfargument name="ID_PPreciov"		type="numeric" 	required="yes">
		<cfargument name="Pid" 				type="numeric" 	required="yes" default="">
		<cfargument name="PVid" 			type="numeric" 	required="yes">
		<cfargument name="Mcodigo" 			type="numeric" 	required="yes">
		<cfargument name="PPrecio" 			type="numeric" 	required="no" default="">
		<cfargument name="BMUsucodigo" 		type="numeric" 	required="no" default="#session.usucodigo#">

		<cfquery datasource="#session.dsn#">
			update 		PPrecio
            set 		Pid=			#arguments.Pid#,
						PVid=			#arguments.PVid#,
						Mcodigo=		#arguments.Mcodigo#,
						PPrecio=		#arguments.PPrecio#,
						BMUsucodigo=	#arguments.BMUsucodigo#
						
			where ID_PPreciov=			#arguments.ID_PPreciov#
		</cfquery>
		<cfreturn #arguments.ID_PPreciov#>
	</cffunction>
	<cffunction name="BAJA" access="public" returntype="numeric">
		<cfargument name="ID_PPreciov" 	type="numeric" required="yes">

		<cfquery datasource="#session.dsn#">
			delete from PPrecio
			where ID_PPreciov=#arguments.ID_PPreciov#
		</cfquery>
		<cfreturn #arguments.ID_PPreciov#>
	</cffunction>
</cfcomponent>