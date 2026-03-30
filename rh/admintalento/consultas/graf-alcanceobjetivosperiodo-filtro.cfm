<cfinvoke key="LB_nav__SPdescripcion" default="Reporte de Alcance de Objetivos por Periodo"  returnvariable="LB_nav__SPdescripcion" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Codigo" default="Codigo"  returnvariable="LB_Codigo" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripcion"  returnvariable="LB_Descripcion" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_ListaDeObjetivos" default="Lista de Objetivos"  returnvariable="LB_ListaDeObjetivos" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="BTN_Consultar" default="Consultar"  returnvariable="BTN_Consultar" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_ListaDeEvaluaciones" default="Lista de Evaluaciones"  returnvariable="LB_ListaDeEvaluaciones" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_FechaInicio" default="Fecha Inicio"  returnvariable="LB_FechaInicio" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_FechaFinaliza" default="Fecha Finaliza"  returnvariable="LB_FechaFinaliza" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="MSG_DebeSeleccionarUnObjetivo" default="Debe seleccionar un objetivo"  returnvariable="MSG_DebeSeleccionarUnObjetivo" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="MSG_DebeSeleccionarUnEmpleado" default="Debe seleccionar un empleado"  returnvariable="MSG_DebeSeleccionarUnEmpleado" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="MSG_DebeSeleccionarUnaEvaluacion" default="Debe seleccionar una evaluacion"  returnvariable="MSG_DebeSeleccionarUnaEvaluacion" component="sif.Componentes.Translate"  method="Translate"/>

<cf_templateheader title="#LB_nav__SPdescripcion#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		<table width="98%" cellpadding="3" cellspacing="0">
			<tr>
				<td width="40%" valign="top">
					<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
						<p><br><cf_translate key="LB_AlcanceDeObjetivosPorPeriodo">
							Para las evaluaciones de objetivos terminadas en un rango de fechas, cuantos 
							empleados alcanzaron los objetivos y cuantos no.<br><br>
							<b>General:</b>Toma en cuenta todos los objetivos evaluados.<br>
							<b>Por Objetivo:</b>Toma en cuenta solo un objetivo seleccionado.<br>
							<b>Por Persona:</b>Toma en cuenta todos los objetivos evaluados a un coolaborador especifico.
							</cf_translate>
						</p><br>
					<cf_web_portlet_end>	
				</td>
				<td width="60%" valign="top">
					<form name="form1" method="post" action="graf-alcanceobjetivosperiodo-rep.cfm" onSubmit="javascript: return funcValida();">
						<table width="100%" cellpadding="2" cellspacing="0" border="0">														
							<tr>
								<td align="right" width="5%" nowrap><b><cf_translate key="LB_FechaDesde">Fecha desde</cf_translate>:</b>&nbsp;</td>
								<td>
									<cf_sifcalendario name="finicio" value="" tabindex="4" form="form1">
								</td>
								<td align="right"><b><cf_translate key="LB_FechaHasta">Fecha hasta</cf_translate>:</b>&nbsp;</td>
								<td>
									<cf_sifcalendario name="ffin" value="" tabindex="5" form="form1">
								</td>
							</tr>
							<tr>
								<td><b><cf_translate key="LB_Evaluacion">Evaluaci&oacute;n</cf_translate>:&nbsp;</b></td>
								<td colspan="3">
									<cf_conlis title="#LB_ListaDeEvaluaciones#"
									campos = "RHDRid,RHRSdescripcion,RHDRfinicio,RHDRffin" 
									desplegables = "N,S,N,N" 
									modificables = "N,N,N,N" 
									size = "0,65,0,0"
									asignar="RHDRid,RHRSdescripcion,RHDRfinicio,RHDRffin"
									asignarformatos="I,S,D,D"
									tabla="RHRelacionSeguimiento a
											inner join RHDRelacionSeguimiento b
												on a.RHRSid = b.RHRSid
												and b.RHDRestado = 30 "																	
									columnas="RHDRid,RHRSdescripcion,RHDRfinicio,RHDRffin"
									filtro="a.Ecodigo =#session.Ecodigo# and a.RHRStipo = 'O' and a.RHRSestado in (20,30)"
									desplegar="RHRSdescripcion,RHDRfinicio,RHDRffin"
									etiquetas="#LB_Descripcion#,#LB_FechaInicio#,#LB_FechaFinaliza#"
									formatos="S,D,D"
									align="left,left,left"
									showEmptyListMsg="true"
									debug="false"
									form="form1"
									width="800"
									height="500"
									left="70"
									top="20"
									filtrar_por="RHRSdescripcion,RHDRfinicio,RHDRffin">									
								</td>
							</tr>							
							<tr id="empleado" style="display:none;">
								<td align="right"><b><cf_translate key="LB_Empleado">Empleado</cf_translate>:</b>&nbsp;</td>
								<td colspan="3"><cf_rhempleado tabindex="1" size="25" form="form1"></td>
							</tr>							
							<tr id="objetivo" style="display:none;">
								<td align="right"><b><cf_translate key="LB_Objetivo">Objetivo</cf_translate>:</b>&nbsp;</td>
								<td colspan="3">									
									<cf_conlis title="#LB_ListaDeObjetivos#"
									campos = "RHOSid,RHOScodigo,RHOStexto" 
									desplegables = "N,S,S" 
									modificables = "N,S,N" 
									size = "0,15,50"
									asignar="RHOSid,RHOScodigo,RHOStexto"
									asignarformatos="I,S,S"
									tabla="RHObjetivosSeguimiento"																	
									columnas="RHOSid,RHOScodigo,RHOStexto"
									filtro="Ecodigo =#session.Ecodigo#"
									desplegar="RHOScodigo,RHOStexto"
									etiquetas="	#LB_Codigo#, 
												#LB_Descripcion#"
									formatos="S,S"
									align="left,left"
									showEmptyListMsg="true"
									debug="false"
									form="form1"
									width="800"
									height="500"
									left="70"
									top="20"
									filtrar_por="RHOScodigo,RHOStexto">
								</td>
							</tr>	
							<tr>
								<td colspan="4">
									<table align="center">
										<tr>
											<td>
												<input type="radio" value="1" name="opt" id="1" onClick="javascript: funcCambio();" checked>
												<label for="1"><cf_translate key="LB_General">General</cf_translate></label>
											</td>
											<!---
											<td>
												<input type="radio" value="2" name="opt" id="2" onClick="javascript: funcCambio();">
												<label for="2"><cf_translate key="LB_PorObjetivo">Por Objetivo</cf_translate></label>
											</td>
											---->
											<td>
												<input type="radio" value="3" name="opt" id="3" onClick="javascript: funcCambio();">
												<label for="3"><cf_translate key="LB_PorPersona">Por Persona</cf_translate></label>
											</td>
										</tr>
									</table>
								</td>
							</tr>						
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td colspan="4" align="center">
									<cfoutput><input type="submit" name="btnConsultar" value="#BTN_Consultar#"></cfoutput>
								</td>
							</tr>
						</table>
					</form>
				</td>
			</tr>
		</table>
		<cfoutput>
			<script type="text/javascript">
				function funcValida(){
					if(document.form1.RHDRid.value==''){
						alert('#MSG_DebeSeleccionarUnaEvaluacion#');
						return false;
					}
					if (document.form1.opt[1].checked){//OBJETIVO
						if(document.form1.DEid.value == ''){
							alert('#MSG_DebeSeleccionarUnEmpleado#');
							return false;				
						}
					}
					return true;
				}
				
				function funcCambio(){
					/*Limpia el conlis de empleados*/
					document.form1.DEid.value='';				
					document.form1.NombreEmp.value='';
					document.form1.DEidentificacion.value='';
					/*Limpia el conlis de objetivos*/
					document.form1.RHOSid.value = '';
					document.form1.RHOScodigo.value = '';
					document.form1.RHOStexto.value= '';
					/*Mostrar/esconder conlis*/
					if(document.form1.opt[1].checked){//EMPLEADO
						document.getElementById('empleado').style.display = '';
						document.getElementById('objetivo').style.display = 'none';
					}
					else{//GENERAL
						document.getElementById('empleado').style.display = 'none';
						document.getElementById('objetivo').style.display = 'none';
					}
					/*else{
						if (document.form1.opt[1].checked){//OBJETIVO
							document.getElementById('empleado').style.display = 'none';
							document.getElementById('objetivo').style.display = '';
						}
						
					}*/
				}
			</script>
		</cfoutput>
	<cf_web_portlet_end>	
<cf_templatefooter>