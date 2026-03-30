<cfinvoke component="sif.Componentes.Translate" 
	method="Translate"
	Key="LB_Centro_Funcional"
	Default="Centro Funcional"
	returnvariable="LB_Centro_Funcional"/>      
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">

		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Puntuacion_de_Factores_Por_Puesto"
				Default="Puntuaci&oacute;n de Factores por Puesto"
				returnvariable="LB_Puntuacion_de_Factores_Por_Puesto"/> 
				
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Puntuacion_de_Factores_Por_Puesto#">
					<form name="form1" method="post" action="PuntosXFactor.cfm" style="margin:0;">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td width="5%">&nbsp;</td>
							<td width="40%" align="center" valign="top">
								<cf_web_portlet_start border="true" titulo="#LB_Puntuacion_de_Factores_Por_Puesto#" skin="info1">
									<table width="100%" align="center">
										<tr><td><p>
										<cf_translate  key="LB_AYUDA">
											Esta consulta muestra la puntuaci&oacute;n que se ha asignado a los diferentes factores de un puesto
										</cf_translate>
										</p></td></tr>
									</table>
								<cf_web_portlet_end>
							</td>
							<td colspan="2" valign="top">
								<cfoutput>
                                <table width="90%" align="center" cellpadding="2" cellspacing="0">
									<tr>
										<td width="10%" align="right" nowrap >#LB_Centro_Funcional#:&nbsp;</td>
										<td>
                                         <cf_rhcfuncional tabindex="1">
										</td>
									</tr>
									<tr>
										<td colspan="2">&nbsp;
											
										</td>
									</tr>
									<tr>
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Consultar"
										Default="Consultar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Consultar"/>
										<cfoutput>
										<td colspan="2" align="center"><input type="submit" name="Consultar" value="#BTN_Consultar#"></td>
										</cfoutput>
									</tr>
								</table>
                                </cfoutput>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					</form>
				<cf_web_portlet_end>
			</td></tr>
		</table>
<cf_templatefooter>