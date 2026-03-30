<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
	<cfparam name="form.DEid" default="#url.DEid#">
</cfif>

<cfif isdefined("url.Did") and not isdefined("form.Did")>
	<cfparam name="form.Did" default="#url.Did#">
</cfif>

<cfif isdefined("url.TDid") and not isdefined("form.TDid")>
	<cfparam name="form.TDid" default="#url.TDid#">
</cfif>


	<cf_templateheader title="Cuentas por Cobrar Empleados">

	
	
	<cf_templatecss>
		<cfoutput>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de Pagos Extraordinarios'>
						<cfinclude template="../../portlets/pNavegacion.cfm">
						<table width="98%" border="0" align="center" cellpadding="2" cellspacing="0">
							<tr>
								<td colspan="2">
									<cfinclude template="/sif/portlets/pEmpleado.cfm">
								</td>
							</tr>
							
							<tr>
								<!---<td valign="top" width="20%"><cfinclude template="planPagos-Actual.cfm"></td>--->
								<td valign="top" colspan="2" ><cfinclude template="registroPagosE-form.cfm"></td>
							</tr>
							
						</table>
						<br>
					<cf_web_portlet_end>
				</td>	
			</tr>
		</table>
		</cfoutput>
		<script language="JavaScript1.2">
		</script>		  
	<cf_templatefooter>