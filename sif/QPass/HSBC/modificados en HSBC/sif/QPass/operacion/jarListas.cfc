<cfcomponent output="no">

<cffunction name="jar" access="public" returntype="string" output="false">
	<cfargument name="zipfile" type="string" required="yes">
	<cfargument name="fullpath" type="string" required="yes">
	
	<cfset BUFFER = 2048>
	<cfset origin = CreateObject("java","java.io.BufferedInputStream")>
	<cfset dest = CreateObject("java","java.io.FileOutputStream").init(zipfile)>
	<cfset adler32 = CreateObject("java","java.util.zip.Adler32").init()>
	<cfset checksum = CreateObject("java","java.util.zip.CheckedOutputStream").init(dest, adler32)>
	<cfset buffered = CreateObject("java","java.io.BufferedOutputStream").init(checksum)>
	<cfset outStream = CreateObject("java","java.util.zip.ZipOutputStream").init(buffered)>
	
		
	<!--- Crear un buffer:byte array, equivale a new byte[BUFFER] --->
	<cfset data = RepeatString(' ', BUFFER).getBytes()>
	<cfset fileSeparator = CreateObject("java", "java.lang.System").getProperty("file.separator")>
	<cfdirectory action="list" directory="#fullpath#" name="files" recurse="yes">
	<cfloop query="files">
		<cfif Type Is 'File' And Not FindNoCase(Name, GetFileFromPath(zipfile))>
			<cfset nameInZip = Mid(Directory & fileSeparator, Len(fullpath)+2, Len(Directory)) & Name >
			<cfset fi = CreateObject("java","java.io.FileInputStream").init(Directory & fileSeparator & Name)>
			<cfset origin = CreateObject("java","java.io.BufferedInputStream").init(fi, BUFFER)>
			<cfset entry = CreateObject("java","java.util.zip.ZipEntry").init(nameInZip)>
			<cfset outStream.putNextEntry(entry)>
			<cfloop condition="true">
				<cfset count = origin.read(data, 0, BUFFER)>
				<cfif count EQ -1><cfbreak></cfif>
				<cfset outStream.write(data, 0, count)>
			</cfloop>

			<cfset origin.close()>
			<cffile action="delete" file="#fullpath#/#nameInZip#">
		</cfif>
	</cfloop>
	<cfset outStream.close()>
</cffunction>
</cfcomponent>

