<cf_templateheader title="Consulta de Gastos Distribuidos">
	<table width="100%" cellpadding="0" cellspacing="0" style="vertical-align:bottom; ">
		<tr>
			<td valign="top">
				<cfparam name="url.orden" default="D">
				<cfif isdefined("url.DGGDid") and not isdefined("form.DGGDid") >
					<cfset form.DGGDid = url.DGGDid >
				</cfif>
				<cfif isdefined("url.periodo") and not isdefined("form.periodo") >
					<cfset form.periodo = url.periodo >
				</cfif>
				<cfif isdefined("url.mes") and not isdefined("form.mes") >
					<cfset form.mes = url.mes >
				</cfif>
				<cfif isdefined("url.orden") and not isdefined("form.orden") >
					<cfset form.orden = url.orden >
				</cfif>

				<cf_web_portlet_start border="true" titulo="Consulta de Gastos Distribuidos">
				<cfinclude template="../../portlets/pNavegacion.cfm">
				<cf_rhimprime datos="/sif/dg/consultas/gastosDistribuidos-form.cfm" paramsuri="&DGGDid=#form.DGGDid#&periodo=#form.periodo#&mes=#form.mes#&orden=#url.orden#">
				<cfinclude template="gastosDistribuidos-form.cfm">
				<cf_web_portlet_end>		
			</td>
		</tr>
	</table>
<cf_templatefooter>