<cfcomponent displayname="WSGetToken">

	<cfset This.C_WS_USER     = 'LDUserWS'> 
	<cfset This.C_WS_PASSWORD = 'UnPassLDWS015O1Nx'> 

	<cffunction name="getToken" access="remote" returntype="struct">
		<cfargument name="usuario"  default="" required="false" Type="String">
		<cfargument name="password" default="" required="false" Type="String">

		<cfset loc.usuario  = trim(arguments.usuario)>
		<cfset loc.password = trim(arguments.password)>

		<cfif loc.usuario eq "" or loc.password eq "" or 
			This.C_WS_USER neq loc.usuario or This.C_WS_PASSWORD neq loc.password>

			<cfset sreturn =  structNew()>
			<cfset sreturn.codigo = 1>
			<cfset sreturn.mensaje = "Usuario y/o password incorrectos">
			<cfreturn sreturn>
		</cfif>
 		
 		<cfset loc.tokenGenerado = tokenPrivado()>
		
		<cfset sreturn =  structNew()>
		<cfset sreturn.codigo = loc.tokenGenerado>
		<cfset sreturn.mensaje = "Token de respuesta">
		<cfreturn sreturn>

	</cffunction>
 

	<cffunction name="tokenPrivado" access="public" returntype="string"> 
		<cfset token = hash(LSDateFormat(Now(), "mmm-dd-yyyy")&this.C_WS_USER&This.C_WS_PASSWORD,"MD5","utf-8")>
		<cfreturn token>
	</cffunction>

</cfcomponent>