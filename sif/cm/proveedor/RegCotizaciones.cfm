<cf_templateheader title="	Registro de Cotizaciones">
			<cfif isdefined("Url.PCPid") and not isdefined("Form.PCPid")>
				<cfset Form.PCPid = Url.PCPid>
			</cfif>
	
			<cf_web_portlet_start titulo="Registro de Cotizaciones">
				<table align="center" width="98%">
				<tr><td>
					<cfinclude template="pNavegacion.cfm">
				</td></tr>
				<cfif isdefined("Form.PCPid") and Len(Trim(Form.PCPid))>
					<tr><td><cfinclude template="RegCotizaciones-Cotizar.cfm"></td></tr>
				<cfelse>
					<tr><td><cfinclude template="RegCotizaciones-form.cfm"></td></tr>
				</cfif>
				</table>
			<cf_web_portlet_end>
	<cf_templatefooter>
