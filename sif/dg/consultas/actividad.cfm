<cf_templateheader title="Actividades">
		<table width="100%" cellpadding="0" cellspacing="0" style="vertical-align:bottom; ">
			<tr>
				<td valign="top">
					<cfif isdefined("url.DGAcodigo") and not isdefined("form.DGAcodigo") >
						<cfset form.DGAcodigo = url.DGAcodigo >
					</cfif>
					<cfif isdefined("url.DGAcodigo2") and not isdefined("form.DGAcodigo2") >
						<cfset form.DGAcodigo2 = url.DGAcodigo2 >
					</cfif>

					<cf_web_portlet_start border="true" titulo="Lista de Actividades">
					<cfinclude template="../../portlets/pNavegacion.cfm">
					<cf_rhimprime datos="/sif/dg/consultas/actividad-form.cfm" paramsuri="&DGAcodigo=#form.DGAcodigo#&DGAcodigo2=#form.DGAcodigo2#">
					<cfinclude template="actividad-form.cfm">
					<cf_web_portlet_end>		
				</td>
			</tr>
		</table>
	<cf_templatefooter>		
