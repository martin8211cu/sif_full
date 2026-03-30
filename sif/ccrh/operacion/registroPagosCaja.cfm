<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
	<cfparam name="form.DEid" default="#url.DEid#">
</cfif>

<cfif isdefined("url.Did") and not isdefined("form.Did")>
	<cfparam name="form.Did" default="#url.Did#">
</cfif>

<cfif isdefined("url.TDid") and not isdefined("form.TDid")>
	<cfparam name="form.TDid" default="#url.TDid#">
</cfif>
<cfif isdefined("url.EPEdocumento") and not isdefined("form.EPEdocumento")>
	<cfparam name="form.EPEdocumento" default="#url.EPEdocumento#">
</cfif>

<cfif not isdefined("url.MODO")>
	<!---ELIMINAR los pagos extraordinarios (de recibos) que tenga el usuario conectado--->
	<cfquery datasource="#session.DSN#">
		delete from ccrhPagoRecibos
		where BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			and Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>
</cfif>

	<cf_templateheader title="Cuentas por Cobrar Empleados">

	<cf_templatecss>
		<cfoutput>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de Pagos de Caja'>
						<cfinclude template="../../portlets/pNavegacion.cfm">
						<table width="98%" border="0" align="center" cellpadding="2" cellspacing="0">
							<tr>
								<td colspan="2">
									<cfinclude template="/sif/portlets/pEmpleado.cfm">
								</td>
							</tr>
							<tr>
								<td valign="top" colspan="2" ><cfinclude template="registroPagosCaja-form.cfm"></td>
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