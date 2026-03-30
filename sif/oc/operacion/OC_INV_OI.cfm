<cfset LvarOCItipoOD = "O">
<cfset LvarTitulo = "Movimientos Origen Salida Inventario (OCOI)">
<cf_templateheader title="#LvarTitulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LvarTitulo#'>
		<table width="80%" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr><td colspan="3">&nbsp;</td></tr>
			<tr>
				<td>
					<cf_navegacion name="OCIid" default="" navegacion="">
					<cfif form.OCIid EQ "" AND NOT isdefined("btnNuevo")>
						<cfinclude template="OC_INV_lista.cfm">
					<cfelse>
						<cfinclude template="OC_INV_form.cfm">
					</cfif>
					
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
