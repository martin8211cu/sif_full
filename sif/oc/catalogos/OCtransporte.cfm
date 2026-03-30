<cf_templateheader title="Mantenimiento de Transportes">
	<cf_web_portlet_start titulo="Mantenimiento de Transportes">

		<cf_navegacion name="OCTid" default="" navegacion="">

		<table width="100%" align="center">
			<tr>
			<cfif false>
				<td width="48%" valign="top">
					<cfinclude template="OCtransporte_list.cfm">
				</td>
				<td width="4%">&nbsp;</td>
				<td width="48%" valign="top">
					<cfinclude template="OCtransporte_form.cfm">
				</td>
			<cfelse>
				<td align="center">
				<cfif form.OCTid EQ '' AND NOT isdefined("btnNuevo")>
					<cfinclude template="OCtransporte_list.cfm">
				<cfelse>
					<cfinclude template="OCtransporte_form.cfm">
				</cfif>
				</td>
			</cfif>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

