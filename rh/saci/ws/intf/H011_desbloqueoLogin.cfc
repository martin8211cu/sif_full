<cfcomponent hint="Ver SACI-03-H011.doc" extends="base">
	<cffunction name="desbloqueoLogin" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="login" type="string" required="yes">
		<cfargument name="saldo" type="string" required="yes" default="0" hint="String por si viene vacío o inválido">
		<cfargument name="spam" type="boolean" required="yes" default="false">
		<cfargument name="motivo" type="string" default="" hint="Sólo se requiere si no viene de SACI">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		
		
		<cfset desbloqueoLGnumero(origen, Arguments.login, 0, saldo, spam, motivo, S02CON)>
	</cffunction>
	
	<cffunction name="desbloqueoLGnumero" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="login" type="string" required="yes">
		<cfargument name="LGnumero" type="numeric" required="yes">
		<cfargument name="saldo" type="string" required="yes" default="0" hint="String por si viene vacío o inválido">
		<cfargument name="spam" type="boolean" default="false">
		<cfargument name="motivo" type="string" default="" hint="Sólo se requiere si no viene de SACI">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		<cfargument name="OrigenbloqueoLogin" type="string" default="SACI" hint="Origen de las notificaciones">
		
		<cfset control_inicio( Arguments, 'H011', 'LGnumero=' & Arguments.LGnumero )>
		<cftry>
			<cfset validarOrigen(Arguments.origen, 'saci,siic')>
			<cfset Arguments.LGnumero = getLGnumero(Arguments.login, Arguments.LGnumero)>
			<cfset ISBlogin = getISBlogin(Arguments.LGnumero)>
			<cfset control_asunto ( ISBlogin.LGlogin )>
			<cfset accesos = getTStipos(Arguments.LGnumero)>
			
			<!--- saci --->
			<cfif Arguments.origen is 'siic'>
				<!--- invocar saci.comp.ISBbloqueoLogin, incluye llamado a cableras --->
				<cfif Not Len(Arguments.motivo)>
					<cfthrow message="No ha especificado el motivo de bloqueo" errorcode="ISB-0008">
				</cfif>
				<cfquery datasource="#session.dsn#" name="ISBmotivoBloqueo">
					select MBmotivo
					from ISBmotivoBloqueo
					where MBmotivo =
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.motivo#">
				</cfquery>
				<cfif ISBmotivoBloqueo.RecordCount is 0>
					<cfthrow message="No existe el motivo de bloqueo '#Arguments.motivo#'" errorcode="ISB-0009">
				</cfif>
	
				<cfquery datasource="#session.dsn#" name="querylogin">
					select LGlogin
					from ISBlogin
					where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
					and Habilitado = 1
				</cfquery>
			
				<cfif Not Len(querylogin.LGlogin)>
					<cfthrow message="El login #ISBlogin.LGlogin# no está activo">		
				</cfif>

	
				<cfset control_servicio( 'saci' )>
				<cfset control_mensaje( 'ISB-0011', 'Desbloqueando LGnumero #Arguments.LGnumero#' )>
				<cfquery datasource="#session.dsn#" name="rsBLQ">
					select BLQid,MBmotivo
					from ISBbloqueoLogin 
					where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
					and MBmotivo = <cfqueryparam cfsqltype="cf_sql_char" value="#ISBmotivoBloqueo.MBmotivo#">
					and BLQdesbloquear = 0
				</cfquery>
				<cfif rsBLQ.RecordCount is 0>
					<cfset control_mensaje( 'ISB-0011', 'Desbloqueando LGnumero #Arguments.LGnumero#' )>
				<cfelse>
					<cfset control_mensaje( 'ISB-0011', 'Motivo Desbloqueo #ISBmotivoBloqueo.MBmotivo#')>
					<cfinvoke component="saci.comp.ISBbloqueoLogin" method="Desbloquear"
						LGnumero="#Arguments.LGnumero#"
						MBmotivo="#ISBmotivoBloqueo.MBmotivo#"
						BLQhasta="#Now()#"
						BLQid="#rsBLQ.BLQid#"
						MStexto="Desbloqueo de login"
						BLorigen = "SIIC"/>
				</cfif>
			</cfif>
			<cfif Arguments.origen eq 'siic' or (Arguments.origen is 'saci' and Arguments.OrigenbloqueoLogin eq 'SACI')>
				<!--- cisco: acceso A => Acceso --->
				<cfif ListFind(accesos, 'A')>
					<cfset control_servicio( 'acceso' )>
					<cfinvoke component="CiscoService" method="changeUserParent"
						usuario="#ISBlogin.LGlogin#"
						newParent="#ISBlogin.PQnombre#" />
				</cfif>
				
				<!--- iplanet: acceso C => Correo --->
				<cfif ListFind(accesos, 'C')>
					<cfset control_servicio( 'correo' )>
					<cfinvoke component="IPlanetService" method="unlock"
						usuario="#ISBlogin.LGlogin#"/>
				</cfif>
				
				<!--- ipass: acceso R => Roaming --->
				<cfif ListFind(accesos, 'R')>
					<cfset control_servicio( 'roaming' )>
					<cfinvoke component="IPassService" method="borrarLoginIpass"
						usuario="#ISBlogin.LGlogin#" />
				</cfif>
			</cfif>
			
			<!--- siic --->
			<cfif Arguments.origen is 'siic'>
				<cfset control_servicio( 'siic' )>
				<!--- cumplimiento --->
				<cfinvoke component="SSXS02" method="getTarea"
					S02CON="#Arguments.S02CON#" returnvariable="Tarea"/>

				<cfinvoke component="SSXS02" method="Cumplimiento"
					S02CON="#Arguments.S02CON#"
					EnviarCumplimiento="#ListFind('O,G', Left(Tarea.S02VA2, 1))#"
					S01VA2="# IIf(Arguments.spam, DE('S'), DE(''))#" />
			<cfelseif Arguments.origen is 'saci'>
				<!--- Notificar al siic --->
				<cfif OrigenbloqueoLogin eq 'SACI' >
					<cfset S01VA1 = ArrayNew(1)>
					<cfset ArrayAppend(S01VA1, ISBlogin.CUECUE)>
					<cfset ArrayAppend(S01VA1, ISBlogin.LGlogin)>
					<cfset ArrayAppend(S01VA1, Arguments.motivo)>
					<cfquery datasource="SACISIIC">
						exec sp_Alta_SSXS01
							@S01ACC = 'D',
							@S01VA1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ArrayToList(S01VA1, '*')#">
					</cfquery>
				</cfif>
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