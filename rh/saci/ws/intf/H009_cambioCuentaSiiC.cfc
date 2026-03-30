<cfcomponent hint="Ver SACI-03-H009.doc" extends="base">
	<cffunction name="cambioCuentaSiiC" access="public" returntype="void">
		<cfargument name="CUECUEnuevo" type="string" required="yes" hint="String por si viene vacío o inválido">
		<cfargument name="CUECUEviejo" type="string" required="yes" hint="String por si viene vacío o inválido">
		<cfargument name="cedula" type="string" required="yes">
		<cfargument name="login" type="string" required="yes">
		<cfargument name="nombreCuenta" type="string" required="yes">
		<cfargument name="nombreCta_SSXINT" type="string" required="yes">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		<cfargument name="origen" type="string" default="siic">
		
		<cfset control_inicio( Arguments, 'H009', Arguments.CUECUEviejo & ' - ' & Arguments.CUECUEnuevo )>
		<cftry>
			<!--- Cambios de la cuenta en saci --->
			<cfset control_servicio( 'saci' )>
			<cfquery datasource="#session.dsn#" name="update_q">
				update ISBcuenta
				set CUECUE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CUECUEnuevo#">
				where CUECUE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CUECUEviejo#">
				select @@rowcount as update_rowcount
			</cfquery>
			<cfif update_q.update_rowcount is 0>
				<cfset control_mensaje( 'ISB-0006', 'ISBcuenta con el CUECUE #Arguments.CUECUEviejo#' )>
			</cfif>
			
			<cfquery datasource="#session.dsn#">
				update ISBpersona
				set PrazonSocial = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.nombreCuenta#">
				where Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cedula#">
			</cfquery>
			
			<cfset LGnumero = getLGnumero(Arguments.login)>
			
			<!--- Registrar el cambio en bitcora --->
			<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta"
				LGnumero="#LGnumero#"
				LGlogin="#Arguments.login#"
				BLautomatica="1"
				BLobs="Cambio de cuenta en SiiC" />
			
			<!--- SiiC --->
			
			<cfset control_servicio( 'siic' )>
			<cfquery datasource="SACISIIC" name="update_q">
				update SSXINT
				set INTNOM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.nombreCta_SSXINT#">
				where SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.login#">
				select @@rowcount as update_rowcount
			</cfquery>
			<cfif update_q.update_rowcount is 0>
				<cfset control_mensaje( 'ISB-0006', 'SSXINT con SERCLA #Arguments.login#' )>
			</cfif>
			<cfquery datasource="SACISIIC" name="update_q">
				update SSXSSC
				set CUECUE= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CUECUEnuevo#">
				where SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.login#">
				and CUECUE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CUECUEviejo#">
				select @@rowcount as update_rowcount
			</cfquery>
			<cfif update_q.update_rowcount is 0>
				<cfset control_mensaje( 'ISB-0006', 'SSXSSC con SERCLA #Arguments.login# y CUECUE #Arguments.CUECUEviejo#' )>
			</cfif>
			<!--- cumplimiento --->
			<cfinvoke component="SSXS02" method="Cumplimiento"
				S02CON="#Arguments.S02CON#"/>
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