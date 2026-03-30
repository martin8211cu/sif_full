<cfcomponent>

	<cffunction name="ALTA" access="public" returntype="query" >
		<cfargument name="TPid" type="numeric" required="yes"/>
		<cfargument name="Ecodigo" type="numeric" required="yes"/> 	
		<cfargument name="EDPdesde" type="date" required="yes"/> 
		<cfargument name="EDPhasta" type="date" required="yes"/>
		<cfargument name="EDPposicion" type="string" required="no"/> 
		<cfargument name="EDPnumero" type="string" required="no" default=""/> 
		<cfargument name="DEid" type="numeric" required="no"/>
		<cfargument name="EDvid" type="numeric" required="no"/>
		<cfargument name="conexion2" type="string" required="no" default="#Session.DSN#"/>
		<cfargument name="BMfalta" type="date" required="no" default="#NOW()#"/>
		<cfargument name="BMUsucodigo" type="numeric" required="no" default="0"/>
	
		<cfquery name="rs" datasource="#arguments.conexion2#">
		insert into EquipoDivPersona (Ecodigo, TPid, EDPdesde, EDPhasta, EDPposicion, EDPnumero, DEid, EDvid, BMfalta, BMUsucodigo)
			values(#arguments.Ecodigo#, #arguments.TPid#, #LSParseDateTime(arguments.EDPdesde)#, 
			#LSParseDateTime(arguments.EDPhasta)#, '#arguments.EDPposicion#', 
			'#arguments.EDPnumero#',
			#arguments.DEid#, #arguments.EDvid#,					
						#arguments.BMfalta#, 
						#arguments.BMUsucodigo#
									  )
		

		<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>	
	<cf_dbidentity2 datasource="#session.DSN#" name="rs">	
	
		<cfreturn rs>
	</cffunction>
	
<cffunction name="CAMBIO" access="public" returntype="numeric">
		<cfargument name="EDPid" type="numeric" required="yes"/>
		<cfargument name="TPid" type="numeric" required="yes"/>
		<cfargument name="Ecodigo" type="numeric" required="yes"/> 	
		<cfargument name="EDPdesde" type="date" required="yes"/> 
		<cfargument name="EDPhasta" type="date" required="yes"/>
		<cfargument name="EDPposicion" type="string" required="yes"/> 
		<cfargument name="EDPnumero" type="string" required="no"/> 
		<cfargument name="DEid" type="numeric" required="no"/>
		<cfargument name="EDvid" type="numeric" required="no"/>
		<cfargument name="conexion2" type="string" required="no" default="#session.dsn#"/>
		<cfargument name="BMUsucodigo" type="numeric" required="no" default="0"/>
		<cfargument name="BMfalta" type="date" required="no" default="#now()#"/>	
		 
		<cfquery datasource="#session.dsn#">
		update EquipoDivPersona
		set Ecodigo= #arguments.Ecodigo#,
			TPid= #arguments.TPid#,
			EDPdesde= #LSParseDateTime(arguments.EDPdesde)#,
			EDPhasta= #LSParseDateTime(arguments.EDPhasta)#,
			EDPposicion= '#arguments.EDPposicion#',
			EDPnumero= '#arguments.EDPnumero#',
			DEid= #arguments.DEid#,
			EDvid= #arguments.EDvid#
			
		where EDPid = #arguments.EDPid#
			   		 
	</cfquery>
		<cfreturn 1>
	</cffunction>
	
<cffunction name="BAJA" access="public" returntype="numeric">
		<cfargument name="EDPid" type="numeric" required="yes">
		<cfargument name="conexion" type="string" required="yes" default="#session.dsn#">
		
		<cfquery datasource="#session.DSN#">
		delete EquipoDivPersona
		where EDPid = #arguments.EDPid#
	</cfquery>	
		<cfreturn 1> 
	</cffunction>
</cfcomponent>
