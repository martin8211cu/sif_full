<cfcomponent hint="Ver SACI-03-H040.doc" extends="base">
	<cffunction name="cambioRealName" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="login" type="string" required="yes">
		<cfargument name="realName" type="string" required="yes">
		<cfargument name="rethrow" type="boolean" default="no">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		
		<cfset cambioRealNameLGnumero(origen, getLGnumero(Arguments.login, 0, true), login, realName, rethrow, S02CON)>
	</cffunction>
	
	<cffunction name="cambioRealNameLGnumero" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="LGnumero" type="numeric" required="yes">
		<cfargument name="LGlogin" type="string" required="yes">
		<cfargument name="LGrealName" type="string" required="yes">
		<cfargument name="rethrow" type="boolean" default="no">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		
		<cfset control_inicio( Arguments, 'H040', Arguments.LGlogin )>
		<cftry>
			<cfset validarOrigen(Arguments.origen)>

			<!--- Obtener los datos generales del login --->
			<cfset ISBlogin = getISBlogin(Arguments.LGnumero)>
			<cfif Arguments.origen neq 'saci'>
				<cfset control_servicio( 'saci' )>
				<!--- Actualización del RealName --->
				<cfquery datasource="#session.dsn#" name="update_q">
					update ISBlogin
					   set LGrealName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LGrealName#">
					 where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
					select @@rowcount as update_rowcount
				</cfquery>
				<cfif update_q.update_rowcount is 0>
					<cfset control_mensaje( 'ISB-0006', 'ISBlogin con LGnumero #Arguments.LGnumero#' )>
				</cfif>
				
				<!--- Anotación en la bitácora --->
				<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta">
				  <cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
				  <cfinvokeargument name="LGlogin" value="#Arguments.LGlogin#">
				  <cfinvokeargument name="BLautomatica" value="true">
				  <cfinvokeargument name="BLobs" value="Cambio de Realname">
				</cfinvoke>
			</cfif>
			
			<!--- Cambio en el equipo de IPlanet --->
			<cfset control_servicio( 'correo' )>

			<!--- Se modifica el casillero de correos --->
			<cfinvoke component="IPlanetService" method="update"
				usuario="#Arguments.LGlogin#"
				mailQuotaKB="#ISBlogin.LGmailQuota#"
				RealName="#ISBlogin.LGrealName#"
				nombre="#ISBlogin.Pnombre#"
				apellido="#ISBlogin.Papellido# #ISBlogin.Papellido2#" />
			<cfif Arguments.origen is 'siic'>
				<!--- cumplimiento --->
				<cfset control_servicio( 'siic' )>
				<cfinvoke component="SSXS02" method="Cumplimiento"
					S02CON="#Arguments.S02CON#" />
			</cfif>			
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
			<cfinvoke component="SSXS02" method="Error"
				S02CON="#Arguments.S02CON#" 
				Error="#Request._saci_intf.Error#"/>
			<cfif rethrow><cfrethrow></cfif>
		</cfcatch>
		</cftry>
	</cffunction>
	
</cfcomponent>