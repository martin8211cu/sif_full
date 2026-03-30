<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Par&aacute;metros de Interfaces
	</cf_templatearea>
	<cf_templatearea name="body">
	  <cf_web_portlet titulo="Par&aacute;metros de Interfaces">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<cfinclude template="parametros-sql.cfm">
			<cfset LvarActivarMotor = true>
			<cfinclude template="parametros-motor.cfm">
			<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
			<tr>
			<td valign="top" width="50%">
			<cfinclude template="parametros-lista.cfm">
			</td>
			<td width="50%" valign="top">
			<cfif isdefined("form.NumeroInterfaz")>
				<cfinclude template="parametros-form.cfm">
			</cfif>
			</td>
			</tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>
