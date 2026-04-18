<cfcomponent displayname="Tienda" rest="true" restPath="/store" produces="application/json">
    <cfset dsn     = "minisif">
	<cfset ecodigo = 2>
	<cfset apiKey  = "sk_YYP0H1isEXOOD8hkoKwqTjXzjyNhxPgo">
	<cfset signatureSecret = "2VLNParYNDICJ8dwKUWUt6GvKbLoCNi5">
	
	<cfset validateVoucherSchema = {
		"required": ["voucher", "curp"],
		"properties": {
			"voucher": {"type": "string"},
			"curp": {"type": "string"},
			"amount": {"type": "numeric"}
		}
	}>
	
	<cfset checkoutVoucherSchema = {
		"required": ["date", "amount", "voucher", "client", "partials", "payment_date", "curp"],
		"properties": {
			"date": {"type": "string"},
			"amount": {"type": "string"},
			"voucher": {"type": "string"},
			"client": {"type": "string"},
			"partials": {"type": "string"},
			"payment_date": {"type": "string"},
			"curp": {"type": "string"}
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
            
            <cfif NOT validateApiKey()>
                <cfheader statuscode="401">
                <cfreturn {success: false, message: "Unauthorized: Invalid or missing X-API-Key"}>
            </cfif>
    
            <!--- Verify signature (optional) --->
            <cfset var headers = getHTTPRequestData().headers>
            <cfif structKeyExists(headers, "X-Signature")>
                <cfset var payload = this.canonicalizePayload(arguments)>
                <cfif NOT this.verifySignature(payload, headers["X-Signature"])>
                    <cfheader statuscode="401">
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
            
            <cfif NOT validateApiKey()>
                <cfheader statuscode="401">
                <cfreturn {success: false, message: "Unauthorized: Invalid or missing X-API-Key"}>
            </cfif>
    
            <!--- Verify signature (optional) --->
            <cfset var headers = getHTTPRequestData().headers>
            <cfif structKeyExists(headers, "X-Signature")>
                <cfset var payload = canonicalizePayload(arguments.body)>
                <cfif NOT verifySignature(payload, headers["X-Signature"])>
                    <cfheader statuscode="401">
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
</cfcomponent>