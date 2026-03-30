<cf_template>
	<cf_templatearea name="title">
			Registro de Feligreses
	</cf_templatearea>
	<cf_templatearea name="left">
		<cfinclude template="../pMenu.cfm">
	</cf_templatearea>
	<cf_templatearea name="body">
		<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">

		<cfif isdefined("Url.empr") and not isdefined("Form.empr")>
			<cfset Form.empr = Url.empr>
		</cfif>
		<cfif isdefined("Form.Iglesia")>
			<cfset Form.empr = Trim(ListGetAt(Form.Iglesia, 2, '|'))>
		</cfif>
		<cfif not isdefined("Form.empr")>
			<cfset Form.empr = session.Ecodigo>
		</cfif>
		
		<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

		<cfif isdefined("Form.btnNuevo")>
			<cfinclude template="afiliacion-form.cfm">
		<cfelseif isdefined("Form.MEpersona") and Len(Trim(Form.MEpersona)) NEQ 0>
			<cfinclude template="afiliacion-form.cfm">
		<cfelse>
			<cfinclude template="afiliacion-lista.cfm">
		</cfif>
	</cf_templatearea>
</cf_template>
