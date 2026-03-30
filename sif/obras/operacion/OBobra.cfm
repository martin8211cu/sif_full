<cf_templateheader title="Administrar la Obra">
	<cf_web_portlet_start titulo="Administrar la Obra">

		<cf_navegacion name="OBOid" default="" navegacion="">
		<cf_navegacion name="OP" default="" navegacion="">
		<cfif form.OBOid EQ "" OR form.OP EQ "">
			<cfinclude template="OBobra_list.cfm">
		<cfelse>
			<cf_navegacion name="OBOLid" default="" navegacion="">
			<cf_navegacion name="OBEid" default="" navegacion="">
			<cfset LvarAdmObr = true>

			<cfif OBOLid NEQ "" or isdefined("btnNuevo") or isdefined("btnNuevo")>
				<cfinclude template="../liquidacion/OBobraLiquidacion_form.cfm">
			<cfelse>
				<cfinclude template="../liquidacion/OBobraLiquidacion_list.cfm">
			</cfif>
			<table width="100%" align="center">
				<tr>
					<td width="48%" valign="top">
					</td>
					<td width="4%">&nbsp;</td>
					<td width="48%" valign="top">
					</td>
				</tr>
			</table>
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>

