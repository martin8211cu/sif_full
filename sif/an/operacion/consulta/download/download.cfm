<cfsetting enablecfoutputonly="yes">
<cfquery datasource="#session.dsn#" name="rsDes">
	select AnexoDes
	from Anexo
	where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
</cfquery>
<cfquery datasource="#session.dsn#" name="rs">
	select e.ACxml, e.ACxls
	from AnexoCalculo e
	where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
	  and ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ACid#">
	  and ACstatus = 'T'<!--- T = Terminado (P=Programado,C=Calculado) --->
	  and Ecodigo in (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, -1)
</cfquery>


<cfif len(rs.ACxls) LTE 1>
	<!--- Upload del XLM viejo, porque no existe el XLS --->
	<cfset LvarType = "XML_VIEJO">
	<cfset LvarData = rs.ACxml>
<cfelseif isdefined("url.xls") OR rs.ACxml EQ "EOF">
	<!--- Upload del XLS y existe el XLS --->
	<cfset LvarType = "XLS_NUEVO">
	<cfset LvarData = rs.ACxls>
<cfelse>
	<!--- Upload del XLM nuevo, porque existe el XLS --->
	<cfset LvarType = "XML_NUEVO">
	<cfset LvarData = rs.ACxml>
</cfif>

<cfif Len(rs.ACxml) LTE 1 AND LvarType NEQ "XLS_NUEVO">
	<cfoutput>No existe la Imagen del Anexo</cfoutput>
<cfelse>
	<cfset filename = REReplace(rsDes.AnexoDes, '[^A-Za-z0-9]', '_', 'all')>
	<cfheader name="Content-Disposition" value="Attachment; filename=#filename#.xls">
	<cfheader name="Expires" value="0">
	
	<cfif LvarType EQ "XML_NUEVO">
		<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
		<cffile action="write" file="#tempfile#" 	output="#LvarData#" charset="iso-8859-1">
		<cfcontent type="application/vnd.ms-excel" 	file="#tempfile#" 	deletefile="yes">
	<cfelseif LvarType EQ "XML_VIEJO">
		<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
		<cffile action="write" file="#tempfile#" 	output="#LvarData#">
		<cfcontent type="application/vnd.ms-excel" 	file="#tempfile#" 	deletefile="yes">
	<cfelse>
		<cfif LvarData[1] EQ 80 and LvarData[2] EQ 75>
			<cfset tempfile = GetTempFile(GetTempDirectory(),"img")>
			<cffile file="#tempfile#" action="write" output="#LvarData#">
			<cfset LvarName=fnUnZip(tempfile,GetTempDirectory())>
			<cffile action="delete" file="#tempfile#">
			<cfcontent type="application/vnd.ms-excel" 	file="#GetTempDirectory()&LvarName#" 	deletefile="yes">
		<cfelse>
			<cfcontent type="application/vnd.ms-excel" 	variable="#LvarData#">
		</cfif>
	</cfif>
</cfif>


<cffunction name="fnUnZip" returntype="string">
	<cfargument name="zipFile">
	<cfargument name="path">
	
	<cfscript>
	   var LobjZF 		= "";	// Java ZipFile
	   var LobjEntries	= "";	// Java Enumeration of ZipLobjEntry
	   var LobjEntry	= "";	// Java ZipLobjEntry
	   var LobjF		= "";	// Java File
	   var LobjFOS		= "";	// Java FileOutputStream
	   var LobjBOS		= "";	// Java BufferedOutputStream
	   var LobjIS		= "";	// Java InputStream

	   var LvarName		= "";
	   var LvarPath		= "";
	   var LvarPathN	= "";
	   var LvarBuffer	= "";
	   var LvarIdx 		= "";
	   var LvarSlash 	= CreateObject("java","java.lang.System").getProperty("file.separator");

	   var LprmZipFile = Arguments.zipFile;
	   var LprmoutputPath = Arguments.path;
	</cfscript>
	<cftry>
		<cfscript>
		   if (mid(LprmOutputPath,len(LprmOutputPath),1) NEQ LvarSlash)
		   {
			   LprmOutputPath = LprmOutputPath & LvarSlash;
		   }
	
		   LobjZF = createObject("java", "java.util.zip.ZipFile");
		   LobjZF.init(LprmZipFile);
	
		   LobjEntries = LobjZF.Entries();
	
		   while(LobjEntries.hasMoreElements())
		   {
			   LobjEntry = LobjEntries.nextElement();
	
			   if(NOT LobjEntry.isDirectory())
			   {
				   LvarName = LobjEntry.getName();
	
				   LvarPathN = len(LvarName) - len(getFileFromPath(LvarName));
	
				   if (LvarPathN)
				   {
					   LvarPath = LprmOutputPath & left(LvarName, LvarPathN);
				   }
				   else
				   {
					   LvarPath = LprmOutputPath;
				   }
	
				   if (NOT directoryExists(LvarPath))
				   {
					   LobjF = createObject("java", "java.io.File");
					   LobjF.init(LvarPath);
					   LobjF.mkdirs();
				   }
	
				   LobjFOS = createObject(
					  "java",
					  "java.io.FileOutputStream");
	
				   LobjFOS.init(LprmOutputPath & LvarName);
	
				   LobjBOS = createObject(
					  "java",
					  "java.io.BufferedOutputStream");
	
				   LobjBOS.init(LobjFOS);
	
				   LobjIS		= LobjZF.getInputStream(LobjEntry);
				   LvarBuffer	= repeatString(" ",1024).getBytes();
				   LvarIdx		= LobjIS.read(LvarBuffer);
	
				   while(LvarIdx GTE 0)
				   {
					 LobjBOS.write(LvarBuffer, 0, LvarIdx);
					 LvarIdx = LobjIS.read(LvarBuffer);
				   }
				   LobjIS.close();
				   LobjBOS.close();
				}
		   }
	
		   LobjZF.close();
		   return LvarName;
		</cfscript>
	<cfcatch type="any">
		<cfreturn "">
	</cfcatch>
	</cftry>
	</cffunction>
<cfscript>
   function fnUnZipArray(LprmInputArray)
   {
       var LobjZIS		= "";	// Java ZipInputStrem
       var LobjEntry	= "";	// Java ZipLobjEntry
       var LobjBIS		= "";	// Java ByteArrayInputStream

       var LvarBuffer	= "";

       LobjBAIS = createObject("java", "java.io.ByteArrayInputStream");
       LobjBAIS.init(LprmInputArray);
       LobjZIS = createObject("java", "java.util.zip.ZipInputStream");
       LobjZIS.init(LobjBAIS);

		LobjEntry = LobjZIS.getNextEntry(); 
		if (LobjEntry NEQ null) 
		{ 
			LvarDecompressedSize = LobjEntry.getSize(); 
			LvarBuffer	= repeatString(" ",LvarDecompressedSize).getBytes();
			LobjZIS.read(LvarUncompressedBuf,0,LvarDecompressedSize); 
		} 

       LobjBAIS.close();
       LobjZIS.close();
	   
	   return LvarBuffer;
    }
</cfscript>

