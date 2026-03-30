<!--- Variables de Sesin utilizadas por educ --->
<cfif isdefined("Url.Ayuda")>
	<cfset Session.Ayuda = Url.Ayuda>
<cfelseif isdefined("Form.Ayuda")>
	<cfset Session.Ayuda = Form.Ayuda>
</cfif>
<cfif isdefined("Url.RegresarURL") and Len(Trim(Url.RegresarURL)) NEQ 0>
	<cfset Session.Edu.RegresarUrl = Url.RegresarURL>
<cfelseif isdefined("Form.RegresarURL") and Len(Trim(Form.RegresarURL)) NEQ 0>
	<cfset Session.Edu.RegresarUrl = Form.RegresarURL>
<cfelseif not isdefined("Session.Edu.RegresarUrl")>
	<cfset Session.Edu.RegresarUrl = "">
</cfif>
