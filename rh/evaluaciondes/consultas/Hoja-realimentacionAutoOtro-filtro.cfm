
<!--- VARIABLES DE TRADUCCION --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_nav__SPdescripcion" default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinvoke key="BTN_Consultar" default="Consultar" returnvariable="BTN_Consultar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke Key="MSG_ElCampoEvaluacionEsRequerido" Default="El campo Evaluación es requerido" returnvariable="MSG_ElCampoEvaluacionEsRequerido" component="sif.Componentes.Translate"method="Translate"/>
<cfinvoke Key="MSG_SePresentaronLosSiguientesErrores" Default="Se presentaron los siguientes errores" returnvariable="MSG_SePresentaronLosSiguientesErrores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_SePresentaronLosSiguientesErrores" Default="Se presentaron los siguientes errores" returnvariable="MSG_SePresentaronLosSiguientesErrores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Evaluador" Default="Evaluador" returnvariable="LB_Evaluador" component="sif.Componentes.Translate" method="Translate"/>
<!----<cfinvoke Key="LB_Identificacion" Default="Identificacion" returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate"/>---->
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
					<form name="form1" method="post" action="Hoja-realimentacionAutoOtro.cfm" style="margin:0; " onsubmit="javascript: return validar(this);">
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
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Evaluacion_Jefes">Evaluaci&oacute;n Jefe</cf_translate>:&nbsp;</td>
										<td ><cf_rhevaluacion size="60" RHEEdescripcion="RHEEdescripcion" RHEEid="RHEEid" tipo = "0" Cerradas = "S" ></td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Jefe">Jefe</cf_translate>:&nbsp;</td>
										<td ><cf_rhempleadoscap></td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Evaluacion_Otros">Evaluaci&oacute;n Otros</cf_translate>:&nbsp;</td>
										<td ><cf_rhevaluacion size="60" RHEEdescripcion="EvaJefe"  RHEEid="RHEEOtroid" tipo = "0" Cerradas = "S"></td>
									</tr>
									
									<tr>
									<td width="10%" align="right" nowrap ><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</td>
									<td><cf_rhcfuncional tabindex="1"></td>
								</tr>
								<tr>
									<td nowrap width="35%" align="right" ></td>
									<td nowrap width="65%" >
										<table width="100%" cellpadding="0" cellspacing="0">
											<tr>
												<td width="1%" valign="middle">
													<input type="checkbox" name="dependencias" id="dependencias" tabindex="1">
												</td>
												<td valign="middle">
													<label for="dependencias" style="font-style:normal; font-variant:normal; font-weight:normal">
													<cf_translate key="LB_Incluir_Dependencias">Incluir Dependencias</cf_translate>&nbsp;
													</label>
												</td>
											</tr>
										</table>
									</td>
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
							if ( form.RHEEOtroid.value == '' ){
								mensaje += ' - El campo de evaluación otros es requerido.\n';
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