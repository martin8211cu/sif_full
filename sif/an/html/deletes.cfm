<cfsetting enablecfoutputonly="yes">

<cfset LvarDir=GetDirectoryFromPath(GetCurrentTemplatePath())>
<cfset LvarNow=createODBCdate(now())>

<cfdirectory action="LIST" directory="#LvarDir#" name="rsDir" recurse="no">
<!---
	#rsDir.name#				Nombre del Archivo o Directorio
	#rsDir.directory#			Directorio al que pertenece el Archivo o Directorio
	#rsDir.size#				Tamaño 
	#rsDir.type#				File o Dir
	#rsDir.dateLastModified#	Ultima modificacion
	#rsDir.attributes#			Atributos
	#rsDir.mode# 				N/A
--->
<cfoutput>
<cfloop query="rsDir">
	<cfif rsDir.type EQ "Dir">
		<cftry>
			<cfset LvarDate = "">
			<cfset LvarDate = LSparseDateTime(mid(rsDir.Name,7,2) & "/" & mid(rsDir.Name,5,2) & "/" & mid(rsDir.Name,1,4))>
			Directorio #rsDir.Name#:&nbsp;
			<cfif DateDiff("d",LvarDate,LvarNow) GT 1>
				<cfdirectory action="delete" directory="#LvarDir##rsDir.Name#" recurse="yes">
				BORRADO<BR />
			<cfelse>
				Se mantiene<BR />
			</cfif>
		<cfcatch type="any">
			<cfif LvarDate NEQ "">
				ERROR: #cfcatch.Message#<BR />
			</cfif>
		</cfcatch>
		</cftry>
	</cfif>
</cfloop>
</cfoutput>
