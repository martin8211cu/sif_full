<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Consulta de Anticipos sin Liquidar" returnvariable="LB_Titulo" 
xmlfile ="GEReportesAnti.xml"/>

<cf_templateheader title="#LB_Titulo#">
	<table width="100%" cellpadding="1" cellspacing="0">
		<tr>
			<td valign="top">	
				<cf_web_portlet_start border="true" titulo="#LB_Titulo#" skin="#Session.Preferences.Skin#"> 
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

