<cf_templateheader title="Reporte de Liquidacion por forma de Pago">
	<table width="100%" cellpadding="1" cellspacing="0">
		<tr>
			<td valign="top">	
				<cf_web_portlet_start border="true" titulo="Reporte de Liquidaciones por forma de Pago" skin="#Session.Preferences.Skin#"> 
					<table width="100%">
						<tr>
							<td>
								<cfinclude template="GEReportesLiq_filtro.cfm">
							</td>
						</tr>						
					</table>					
				<cf_web_portlet_end> 
		
		</tr>
	</table>	
<cf_templatefooter>

