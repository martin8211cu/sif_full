<cfcomponent hint="Ver SACI-03-H012.doc" extends="base">
	<cffunction name="borradoLogin" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="login" type="string" required="yes">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		
		<cfset borradoLoginLGnumero(origen, Arguments.login, 0, S02CON)>
	</cffunction>

	<cffunction name="borradoLoginLGnumero" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="login" type="string" required="yes">
		<cfargument name="LGnumero" type="numeric" required="yes">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		<cfargument name="NotificarSACI" type="boolean" required="No" default="yes">

		<cfset control_inicio( Arguments, 'H012', Arguments.login & ' Notificar a SACI - ' & Arguments.NotificarSACI )>
		<cftry>
			<cfset validarOrigen(Arguments.origen)>
			<cfset ProgramarAFuturo = false>
			<cfset Arguments.LGnumero = getLGnumero(Arguments.login, Arguments.LGnumero)>
		
			<cfset accesos = getTStipos(Arguments.LGnumero)>
			<!---
				1.	S02VA1 = "cta SIIC*login" 
				2.	S02VA1 = "cta SIIC*login*fecha*Operador*saldo"
				3.	S02VA1 = "cta SIIC*login*fecha*Operador*saldo*spam" --->
			<!--- saci --->
			<cfif not Arguments.origen is 'saci'>
				<cfset control_servicio( 'saci' )>
				<cfinvoke component="SSXS02" method="getTarea"
					S02CON="#Arguments.S02CON#" returnvariable="Tarea"/>
				<cfif ListLen(Tarea.S02VA1, '*') GE 3>
					<cfset fecha_retiro = ListGetAt(Tarea.S02VA1, 3, '*')>
					<cfset sdfDatetime2 = CreateObject("java", "java.text.SimpleDateFormat").init('dd/MM/yyyy')>
					<cfset fecha_retiro = sdfDatetime2.parse(fecha_retiro)>
				<cfelse>
					<cfset fecha_retiro = Now()>
				</cfif>
				<cfset ProgramarAFuturo = fecha_retiro GT Now()>
				
				<cfif ProgramarAFuturo>
					<cfquery datasource="#session.dsn#" name="consulta_login">
						select ct.Contratoid, ct.PQcodigo, ct.CTid
						from ISBlogin lg
							join ISBproducto ct
								on lg.Contratoid = lg.Contratoid
						where lg.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
					</cfquery>
					<cfquery datasource="#session.dsn#" name="motivo">
						select MRid from ISBmotivoRetiro
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and MRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(Tarea.S02VA2,1)#">
					</cfquery>
					<cfif motivo.RecordCount is 0>
						<cfthrow message="El motivo de retiro #Left(Tarea.S02VA2,1)# (#getMStexto(Tarea.S02VA2)#) no está parametrizado en SACI">
					</cfif>
					<!---Componente que genera el XML para el retiro de login--->
					<cfinvoke component="saci.comp.generadorXML" method="retiroLogin" returnvariable="loginXML"
						Contratoid="#consulta_login.Contratoid#"
						PQcodigo="#consulta_login.PQcodigo#"
						LGlogin="#Arguments.login#"
						motivoid="#motivo.MRid#"
						fecha="#fecha_retiro#"/>
					
					<cfquery datasource="#session.dsn#" name="buscar_tarea">
						select TPid from ISBtareaProgramada
						where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#consulta_login.CTid#">
						  and Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#consulta_login.Contratoid#">
						  and TPtipo = 'CP'
						  and TPestado = 'P'
					</cfquery>
					<cfinvoke component="saci.comp.ISBtareaProgramada" method="#IIf(buscar_tarea.RecordCount, DE('Cambio'), DE('Alta'))#"
						TPid="#buscar_tarea.TPid#"
						CTid="#consulta_login.CTid#"
						Contratoid="#consulta_login.Contratoid#"
						LGnumero="#Arguments.LGnumero#"
						TPinsercion="#now()#"
						TPfecha="#fecha_retiro#"
						TPdescripcion="Retiro de login (#Arguments.origen#)"
						TPxml="#loginXML#"
						TPestado="P"
						TPtipo="RL" 
						TPorigen="SIIC"/>
				
				<cfelse>
					<cfinvoke component="saci.comp.ISBlogin" method="RetirarLogin"
						LGnumero="#Arguments.LGnumero#"
						registrar_en_bitacora="true"
						fecha="#now()#"
						BLautomatica="1"
						BLobs="Borrado del login #Arguments.LGnumero#"
						MSoperacion="B"
						MSfechaEnvio="#Tarea.S02FEC#"
						MSmotivo="#Tarea.S02VA2#"
						MStexto="#getMStexto(Tarea.S02VA2)#"
						borradoLogico="true" 
						LGevento = "SIIC"/>
				</cfif>
			</cfif>
				<cfif Not ProgramarAFuturo>
					<!--- cisco: acceso A => Acceso --->
					<cfif ListFind(accesos, 'A')>
						<cfset control_servicio( 'acceso' )>
						<cfinvoke component="CiscoService" method="deleteUser"
							usuario="#Arguments.login#"/>
					</cfif>
									
					<!--- iplanet: acceso C => Correo --->
					<cfif ListFind(accesos, 'C')>
						<cfset control_servicio( 'correo' )>
						<cfinvoke component="IPlanetService" method="delete"
							usuario="#Arguments.login#" />
					</cfif>
									
					<!--- ipass: acceso R => Roaming --->
					<cfif Not ListFind(accesos, 'R')>
						<cfset control_servicio( 'roaming' )>
						<cfinvoke component="IPassService" method="borrarLoginIpass"
							usuario="#Arguments.login#" />
					</cfif>
				</cfif>
			<!--- siic --->
			<cfif Arguments.origen is 'siic'>
				<!--- cumplimiento --->
				<cfset control_servicio( 'siic' )>
				<cfinvoke component="SSXS02" method="Cumplimiento"
					S02CON="#Arguments.S02CON#"
					EnviarCumplimiento="#ListFind('O,G', Left(Tarea.S02VA2, 1))#" />
			<cfelseif Arguments.origen is 'saci' and NotificarSACI>
				<cfset ISBlogin = getISBlogin(Arguments.LGnumero)>
				
				<!--- Se actualiza la fecha de deshabilitación --->
				<cfquery datasource="SACISIIC">
					Update SSXSSC Set SSCFIN = getdate()
					Where SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.LGlogin#"> 
				</cfquery>
				
				
				<!--- Notificar al siic --->
				<cfset S01VA1 = ArrayNew(1)>
				<cfset ArrayAppend(S01VA1, ISBlogin.CUECUE)>
				<cfset ArrayAppend(S01VA1, ISBlogin.LGlogin)>
				<cfset ArrayAppend(S01VA1, dateformat(Now(),'yyyyMMDD'))>
				<cfset ArrayAppend(S01VA1, ISBlogin.Usulogin)>
				<cfset ArrayAppend(S01VA1, '0')>
				<cfset ArrayAppend(S01VA1, ISBlogin.CNdevolverdeposito)>
				<cfset ArrayAppend(S01VA1, ISBlogin.MRid)>
				<cfquery datasource="SACISIIC">
					exec sp_Alta_SSXS01
						@S01ACC = 'B',
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