<cfcomponent>
  	 <cffunction name="init">
  	 	<cfargument type="string" name="clientid">
  	 	<cfargument type="string" name="clientsecret">

		<cfset variables.clientid = arguments.clientid>
		<cfset variables.clientsecret = arguments.clientsecret>
		<cfreturn this>
	</cffunction>

	<!---- genera el url del proceso de logeo de google---->
	<cffunction name="generateAuthURL" returntype="String">
		<cfargument type="string" name="redirecturl">
		<cfargument type="string" name="state">
		<cfreturn "https://accounts.google.com/o/oauth2/auth?" & 
				 "client_id=#variables.clientid#" & 
     			 "&redirect_uri=#arguments.redirecturl#" &
				 "&scope=https://www.googleapis.com/auth/userinfo.email&response_type=code" & 
				 "&state=#arguments.state#">

	</cffunction>

	<!---- obtiene informacion del perfil----->
	<cffunction name="getProfile">
		<cfargument type="string" name="accesstoken">
		<cfset var h = new com.adobe.coldfusion.http()>
		<cfset h.setURL("https://www.googleapis.com/oauth2/v1/userinfo")>
		<cfset h.setMethod("get")>
		<cfset h.addParam(type="header",name="Authorization",value="OAuth #accesstoken#")>
		<cfset h.addParam(type="header",name="GData-Version",value="3")>
		<cfset h.setResolveURL(true)>
		<cfset var result = h.send().getPrefix()>
		
		<cfreturn deserializeJSON(result.filecontent.toString())>
	</cffunction>

	<!---- funcion de validacion del logeo---->
	<cffunction name="validateResult">
		<cfargument name="code" type="string">
		<cfargument name="error" type="string">
		<cfargument name="remoteState" type="string">
		<cfargument name="clientState" type="string">
 
		<cfset var result = {}>

		<!---- si es vacio ocurrio un error--->
		<cfif error neq "">
			<cfset result.status = false>
			<cfset result.message = error>
			<cfreturn result>
		</cfif>

		<!---- se asegura que los estados sean iguales---->
		<cfif remoteState neq clientState>
			<cfset result.status = false>
			<cfset result.message = "Los estados no son iguales">
			<cfreturn result>
		</cfif>

		<cfset var token = getGoogleToken(code)>

		<cfif structKeyExists(token, "error")>
			<cfset result.status = false>
			<cfset result.message = token.error>
			<cfreturn result>
		</cfif>
		
		<cfset result.status = true>
		<cfset result.token = token>

		<cfreturn result>

	</cffunction>

	 
	<cffunction access="private" name="getGoogleToken">
		<cfargument name="code" type="string">

		<cfset var postBody = "code=" & UrlEncodedFormat(arguments.code) & "&">
			 <cfset postBody = postBody & "client_id=" & UrlEncodedFormat(application.clientid) & "&">
			 <cfset postBody = postBody & "client_secret=" & UrlEncodedFormat(application.clientsecret) & "&">
			 <cfset postBody = postBody & "redirect_uri=" & UrlEncodedFormat(application.callback) & "&">
			 <cfset postBody = postBody & "grant_type=authorization_code">


			<cfset var h = new com.adobe.coldfusion.http()>
			<cfset h.setURL("https://accounts.google.com/o/oauth2/token")>
			<cfset h.setMethod("post")>
			<cfset h.addParam(type="header",name="Content-Type",value="application/x-www-form-urlencoded")>
			<cfset h.addParam(type="body",value="#postBody#")>
			<cfset h.setResolveURL(true)>
			<cfset var result = h.send().getPrefix()>
			<cfreturn deserializeJSON(result.filecontent.toString())>
	</cffunction>
</cfcomponent>

