<cfif isdefined("url.log")>
	<cfinclude template="downloadLog.cfm">
</cfif>
<cfquery name="rsCE" datasource="asp">
	select CEaliaslogin
	from CuentaEmpresarial
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
</cfquery>
<cfset Request.CEnombre = rsCE.CEAliaslogin>
<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Par&aacute;metros de cada Interfaz
	</cf_templatearea>
	<cf_templatearea name="body">
	  <cf_web_portlet_start titulo="Par&aacute;metros de Interfaces">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<cfset LvarActivarMotor = true>
			<table width="50%" align="center" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top">
						<cfinclude template="parametrosMotor-form.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>
