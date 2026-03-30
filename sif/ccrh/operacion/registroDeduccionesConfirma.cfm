<cf_templateheader title="Cuentas por Cobrar RH">
	<!--- debe esxistri esta estructura en session --->
	<cfif not isdefined("session.deduccion_empleado")>
		<cflocation url="listaEmpleados.cfm">
	<cfelse>
		<cfset form.DEid = session.deduccion_empleado.DEid >
	</cfif>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de Deducciones por Empleado'>
					<cfinclude template="../../portlets/pNavegacion.cfm">
					<table width="98%" align="center" cellpadding="2" cellspacing="0">
						<tr>
							<td>
								<cfinclude template="/sif/portlets/pEmpleado.cfm">
							</td>
						</tr>
						
						<tr>
							<!--- Plan de Financiamiento --->
							<td valign="top">
								<cfinclude template="registroDeduccionesConfirma-form.cfm">
							</td>
						</tr>
						
					</table>
					<br>
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>
<cf_templatefooter>
