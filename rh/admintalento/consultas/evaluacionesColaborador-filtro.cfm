<cfinvoke key="LB_nav__SPdescripcion" default="Reporte de Evaluaciones del talento por Colaborador"  returnvariable="LB_nav__SPdescripcion" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Codigo" default="Codigo"  returnvariable="LB_Codigo" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripcion"  returnvariable="LB_Descripcion" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_ListaDeRelacionesDeSeguimiento" default="Lista de Relaciones de Seguimiento"  returnvariable="LB_Lista" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="BTN_Consultar" default="Consultar"  returnvariable="BTN_Consultar" component="sif.Componentes.Translate"  method="Translate"/>

<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		<table width="98%" cellpadding="3" cellspacing="0">
			<tr>
				<td width="40%" valign="top">
					<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
						<p><br><cf_translate key="LB_ReporteDeEvaluacionesDeltalentoPorColaborador">Reporte que muestra los resultados de las diferentes evaluciones de talento realizadas a un colaborador</cf_translate></p><br>
					<cf_web_portlet_end>	
				</td>
				<td width="60%" valign="top">
					<form name="form1" method="url" action="evaluacionesColaborador.cfm">
						<table width="100%" cellpadding="2" cellspacing="0">							
							<tr>
								<td><b><cf_translate key="LB_Empleado">Empleado</cf_translate>:</b>&nbsp;</td>
								<td><cf_rhempleado tabindex="1" size="25" form="form1"></td>
							</tr>
							<!---
							<tr>
								<td><b><cf_translate key="LB_EmpleadoHasta">Empleado hasta</cf_translate>:</b>&nbsp;</td>
								<td><cf_rhempleado tabindex="2" size="25" form="form1"></td>
							</tr>
							--->
							<tr>
								<td nowrap="nowrap"><b><cf_translate key="LB_RelacionDeSeguimiento">Relaci&oacute;n de Seguimiento</cf_translate>:</b>&nbsp;</td>
								<td>
									<cf_conlis title="#LB_Lista#"
									campos = "RHRSid,RHRSdescripcion" 
									desplegables = "N,S" 
									modificables = "N,N" 
									size = "0,40"
									asignar="RHRSid,RHRSdescripcion"
									asignarformatos="I,S"
									tabla="RHRelacionSeguimiento"																	
									columnas="RHRSid,RHRSdescripcion"
									filtro="Ecodigo =#session.Ecodigo# and RHRSestado in (20,30) and exists ( select 1 from RHDRelacionSeguimiento where RHRSid=RHRelacionSeguimiento.RHRSid and RHDRestado in (20,30) )"
									desplegar="RHRSdescripcion"
									etiquetas="#LB_Descripcion#"
									formatos="S"
									align="left"
									showEmptyListMsg="true"
									debug="false"
									form="form1"
									width="800"
									height="500"
									left="70"
									top="20"
									filtrar_por="RHRSdescripcion">
								</td>
							</tr>
							<tr>
								<td><b><cf_translate key="LB_FechaDesde">Fecha desde</cf_translate>:</b>&nbsp;</td>
								<td>
									<cf_sifcalendario name="inicio" value="" tabindex="4" form="form1">
								</td>
							</tr>
							<tr>
								<td><b><cf_translate key="LB_FechaHasta">Fecha hasta</cf_translate>:</b>&nbsp;</td>
								<td>
									<cf_sifcalendario name="fin" value="" tabindex="5" form="form1">
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td colspan="2" align="center">
									<cfoutput><input type="submit" name="btnConsultar" value="#BTN_Consultar#"></cfoutput>
								</td>
							</tr>
						</table>
					</form>
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>