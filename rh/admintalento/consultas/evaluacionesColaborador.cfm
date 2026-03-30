	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<table width="100%" cellpadding="1" cellspacing="0">
			<tr>
				<td valign="top">	
					<cf_web_portlet_start border="true" titulo="Evaluaciones de Talento por Colaborador" skin="#Session.Preferences.Skin#"> 
						<table width="100%">
							<tr>
								<td>
									<cfparam name="url.DEid" default="">
									<cfparam name="url.RHRSid" default="">									
									<cfparam name="url.inicio" default="">									
									<cfparam name="url.fin" default="">
									<cfset params = "?DEid=#url.DEid#&RHRSid=#url.RHRSid#&inicio=#url.inicio#&fin=#url.fin#">
								
									<iframe width="100%" height="500" frameborder="0" src="evaluacionesColaborador-form.cfm<cfoutput>#params#</cfoutput>" ></iframe>
								</td>
							</tr>
						</table>
					<cf_web_portlet_end> 
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>