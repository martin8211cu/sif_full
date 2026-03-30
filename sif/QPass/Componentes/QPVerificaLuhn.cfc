<cfcomponent output="no">
	<cffunction name="ValidaDigitoLuhn" output="no" access="public" returntype="numeric">
		<cfargument name="NoTarjeta" type="string" required="yes">

		<cfset LvarNoTarjeta = trim(replace(Arguments.NoTarjeta, "-", "", "all"))>

		<cfif len(trim(LvarNoTarjeta)) NEQ 16>
			<cfreturn -1>
		</cfif>

		<cfif (mid(LvarNoTarjeta, 15, 1)  LT 0) or  (mid(LvarNoTarjeta, 15, 1)  LT 0) GT 9>
			<cfreturn -2>
		</cfif>	

		<cfif (mid(LvarNoTarjeta, 16, 1)  LT 0) or  (mid(LvarNoTarjeta, 16, 1)  LT 0) GT 9>
			<cfreturn -3>
		</cfif>

		<cfset LvarPosicion = 1>
		<cfset LvarSuma = 0>
		
		<cfloop condition="LvarPosicion LT 15">
			<!--- Validacion de que los digitos sean numéricos --->
			<cfif (mid(LvarNoTarjeta, LvarPosicion, 1)  LT 0) or  (mid(LvarNoTarjeta, LvarPosicion, 1)  LT 0) GT 9>
				<cfreturn -4>
			</cfif>	
			<cfif (mid(LvarNoTarjeta, LvarPosicion + 1, 1)  LT 0) or  (mid(LvarNoTarjeta, LvarPosicion + 1, 1)  LT 0) GT 9>
				<cfreturn -5>
			</cfif>	
			
			<!--- Obtener el digito impar --->
			<cfset LvarDigito = mid(LvarNoTarjeta, LvarPosicion, 1) * 2>
			<cfif LvarDigito GT 9>
				<cfset LvarDigito = LvarDigito - 9>
			</cfif>
			<cfset LvarSuma = LvarSuma + LvarDigito>
			
			<!--- Obtener el dígito par --->
			<cfset LvarSuma = LvarSuma + mid(LvarNoTarjeta, LvarPosicion+1, 1)>

			<cfset LvarPosicion = LvarPosicion + 2>
		</cfloop>

		<cfset LvarDigito = mid(LvarNoTarjeta, 15, 1) * 2>
		<cfif LvarDigito GT 9>
			<cfset LvarDigito = LvarDigito - 9>
		</cfif>
		<cfset LvarSuma = LvarSuma + LvarDigito>

		<cfset LvarSuma = 10 - ( LvarSuma mod 10 )>
        <cfif LvarSuma EQ 10>
        	<cfset LvarSuma = 0>
        </cfif>
		
		<cfif LvarSuma NEQ mid(LvarNoTarjeta, 16, 1)>
			<cfreturn LvarSuma>
		</cfif>
		<cfreturn 100>

	</cffunction>

</cfcomponent>
