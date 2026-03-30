<cf_templateheader title="Mantenimiento de Etapa de una obra">
	<cf_web_portlet_start titulo="Mantenimiento de Etapa de una obra">

		<cf_navegacion name="OBEid" default="" navegacion="">

		<table width="100%" align="center">
			<tr>
			<cfif false>
				<td width="48%" valign="top">
					<cfinclude template="OBetapa_list.cfm">
				</td>
				<td width="4%">&nbsp;</td>
				<td width="48%" valign="top">
					<cfinclude template="OBetapa_form.cfm">
				</td>
			<cfelse>
				<td align="center">
				<cfif form.OBEid EQ '' AND  NOT isdefined("btnNuevo")>
					<cfinclude template="OBetapa_list.cfm">
				<cfelse>
					<cfinclude template="OBetapa_form.cfm">
				</cfif>
				</td>
			</cfif>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

