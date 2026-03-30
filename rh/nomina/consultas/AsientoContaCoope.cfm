<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<table width="100%" cellpadding="1" cellspacing="0">
		<tr>
			<td valign="top">	
				<cf_web_portlet_start border="true" titulo="Consulta de Asiento de Contabilidad" skin="#Session.Preferences.Skin#"> 
					<table width="100%">
						<tr>
							<td>
								<cfoutput><iframe width="100%" height="500" frameborder="0" src="AsientoContaCoope-form.cfm?desde=#url.desde#&hasta=#url.hasta#"></iframe></cfoutput>
							</td>
						</tr>
					</table>
				<cf_web_portlet_end> 
			</td>	
		</tr>
	</table>	
<cf_templatefooter>