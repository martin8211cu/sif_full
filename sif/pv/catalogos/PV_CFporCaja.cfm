<cfset modo="alta">
<cfif not isdefined('form.PVCajaCFid') and isdefined('url.PVCajaCFid')>
	<cfset form.PVCajaCFid = url.PVCajaCFid>
</cfif>
<cfif isdefined('form.PVCajaCFid')>
	<cfset modo = "cambio">
</cfif>
<cf_templateheader title="Punto de Venta - Centro funcionales por caja">
	<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Autorización de Centros Funcionales por Caja">
			<table width="100%" align="center" cellpadding="0" border="0" cellspacing="0">
				<tr valign="top">
					<td width="55%">
					 	<cfinclude template="PV_CFporCaja-lista.cfm">
				  </td>
					<td width="45%">
						<cfinclude template="PV_CFporCaja-form.cfm">
				  </td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>		
