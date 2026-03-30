<cfcomponent extends="base">
	<!--- crearEnSaci --->
	<cffunction name="crearEnSaci" access="public" returntype="void" output="false">
		<cfargument name="login" type="string" required="yes" hint="Login por crear">
		<cfargument name="datosLogin" type="struct" required="yes" hint="Resultado de leerDatosLoginSACISIIC">
		<cfargument name="sobre" type="numeric" required="No" hint="Sobre con la contraseña">
		<cfargument name="dominioVPN" type="string" required="yes" hint="Dominio VPN al que pertenece">
		<cfargument name="BLobs" type="string" required="yes">
		
		<cfif Len(Trim(Arguments.login)) is 0>
			<cfthrow message="Debe indicar el login por incluir en SACI.">
		</cfif>
		<cfset control_mensaje( 'ISB-0020', 'Creando login #Arguments.login#' )>
		<cfquery datasource="#session.dsn#" name="existe">
			select Pquien from ISBpersona
			where Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datosLogin.SSMCLT.CLTCED#">
		</cfquery>
		<cfif existe.RecordCount GT 1>
			<cfset control_mensaje( 'ISB-0007', 'ISBpersona con Pid=#datosLogin.SSMCLT.CLTCED#, #existe.RecordCount# rows' )>
		</cfif>
		<cfif existe.RecordCount>
			<cfset datosLogin.Pquien = existe.Pquien>
		<cfelse>
			<!--- Al especificar el Pquien, se usará el set identity_insert
			<cfset datosLogin.Pquien = datosLogin.SSMCLT.CLTCOD>
			Pquien="#datosLogin.Pquien#" --->
			<cfset Pnombre = ' '>
			<cfset Papellido = ''>
			<cfset Papellido2 = ''>
			<cfif ListLen(datosLogin.SSMCUE.CUEGER, ' ') is 1>
				<cfset Pnombre = datosLogin.SSMCUE.CUEGER>
			<cfelseif ListLen(datosLogin.SSMCUE.CUEGER, ' ') is 2>
				<cfset Pnombre = ListFirst(datosLogin.SSMCUE.CUEGER, ' ')>
				<cfset Papellido = ListRest(datosLogin.SSMCUE.CUEGER, ' ')>
			<cfelse>
				<cfset Pnombre = ListFirst(datosLogin.SSMCUE.CUEGER, ' ')>
				<cfset Papellido = ListFirst(ListRest(datosLogin.SSMCUE.CUEGER, ' '))>
				<cfset Papellido2 = ListRest(ListRest(datosLogin.SSMCUE.CUEGER, ' '))>
			</cfif>
			
			<cfinvoke component="saci.comp.ISBpersona" method="Alta" returnvariable="Pquien"
				Ppersoneria="#datosLogin.SSMCLT.CLTTIP#"
				Pid="#datosLogin.SSMCLT.CLTCED#"
				Pnombre="#Pnombre# "
				Papellido="#Papellido#"
				Papellido2="#Papellido2#"
				PrazonSocial="#datosLogin.SSMCLT.CLTRSO#"
				Ppais="CR"
				Pobservacion=""
				Pprospectacion=""
				Ecodigo="#session.Ecodigo#"
				AEactividad="#datosLogin.SSMCUE.ACTCOD#"
				Papdo="#datosLogin.SSMENV.ENVAPT#"
				LCid="#datosLogin.LCidPersona#"
				Pdireccion="#datosLogin.SSMCUE.CUEDIR#"
				Pbarrio=""
				Ptelefono1="#datosLogin.SSMCUE.CUETEL#"
				Ptelefono2="#datosLogin.SSMCUE.CUETL2#"
				
				Pfax="#datosLogin.SSMCUE.CUEFAX#"
				Pemail="#datosLogin.SSMENV.ENVCOP#"
				Pfecha="#Now()#" >
				<cfif Len(datosLogin.SSMENV.ZOPCOD)>
					<cfinvokeargument name="CPid" value="#datosLogin.SSMENV.ZOPCOD#">
				</cfif>
			</cfinvoke>
			<cfset datosLogin.Pquien = Pquien>
		</cfif>
		<cfif Len(datosLogin.SSMCUE.CUECUE)>
			<cfquery datasource="#session.dsn#" name="existe">
				select CTid from ISBcuenta where CUECUE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datosLogin.SSMCUE.CUECUE#">
			</cfquery>
		<cfelse>
			<cfset existe = QueryNew('CTid')>
		</cfif>
		<cfif existe.RecordCount>
			<cfset datosLogin.CTid = existe.CTid>
		<cfelse>
			<!--- se usa el SSMCUE.CUECUE y no el SSXSSC.CUECUE, ya que este último corresponde
				al vendedor responsable del servicio, y el primero al cliente --->
			<cfinvoke component="saci.comp.ISBcuenta" method="Alta" returnvariable="datosLogin.CTid"
				Pquien="#datosLogin.Pquien#"
				CUECUE="#datosLogin.SSMCUE.CUECUE#"
				ECidEstado="#datosLogin.buscarEstado.ECidEstado#"
				CTapertura="#datosLogin.SSMCUE.CUEFAP#"
				CTcobrable="#datosLogin.SSMCUE.CUETIP#"
				CTrefComision=""
				CCclaseCuenta="#datosLogin.SSMCUE.CLACOD#"
				GCcodigo="#datosLogin.SSMCLT.GRUCOD#"
				CTpagaImpuestos="#datosLogin.SSMCLT.CLTIMP is 'S'#"
				Habilitado="1"
				CTobservaciones="#datosLogin.SSMCUE.CUEOBS#"
				CTtipoUso="U">
				<cfif Len(datosLogin.SSXSSC.SSCINC)>
					<cfinvokeargument name="CTdesde" value="#datosLogin.SSXSSC.SSCINC#">
				</cfif>
				<cfif Len(datosLogin.SSXSSC.SSCFIN)>
					<cfinvokeargument name="CThasta" value="#datosLogin.SSXSSC.SSCFIN#">
				</cfif>
			</cfinvoke>
			
			<!--- Apartado o Dirección: CTtipoEnvio(1/2) = ENVTIP(A/D) --->
			<cfif datosLogin.SSMENV.ENVTIP is 'A'>
				<cfset CTtipoEnvio = '1'>
			<cfelse>
				<cfset CTtipoEnvio = '2'>
			</cfif>
			
			<!--- en saci no existe el 'S', equivale a 'N' --->
			<cfif (datosLogin.SSMENV.ENVCOP is 'S') or Len(datosLogin.SSMENV.ENVCOP) is 0>
				<cfset CTcopiaModo = 'N'>
			<cfelse>
				<cfset CTcopiaModo = datosLogin.SSMENV.ENVCOP>
			</cfif>
			<cfinvoke component="saci.comp.ISBcuentaNotifica" method="Alta" 
				 CTid="#datosLogin.CTid#"
				 CTtipoEnvio="#CTtipoEnvio#"
				 CTdireccionEnvio="#datosLogin.SSMENV.ENVDIR#"
				 
				 CTapdoPostal="#datosLogin.SSMENV.ENVAPT#"
				 CTcopiaModo="#CTcopiaModo#"
				 CTcopiaDireccion="#datosLogin.SSMENV.ENVICO#"
				 CTcopiaDireccion2="#datosLogin.SSMENV.ENVCAD#"
				 
				 CPid="#datosLogin.SSMENV.ZOPCOD#" />
			
			<!--- validar si CTcobro está bien insertado --->
			<cfinvoke component="saci.comp.ISBcuentaCobro" method="Alta" 
				CTid="#datosLogin.CTid#"
				CTbcoRef="#datosLogin.SSMCOB.COBIDE#"
				CTanoVencimiento="#datosLogin.SSMCOB.COBANO#"
				CTmesVencimiento="#datosLogin.SSMCOB.COBMES#" >
				<cfif Len(datosLogin.SSMCOB.COBCOI)>
					<cfinvokeargument name="CTcobro"  value="#datosLogin.SSMCOB.COBCOI#">
				<cfelse>
					<!--- default: no hay default para no cobrar --->
					<cfinvokeargument name="CTcobro"  value="2">
				</cfif>
				<cfif Len(datosLogin.ISBentidadFinanciera.EFid)>
					<cfinvokeargument name="EFid"  value="#datosLogin.ISBentidadFinanciera.EFid#">
				</cfif>
			</cfinvoke>
		</cfif>
			
		<cfquery datasource="#session.dsn#" name="existe">
			select lg.Contratoid, lg.LGnumero
			from ISBlogin lg
				join ISBproducto pr
					on pr.Contratoid = lg.Contratoid
			where lg.LGlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datosLogin.SSXSSC.SERCLA#">
			  and pr.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datosLogin.CTid#">
		</cfquery>
		<cfif existe.RecordCount>
			<cfset datosLogin.Contratoid = existe.Contratoid>
			<cfset datosLogin.LGnumero = existe.LGnumero>
		<cfelse>
			<cfquery datasource="#session.dsn#" name="buscar_vendedor">
				select Vid from ISBvendedor
				where AGid = 
					<cfif datosLogin.SSXSSC.VENCOD is 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="199">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#datosLogin.SSXSSC.VENCOD#">
					</cfif>
			</cfquery>
			<cfif buscar_vendedor.RecordCount is 0>
				<cfif datosLogin.SSXSSC.VENCOD is 0>
					<cfthrow message="No hay vendedores para el agente RACSA (AGid = 199/VENCOD = 0)" errorcode="ISB-0021">
				<cfelse>
					<cfthrow message="No hay vendedores para el agente (AGid = VENCOD = #datosLogin.SSXSSC.VENCOD#)" errorcode="ISB-0021">
				</cfif>
			</cfif>
			<cfif datosLogin.ISBpaquete.PQinterfaz>
				<!--- buscar si el paquete es adicional de otro paquete --->
				<cfquery datasource="#session.dsn#" name="buscar_paquete_base">
					select pr.Contratoid
					from ISBservicio sv
						join ISBproducto pr
							on pr.PQcodigo = sv.PQcodigo
					where sv.PQinterfaz = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datosLogin.ISBpaquete.PQcodigo#">
					  and pr.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datosLogin.CTid#">
				</cfquery>
			<cfelse>
				<cfset buscar_paquete_base = QueryNew('Contratoid')>
			</cfif>
			<cfif Len(buscar_paquete_base.Contratoid)>
				<cfset datosLogin.Contratoid = buscar_paquete_base.Contratoid>
			<cfelse>
				<cfinvoke component="saci.comp.ISBproducto" method="Alta" returnvariable="datosLogin.Contratoid"
					CTid="#datosLogin.CTid#"
					CTidFactura="#datosLogin.CTid#"
					PQcodigo="#datosLogin.ISBpaquete.PQcodigo#"
					Vid="#buscar_vendedor.Vid#"
					CTcondicion="1"
					CNsubestado="REV"
					CNsuscriptor=""
					CNnumero="0"
					CNapertura="#datosLogin.SSMCUE.CUEFAP#">
					<cfif Len(datosLogin.ISBdominioVPN.VPNid)>
						<cfinvokeargument name="VPNid" value="#datosLogin.ISBdominioVPN.VPNid#">
					</cfif>
				</cfinvoke>
			</cfif>
			
			<cfinvoke component="saci.comp.ISBlogin" method="Alta" returnvariable="datosLogin.LGnumero"
				Contratoid="#datosLogin.Contratoid#"
				LGlogin="#datosLogin.SSXSSC.SERCLA#"
				LGrealName="#datosLogin.SSMCUE.CUEGER#"   
				
				LGmailQuota="#datosLogin.ISBpaquete.PQmailQuota#"
				LGroaming="#datosLogin.ISBpaquete.PQroaming#"
				LGprincipal="#datosLogin.ISBpaquete.PQinterfaz is 0#"
				LGapertura="#datosLogin.SSMCUE.CUEFAP#"
				LGserids="#datosLogin.SSXSSC.SERIDS#"
				
				Habilitado="1"
				LGbloqueado="0"
				LGmostrarGuia="#datosLogin.SSXINT.SERGUI is'S'#"
				LGtelefono="#datosLogin.SSXINT.INTTEL#">
				<cfif IsDefined('Arguments.sobre') and Len(Arguments.sobre) and Arguments.sobre NEQ 0>
					<!--- cuando el login es un dominio VPN no viene el sobre --->
					<cfinvokeargument name="Snumero" value="#Arguments.sobre#">
				</cfif>
			</cfinvoke>

			<!--- insertar en ISBserviciosLogin uno por uno.  --->
			<cfloop query="datosLogin.ISBservicio">
				<!--- se omite SLcese para que quede en NULL
							el password no se guarda por seguridad --->
				<cfinvoke component="saci.comp.ISBserviciosLogin" method="Alta"
					LGnumero="#datosLogin.LGnumero#"
					TScodigo="#datosLogin.ISBservicio.TScodigo#"
					PQcodigo="#datosLogin.ISBpaquete.PQcodigo#"
					SLpassword="*"
					Habilitado="1"/>
			</cfloop>
		
			<!---registro en la bitacora del cambio realizado --->
			<cfinvoke component="saci.comp.ISBbitacoraLogin" method="Alta">
				<cfinvokeargument name="LGnumero" value="#datosLogin.LGnumero#">
				<cfinvokeargument name="LGlogin" value="#Arguments.login#">
				<cfinvokeargument name="BLautomatica" value="true">
				<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">
				<cfinvokeargument name="BLfecha" value="#Now()#">
			</cfinvoke>
		</cfif>

	</cffunction>
	
	<!--- leerDatosLoginSACISIIC --->
	<cffunction name="leerDatosLoginSACISIIC" access="public" returntype="struct" output="false">
		<cfargument name="login" type="string" required="yes" hint="Login por crear">
		<cfargument name="sobre" type="numeric" required="no" hint="Sobre con la contraseña">
		<cfargument name="dominioVPN" type="string" required="yes" hint="Dominio VPN al que pertenece">
		<cfargument name="CUECUE" type="numeric" required="yes" hint="Número de cuenta existente en SACISIIC">
		
		<cfset ret = StructNew()>
		
		<cfset control_mensaje ('SIC-0008', 'Leyendo login #Arguments.login#, CUECUE #IIf(Arguments.CUECUE, DE(Arguments.CUECUE), DE('No especificado'))#' )>
		
		 <!--- Datos del Login --->
		<cfquery datasource="SACISIIC" name="ret.SSXINT">
			SELECT INTSOB, CINCAT, INTTEL, SERGUI
			FROM SSXINT 
			WHERE SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.login#">
		</cfquery>
		<cfif ret.SSXINT.RecordCount is 0>
			<cfthrow message="No existe el login #Arguments.login# en SSXINT" errorcode="QRY-0003">
		</cfif>

		 <!--- Datos del Login --->
		 <cfquery datasource="SACISIIC" name="ret.SSXSSC">
			SELECT ltrim(rtrim(CLTCED)) as CLTCED, SSCCTA, SERCLA,
				SERIDS, ESCCOD, CONCGO,
			   VENCOD, SSCFAP, SSCINC, SSCFIN
			   <!--- no se lee el CUECUE porque puede corresponder al vendedor --->
			FROM SSXSSC 
			WHERE SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.login#">
		</cfquery>
		<cfif ret.SSXSSC.RecordCount is 0>
			<cfthrow message="No existe el login #Arguments.login# en SSXSSC" errorcode="QRY-0003">
		</cfif>
		
		<!--- Datos del cliente en SACISIIC --->
		<cfquery datasource="SACISIIC" name="ret.SSMCLT">
			SELECT CLTCOD, CLTTIP, CLTCED, CLTRSO, CLTIMP, GRUCOD
			FROM SSMCLT
			WHERE CLTCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ret.SSXSSC.CLTCED#">
		</cfquery>
		<cfif ret.SSMCLT.RecordCount is 0>
			<cfthrow message="No existe el cliente #ret.SSXSSC.CLTCED# en SSMCLT" errorcode="QRY-0008">
		</cfif>
		
		<!--- Datos de la cuenta en SACISIIC --->
		<cfquery datasource="SACISIIC" name="ret.SSMCUE" maxrows="1">
			SELECT
			   CUEGER, CUECUE, ACTCOD, CUEOBS, CUETIP, CLACOD, CUEFAP,
			   PRVCOD, CANCOD, coalesce (DISCOD, 99) as DISCOD,
			   CUEDIR, CUETEL, CUETL2,
			   CUEFAX, CUEGER, CUEGER, CUEGER
			FROM SSMCUE
			WHERE CLTCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ret.SSMCLT.CLTCOD#">
			order by case
				when CUECUE = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CUECUE#">
				then 0 else 1 end
		</cfquery>
		<cfif ret.SSMCUE.RecordCount is 0>
			<cfthrow message="No existe la cuenta para el cliente CLTCOD = #ret.SSMCLT.CLTCOD# en SSMCUE" errorcode="QRY-0008">
		<cfelseif ret.SSMCUE.CUECUE neq Arguments.CUECUE>
			<cfset control_mensaje('QRY-0010', 'La cuenta para CLTCOD = #ret.SSMCLT.CLTCOD# no es #Arguments.CUECUE#, sino #ret.SSMCUE.CUECUE#')>
		</cfif>
		
		<!--- Datos de la notificación --->
		<cfquery datasource="SACISIIC" name="ret.SSMENV">
			SELECT
			   ZOPCOD, ENVAPT, ENVCOP, ENVTIP,
			   ENVDIR, ENVCOP, ENVICO, ENVCAD
			FROM SSMENV
			WHERE CUECUE =<cfqueryparam cfsqltype="cf_sql_integer" value="#ret.SSMCUE.CUECUE#">
		</cfquery>
		
		<!--- Datos del cobro --->
		<cfquery datasource="SACISIIC" name="ret.SSMCOB">
			SELECT IFCCOD, COBCOI, COBIDE, COBANO, COBMES
			FROM SSMCOB
			WHERE CUECUE =<cfqueryparam cfsqltype="cf_sql_integer" value="#ret.SSMCUE.CUECUE#">
		</cfquery>
			
		<!--- buscar EFid para el banco--->
		<cfif Len(ret.SSMCOB.IFCCOD)>
			<cfquery datasource="#session.dsn#" name="ret.ISBentidadFinanciera">
				select EFid
				from ISBentidadFinanciera
				where IFCCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#ret.SSMCOB.IFCCOD#">
			</cfquery>
			<cfif ret.ISBentidadFinanciera.RecordCount is 0>
				<cfthrow message="No está definida la entidad financiera IFCCOD= #ret.SSMCOB.IFCCOD# en ISBentidadFinanciera" errorcode="QRY-0008">
			</cfif>
		<cfelse>
			<cfset ret.ISBentidadFinanciera = QueryNew('EFid')>
		</cfif>
		
		<!--- Buscar el codigo del dominio --->
		<cfquery datasource="#session.dsn#" name="ret.ISBdominioVPN">
			SELECT VPNid
			FROM ISBdominioVPN
			WHERE VPNdominio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.dominioVPN#">
		</cfquery>
		<cfif Len(Arguments.dominioVPN) and Not ret.ISBdominioVPN.RecordCount>
			<cfthrow message="No existe el dominio de VPN #Arguments.dominioVPN# en ISBdominioVPN" errorcode="QRY-0008">
		</cfif>
		
		<cfset ret.LCidPersona = getLCid(ret.SSMCUE.PRVCOD, ret.SSMCUE.CANCOD, ret.SSMCUE.DISCOD)>
		<cfif Len(ret.LCidPersona) is 0>
			<cfthrow message="Provincia/Cantón/Distrito no existen: #ret.SSMCUE.PRVCOD#/#ret.SSMCUE.CANCOD#/#ret.SSMCUE.DISCOD#" errorcode="QRY-0008">
		</cfif>
		
		<cfquery datasource="#session.dsn#" name="ret.ISBpaquete">
			select PQcodigo, PQroaming, PQmailQuota, PQinterfaz
			from ISBpaquete
			where CINCAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#ret.SSXINT.CINCAT#">
		</cfquery>
		<cfif ret.ISBpaquete.RecordCount is 0>
			<cfthrow message="No hay un paquete con CINCAT = #ret.SSXINT.CINCAT#" errorcode="QRY-0008">
		</cfif>
			
		<!--- buscar ECidEstado para la cuenta --->
		<cfquery datasource="#session.dsn#" name="ret.buscarEstado">
			select ECidEstado
			from ISBcuentaEstado
			where ECestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#ret.SSXSSC.ESCCOD#">
			  and ECsubEstado = <cfqueryparam cfsqltype="cf_sql_integer" value="#ret.SSXSSC.CONCGO#">
		</cfquery>
		<cfif ret.buscarEstado.RecordCount is 0>
			<cfthrow message="No está definido el estado #ret.SSXSSC.ESCCOD# #ret.SSXSSC.CONCGO# en ISBcuentaEstado" errorcode="QRY-0008">
		</cfif>

		<cfif IsDefined('Arguments.sobre') and Len(Arguments.sobre) and Arguments.sobre neq 0>
			<!--- buscar las contraseñas por asignar en el sobre de acceso --->
			<cfquery datasource="#session.dsn#" name="ret.ISBsobres">
				select SpwdCorreo, SpwdAcceso
				from ISBsobres
				where Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.sobre#">
			</cfquery>
			<cfif ret.ISBsobres.RecordCount is 0>
				<cfthrow message="El sobre #Arguments.sobre# no existe en ISBsobres" errorcode="QRY-0008">
			</cfif>
		<cfelse>
			<cfset ret.ISBsobres = QueryNew ( 'SpwdCorreo,SpwdAcceso' ) >
		</cfif>
			
		<!--- Leer los servicios por asignar al login.  Podría haber más de
			uno de acceso o de correo con distinto TScodigo --->
		<cfquery datasource="#session.dsn#" name="ret.ISBservicio">
			select
				a.TScodigo, b.TStipo
			from ISBservicio a
				join ISBservicioTipo b
					on a.TScodigo = b.TScodigo
			where a.PQcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ret.ISBpaquete.PQcodigo#">
		</cfquery>
		<!---
			Si no tiene servicios ni modo, porque puede ser un dominio VPN
		<cfif ret.ISBservicio.RecordCount is 0>
			<cfthrow message="El paquete #ret.ISBpaquete.PQcodigo# no tiene servicios" errorcode="QRY-0008">
		</cfif>
		--->
		<cfreturn ret>

	</cffunction>
	
	<!--- getLCid --->
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
	
</cfcomponent>