<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title"><cf_translate  XmlFile="/rh/generales.xml" key="LB_RecursosHumanos">Recursos Humanos</cf_translate></cf_templatearea>
	
	<cf_templatearea name="body">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_PlanDeCompetenciasADesarrollar"
				Default="Plan de competencias a desarrollar"
				returnvariable="LB_PlanDeCompetenciasADesarrollar"/> 
				
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_PlanDeCompetenciasADesarrollar#">
					<form name="form1" method="get" action="PlanCompetencias.cfm" style="margin:0; " onSubmit="javascript: return validar(this);">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td width="5%">&nbsp;</td>
							<td width="40%" align="center" valign="top">
								<cf_web_portlet_start border="true" titulo="#LB_PlanDeCompetenciasADesarrollar#" skin="info1">
									<table width="100%" align="center">
										<tr><td><p>
										<cf_translate  key="AYUDA_PlanDeCompetenciasADesarrollar">
											Este reporte permite visualizar aquellas competencias  que un empleado no cumple con la valoración mínima 
										</cf_translate>
										</p></td></tr>
									</table>
								<cf_web_portlet_end>
							</td>
							<td colspan="2" valign="top">
								<table width="90%" align="center" cellpadding="2" cellspacing="0">
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:&nbsp;</td>
										<td ><cf_rhcfuncional></td>
									</tr>
									<tr>
										<td></td>
										<td>
											<table width="100%" cellpadding="0" cellspacing="0">
												<tr>
													<td width="1%" valign="middle"><input type="checkbox" name="dependencias"></td>
													<td valign="middle"><cf_translate  key="LB_IncluyeDependencias">Incluye Dependencias</cf_translate></td>
												</tr>
											</table>
										</td>
									<tr>
										<td align="right"><cf_translate  key="LB_Empleado">Empleado</cf_translate>:&nbsp;</td>
										<td><cf_rhempleado></td>
									</tr>
									
									<tr>
										<td nowrap align="right"><cf_translate  key="LB_TipoDeCompetencia">Tipo de Competencia</cf_translate>:&nbsp;</td>
										<td>
											<select name="tipo" onChange="javascript: cambio_tipo(this.value);">
												<option value="T"><cf_translate  key="CMB_Todos">Todos</cf_translate></option>
												<option value="C"><cf_translate  key="CMB_Conocimientos">Conocimientos</cf_translate></option>
												<option value="H"><cf_translate  key="CMB_Habilidades">Habilidades</cf_translate></option>																								
											</select>
										</td>
									</tr>
									
									<tr id="id_h">
										<td align="right"><cf_translate  key="LB_Habilidad">Habilidad</cf_translate>:&nbsp;</td>
										<td><cf_rhhabilidad></td>
									</tr>
									
									<tr id="id_c">
										<td align="right"><cf_translate  key="LB_Conocimiento">Conocimiento</cf_translate>:&nbsp;</td>
										<td><cf_rhconocimiento></td>
									</tr>

									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="Formato">Formato</cf_translate>:&nbsp;</td>
										<td>
											<select name="formato">
												<option value="flashpaper"><cf_translate  key="LB_Flashpaper">Flashpaper</cf_translate></option>
												<option value="pdf"><cf_translate  key="LB_PDF">PDF</cf_translate></option>
												<option value="excel"><cf_translate  key="LB_Excel">Excel</cf_translate></option>
											</select>
										</td>
									</tr>
									<tr>
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Consultar"
										Default="Consultar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Consultar"/>
										<cfoutput>
										<td colspan="2" align="center"><input type="submit" name="Consultar" value="#BTN_Consultar#"></td>
										</cfoutput>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					</form>
					
					<script language="javascript1.2" type="text/javascript">
						<cfoutput>
						function validar(form){
							var mensaje = '';
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="MSG_SePresentaronLosSiguientesErrores"
							Default="Se presentaron los siguientes errores"
							returnvariable="MSG_SePresentaronLosSiguientesErrores"/> 
												
							if ( mensaje != '' ){
								mensaje = '#MSG_SePresentaronLosSiguientesErrores#:\n' + mensaje;
								alert(mensaje);
								return false;
							}
							
							return true;
							
						}
						
						function cambio_tipo(valor){
							if ( valor == 'C' ){
								document.getElementById("id_c").style.display = '';
								document.getElementById("id_h").style.display = 'none';
								document.form1.RHHid.value = '';
								document.form1.RHHcodigo.value = '';
								document.form1.RHHdescripcion.value = '';
							}
							else if (valor == 'H') {
								document.getElementById("id_c").style.display = 'none';
								document.getElementById("id_h").style.display = '';
								document.form1.RHCid.value = '';
								document.form1.RHCcodigo.value = '';
								document.form1.RHCdescripcion.value = '';
							}
							else{
								document.getElementById("id_c").style.display = 'none';
								document.getElementById("id_h").style.display = 'none';
								document.form1.RHHid.value = '';
								document.form1.RHHcodigo.value = '';
								document.form1.RHHdescripcion.value = '';
								document.form1.RHCid.value = '';
								document.form1.RHCcodigo.value = '';
								document.form1.RHCdescripcion.value = '';
							}
						}

						cambio_tipo('');
						
						</cfoutput>
					</script>
				<cf_web_portlet_end>
			</td></tr>
		</table>
	</cf_templatearea>
</cf_template>