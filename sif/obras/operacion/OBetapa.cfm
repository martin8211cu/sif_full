<cf_templateheader title="Administrar Etapas de las Obras abiertas">
	<cf_web_portlet_start titulo="Administrar Etapas de las Obras abiertas">

		<cf_navegacion name="OBEid" default="" navegacion="">
		<cf_navegacion name="OBOid" default="" navegacion="">

		<table width="100%" align="center">
			<tr>
				<td width="48%" valign="top">
					<cfinclude template="OBetapa_list.cfm">
				</td>
				<td width="4%">&nbsp;</td>
				<td width="48%" valign="top">
					<cfinclude template="OBetapa_form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

