<cfcomponent extends="base">
	<cffunction name="crearLoginInterfaz" access="public" returntype="numeric">
		<!--- crea en SACISIIC,iplanet,cisco,ipass un login que ya existe en saci .
				Por tanto origen se asume como 'saci' --->
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="LGnumero" type="numeric" required="yes">
		<cfargument name="claveAcceso" type="string" required="yes">
		<cfargument name="claveCorreo" type="string" required="yes">
		<cfargument name="login_principal" type="string" required="yes">
		<cfargument name="S01CON_principal" type="numeric" default="0">
		
		<cfset control_inicio( Arguments, 'H001', 'LGnumero=' & Arguments.LGnumero )>
		<cftry>
			<cfset validarOrigen(Arguments.origen, 'saci')>
			<cfset ISBlogin = getISBlogin(Arguments.LGnumero)>
			<cfset control_asunto ( ISBlogin.LGlogin )>
			<cfset accesos = getTStipos(Arguments.LGnumero)>
			<cfset PQinterfaz = getPQinterfaz(Arguments.LGnumero,'ACCS')>
			
		<cfset control_servicio( 'siic' )>			
			<cfinvoke component="AddVentaServiciosSACISIIC" method="AddVentaServicios"
				LGnumero="#Arguments.LGnumero#" 
				login_principal="#Arguments.login_principal#"
				S01CON_principal="#Arguments.S01CON_principal#"
				returnvariable="S01CON_new" />
				
			<!--- cisco: acceso A => Acceso --->
			<cfif ListFind(accesos, 'A')>
				<cfset control_servicio( 'acceso' )>
				<cfset pq = 'undefined'>
				<cfif Len(PQinterfaz)>
					<cfset pq = PQinterfaz>
				<cfelse>
					<cfset pq = ISBlogin.PQnombre>
				</cfif>					
				<cfinvoke component="CiscoService" method="createUser"
					usuario="#ISBlogin.LGlogin#"
					clave="#Arguments.claveAcceso#"
					parentGroup="#pq#"
					listaTelefonos="#ISBlogin.LGtelefono#"
					maxSession="#ISBlogin.PQmaxSession#" />
			</cfif>
							
			<!--- iplanet: acceso C => Correo --->
			<cfif ListFind(accesos, 'C')>
				<cfset control_servicio( 'correo' )>
					
				<cfinvoke component="IPlanetService" method="add"
					usuario="#ISBlogin.LGlogin#"
					mailQuotaKB="#ISBlogin.LGmailQuota#"
					RealName="#ISBlogin.LGrealName#"
					nombre="#ISBlogin.Pnombre#"
					apellido="#ISBlogin.Papellido# #ISBlogin.Papellido2#"
					userPassword="#Arguments.claveCorreo#" />
			</cfif>
			
			<!--- ipass: acceso R => Roaming --->
			<cfif Not ListFind(accesos, 'R')>
				<!--- Guardar excepción en ipass cuando no hay roaming para el usuario --->
				<cfset control_servicio( 'roaming' )>
				<cfinvoke component="IPassService" method="agregarLoginIpass"
					usuario="#ISBlogin.LGlogin#" />
			</cfif>
			<cfset control_final( )>
			<cfreturn S01CON_new>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
			<cfreturn 0>
		</cfcatch>
		</cftry>
	</cffunction>
	<cffunction name="activar_cuenta" output="false" returntype="void" hint="Activa toda la cuenta, para invocarse desde el UI de SACI">
		<cfargument name="Contratoid" type="numeric" default="0" hint="Para activar los logines de un contrato">
		<cfargument name="LGnumero" type="numeric" default="0" hint="Para activar solo un login">

		<!--- Activación de logines en sistemas externos --->
		<cfquery name="logines_por_activar" datasource="#Session.DSN#">
			select b.LGnumero, b.LGlogin, s.SpwdCorreo, s.SpwdAcceso, a.CTid
			from ISBproducto a
				inner join ISBlogin b
					on b.Contratoid = a.Contratoid
				<!--- aunque ya se verifico que el sobre no exista, hace left join para que siempre salga el login incluso si no hay sobre --->
				left join ISBsobres s
					on s.Snumero = b.Snumero
			<cfif Arguments.LGnumero>
				where b.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
			<cfelseif Arguments.Contratoid>
				where a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#">
			<cfelse>
				<cfthrow message="Se requiere indicar el parámetros Contratoid o LGnumero para activar_cuenta.">
			</cfif>
			order by b.LGnumero
		</cfquery>
		
		<!--- Invocar interfaz de activación en SACISIIC.  No puede llamarse
			desde saci.comp.ISBlogin,
			como sería lógico, porque aquél está dentro de una transacción
			y es otra base de datos. Tampoco puede ir al repconnector, porque
			ocupa guardar del S01CON_principal cuando mando varios --->
		<cfset login_principal = logines_por_activar.LGlogin>
		<cfset S01CON_principal = 0>
		<cfloop query="logines_por_activar">
			<cfinvoke component="saci.ws.intf.H001_crearLoginSIIC"
				method="crearLoginInterfaz"
				origen="saci"
				LGnumero="#logines_por_activar.LGnumero#"
				claveAcceso="#logines_por_activar.SpwdAcceso#"
				claveCorreo="#logines_por_activar.SpwdCorreo#"
				login_principal="#login_principal#"
				S01CON_principal="#S01CON_principal#"
				returnvariable="S01CON_new" />
			<cfif logines_por_activar.CurrentRow is 1>
				<cfset S01CON_principal = S01CON_new>
			</cfif>
			<cfset control_reset()>
		</cfloop>

		<!--- Corroborar si la cuenta que estamos activando es de un agente --->
		<cfquery datasource="#session.dsn#" name="es_agente">
			select AGid
			from ISBagente
			where CTidAcceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#logines_por_activar.CTid#">
		</cfquery>
		<cfif es_agente.RecordCount>
			<cfinvoke component="saci.ws.intf.H045_agente"
				method="replicarAgente"
				origen="saci"
				operacion="A"
				AGid="#es_agente.AGid#"
				login_principal="#login_principal#"
				S01CON_principal="#S01CON_principal#"/>
			<cfset control_reset()>
		</cfif>
	</cffunction>
</cfcomponent>