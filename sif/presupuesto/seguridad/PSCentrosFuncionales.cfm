<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfif isdefined("url.CFpk") and len(trim(url.CFpk))><cfset form.CFpk = url.CFpk></cfif>
<cf_templateheader title="Seguridad por Centros Funcionales">
	<cfoutput>#pNavegacion#</cfoutput>
    <cf_web_portlet_start titulo="Seguridad por Centros Funcionales">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="30%" valign="top">
				<cfinclude template="PSCentrosFuncionalesArbol.cfm">
			</td>
			<td width="70%" valign="top">
				<cfif isdefined("form.CFpk")>
					<cfinclude template="PSCentrosFuncionalesForm.cfm">
				<cfelse>
					<br><table width="98%" align="center" border="0" cellspacing="0" cellpadding="0"><tr><td><fieldset><legend>Centro Funcional</legend><div style="overflow:auto; height: 357; margin:0;" ><table width="100%"  border="0" cellspacing="0" cellpadding="0" class="areafiltro"><tr><td>Seleccione un Centro Funcional, para modificar la seguridad.&nbsp;</td></tr></table></div></fieldset></td></tr></table><br>
				</cfif>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>