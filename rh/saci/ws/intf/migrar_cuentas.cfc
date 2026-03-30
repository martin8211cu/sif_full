<cfcomponent>

	<cfset init_lookup()>

	<!--- MillisFormat --->
	<cffunction name="MillisFormat" output="false" returntype="string">
		<cfargument name="ms">
		<cfset Segundos = Arguments.ms / 1000>
		<cfset Minutos = Int (Segundos / 60) mod 60>
		<cfset Horas = Int (Segundos / 3600)>
		<cfset Segundos = Segundos - Minutos * 60 - Horas * 3600>
		<cfreturn
			NumberFormat(Horas, '0') & ":" &
			NumberFormat(Minutos, '00') & ":" &
			NumberFormat(Segundos, '00.00') >
	</cffunction>	
	<!--- query_cedulas --->
	<cffunction name="query_cedulas" returntype="numeric">
		<cfargument name="maxrows" type="numeric" required="yes">
		<cfquery datasource="#session.dsn#" name="ret">
			set rowcount #Arguments.maxrows#
			insert into migra_cedula (cedula)
			select distinct
				s07.SAI07CED as cedula
			from SACI..SAI007 s07
			order by s07.SAI07CED
			select @@rowcount as TotalRows
			set rowcount 0
		</cfquery>
		<cfreturn ret.TotalRows>
	</cffunction>
	<!--- migrar_cedula --->
	<cffunction name="migrar_cedula" returntype="boolean" output="false" hint="Regresa true si ejecuta sin errores">
		<cfargument name="cedula" type="string">
		<cfset This.errorcount = 0>
		<!--- ver si la cédula tiene una única cuenta --->
		<cfquery datasource="SACISIIC" name="porced">
			select clt.CLTCOD, clt.CLTSIS, cue.CUECUE, cue.CUESIS
			from SSMCLT clt
				join SSMCUE cue
					on cue.CLTCOD = clt.CLTCOD
					and cue.CLTSIS = clt.CLTSIS
			where clt.CLTCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cedula#">
			order by cue.update_time desc
		</cfquery>
		<!--- si sólo tiene una cuenta, realizar búsqueda suplementaria usando esa cuenta --->
		<cfset variables.hayCuentaDefault = porced.RecordCount ge 1>
		<!--- query de logines --->
		<cfquery datasource="SACISIIC" name="logines">
			<!--- FORCEPLAN no requerido en UOSERVER/Linux/12.5.3/ESD#2, pero sí en 440/Sunv4/12.5.3/ESD#7--->
			<!---set forceplan on--->
			select
				s01.SAI01COD, s01.SAI01LOG, s01.SAI01BOR, s01.update_time, s01.SAI01EST,s01.SAI01FEC
				
				s07.SAI07COD, s07.SAI03COD, s07.SAI07BOR,
				
				ssc.SSCCTA, ssc.VENCOD,
				ssc.CUECUE as CUECUE, ssc.SSCINC, ssc.SSCFIN, ssc.SSCFAP,
				ssc.ESCCOD, ssc.CONCGO, ssc.SERIDS, ssc.SERCLA,
				
				xint.SERGUI, xint.INTTEL, xint.INTSOB, xint.SERCLA,
				
				case when exists (select 1 from SACI..SAI065 s65
					where s65.SAI03HIJ = s07.SAI03COD) then 1 else 0 end as eshijo,
				
				<cfloop list="CUEGER,ACTCOD,CUEDIR,CUETEL,CUETL2,CUEFAX,CUEFAP,CUETIP,CLACOD,PRVCOD,CANCOD,DISCOD,CUEOBS" index="campo">
					case when cue.CUECUE is not null then cue.#campo#
						when cue2.CUECUE is not null then cue2.#campo#
						<cfif variables.hayCuentaDefault>
						else cue3.#campo#</cfif>
					end as #campo#,
				</cfloop>
				case when cue.CUECUE is not null then 1
					when cue2.CUECUE is not null then 2
					<cfif variables.hayCuentaDefault>
					else 3</cfif>
				end as origen_cuenta,
				clt.CLTSIS, clt.CLTCOD, clt.CLTTIP, clt.CLTRSO, 
				clt.GRUCOD, clt.CLTIMP,
				
				env.ENVAPT, env.ENVCOP, env.ZOPCOD, env.ENVTIP,
				env.ENVDIR, env.ENVICO, env.ENVCAD,
				
				cob.COBIDE, cob.COBANO, cob.COBMES, cob.COBCOI,
				cob.IFCCOD

			from SACI..SAI007 s07 (index 0)
				inner join SACI..SAI011 s11
					on s07.SAI07COD = s11.SAI07COD
				left join SACI..SAI001 s01
					on s11.SAI01COD = s01.SAI01COD
				inner join SACISIIC..SSXSSC ssc (index SSXSSC02)
					on ssc.SERCLA = convert(varchar(20), s01.SAI01LOG)
				left join SACISIIC..SSXINT xint
					on s01.SAI01LOG = xint.SERCLA

				left join SACISIIC..SSMCUE cue
				 on cue.CUECUE = ssc.CUECUE and cue.CUESIS = 0
				
				left join SACISIIC..SSMCUE cue2
				on cue2.CUECUE = s07.SAI07COD and cue2.CUESIS = 1
				
				<cfif variables.hayCuentaDefault>
					left join SACISIIC..SSMCUE cue3
					on cue3.CUECUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#porced.CUECUE#">
					and cue3.CUESIS = <cfqueryparam cfsqltype="cf_sql_integer" value="#porced.CUESIS#">
				</cfif>
				
				left join SACISIIC..SSMCLT clt <!---(index PK_SSMCLT)--->
					on  clt.CLTCOD = coalesce (cue.CLTCOD, cue2.CLTCOD<cfif variables.hayCuentaDefault>, cue3.CLTCOD</cfif>)
					and clt.CLTSIS = coalesce (cue.CLTSIS, cue2.CLTSIS<cfif variables.hayCuentaDefault>, cue3.CLTSIS</cfif>)
				left join SACISIIC..SSMCOB cob <!---(index PK_SSMCOB)--->
					on cob.CUECUE = coalesce (cue.CUECUE, cue2.CUECUE<cfif variables.hayCuentaDefault>, cue3.CUECUE</cfif>)
					and cob.CUESIS = coalesce (cue.CUESIS, cue2.CUESIS<cfif variables.hayCuentaDefault>, cue3.CUESIS</cfif>)
				left join SACISIIC..SSMENV env <!---(index PK_SSMENV)--->
					on env.CUECUE = coalesce (cue.CUECUE, cue2.CUECUE<cfif variables.hayCuentaDefault>, cue3.CUECUE</cfif>)
					and env.CUESIS = coalesce (cue.CUESIS, cue2.CUESIS<cfif variables.hayCuentaDefault>, cue3.CUESIS</cfif>)
			where s07.SAI07CED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cedula#">
			  and (s01.SAI01BOR = 0 or not exists ( select 1 from SACI..SAI001 dup1 where dup1.SAI01LOG = s01.SAI01LOG and dup1.SAI01BOR = 0 ) )
			order by ssc.CUECUE desc, eshijo, s01.SAI01LOG
			<!---set forceplan off--->
		</cfquery>
		
		<cfif logines.RecordCount is 0>
			<!---advertencia, regreso para no migrar la persona--->
			<cfreturn log_error(Arguments.cedula, 'No hay logines para cédula ' & Arguments.cedula)>
		</cfif>
		
		<cfset variables.Pquien = migrar_persona(cedula, logines)>
		
		<cfoutput query="logines" group="CUECUE"><!--- cada CUECUE --->
			<cfset seguirProcesando = true>
			<cfquery dbtype="query" name="esta_cuenta" maxrows="1">
				select * from logines
				<cfif Len(SAI01COD)>
				where SAI01COD = #SAI01COD#
				<cfelseif Len(SAI07COD)>
				where SAI07COD = #SAI07COD#
				<cfelse><!--- no creo que llegue a pasar, pero nunca se sabe --->
					<cfthrow message="Me llegó un registro sin SAI01COD ni SAI07COD !!">
				</cfif>
			</cfquery>
			<cfset variables.CTid = ''>
			<cfset variables.Contratoid = ''>
			<cfif Len(esta_cuenta.CLTCOD) is 0 and Len(esta_cuenta.CUECUE)>
				<!--- buscar la cuenta en CUECUE_SIIC --->
				<cfquery datasource="#session.dsn#" name="buscar_cuenta_existente">
					select CTid from ISBcuenta ct
					where CUECUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#esta_cuenta.CUECUE#">
					and Pquien = <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.Pquien#">
				</cfquery>
				<cfset variables.CTid = buscar_cuenta_existente.CTid>
			</cfif>
			<cfif Len(logines.SAI01LOG) is 0 and (logines.SAI03COD GE 0) and (logines.SAI01BOR EQ 0)>
				<!---advertencia. Solamente VSAT(-2) y Dedicado(-1) pueden estar activas y no tener logines--->
				<cfset seguirProcesando = false>
				<cfset log_error(Arguments.cedula, "La cuenta SAI07COD=#logines.SAI07COD# no tiene logines, paquete #logines.SAI03COD# >= 0")>
			<cfelseif Len(esta_cuenta.CLTCOD) Is 0 And Len(variables.CTid) Is 0>
				<cfset seguirProcesando = false>
				<cfif logines.SAI01BOR is 1>
					<cfset log_error(Arguments.cedula, "No existe la cuenta para login borrado (#SAI01LOG#) CLTSIS=1/SAI07COD=#logines.SAI07COD# o CLTSIS=0/CUECUE=#logines.CUECUE#, por ced[rc=#porced.RecordCount#]CLTCOD=#porced.CLTCOD#/CLTSIS=#porced.CLTSIS#,CUECUE=#porced.CUECUE#/CUESIS=#porced.CUESIS#")>
				<cfelse>
					<cfset log_error(Arguments.cedula, "No existe la cuenta para login activo (#SAI01LOG#) CLTSIS=1/SAI07COD=#logines.SAI07COD# o CLTSIS=0/CUECUE=#logines.CUECUE#, por ced[rc=#porced.RecordCount#]CLTCOD=#porced.CLTCOD#/CLTSIS=#porced.CLTSIS#,CUECUE=#porced.CUECUE#/CUESIS=#porced.CUESIS#")>
				</cfif>
			<cfelseif (esta_cuenta.origen_cuenta is 3) And (porced.RecordCount GT 1) And Len(logines.SAI01LOG)>
				<cfset log_error(Arguments.cedula, "El login #logines.SAI01LOG# no tiene cuenta asociada, se toma la más reciente (CUECUE=#porced.CUECUE#/CUESIS=#porced.CUESIS#)")>
			</cfif>
			<cfif  Len(esta_cuenta.CUECUE) is 0 and Len(Trim(esta_cuenta.SERCLA)) is 0>
				<cfquery datasource="SACISIIC" name="buscar_cuenta_siic">
					select CUECUE from SACISIIC..SSXSSC ssc
					where CLTCED = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.cedula#">
				</cfquery>
				<cfif Isdefined('buscar_cuenta_siic') and buscar_cuenta_siic.RecordCount eq 1>	
					<cfset esta_cuenta.CUECUE = buscar_cuenta_siic.CUECUE>
					<cfset log_error(Arguments.cedula, "No se encontró la cuenta SIIC con CLTCOD= #esta_cuenta.CLTCOD# SAI07COD= #esta_cuenta.SAI07COD#, se asigna la cuenta=#esta_cuenta.CUECUE#")>
				<cfelse>	
					<cfset log_error(Arguments.cedula, "No se encontró la cuenta SIIC con CLTCOD= #esta_cuenta.CLTCOD# SAI07COD= #esta_cuenta.SAI07COD#")>				
				</cfif>
			</cfif>
			<!--- Residencial 	   : Capturar como: 9-0009-0009--->
			<!--- Jurídica Nacional: Capturar como: 9-009-000009--->
			
			<cfif Len(esta_cuenta.CLTCOD) and Listfind('F,J,E',esta_cuenta.CLTTIP)>
				<cfif esta_cuenta.CLTTIP eq 'F'>
					<cfif Trim(Arguments.cedula) neq 9>
						<cfset log_error(Arguments.cedula, "La cédula=#Arguments.cedula# no cumple con la Personería= #esta_cuenta.CLTTIP#")>				
					</cfif>
				<cfelseif esta_cuenta.CLTTIP eq 'J' >
					<cfif Trim(Arguments.cedula) neq 10>
						<cfset log_error(Arguments.cedula, "La cédula=#Arguments.cedula# no cumple con la Personería= #esta_cuenta.CLTTIP#")>				
					</cfif>				
				</cfif>	
			</cfif>
			<cfif seguirProcesando>
				<cfif Len(variables.CTid) Is 0>
					<cfset variables.CTid = crear_cuenta (Arguments.cedula, variables.Pquien, esta_cuenta)>
				</cfif><!---seguirProcesando--->
				<cfoutput group="SAI01LOG"><!--- cada login de esta cuenta, group por si hubiera repetidos --->
					<!---insertar paquete y login --->
					<cftransaction>
						<!--- variables.Contratoid --->
						<cfset variables.ISBpaquete = buscar_paquete(logines.SAI03COD)>
						<cfif eshijo and variables.ISBpaquete.PQinterfaz is 1>
							<cfset variables.Contratoid = buscar_producto_base(variables.CTid, logines.SAI03COD)>
							<cfif (variables.Contratoid) is 0>
								<cfset log_error(Arguments.cedula, "Sin paquete base para CINCAT=#logines.SAI03COD#, " &
									"CTid=#variables.CTid#, SAI01LOG=#logines.SAI01LOG#, SERCLA=#logines.SERCLA#")>
								<cfset seguirProcesando = false>
							</cfif>
							<cfif seguirProcesando And (SAI01BOR neq 1)>
								<!--- activar si no está activo --->
								<cfquery datasource="#session.dsn#">
									update ISBproducto
									set MRid = null, CNfechaRetiro = null
									where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.Contratoid#">
									  and MRid is not null or CNfechaRetiro is not null
								</cfquery>
							</cfif>
						<cfelse>
							<cfset variables.Vid = buscar_vendedor(logines.VENCOD)>
							<cfif variables.ISBpaquete.PQinterfaz is 1>
								<cfset log_error(Arguments.cedula, 'El paquete #logines.SAI03COD# está marcado con PQinterfaz=1 en ISBpaquete')>
							</cfif>
							<!--- buscar dominio VPN si SAI01LOG tiene el símbolo @ --->
							<cfif Find('@', logines.SAI01LOG)>
								<cfset variables.VPNdominio = ListRest(logines.SAI01LOG, '@')>
								<cfset variables.VPNid = buscar_vpn(variables.VPNdominio)>
								<cfif Len(buscar_vpn_q.VPNid) is 0>
									<cfset log_error(Arguments.cedula, 'No existe el dominio VPN #variables.VPNdominio#')>
									<cfset seguirProcesando = false>
								</cfif>
							<cfelse>
								<cfset variables.VPNid = ''>
							</cfif>
							<cfif seguirProcesando>
								<!---ISBproducto--->
								<cfinvoke component="saci.comp.ISBproducto" method="Alta" returnvariable="variables.Contratoid"
									CTid="#variables.CTid#"
									CTidFactura="#variables.CTid#"
									PQcodigo="#variables.ISBpaquete.PQcodigo#"
									Vid="#variables.Vid#"
									CTcondicion="1"
									CNsubestado="REV"
									CNsuscriptor=""
									CNnumero="0"
									CNapertura="#coalesce(esta_cuenta.CUEFAP, Now())#">
									<cfif Len(variables.VPNid)>
										<cfinvokeargument name="VPNid" value="#variables.VPNid#">
									</cfif>
									<cfif SAI01BOR is 1 or Len(logines.SSCFIN)>
										<cfinvokeargument name="CNfechaRetiro" value="#logines.update_time#">
										<cfinvokeargument name="MRid" value="#This.MRid_default#">
									</cfif>
								</cfinvoke>
							</cfif><!---seguirProcesando--->
						</cfif>
						<cfif seguirProcesando>
							<cfif Len(Trim(logines.SAI01LOG))>
								<!--- Las cuentas sin logines, como Dedicado y SAT --->
								<!---ISBlogin--->
								<cfinvoke component="saci.comp.ISBlogin" method="Alta" returnvariable="variables.LGnumero"
									Contratoid="#variables.Contratoid#"
									LGlogin="#logines.SAI01LOG#"
									LGrealName="#esta_cuenta.CUEGER#"   
									LGmailQuota="#variables.ISBpaquete.PQmailQuota#"
									LGroaming="#variables.ISBpaquete.PQroaming#"
									LGprincipal="#variables.ISBpaquete.PQinterfaz is 0#"
									LGapertura="#Coalesce(logines.SAI01FEC,logines.update_time,Now())#"
									LGserids="#logines.SERIDS#"
									LGbloqueado="#logines.SAI01EST is 'S'#"
									LGmostrarGuia="#logines.SERGUI is'S'#"
									LGtelefono="#logines.INTTEL#">
									<cfif Len(logines.INTSOB)>
										<!--- cuando el login es un dominio VPN no viene el sobre --->
										<cfinvokeargument name="sobre" value="#logines.INTSOB#">
									</cfif>
									<cfif SAI01BOR is 1>
										<cfinvokeargument name="Habilitado" value="2">
										<cfinvokeargument name="LGfechaRetiro" value="#logines.update_time#">
										<cfinvokeargument name="MRid" value="#This.MRid_default#">
									<cfelse>
										<cfinvokeargument name="Habilitado" value="1">
									</cfif>
								</cfinvoke>
								<!--- insertar en ISBserviciosLogin según el paquete --->
								<cfquery datasource="#session.dsn#" name="ret.ISBservicio">
									insert into ISBserviciosLogin (
										LGnumero, TScodigo, PQcodigo, SLpassword, Habilitado, BMUsucodigo)
									select
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#variables.LGnumero#" null="#Len(variables.LGnumero) Is 0#">,
										a.TScodigo, a.PQcodigo, '**secret**', 1,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
									from ISBservicio a
									where a.PQcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.ISBpaquete.PQcodigo#">
								</cfquery>
								<!---ISBbitacoraLogin: registro en la bitacora del cambio realizado --->
								<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta">
									<cfinvokeargument name="LGnumero" value="#variables.LGnumero#">
									<cfinvokeargument name="LGlogin" value="#logines.SAI01LOG#">
									<cfinvokeargument name="BLautomatica" value="true">
									<cfinvokeargument name="BLobs" value="Carga de datos iniciales">
									<cfinvokeargument name="BLfecha" value="#Now()#">
								</cfinvoke>
							</cfif><!---Len(logines.SAI01LOG)--->
						</cfif><!---seguirProcesando--->
					</cftransaction>
					<cfif seguirProcesando and Len(Trim(logines.SAI01LOG))>
						<!--- actualizar SSXSSC, pierdo la referencia al codigo de saci anterior --->
						<cfquery datasource="SACISIIC">
							update SSXSSC
							set SSCCTA = <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.CTid#">
							where SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#logines.SAI01LOG#">
						</cfquery>
					</cfif><!---seguirProcesando--->
				</cfoutput>
			</cfif>
		</cfoutput>
		<cfreturn This.errorcount is 0>
	</cffunction>	
	<!--- migrar_persona --->
	<cffunction name="migrar_persona" returntype="numeric" output="false">
	<cfargument name="cedula" type="string">
	<cfargument name="cuenta" type="query">
		<cfquery datasource="#session.dsn#" name="existe">
			select Pquien from ISBpersona
			where Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cedula#">
		</cfquery>
		<cfif existe.RecordCount and Len(existe.Pquien)>
			<cfreturn existe.Pquien>
		</cfif>
		<cfset Pnombre = ' '>
		<cfset Papellido = ''>
		<cfset Papellido2 = ''>
		<cfif ListLen(Arguments.cuenta.CLTRSO, ' ') is 1>
			<cfset Pnombre = Arguments.cuenta.CLTRSO>
		<cfelseif ListLen(Arguments.cuenta.CLTRSO, ' ') is 2>
			<cfset Papellido = ListFirst(Arguments.cuenta.CLTRSO, ' ')>
			<cfset Papellido2 = ListRest(Arguments.cuenta.CLTRSO, ' ')>
		<cfelse>
			<cfset Papellido = ListFirst(Arguments.cuenta.CLTRSO, ' ')>
			<cfset Papellido2 = ListFirst(ListRest(Arguments.cuenta.CLTRSO, ' '))>
			<cfset Pnombre = ListRest(ListRest(Arguments.cuenta.CLTRSO, ' '))>
		</cfif>
		<cfset variables.LCid = getLCid(Arguments.cuenta.PRVCOD,Arguments.cuenta.CANCOD,Arguments.cuenta.DISCOD)>
		<!---ISBpersona--->
		<cfinvoke component="saci.comp.ISBpersona" method="Alta" returnvariable="Pquien"
			Ppersoneria="#Coalesce(Arguments.cuenta.CLTTIP,'F')#"
			Pid="#Arguments.cedula#"
			Pnombre="#Pnombre# "
			Papellido="#Papellido#"
			Papellido2="#Papellido2#"
			PrazonSocial="#Arguments.cuenta.CLTRSO#"
			Ppais="CR"
			Pobservacion=""
			Pprospectacion=""
			Ecodigo="#session.Ecodigo#"
			Papdo="#Arguments.cuenta.ENVAPT#"
			Pdireccion="#Arguments.cuenta.CUEDIR#"
			Pbarrio=""
			Ptelefono1="#Coalesce(Arguments.cuenta.CUETEL, ' ')#"
			Ptelefono2="#Arguments.cuenta.CUETL2#"
			
			Pfax="#Arguments.cuenta.CUEFAX#"
			Pemail="#Arguments.cuenta.ENVICO#"
			Pfecha="#Now()#" >
			<cfif Len(Arguments.cuenta.ZOPCOD)>
				<cfinvokeargument name="CPid" value="#Arguments.cuenta.ZOPCOD#">
			</cfif>
			<cfif Len(Arguments.cuenta.ACTCOD)>
				<cfinvokeargument name="AEactividad" value="#Arguments.cuenta.ACTCOD#">
			</cfif>
			<cfif Len(variables.LCid)>
				<cfinvokeargument name="LCid" value="#variables.LCid#">
			</cfif>
		</cfinvoke>
		<cfreturn Pquien>
	</cffunction>	
	<!--- crear_cuenta --->
	<cffunction name="crear_cuenta" returntype="numeric" output="false">
	<cfargument name="cedula" type="string" required="yes">
	<cfargument name="Pquien" type="string" required="yes">
	<cfargument name="cuenta" type="query" required="yes">
		<cfset var CUECUE = Arguments.cuenta.CUECUE>
		<cfif Len(CUECUE) is 0 And Arguments.cuenta.SAI03COD LT 0>
			<!--- solo para (dedicado y vpn), que no tienen login, buscar por SSXSSC --->
			<cfquery datasource="SACISIIC" name="buscando_CUECUE">
				select CUECUE
				from SSXSSC
				where CLTCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cedula#">
				  and CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.cuenta.SAI03COD#">
				  and CUECUE is not null
			</cfquery>
			<cfset CUECUE = buscando_CUECUE.CUECUE>
			<cfif Len(CUECUE) is 0>
				<cfset log_error(Arguments.cedula,'No se encuentra cuenta en SSXSSC para cédula #Arguments.cedula# y paquete #Arguments.cuenta.SAI03COD#' )>
			</cfif>
		</cfif>
		<!--- Si existe una cuenta (CUECUE) para esa persona--->
		<cfif Len(Arguments.cuenta.CUECUE) and Arguments.Pquien>
			<cfquery datasource="#session.dsn#" name="existe">
				select CTid
				from ISBcuenta c
				inner join ISBpersona p
					on c.Pquien = p.Pquien
				where CUECUE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.cuenta.CUECUE#">
				and p.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#">
			</cfquery>
			<cfif existe.RecordCount and Len(existe.CTid)>
				<cfreturn existe.CTid>
			</cfif>
		</cfif>
		<!--- ISBcuenta --->
		<cfinvoke component="saci.comp.ISBcuenta" method="Alta" returnvariable="CTid"
			Pquien="#Arguments.Pquien#"
			CUECUE="#Coalesce(CUECUE, 0)#"
			CTapertura="#Coalesce(Arguments.cuenta.CUEFAP, CreateDate(2006,1,1))#"
			CTdesde="#Coalesce(Arguments.cuenta.SSCINC, CreateDate(2006,1,1))#"
			CThasta="#Coalesce(Arguments.cuenta.SSCFIN, CreateDate(2006,1,1))#"
			CTcobrable="#Arguments.cuenta.CUETIP#"
			CTrefComision=""
			CCclaseCuenta="#Arguments.cuenta.CLACOD#"
			GCcodigo="#Arguments.cuenta.GRUCOD#"
			CTpagaImpuestos="#Arguments.cuenta.CLTIMP is 'S'#"
			Habilitado="1"
			CTobservaciones="#Arguments.cuenta.CUEOBS#"
			CTtipoUso="U">
			<cfif Len(Arguments.cuenta.ESCCOD) And Len(Arguments.cuenta.CONCGO)>
				<cfif Not StructKeyExists(This.lookup_estado, Arguments.cuenta.ESCCOD & '/' & Arguments.cuenta.CONCGO)>
					<cfthrow message="Estado/subestado inválidos: #Arguments.cuenta.ESCCOD#/#Arguments.cuenta.CONCGO#">
				<cfelse>
					<cfinvokeargument name="ECidEstado" value="#StructFind(This.lookup_estado, Arguments.cuenta.ESCCOD & '/' & Arguments.cuenta.CONCGO)#">
				</cfif>
			</cfif>
		</cfinvoke>	
		<!--- Agrega los datos de la ISBlocalizacion --->	
		<cfset variables.LCid = getLCid(Arguments.cuenta.PRVCOD,Arguments.cuenta.CANCOD,Arguments.cuenta.DISCOD)>
		
		<cfinvoke component="saci.comp.ISBlocalizacion" method="Alta"  returnvariable="idReturn">
						
			<cfinvokeargument name="RefId" value="#CTid#">
			<cfinvokeargument name="Ltipo" value="C">					
			
			<cfif Len(Arguments.cuenta.ZOPCOD)>
				<cfinvokeargument name="CPid" value="#Arguments.cuenta.ZOPCOD#">
			</cfif>
			<cfif Len(variables.LCid)>
				<cfinvokeargument name="LCid" value="#variables.LCid#">
			</cfif>
			<cfinvokeargument name="Papdo" value="#Arguments.cuenta.ENVAPT#">--->
			<cfinvokeargument name="Pdireccion" value="#Arguments.cuenta.CUEDIR#">
			<cfinvokeargument name="Pbarrio" value="">
			<cfinvokeargument name="Ptelefono1" value="#Coalesce(Arguments.cuenta.CUETEL, ' ')#">
			<cfinvokeargument name="Ptelefono2" value="#Arguments.cuenta.CUETL2#">
			<cfinvokeargument name="Pfax" value="#Arguments.cuenta.CUEFAX#">
			<cfinvokeargument name="Pemail" value="#Arguments.cuenta.ENVICO#">
		</cfinvoke>
		<!--- Apartado o Dirección: CTtipoEnvio(1/2) = ENVTIP(A/D) --->
		<cfif Arguments.cuenta.ENVTIP is 'A'>
			<cfset CTtipoEnvio = '1'>
		<cfelse>
			<cfset CTtipoEnvio = '2'>
		</cfif>		
		<!--- ENVCOP: en saci no existe el 'S', equivale a 'N' --->
		<cfif (Arguments.cuenta.ENVCOP is 'S') or Len(Arguments.cuenta.ENVCOP) is 0>
			<cfset CTcopiaModo = 'S'>
		<cfelse>
			<cfset CTcopiaModo = Arguments.cuenta.ENVCOP>
		</cfif>
		<!--- ISBcuentaNotifica --->
		<cfinvoke component="saci.comp.ISBcuentaNotifica" method="Alta" 
			 CTid="#CTid#"
			 CTtipoEnvio="#CTtipoEnvio#"
			 CTdireccionEnvio="#Arguments.cuenta.ENVDIR#"
			 
			 CTapdoPostal="#Arguments.cuenta.ENVAPT#"
			 CTcopiaModo="#CTcopiaModo#"
			 CTcopiaDireccion="#Arguments.cuenta.ENVICO#"
			 CTcopiaDireccion2="#Arguments.cuenta.ENVCAD#"
			 
			 CPid="#Arguments.cuenta.ZOPCOD#" />		
		<!--- ISBcuentaCobro --->
		<cfinvoke component="saci.comp.ISBcuentaCobro" method="Alta" 
			CTid="#CTid#"
			CTbcoRef="#Arguments.cuenta.COBIDE#"
			CTanoVencimiento="#Arguments.cuenta.COBANO#"
			CTmesVencimiento="#Arguments.cuenta.COBMES#" >
			<cfif Len(Arguments.cuenta.COBCOI)>
				<cfinvokeargument name="CTcobro"  value="#Arguments.cuenta.COBCOI#">
			<cfelse>
				<!--- default: no hay default para no cobrar --->
				<cfinvokeargument name="CTcobro"  value="2">
			</cfif>
			
			<cfif Len(Arguments.cuenta.COBCOI) and Arguments.cuenta.COBCOI eq 2>
				<cfif StructKeyExists(This.lookup_tarjeta, Arguments.cuenta.IFCCOD)>
					<cfinvokeargument name="MTid"  value="#StructFind(This.lookup_tarjeta, Arguments.cuenta.IFCCOD)#">
				</cfif>			
			<cfelse>
				<cfif StructKeyExists(This.lookup_entidad, Arguments.cuenta.IFCCOD)>
					<cfinvokeargument name="EFid"  value="#StructFind(This.lookup_entidad, Arguments.cuenta.IFCCOD)#">
				</cfif>
			</cfif>			
		</cfinvoke>
		<cfreturn CTid>
	</cffunction>
	<!---buscar_vendedor--->
	<cffunction name="buscar_vendedor" output="false" returntype="numeric">
	<cfargument name="VENCOD" type="string">
		<cfif Len(Arguments.VENCOD) is 0>
			 <cfreturn This.vendedor_default>
		</cfif>
		<cfquery datasource="#session.dsn#" name="buscar_vendedor_query">
			select min(Vid) as Vid from ISBvendedor
			where AGid = 
				<cfif Arguments.VENCOD is 0>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="199">
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.VENCOD#">
				</cfif>
		</cfquery>
		<cfif Len(buscar_vendedor_query.Vid) is 0>
			<cfif Arguments.VENCOD is 0>
				<cfthrow message="No hay vendedores para el agente RACSA (AGid = 199/VENCOD = 0)">
			<cfelse>
				<cfthrow message="No hay vendedores para el agente (AGid = VENCOD = #Arguments.VENCOD#)">
			</cfif>
		</cfif>
		<cfreturn buscar_vendedor_query.Vid>
	</cffunction>
	<!---buscar_producto_base--->
	<cffunction name="buscar_producto_base" returntype="numeric" output="false">
	<cfargument name="CTid" type="numeric">
	<cfargument name="CINCAT" type="numeric">
		<!--- buscar si el paquete es adicional de otro paquete, error si no hay --->
		<cfquery datasource="#session.dsn#" name="buscar_producto_base_q">
			select pr.Contratoid
			from ISBservicio sv
				inner join ISBproducto pr
					on pr.PQcodigo = sv.PQcodigo
				inner join ISBpaquete pqhijo
					on pqhijo.PQcodigo = sv.PQinterfaz
			where pqhijo.CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CINCAT#">
			  and pr.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#">
		</cfquery>
		<cfif Len(buscar_producto_base_q.Contratoid) is 0>
			<cfreturn 0>
		</cfif>
		<cfreturn buscar_producto_base_q.Contratoid>
	</cffunction>
	<!---buscar_paquete--->
	<cffunction name="buscar_paquete" output="false" returntype="query">
	<cfargument name="CINCAT" type="numeric">
		<cfquery datasource="#session.dsn#" name="ISBpaquete">
			select PQcodigo, PQinterfaz, PQmailQuota, PQroaming
			from ISBpaquete
			where CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CINCAT#">
		</cfquery>
		<cfif ISBpaquete.RecordCount is 0>
			<cfthrow message="No hay un paquete con CINCAT = #Arguments.CINCAT#">
		</cfif>
		<cfreturn ISBpaquete>
	</cffunction>
	<!---buscar_vpn--->
	<cffunction name="buscar_vpn" returntype="string" output="false" hint="Regresa el VPN, o vacío si no lo encuentra">
		<cfargument name="dominio" type="string">
		<cfquery datasource="#session.dsn#" name="buscar_vpn_q">
			select VPNid
			from ISBdominioVPN
			where VPNdominio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.dominio#">
		</cfquery>
		<cfreturn buscar_vpn_q.VPNid>
	</cffunction>
	<!---getLCid--->
	<cffunction name="getLCid" output="false">
		<cfargument name="PRVCOD" type="string" required="yes">
		<cfargument name="CANCOD" type="string" required="yes">
		<cfargument name="DISCOD" type="string" required="yes">
		<cfquery datasource="#session.dsn#" name="tmp_LocalidadPersona">
			select dist.LCid
			from Localidad prov
				join Localidad cant
					on prov.LCid = cant.LCidPadre
				join Localidad dist
					on cant.LCid = dist.LCidPadre
			where prov.LCcod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PRVCOD#">
			  and cant.LCcod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CANCOD#">
			  and dist.LCcod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DISCOD#">
			  and prov.LCidPadre is null
		</cfquery>
		<!--- si no existe el DISCOD, poner 99 --->
		<cfif Len(tmp_LocalidadPersona.LCid) is 0 And (Arguments.DISCOD neq 99)>
			<cfreturn getLCid(Arguments.PRVCOD, Arguments.CANCOD, 99)>
		</cfif>
		<cfif Len(tmp_LocalidadPersona.LCid) is 0 And (Arguments.CANCOD neq 99)>
			<cfreturn getLCid(Arguments.PRVCOD, 99, 99)>
		</cfif>
		
		<cfreturn tmp_LocalidadPersona.LCid>
	</cffunction>
	<!---init_lookup: Cargar ISBestadoCuenta e ISBentidadFiananciera en memoria--->
	<cffunction name="init_lookup" output="false" returntype="void">
		<cfquery datasource="#session.dsn#" name="lookup_estado_q">
			select ECidEstado, ECestado, ECsubEstado
			from ISBcuentaEstado
		</cfquery>
		<cfset This.lookup_estado = StructNew()>
		<cfloop query="lookup_estado_q">
			<cfset StructInsert(This.lookup_estado, ECestado & '/' & ECsubEstado, ECidEstado)>
		</cfloop>
		
		<cfquery datasource="#session.dsn#" name="lookup_entidad_q">
			select EFid, IFCCOD
			from ISBentidadFinanciera
			where IFCCOD is not null
		</cfquery>
		<cfset This.lookup_entidad = StructNew()>
		<cfloop query="lookup_entidad_q">
			<cfset StructInsert(This.lookup_entidad, IFCCOD, EFid)>
		</cfloop>

		<cfquery datasource="#session.dsn#" name="lookup_tarjeta_q">
			select MTid, IFCCOD
			from ISBtarjeta
			where IFCCOD is not null
		</cfquery>
		<cfset This.lookup_tarjeta = StructNew()>
		<cfloop query="lookup_tarjeta_q">
			<cfset StructInsert(This.lookup_tarjeta, IFCCOD, MTid)>
		</cfloop>

		
		<cfquery datasource="#session.dsn#" name="vendedor_default_q">
			select Vid
			from ISBvendedor
			where AGid = 199<!--- 199=racsa--->
		</cfquery>
		<cfif Len(vendedor_default_q.Vid) is 0>
			<cfthrow message="No hay vendedores para el agente AGid = 199/RACSA">
		</cfif>
		<cfset This.vendedor_default = vendedor_default_q.Vid>
		
		<cfquery datasource="#session.dsn#" name="motivo_retiro_q">
			select min(MRid) as MRid
			from ISBmotivoRetiro
		</cfquery>
		<cfif Len(motivo_retiro_q.MRid) is 0>
			<cfthrow message="No hay motivos de retiro definidos">
		</cfif>
		<cfset This.MRid_default = motivo_retiro_q.MRid>
	</cffunction>
	<!---Coalesce--->
	<cffunction name="Coalesce" returntype="any" output="false">
		<cfargument name="val1" required="yes">
		<cfargument name="val2" required="yes">
		<cfif Len(Arguments.val1)>
			<cfreturn Arguments.val1>
		<cfelse>
			<cfreturn Arguments.val2>
		</cfif>
	</cffunction>
	<!---log_error--->
	<cffunction name="log_error" output="false" returntype="boolean" hint="Regresa siempre false">
	<cfargument name="cedula" type="string" required="yes">
	<cfargument name="errmsg" type="string" required="yes">
	<cfargument name="TagContext" type="array" required="no">
		<cfset This.errorcount = This.errorcount + 1>
		<cfif Not IsDefined("Arguments.TagContext")>
			<cftry>
				<cfthrow message="Get Tag Context ">
			<cfcatch type="any">
				<cfset Arguments.TagContext = ArrayNew(1)>
				<cfloop from="2" to="#ArrayLen(cfcatch.TagContext)#" index="i">
		}			<cfset Arguments.TagContext[i-1] = cfcatch.TagContext[i]>
				</cfloop>
			</cfcatch>
			</cftry>
		</cfif>
	
		<cflog file="migracion_saci" text="#Arguments.cedula#;#Arguments.errmsg#">
		<cfset stack = ''>
		<cfset errorline = ''>
		<cfloop to="1" from="#ArrayLen(Arguments.TagContext)#" index="i" step="-1">
			<cfset errorline = GetFileFromPath(Arguments.TagContext[i].Template) & ':' & Arguments.TagContext[i].Line>
			<cfset stack = Chr(10) & errorline & stack >
		</cfloop>
		<!--- Guardar error --->
		<cfquery datasource="#session.dsn#">
			insert into migra_error (cedula, msg, stack)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cedula#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.errmsg#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#stack#"> )
		</cfquery>
		<cfreturn false>
	</cffunction>
</cfcomponent>
