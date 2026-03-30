<cfcomponent extends="crearLoginSACI">
	<!--- crearUsuarioVPN --->
	<cffunction name="usuarioVPN" access="public" returntype="string" output="false">
		<!--- crea en SACI,iplanet,cisco,ipass un login que ya existe en siic .
				Por tanto origen se asume como 'siic' --->
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="CUECUE" type="string" required="yes">
		<cfargument name="login" type="string" required="yes" hint="Login por crear">
		<cfargument name="sobre" type="string" required="yes" hint="Sobre con la contraseña. String por si no viene o viene mal">
		<cfargument name="dominioVPN" type="string" required="yes" hint="Dominio VPN al que pertenece">
		<cfargument name="opcion" type="string" required="yes">
		<cfargument name="maxsession" type="string" default="1">	
		<cfargument name="S02VA2" type="string" required="yes">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		
		<cfset control_inicio( Arguments, 'H018', Arguments.login & '@' & Arguments.dominioVPN & '(' & Arguments.opcion & ')' )>
		
		<cftry>
			<cfset validarOrigen(Arguments.origen, 'siic')>
			<cfif Arguments.login is Arguments.sobre>
				<cfset control_mensaje( 'ARG-0001', 'sobre=login=#Arguments.sobre#' )>
				<cfset Arguments.sobre = 0>
			</cfif>
			<cfparam name="Arguments.sobre" type="numeric">
			<cfif Arguments.opcion is 'P'>
				<cfset control_servicio( 'siic' )>
				<cfset datosLogin = leerDatosLoginSACISIIC(Arguments.login, Arguments.sobre, Arguments.dominioVPN, Arguments.CUECUE)>
				
				<cfset control_servicio( 'saci' )>
				<cftransaction>
					<cfset crearEnSaci(Arguments.login, datosLogin, Arguments.sobre, Arguments.dominioVPN,
						"Creación de usuario por interfaz, orden núm " & Arguments.S02CON)>
				</cftransaction>
				<cfset accesos = getTStipos(getLGnumero(Arguments.login))>
				
				<!--- actualizar SSXINT con el nuevo codigo --->
				<cfset control_servicio( 'siic' )>
				<cfset control_mensaje( 'SIC-0004', 'SSCCTA=#datosLogin.CTid# para SERCLA=#Arguments.login#' )>
				<cfquery datasource="SACISIIC">
					update SSXSSC
					set SSCCTA = <cfqueryparam cfsqltype="cf_sql_integer" value="#datosLogin.CTid#">
					where SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.login#">
				</cfquery>
				<!---
					no agregar los servicios cisco/iplanet, porque se va
					a disparar la interfaz H014b
					que se encarga de agregarlos --->
				<!--- ipass: acceso R => Roaming --->
				<cfif Not ListFind(accesos, 'R')>
					<cfset control_servicio( 'roaming' )>
					<!--- Guardar excepción en ipass cuando no hay roaming para el usuario --->
					<cfinvoke component="IPassService" method="agregarLoginIpass"
						usuario="#ISBlogin.LGlogin#" />
				</cfif>
			<cfelseif Arguments.opcion is 'B'>
				<!--- consultar ISBlogin --->
				<cfset control_servicio( 'saci' )>
				<cfset LGnumero = getLGnumero(Arguments.login)>
				<cfset ISBlogin = getISBlogin(LGnumero)>
				<cfif ISBlogin.Habilitado neq 1>
					<!--- Sólo un warning y de todos modos va a los externos, por si es un reenvío de la interfaz --->
					<cfset control_mensaje( 'ISB-0030', 'El login #Arguments.login# no está activo' )>
				<cfelse>
					<cfset accesos = getTStipos(ISBlogin.LGnumero)>
					<cfset control_mensaje( 'ISB-0005', 'Retirando login VPN #Arguments.login# #ISBlogin.LGnumero#' )>
					<cfinvoke component="saci.comp.ISBlogin" method="RetirarLogin">
						<cfinvokeargument name="LGnumero" value="#ISBlogin.LGnumero#">
						<cfinvokeargument name="registrar_en_bitacora" value="true">
						<cfinvokeargument name="fecha" value="#now()#" 	>
						<cfinvokeargument name="BLautomatica" value="1">
						<cfinvokeargument name="BLobs" value="Borrado de usuario VPN #ISBlogin.LGnumero#, orden núm #Arguments.S02CON#">
						<cfinvokeargument name="borradoLogico" value="true">
					</cfinvoke>
				</cfif>
				<!---
					no borrar los servicios cisco/iplanet/ipass, porque se va
					a disparar la interfaz H014b
					que se encarga de borrarlos --->
			<cfelse>
				<cfthrow message="La opción #Arguments.opcion# no es válida. Los valores válidos son P y B para Programación y Borrado respectivamente" errorcode="ARG-0002">
			</cfif>
			
			<cfset control_servicio( 'siic' )>
			<cfinvoke component="SSXS02" method="Cumplimiento"
				S02CON="#Arguments.S02CON#"
				EnviarCumplimiento="#ListFind('G,O', Left(Arguments.S02VA2, 1) )#"/>
			
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