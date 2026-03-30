<cfcomponent hint="Ver SACI-03-H005.doc" extends="base">
	<cffunction name="reprogramacionLogin" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="login" type="string" required="yes">
		<cfargument name="paquete" type="string" required="yes">
		<cfargument name="sobre" type="string" required="yes" hint="No es numérico por si viene mal que se registre el error">
		<cfargument name="INTPAD" type="string" required="yes">
		<cfargument name="saldo" type="string" required="yes" default="0" hint="String por si viene vacío o inválido">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">

		<cfset reprogramacionLoginLGnumero(origen, login, 0, paquete, sobre, INTPAD, saldo, S02CON)>
	</cffunction>

	<cffunction name="reprogramacionLoginLGnumero" access="public" returntype="void">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="login" type="string" required="yes">
		<cfargument name="LGnumero" type="numeric" required="yes">
		<cfargument name="paquete" type="string" required="yes">
		<cfargument name="sobre" type="string" required="yes" hint="No es numérico por si viene mal que se registre el error">
		<cfargument name="INTPAD" type="string" required="yes">
		<cfargument name="saldo" type="string" required="yes" default="0" hint="String por si viene vacío o inválido">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		<cfargument name="NotificarSACI" type="boolean" required="No" default="yes">
			
		<cfset control_inicio( Arguments, 'H005', Arguments.login )>
		<cftry>
			
			
			<cfset validarOrigen(Arguments.origen)>
			<cfset Arguments.LGnumero = getLGnumero(Arguments.login, Arguments.LGnumero)>
			
			<cfset accesos = getTStipos(Arguments.LGnumero)>
			
			<cfif Arguments.sobre eq Arguments.login>
				<cfset control_mensaje( 'ARG-0001', 'sobre=login=#Arguments.sobre#' )>
				<cfset Arguments.sobre = 0>
			</cfif>
			
			<cfif Arguments.sobre>
				<cfquery datasource="#session.dsn#" name="ISBsobre">
					select
						coalesce (SpwdAcceso, SpwdCorreo) as SpwdAcceso,
						coalesce (SpwdCorreo, SpwdAcceso) as SpwdCorreo
					from ISBsobres
					where Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.sobre#">
				</cfquery>
				
				<cfif ISBsobre.RecordCount is 0>
					<cfthrow message="El sobre #Arguments.sobre# no aparece registrado." errorcode="ISB-0026">
				</cfif>
				<cfset SpwdAcceso = ISBsobre.SpwdAcceso> 
				<cfset SpwdCorreo = ISBsobre.SpwdCorreo>
			<cfelse>
				<cfset SpwdAcceso = Arguments.login> 
				<cfset SpwdCorreo = Arguments.login>
			</cfif>
			
			<cfset ISBlogin = getISBlogin(Arguments.LGnumero)>
			<!--- cisco: acceso A => Acceso --->
			<cfif ListFind(accesos, 'A')>
				<!--- Verificar que tenga contraseña de acceso --->
				<cfif Len(SpwdAcceso) is 0>
					<cfthrow message="El sobre #Arguments.sobre# no tiene contraseña de acceso." errorcode="ISB-0003">
				</cfif>
				<!--- Crear el login nuevo en CISCO --->
				<cfset control_servicio( 'acceso' )>
				<cfset control_mensaje( 'DBG-0000', 'cfinvoke component=CiscoService')>		
				<cfinvoke component="CiscoService" method="createUser"
					usuario="#Arguments.login#"
					clave="#SpwdAcceso#"
					parentGroup="#ISBlogin.PQnombre#"
					listaTelefonos="#ISBlogin.LGtelefono#"
					maxSession="#ISBlogin.PQmaxSession#" />
			</cfif>
							
			<!--- iplanet: acceso C => Correo --->
			<cfif ListFind(accesos, 'C')>
				<!--- Verificar que tenga contraseña de correo --->
				<cfif Len(SpwdCorreo) is 0>
					<cfthrow message="El sobre #Arguments.sobre# no tiene contraseña de correo." errorcode="ISB-0004">
				</cfif>
				<!--- Se crea el casillero de correos nuevo--->
				<cfset control_servicio( 'correo' )>
				<cfinvoke component="IPlanetService" method="add"
					usuario="#Arguments.login#"
					mailQuotaKB="#ISBlogin.LGmailQuota#"
					RealName="#ISBlogin.LGrealName#"
					nombre="#ISBlogin.Pnombre#"
					apellido="#ISBlogin.Papellido# #ISBlogin.Papellido2#"
					userPassword="#SpwdCorreo#" />
			</cfif>
							
			<!--- ipass: acceso R => Roaming --->
			<cfif Not ListFind(accesos, 'R')>
				<!--- Incluir en lista de accesos el login anterior --->
				<cfset control_servicio( 'roaming' )>
				<cfinvoke component="IPassService" method="agregarLoginIpass"
					usuario="#Arguments.login#" />
			</cfif>
		
		<!--- saci --->
			<cfif not Arguments.origen is 'saci'>
				<cfset control_servicio( 'saci' )>
				<cfinvoke component="SSXS02" method="getTarea"
					S02CON="#Arguments.S02CON#" returnvariable="Tarea"/>
					
				<cfquery datasource="SACISIIC" name="SSXINT_TELEFONO">
					select INTTEL 
					from SSXINT 
					where SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.login#">
				</cfquery>
				
				<cfif SSXINT_TELEFONO.RecordCount GT 0>
				<cfquery datasource="#session.dsn#" name="SSXINT_TELEFONO">
					update ISBlogin  set LGtelefono = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SSXINT_TELEFONO.INTTEL#" 
						null="#Len(SSXINT_TELEFONO.INTTEL) EQ 0 OR SSXINT_TELEFONO.INTTEL EQ '0000000'#">
					where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
				</cfquery>
						
			</cfif>
				
				<!---<cfset control_mensaje( 'ERR-0000', 'cfinvoke_component=saci.comp.ISBlogin method=ReprogramarLogin')>--->		
				<cfset control_mensaje( 'ISB-0001', 'Reprogramar LGnumero=#Arguments.LGnumero#,LGlogin=#Arguments.login#' )>
				<cfinvoke component="saci.comp.ISBlogin" method="ReprogramarLogin">
					<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
					<cfinvokeargument name="LGlogin" value="#Arguments.login#">
					<cfinvokeargument name="Snumero" value="#Arguments.sobre#">
					<cfinvokeargument name="CNnumero" value="#Arguments.INTPAD#">
					<cfinvokeargument name="BLautomatica" value="1">
					<cfinvokeargument name="MSoperacion" value="P">
					<cfinvokeargument name="MSfechaEnvio" value="#Tarea.S02FEC#">
					<cfinvokeargument name="MSsaldo" value="#Arguments.saldo#">
					<cfinvokeargument name="MSmotivo" value="#Tarea.S02VA2#">
					<cfinvokeargument name="MStexto" value="#getMStexto(Tarea.S02VA2)#">
					<cfinvokeargument name="LGevento" value="SIIC">
				</cfinvoke>
				<cfif Arguments.sobre is 0>
					<cfset control_mensaje( 'ISB-0002', 'LGnumero=#Arguments.LGnumero#,LGlogin=#Arguments.login#' )>
					<cfquery datasource="#session.dsn#">
						update ISBserviciosLogin
						set SLpasswordExp = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('h', 24, Now())#">
						where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
					</cfquery>
				</cfif>
			</cfif>
			
		
			<!--- siic --->
			<cfif Arguments.origen is 'siic'>
				<cfset control_servicio( 'siic' )>
				<cfif Arguments.INTPAD neq ''>
					<cfset control_mensaje( 'SIC-0002', 'INTPAD=#Arguments.INTPAD#,SERCLA=#Arguments.login#' )>
					<cfquery datasource="SACISIIC">
						update SSXINT
						set INTPAD = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.INTPAD#">
						where SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.login#">
					</cfquery>
				</cfif>
				<!--- Cumplimiento --->
				<cfinvoke component="SSXS02" method="Cumplimiento"
					S02CON="#Arguments.S02CON#"
					EnviarCumplimiento="#ListFind('O,G', Left(Tarea.S02VA2, 1))#"/>
			
			<cfelseif Arguments.origen is 'saci' And NotificarSACI>
			
			
				<cfquery datasource="#session.dsn#" name="ISBgarantia">
					select g.Gtipo, g.Gmonto, g.Gref, g.Ginicio, g.Miso4217, ef.INSCOD
					from ISBgarantia g
					left join ISBentidadFinanciera ef
					on ef.EFid = g.EFid
					where g.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBlogin.Contratoid#">
				</cfquery>

						
			   <cfif Not ISBlogin.LGprincipal>
				
					<cfquery datasource="SACISIIC">
						exec sp_Alta_SSXDEP
						<!---El monto se indica en la interfaz SACI-03-H029b--->
						@DEPMON = <cfqueryparam cfsqltype="cf_sql_float" value="0"> 
						, @DEPMOD = <cfif ISBgarantia.Miso4217 is 'USD'>'D'<cfelse>'C'</cfif>
						, @SERIDS = null
						, @SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.LGlogin#" null="#Len(ISBlogin.LGlogin) is 0#">
						, @INSCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ISBgarantia.INSCOD#" null="#Len(ISBgarantia.INSCOD) is 0#">
						, @DEPDOC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBgarantia.Gref#" null="#Len(ISBgarantia.Gref) is 0#">
						, @DEPFED =
						<cfif Len(ISBgarantia.Ginicio)>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#DateFormat(ISBgarantia.Ginicio, 'yyyymmdd')#">
						<cfelse> NULL </cfif>			
						, @FIDCOD = <cfif Len(ISBgarantia.Gtipo)>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#ISBgarantia.Gtipo#" null="#Len(ISBgarantia.Gtipo) is 0#">
						<cfelse> 1 </cfif>
						, @MAAT 	= 1
						, @RETORNO = 0
					</cfquery>
				
				</cfif>
			
				<cfquery datasource="SACISIIC">
					update SSXINT
					set INTTEL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.LGtelefono#">
					where SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ISBlogin.LGlogin#">
				</cfquery>
			
			
			
				<!--- Notificar al siic --->
				<cfset S01VA1 = ArrayNew(1)>
				<cfset ArrayAppend(S01VA1, ISBlogin.CUECUE)>
				<cfset ArrayAppend(S01VA1, ISBlogin.LGlogin)>
				<cfset ArrayAppend(S01VA1, ISBlogin.CINCAT)>
				<cfset ArrayAppend(S01VA1, ISBlogin.Snumero)>
				<cfset ArrayAppend(S01VA1, '0')>
				<cfset ArrayAppend(S01VA1, ISBlogin.LGserids)>
				  
				<cfif Len(ISBlogin.MRidMayorista)>
				<!---es cable modem se agrega el suscriptor--->
					<cfset ArrayAppend(S01VA1, ISBlogin.LGserids)>
				<cfelseif ListFind('8,9', ISBlogin.CINCAT)> 
					<!--- es paquete de correo --->
					<cfquery datasource="#session.dsn#" name="LGserids_padre">
					select LGserids
						from ISBlogin 
						where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ISBlogin.Contratoid#">
							and LGserids is not null
							and LGserids != ''
							and LGprincipal = 1
						order by LGnumero
					</cfquery>
					<cfset LGserids_padre = LGserids_padre.LGserids>
					<cfset ArrayAppend(S01VA1, LGserids_padre)>
				<cfelse>
				<!--- dejar el S01VA1 hasta donde iba --->
				</cfif>
				
				<cfif NotificarSACI>
				<cfquery datasource="SACISIIC">
					exec sp_Alta_SSXS01
						@S01ACC = '1',
						@S01VA1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ArrayToList(S01VA1, '*')#">
				</cfquery>
				</cfif>
			</cfif>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
			<cfinvoke component="SSXS02" method="Error"
				Error="#Request._saci_intf.Error#"
				S02CON="#Arguments.S02CON#"/>
		</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>