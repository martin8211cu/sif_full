<cfcomponent hint="Ver SACI-03-H038.doc" extends="base">
	<cffunction name="bloqueo900" access="public" returntype="void">
		<cfargument name="MDref" type="string" required="yes">
		<cfargument name="MDbloqueado" type="boolean" required="yes">
		<cfargument name="origen" type="string" default="saci">
		<cfargument name="S02CON" type="string" default="0">
		<cfargument name="modificar" type="string" >
		<cfargument name="modificarprepago" type="string">
		
		<cfset control_inicio( Arguments, 'H038', Arguments.MDref )>
		<cftry>
			<cfquery datasource="#session.dsn#" name="ISBmedio">
				select EMid 
				from ISBmedio 
				where MDref = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MDref#">
			</cfquery>
			
			<cfset control_servicio( 'acceso' )>
			
			<cfif modificar>
				<cfif MDbloqueado>
					<cfset BTobs = 'Bloqueo de servicio 900'>
					<!--- Bloquear el teléfono para no permitir servicios en 900 --->			
					<cfinvoke component="CiscoService" method="createUser"
						usuario="#Arguments.MDref#"
						clave="#Arguments.MDref#"
						parentGroup="NO_AUTORIZADOS_900" />
				<cfelse>
						<cfset BTobs = 'Desbloqueo de servicio 900'>
						<cfinvoke component="CiscoService" method="deleteUser"
						usuario="#Arguments.MDref#"/>
				</cfif>
			</cfif>	
			
			<cfif modificarprepago>
				<cfif MDbloqueado>
					<cfset BTobs = 'Bloqueo de un teléfono para el Servicio Prepago'>
					<!--- Bloquear el teléfono para no permitir servicios en 900 --->			
					<cfinvoke component="CiscoService" method="UpdateProfile"
					telefono="#Arguments.MDref#"
					grupo="PREPAGO"/>
				<cfelse>
					<cfthrow message="No se permite el desbloqueo de un teléfono para prepagos">
				</cfif>
			</cfif>	

			<cfset control_servicio( 'saci' )>
			<cfinvoke component="saci.comp.ISBbitacoraMedio" method="Alta">
				<cfinvokeargument name="MDref" value="#Arguments.MDref#">
				<cfinvokeargument name="EMid" value="#ISBmedio.EMid#">
				<cfinvokeargument name="BTautomatica" value="Yes">  
				<cfinvokeargument name="BTobs" value="#BTobs#">  
			</cfinvoke>
						
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
		</cfcatch>
		</cftry>
		
	</cffunction>
</cfcomponent>