	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Consulta_de_Incapacidad_de_Empleados"
		Default="Consulta de Incapacidades por Empleado"
		returnvariable="LB_Titulo"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Etiqueta"
		Default="Etiqueta"
		returnvariable="LB_Etiqueta"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Consultar"
		Default="Consultar"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_Consultar"/>

	<cfset v_EFEid = 0 >
<!---	<cfquery name="rs_parametro_930" datasource="#session.DSN#">
		select Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 930
	</cfquery>
	<cfif len(trim(rs_parametro_930.Pvalor))>
		<cfset v_EFEid = rs_parametro_930.Pvalor >
	</cfif>--->
	
	<cfquery name="etiquetas" datasource="#session.DSN#">
		select DFElinea, DFEetiqueta
		from DFormatosExpediente
		<!---where EFEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#v_EFEid#">--->
		order by DFEetiqueta
	</cfquery>
	
	<cfoutput>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<table width="100%" cellpadding="1" cellspacing="0">
			<tr>
				<td valign="top">	
					<cf_web_portlet_start border="true" titulo="#LB_Titulo#" skin="#Session.Preferences.Skin#"> 
						<form name="form1" method="get" action="incapacidadEmpleado.cfm" style="margin:0;">
							<table width="75%" align="center" cellpadding="2">
								<tr>
									<td align="right" width="35%"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Empleado">Empleado</cf_translate>:</strong></td>
									<td><cf_rhempleado></td>
								</tr>
								<tr>
									<td align="right"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_FechaDesde">Fecha desde</cf_translate>:</strong></td>
									<td><cf_sifcalendario name="desde"></td>
								</tr>
								<tr>
									<td align="right"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_FechaHasta">Fecha hasta</cf_translate>:</strong></td>
									<td><cf_sifcalendario name="hasta"></td>
								</tr>
								<tr>
									<td align="right"><strong>#LB_Etiqueta#:</strong></td>
									<td><select name="DFElinea">
											<option value="">-<cf_translate xmlfile="/rh/generales.xml" key="LB_Seleccionar">seleccionar</cf_translate> -</option> 	
											<cfloop query="etiquetas">
												<option value="#etiquetas.DFElinea#">#etiquetas.DFEetiqueta#</option> 	
											</cfloop>
										</select>
									</td>
								</tr>
								<tr>
									<td></td>
									<td>
										<table>
											<tr>
												<td width="1%"><input type="checkbox" name="depto" id="depto"></td>
												<td><label for="depto"><cf_translate key="LB_Mostrar_Incapacidades_por_Departamento">Mostrar Incapacidades por Departamento</cf_translate></label></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td colspan="2" align="center"><input type="submit" class="btnFiltrar" name="Consultar" value="#LB_Consultar#"></td>
								</tr>
							</table>
						</form>
					<cf_web_portlet_end> 
				</td>	
			</tr>
		</table>	
	
		<cf_qforms>
		
		<script language="javascript1.2" type="text/javascript">
			objForm.DFElinea.required = true;
			objForm.DFElinea.description = '#LB_Etiqueta#';
		</script>
			
	<cf_templatefooter>
	</cfoutput>
	