<cf_templateheader title="Complemento Art&iacute;culos">
	<cf_web_portlet_start titulo="Complemento Art&iacute;culos">
		<cf_navegacion name="Aid" default="" navegacion="">
		<cf_navegacion name="TieneComplemento" default="" navegacion="">

		<table width="100%" align="center">
			<tr>
			<cfif false>
				<td width="48%" valign="top">
					<cfinclude template="OCComplementoArticulo_list.cfm">
				</td>
				<td width="4%">&nbsp;</td>
				<td width="48%" valign="top">
					<cfinclude template="OCComplementoArticulo_form.cfm">
				</td>
			<cfelse>
				<td align="center">
				<cfif form.Aid EQ ''>
					<cfinclude template="OCComplementoArticulo_list.cfm">
				<cfelse>
					<cfinclude template="OCComplementoArticulo_form.cfm">
				</cfif>
				</td>
			</cfif>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

