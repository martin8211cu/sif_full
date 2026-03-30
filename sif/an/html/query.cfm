<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Mensaje" 	default="Escoja un Anexo" 
returnvariable="LB_Mensaje" xmlfile="query.xml"/>
<cfsetting enablecfoutputonly="yes">
<cfset LvarSid = GetTickCount()><cfset application.Sid["SID#LvarSid#"] = true>
<cflock throwontimeout="no" timeout="1">
	<cfhttp
		url			 = "http://#session.sitio.host#/cfmx/sif/an/html/deletes.cfm?Sid=#LvarSid#"
		method		 = "get"
		timeout		 = "1"
		throwonerror = "no"
	/>
</cflock>

<cfparam name="url.tipo" 	default="">
<cfparam name="url.AnexoId" default="">
<cfparam name="url.ACid" 	default="">

<cfset LvarSlash = CreateObject("java","java.lang.System").getProperty("file.separator")>

<cfset LvarDirCur=GetDirectoryFromPath(GetCurrentTemplatePath())>
<cfset LvarYYYYMMDD=DateFormat(now(),"YYYYMMDD") & LvarSlash>
<cfset LvarDirHoy=LvarDirCur & LvarYYYYMMDD>
<cfif NOT DirectoryExists(LvarDirHoy)>
	<cfdirectory action="create" directory="#LvarDirHoy#">
</cfif>

<cfif url.tipo EQ "D">
	<cfif NOT isnumeric(url.AnexoId)>
		<cf_errorCode	code = "50146" msg = "AnexoId incorrecto">
	</cfif>
	<cfset LvarDir = LvarDirHoy & "AD#url.AnexoId#" & LvarSlash>
	<cfset LvarName=LvarYYYYMMDD & "AD#url.AnexoId#" & LvarSlash & "anexoDiseno.htm">
	<cfquery name="rsDownload" datasource="#session.dsn#">
		select 
				coalesce(<cf_dbfunction name="length" args="AnexoDef">, 0) as XML,
				coalesce(<cf_dbfunction name="length" args="AnexoZIP">, 0) as ZIP,
				coalesce(<cf_dbfunction name="length" args="AnexoXLS">, 0) as XLS
		  from Anexoim
		 where AnexoId = #url.AnexoId#
	</cfquery>
	<cfif rsDownload.ZIP EQ 0>
		<cfset LvarAccion = 'utilice la opción <span style="background-color: ##D0D0D0; color:##000000; font-size:17px">&nbsp;Cargar con SOINanexos&nbsp;</span> para crear el anexo'>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select AnexoZIP as ZIP
			  from Anexoim
			 where AnexoId = #url.AnexoId#
		</cfquery>
	</cfif>
<cfelseif url.tipo EQ "C">
	<cfif url.ACid EQ "">
		<cfoutput>
		<table style="height:100%; width:100%; vertical-align:middle; text-align:center;"><tr>
		<td>
			<font style="color:##0000FF; font-family:Arial, Helvetica, sans-serif; font-size:18px;">
				<cfoutput>#LB_Mensaje#</cfoutput>
			</font>
		</td></tr></table>
		<script language="javascript">
			parent.document.getElementById("Descargar").disabled = true;
			parent.document.getElementById("Maximizar").disabled = true;
		</script>	
		</cfoutput>
		<cfabort>
	<cfelseif NOT isnumeric(url.ACid)>
		<cf_errorCode	code = "50147" msg = "ACid incorrecto">
	</cfif>
	<cfset LvarDir=LvarDirHoy & "AC#url.ACid#" & LvarSlash>
	<cfset LvarName=LvarYYYYMMDD & "AC#url.ACid#" & LvarSlash & "anexoCalculado.htm">
	<cfquery name="rsDownload" datasource="#session.dsn#">
		select 
			
			coalesce(<cf_dbfunction name="length" args="ACxml">, 0) as XML,
			coalesce(<cf_dbfunction name="length" args="ACzip">, 0) as ZIP,
			coalesce(<cf_dbfunction name="length" args="ACxls">, 0) as XLS
		  from AnexoCalculo
		 where ACid = #url.ACid#
	</cfquery>
	<cfif rsDownload.ZIP EQ 0>
		<cfset LvarAccion = 'utilice la opción <span style="background-color: ##D0D0D0; color:##000000; font-size:17px">&nbsp;Repetir Cálculo...&nbsp;</span> para calcular el Anexo'>
	<cfelse>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select ACzip as zip 
			  from AnexoCalculo
			 where ACid = #url.ACid#
		</cfquery>
	</cfif>
<cfelse>
	<cf_errorCode	code = "50148" msg = "Tipo consulta incorrecto">
</cfif>

<cfif rsDownload.XML + rsDownload.ZIP + rsDownload.XLS EQ 0>
	<cfoutput>
	<table style="height:100%; width:100%; vertical-align:middle; text-align:center;"><tr>
	<td>
		<font style="color:##0000FF; font-family:Arial, Helvetica, sans-serif; font-size:18px;">
			No se ha creado el Anexo:<BR><BR>
			#LvarAccion#			
		</font>
	</td></tr></table>
	<cfif url.tipo EQ "C">
		<script language="javascript">
			parent.document.getElementById("Descargar").disabled = true;
			parent.document.getElementById("Maximizar").disabled = true;
		</script>	
	</cfif>
	</cfoutput>
<cfelseif rsDownload.ZIP EQ 0>
	<cfoutput>
	<table style="height:100%; width:100%; vertical-align:middle; text-align:center;"><tr>
	<td>
		<font style="color:##0000FF; font-family:Arial, Helvetica, sans-serif; font-size:18px;">
			No existe la Imagen del Anexo:<BR><BR>
			utilice la opción <span style="background-color: ##D0D0D0; color:##000000; font-size:17px">&nbsp;Descargar Anexo&nbsp;</span> para visualizarlo desde Excel<BR><BR>
			#LvarAccion#			
		</font>
	</td></tr></table>
	<cfif url.tipo EQ "C">
		<script language="javascript">
			parent.document.getElementById("Maximizar").disabled = true;
		</script>	
	</cfif>
	</cfoutput>
<cfelse>
	<cfif NOT DirectoryExists(LvarDir)>
		<cfdirectory action="create" directory="#LvarDir#">
		<cfset LvarZipFile = LvarDir & "Anexo.zip">
		<cffile file="#LvarZipFile#" action="write" output="#rsSQL.zip#">
		<cfset fnUnZip(LvarZipFile,LvarDir)>
	</cfif>
	<cfset LvarName=replace(LvarName,"\","/","ALL")>
	<cflocation url="#LvarName#?ms=#getTickCount()#">
</cfif>

<cfscript>
   function fnUnZip(LprmZipFile, LprmOutputPath)
   {
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
    }
</cfscript>