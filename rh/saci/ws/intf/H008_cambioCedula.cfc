<cfcomponent hint="Ver SACI-03-H008.doc" extends="base">
	<cffunction name="cambioCedula" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="PidAnterior" type="string" required="yes">
		<cfargument name="PidNuevo" type="string" required="yes">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		
		<cfset control_inicio( Arguments, 'H008', Arguments.PidAnterior & ' - ' & Arguments.PidNuevo )>
		<cftry>
		
			<!--- saci --->
			<cfif not Arguments.origen is 'saci'>
				<cfset control_servicio( 'saci' )>
				<cfquery datasource="#session.dsn#" name="update_q">
					update ISBpersona
					set Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PidNuevo#">
					where Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PidAnterior#">
					select @@rowcount as update_rowcount
				</cfquery>
				<cfif update_q.update_rowcount is 0>
					<cfset control_mensaje( 'ISB-0006', 'ISBpersona con la cédula #Arguments.PidAnterior#' )>
				<cfelseif update_q.update_rowcount gt 1>
					<cfset control_mensaje( 'ISB-0007', 'ISBpersona con la cédula #Arguments.PidAnterior#' )>
				</cfif>
			</cfif>
		
			<!--- siic --->
			<cfif Arguments.origen is 'siic'>
				<cfset control_servicio( 'siic' )>
				<cfset control_mensaje( 'SIC-0005', 'anterior:#Arguments.PidAnterior#, nueva:#Arguments.PidNuevo#' )>
				<!--- Actualizar las tablas de SACISIIC --->
				<cfquery datasource="SACISIIC" name="update_q">
					update SSMCLT
					set CLTCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PidNuevo#">
					where CLTCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PidAnterior#">
					select @@rowcount as update_rowcount
				</cfquery>
				<cfif update_q.update_rowcount is 0>
					<cfset control_mensaje( 'ISB-0006', 'SSMCLT con la cédula #Arguments.PidAnterior#' )>
				</cfif>
				<cfquery datasource="SACISIIC" name="update_q">
					update SSXINT
					set INTCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PidNuevo#">
					where INTCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PidAnterior#">
					select @@rowcount as update_rowcount
				</cfquery>
				<cfif update_q.update_rowcount is 0>
					<cfset control_mensaje( 'ISB-0006', 'SSXINT con la cédula #Arguments.PidAnterior#' )>
				</cfif>
				<cfquery datasource="SACISIIC" name="update_q">
					update SSXSSC
					set CLTCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PidNuevo#">
					where CLTCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PidAnterior#">
					select @@rowcount as update_rowcount
				</cfquery>
				<cfif update_q.update_rowcount is 0>
					<cfset control_mensaje( 'ISB-0006', 'SSXSSC con la cédula #Arguments.PidAnterior#' )>
				</cfif>
				<!--- cumplimiento --->
				<cfinvoke component="SSXS02" method="Cumplimiento"
					S02CON="#Arguments.S02CON#"/>
			<cfelseif Arguments.origen is 'saci'>
				<!--- definir nuevo stored proc para notificar a siic --->
			</cfif>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
			<cfinvoke component="SSXS02" method="Error"
				S02CON="#Arguments.S02CON#" 
				Error="#Request._saci_intf.Error#"/>
		</cfcatch>
		</cftry>
		
	</cffunction>
	
</cfcomponent>