<cf_templateheader title="Mantenimiento de Tipo Proyecto">
	<cf_web_portlet_start titulo="Mantenimiento de Tipo Proyecto">

		<cf_navegacion name="OBTPid" default="" navegacion="">

		<table width="100%" align="center">
			<tr>
			<cfif false>
				<td width="48%" valign="top">
					<cfinclude template="OBtipoProyecto_list.cfm">
				</td>
				<td width="4%">&nbsp;</td>
				<td width="48%" valign="top">
					<cfinclude template="OBtipoProyecto_form.cfm">
				</td>
			<cfelse>
				<td align="center">
				<cfif form.OBTPid EQ '' AND  NOT isdefined("btnNuevo")>
					<cfinclude template="OBtipoProyecto_list.cfm">
				<cfelse>
					<cfinclude template="OBtipoProyecto_form.cfm">
				</cfif>
				</td>
			</cfif>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

