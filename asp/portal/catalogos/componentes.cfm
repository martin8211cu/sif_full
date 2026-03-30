<cfif isDefined("url.fSScodigo")>
	<cfset form.fSScodigo = url.SScodigo></cfif>
<cfif isDefined("url.fSMcodigo")>
	<cfset form.fSMcodigo = url.fSMcodigo></cfif>
<cfif isDefined("url.SScodigo")>
	<cfset form.SScodigo = url.SScodigo></cfif>
<cfif isDefined("url.SMcodigo")>
	<cfset form.SMcodigo = url.SMcodigo></cfif>
<cfif isDefined("url.SMcodigo")>
	<cfset form.SPcodigo = url.SPcodigo></cfif>
<cfif isDefined("url.SCuri")>
	<cfset form.SCuri = url.SCuri></cfif>
<cf_templateheader title="Mantenimiento de Componentes">
<cf_web_portlet_start titulo="Mantenimiento de Componentes">

		<cfinclude template="frame-header.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr><td colspan="2"><cfinclude template="/home/menu/pNavegacion.cfm"></td></tr>	
		  <tr>
			<td valign="top" align="center">
				<cfinclude template="componentes-form.cfm">
			</td>
		  </tr>
		</table>

<cf_web_portlet_end>
<cf_templatefooter>