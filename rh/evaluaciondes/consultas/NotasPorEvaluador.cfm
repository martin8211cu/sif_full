<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_ListaDeEvaluaciones" default="Lista de Evaluaciones" returnvariable="LB_ListaDeEvaluaciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ListaDeEmpleadosEvaluados" default="Lista de Empleados Evaluados" returnvariable="LB_ListaDeEmpleadosEvaluados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_No_se_encontraron_registros" default="No se encontraron registros" returnvariable="LB_No_se_encontraron_registros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripci\u00f3n"returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaDesde" default="Fecha Desde" returnvariable="LB_FechaDesde" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaHasta" default="Fecha Hasta" returnvariable="LB_FechaHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Identificacion" default="Identificaci&oacute;n"returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Evaluacion" default="Evaluaci\u00f3n" returnvariable="LB_Evaluacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Empleado" default="Empleado" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Reporte_Notas_del_Evaluado_Por_Evaluador" default="Reporte Notas del Evaluado Por Evaluador" returnvariable="LB_Reporte_Notas_del_Evaluado_Por_Evaluador" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Consultar" default="Consultar" xmlfile="/rh/generales.xml" returnvariable="BTN_Consultar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Exportar_Excel" default="Exportar a Excel" xmlfile="/rh/generales.xml" returnvariable="BTN_Exportar_Excel" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_ElCampoEsRequerido" default="El campo siguiente campo es requerido" returnvariable="MSG_ElCampoEsRequerido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_SePresentaronLosSiguientesErrores" default="Se presentaron los siguientes errores" returnvariable="MSG_SePresentaronLosSiguientesErrores" component="sif.Componentes.Translate" method="Translate"/>
<cfquery name="rsEscalas" datasource="#Session.DSN#">
	select RHEid ,RHEdescripcion, RHEdefault
	from RHEscalas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Reporte_Notas_del_Evaluado_Por_Evaluador#">
				
				<form name="form1" method="post" action="NotasPorEvaluador-rep.cfm" style="margin:0; " onsubmit="javascript: return validar(this);">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr>
						<td width="5%">&nbsp;</td>
						<td width="50%" align="center" valign="top">
							<cf_web_portlet_start border="true" titulo="#LB_Reporte_Notas_del_Evaluado_Por_Evaluador#" skin="info1">
								<table width="100%" align="center">
									<tr>
										<td>
											<p><cf_translate key="AYUDA_Notas_del_Evaluado_Por_Evaluador">
											Este Reporte muestra el ponderado de notas de un empleado evaluado en una evaluaci&oacute;n, asi como el detalle por evaluador.
											<br /><br /> <b>Evaluado:</b> Permite filtrar por empleado evaluado.
											<br /><br /> <b>Centro Funcional:</b> Permite filtrar por Centro Funcional del Evaluado.
											<br /><br /> <b>Orden:</b> Permite ordenar los empleados evaluados por "Nombre y Apellidos" o "Apellidos y Nombre" según se desee.
											</cf_translate></p>
										</td>
									</tr>
								</table>
							<cf_web_portlet_end>
						</td>
						<td colspan="2" valign="top">
							<table width="90%" align="center" cellpadding="2" cellspacing="0">
								<tr>
									<td width="10%" align="right" nowrap ><cf_translate key="LB_Evaluacion" XmlFile="/rh/generales.xml">Evaluaci&oacute;n</cf_translate>:&nbsp;</td>
									<td>
										<cf_rhevaluacion size="60" tipo = "2,4" Cerradas = "S">
									</td>
								</tr>
								<tr>
									<td width="10%" align="right" nowrap ><cf_translate key="LB_Evaluado" XmlFile="/rh/generales.xml">Evaluado</cf_translate>:&nbsp;</td>
									<td>
										<cf_conlis title="#LB_ListaDeEmpleadosEvaluados#"
											campos = "DEid,DEidentificacion,nombreEmp" 
											desplegables = "N,S,S" 
											modificables = "N,S,N"
											size = "0,12,45"
											valuesArray="" 
											tabla="DatosEmpleado de
													inner join RHListaEvalDes ed
														on ed.DEid = de.DEid
														and ed.RHEEid = $RHEEid,numeric$
														and ed.Ecodigo = de.Ecodigo
												"
											columnas="de.DEid,DEidentificacion,{fn concat(DEapellido1,{fn concat(' ',{fn concat(DEapellido2,{fn concat(', ',DEnombre)})})})} as nombreEmp"
											filtro="de.Ecodigo=#session.Ecodigo#"
											desplegar="DEidentificacion,nombreEmp"
											etiquetas="#LB_Identificacion#,#LB_Nombre#"
											formatos="S,S"
											align="left,left"
											asignar="DEid,DEidentificacion,nombreEmp"
											asignarformatos="S,S,S"
											filtrar_por="DEidentificacion|{fn concat(DEapellido1,{fn concat(' ',{fn concat(DEapellido2,{fn concat(', ',DEnombre)})})})}"
											filtrar_por_delimiters="|"
											tabindex="1">
									</td>
								</tr>
								<tr>
									<td width="10%" align="right" nowrap ><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</td>
									<td>
										<cf_rhcfuncional>
									</td>
								</tr>
								<tr>
									<td></td>
									<td><label for=R><input type="checkbox" name="chkIncluirDependencias" />Incluir dependencias</label></td>
								</tr>
								<tr>		
									<tr>
										<tr>
											<td width="10%" align="right" nowrap ><cf_translate  key="LB_Ordenamiento">Orden</cf_translate>:&nbsp;</td>
											<td>
												<select name="RHOrden"  tabindex="1">
													<option value="N"><cf_translate  key="LB_Escala_de_calificaci&oacute;n">Nombre y Apellidos</cf_translate></option>
													<option value="A"><cf_translate  key="LB_Escala_de_calificaci&oacute;n">Apellidos y Nombre</cf_translate></option>
												</select>
											</td>		
										</tr>
									<tr>
								</tr>
	                             <tr><td>&nbsp;</td></tr>
								<tr>
									<td></td>
									<td align="center">
										<input type="submit" name="Consultar" class="btnNormal" value="<cfoutput>#BTN_Consultar#</cfoutput>" tabindex="1">
										<input type="submit" name="Exportar" class="btnPublicar" value="<cfoutput>#BTN_Exportar_Excel#</cfoutput>" tabindex="1">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>		
				</table>
				</form>
				
				<script language="javascript1.2" type="text/javascript">
					function validar(form){
					
						if(document.getElementById('RHEEid').value==""){
								alert("<cfoutput>#MSG_ElCampoEsRequerido# : \n-  #LB_Evaluacion#</cfoutput>");
								return false;
						}
							
						return true;
					}
				</script>
	
			<cf_web_portlet_end>
			</td>
		</tr>
	</table>
<cf_templatefooter>