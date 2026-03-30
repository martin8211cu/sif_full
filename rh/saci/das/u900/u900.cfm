<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td width="70%" valign="top">
			<cf_web_portlet_start titulo="#nav__SPdescripcion#">
				<cfinclude template="u900-params.cfm">
				<cfif form.paso EQ 1>			<!--- Bloquear --->
					<cfinclude template="u900-form.cfm">
				<cfelseif form.paso EQ 2>		<!--- Desbloquear --->
					<cfinclude template="u900-desbloqueo.cfm">
				<cfelseif form.paso EQ 3>		<!--- Limitar Acceso --->
					<cfinclude template="u900-limitacionAcceso.cfm">
				<cfelseif form.paso EQ 4>		<!--- Bloqueo Masivo --->
					<cfinclude template="u900-bloqueoMasivo-form.cfm">					
				</cfif>
			<cf_web_portlet_end> 
		</td>
		<td align="center" valign="top" width="30%">
			<cfinclude template="U900-menu.cfm">
		</td>
	  </tr>
	</table>
<cf_templatefooter>