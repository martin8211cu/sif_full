<cfif isdefined("url._")>
	<cfset session.Obras.OBD.OBTPid	= "">
	<cfset session.Obras.OBD.OBPid	= "">
	<cfset session.Obras.OBD.OBOid	= "">
	<cfset session.Obras.OBD.OBEid	= "">
<cfelseif isdefined("url.OBD")>
	<cfset session.Obras.OBD.OBTPid	= url.OBTPid>
	<cfset session.Obras.OBD.OBPid	= url.OBPid>
	<cfset session.Obras.OBD.OBOid	= url.OBOid>
	<cfset session.Obras.OBD.OBEid	= url.OBEid>
</cfif>

<cf_navegacion name="OBTPid" 	default="#session.Obras.OBD.OBTPid#"	navegacion="">
<cf_navegacion name="OBPid" 	default="#session.Obras.OBD.OBPid#" 	navegacion="">
<cf_navegacion name="OBOid" 	default="#session.Obras.OBD.OBOid#" 	navegacion="">
<cf_navegacion name="OBEid" 	default="#session.Obras.OBD.OBEid#" 	navegacion="">

<cfset LvarTODO = 	session.Obras.OBD.OBTPid EQ "" 	AND session.Obras.OBD.OBPid EQ "" AND
					session.Obras.OBD.OBOid EQ ""	AND session.Obras.OBD.OBEid EQ ""
>

<cfif LvarTODO>
<cf_templateheader title="Mantenimiento a Documentación de Soporte">
<cfelse>
<cf_onEnterKey>
</cfif>
	<cf_web_portlet_start titulo="Mantenimiento a Documentación de Soporte">

		<cf_navegacion name="OBDid" default="" navegacion="">
		<table width="100%" align="center">
			<tr>
			<cfif LvarTODO>
				<td width="48%" valign="top">
					<cfinclude template="OBdocumentacion_list.cfm">
				</td>
				<td width="4%">&nbsp;</td>
				<td width="48%" valign="top">
					<cfinclude template="OBdocumentacion_form.cfm">
				</td>
			<cfelse>
				<td align="center">
				<cfif form.OBDid EQ '' AND  NOT isdefined("btnNuevo")>
					<cfinclude template="OBdocumentacion_list.cfm">
				<cfelse>
					<cfinclude template="OBdocumentacion_form.cfm">
				</cfif>
				</td>
			</cfif>
			</tr>
		</table>
<cfif LvarTODO>
	<cf_web_portlet_end>
<cf_templatefooter>
</cfif>
