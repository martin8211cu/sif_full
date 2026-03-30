<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_nav__SPdescripcion" default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinvoke key="BTN_Consultar" default="Consultar" returnvariable="BTN_Consultar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke Key="MSG_ElCampoEvaluacionEsRequerido" Default="El campo Evaluación es requerido" returnvariable="MSG_ElCampoEvaluacionEsRequerido" component="sif.Componentes.Translate"method="Translate"/>
<cfinvoke Key="MSG_SePresentaronLosSiguientesErrores" Default="Se presentaron los siguientes errores" returnvariable="MSG_SePresentaronLosSiguientesErrores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_SePresentaronLosSiguientesErrores" Default="Se presentaron los siguientes errores" returnvariable="MSG_SePresentaronLosSiguientesErrores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Evaluador" Default="Evaluador" returnvariable="LB_Evaluador" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_ListaDeEvaluadores" Default="Lista de Evaluadores" returnvariable="LB_ListaDeEvaluadores" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cfquery name="rsEscalas" datasource="#Session.DSN#">
	select RHEid ,RHEdescripcion, RHEdefault
	from RHEscalas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cf_templateheader title="#LB_nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_nav__SPdescripcion#">
					<form name="form1" method="post" action="Hoja-realimentacion.cfm" style="margin:0; " onsubmit="javascript: return validar(this);">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td width="5%">&nbsp;</td>
							<td width="50%" align="center" valign="top">
								<cf_web_portlet_start border="true" titulo="#LB_nav__SPdescripcion#" skin="info1">
									<table width="100%" align="center">
										<tr><td><p>
										<cf_translate  key="Ayuda_Reporte">
											En este reporte se puede consultar las notas obtenidas de un empleado para una determinada evaluaci&oacute;n por habilidades		
										</cf_translate>
										</p></td></tr>
									</table>
								<cf_web_portlet_end>
							</td>
							<td colspan="2" valign="top">
								<table width="90%" align="center" cellpadding="2" cellspacing="0">
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Evaluacion">Evaluaci&oacute;n</cf_translate>:&nbsp;</td>
										<td ><cf_rhevaluacion size="60" tipo = "1" Cerradas = "S"></td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Empleado">Empleado</cf_translate>:&nbsp;</td>
										<td ><cf_rhempleadoscap></td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Escala_de_calificaci&oacute;n">Escala de calificaci&oacute;n</cf_translate>:&nbsp;</td>
										<td>
											<cfif isdefined("rsEscalas") and rsEscalas.recordCount GT 0>
												<select name="RHEid"  tabindex="1">
													<cfoutput><cfloop query="rsEscalas">
													<option value="#RHEid#"<cfif isdefined("rsEscalas.RHEdefault") and rsEscalas.RHEdefault EQ 1> selected</cfif>>
														#RHEdescripcion#</option>
													</cfloop></cfoutput>
												</select>
											<cfelse>
												<select name="RHEid"  tabindex="1">
													<option value="100">1-100</option>
												</select>
											</cfif>
										</td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Jefe">Jefe</cf_translate>:&nbsp;</td>
										<td>											
											<cf_dbfunction name="concat" args="c.DEapellido1,' ',c.DEapellido2,' ',c.DEnombre" returnvariable="nombre">											
											<cf_conlis title="#LB_ListaDeEvaluadores#"
												campos="DEideval,nombre" 
												desplegables = "S,S" 
												modificables = "S,S" 
												size = "10,45"
												asignar="DEideval,nombre"
												asignarformatos="S,S"
												tabla="	RHEEvaluacionDes a
														inner join RHEvaluadoresDes b
															on a.RHEEid = b.RHEEid
															and b.RHEDtipo in ('J','E')
														inner join DatosEmpleado c
															on b.DEideval = c.DEid
															and a.Ecodigo = c.Ecodigo"																	
												columnas="distinct(b.DEideval),#nombre# as nombre"
												filtro="a.Ecodigo =#session.Ecodigo# and a.RHEEid = $RHEEid,numeric$"
												desplegar="nombre"
												etiquetas="#LB_Evaluador#"
												formatos="S"
												align="left"
												showEmptyListMsg="true"
												form="form1"
												width="800"
												height="500"
												left="70"
												top="20"
												filtrar_por="DEidentificacion,#nombre#"
												>
										</td>
									</tr>
									<tr>
										<td>&nbsp;</td>
										<td><input name="chk360" type="checkbox" id="chk360"> <label for="chk360" style="font-style:normal; font-variant:normal; font-weight:normal">360</label></td>
									</tr>
									<tr>
										
										<td colspan="2" align="center">
											<input type="submit" name="Consultar" value="<cfoutput>#BTN_Consultar#</cfoutput>">
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
							var mensaje = '';
							<cfoutput>
							if ( form.RHEEdescripcion.value == '' ){
								mensaje += ' - #MSG_ElCampoEvaluacionEsRequerido#.\n';
							}
							if ( mensaje != '' ){
								mensaje = '#MSG_SePresentaronLosSiguientesErrores#:\n' + mensaje;
								alert(mensaje);
								return false;
							}
							</cfoutput>
							return true;
						}
						
					</script>
				<cf_web_portlet_end>
			</td></tr>
		</table>
		<iframe id="iframe_evaluador" name="iframe_evaluador" width="0" height="0" frameborder="0" style="visibility:hidden;" ></iframe>
<cf_templatefooter>