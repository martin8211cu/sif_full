<cfif isdefined("url.id") and Len(url.id) eq 0><cfset url.id=0></cfif>
<cfparam name="url.id" default="0" type="numeric">
<cfif IsDefined('url.nom') And Len('url.nom')>
	<cfquery datasource="asp" name="attach">
		select SMTPcontenido, SMTPmime, SMTPlocalURL
		from SMTPAttachment
		where SMTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
		  and SMTPnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.nom#">
	</cfquery>
	<cfif Len(attach.SMTPlocalURL)>
		<cfcontent type="#attach.SMTPmime#" file="#ExpandPath( attach.SMTPlocalURL )#" deletefile="no" reset="yes">
	<cfelseif Len(attach.SMTPcontenido)>
		<cfcontent type="#attach.SMTPmime#" variable="#attach.SMTPcontenido#">
	<cfelse>
	Attachment Not Found
	<cfheader statuscode="404" statustext="Attachment Not Found">
	</cfif>
	<cfabort>
</cfif><cf_templateheader title="Correos sin enviar"><cf_web_portlet_start titulo="Correos sin enviar">
<cfinclude template="/home/menu/pNavegacion.cfm">
<table width="903" height="352">
  <tr><td width="377" valign="top" align="left">
<cfinclude template="correo-lista.cfm">

</td><td width="514" valign="top" align="left">
<cfif url.id neq 0>
<cfinclude template="correo-form.cfm">
</cfif>
</td></tr></table>

<cf_web_portlet_end>
<cf_templatefooter>
