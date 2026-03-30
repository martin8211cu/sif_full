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
