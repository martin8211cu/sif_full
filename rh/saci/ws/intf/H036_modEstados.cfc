<cfcomponent hint="Ver SACI-03-H036.doc" extends="base">
	<cffunction name="modificacionEstados" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="SSCCOD" type="string" required="Yes">
		<cfargument name="ESCCOD" type="string" required="No" default="0">
		<cfargument name="CONCGO" type="string" required="No" default="0">
		
		<cfset control_inicio( Arguments, 'H036', 'SSCCOD= ' & Arguments.SSCCOD)>
		<cftry>
			<cfparam name="Arguments.SSCCOD" type="numeric">
			<cfset control_servicio( 'siic' )>
			<cfquery datasource="SACISIIC" name="modificacionEstados_Q">
				select CUECUE,ESCCOD,CONCGO
				from SSXSSC
				where SSCCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SSCCOD#">
			</cfquery>
			<cfif modificacionEstados_Q.RecordCount is 0>
				<cfthrow message="No existe cuenta con SSCCOD = #Arguments.SSCCOD#" errorcode="SIC-0011">
			</cfif>
			<cfset control_servicio( 'saci' )>
			<cfquery datasource="#session.dsn#" name="update_q">
				update ISBcuenta
				set ECidEstado = (	select ECidEstado 
									from ISBcuentaEstado 
									where ECestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#modificacionEstados_Q.ESCCOD#"> and 
										  ECsubEstado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#modificacionEstados_Q.CONCGO#">
								  )
				where CUECUE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#modificacionEstados_Q.CUECUE#">
				select @@rowcount as update_rowcount
			</cfquery>
			<cfif update_q.update_rowcount is 0>
				<cfset control_mensaje( 'ISB-0006', 'ISBcuenta con CUECUE #modificacionEstados_Q.CUECUE#' )>
			</cfif>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
		</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>