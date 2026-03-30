<cfset ts =  LSDateFormat(Now(), 'ddmmyyyy') & LSTimeFormat(Now(),'hhmmss')>

<cfif isdefined("Url.PageNum_lista") and not isdefined("Form.PageNum_lista")>
	<cfset Form.PageNum_lista = Url.PageNum_lista>
</cfif>
<cfif isdefined("Url.PageNum") and not isdefined("Form.PageNum")>
	<cfset Form.PageNum = Url.PageNum>
</cfif>
<cfif isdefined("Form.PageNum_lista")>
	<cfset Form.PageNum = Form.PageNum_lista>
</cfif>

<cfset tabNames = ArrayNew(1)>
<cfset tabNames[1] = "Buz&oacute;n de Entrada">
<cfset tabNames[2] = "Nuevo Mensaje">

<cfset tabLinks = ArrayNew(1)>
<cfif isdefined("Form.PageNum")>
	<cfset tabLinks[1] = "index.cfm?o=1&PageNum_lista=" & Form.PageNum & "&a=" & ts>
	<cfset tabLinks[2] = "index.cfm?o=2&PageNum_lista=" & Form.PageNum & "&a=" & ts>
<cfelse>
	<cfset tabLinks[1] = "index.cfm?o=1" & "&a=" & ts>
	<cfset tabLinks[2] = "index.cfm?o=2" & "&a=" & ts>
</cfif>

<cfset tabStatusText = ArrayNew(1)>
<cfset tabStatusText[1] = "">
<cfset tabStatusText[2] = "">
