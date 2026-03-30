<!---modifica para subir nuevamente y agregar en parche--->
<cfsetting requesttimeout="8600">
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/rh/generales.xml"/>
<cfinvoke key="LB_FuncionariosPorTipoDeNombramiento" default="Funcionarios por Tipo de Comportamiento" returnvariable="LB_FuncionariosPorTipoDeNombramiento" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Consultar" default="Consultar" returnvariable="BTN_Consultar" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/rh/generales.xml"/>
<cfinvoke key="LB_ListaDePuestos" default="Lista de Puestos" returnvariable="LB_ListaDePuestos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Codigo" default="Codigo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripcion" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>				
<cfinvoke key="LB_ListaDeTiposDeNombramiento" default="Lista de Tipos de Nombramiento" returnvariable="LB_ListaDeTiposDeNombramiento" component="sif.Componentes.Translate" method="Translate"/>								
<cfinvoke Key="MSG_DebeSeleccionarUnaFechaDeInicioYUnaFechaFinal" Default="Debe seleccionar una fecha de inicio y una fecha final" returnvariable="MSG_DebeSeleccionarUnaFechaDeInicioYUnaFechaFinal" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

<cf_templatecss>
<link href="../../css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
	<!--
	function MM_reloadPage(init) {  //reloads the window if Nav4 resized
	  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
		document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
	  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
	}
	MM_reloadPage(true);
	//-->
</script>

	  <cfinclude template="../../Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>
		<cfoutput>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">                	
					<cf_web_portlet_start titulo="#LB_FuncionariosPorTipoDeNombramiento#" >
						<cfinclude template="../../portlets/pNavegacionPago.cfm">
						<form style="margin:0 " name="form1" method="post" action="repFuncionariosComportamiento-rep.cfm" onsubmit="javascript: return funcValidar();">
							<table width="100%" cellpadding="0" cellspacing="0" border="0">
								<tr><td colspan="2">&nbsp;</td></tr>
								<tr>
									<td align="right"><strong><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</strong></td>										
									<td>
										<table>
											<tr>
												<td>													
													<cf_rhcfuncional form="form1" name="CFcodigoI" desc="CFdescripcionI" id="CFidI" codigosize='15' size='60' >
												</td>
												<td>&nbsp;</td>
												<td>
													<input type="checkbox" name="dependencias" value="dependencias" <cfif isdefined("form.dependencias")>checked</cfif>>
													<label for="dependencias"><cf_translate  key="LB_IncluirDependencias">Incluir dependencias</cf_translate></label>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td align="right"><strong><cf_translate key="LB_Puesto">Puesto</cf_translate>:</strong>&nbsp;</td>
									<td>
										<cf_conlis title="#LB_ListaDePuestos#"
											campos = "RHPcodigo,RHPdescpuesto" 
											desplegables = "S,S" 
											modificables = "S,N" 
											size = "10,30"
											asignar="RHPcodigo,RHPdescpuesto"
											asignarformatos="S,S"
											tabla="RHPuestos"																	
											columnas="RHPcodigo,RHPdescpuesto"
											filtro="Ecodigo =#session.Ecodigo#"
											desplegar="RHPcodigo,RHPdescpuesto"
											etiquetas="#LB_Codigo#,#LB_Descripcion#"
											formatos="S,S"
											align="left,left"
											showEmptyListMsg="true"
											debug="false"
											form="form1"
											width="800"
											height="500"
											left="70"
											top="20"
											filtrar_por="RHPcodigo,RHPdescpuesto">			
									</td>
								</tr>
								<tr>
									<td align="right"><strong><cf_translate key="LB_TipoNombramiento">Tipo de Nombramiento</cf_translate>:</strong>&nbsp;</td>
									<td>
										<cf_conlis title="#LB_ListaDeTiposDeNombramiento#"
											campos = "RHTid,RHTcodigo,RHTdesc" 
											desplegables = "N,S,S" 
											modificables = "N,S,N" 
											size = "0,10,30"
											asignar="RHTid,RHTcodigo,RHTdesc"
											asignarformatos="N,S,S"
											tabla="RHTipoAccion"																	
											columnas="RHTid,RHTcodigo,RHTdesc"
											filtro="Ecodigo =#session.Ecodigo# and RHTcomportam = 1"
											desplegar="RHTcodigo,RHTdesc"
											etiquetas="#LB_Codigo#,#LB_Descripcion#"
											formatos="S,S"
											align="left,left"
											showEmptyListMsg="true"
											debug="false"
											form="form1"
											width="800"
											height="500"
											left="70"
											top="20"
											filtrar_por="RHTcodigo,RHTdesc">			
									</td>
								</tr>																					
								<tr>
									<td align="right"><strong><cf_translate key="LB_FechaDesde">Fecha Desde</cf_translate>:</strong>&nbsp;</td>
									<td>
										<table>
											<tr>												
												<td>
													<cf_sifcalendario name="finicio" value="" tabindex="5" form="form1">
												</td>
												<td width="5%">&nbsp;</td>
												<td align="right"><strong><cf_translate key="LB_FechaHasta">Fecha Hasta</cf_translate>:</strong>&nbsp;</td>
												<td>
													<cf_sifcalendario name="ffin" value="" tabindex="5" form="form1">
												</td>												
											</tr>
										</table>
									
									</td>
									
								</tr>
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td colspan="2" align="center">
										<input type="submit" name="btn_consultar" value="#BTN_Consultar#"/>
									</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
							</table>
						</form>
	         		<cf_web_portlet_end>
				</td>	
			</tr>
		</table>
		<script type="text/javascript">
			function funcValidar(){
				if (document.form1.finicio.value ==''){
					alert('#MSG_DebeSeleccionarUnaFechaDeInicioYUnaFechaFinal#');
					return false;
				}
				return true;
			}
			
		</script>
		
		</cfoutput>					
	<cf_templatefooter>