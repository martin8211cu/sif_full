<cfcomponent hint="Ver SACI-03-H020.doc" extends="base">
	<cffunction name="cambioTelefono" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="SERIDS" type="string" required="yes">
		<cfargument name="telefono" type="string" required="yes">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		
		<cfset cambioTelefonoLGnumero(origen, Arguments.SERIDS, 0, '', telefono, S02CON)>
	</cffunction>
	<cffunction name="cambioTelefonoLGnumero" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="SERIDS" type="string" required="no">
		<cfargument name="LGnumero" type="numeric" required="yes">
		<cfargument name="LGlogin" type="string" required="yes">
		<cfargument name="telefono" type="string" required="yes">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		
		<cfset control_inicio( Arguments, 'H020', Arguments.LGlogin & ' - ' & Arguments.telefono )>
		<cftry>
			<cfif IsDefined('Arguments.SERIDS') And Len(Arguments.SERIDS)>
				<cfset control_servicio( 'saci' )>
				<cfquery datasource="#session.dsn#" name="ISBlogin">
					select LGnumero, LGlogin 
					from ISBlogin 
					where LGserids = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SERIDS#">
					and Habilitado = 1
				</cfquery>
				<cfif ISBlogin.RecordCount is 0>
					<cfthrow message="Login no existe con SERIDS = #Arguments.SERIDS#" errorcode="QRY-0009">
				</cfif>
				<cfset Arguments.LGnumero = ISBlogin.LGnumero>
				<cfset Arguments.LGlogin = ISBlogin.LGlogin>
				<cfset control_asunto( ISBlogin.LGlogin & ' - ' & Arguments.telefono )>
			</cfif>
			
			<cfquery datasource="#session.dsn#" name="ISBpaquete">
				select a.PQcodigo, PQtelefono, l.LGserids
				from ISBpaquete a
					join ISBproducto b
						on a.PQcodigo = b.PQcodigo
					join ISBlogin l
						on l.Contratoid = b.Contratoid
				where l.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
			</cfquery>

			<cfif Arguments.telefono is '0000000'>
				<cfset Arguments.telefono = ''>
			</cfif>
			
			<cfif ISBpaquete.PQtelefono neq 1>
				<cfset control_mensaje( 'ISB-0014', 'Teléfono #Arguments.telefono# ignorado, paquete #ISBpaquete.PQcodigo#' )>
				<cfset Arguments.telefono = ''>
			</cfif>
			
			<!--- saci --->
			<cfif not Arguments.origen is 'saci'>
				<cfset control_servicio( 'saci' )>
				<cfset control_mensaje( 'ISB-0024', 'Cambiando teléfono #Arguments.telefono# ' )>
				<cfinvoke component="saci.comp.ISBlogin" method="CambioTelefono">
  					<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
  					<cfinvokeargument name="LGtelefono" value="#Arguments.telefono#">
  					<cfinvokeargument name="BLautomatica" value="1">
  					<cfinvokeargument name="BLobs" value="Cambio de telefono del login #Arguments.LGnumero#">
				</cfinvoke>
			</cfif>
			<!--- Actualizar en CISCO --->
			<cfset control_servicio( 'acceso' )>
			<cfinvoke component="CiscoService" method="updateTelefono"
				usuario="#Arguments.LGlogin#"
				telefono="#Arguments.telefono#" />
			<!--- siic --->
			<cfif Arguments.origen is 'siic'>
				<cfset control_servicio( 'siic' )>
				<cfset control_mensaje( 'SIC-0009', 'Cambiando teléfono #Arguments.telefono# para SERCLA #Arguments.login# ' )>
				<cfquery datasource="SACISIIC">
					update SSXINT
					set INTTEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.telefono#">
					where SERCLA =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LGlogin#">
				</cfquery>
				<cfinvoke component="SSXS02" method="Cumplimiento"
					S02CON="#Arguments.S02CON#"
					EnviarCumplimiento="false"
					EnviarHistorico="true"/>
			<cfelseif (Arguments.origen is 'saci') And Len(Arguments.telefono)>
				<!--- Notificar al siic --->
				<cfset S01VA1 = ArrayNew(1)>
				<cfset ArrayAppend(S01VA1, ISBpaquete.LGserids)>
				<cfset ArrayAppend(S01VA1, Arguments.telefono)>
				<cfquery datasource="SACISIIC">
					exec sp_Alta_SSXS01
						@S01ACC = 'H',
						@S01VA1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ArrayToList(S01VA1, '*')#">
				</cfquery>
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