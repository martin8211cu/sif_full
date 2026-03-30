<cfcomponent hint="Ver SACI-03-H039.doc" extends="base">
	<cffunction name="cambioPassword" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="login" type="string" required="yes">
		<cfargument name="sobre" type="string" required="yes">
		<cfargument name="tipocambio" type="string" required="yes">
		<cfargument name="clave" type="string" required="yes">
		<cfargument name="rethrow" type="boolean" default="no">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		
		<cfset cambioPasswordLGnumero(origen, login, getLGnumero(Arguments.login, 0, true), sobre, tipocambio, clave, rethrow, S02CON)>
	</cffunction>
	
	<cffunction name="cambioPasswordLGnumero" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="LGlogin" type="string" required="yes">
		<cfargument name="LGnumero" type="numeric" required="yes">
		<cfargument name="Snumero" type="numeric" required="yes" hint="Núm de sobre, o 0 si no aplica">
		<cfargument name="tipocambio" type="string" required="yes">
		<cfargument name="clave" type="string" required="yes" default="Indique 0 en el sobre para usar este valor">
		<cfargument name="rethrow" type="boolean" default="no">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		<!---
		<cfdump var="#Arguments.clave#">
		<cfdump var="#Arguments.LGnumero#">
		<cfdump var="#Arguments.Snumero#">
		--->
		<cfset control_inicio( Arguments, 'H039', Arguments.LGlogin )>
		<cftry>
			<cfset validarOrigen(Arguments.origen)>
			<cfset accesos = getTStipos(Arguments.LGnumero)>

			<cfif Not ListFind('acceso,global,correo,saci',Arguments.tipocambio)>
				<cfthrow message="El servicio #Arguments.tipocambio# no es válido">
			</cfif>


			<!--- Obtener los datos generales del login --->
			<cfset ISBlogin = getISBlogin(Arguments.LGnumero)>
			<cfif Arguments.Snumero is 0>
				<cfset SpwdAcceso = clave>
				<cfset SpwdCorreo = clave>
			<cfelse>
				<cfquery datasource="#session.dsn#" name="ISBsobres">
					select SpwdAcceso, SpwdCorreo 
					  from ISBsobres 
					 where Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#">
					 and Sestado = '0'
					 <cfif LCase(Arguments.tipocambio) is 'global' OR LCase(Arguments.tipocambio) is 'acceso'>				
					 and Sgenero in ('M','A') 
					<cfelseif LCase(Arguments.tipocambio) is 'global' OR LCase(Arguments.tipocambio) is 'correo'>
					 and Sgenero in ('M','C') 
					</cfif>
				</cfquery>
			
				<cfif ISBsobres.RecordCount is 0>
					<cfthrow message="El sobre #Arguments.Snumero# no está disponible para el servicio #Arguments.tipocambio#" errorcode="ISB-0026">
				</cfif>
				<cfset SpwdAcceso = ISBsobres.SpwdAcceso>
				<cfset SpwdCorreo = ISBsobres.SpwdCorreo>
			</cfif>
			
			<!--- saci --->
			<cfif isdefined("ISBsobres") and ISBsobres.RecordCount gt 0>
				<cfset control_servicio( 'saci' )>
				<cfinvoke component="saci.comp.ISBlogin" method="CambioPasswordSobre">
					<cfinvokeargument name="Snumero" value="#Arguments.Snumero#">
					<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
					<cfinvokeargument name="LGlogin" value="#Arguments.LGlogin#">
					<cfinvokeargument name="BLautomatica" value="true">
				</cfinvoke>
			</cfif>

			<!--- cisco: acceso A => Acceso --->
			<cfif LCase(Arguments.tipocambio) is 'global' OR LCase(Arguments.tipocambio) is 'acceso'>
				<cfif ListFind(accesos, 'A')>
					<cfset control_servicio( 'acceso' )>
					<!--- Modificar contraseña en CISCO --->
					<cfinvoke component="CiscoService" method="updatePassword" 
						usuario="#Arguments.LGlogin#"
						newPassword="#SpwdAcceso#" />
				<cfelse>
					<cfset control_mensaje( 'ISB-0027', 'El usuario #Arguments.LGlogin# no tiene servicio de acceso, no se puede cambiar la contraseña' )>
				</cfif>
			</cfif>
							
			<!--- iplanet: acceso C => Correo --->
			<cfif LCase(Arguments.tipocambio) is 'global' OR LCase(Arguments.tipocambio) is 'correo'>
				<cfif ListFind(accesos, 'C')>
					<cfset control_servicio( 'correo' )>
					<!--- Se elimina el casillero de correos anterior --->
					<cfinvoke component="IPlanetService" method="updatePassword"
						usuario="#Arguments.LGlogin#"
						userPassword="#SpwdCorreo#" />
				<cfelse>
					<cfset control_mensaje( 'ISB-0027', 'El usuario #Arguments.LGlogin# no tiene servicio de correo, no se puede cambiar la contraseña' )>
				</cfif>
			</cfif>

			<cfif LCase(Arguments.tipocambio) is 'saci'>
				<!---cambiar contraseña de saci--->
				<cfquery datasource="#session.dsn#" name="Usuario_Q">
					select Usucodigo 
					  from Usuario 
					 where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LGlogin#"> and 
					       CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
				</cfquery>
				<cfset control_servicio( 'saci' )>
				<cfif Usuario_Q.RecordCount>
					<cfinvoke component="home.Componentes.Seguridad" method="renombrarUsuario">
						<cfinvokeargument name="Usucodigo" value="#Usuario_Q.Usucodigo#">
						<cfinvokeargument name="nuevo_login" value="#Arguments.LGlogin#">
						<cfinvokeargument name="nuevo_password" value="#Arguments.LGlogin#">
					</cfinvoke>
				<cfelse>
					<cfset control_mensaje( 'ISB-0027', 'El usuario #Arguments.LGlogin# no tiene acceso al SACI, no se puede cambiar la contraseña' )>
				</cfif>
			</cfif>
							
			<!--- siic --->
			<cfif Arguments.origen is 'siic'>
				<cfset control_servicio( 'siic' )>
				<!--- cumplimiento --->
				<cfinvoke component="SSXS02" method="Cumplimiento"
					S02CON="#Arguments.S02CON#" />

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
			<cfif rethrow><cfrethrow></cfif>
		</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>