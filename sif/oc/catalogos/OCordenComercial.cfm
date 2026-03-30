<cf_templateheader title="Mantenimiento de Orden Comercial">
	<cf_web_portlet_start titulo="Mantenimiento de Orden Comercial">

		<cf_navegacion name="OCid" default="" navegacion="">

		<table width="100%" align="center">
			<tr>
			<cfif false>
				<td width="48%" valign="top">
					<cfinclude template="OCordenComercial_list.cfm">
				</td>
				<td width="4%">&nbsp;</td>
				<td width="48%" valign="top">
					<cfinclude template="OCordenComercial_form.cfm">
				</td>
			<cfelse>
				<td align="center">
				<cfif form.OCid EQ '' AND NOT isdefined("btnNuevo")>
					<cfinclude template="OCordenComercial_list.cfm">
				<cfelse>
					<cfinclude template="OCordenComercial_form.cfm">
				</cfif>
				</td>
			</cfif>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

