<cfcomponent hint="Ver SACI-03-H007.doc" extends="crearLoginSACI">
	<cffunction name="internetDedicado" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="opcion" type="string" required="yes">
		<cfargument name="paquete" type="string" required="yes">
		<cfargument name="CUECUE" type="string" required="yes" default="0">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		
		<cfset control_inicio( Arguments, 'H007', Arguments.opcion & ' ' & Arguments.CUECUE )>
		<cftry>
			<cfset validarOrigen(Arguments.origen, 'siic')>
			<cfquery datasource="SACISIIC" name="SSXSSC" maxrows="1">
				select SERCLA, CUECUE
				from SSXSSC
				where CUECUE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CUECUE#">
			</cfquery>
			<cfset control_mensaje( 'QRY-0001', '#SSXSSC.RecordCount# rows' )>
			<cfif SSXSSC.RecordCount is 0>
				<cfthrow message="No hay login con CUECUE #Arguments.CUECUE#" errorcode="QRY-0007">
			</cfif>
			<cfquery datasource="SACISIIC" name="SSXINT" maxrows="1">
				select INTSOB
				from SSXINT
				where SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SSXSSC.SERCLA#">
			</cfquery>
			<cfset asunto = SSXSSC.SERCLA & ' ' & Arguments.CUECUE & ' (' & Arguments.opcion & ')'>
			<cfset control_asunto ( asunto )>
			<cfset validarOrigen(Arguments.origen)>
			<cfif Arguments.opcion is 'B'><!---Borrado--->
				<cfset borradoInternetDedicado (SSXSSC.SERCLA, Arguments.CUECUE,
					Arguments.S02CON) >
			<cfelseif Arguments.opcion is 'P'><!---Programación--->
				<cfset programacionInternetDedicado (SSXSSC.SERCLA, Arguments.CUECUE,
					SSXINT.INTSOB, Arguments.S02CON ) >
			</cfif>

			<cfset control_servicio( 'siic' )>
			<cfinvoke component="SSXS02" method="Cumplimiento"
				S02CON="#Arguments.S02CON#" />

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
	<!---borradoInternetDedicado--->
	<cffunction name="borradoInternetDedicado" access="private" returntype="void">
		<cfargument name="LGlogin" type="string" required="yes">
		<cfargument name="CUECUE" type="numeric" required="no">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
	
		<!--- saci --->
		<cfset control_servicio( 'saci' )>
		<cfset LGnumero = getLGnumero(Arguments.LGlogin)>
		<cfset control_mensaje( 'ISB-0005', 'Retirar login #Arguments.LGlogin#, LGnumero=#LGnumero#' )>
		<cfinvoke component="saci.comp.ISBlogin" method="RetirarLogin">
			<cfinvokeargument name="LGnumero" value="#LGnumero#">
			<cfinvokeargument name="registrar_en_bitacora" value="true">
			<cfinvokeargument name="fecha" value="#Now()#">
			<cfinvokeargument name="BLautomatica" value="1">
			<cfinvokeargument name="BLobs" value="Borrado de internet dedicado por interfaz">
			<cfinvokeargument name="borradoLogico" value="true">
		</cfinvoke>
	</cffunction>

	<!--- programacionInternetDedicado --->
	<cffunction name="programacionInternetDedicado" access="public" returntype="string" output="false">
		<!--- crea en SACI,iplanet,cisco,ipass un login que ya existe en siic .
				Por tanto origen se asume como 'siic' --->
		<cfargument name="login" type="string" required="yes" hint="Login por crear">
		<cfargument name="CUECUE" type="string" required="yes" default="0">
		<cfargument name="sobre" type="string" required="yes" hint="Sobre con la contraseña. String por si no viene o viene mal">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		
		<cfset control_servicio( 'siic' )>
		<cfif Not Len(Trim(Arguments.sobre))>
			<cfset Arguments.sobre = 0>
		</cfif>
		<cfset datosLogin = leerDatosLoginSACISIIC(Arguments.login, Arguments.sobre, '', Arguments.CUECUE)>
		
		<cfset control_servicio( 'saci' )>
		<cftransaction>
			<cfset control_mensaje( 'ISB-0001', 'Reprogramar login=#Arguments.login#' )>
			<cfset crearEnSaci(Arguments.login, datosLogin, Arguments.sobre, '',
				"Creación de usuario por interfaz, orden núm " & Arguments.S02CON)>
		</cftransaction>
		
		<!--- actualizar SSXSSC con el nuevo codigo --->
		<cfset control_servicio( 'siic' )>
		<cfquery datasource="SACISIIC" name="update_q">
			update SSXSSC
			set SSCCTA = <cfqueryparam cfsqltype="cf_sql_integer" value="#datosLogin.CTid#">
			where SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.login#">
			select @@rowcount as update_rowcount
		</cfquery>
		<cfset control_mensaje( 'SIC-0004', 'SSCCTA=#datosLogin.CTid# para SERCLA=#Arguments.login#, #update_q.update_rowcount# registro(s)' )>
	</cffunction>

</cfcomponent>