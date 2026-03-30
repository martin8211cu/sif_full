<cfquery datasource="asp">
	update SMTPQueue
	set SMTPdestinatario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,
      	SMTPcc = <cfqueryparam cfsqltype="cf_sql_varchar" 			value="#form.emailcc#">,
        SMTPbcc = <cfqueryparam cfsqltype="cf_sql_varchar" 			value="#form.emailbcc#">
	where SMTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id#">
</cfquery>
<cfset url.PageNum_lista = form.PageNum_lista>
<cfset url.sort = form.sort>
<cfset url.id = form.id>

<cfinclude template="retry-apply.cfm">
