<cf_templateheader title="Conceptos">
		<table width="100%" cellpadding="0" cellspacing="0" style="vertical-align:bottom; ">
			<tr>
				<td valign="top">
					<cfif isdefined("url.DGCcodigo") and not isdefined("form.DGCcodigo") >
						<cfset form.DGCcodigo = url.DGCcodigo >
					</cfif>
					<cfif isdefined("url.DGCcodigo2") and not isdefined("form.DGCcodigo2") >
						<cfset form.DGCcodigo2 = url.DGCcodigo2 >
					</cfif>
					<cfif isdefined("url.DGtipo") and not isdefined("form.DGtipo") >
						<cfset form.DGtipo = url.DGtipo >
					</cfif>
					<cfif isdefined("url.Comportamiento") and not isdefined("form.Comportamiento") >
						<cfset form.Comportamiento = url.Comportamiento >
					</cfif>
					<cfif isdefined("url.referencia") and not isdefined("form.referencia") >
						<cfset form.referencia = url.referencia >
					</cfif>

					<cf_web_portlet_start border="true" titulo="Lista de Conceptos de Estado de Resultados">
					<cfinclude template="../../portlets/pNavegacion.cfm">
					<cf_rhimprime datos="/sif/dg/consultas/conceptos-form.cfm" paramsuri="&DGCcodigo=#form.DGCcodigo#&DGCcodigo2=#form.DGCcodigo2#&DGtipo=#form.DGtipo#&Comportamiento=#form.Comportamiento#&referencia=#form.referencia#">
					<cfinclude template="conceptos-form.cfm">
					<cf_web_portlet_end>		
				</td>
			</tr>
		</table>
	<cf_templatefooter>		