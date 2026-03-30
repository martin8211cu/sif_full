<cf_templateheader title="Activos Fijos">
		<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
		<cfif isdefined("url.Aid") and len(trim(url.Aid))><cfset form.Aid = url.Aid></cfif>
		<cfif isdefined("url.DEid") and len(trim(url.DEid))><cfset form.DEid = url.DEid></cfif>
		<cfif isdefined("form.DEid")>
			<cfinclude template="/sif/portlets/pEmpleado.cfm">
			<cfinclude template="vales_responsale_form.cfm">
		<cfelse>
			<cfif not isdefined("form.Aid")>
				<cfinclude template="vales_responsale_listaalmacen.cfm">
			<cfelse>
				<cfinclude template="vales_responsale_almacen.cfm">
				<cfinclude template="vales_responsale_form.cfm">
			</cfif>
		</cfif>
	<cf_templatefooter>
