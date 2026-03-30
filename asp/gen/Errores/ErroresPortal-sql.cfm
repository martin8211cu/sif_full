<cfinclude template="fnErrorCode.cfm">
<cfif isdefined("Form.btnGenerar") and isdefined("form.Fuente") and form.Fuente NEQ "">
	<cfset LvarFile = expandPath("/#form.Fuente#")>
	<cfset LvarDir = getDirectoryFromPath(LvarFile)>
	<cfset LvarSlash = right(LvarDir,1)>
	<cfif not FileExists(#LvarFile#) and not (DirectoryExists(#LvarFile#) and isdefined("form.chkSubdir"))>
		<cfthrow message="Archivo no existe: '#LvarFile#'">
	</cfif>
	<cfset LvarArchivos = arrayNew(1)>

	<cfif isdefined("form.chkSubdir")>
		<cfdirectory action="list" directory="#getDirectoryFromPath(LvarFile)#" name="rsDir" filter="*.cf?" recurse="no">
		<cfset i=0>
		<cfloop query="rsDir">
			<cfif lcase(right(rsDir.name,4)) EQ ".cfm" or lcase(right(rsDir.name,4)) EQ ".cfc">
				<cfset i++>
				<cfset LvarArchivos[i] = rsDir.Directory & LvarSlash & rsDir.name>
			</cfif>
		</cfloop>
	<cfelse>
		<cfset LvarArchivos[1] = LvarFile>
	</cfif>
	<cfset sbCambiarCFM(LvarArchivos)>
</cfif>
<cflocation url="ErroresPortal.cfm">
