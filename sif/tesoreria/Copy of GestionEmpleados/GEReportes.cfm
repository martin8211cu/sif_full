	<!--- valida CPid--->
	<!---<cfif not isdefined("url.CPid")>
		<cf_errorCode	code = "50736" msg = "No se ha seleccionado el calendario de Pagos">
	</cfif>--->
	
<cf_templateheader title="Consulta de Transacciones Empleado">
	<table width="100%" cellpadding="1" cellspacing="0">
		<tr>
			<td valign="top">	
				<cf_web_portlet_start border="true" titulo="Consulta de Transacciones Empleado" skin="#Session.Preferences.Skin#"> 
					<table width="100%">
						<tr>
							<td>
								<cfinclude template="GEReportes_filtro.cfm">
							</td>
						</tr>						
					</table>					
				<cf_web_portlet_end> 
		
		</tr>
	</table>	
<cf_templatefooter>

