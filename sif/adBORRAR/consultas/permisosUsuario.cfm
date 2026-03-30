<cf_templateheader title="Permisos por Usuario">
		<table width="100%" cellpadding="0" cellspacing="0" style="vertical-align:bottom; ">
			<tr>
				<td valign="top">
					<cfset params = '' >
					<cfif isdefined("url.opcion") and not isdefined("form.opcion") >
						<cfset form.opcion = url.opcion >
					</cfif>
					<cfif isdefined("url.SScodigo") and not isdefined("form.SScodigo") >
						<cfset form.SScodigo = url.SScodigo >
					</cfif>
					<cfif isdefined("url.empresa") and not isdefined("form.empresa") >
						<cfset form.empresa = url.empresa >
					</cfif>
					<cfif isdefined("form.empresa") and len(trim(form.empresa))>
						<cfset params = params & "&empresa=#form.empresa#">
					</cfif>
					<cfset params = params & "&opcion=#form.opcion#">
					<cfset params = params & "&SScodigo=#form.SScodigo#">
					
					<cfif form.opcion eq 'rol'>
						<cfif isdefined("url.SRcodigo") and not isdefined("form.SRcodigo") >
							<cfset form.SRcodigo = url.SRcodigo >
						</cfif>
						<cfif isdefined("form.SRcodigo") and len(trim(form.SRcodigo))>
							<cfset params = params & "&SRcodigo=#form.SRcodigo#">
						</cfif>
					<cfelse>
						<cfset form.opcion = 'sistema' >
						<cfif isdefined("url.SMcodigo") and not isdefined("form.SMcodigo") >
							<cfset form.SMcodigo = url.SMcodigo >
						</cfif>
						<cfif isdefined("url.SPcodigo") and not isdefined("form.SPcodigo") >
							<cfset form.SPcodigo = url.SPcodigo >
						</cfif>
						
						<cfif isdefined("form.SMcodigo") and len(trim(form.SMcodigo))>
							<cfset params = params & "&SMcodigo=#form.SMcodigo#">
						</cfif>
						<cfif isdefined("form.SPcodigo") and len(trim(form.SPcodigo))>
							<cfset params = params & "&SPcodigo=#form.SPcodigo#">
						</cfif>
					</cfif>

					<cf_web_portlet_start border="true" titulo="Usuarios por Permiso">
					<cfinclude template="../../portlets/pNavegacion.cfm">
					<!--- <cf_rhimprime datos="/sif/ad/consultas/permisosUsuario-form.cfm" paramsuri="#params#" > --->
                    <cf_htmlreportsheaders
                        title="Permisos" 
                        filename="Permisos#session.Usulogin##LSDateFormat(now(),'yyyymmdd')#.xls" 
                        ira="permisosUsuario-filtro.cfm">
					<cfinclude template="permisosUsuario-form.cfm">
					<cf_web_portlet_end>		
				</td>
			</tr>
		</table>
<cf_templatefooter>	