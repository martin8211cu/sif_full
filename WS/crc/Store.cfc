<cfcomponent displayname="Tienda" rest="true" restPath="/store" produces="application/json">
    <cfset dsn     = "minisif">
	<cfset ecodigo = 2>
	<cfset apiKey  = "">
	<cfset signatureSecret = "">
	

    <cffunction name="getConfig" access="public" returntype="void" hint="Obtiene la configuración de la tienda">

        <cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
        <cfset enabled = objParams.getParametroInfo(codigo='30910001', conexion=dsn, ecodigo=ecodigo).Valor>
        <cfset signatureSecret = objParams.getParametroInfo(codigo='30910002', conexion=dsn, ecodigo=ecodigo).Valor>
        <cfset apiKey = objParams.getParametroInfo(codigo='30910003', conexion=dsn, ecodigo=ecodigo).Valor>

		<cfif enabled neq "S">
            <cfthrow message="Tienda deshabilitada">
        </cfif>
        <cfif signatureSecret eq "">
            <cfthrow message="Secreto no configurado">
        </cfif>
        <cfif apiKey eq "">
            <cfthrow message="API Key no configurada">
        </cfif>
        
	</cffunction>

	<cfset validateVoucherSchema = {
		"required": ["voucher", "curp"],
		"properties": {
			"voucher": {"type": "string"},
			"curp": {"type": "string"},
			"amount": {"type": "numeric"}
		}
	}>
	
	<cfset checkoutVoucherSchema = {
		"required": ["date", "amount", "voucher", "client", "address","partials", "payment_date", "curp"],
		"properties": {
			"date": {"type": "string"},
			"amount": {"type": "string"},
			"voucher": {"type": "string"},
			"client": {"type": "string"},
			"address": {"type": "string"},
			"partials": {"type": "string"},
			"payment_date": {"type": "string"},
			"curp": {"type": "string"},
            "notes": {"type": "string"}
		}
	}>

	<cffunction name="validateApiKey" access="private" returntype="boolean">
		<cfset var headers = getHTTPRequestData().headers>
		<cfif structKeyExists(headers, "X-API-Key") AND headers["X-API-Key"] EQ apiKey>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="verifySignature" access="private" returntype="boolean">
		<cfargument name="body" type="string" required="yes">
		<cfargument name="signature" type="string" required="yes">
		<cfset var expected = hash(arguments.body, "HMACSHA256", this.signatureSecret)>
		<cfreturn expected EQ arguments.signature>
	</cffunction>

	<cffunction name="canonicalizePayload" access="private" returntype="string">
		<cfargument name="data" type="struct" required="yes">
		<cfset var keys = arrayNew(1)>
		<cfset var parts = arrayNew(1)>
		<cfloop collection="#arguments.data#" item="key">
			<cfset arrayAppend(keys, key)>
		</cfloop>
		<cfset arraySort(keys, "textnocase")>
		<cfloop array="#keys#" index="key">
			<cfset arrayAppend(parts, key & "=" & toString(arguments.data[key]))>
		</cfloop>
		<cfreturn arrayToList(parts, "&")>
	</cffunction>

	<cffunction name="validateSchema" access="private" returntype="struct">
		<cfargument name="data" type="struct" required="yes">
		<cfargument name="schema" type="struct" required="yes">
		
		<cfset var errors = arrayNew(1)>
		<cfset var result = structNew()>
		
		<!--- Check required fields --->
		<cfif structKeyExists(schema, "required")>
			<cfloop array="#schema.required#" index="field">
				<cfif NOT structKeyExists(data, field) OR data[field] EQ "">
					<cfset arrayAppend(errors, "Missing required field: #field#")>
				</cfif>
			</cfloop>
		</cfif>
		
		<!--- Check properties --->
		<cfif structKeyExists(schema, "properties")>
			<cfloop collection="#schema.properties#" item="field">
				<cfif structKeyExists(data, field)>
					<cfset var prop = schema.properties[field]>
					<cfif structKeyExists(prop, "type")>
						<cfif prop.type EQ "string" AND NOT isSimpleValue(data[field])>
							<cfset arrayAppend(errors, "Field #field# must be a string")>
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfset result.valid = arrayLen(errors) EQ 0>
		<cfset result.errors = errors>
		<cfreturn result>
	</cffunction>

	<cffunction name="validate" restPath="/voucher/validate" access="remote" returnformat="JSON"  produces="application/json" httpMethod="POST" returntype="struct">
        <cfargument name="body" type="struct" required="true">
        <cftry>
            
            <cfset getConfig()>

            <cfif NOT validateApiKey()>
                <cfreturn {success: false, message: "Unauthorized: Invalid or missing X-API-Key"}>
            </cfif>
    
            <!--- Verify signature (optional) --->
            <cfset var headers = getHTTPRequestData().headers>
            <cfif structKeyExists(headers, "X-Signature")>
                <cfset var payload = this.canonicalizePayload(arguments)>
                <cfif NOT this.verifySignature(payload, headers["X-Signature"])>
                    <cfreturn {success: false, message: "Unauthorized: Invalid signature"}>
                </cfif>
            </cfif>
            
                
            <!--- Validate schema --->
            <cfset var validation = validateSchema(arguments.body, validateVoucherSchema)>
            <cfif NOT validation.valid>
                <cfreturn {success: false, message: arrayToList(validation.errors, "; ")}>
            </cfif>

            <cfset Vales = createObject("component","crc.Componentes.web.Vales")>
            <cfset Vales.init(dsn, ecodigo)>

            <cfset data = Vales.validaVale(
                voucher=arguments.body.voucher,
                curp=arguments.body.curp,
                digital=true,
                amount=isDefined("arguments.body.amount") ? arguments.body.amount : 0
            )>
            
    
            <cfreturn {success: true, data: data}>
        <cfcatch>
            <cfreturn {success: false, message: cfcatch.message}>
        </cfcatch>
        </cftry>
	</cffunction>
	
	<cffunction name="checkout" restPath="/voucher/checkout" access="remote" returnformat="JSON"  produces="application/json" httpMethod="POST" returntype="struct">
        <cfargument name="body" type="struct" required="true">
        
        <cftry>
            
            <cfset getConfig()>

            <cfif NOT validateApiKey()>
                <cfreturn {success: false, message: "Unauthorized: Invalid or missing X-API-Key"}>
            </cfif>
    
            <!--- Verify signature (optional) --->
            <cfset var headers = getHTTPRequestData().headers>
            <cfif structKeyExists(headers, "X-Signature")>
                <cfset var payload = canonicalizePayload(arguments.body)>
                <cfif NOT verifySignature(payload, headers["X-Signature"])>
                    <cfreturn {success: false, message: "Unauthorized: Invalid signature"}>
                </cfif>
            </cfif>
            
                
            <!--- Validate schema --->
            <cfset var validation = validateSchema(arguments.body, checkoutVoucherSchema)>
            <cfif NOT validation.valid>
                <cfreturn {success: false, message: arrayToList(validation.errors, "; ")}>
            </cfif>

            <cfset Vales = createObject("component","crc.Componentes.web.Vales")>
            <cfset Vales.init(dsn, ecodigo)>

            <cfset data = Vales.reservaVale(
                voucher=arguments.body.voucher,
                curp=arguments.body.curp,
                date=arguments.body.date,
                partials=arguments.body.partials,
                client=arguments.body.client,
                address=arguments.body.address,
                notes=arguments.body.notes,
                amount=arguments.body.amount,
                payment_date=arguments.body.payment_date,
                digital=true
            )>
            
    
            <cfreturn {success: true, data: data}>
        <cfcatch>
            <cfreturn {success: false, message: cfcatch.message}>
        </cfcatch>
        </cftry>
	</cffunction>
	
	<cffunction name="paymentPlans" restPath="/payment-plans" access="remote" returnformat="JSON"  produces="application/json" httpMethod="GET" returntype="struct">
        <cfargument name="monto" type="string" required="true" restArgSource="query">
        
        <cftry>
            <cfset var data = ArrayNew(1)>
            <cfset var headers = getHTTPRequestData().headers>
            <cfset var payloadData = structNew()>
            <cfset var qryPaymentPlans = "">
            
            <cfset getConfig()>

            <cfif NOT validateApiKey()>
                <cfreturn {success: false, message: "Unauthorized: Invalid or missing X-API-Key"}>
            </cfif>
    
            <!--- Verify signature (optional) --->
            <cfset payloadData.monto = arguments.monto>
            <cfif structKeyExists(headers, "X-Signature")>
                <cfset var payload = canonicalizePayload(payloadData)>
                <cfif NOT verifySignature(payload, headers["X-Signature"])>
                    <cfreturn {success: false, message: "Unauthorized: Invalid signature"}>
                </cfif>
            </cfif>

            <cfif NOT len(trim(arguments.monto)) OR NOT isNumeric(arguments.monto)>
                <cfreturn {success: false, message: "Invalid amount: 'monto' must be numeric"}>
            </cfif>

            <cfif len(trim(arguments.vale_id))>
                <cfif NOT isNumeric(arguments.vale_id)>
                    <cfreturn {success: false, message: "Invalid value: 'vale_id' must be numeric"}>
                </cfif>
                <cfset valeId = val(arguments.vale_id)>
            </cfif>

            <cfquery name="qryPaymentPlans" datasource="#dsn#">
                SELECT
                    Rango_Id,
                    Vale_Id,
                    Vale_Inicio,
                    Vale_Final,
                    Vale_Numero_Pago,
                    Vale_Porc_Interes,
                    Vale_Fec_Actualizacion,
                    Usuario_Id,
                    Rango_Nombre,
                    Rango_Fecha_Inicio,
                    Rango_Fecha_Final,
                    Rango_Siguente_Pago,
                    Articulo_Id,
                    Rango_Descuento
                FROM Vale_Credito_Rango
                WHERE getdate() between Rango_Fecha_inicio and Rango_Fecha_final
                  AND Vale_Inicio <= <cfqueryparam value="#val(arguments.monto)#" cfsqltype="cf_sql_money"> 
                  AND Vale_final >=<cfqueryparam value="#val(arguments.monto)#" cfsqltype="cf_sql_money">
                  AND Vale_Id = 1
                ORDER BY Vale_Numero_Pago
            </cfquery>

            <cfloop query="qryPaymentPlans">
                <cfset var item = structNew()>
                <cfset item["rango_id"] = qryPaymentPlans.Rango_Id>
                <cfset item["vale_id"] = qryPaymentPlans.Vale_Id>
                <cfset item["vale_inicio"] = qryPaymentPlans.Vale_Inicio>
                <cfset item["vale_final"] = qryPaymentPlans.Vale_Final>
                <cfset item["vale_numero_pago"] = qryPaymentPlans.Vale_Numero_Pago>
                <cfset item["vale_porc_interes"] = qryPaymentPlans.Vale_Porc_Interes>
                <cfset item["vale_fec_actualizacion"] = qryPaymentPlans.Vale_Fec_Actualizacion>
                <cfset item["usuario_id"] = qryPaymentPlans.Usuario_Id>
                <cfset item["rango_nombre"] = qryPaymentPlans.Rango_Nombre>
                <cfset item["rango_fecha_inicio"] = qryPaymentPlans.Rango_Fecha_Inicio>
                <cfset item["rango_fecha_final"] = qryPaymentPlans.Rango_Fecha_Final>
                <cfset item["rango_siguente_pago"] = qryPaymentPlans.Rango_Siguente_Pago>
                <cfset item["articulo_id"] = qryPaymentPlans.Articulo_Id>
                <cfset item["rango_descuento"] = qryPaymentPlans.Rango_Descuento>
                <cfset arrayAppend(data, item)>
            </cfloop>

            <cfreturn {success: true, data: data}>
        <cfcatch>
            <cfreturn {success: false, message: cfcatch.message}>
        </cfcatch>
        </cftry>
	</cffunction>
</cfcomponent>