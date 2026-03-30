<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
	<cfquery name="rsRelEval" datasource="#session.DSN#">
		Select RHEEid,RHEEdescripcion
		from RHEEvaluacionDes
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<!--- Creado por: 	  Rodolfo Jimenez Jara  --->
	<!--- Fecha: 		  11/05/2005  3:00 p.m. --->
	<!--- Modificado por: --->
	<!--- Fecha: 		  --->
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_PerfilDeCompetenciasPorTipo"
					Default="Perfil de Competencias por Tipo"
					returnvariable="LB_PerfilDeCompetenciasPorTipo"/>
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_PerfilDeCompetenciasPorTipo#">
					<form name="form1" method="get" action="PerfilCompetencia-SQL.cfm">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td width="5%">&nbsp;</td>
							<td width="50%" align="center" valign="top">
								<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_PerfilDeCompetenciasPorTipo"
									Default="Perfil de Competencias por Tipo"
									returnvariable="LB_PerfilDeCompetenciasPorTipo"/>
								<cf_web_portlet_start border="true" titulo="#LB_PerfilDeCompetenciasPorTipo#" skin="info1">
									<table width="100%" align="center" >
										<tr>
											<td>
											<p><cf_translate key="AYUDA_EstaConsultaMuestraUnListadoDeLosPromediosDeLasCompetencias">Esta consulta muesta un listado de los promedios de las competencias. Incluye un promedio General, y se puede generar en formatos de MS Excel, Adobe y Flashpaper de Macromedia.</cf_translate></p>
										  	</td>
										</tr>
									</table>
								<cf_web_portlet_end>
							</td>
							<td colspan="2" valign="top">
								<table width="90%" align="center" cellpadding="0" cellspacing="0">
									<tr>
										<td width="10%" align="right" nowrap ><strong><cf_translate key="LB_RelacionDeEvaluación">Relaci&oacute;n de Evaluaci&oacute;n</cf_translate>:&nbsp;</strong></td>
										<td >
											<select name="RHEEid_f">
												<cfif isdefined('rsRelEval') and rsRelEval.recordCount GT 0>
													<!--- <option value="-1"<cfif not isdefined('form.RHEEid_f')>selected</cfif>>Todos</option> --->
													<cfoutput query="rsRelEval">
														<option value="#RHEEid#" <cfif isdefined('form.RHEEid_f') and form.RHEEid_f EQ rsRelEval.RHEEid> selected</cfif>>#RHEEdescripcion#</option>
													</cfoutput>
												</cfif>
											</select>
										</td>
									</tr>
									<tr>
										<td align="right" nowrap><strong><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</strong></td>
									  	<td ><cf_rhcfuncional></td>
								  	</tr>
									<tr >
										<td align="right"><strong><cf_translate key="LB_TipoDeHabilidad">Tipo de Habilidad</cf_translate>:&nbsp;
									  	</div>
									  	</strong></td>
									  	<td>
											<select name="RHHtipo">
												<option value="" selected ><cf_translate key="LB_Todos" XmlFile="/rh/generales.xml">Todos</cf_translate></option>
												<option value="0" ><cf_translate key="LB_Primordial">Primordial</cf_translate></option>
												<option value="1" ><cf_translate key="LB_Basica">B&aacute;sica</cf_translate></option>
												<option value="2" ><cf_translate key="LB_Complementaria">Complementaria</cf_translate></option>
												<option value="3" ><cf_translate key="LB_Deseable">Deseable</cf_translate></option>
											</select>
										</td>
								  	</tr>
									<tr >
									 	<td><div align="right"><strong><cf_translate key="LB_Formato" XmlFile="/rh/generales.xml">Formato</cf_translate>:&nbsp;</strong></div></td>
									  	<td>
									  		<select name="Formato" id="Formato" tabindex="1">
												<option value="1"><cf_translate key="LB_Flashpaper" XmlFile="/rh/generales.xml">FLASHPAPER</cf_translate></option>
											  	<option value="2"><cf_translate key="LB_PDF" XmlFile="/rh/generales.xml">PDF</cf_translate></option>
											  	<option value="3"><cf_translate key="LB_Excel" XmlFile="/rh/generales.xml">EXCEL</cf_translate></option>
											</select>
									  	</td>
								  	</tr>
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td colspan="2" align="center">
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												Key="BTN_Consultar"
												Default="Consultar"
												XmlFile="/rh/generales.xml"
												returnvariable="BTN_Consultar"/>
											<cfoutput>
											<input type="submit" name="Consultar" value="#BTN_Consultar#">
											</cfoutput>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					</form> 
				<cf_web_portlet_end>
			</td>
		</tr>
	</table>
<cf_templatefooter>