<cfcomponent>
	<cfset GvarVersion = "2.0">
	
	<cffunction name="qryEsquemasModelo" access="remote" returntype="array">
		<cfargument name="modelo"	type="string">
		<cfargument name="version"	type="string" default="1">
	
		<cfif Arguments.version NEQ GvarVersion>
			<cfthrow message="Debe instalar la versión #GvarVersion# del PDtoCF.exe">
		</cfif>
		
		<cfquery name="rsSQL" datasource="asp">
			select sch
			  from DBMmodelos m
			  	inner join DBMsch s
					on s.IDsch = m.IDsch
			 where modelo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.modelo#">
		</cfquery>
		<cfif rsSQL.sch EQ "">
			<cfquery name="rsSQL" datasource="asp">
				select sch
				  from DBMsch
				 order by orden
			</cfquery>
		<cfelse>
		</cfif>
		<cfreturn listToArray(valueList(rsSQL.sch))>
	</cffunction>

	<cffunction name="addModelo" access="remote" returntype="void">
		<cfargument name="modelo"	type="string">
		<cfargument name="esquema"	type="string">
		<cfargument name="usuario"	type="string">
	
		<cfquery name="rsSQL" datasource="asp">
			insert into DBMmodelos (IDsch, modelo, uidSVN)
			select 	IDsch
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.modelo#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.usuario#">
			  from DBMsch
			 where sch = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.esquema#">
		</cfquery>
	</cffunction>

	<cffunction name="upload" access="remote" returntype="string">
		<cfargument name="usuario"		type="string">
		<cfargument name="modelo"		type="string">
		<cfargument name="descripcion"	type="string">
		<cfargument name="cantidad"		type="string">
		<cfargument name="XMLzip"		type="binary">

		<cfset Arguments.descripcion = replace(Arguments.descripcion,"<","(","ALL")>
		<cfset Arguments.descripcion = replace(Arguments.descripcion,">",")","ALL")>
		<cfquery name="rsInsert" datasource="asp">
			insert into DBMuploads
				(IDmod, des, uidSVN, fec, sts, stsP, tabs)
			select 	IDmod
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.descripcion#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.usuario#">
					, <cf_dbfunction name="now" datasource="asp">
					, 0
					, 0
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.cantidad#">
			  from DBMmodelos
			 where modelo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.modelo#">
			<cf_dbidentity1 name="rsInsert" returnVariable="LvarIDupl" datasource="asp">
		</cfquery>
		<cf_dbidentity2 name="rsInsert" returnVariable="LvarIDupl" datasource="asp">

		<cfset LvarPath = getTempDirectory()>
		<cfset LvarPath = LvarPath & "DBM" & numberFormat(LvarIDupl, "0000000000")>

		<cfset LvarFile = sbUnZip(XMLzip, LvarPath)>
		<cfset LvarFile = LvarPath & "\" & LvarFile>
		<cfset LvarOBJ = createObject("component", "DBModel")>

		<cfthread
			name="DBModel_upload"
			action="run"
			priority="NORMAL"
		>
			<cfset LvarOBJ.XML_toUpload(LvarFile, LvarIDupl)>
		</cfthread>

		<cfreturn "#LvarIDupl#">

		<cfdirectory action="delete" directory="#LvarPath#">
	</cffunction>
<cfscript>
   function sbUnZip(LprmZipByte, LprmOutputPath)
   {
       var LobjBIS		= "";	// Java ByteArrayInputStream
       var LobjZIS		= "";	// Java ZipInputStream
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

       if (mid(LprmOutputPath,len(LprmOutputPath),1) NEQ LvarSlash)
       {
           LprmOutputPath = LprmOutputPath & LvarSlash;
       }

       LobjBIS = createObject("java", "java.io.ByteArrayInputStream");
       LobjBIS.init(LprmZipByte);

       LobjZIS = createObject("java", "java.util.zip.ZipInputStream");
       LobjZIS.init(LobjBIS);

		LobjEntry = LobjZIS.getNextEntry();
		while(isdefined("LobjEntry") AND LobjEntry NEQ "")
		{
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

               LvarBuffer	= repeatString(" ",1024).getBytes();
               LvarIdx		= LobjZIS.read(LvarBuffer);

               while(LvarIdx GTE 0)
               {
                 LobjBOS.write(LvarBuffer, 0, LvarIdx);
                 LvarIdx = LobjZIS.read(LvarBuffer);
               }
               LobjBOS.close();
			}
			LobjEntry = LobjZIS.getNextEntry();
		}
		LobjZIS.close();
		return LvarName;
    }
</cfscript>
</cfcomponent>