<cfcomponent hint="Ver SACI-03-H013.doc" extends="base">
	<cffunction name="cambioLogin" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="loginAnterior" type="string" required="yes">
		<cfargument name="loginNuevo" type="string" required="yes">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		
		<cfset cambioLoginLGnumero(origen, loginAnterior, loginNuevo, 0, S02CON)>
	</cffunction>
	
	<cffunction name="cambioLoginLGnumero" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="loginAnterior" type="string" required="yes">
		<cfargument name="loginNuevo" type="string" required="yes">
		<cfargument name="LGnumero" type="numeric" required="yes">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		<cfargument name="NotificarSACI" type="boolean" required="No" default="yes">
		
		<cfif origen eq 'SACI' and Not NotificarSACI>
		<cfreturn>
		</cfif>
		
		<cfset control_inicio( Arguments, 'H013', 'Notificación-' & Arguments.NotificarSACI & ' ' & Arguments.loginAnterior & ' - ' & Arguments.loginNuevo )>
		<cftry>
			
			<cfset validarOrigen(Arguments.origen)>
			<cfif Arguments.origen neq 'saci'>
				<cfset Arguments.LGnumero = getLGnumero(Arguments.loginAnterior, Arguments.LGnumero)>
				<cfset control_arguments( Arguments )>
				
				<!--- Verificación que el nuevo login no exista --->
				<cfquery datasource="#session.dsn#" name="login_repetido">
					select count(1) as cant 
					from ISBlogin 
					where Habilitado = 1
					  and LGlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.loginNuevo#">
					  <!--- valido otro LGnumero por si es que se está reenviando la tarea --->
					  and LGnumero != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
				</cfquery>
				
				<cfif login_repetido.cant is 1>
					<!--- TO DO: --->
					<!--- Se debe definir el código del error --->
					<cfthrow message="El login solicitado(#Arguments.loginNuevo#) ya existe y está habilitado">
				</cfif>
			</cfif>

				<cfquery datasource="#session.dsn#" name="login_actual">
					select count(1) as cant 
					from ISBlogin 
					where Habilitado = 1
					  and LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
				</cfquery>

				<cfif login_actual.cant is 0>
					<!--- TO DO: --->
					<!--- Se debe definir el código del error --->
					<cfthrow message="El login actual #Arguments.loginAnterior# no está Habilitado">
				</cfif>
					
			<cfset accesos = getTStipos(Arguments.LGnumero)>
			
			<!--- saci --->
			<cfif not Arguments.origen is 'saci'>
				<cfset control_servicio( 'saci' )>
				<cfquery datasource="#session.dsn#" name="info_login">
					select LGlogin
					from ISBlogin
					where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
				</cfquery>
				<cfif info_login.LGlogin neq Arguments.loginNuevo>
					<!---
						esto se valida porque podría estarse reenviando la tarea, en cuyo caso no
						hay necesidad de cambiar el login de nuevo
					--->
					<cfinvoke component="saci.comp.ISBlogin" method="CambioLogin">
						<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
						<cfinvokeargument name="LGlogin" value="#Arguments.loginNuevo#">
						<cfinvokeargument name="BLautomatica" value="1">
						<cfinvokeargument name="LGevento" value="SIIC">
					</cfinvoke>
				</cfif>
			</cfif>
			
			<cfset ISBlogin = getISBlogin(Arguments.LGnumero)>
			<!--- cisco: acceso A => Acceso --->
			
			<cfif ListFind(accesos, 'A')>
				<!--- Crear el login nuevo en CISCO --->
				<cfset control_servicio( 'acceso' )>
				<cfinvoke component="CiscoService" method="renameUser"
					usuario="#Arguments.loginAnterior#"
					nuevo="#Arguments.loginNuevo#">
			</cfif>
							
			<!--- iplanet: acceso C => Correo --->
			<cfif ListFind(accesos, 'C')>
				<!--- Se crea el casillero de correos nuevo--->
				<cfset control_servicio( 'correo' )>
				<cfinvoke component="IPlanetService" method="rename"
					usuario="#Arguments.loginAnterior#"
					nuevo="#Arguments.loginNuevo#" />
			</cfif>
							
			<!--- ipass: acceso R => Roaming --->
			<cfif Not ListFind(accesos, 'R')>
				<!--- Incluir en lista de accesos el login anterior --->
				<cfset control_servicio( 'roaming' )>
				<cfinvoke component="IPassService" method="borrarLoginIpass"
					usuario="#Arguments.loginAnterior#" />
				<cfinvoke component="IPassService" method="agregarLoginIpass"
					usuario="#Arguments.loginNuevo#" />
			</cfif>
		
			<!--- siic --->
			<cfif Arguments.origen is 'siic'>
				
				<cfinvoke component="SSXS02" method="getTarea"
					S02CON="#Arguments.S02CON#" returnvariable="Tarea"/>
				<!--- Cumplimiento --->
				<cfset control_servicio( 'siic' )>

				<cftransaction>
				<cfquery datasource="SACISIIC">
					insert into SSXINT (
						SERCLA, CINCAT, SERGUI, INTNOM,
						INTCED, INTOBS, INTVEN, INTSOB,
						SERTIP, INTCON, INTTEL, INTPER, INTPAD )
					select
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.loginNuevo#">,
							CINCAT, SERGUI, INTNOM,
						INTCED, INTOBS, INTVEN, INTSOB,
						SERTIP, INTCON, INTTEL, INTPER, INTPAD 
					from SSXINT
					where SERCLA =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.loginAnterior#">
					and not exists (
						select 1 from SSXINT
						where SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.loginNuevo#">
						)
				</cfquery>
				<cfquery datasource="SACISIIC">
					update SSXSSC
					set SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.loginNuevo#">
					where SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.loginAnterior#">
				</cfquery>
				<cfquery datasource="SACISIIC">
					delete SSXINT
					where SERCLA =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.loginAnterior#">
				</cfquery>
				</cftransaction>
				

				<cfinvoke component="SSXS02" method="Cumplimiento"
					S02CON="#Arguments.S02CON#"
					EnviarCumplimiento="#ListFind('O,G', Left(Tarea.S02VA2, 1))#" />
				
			<cfelseif Arguments.origen is 'saci'>
				<!--- Notificar al siic --->
				<cfset S01VA1 = ArrayNew(1)>
				<cfset ArrayAppend(S01VA1, ISBlogin.CUECUE)>
				<cfset ArrayAppend(S01VA1, Arguments.loginAnterior)>
				<cfset ArrayAppend(S01VA1, Arguments.loginNuevo)>
				<cfquery datasource="SACISIIC">
					exec sp_Alta_SSXS01
						@S01ACC = 'G',
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