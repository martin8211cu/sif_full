<cfcomponent>
	<cffunction name="AuthorizedKey" access="public" returntype="string" output="false">
		<cfset LvarKey = trim("UID#GetTickCount()#")>
		<cfset application.WSsecurity[LvarKey] = 1>
		<cfreturn LvarKey>
	</cffunction>

	<cffunction name="Authorized" access="public" returntype="boolean" output="false">
		<cfargument name="IDsec" type="string" required="yes">

		<cfif isdefined("application.WSsecurity.#Arguments.IDsec#")>
			<cfset structDelete(application.WSsecurity,Arguments.IDsec)>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
	</cffunction>

	<cffunction name="getWSerror" access="public" returntype="any" output="false">
		<cfargument name="LvarCFcatch" type="any" required="yes">
		
		
		<cfset LvarDET = LvarCFcatch.detail>
		<cfset LvarPto = find("(*_*_*",LvarDET)>
		<cfif LvarPto GT 0>
			<cfset LvarMSG = mid(LvarDET,LvarPto+6,255)>
			<cfset LvarPto = find("*_*_*)",LvarMSG)>
			<cfif LvarPto GT 0>
				<cfset LvarMSG = mid(LvarMSG,1,LvarPto-1)>
				<cfset LvarDET = "Error enviado por WebService Interno">
			<cfelse>
				<cfset LvarMSG = "Error ocurrido al Invocar WebService Interno">
			</cfif>
		<cfelse>
			<cfset LvarMSG = "Error ocurrido al Invocar WebService Interno">
		</cfif>
			
		<cfthrow message="#LvarMSG#" detail="#LvarDET#">
		<cfset LvarCFcatch.Message = "hola">
		<cfreturn LvarCFcatch>
	</cffunction>

	<cffunction name="setWSerror" access="public" returntype="any" output="false">
		<cfargument name="LvarCFcatch" type="any" required="yes">
		
		<cf_errorCode	code = "51411"
						msg  = "(*_*_*@errorDat_1@ @errorDat_2@*_*_*)"
						errorDat_1="#LvarCFcatch.Message#"
						errorDat_2="#LvarCFcatch.Detail#"
		>
		<cfset LvarCFcatch.Message = "(*_*_*#LvarCFcatch.Message#*_*_*)">
		<cfreturn LvarCFcatch>
	</cffunction>
</cfcomponent>

