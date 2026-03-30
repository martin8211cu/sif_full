	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Incapacidades_por_Unidad_de_Negocio"
	Default="Incapacidades por Unidad de Negocio"
	returnvariable="LB_Incapacidades_por_Unidad_de_Negocio"/>

	<cfquery name="rsEtiquetas" datasource="#session.DSN#">
		select DFElinea,DFEetiqueta from DFormatosExpediente
		where EFEid = 
		(select <cf_dbfunction name="to_number" args="Pvalor">  from RHParametros where Ecodigo  =<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
		 and Pcodigo = 930 )
		 order by DFEetiqueta
	</cfquery>


<cf_templateheader title="#LB_RecursosHumanos#">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Incapacidades_por_Unidad_de_Negocio#">
					<cfoutput>
					<form name="form1" method="post" action="IncapacidadesUNeg.cfm" style="margin:0; ">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td width="5%">&nbsp;</td>
							<td width="50%" align="center" valign="top">
								<cf_web_portlet_start border="true" titulo="#LB_Incapacidades_por_Unidad_de_Negocio#" skin="info1">
									<table width="100%" align="center">
										<tr><td><p>
										<cf_translate  key="Ayuda_Reporte">
											En este reporte se puede consultar las incapacidades de los colaboradores ordenadas por centro funcional y coloborador
											en un rango definido de fechas.
										</cf_translate>
										</p></td></tr>
									</table>
								<cf_web_portlet_end>
							</td>
							<td colspan="2" valign="top">
								<table width="90%" align="center" cellpadding="2" cellspacing="0">
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate key="LB_FechaDesde">Fecha desde</cf_translate>:&nbsp;</td>
										<td>
											<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fdesde" value="" tabindex="1">
										</td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate key="LB_FechaHasta">Fecha hasta</cf_translate>:&nbsp;</td>
										<td>
											<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fhasta" value="" tabindex="1">
										</td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Consultar">Consultar</cf_translate>:&nbsp;</td>
										<td >
										<select name="DFElinea">
												<option value="-1"><cf_translate  key="LB_Niguno">Ninguna Etiqueta</cf_translate></option>
												<option value="-2"><cf_translate  key="LB_todos">Todas las Etiquetas</cf_translate></option>
												<cfif rsEtiquetas.recordCount GT 0>
													<cfloop query="rsEtiquetas">
														<option value="#rsEtiquetas.DFElinea#">#rsEtiquetas.DFEetiqueta#</option>
													</cfloop>
												</cfif>		
										</select>
										</td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Empleado">Empleado</cf_translate>:&nbsp;</td>
										<td ><cf_rhempleado tabindex="1" size = "30" DEid="DEid"  ></td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Centro_Funcional">Centro Funcional</cf_translate>:&nbsp;</td>
										<td ><cf_rhcfuncional tabindex="1"></td>
									</tr>
									<tr>
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Consultar"
										Default="Consultar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Consultar"/>
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Limpiar"
										Default="Limpiar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Limpiar"/>
										
										<td colspan="2" align="center">
											<input type="submit" name="Consultar" value="<cfoutput>#BTN_Consultar#</cfoutput>">
											<input type="reset"  name="limpiar" value="<cfoutput>#BTN_Limpiar#</cfoutput>">
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					</form>
					</cfoutput>
					
					<script language="javascript1.2" type="text/javascript">
					</script>
				<cf_web_portlet_end>
			</td></tr>
		</table>
<cf_templatefooter>