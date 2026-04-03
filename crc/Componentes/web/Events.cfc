<cfcomponent displayname="Events" hint="Componente para enviar eventos SIF a webhooks según especificación OpenAPI">

	<!--- Propiedades del componente --->
	<cfset this.dsn = "minisif">
	<cfset this.ecodigo = 2>
	<cfset this.webhookEnabled = false>
	<cfset this.webhookUrl = "">
	<cfset this.webhookSecret = "">
	<cfset this.webhookToken = "">
	<cfset this.timeout = 30>
	<cfset this.logFile = "Events">
	<cfset this.maxEventAge = 86400> <!--- 24 horas en segundos --->

	<!--- Constructor --->
	<cffunction name="init" access="public" returntype="Events" hint="Inicializa el componente Events">
		<cfargument name="dsn" type="string" required="false" default="#session.dsn#">
		<cfargument name="ecodigo" type="numeric" required="false" default="#session.ecodigo#">
		<cfargument name="timeout" type="numeric" required="false" default="30">
		<cfargument name="maxEventAge" type="numeric" required="false" default="86400">

        <cfset this.dsn = arguments.dsn>
        <cfset this.ecodigo = arguments.ecodigo>
		<cfset this.timeout = arguments.timeout>
		<cfset this.maxEventAge = arguments.maxEventAge>
        <cfset configureWebhook()>

		<cfreturn this>
	</cffunction>

	<!--- Configurar webhook --->
	<cffunction name="configureWebhook" access="public" returntype="void" hint="Configura la URL, secret y token del webhook">

        <cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
        <cfset webhookEnabled = objParams.getParametroInfo(codigo='30900001', conexion=this.dsn, ecodigo=this.ecodigo).Valor>
        <cfset webhookUrl = objParams.getParametroInfo(codigo='30900002', conexion=this.dsn, ecodigo=this.ecodigo).Valor>
        <cfset webhookSecret = objParams.getParametroInfo(codigo='30900003', conexion=this.dsn, ecodigo=this.ecodigo).Valor>
        <cfset webhookToken = objParams.getParametroInfo(codigo='30900004', conexion=this.dsn, ecodigo=this.ecodigo).Valor>

		<cfset this.webhookEnabled = webhookEnabled eq "S">
		<cfset this.webhookUrl = webhookUrl>
		<cfset this.webhookSecret = webhookSecret>
		<cfset this.webhookToken = webhookToken>
	</cffunction>

	<!--- Generar firma HMAC --->
	<cffunction name="generateHMACSignature" access="private" returntype="string" hint="Genera firma HMAC-SHA256">
		<cfargument name="payload" type="string" required="true">

		<cfif this.webhookSecret eq "">
			<cfreturn "">
		</cfif>

		<!--- Usar Java para HMAC-SHA256 --->
		<cfset var secret = createObject("java", "javax.crypto.spec.SecretKeySpec").init(
			this.webhookSecret.getBytes("UTF-8"),
			"HmacSHA256"
		)>
		<cfset var mac = createObject("java", "javax.crypto.Mac").getInstance("HmacSHA256")>
		<cfset mac.init(secret)>
		<cfset var hash = mac.doFinal(arguments.payload.getBytes("UTF-8"))>

		<!--- Convertir a hexadecimal --->
		<cfset var sb = createObject("java", "java.lang.StringBuilder")>
		<cfloop array="#hash#" index="b">
			<cfset sb.append(createObject("java", "java.lang.String").format("%02x", [b]))>
		</cfloop>

		<cfreturn sb.toString()>
	</cffunction>

	<!--- Generar eventId único --->
	<cffunction name="generateEventId" access="private" returntype="string" hint="Genera ID único para evento">
		<cfreturn "evt_" & createUUID()>
	</cffunction>

	<!--- Normaliza keys de un struct/array a minusculas (recursivo) --->
	<cffunction name="normalizeKeysLower" access="private" returntype="any" hint="Normaliza recursivamente las keys de struct a minúsculas para JSON exacto">
		<cfargument name="value" required="true">
		<cfif isStruct(arguments.value)>
			<cfset var normalized = {}>
			<cfloop collection="#arguments.value#" item="k">
				<cfset var v = arguments.value[k]>
				<cfset var keyLower = lcase(k)>
				<cfset normalized[keyLower] = normalizeKeysLower(v)>
			</cfloop>
			<cfreturn normalized>
		<cfelseif isArray(arguments.value)>
			<cfset var normalized = []>
			<cfloop array="#arguments.value#" index="item">
				<cfset arrayAppend(normalized, normalizeKeysLower(item))>
			</cfloop>
			<cfreturn normalized>
		<cfelse>
			<cfreturn arguments.value>
		</cfif>
	</cffunction>

	<!--- Validar SIFEvent schema --->
	<cffunction name="validateSIFEvent" access="private" returntype="struct" hint="Valida esquema SIFEvent (event, eventId, timestamp, data, signature opcional)">
		<cfargument name="eventPayload" type="struct" required="true">

		<cfset var validation = {valid:true,message:"OK"}>

		<cfif not structKeyExists(arguments.eventPayload, 'event') or trim(arguments.eventPayload.event) eq "">
			<cfset validation.valid = false>
			<cfset validation.message = "event es requerido">
			<cfreturn validation>
		</cfif>

		<cfif not structKeyExists(arguments.eventPayload, 'eventId') or trim(arguments.eventPayload.eventId) eq "">
			<cfset validation.valid = false>
			<cfset validation.message = "eventId es requerido">
			<cfreturn validation>
		</cfif>

		<cfif not structKeyExists(arguments.eventPayload, 'timestamp') or trim(arguments.eventPayload.timestamp) eq "">
			<cfset validation.valid = false>
			<cfset validation.message = "timestamp es requerido">
			<cfreturn validation>
		</cfif>

		<cfif not structKeyExists(arguments.eventPayload, 'data') or not isStruct(arguments.eventPayload.data)>
			<cfset validation.valid = false>
			<cfset validation.message = "data es requerido y debe ser struct">
			<cfreturn validation>
		</cfif>

		<cfif structKeyExists(arguments.eventPayload, 'signature') and not isSimpleValue(arguments.eventPayload.signature)>
			<cfset validation.valid = false>
			<cfset validation.message = "signature debe ser string opcional">
			<cfreturn validation>
		</cfif>

		<cfreturn validation>
	</cffunction>

	<!--- Enviar evento SIF --->
	<cffunction name="sendEvent" access="public" returntype="struct" hint="Envía un evento SIF al webhook según especificación OpenAPI">
		<cfargument name="eventType" type="string" required="true">
		<cfargument name="eventData" type="struct" required="true">

		<cfset var result = {success: false, message: "", responseCode: 0, responseData: "", eventId: ""}>

		<!--- Validar configuración --->
        <cfif not this.webhookEnabled>
            <cfset result.message = "Webhook deshabilitado por configuración">
            <cfset logEvent("WARNING", "Webhook deshabilitado")>
            <cfreturn result>
        </cfif>

		<cfif this.webhookUrl eq "">
			<cfset result.message = "Webhook URL no configurada">
			<cfset logEvent("WARNING", "Webhook URL no configurada")>
			<cfreturn result>
		</cfif>

		<!--- Generar eventId único --->
		<cfset result.eventId = generateEventId()>

		<!--- Preparar payload según especificación SIFEvent --->
		<cfset var nowDate = now()>
		<cfset timestampValue = dateDiff("s", createDateTime(1970,1,1,0,0,0), now())>
		<cfset var payload = {
			event: arguments.eventType,
			eventId: result.eventId,
			timestamp: timestampValue,
			data: normalizeKeysLower(arguments.eventData)
		}>

		<!--- Validar SIFEvent schema --->
		<cfset var val = validateSIFEvent(payload)>
		<cfif not val.valid>
			<cfset result.message = "Payload inválido: #val.message#">
			<cfset logEvent("ERROR", result.message)>
			<cfreturn result>
		</cfif>

		<!--- Preparar JSON y firma ---
		   Top-level keys se mantienen castead exacto (event, eventId, timestamp, data, signature opcional) --->
		<cfset var bodyToSend = {
			event: payload.event,
			eventId: payload.eventId,
			timestamp: payload.timestamp,
			data: payload.data
		}>

		<cfset var signature = "">
		<cfset var jsonToSign = serializeJSON(bodyToSend, true)>
		<cfif this.webhookSecret neq "">
			<cfset signature = generateHMACSignature(jsonToSign)>
		</cfif>

		<!--- Convertir a JSON usando serializador custom para mantener minúsculas exactas --->
		<cfset var jsonPayload = jsonToSign>

		<!--- Enviar solicitud HTTP --->
		<cftry>
			<cfhttp url="#this.webhookUrl#/api/webhooks/sif" method="post" timeout="#this.timeout#" result="httpResult">
				<cfhttpparam type="header" name="Content-Type" value="application/json">
				<cfif this.webhookToken neq "">
					<cfhttpparam type="header" name="Authorization" value="Bearer #this.webhookToken#">
				</cfif>
				<cfif this.webhookSecret neq "">
				<cfhttpparam type="header" name="X-SIF-Signature" value="#signature#">
				</cfif>
				<cfhttpparam type="body" value="#jsonPayload#">
			</cfhttp>

			<cfset result.responseCode = httpResult.statusCode>
			<cfset result.responseData = httpResult.fileContent>

			<cfif httpResult.statusCode eq "200 OK">
				<cfset result.success = true>
				<cfset result.message = "Evento SIF enviado exitosamente">
				<cfset logEvent("SUCCESS", "Evento '#arguments.eventType#' enviado")>
			<cfelse>
				<cfset result.message = "Error al enviar evento: #httpResult.statusCode# - #httpResult.fileContent#">
				<cfset logEvent("ERROR", result.message)>
			</cfif>

		<cfcatch type="any">
			<cfset result.message = "Error de conexión: #cfcatch.message#">
			<cfset logEvent("ERROR", result.message)>
		</cfcatch>
		</cftry>

		<cfreturn result>
	</cffunction>

	<!--- Logging interno --->
	<cffunction name="logEvent" access="public" returntype="void" hint="Registra eventos en el log">
		<cfargument name="level" type="string" required="true">
		<cfargument name="message" type="string" required="true">
		<cfargument name="data" type="struct" required="false" default="#{}#">

		<cfset var logEntry = "#dateFormat(now(), 'yyyy-mm-dd HH:mm:ss')# [#arguments.level#] #arguments.message#">
		<cfif not structIsEmpty(arguments.data)>
			<cfset logEntry &= " Data: #serializeJSON(arguments.data, true)#">
		</cfif>
        <cflog file="#this.logFile#" text="#logEntry#" log="Application" type="information">
	</cffunction>

	<!--- Obtener configuración actual --->
	<cffunction name="getConfiguration" access="public" returntype="struct" hint="Devuelve la configuración actual del webhook">
		<cfreturn {
			webhookUrl: this.webhookUrl,
			hasSecret: (this.webhookSecret neq ""),
			hasToken: (this.webhookToken neq ""),
			timeout: this.timeout,
			maxEventAge: this.maxEventAge,
			logFile: this.logFile
		}>
	</cffunction>

	<cffunction name="sendStatementAvailable" access="public" returntype="struct" hint="Envía evento statement.available">
		<cfargument name="statement" type="string" required="true">
		<cfargument name="statementType" type="string" required="true">
		<cfargument name="statementStartDate" type="date" required="true">

		<cfset var result = {success: false, message: "", responseCode: 0, responseData: "", eventId: ""}>

		<cftry>
			<cfquery name="cuentasAEnviar" datasource="#this.dsn#">
				select
				co.Codigo Corte, 
				ct.Numero Cuenta, 
				co.Tipo tipoCorte, 
				ct.Tipo tipoCuenta,
				ct.id idCuenta,
				ct.Numero, 
				ct.SNegociosSNid SNid,
				sn.SNnombre,
				sn.SNemail,
				sn.SNenviarEmail,
				ec.Descripcion estado
				from CRCCuentas ct
				inner join CRCCortes co
				on ct.Tipo = co.Tipo
				inner join SNegocios sn on sn.SNid = ct.SNegociosSNid
				inner join CRCMovimientoCuentaCorte mcc
				on ct.id = mcc.CRCCuentasId
				and co.Codigo = mcc.Corte
				inner join CRCEstatusCuentas ec on ec.id = ct.CRCEstatusCuentasid
				where ec.Orden < ( select id 
						from CRCEstatusCuentas
						where Orden = (select Pvalor 
										from CRCParametros 
										where Pcodigo = '30300110' and Ecodigo = #this.ecodigo#)
				)
					and co.Codigo = '#arguments.statement#'
					and ct.TIpo = '#arguments.statementType#'
				order by Cuenta
	
			</cfquery>
			<cfset accounts = arrayNew(1)>
			<cfloop query="cuentasAEnviar">
					<cfset account = structNew()>
					<cfset account["statement"] = arguments.statement>
					<cfset account["snid"] = cuentasAEnviar.SNid>
					<cfset account["account_type"] = trim(cuentasAEnviar.tipoCuenta)>
					<cfset account["account_id"] = cuentasAEnviar.idCuenta>
					<cfset account["account_status"] = trim(cuentasAEnviar.estado)>
					<cfset account["account_number"] = cuentasAEnviar.Numero>
					<cfset account["month"] = dateformat(arguments.statementStartDate, "yyyy-mm")>
					<cfset arrayAppend(accounts, account)>
			</cfloop>
			<cfset result = sendEvent(
				eventType = "statement.available",
				eventData = {
					statement_id = arguments.statement,
					accounts: accounts
				}
			)>
		<cfcatch>
			<cfset logEvent("ERROR", "Error al enviar evento [statement.available]: #cfcatch.message#")>
			<cfset result.message = "Error al enviar evento [statement.available]: #cfcatch.message#">
			<cfset result.responseCode = 0>
			<cfset result.responseData = "">
			<cfset result.eventId = "">
			<cfreturn result>
		</cfcatch>
		</cftry>
		<cfreturn result>
	</cffunction>
	
	<cffunction name="sendPrizeAvailable" access="public" returntype="struct" hint="Envía evento prize.available">
		<cfargument name="statement" type="string" required="true">
		<cfargument name="statementType" type="string" required="true">
		<cfargument name="statementStartDate" type="date" required="true">

		<cfset var result = {success: false, message: "", responseCode: 0, responseData: "", eventId: ""}>
		
		<cfif trim(arguments.statementType) neq "D">
			<cfset result.message = "Tipo de corte no válido: #arguments.statementType#">
			<cfset result.responseCode = 0>
			<cfset result.responseData = "">
			<cfset result.eventId = "">
			<cfreturn result>
		</cfif>
		<cfset corteNum = right(arguments.statement,1)>
		<cfif corteNum neq "1">
			<cfset result.message = "Corte no válido: #arguments.statement#">
			<cfset result.responseCode = 0>
			<cfset result.responseData = "">
			<cfset result.eventId = "">
			<cfreturn result>
		</cfif>
		<cftry>
			<cfquery name="cuentasAEnviar" datasource="#this.dsn#">
				select
					co.Codigo Corte, 
					ct.Numero Cuenta, 
					co.Tipo tipoCorte, 
					ct.Tipo tipoCuenta,
					ct.id idCuenta,
					ct.Numero, 
					ct.SNegociosSNid SNid,
					sn.SNnombre,
					sn.SNemail,
					sn.SNenviarEmail,
					ec.Descripcion estado,
					bonos.Bono Bono,
					bonos.Mes_Venta Mes_Venta
				from CRCCuentas ct
				inner join CRCCortes co
				on ct.Tipo = co.Tipo
				inner join SNegocios sn on sn.SNid = ct.SNegociosSNid
				inner join CRCMovimientoCuentaCorte mcc
				on ct.id = mcc.CRCCuentasId
				and co.Codigo = mcc.Corte
				inner join CRCEstatusCuentas ec on ec.id = ct.CRCEstatusCuentasid
				inner join (												
					SELECT Cuenta, SUM(Bono) AS Bono, Mes_Venta 
					FROM CRC_ReporteBonos
					WHERE Mes_Venta = '#DateFormat(arguments.statementStartDate, "yyyy-MM")#'
					GROUP BY Cuenta, Mes_Venta
				) as bonos
				on ct.Numero = bonos.Cuenta
				where ec.Orden < ( select id 
						from CRCEstatusCuentas
						where Orden = (select Pvalor 
										from CRCParametros 
										where Pcodigo = '30300110' and Ecodigo = #this.ecodigo#)
				)
					and co.Codigo = '#arguments.statement#'
					and ct.TIpo = '#arguments.statementType#'
				order by Cuenta	
			</cfquery>
			<cfset accounts = arrayNew(1)>
			<cfloop query="cuentasAEnviar">
					<cfset account = structNew()>
					<cfset account["statement"] = arguments.statement>
					<cfset account["snid"] = cuentasAEnviar.SNid>
					<cfset account["account_type"] = trim(cuentasAEnviar.tipoCuenta)>
					<cfset account["account_id"] = cuentasAEnviar.idCuenta>
					<cfset account["account_status"] = trim(cuentasAEnviar.estado)>
					<cfset account["account_number"] = cuentasAEnviar.Numero>
					<cfset account["month"] = dateformat(cuentasAEnviar.Mes_Venta, "yyyy-mm")>
					<cfset account["amount"] = cuentasAEnviar.Bono>
					<cfset arrayAppend(accounts, account)>
			</cfloop>
			
			<cfset result = sendEvent(
				eventType = "prize.available",
				eventData = {
					statement_id = arguments.statement,
					accounts: accounts
				}
			)>
		<cfcatch>
			<cfset logEvent("ERROR", "Error al enviar evento [prize.available]: #cfcatch.message#")>
			<cfset result.message = "Error al enviar evento [prize.available]: #cfcatch.message#">
			<cfset result.responseCode = 0>
			<cfset result.responseData = "">
			<cfset result.eventId = "">
			<cfreturn result>
		</cfcatch>
		</cftry>
		<cfreturn result>
	</cffunction>

</cfcomponent>
