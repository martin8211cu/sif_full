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
	<!--- outStream.setMethod(ZipOutputStream.DEFLATED); --->
	
	<!--- Crear un buffer:byte array, equivale a new byte[BUFFER] --->
	<cfset data = RepeatString(' ', BUFFER).getBytes()>
	<cfset fileSeparator = CreateObject("java", "java.lang.System").getProperty("file.separator")>
	<cfdirectory action="list" directory="#fullpath#" name="files" recurse="yes">
	<cfloop query="files">
		<cfif Type Is 'File' And Not FindNoCase(Name, GetFileFromPath(zipfile))>
			<cfset nameInZip = Mid(Directory & fileSeparator, Len(fullpath)+2, Len(Directory)) & Name >
			<cfoutput>Agregando #nameInZip#</cfoutput><br>
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
		</cfif>
		</cfloop>
	<cfset outStream.close()>
</cffunction>
	
<cffunction name="unjar" output="false">
	<cfargument name="jarfile" type="string">
	<cfargument name="destdir" type="string">

	<cfscript>
		fileSeparator = CreateObject("java", "java.lang.System").getProperty("file.separator");
		if (Not Arguments.destdir.endsWith(fileSeparator)) {
			Arguments.destdir = Arguments.destdir & fileSeparator;
		}
		zipFile = createObject("java", "java.util.zip.ZipFile").
			init(Arguments.jarfile);
		byteBuffer	= RepeatString(" ", 8192).getBytes();
		zipEntries = zipFile.Entries();
		while (zipEntries.hasMoreElements()) {
			zipEntry = zipEntries.nextElement();
			if (Not zipEntry.isDirectory()) {
				entryName = zipEntry.getName();
				
				entryPath = GetDirectoryFromPath(entryName);
				if(entryPath.startsWith(fileSeparator)) {
					entryPath = Mid(entryPath, 2, Len(entryPath) - 1);
				}
				entryPath = Arguments.destdir & entryPath;
				if (Not DirectoryExists(entryPath)) {
					CreateObject("java", "java.io.File").init(entryPath).mkdirs();
				}
				
				fileOutputStream = CreateObject("java", "java.io.FileOutputStream")
					.init(Arguments.destdir & entryName);
				
				buffOutputStream = createObject("java", "java.io.BufferedOutputStream")	
					.init(fileOutputStream);
				
				inpStream = zipFile.getInputStream(zipEntry);
				while(true) {
					bytesRead = inpStream.read(byteBuffer);
					if(bytesRead LT 0) break;
					buffOutputStream.write(byteBuffer, 0, bytesRead);
				}
				inpStream.close();
				buffOutputStream.close();
			}
		}
		zipFile.close();
	</cfscript>
</cffunction>
	
</cfcomponent>