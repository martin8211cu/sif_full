<cffunction name="fnUriNotExists" output="false" returntype="struct">
	<cfargument name="pUri" type="string" required="yes">
	<cfargument name="pTipo" type="string" required="yes">
	
	<cfset pUri = trim(pUri)>
	<cfif pTipo EQ 'O'>
		<cfset LvarUri.NotExists = 0>
		<cfset LvarUri.Uri = pUri>
		<cfreturn LvarUri>
	</cfif>
	
	<cfset LvarCFile = ExpandPath(pUri)>
	<cfset LvarJFile = CreateObject("java", "java.io.File")>
	<cfset LvarJFile.init(LvarCFile)>
	<cfif not LvarJFile.exists()>
		<cfset LvarUri.NotExists = 2>
		<cfset LvarUri.Uri = "">
	<cfelse>
		<cfset LvarUri.NotExists = 0>
		<cfif pTipo EQ 'P'>
			<cfif not FileExists(LvarCFile)>
				<cfset LvarUri.NotExists = 2>
				<cfset LvarUri.Uri = "">
			</cfif>
		<cfelse>
			<cfset LvarCFile = mid(LvarCFile,1,len(LvarCFile)-1)>
			<cfif not DirectoryExists(LvarCFile)>
				<cfset LvarUri.NotExists = 2>
				<cfset LvarUri.Uri = "">
			</cfif>
		</cfif>
		<cfif LvarUri.NotExists EQ 0>
			<cfset LvarIni = len(ExpandPath(""))+1>
			<cfset LvarJSFile = mid(LvarJFile.getCanonicalPath(),LvarIni,1000)>
			<cfset LvarCFile = mid(LvarCFile,LvarIni,1000)>
			<cfif LvarJSFile.equals(LvarCFile)>
				<cfset LvarUri.NotExists = 0>
			<cfelse>
				<cfset LvarUri.NotExists = 1>
			</cfif>
			<cfset LvarUri.Uri = replace(LvarJSFile,"\","/","ALL")>
		</cfif>
	</cfif>
	<cfreturn LvarUri>
</cffunction>

<cffunction name="validarUrl" output="false" returntype="boolean">
	<cfargument required="yes" name="LvarURL" type="string" > 

	<cfset SPhomeuri = trim(arguments.LvarURL)>
	<cfset LvarSPhomeuri = SPhomeuri>
	<cfset LvarSignoPto = find("?",LvarSPhomeuri)>
	<cfif LvarSignoPto>
		<cfset LvarSPhomeuriP = mid(LvarSPhomeuri,LvarSignoPto,len(LvarSPhomeuri))>
		<cfset LvarSPhomeuri  = mid(LvarSPhomeuri,1,LvarSignoPto-1)>
	<cfelse>
		<cfset LvarSPhomeuriP = "">
	</cfif>
	<cfif LvarSPhomeuri EQ "/">
		<cfset LvarUri.NotExists = 0>
	<cfelse>
		<cfset LvarUri = fnUriNotExists(LvarSPhomeuri, 'P')>
		<cfif LvarUri.NotExists EQ 1>
			<cfset LvarSPhomeuri  = LvarUri.Uri>
			<cfset SPhomeuri = LvarUri.Uri & LvarSPhomeuriP>
		</cfif>
	</cfif>

	<cfif LvarUri.NotExists EQ 2>
		<!---<cf_errorCode	code = "50274"
		     				msg  = "No existe el archivo indicado para el formato estático: @errorDat_1@"
		     				errorDat_1="#LvarSPhomeuri#"
		     >--->
		<cfreturn false >
	<cfelse>	
		<cfreturn true >
	</cfif>
</cffunction>

