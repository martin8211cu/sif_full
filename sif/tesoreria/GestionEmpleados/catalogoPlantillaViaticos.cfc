<cfcomponent>
	<cffunction name="ALTA" access="public" returntype="numeric">
		<cfargument name="Mcodigo" 				type="numeric" 	required="yes">
		<cfargument name="GEPVmonto" 			type="numeric" 	required="yes" default="">
		<cfargument name="GECid" 				type="numeric" 	required="yes">
		<cfargument name="GECVid" 				type="numeric" 	required="yes">
		<cfargument name="GEPVcodigo" 			type="string" 	required="yes">
		<cfargument name="GEPVtipoviatico" 		type="string" 	required="yes">
		<cfargument name="GEPVdescripcion" 		type="string" 	required="no">
		<cfargument name="GEPVaplicaTodos" 		type="string" 	required="no">
		<cfargument name="GEPVhoraini" 			type="numeric" 	required="no">
		<cfargument name="GEPVhorafin" 			type="numeric" 	required="no">
		<cfargument name="GEPVfechaini" 		type="date" 	required="yes">
		<cfargument name="GEPVfechafin" 		type="date" 	required="yes">
		<cfargument name="BMUsucodigo" 			type="numeric" 	required="no" default="#session.usucodigo#">
		
		<cfquery datasource="#session.dsn#">
			insert into GEPlantillaViaticos (
				 Mcodigo,
				 GEPVmonto,
				 GECid,
				 GECVid,
				 GEPVcodigo,
				 GEPVtipoviatico,
				 GEPVdescripcion,
				 GEPVaplicaTodos,
				 GEPVhoraini,
				 GEPVhorafin,
				 GEPVfechaini,
				 GEPVfechafin,
				 Ecodigo,
				 BMUsucodigo   
			)
   			values(
				#arguments.Mcodigo#,
				#arguments.GEPVmonto#,	
				#arguments.GECid#,
				#arguments.GECVid#,	
				'#arguments.GEPVcodigo#',
				'#arguments.GEPVtipoviatico#',	
				'#arguments.GEPVdescripcion#',
				'#arguments.GEPVaplicaTodos#',	
				#arguments.GEPVhoraini#,
				#arguments.GEPVhorafin#,	
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.GEPVfechaini)#">,
			    <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.GEPVfechafin)#">,
				#session.Ecodigo#,
				#arguments.BMUsucodigo#
			)
		</cfquery>
			
		<cfquery name="rsSelectId" datasource="#session.dsn#">
			select max(GEPVid)as id from GEPlantillaViaticos
		</cfquery>
		<cfreturn #rsSelectId.id#>
	</cffunction>
	
	<cffunction name="CAMBIO" access="public" returntype="numeric">
	    <cfargument name="GEPVid"				type="numeric" 	required="yes">
		<cfargument name="Mcodigo" 				type="numeric" 	required="yes">
		<cfargument name="GEPVmonto" 			type="numeric" 	required="yes" default="">
		<cfargument name="GECid" 				type="numeric" 	required="yes">
		<cfargument name="GECVid" 				type="numeric" 	required="yes">
		<cfargument name="GEPVcodigo" 			type="string" 	required="yes">
		<cfargument name="GEPVtipoviatico" 		type="string" 	required="yes">
		<cfargument name="GEPVdescripcion" 		type="string" 	required="no">
		<cfargument name="GEPVaplicaTodos" 		type="string" 	required="no">
		<cfargument name="GEPVhoraini" 			type="numeric" 	required="no">
		<cfargument name="GEPVhorafin" 			type="numeric" 	required="no">
		<cfargument name="GEPVfechaini" 		type="date" 	required="yes">
		<cfargument name="GEPVfechafin" 		type="date" 	required="yes">		
		<cfargument name="BMUsucodigo" 			type="numeric" 	required="no" default="#session.usucodigo#">

		<cfquery datasource="#session.dsn#">
			update 		GEPlantillaViaticos
            set 		 Mcodigo=			#arguments.Mcodigo#,
						 GEPVmonto=			#arguments.GEPVmonto#,
						 GECid=				#arguments.GECid#,
						 GECVid=			#arguments.GECVid#,	
						 GEPVcodigo=		'#arguments.GEPVcodigo#',
						 GEPVtipoviatico=	'#arguments.GEPVtipoviatico#',	
						 GEPVdescripcion=	'#arguments.GEPVdescripcion#',
						 GEPVaplicaTodos=	'#arguments.GEPVaplicaTodos#',	
						 GEPVhoraini=		#arguments.GEPVhoraini#,
						 GEPVhorafin=		#arguments.GEPVhorafin#,	
						 GEPVfechaini=		<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.GEPVfechaini)#">,
						 GEPVfechafin=		<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.GEPVfechafin)#">,
					     BMUsucodigo=		#arguments.BMUsucodigo#
			where GEPVid=			#arguments.GEPVid#
		</cfquery>
		<cfreturn #arguments.GEPVid#>
	</cffunction>
	<cffunction name="BAJA" access="public" returntype="numeric">
		<cfargument name="GEPVid" 	type="numeric" required="yes">

		<cfquery datasource="#session.dsn#">
			delete from GEPlantillaViaticos
			where GEPVid=#arguments.GEPVid#
		</cfquery>
		<cfreturn #arguments.GEPVid#>
	</cffunction>
</cfcomponent>