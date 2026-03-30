<cfcomponent displayname="Correo">

<cffunction name="enviar" access="public" returntype="boolean">
	<cfargument name="id" type="numeric" required="yes">
	
	<cfset Request.SMTPQueue_error = "">
	
	<cfquery datasource="asp" name="msg">
		select * from SMTPQueue
		where SMTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
	</cfquery>
	
	<cfset mailtype = "text/plain">
	<cfif msg.SMTPhtml><cfset mailtype = "text/html"></cfif>
	<cftry>
		<cfmail from="#msg.SMTPremitente#" to="#msg.SMTPdestinatario#"
			subject="#msg.SMTPasunto#"
			cc="" bcc="" type="#mailtype#" spoolEnable="no">
			#msg.SMTPtexto#
			<cfmailparam name="SMTPid" value="#msg.SMTPid#; creado #DateFormat(msg.SMTPcreado,'dd/mm/yy')# #TimeFormat(msg.SMTPcreado,'HH:mm:ss')#">
		</cfmail>
	
		<cfquery datasource="asp">
			delete SMTPQueue
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
	<cfquery datasource="asp" name="ids" maxrows="#maxmsgs#">
		select SMTPid
		from SMTPQueue
		where (SMTPenviado is null
		    or SMTPintentos <= 10)
		order by SMTPintentos asc, SMTPcreado asc
	</cfquery>
	<cfloop query="ids">
		<cfif This.enviar(ids.SMTPid)><cfset msgs = msgs + 1></cfif>
	</cfloop>
	<cfreturn msgs>
</cffunction>

</cfcomponent>