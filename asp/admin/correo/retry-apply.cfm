<cfquery datasource="asp" name="deleted">
	select SMTPcreado, SMTPdestinatario, SMTPasunto
	from SMTPQueue
	where SMTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
</cfquery>

<cfquery datasource="asp" name="lista">
	select SMTPid from SMTPQueue
	<cfif abs(sort) is 1>
		order by SMTPcreado
	<cfelseif abs(sort) is 2>
		order by upper(SMTPdestinatario)
	<cfelseif abs(sort) is 3>
		order by upper(SMTPasunto)
	</cfif>
	<cfif sort lt 0> desc </cfif>
</cfquery>

<!--- buscar el siguiente elemento en la lista --->
<cfset MaxRows_lista=16>
<cfset StartRow_lista=Min((PageNum_lista-1)*MaxRows_lista+1,Max(lista.RecordCount,1))>

<cfset usenext=false>
<cfset nextvalue="">
<cfloop query="lista" startRow="#StartRow_lista#">
	<cfif usenext><cfset nextvalue=SMTPid><cfbreak></cfif>
	<cfif SMTPid is id><cfset usenext=true></cfif>
</cfloop>
<cfif len(nextvalue)eq 0><cfset nextvalue = lista.SMTPid></cfif>

<!--- borrar anterior y seguir --->
<cfinvoke component="SMTPQueue" method="enviar" returnvariable="mail_status">
	<cfinvokeargument name="id" value="#url.id#">
</cfinvoke>
<cfoutput>status: #mail_status#</cfoutput>

<cfif mail_status>
<cflocation url="index.cfm?PageNum_lista=#url.PageNum_lista#&sort=#url.sort#&id=#nextvalue#&retry_status=#mail_status#">
<cfelse>
<cfset Error_Message = Replace(Replace(Request.SMTPQueue_error,Chr(13),' ','all'),Chr(10),' ','all')>
<cflocation url="index.cfm?PageNum_lista=#url.PageNum_lista#&sort=#url.sort#&id=#url.id#&retry_status=#mail_status#&retry_error=#URLEncodedFormat(Error_Message)#">
</cfif>
