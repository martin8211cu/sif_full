<cfcomponent displayname="Correo">

<cfset AttachmentsDirectory = GetTempDirectory() & 'attachments/'>
<cfif Not DirectoryExists (AttachmentsDirectory)>
	<cfdirectory action="create" directory="#AttachmentsDirectory#">
</cfif>
<cffunction name="enviar" access="public" returntype="boolean">
	<cfargument name="id" type="numeric" required="yes">
	
	<cfset Request.SMTPQueue_error = "">
	
	<cfquery datasource="asp" name="msg">
		select SMTPhtml, SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPcreado, SMTPtexto, SMTPcc, SMTPbcc
		from SMTPQueue
		where SMTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
	</cfquery>
	
	<cfquery datasource="asp" name="attach">
		select SMTPnombre, SMTPmime, SMTPcontentid, SMTPcontenido, SMTPlocalURL
		from SMTPAttachment
		where SMTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
	</cfquery>
	
	<cfset mailtype = "text/plain">
	<cfif msg.SMTPhtml><cfset mailtype = "text/html"></cfif>
	<cftry>
		<cfif Len(Trim(msg.SMTPremitente)) EQ 0 or Trim(msg.SMTPremitente) EQ 'gestion@soin.co.cr'>
			<cfinvoke component="home.Componentes.Politicas"
				method="trae_parametro_global"
				parametro="correo.cuenta"
				returnvariable="remitente"/>
		<cfelse>
			<cfset remitente = msg.SMTPremitente>
		</cfif>
		<cfmail from="#remitente#" to="#msg.SMTPdestinatario#"
			subject="#msg.SMTPasunto#"
			cc="#msg.SMTPcc#" bcc="#msg.SMTPbcc#" type="#mailtype#" spoolEnable="no">
			#msg.SMTPtexto#
			<cfloop query="attach">
				<cfif Len(Trim(attach.SMTPlocalURL))>
					<cfif FileExists(attach.SMTPlocalURL)>
						<cfset AttachedFilename = attach.SMTPlocalURL>
					<cfelse>
						<cfset AttachedFilename = ExpandPath(attach.SMTPlocalURL)>
					</cfif>
				<cfelse>
					<cfset AttachedFilename = AttachmentsDirectory & attach.SMTPnombre>
					<cffile action="write" file="#AttachedFilename#" output="#attach.SMTPcontenido#">
				</cfif>
				<cfif Len(Trim(attach.SMTPcontentid))>
					<cfmailparam file="#AttachedFilename#" type="#attach.SMTPmime#" contentid="#attach.SMTPcontentid#">
				<cfelse>
					<cfmailparam file="#AttachedFilename#" type="#attach.SMTPmime#">
				</cfif>
			</cfloop>
			<cfmailparam name="SMTPid" value="#arguments.id#; creado #DateFormat(msg.SMTPcreado,'dd/mm/yy')# #TimeFormat(msg.SMTPcreado,'HH:mm:ss')#">
		</cfmail>
		<cfloop query="attach">
				<cfif Len(Trim(attach.SMTPlocalURL)) EQ 0>
					<cffile action="delete" file="#AttachmentsDirectory##attach.SMTPnombre#">
				</cfif>
		</cfloop>

		<cfquery datasource="asp">
			delete from SMTPAttachment
			where SMTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
		</cfquery>
		<cfquery datasource="asp">
			delete from SMTPQueue
			where SMTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
		</cfquery>
		<cfreturn true>
		<cfcatch type="any">
			<cflog file="SMTPQueue" text="#cfcatch.Message# #cfcatch.Detail#">
			<cfset Request.SMTPQueue_error = cfcatch.Message & " " & cfcatch.Detail>
		</cfcatch>
	</cftry>
	<cfquery datasource="asp">
		update SMTPQueue
		set SMTPintentos = SMTPintentos + 1,
		  SMTPenviado = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		where SMTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
	</cfquery>
	<cfreturn false>
	
</cffunction>

<cffunction name="lote" access="public" returntype="numeric">
	<cfargument name="maxmsgs" type="numeric" default="50">
	
	<!---
		reintentar un mensaje a los 1,8,27,64,125,216,343,512,729,1000 minutos (x^3)
		1000 minutos = aprox. 16 horas
	 --->
	<cfset var msgs = 0>
	
	<!--- 
		Se pone cflock el 13/03/2004 porque por algún motivo parece que la tarea corre mas de 1 vez en el mismo
		instante y está envíando 2 veces los correos. Con cflock, la tarea 2 se espera a que la tarea 1 termine y 
		cuando corre ya el correo enviado por la 1 no se encuentra por lo que no lo encuentra.
	--->
	<cflock timeout="1" throwontimeout="no">
	
	<cfquery datasource="asp" name="ids" maxrows="#maxmsgs#">
		select SMTPid
		from SMTPQueue
		where (SMTPenviado is null
		    or SMTPintentos <= 10)
		order by SMTPintentos asc, SMTPcreado asc
	</cfquery>
	
	<cflog file="SMTPQueue2" text="Hora: #now()#. Mensajes: #ids.recordcount#">
	
	<cfloop query="ids">
		<cfif This.enviar(ids.SMTPid)><cfset msgs = msgs + 1></cfif>
	</cfloop>
	
	</cflock>
	<cfreturn msgs>
</cffunction>

    <cffunction  name="createEmail">
        <cfargument  name="from"            type="string" required="true">
        <cfargument  name="to"              type="string" required="true">
        <cfargument  name="subject"         type="string" required="true">

        <cfargument  name="cc"              type="string" required="false"  default="">
        <cfargument  name="bcc"             type="string" required="false"  default="">
        <cfargument  name="body"     		type="string" required="false"  default="">
        <cfargument  name="contentPath"     type="string" required="false"  default="">
        <cfargument  name="type"            type="string" required="false"  default="html">
        <cfargument  name="attachmentPath"  type="string" required="false"  default="">
        <cfargument  name="attachmentExt"   type="string" required="false"  default="">

        <cfargument  name="send"            type="boolean" required="false"  default="false">

        <cfset SMTPhtml = "1">
        <cfif arguments.type neq 'html'> <cfset SMTPhtml = "0"> </cfif>

        <cfswitch expression="#Trim(arguments.attachmentExt)#">  
            <cfcase value="pdf">    <cfset SMTPmime = "application/pdf"> </cfcase> 
            <cfcase value="csv">    <cfset SMTPmime = "text/csv"> </cfcase> 
            <cfcase value="doc">    <cfset SMTPmime = "application/msword"> </cfcase> 
            <cfcase value="gif">    <cfset SMTPmime = "image/gif"> </cfcase> 
            <cfcase value="html">   <cfset SMTPmime = "text/html"> </cfcase> 
            <cfcase value="ics">    <cfset SMTPmime = "text/calendar"> </cfcase> 
            <cfcase value="jpeg">   <cfset SMTPmime = "image/jpeg"> </cfcase> 
            <cfcase value="jpg">    <cfset SMTPmime = "image/jpeg"> </cfcase> 
            <cfcase value="json">   <cfset SMTPmime = "application/json"> </cfcase> 
            <cfcase value="odp">    <cfset SMTPmime = "application/vnd.oasis.opendocument.presentation"> </cfcase> 
            <cfcase value="odt">    <cfset SMTPmime = "application/vnd.oasis.opendocument.text"> </cfcase> 
            <cfcase value="ppt">    <cfset SMTPmime = "application/vnd.ms-powerpoint"> </cfcase> 
            <cfcase value="rar">    <cfset SMTPmime = "application/x-rar-compressed"> </cfcase> 
            <cfcase value="rtf">    <cfset SMTPmime = "application/rtf"> </cfcase> 
            <cfcase value="svg">    <cfset SMTPmime = "image/svg+xml"> </cfcase> 
            <cfcase value="swf">    <cfset SMTPmime = "application/x-shockwave-flash"> </cfcase> 
            <cfcase value="tar">    <cfset SMTPmime = "application/x-tar"> </cfcase> 
            <cfcase value="tiff">   <cfset SMTPmime = "image/tiff"> </cfcase> 
            <cfcase value="tif">    <cfset SMTPmime = "image/tiff"> </cfcase> 
            <cfcase value="xls">    <cfset SMTPmime = "application/vnd.ms-excel"> </cfcase> 
            <cfcase value="xml">    <cfset SMTPmime = "application/xml"> </cfcase> 
            <cfcase value="zip">    <cfset SMTPmime = "application/zip"> </cfcase> 
            <cfcase value="7z">     <cfset SMTPmime = "application/x-7z-compressed"> </cfcase> 
            <cfdefaultcase>         <cfset SMTPmime = "text/plain"></cfdefaultcase>  
        </cfswitch>  

        <cfset content = arguments.body>
        <cfif arguments.contentPath neq ''>
            <cfsavecontent variable = "content"> 
                <cfinclude template="#arguments.contentPath#">
            </cfsavecontent>
        </cfif>

        <cftransaction>
            <cfquery datasource="asp" name="msg">
                insert into SMTPQueue (
                        SMTPremitente
                        , SMTPdestinatario
                        , SMTPasunto
                        , SMTPtexto
                        , SMTPcreado
                        , SMTPhtml
                        , SMTPcc
                        , SMTPbcc
                    ) values(
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.from#">
                        , <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.to#">
                        , <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subject#">
                        , <cfqueryparam cfsqltype="cf_sql_varchar" value="#content#">
                        , <cfqueryparam cfsqltype="cf_sql_date" value="#DateTimeFormat(Now(),'yyyy-mm-dd hh:nn:ss')#">
                        , <cfqueryparam cfsqltype="cf_sql_numeric" value="#SMTPhtml#">
                        , <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cc#">
                        , <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bcc#">
                    );
                <cf_dbidentity1 datasource="asp">
            </cfquery>
            <cf_dbidentity2 datasource="asp" name="msg" returnvariable="msg_id">

            <cfif arguments.attachmentPath neq ''>
                <cfset SMTPnombre = listToArray(attachmentPath,'\',false,false)>
                <cfset SMTPnombre = SMTPnombre[arrayLen(SMTPnombre)]>
                <cfquery datasource="asp" name="msg">
                    insert into SMTPAttachment(
                            SMTPid
                            , SMTPmime
                            , SMTPlocalURL
                            , SMTPnombre
                        ) values (
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#msg_id#">
                            , <cfqueryparam cfsqltype="cf_sql_varchar" value="#SMTPmime#">
                            , <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.attachmentPath#">
                            , <cfqueryparam cfsqltype="cf_sql_varchar" value="#SMTPnombre#">
                        );
                </cfquery>
            </cfif>
        </cftransaction>
        <cfif arguments.send>
            <cfset send = This.enviar(msg_id)>
        </cfif>
    </cffunction>

</cfcomponent>
