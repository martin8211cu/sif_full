<cfcomponent>
	<!---init--->
	<cfset This.Debug = true>
	<cfparam name="Request._saci_intf" default="#StructNew()#">
	<cfparam name="Request._saci_intf.IBid" default="">
	<cfparam name="Request._saci_intf.S02CON" default="">
	<cfparam name="Request._saci_intf.origen" default="">
	<cfparam name="Request._saci_intf.Error" default="0">
	
	
	<!---validarOrigen--->
	<cffunction name="validarOrigen">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="obligar" type="string" default="saci,siic,cic">
		<!---
			siic: sistema de clientes interno de racsa;
			cic: CRM provisto por siebel
			saci: Este sistema
		--->
		<cfif Not ListFind(Arguments.obligar, Arguments.origen)>
			<cfthrow message="Origen inválido: #origen#.  Debe ser #Arguments.obligar#." errorcode="ORI-0001">
		</cfif>
	</cffunction>
	<!---getParametro--->
	<cffunction name="getParametro">
	  <cfargument name="Pcodigo" type="numeric" required="Yes"  displayname="Parámetro">
	  
		<cfinvoke component="saci.comp.ISBparametros" method="Get" Pcodigo="#Arguments.Pcodigo#"
		returnvariable="retval"/>
		<cfreturn retval>
	</cffunction>
	<!---getMStexto--->
	<cffunction name="getMStexto">
		<cfargument name="S02VA2" type="string" required="Yes" displayname="Parámetro">
		<cfif Left(Arguments.S02VA2, 1) is 'G'>
			<cfreturn 'Gestión de Cobro'>
		<cfelseif Left(Arguments.S02VA2, 1) is 'O'>
			<cfreturn 'Solicitud del cliente'>
		<cfelseif Left(Arguments.S02VA2, 1) is 'P'>
			<cfreturn 'Retiro por Spam'>
		<cfelseif Left(Arguments.S02VA2, 1) is 'Q'>
			<cfreturn 'Retiro por cambio de paquete'>
		<cfelse>
			<cfthrow message="Texto inválido para getMStexto en S02VA2: '#Arguments.S02VA2#'">
		</cfif>
	</cffunction>
	<!---control_inicio--->
	<cffunction name="control_inicio" access="private" returntype="void" output="false">
		<cfargument name="params" type="struct">
		<cfargument name="interfaz" type="string">
		<cfargument name="asunto" type="string" default="">

		<cfset Request._saci_intf.interfaz = Arguments.interfaz>
		<cfset Request._saci_intf.servicio = ''>
		<cfset Request._saci_intf.asunto = asunto>
		<cfquery datasource="#session.dsn#" name="control_inicio_q">
			select severidad_log
			from ISBinterfaz
			where interfaz = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.interfaz#">
		</cfquery>
		<cfset Request._saci_intf.severidad_log = control_inicio_q.severidad_log>
		<cfinvoke component="home.Componentes.aspmonitor" method="GetHostName" returnvariable="localhostname"/>
		<cfset control_mensaje ('INF-0004', 'Inicia interfaz #Arguments.interfaz#, asunto #Arguments.asunto#, hostname: #localhostname#')>
		<cfif Len(Request._saci_intf.IBid)>
			<cfset control_arguments (Arguments.params)>
			<cfset control_asunto (Arguments.asunto)>
		<cfelse>
			<cfset StructAppend(Request._saci_intf, Arguments.params, false)>
		</cfif>
	</cffunction>
	<!---control_arguments--->
	<cffunction name="control_arguments" access="private" returntype="void" output="false">
		<cfargument name="params" type="struct">
		<cfset StructAppend(Request._saci_intf, Arguments.params, true)>
		<cfset control_mensaje( 'ORI-0004' )>
		<cfif Request._saci_intf.IBid>
			<cfset text_args = calcular_text_args()>
			<cfquery datasource="#session.dsn#">
				update ISBinterfazBitacora
				set interfaz = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Request._saci_intf.interfaz#">,
				S02CON=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request._saci_intf.S02CON#" null="#Len(Request._saci_intf.S02CON) is 0#">,
				origen=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Request._saci_intf.origen#">,
				<cfif Len(text_args) GT 255>
					args_text = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#text_args#">,
					args = null
				<cfelse>
					args_text = null,
					args = <cfqueryparam cfsqltype="cf_sql_varchar" value="#text_args#">
				</cfif>
				where IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Request._saci_intf.IBid#">
			</cfquery>
		</cfif>
	</cffunction>	
	<!---control_asunto--->
	<cffunction name="control_asunto" access="private" returntype="void" output="false">
		<cfargument name="asunto" type="string">
		<cfset Request._saci_intf.asunto = Arguments.asunto>
		<cfset control_mensaje( 'ORI-0003', Arguments.asunto )>
		<cfif Len(Request._saci_intf.IBid)>
			<cfquery datasource="#session.dsn#">
				update ISBinterfazBitacora
				set asunto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.asunto#">
				where IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Request._saci_intf.IBid#">
			</cfquery>
		</cfif>
	</cffunction>	
	<!---control_reenviar--->
	<cffunction name="control_reenviar" access="public" returntype="void" output="false">
		<cfargument name="IBid" type="numeric">
		
		<cfset Request._saci_intf.IBid = Arguments.IBid>
		
		<cfquery name="control_reenviar_q" datasource="#session.dsn#">
			update ISBinterfazBitacora
			set severidad = 0
			where IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IBid#">
			
			select ib.interfaz, ib.S02CON, ib.origen, ib.asunto, i.severidad_log
			from ISBinterfazBitacora ib
				join ISBinterfaz i
					on i.interfaz = ib.interfaz
			where ib.IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IBid#">
		</cfquery>
		
		<cfset Request._saci_intf.servicio = ''>
		<cfset Request._saci_intf.interfaz = control_reenviar_q.interfaz>
		<cfset Request._saci_intf.S02CON = control_reenviar_q.S02CON>
		<cfset Request._saci_intf.origen = control_reenviar_q.origen>
		<cfset Request._saci_intf.asunto = control_reenviar_q.asunto>
		<cfset Request._saci_intf.severidad_log = control_reenviar_q.severidad_log>
		

		<cfset control_mensaje ('INF-0001', 'Reenviando invocación, IBid:#Request._saci_intf.IBid#')>
	</cffunction>
	<!---control_servicio: indica el servicio que se va a trabajar --->
	<cffunction name="control_servicio" access="private" returntype="void" output="false">
		<cfargument name="servicio">
		<cfif Not ListFind('saci,siic,crm,repconn,acceso,correo,roaming', Arguments.servicio)>
			<cfthrow message="Servicio inválido">
		</cfif>
		<cfset control_mensaje( 'ORI-0002', Arguments.servicio )>
		<cfset Request._saci_intf.servicio = Arguments.servicio>
	</cffunction>
	<!---control_final--->
	<cffunction name="control_final" access="private" returntype="void" output="false">
		<cfset control_mensaje ('INF-0003', 'Terminado')>
		<cfif Len(Request._saci_intf.IBid)>
			<cfquery datasource="#session.dsn#">
				update ISBinterfazBitacora
				set resuelto_por = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				,  resuelto_login = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usulogin#">
				,  resuelto_fecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				where IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Request._saci_intf.IBid#">
				  and severidad <= 0
			</cfquery>
		</cfif>
	</cffunction>
	<!---control_catch--->
	<cffunction name="control_catch" access="private" returntype="string" output="false">
		<cfargument name="error" type="any">
		
		<cfparam name="Arguments.error.ErrorCode" default="">
		
		<cfif Len(Request._saci_intf.S02CON)>
			<cfinvoke component="SSXS02" method="Error"
				Error= "#Arguments.error.ErrorCode#"
				S02CON="#Request._saci_intf.S02CON#" />
		</cfif>
		
		<cfset Arguments.Error.Diagnostics = Arguments.Error.Detail>
		
		<cfinvoke component="home.Componentes.ErrorHandler" method="guardarError"
			error="#Arguments.error#"
			returnvariable="errorid"/>
		 <!---<cfparam name="Arguments.error.ErrorCode" default="">--->
		<cfset errmsg = error.Message & ' ' & error.Detail>
			
		<cfset control_mensaje (Arguments.error.ErrorCode, errmsg, errorid)>
		<cfset Request._saci_intf.Error = Arguments.error.ErrorCode>
	</cffunction>
	<!---control_mensaje--->
	<cffunction name="control_mensaje" access="private" returntype="string" output="false">
		<cfargument name="codMensaje" type="string">
		<cfargument name="msg" type="string" default="">
		<cfargument name="errorid" type="string" default="">
		
		<cfif Len(Arguments.codMensaje) is 0>
			<!--- Código genérico de error --->
			<cfset Arguments.codMensaje = 'ERR-0000'>
		</cfif>
		<cfparam name="Request._saci_intf.interfaz" default="E000">
		<cfparam name="Request._saci_intf.asunto" default="">
		<cfparam name="Request._saci_intf.servicio" default="">
		<cfparam name="Request._saci_intf.severidad_log" default="-10">
		
		
		<cfquery datasource="#session.dsn#" name="ISBinterfazMensaje">
			select severidad
			from ISBinterfazMensaje
			where codMensaje = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.codMensaje#">
		</cfquery>
		<cfif ISBinterfazMensaje.RecordCount>
			<cfset severidad_mensaje = ISBinterfazMensaje.severidad>
		<cfelse>
			<cfset severidad_mensaje = 20><!--- ERROR siempre, ya que el mensaje debiera estar --->
			<cfset Arguments.msg = '[' & Arguments.codMensaje & '] ' & Arguments.msg>
			<cfset Arguments.codMensaje = 'ERR-0000'>
		</cfif>
		
		
		<cfif Not Len(Request._saci_intf.IBid)>
			<cfif severidad_mensaje GE Request._saci_intf.severidad_log>
				<cfset control_header(severidad_mensaje)>
			<cfelse>
				<cfreturn>
			</cfif>
		<cfelse>
			<cfquery datasource="#session.dsn#">
				update ISBinterfazBitacora
				set severidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#severidad_mensaje#">
				where IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Request._saci_intf.IBid#">
				  and severidad < <cfqueryparam cfsqltype="cf_sql_integer" value="#severidad_mensaje#">
			</cfquery>
		</cfif>
		<cfquery datasource="#session.dsn#" name="insert_ISBinterfazDetalle">
			insert into ISBinterfazDetalle (
				IBid, codMensaje, servicio, msg,
				errorid, fecha, BMUsulogin, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Request._saci_intf.IBid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.codMensaje#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Request._saci_intf.servicio#" null="#Len(Request._saci_intf.servicio) is 0#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.msg#">,
				
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.errorid#" null="#Len(Arguments.errorid) is 0#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usulogin#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
			<cf_dbidentity1 datasource="#session.dsn#" name="insert_ISBinterfazDetalle" verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 datasource="#session.dsn#" name="insert_ISBinterfazDetalle" verificar_transaccion="false">
		<cfset Request._saci_intf.IBlinea = insert_ISBinterfazDetalle.identity>
	
	
	<!---<cfreturn Arguments.codMensaje>--->
	</cffunction>
	<!---control_header--->
	<cffunction name="control_header" access="private" output="false" returntype="void" hint="Inserta el encabezado en ISBinterfazBitacora">
		<cfargument name="severidad" type="numeric" required="yes" default="0">
		
		<cfset var text_args = calcular_text_args()>
		<cfif Len(Request._saci_intf.IBid)>
			<cfreturn>
		</cfif>
		
		<cfset ip = ''>
		<cfif IsDefined('session.sitio.ip') And Len(session.sitio.ip)>
			<cfset ip = session.sitio.ip>
		<cfelse>
			<cfset _X_Forwarded_For = GetPageContext().getRequest().getHeader("X-Forwarded-For")>
			<cfif IsDefined("_X_Forwarded_For") and Len(_X_Forwarded_For) GT 0>
				<cfset ip = Trim(ListGetAt(_X_Forwarded_For, 1))>
			<cfelse>
				<cfset ip = GetPageContext().getRequest().getRemoteAddr()>
			</cfif>
		</cfif>
		<cfif Not IsDefined('ip')><cfset ip = ''></cfif>
	
		<cfquery datasource="#session.dsn#" name="insert_ISBinterfazBitacora">
			insert into ISBinterfazBitacora (
				interfaz, S02CON, origen, <cfif Len(text_args) GT 255>args_text<cfelse>args</cfif>,
				asunto, ip, fecha, severidad,
				BMUsulogin, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Request._saci_intf.interfaz#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Request._saci_intf.S02CON#" null="#Len(Request._saci_intf.S02CON) is 0#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Request._saci_intf.origen#">,
				<cfif Len(text_args) GT 255>
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#text_args#">,
				<cfelse>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#text_args#">,
				</cfif>
				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Request._saci_intf.asunto#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ip#" null="#Len(ip) is 0#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.severidad#">,
				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usulogin#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
				<cf_dbidentity1 datasource="#session.dsn#" name="insert_ISBinterfazBitacora" verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 datasource="#session.dsn#" name="insert_ISBinterfazBitacora" verificar_transaccion="false">
		<cfset Request._saci_intf.IBid = insert_ISBinterfazBitacora.identity>
	</cffunction>
	<!---control_reset--->
	<cffunction name="control_reset" output="false">
		<cfset Request._saci_intf = StructNew()>
		<cfset Request._saci_intf.IBid = ''>
		<cfset Request._saci_intf.S02CON = ''>
		<cfset Request._saci_intf.origen = ''>
	</cffunction>
	<!---getLGnumero--->
	<cffunction name="getLGnumero" output="false" returntype="numeric" hint="Obtiene el LGnumero">
		<cfargument name="login" type="string" required="yes">
		<cfargument name="LGnumero" type="numeric" default="0" hint="Si viene no se busca">
		<cfargument name="activo" type="boolean" default="no" hint="Se requiere que el usuario esté activo">
		
		<cfif (Arguments.LGnumero)>
			<cfreturn Arguments.LGnumero>
		</cfif>
		<cfset control_servicio( 'saci' )>
		<cfquery datasource="#session.dsn#" name="buscarLogin" maxrows="1">
			select LGnumero
			from ISBlogin
			where LGlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.login#">
			<cfif Arguments.activo> and Habilitado = 1</cfif>
			order by
				case when Habilitado = 1 then 0 else 1 end,	<!--- primero el que esté habilitado --->
				LGnumero desc													<!--- sino el último creado --->
		</cfquery>
		<cfif buscarLogin.RecordCount is 0>
			<cfthrow message="No existe el login #Arguments.login#" errorcode="QRY-0003">
		</cfif>
		<cfset control_mensaje ('QRY-0004', 'LGnumero=#buscarLogin.LGnumero# para #Arguments.login#')>
		<cfreturn buscarLogin.LGnumero>
	</cffunction>
	<!---getISBlogin--->
	<cffunction name="getISBlogin" returntype="query" output="false" hint="Regresa perfil sobre un Login en SACI">
		<cfargument name="LGnumero" type="numeric" required="yes">
		<cfset var getISBlogin_Q = ''>
		<cfset control_servicio( 'saci' )>
		<cfquery datasource="#session.dsn#" name="getISBlogin_Q">
			select lg.LGnumero, lg.LGlogin, lg.LGmailQuota, lg.LGrealName, lg.LGserids,
				lg.Habilitado, lg.Contratoid,
				case when pq.PQtelefono = 1 then lg.LGtelefono else '' end as LGtelefono,
				p.Pnombre, p.Papellido, p.Papellido2,
				pq.PQcodigo, pq.PQnombre, pq.CINCAT, pq.PQmaxSession,
				pr.CTid, pr.CNnumero,
				ct.CUECUE, lg.Snumero,
				coalesce(s.SpwdAcceso, s.SpwdCorreo, lg.LGlogin) as SpwdAcceso,
				coalesce(s.SpwdCorreo, s.SpwdAcceso, lg.LGlogin) as SpwdCorreo,
				'#session.Usulogin#' as Usulogin,lg.LGprincipal,pq.MRidMayorista,pr.CNdevolverdeposito,
				lg.MRid
			from ISBlogin lg
				join ISBproducto pr
					on pr.Contratoid = lg.Contratoid
				join ISBpaquete pq
					on pq.PQcodigo = pr.PQcodigo
				join ISBcuenta ct
					on ct.CTid = pr.CTid
				join ISBpersona p
					on p.Pquien = ct.Pquien
				left join ISBsobres s
					on s.Snumero = lg.Snumero
			where lg.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
		</cfquery>

		<cfif getISBlogin_Q.RecordCount is 0>
			<cfthrow message="No existe el login #Arguments.LGnumero#" errorcode="QRY-0005">
		</cfif>
		<cfset control_mensaje ('QRY-0006', '#getISBlogin_Q.LGlogin# para LGnumero=#Arguments.LGnumero#')>
		<cfreturn getISBlogin_Q>
	</cffunction>
	<!---calcular_text_args--->
	<cffunction name="calcular_text_args" returntype="string">
		<cfset var text_args_ret = ''>
		<cfset var keys = StructKeyArray(Request._saci_intf)>
		<cfset ArraySort(keys, 'text')>
		<cfloop from="1" to="#ArrayLen(keys)#" index="i">
			<cfif StructKeyExists( Request._saci_intf, keys[i]) >
				<cfset theValue = StructFind  ( Request._saci_intf, keys[i] )>
				<cfif (Not ListFindNoCase('IBid,IBlinea,severidad_log,asunto,servicio,interfaz', keys[i]) ) And
						IsSimpleValue(  theValue  ) >
					<cfset text_args_ret = ListAppend(text_args_ret, URLEncodedFormat(LCase( keys[i] )) & "=" & URLEncodedFormat( Request._saci_intf[keys[i]]) )>
				</cfif>
			</cfif>
		</cfloop>
		<cfreturn text_args_ret>
	</cffunction>
	<!---getTStipos--->
	<cffunction name="getTStipos" access="public" returntype="string" output="false">
		<cfargument name="LGnumero" type="numeric" required="yes">
		<cfargument name="TScodigo" type="string" default="">
		<!--- La lista regresa C,A,R  (Correos/Acceso/Roaming) --->
		<cfquery datasource="#session.dsn#" name="TStipos">
			select distinct TStipo
			from ISBlogin a
				join ISBserviciosLogin b
					on a.LGnumero = b.LGnumero
				join ISBservicioTipo c
					on c.TScodigo = b.TScodigo
			where a.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
			<cfif Len(Arguments.TScodigo)>
			  and c.TScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TScodigo#">
			</cfif>
		</cfquery>
		<cfset accesos = ValueList(TStipos.TStipo)>
		<cfif Len(Arguments.TScodigo) is 0>
			<!--- solo si es global se manda el roaming, si es para un TScodigo no --->
			<cfquery datasource="#session.dsn#" name="roaming">
					select pq.PQroaming
					from ISBlogin lg
						join ISBproducto p
							on p.Contratoid = lg.Contratoid
						join ISBpaquete pq
							on pq.PQcodigo = p.PQcodigo
					where lg.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
			</cfquery>
			<cfif roaming.PQroaming is '1'>
				<cfset accesos = ListAppend(accesos, 'R')>
			</cfif>
		</cfif>
		<cfset control_mensaje( 'QRY-0002', 'LGnumero=#Arguments.LGnumero#, accesos=#accesos#' )>
		<cfreturn accesos>
	</cffunction>
	
	<cffunction name="getPQinterfaz" access="public" returntype="string" output="false">	
	<cfargument name="LGnumero" type="numeric" required="yes">
	<cfargument name="servicio" type="string" required="No" default="todos">
	
	<cfquery datasource="#session.dsn#" name="ISBpaqinterfaz">
		select coalesce(paq.PQnombre,'') as PQinterfaz
		    from ISBserviciosLogin sl
    			inner join ISBservicio sp
    				on sl.PQcodigo = sp.PQcodigo
    				and sl.TScodigo = sp.TScodigo
					<cfif Arguments.servicio neq 'todos'>
						and sl.TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.servicio#"> 
    				</cfif>
				inner join ISBpaquete paq
    				on paq.PQcodigo = sp.PQinterfaz
		where sl.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
		</cfquery>
	<cfreturn ISBpaqinterfaz.PQinterfaz>
	</cffunction>
	
	<cffunction name="maxlogines" access="public" returntype="numeric" output="false">
		<cfargument name="paquete" type="query" required="yes">
		
	 <cfset maxlogines = 0>
	
	<cfloop query="paquete">	
	
	 <cfquery datasource="#session.dsn#" name="logines">
		if exists(Select 1 from ISBservicio 
           Where TScodigo = 'CABM'
           and SVcantidad > 0
           and PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#paquete.PQcodigo#">
           and Habilitado = 1)  

          select coalesce(sum(SVcantidad), 0) as cant
	    	from ISBservicio
		    where Habilitado = 1
            and PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#paquete.PQcodigo#">
            and TScodigo in ('ACCS','MAIL')
     else
                  
          select coalesce(sum(SVcantidad), 0) as cant
	    	from ISBservicio
		    where Habilitado = 1
            and PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#paquete.PQcodigo#">
			and TScodigo = 'MAIL'
		</cfquery>
		
			<cfif logines.RecordCount gt 0>				
				<cfif logines.cant gt maxlogines>
					<cfset maxlogines = #logines.cant#>
				</cfif>
			</cfif>
	</cfloop>	
	<cfreturn maxlogines>			
	</cffunction>
	
	<cffunction name="servpaq" access="public" returntype="numeric" output="false">
		<cfargument name="paquete" type="string" default="-1" required="false">

			<cfquery name="pq" datasource="#session.dsn#">
				select PQcodigo from ISBpaquete
				Where Habilitado = 1
				<cfif paquete gt 0>
				and PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#paquete#">
				</cfif>
			</cfquery>
		
		<cfset maxlon = 0>
		<cfset maxlon = maxlogines(pq)>
	
	<cfreturn maxlon>		
	</cffunction>
	
	
	
	
</cfcomponent>