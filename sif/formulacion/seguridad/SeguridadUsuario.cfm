<cfif isdefined("url.CFid") and len(trim(url.CFid))><cfset form.CFid = url.CFid></cfif>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cf_templateheader title="Seguridad por Centros Funcionales">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Seguridad por Centros Funcionales">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="40%" valign="top">
				<cfinclude template="SeguridadUsuario-Arbol.cfm">
			</td>
			<td width="60%" valign="top">
				<cfif isdefined("form.CFid")>
					<cfinclude template="SeguridadUsuario-Form.cfm">
				<cfelse>
					<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0"><tr>
						<td><fieldset><legend>Centro Funcional</legend>
						<div style="overflow:auto;">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="areafiltro"><tr>
								<td>Seleccione un Centro Funcional, para modificar la seguridad.&nbsp;</td>
							</tr></table>
						</div></fieldset></td>
					</tr></table>
				</cfif>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>