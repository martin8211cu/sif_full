<cfcomponent hint="Ver SACI-03-H049.doc" extends="base">
	<cffunction name="MostrarRealName" access="public" returntype="string">		
		
		<cfargument name="login" type="string" required="yes">
		<cfargument name="rethrow" type="boolean" default="no">
		<cfargument name="origen" type="string" required="yes">

		<cfset control_inicio( Arguments, 'H049', Arguments.login )>
		<cftry>
			<cfset validarOrigen(Arguments.origen)>

			<!--- Obtener los datos generales del login --->
			
				<cfset LGnumero = getLGnumero(Arguments.login)>
				<cfquery datasource="#session.dsn#" name="update_q">
					select coalesce(LGrealName,'_') as LGrealName from ISBlogin
					 where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LGnumero#">
				</cfquery>
				
				<cfif update_q.RecordCount is 0>
					<cfset control_mensaje( 'ISB-0006', 'ISBlogin con #Arguments.login#' )>
				</cfif>

			<cfset control_final( )>				
			<cfcatch type="any">
				<!--- cumplimiento / error --->
				<cfset control_catch( cfcatch )>
				<cfif rethrow><cfrethrow></cfif>
			</cfcatch>
		</cftry>
	<cfreturn update_q.LGrealName> 	
	</cffunction>
	
</cfcomponent>