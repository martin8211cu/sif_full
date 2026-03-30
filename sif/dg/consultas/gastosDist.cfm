<cf_templateheader title="Lista de Gastos por Distribuir">
		<table width="100%" cellpadding="0" cellspacing="0" style="vertical-align:bottom; ">
			<tr>
				<td valign="top">
					<cfif isdefined("url.DGGDcodigo") and not isdefined("form.DGGDcodigo") >
						<cfset form.DGGDcodigo = url.DGGDcodigo >
					</cfif>
					<cfif isdefined("url.DGGDcodigo2") and not isdefined("form.DGGDcodigo2") >
						<cfset form.DGGDcodigo2 = url.DGGDcodigo2 >
					</cfif>

					<cf_web_portlet_start border="true" titulo="Lista de Gastos por Distribuir">
					<cfinclude template="../../portlets/pNavegacion.cfm">
					<cf_rhimprime datos="/sif/dg/consultas/gastosDist-form.cfm" paramsuri="&DGGDcodigo=#form.DGGDcodigo#&DGGDcodigo2=#form.DGGDcodigo2#">
					<cfinclude template="gastosDist-form.cfm">
					<cf_web_portlet_end>		
				</td>
			</tr>
		</table>
	<cf_templatefooter>		