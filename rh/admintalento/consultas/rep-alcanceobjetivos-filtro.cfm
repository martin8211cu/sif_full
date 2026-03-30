<cfinvoke key="LB_nav__SPdescripcion" default="Reporte de Alcance de Objetivos"  returnvariable="LB_nav__SPdescripcion" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Codigo" default="Codigo"  returnvariable="LB_Codigo" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripcion"  returnvariable="LB_Descripcion" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_ListaDeTiposDeObjetivo" default="Lista de Tipos de Objetivo"  returnvariable="LB_ListaDeTiposDeObjetivo" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="BTN_Consultar" default="Consultar"  returnvariable="BTN_Consultar" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_ListaDeEvaluaciones" default="Lista de Evaluaciones"  returnvariable="LB_ListaDeEvaluaciones" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_FechaInicio" default="Fecha Inicio"  returnvariable="LB_FechaInicio" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_FechaFinaliza" default="Fecha Finaliza"  returnvariable="LB_FechaFinaliza" component="sif.Componentes.Translate"  method="Translate"/>

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
						<p><br><cf_translate key="LB_ReporteDeAlcanceDeLosObjetivos">Reporte que muestra el porcentaje de alcance de los objetivos en las diferentes evaluaciones</cf_translate></p><br>
					<cf_web_portlet_end>	
				</td>
				<td width="60%" valign="top">
					<form name="form1" method="post" action="rep-alcanceobjetivos-rep.cfm">
						<table width="100%" cellpadding="2" cellspacing="0">							
							<tr>
								<td align="right"><b><cf_translate key="LB_Empleado">Empleado</cf_translate>:</b>&nbsp;</td>
								<td><cf_rhempleado tabindex="1" size="25" form="form1"></td>
							</tr>							
							<tr>
								<td align="right"><b><cf_translate key="LB_Evaluacion">Evaluaci&oacute;n</cf_translate>:</b>&nbsp;</td>
								<td>
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
							<tr>
								<td align="right"><b><cf_translate key="LB_TipoObjetivo">Tipo de objetivo</cf_translate>:</b>&nbsp;</td>
								<td>									
									<cf_conlis title="#LB_ListaDeTiposDeObjetivo#"
									campos = "RHTOid,RHTOcodigo,RHTOdescripcion" 
									desplegables = "N,S,S" 
									modificables = "N,S,N" 
									size = "0,10,30"
									asignar="RHTOid,RHTOcodigo,RHTOdescripcion"
									asignarformatos="I,S,S"
									tabla="RHTipoObjetivo "																	
									columnas="RHTOid,RHTOcodigo,RHTOdescripcion"
									filtro="Ecodigo =#session.Ecodigo#"
									desplegar="RHTOcodigo,RHTOdescripcion"
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
									filtrar_por="RHTOcodigo,RHTOdescripcion">
								</td>
							</tr>
							<tr>
								<td align="right"><b><cf_translate key="LB_FechaDesde">Fecha desde</cf_translate>:</b>&nbsp;</td>
								<td>
									<cf_sifcalendario name="finicio" value="" tabindex="4" form="form1">
								</td>
							</tr>
							<tr>
								<td align="right"><b><cf_translate key="LB_FechaHasta">Fecha hasta</cf_translate>:</b>&nbsp;</td>
								<td>
									<cf_sifcalendario name="ffin" value="" tabindex="5" form="form1">
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