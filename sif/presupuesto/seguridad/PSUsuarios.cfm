<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfif isdefined("url.Usucodigo") and len(trim(url.Usucodigo))>
	<cfset form.Usucodigo = url.Usucodigo>
</cfif>
<cf_templateheader title="Seguridad por Usuario">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="Seguridad por Usuario">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="30%" valign="top">
				<cfinclude template="PSUsuariosLista.cfm">
			</td>
			<td width="70%" valign="top">
				<cfif isdefined("form.Usucodigo")>
					<cfinclude template="PSUsuariosForm.cfm">
				<cfelse>
					<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0"><tr><td><fieldset><legend>Usuario</legend><div style="overflow:auto; height: 357; margin:0;" ><table width="100%"  border="0" cellspacing="0" cellpadding="0" class="areafiltro"><tr><td>Seleccione un Usuario, para modificar la seguridad.&nbsp;</td></tr></table></div></fieldset></td></tr></table><br>
				</cfif>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>