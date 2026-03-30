<cf_templateheader title="Mantenimiento de Grupo de Objetos de Gasto">
	<cf_web_portlet_start titulo="Mantenimiento de Grupo de Objetos de Gasto">

		<cf_navegacion name="OBGid" default="" navegacion="">

		<table width="100%" align="center">
			<tr>
			<cfif false>
				<td width="48%" valign="top">
					<cfinclude template="OBgrupoOG_list.cfm">
				</td>
				<td width="4%">&nbsp;</td>
				<td width="48%" valign="top">
					<cfinclude template="OBgrupoOG_form.cfm">
				</td>
			<cfelse>
				<td align="center">
				<cfif form.OBGid EQ '' AND  NOT isdefined("btnNuevo")>
					<cfinclude template="OBgrupoOG_list.cfm">
				<cfelse>
					<cfinclude template="OBgrupoOG_form.cfm">
				</cfif>
				</td>
			</cfif>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

