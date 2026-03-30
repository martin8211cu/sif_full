<cfcomponent extends="base">
	<cffunction name="respuesta_sobres_prepagos" access="public" returntype="void" output="false">
		<cfargument name="origen" type="string" required="yes" default="siic">	
		<cfargument name="SOid" type="string" required="yes">
		<cfargument name="SOidexterno" type="string" required="yes">
		<cfargument name="AGid" type="string" required="yes">
		<cfargument name="estado" type="string" required="yes">
		<cfargument name="S02CON" type="string" required="yes" default="0">
		
										
		<cfset control_inicio( Arguments, 'H019b','##Solicitud= ' & Arguments.SOid & ' Estado=' & Arguments.estado)>
		<cftry>
			<cfset control_servicio( 'siic' )>
				<cfquery datasource="#session.dsn#" name="querydatos">				
					Update ISBsolicitudes Set SOestado = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.estado#">
					Where SOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SOid#">
				</cfquery>
		<cfset control_final( )>
		<cfcatch type="any">
			<!--- error --->
			<cfset control_catch( cfcatch )>
			<cfinvoke component="SSXS02" method="Error"
			S02CON="#Arguments.S02CON#" 
			Error="#Request._saci_intf.Error#"/>			
		</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>