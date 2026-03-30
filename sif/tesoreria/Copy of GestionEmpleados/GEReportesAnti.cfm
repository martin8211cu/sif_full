<cf_templateheader title="Consulta de Anticipos sin Liquidar">
	<table width="100%" cellpadding="1" cellspacing="0">
		<tr>
			<td valign="top">	
				<cf_web_portlet_start border="true" titulo="Consulta de Anticipos sin Liquidar" skin="#Session.Preferences.Skin#"> 
					<table width="100%">
						<tr>
							<td>
								<cfinclude template="GEReportesAnti_filtro.cfm">
							</td>
						</tr>						
					</table>					
				<cf_web_portlet_end> 
		
		</tr>
	</table>	
<cf_templatefooter>

