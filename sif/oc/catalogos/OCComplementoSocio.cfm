<cf_templateheader title="Complemento Socio de Negocios">
	<cf_web_portlet_start titulo="Complemento Socio de Negocios">
		<cf_navegacion name="SNid" default="" navegacion="">
		<cf_navegacion name="TieneComplemento" default="" navegacion="">

		<table width="100%" align="center">
			<tr>
			<cfif false>
				<td width="48%" valign="top">
					<cfinclude template="OCComplementoSocio_list.cfm">
				</td>
				<td width="4%">&nbsp;</td>
				<td width="48%" valign="top">
					<cfinclude template="OCComplementoSocio_form.cfm">
				</td>
			<cfelse>
				<td align="center">
				<cfif form.SNid EQ ''>
					<cfinclude template="OCComplementoSocio_list.cfm">
				<cfelse>
					<cfinclude template="OCComplementoSocio_form.cfm">
				</cfif>
				</td>
			</cfif>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

