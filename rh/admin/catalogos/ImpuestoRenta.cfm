<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
		<cfif isdefined("url.IRcodigo") and len(trim(url.IRcodigo))>
			<cfset form.IRcodigo = url.IRcodigo>
		</cfif>
		<cfoutput>#pNavegacion#</cfoutput>
		<br>
		<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="40%" valign="top">
				<cfinclude template="ImpuestoRenta-Arbol.cfm">
			</td>
			<td width="60%" valign="top">
				<cfinclude template="formImpuestoRenta.cfm">
			</td>
		  </tr>
		</table>
		<br>
	<cf_web_portlet_end>
<cf_templatefooter>