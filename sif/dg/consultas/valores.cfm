<cf_templateheader title="Lista de Valores de Distribuci&oacute;n de Gastos por Departamento">
	<table width="100%" cellpadding="0" cellspacing="0" style="vertical-align:bottom; ">
		<tr>
			<td valign="top">
				<cfif isdefined("url.DGCDid") and not isdefined("form.DGCDid") >
					<cfset form.DGCDid = url.DGCDid >
				</cfif>
				<cfif isdefined("url.PCDcatid") and not isdefined("form.PCDcatid") >
					<cfset form.PCDcatid = url.PCDcatid >
				</cfif>
				<cfif isdefined("url.Periodo") and not isdefined("form.Periodo") >
					<cfset form.Periodo = url.Periodo >
				</cfif>
				<cfif isdefined("url.mes") and not isdefined("form.mes") >
					<cfset form.mes = url.mes >
				</cfif>

				<cf_web_portlet_start border="true" titulo="Lista de Valores de Distribuci&oacute;n de Gastos por Departamento">
				<cfinclude template="../../portlets/pNavegacion.cfm">
				<cf_rhimprime datos="/sif/dg/consultas/valores-form.cfm" paramsuri="&DGCDid=#form.DGCDid#&PCDcatid=#form.PCDcatid#&Periodo=#form.Periodo#&mes=#form.mes#">
				<cfinclude template="valores-form.cfm">
				<cf_web_portlet_end>		
			</td>
		</tr>
	</table>
<cf_templatefooter>