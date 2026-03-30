<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title"><cf_translate  XmlFile="/rh/generales.xml" key="LB_RecursosHumanos">Recursos Humanos</cf_translate></cf_templatearea>
	
	<cf_templatearea name="body">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_BrechasDeCapacitacion"
				Default="Brechas de Capacitación"
				returnvariable="LB_BrechasDeCapacitacion"/> 
				<script  language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>

				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_BrechasDeCapacitacion#">
					<form name="form1" method="get" action="brechas-capacitacion.cfm" style="margin:0; " onSubmit="javascript: return validar(this);">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td width="5%">&nbsp;</td>
							<td width="40%" align="center" valign="top">
								<cf_web_portlet_start border="true" titulo="#LB_BrechasDeCapacitacion#" skin="info1">
									<table width="100%" align="center">
										<tr><td><p>
										<cf_translate  key="AYUDA_EstaConsultaMuestraUnListadoLosColaboradoresAgrupadosPorCentroFuncionalQueRequierenCapacitacion">
											Esta consulta muestra un listado los colaboradores agrupados por Centro Funcional que requieren capacitaci&oacute;n.
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
									</tr>
									
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Puesto">Puesto</cf_translate>:&nbsp;</td>
										<td ><cf_rhpuesto></td>
									</tr>
									
									<tr>
										<td nowrap align="right"><cf_translate  key="LB_TipoDeCompetencia">Tipo de Competencia</cf_translate>:&nbsp;</td>
										<td>
											<select name="tipo" onChange="javascript: cambio_tipo(this.value);">
												<option value=""><cf_translate  key="CMB_Todos">Todos</cf_translate></option>
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
										<td align="right"><cf_translate  key="LB_Empleado">Empleado</cf_translate>:&nbsp;</td>
										<td><cf_rhempleado></td>
									</tr>

									<tr>
										<td></td>
										<td>
											<table width="50%" cellpadding="0" cellspacing="0">
												<tr>
													<td width="1%" valign="middle"><input   type="radio" checked value="R" name="resumido"></td>
													<td valign="middle"><cf_translate  key="LB_Resumido">Resumido</cf_translate></td>
													<td width="1%" valign="middle"><input  type="radio" value="D" name="resumido"></td>
													<td valign="middle"><cf_translate  key="LB_Detallado">Detallado</cf_translate></td>
												</tr>
											</table>
										</td>
									</tr>
									
									<tr id="id_B">
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_BrechaMayorQue">Brecha mayor que</cf_translate>
										  :&nbsp;</td>
										<td >
											<input name="Brecha" id="Brecha" type="text" value="" 
												maxlength="6" 
												size="6" 
												style=" text-align:right "
												onBlur="javascript:fm(this,0)" 
												onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
										</td>
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
						
						function muestra_brecha(valor){
							if ( valor == 'S' ){
								document.getElementById("id_B").style.display = '';
							}
							else{
								document.getElementById("id_B").style.display = 'none';
							}
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