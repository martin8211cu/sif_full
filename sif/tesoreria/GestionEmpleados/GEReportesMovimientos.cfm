<cfset LvarSAporEmpleadoSolicitante="false">
<cfset LvarCFM = "">	
<cf_templateheader title="Consulta de Movimientos de Gastos de Empleado de Tesoreria">
	<table width="100%" cellpadding="1" cellspacing="0">
		<tr>
			<td valign="top">	
				<cf_web_portlet_start border="true" titulo="Consulta de Movimientos de Gastos de Empleado de Tesoreria por Periodo" skin="#Session.Preferences.Skin#"> 
					<table width="100%">
						<tr>
							<td>
								<cfinclude template="GEReportes_filtroMovimientos.cfm">
							</td>
						</tr>						
					</table>					
				<cf_web_portlet_end> 
             </td>  
		</tr>
	</table>	
<cf_templatefooter>

