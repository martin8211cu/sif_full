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
				Key="LB_GradosXFactor"
				Default="Puntuación de Grados por Factor"
				returnvariable="LB_GradosXFactor"/> 
				
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_GradosXFactor#">
					<form name="form1" method="get" action="GradosXFactor.cfm" style="margin:0; " onSubmit="javascript: return validar(this);">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td width="5%">&nbsp;</td>
							<td width="40%" align="center" valign="top">
								<cf_web_portlet_start border="true" titulo="#LB_GradosXFactor#" skin="info1">
									<table width="100%" align="center">
										<tr><td><p>
										<cf_translate  key="AYUDA_EstaConsultaMuestraLaPuntuacionQueSeHaAsignadoALosDiferentesGradosDeUnFactor">
											Esta consulta muestra la puntuaci&oacute;n que se ha asignado a los diferentes grados de un factor
										</cf_translate>
										</p></td></tr>
									</table>
								<cf_web_portlet_end>
							</td>
							<td colspan="2" valign="top">
								<table width="90%" align="center" cellpadding="2" cellspacing="0">
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Factor">Factor</cf_translate>:&nbsp;</td>
										<td>
											<cfquery name="RSFactores" datasource="#session.DSN#">
												select RHFid,RHFcodigo,RHFdescripcion
												from RHFactores
												where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											</cfquery>
											<cfoutput>
											<select name="RHFid">
												<option value="" selected="selected" ><cf_translate  key="LB_Todos">Todos</cf_translate></option>
												<cfloop query="RSFactores">
													<option value="#RSFactores.RHFid#">#trim(RSFactores.RHFcodigo)#-#trim(RSFactores.RHFdescripcion)#</option>
												</cfloop>
											</select>
											</cfoutput>
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
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					</form>
					
					<script language="javascript1.2" type="text/javascript">
						<cfoutput>
						function validar(form){
							return true;
						}
						
						</cfoutput>
					</script>
				<cf_web_portlet_end>
			</td></tr>
		</table>
<cf_templatefooter>