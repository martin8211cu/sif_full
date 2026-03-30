<cf_templateheader title="Mantenimiento de Obra">
	<cf_web_portlet_start titulo="Mantenimiento de Obra">

		<cf_navegacion name="OBOid" default="" navegacion="">
		<cf_navegacion name="OP" 	default="" navegacion="">
		<cfif isdefined("NuevoObra")>
			<cfset form.OBOid = "">
		</cfif>

		<table width="100%" align="center">
			<tr>
				<td align="center">
					<cfset LvarConsulta = true>
					<cfinclude template="../catalogos/OBobra_list.cfm"> 
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

