<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr><td>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_EvaluacionesPorColaborador"
					Default="Evaluaciones por Colaborador"
					returnvariable="LB_EvaluacionesPorColaborador"/>
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_EvaluacionesPorColaborador#">
				<form name="form1" method="get" action="RangoNotas.cfm" style="margin:0; " onSubmit="javascript: return validar(this);">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr>
						<td width="5%">&nbsp;</td>
						<td width="50%" align="center" valign="top">
							<cf_web_portlet_start border="true" titulo="#LB_EvaluacionesPorColaborador#" skin="info1">
								<table width="100%" align="center">
									<tr><td><p><cf_translate key="AYUDA_EstaConsultaMuestraUnListadoDeLasCalificacionesParaUnEmpleadoSegunLaRelacionDeEvaluacionYElRangoDeFechasSeleccionadas">Esta consulta muesta un listado de las calificaciones para un empleado seg&uacute;n la Relaci&oacute;n de Evaluaci&oacute;n y el Rango de Fechas seleccionado.<br>El campo Evaluaci&oacute;nes, el Colaborador, y escoger un tipo de Rango de Fecha son requeridos por la consulta.</cf_translate></p></td></tr>
								</table>
							<cf_web_portlet_end>
						</td>
						<td colspan="2" valign="top">
							<table width="90%" align="center" cellpadding="2" cellspacing="0">
								<tr>
									<td width="40%" align="right" nowrap><cf_translate key="LB_Evaluacion" XmlFile="/rh/generales.xml">Evaluaci&oacute;n</cf_translate>:&nbsp;</td>
									<td><cf_rhevaluacion size="60" tipo="1"></td>
								</tr>
								<tr>
									<td width="40%" align="right" nowrap><cf_translate key="LB_Empleado" XmlFile="/rh/generales.xml">Empleado</cf_translate>:&nbsp;</td>
									<td ><cf_rhempleadoscap></td>
								</tr>
								
								<tr>
								  <td align="left" colspan="2">
								  	<table width="100%"  cellpadding="0" cellspacing="0">
										<tr>
										  <td align="right"><table width="100%">
											  <tr>
												<td align="right" width="25%"><input name="nota" id="2" type="radio" value="2"  onclick="javascript: cambio()" <cfif isdefined("form.nota") and form.nota EQ 2>checked</cfif> /></td>
												<td align="left"><cf_translate key="LB_NotaMayorA">Nota mayor a</cf_translate>:</td>
											  </tr>
										  </table></td>
										  <td align="left">
										  	<input name="n_mayor" type="text" size="5" maxlength="3" 
											<cfif isdefined("form.nota") and form.nota EQ 2> <cfif isdefined("form.n_mayor") and len(trim(form.n_mayor)) NEQ 0> value="<cfoutput>#form.n_mayor#</cfoutput>"</cfif></cfif>
											/>
										  </td>
										</tr>
										<tr>
										  <td align="right"><table width="100%">
											  <tr>
												<td align="right"  width="25%"><input name="nota"id="3" type="radio" value="3"  onclick="javascript: cambio()" <cfif isdefined("form.nota") and form.nota EQ 3>checked</cfif> /></td>
												<td align="left" nowrap="nowrap"><cf_translate key="LB_NotaMenorA">Nota menor a</cf_translate>:</td>
											  </tr>
										  </table></td>
										  <td align="left">
											<input name="n_menor" type="text" size="5" maxlength="3" 
											<cfif isdefined("form.nota") and form.nota EQ 3> <cfif isdefined("form.n_menor") and len(trim(form.n_menor)) NEQ 0> value="<cfoutput>#form.n_menor#</cfoutput>"</cfif></cfif>
											/>
										  </td>
										</tr>
										<tr>
										  <td align="right"><table width="100%">
											  <tr>
												<td align="right"  width="25%"><input name="nota" id="1" type="radio" value="1" onclick="javascript: cambio()" <cfif isdefined("form.nota") and form.nota EQ 1>checked</cfif>/></td>
												<td align="left" nowrap="nowrap"><cf_translate key="LB_RangoDeNotas">Rango de notas</cf_translate>:</td>
											  </tr>
										  </table></td>
										  <td align="left"><table cellpadding="0" cellspacing="0">
											  <tr>
												<td><input name="n_inferior" type="text" size="5" maxlength="3"
													<cfif isdefined("form.nota") and form.nota EQ 1> <cfif isdefined("form.n_inferior") and len(trim(form.n_inferior)) NEQ 0> value="<cfoutput>#form.n_inferior#</cfoutput>"</cfif></cfif>
													/>
												  <cf_translate key="LB_Inferior">Inferior</cf_translate>&nbsp;</td>
												<td><input name="n_superior" type="text" size="5" maxlength="3"
													<cfif isdefined("form.nota") and form.nota EQ 1> <cfif isdefined("form.n_superior") and len(trim(form.n_superior)) NEQ 0> value="<cfoutput>#form.n_superior#</cfoutput>"</cfif></cfif>
													/>
												  <cf_translate key="LB_Superior">Superior</cf_translate>&nbsp;</td>
											  </tr>
										  </table></td>
										</tr>
									</table></td>
								</tr>
								<tr>
									<td width="40%" align="right" nowrap><cf_translate key="LB_Format" XmlFile="/rh/generales.xml">Formato</cf_translate>:&nbsp;</td>
									<td>
										<select name="formato">
											<option value="flashpaper"><cf_translate key="LB_Flashpaper" XmlFile="/rh/generales.xml">Flashpaper</cf_translate></option>
											<option value="pdf"><cf_translate key="LB_PDF" XmlFile="/rh/generales.xml">PDF</cf_translate></option>
											<option value="excel"><cf_translate key="LB_Excel" XmlFile="/rh/generales.xml">Excel</cf_translate></option>
										</select>
									</td>
								</tr>		
								<tr>
									<td colspan="2" align="center">
										<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="BTN_Consultar"
											Default="Consultar"
											XmlFile="/rh/generales.xml"
											returnvariable="BTN_Consultar"/>

										<input type="submit" name="Consultar" value="<cfoutput>#BTN_Consultar#</cfoutput>">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</table>
				</form>
					<!--- VARIABLES DE TRADUCCION --->
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_ElCampoEvaluacionEsRequerido."
						Default="El campo Evaluación es requerido."
						returnvariable="MSG_ElCampoEvaluacionEsRequerido"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_SePresentaronLosSiguientesErrores"
						Default="Se presentaron los siguientes errores"
						returnvariable="MSG_SePresentaronLosSiguientesErrores"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_DebeDigitarLaNotaInferiorYSuperiorParaElCampoRangoDeNota"
						Default="Debe digitar la nota inferior y superior para el campo: 'Rango de nota:'"
						returnvariable="MSG_DebeDigitarLaNotaInferiorYSuperiorParaElCampoRangoDeNota"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_DebeDigitarUnaNotaParaElCampoNotasMayorA"
						Default="Debe digitar una nota para el campo: 'Notas Mayor a:'"
						returnvariable="MSG_DebeDigitarUnaNotaParaElCampoNotasMayorA"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_DebeDigitarUnaNotaParaElCampoNotasMenorA"
						Default="Debe digitar una nota para el campo: 'Notas Menor a:'"
						returnvariable="MSG_DebeDigitarUnaNotaParaElCampoNotasMenorA"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_DebeDigitarUnaOpcionDeNota"
						Default="Debe digitar una opción de nota"
						returnvariable="MSG_DebeDigitarUnaOpcionDeNota"/>

				<script language="javascript1.2" type="text/javascript">
					function validar(form){
						var mensaje = '';
						
						if ( form.RHEEdescripcion.value == '' ){
							mensaje += ' - <cfoutput>#MSG_ElCampoEvaluacionEsRequerido#</cfoutput>.\n';
						}
						<!--- if ( form.DEid.value == '' ){
							mensaje += ' - El campo Empleado es requerido.\n';
						} --->

						if ( mensaje != '' ){
							mensaje = '<cfoutput>#MSG_SePresentaronLosSiguientesErrores#</cfoutput>:\n' + mensaje;
							alert(mensaje);
							return false;
						}
						
						if(document.form1.nota[2].checked)/*valida q exista la fecha superior y la fecha inferior*/
						{
							menor = form1.n_inferior.value;
							mayor = form1.n_superior.value;
							if ((menor == '')&&(mayor == ''))
							{
								alert("<cfoutput>#MSG_DebeDigitarLaNotaInferiorYSuperiorParaElCampoRangoDeNota#</cfoutput>");
								return false;
							}
							
							
						}
						else{ 
							if(document.form1.nota[0].checked)/*valida q exista la fecha mayor*/
							{
								mayor = form1.n_mayor.value;
								if (mayor == '')
								{
									alert("<cfoutput>#MSG_DebeDigitarUnaNotaParaElCampoNotasMayorA#</cfoutput>");
									return false;
								}
								
							}
							else
							{
								if(document.form1.nota[1].checked)/*valida q exista la fecha menor*/
								{
									menor = form1.n_menor.value;
									if (menor == '')
									{
										alert("<cfoutput>#MSG_DebeDigitarUnaNotaParaElCampoNotasMenorA#</cfoutput>");
										return false;
									}
									
								}
								else
								{
									alert('#<cfoutput>#MSG_DebeDigitarUnaOpcionDeNota#</cfoutput>#');
									return false;
								}		
							}
						}
						
						return true;
						
					}
					
					function cambio()
					{
						if(document.form1.nota[0].checked)/*valida q exista la fecha mayor*/
						{
							if(document.form1.n_mayor.value == "")
							document.form1.n_mayor.value= "0";
							
							document.form1.n_mayor.disabled= false;
							document.form1.n_menor.disabled= true;
							document.form1.n_inferior.disabled= true;
							document.form1.n_superior.disabled= true;
						}
						else if(document.form1.nota[1].checked)/*valida q exista la fecha mayor*/
						{
							if(document.form1.n_menor.value == "")
							document.form1.n_menor.value= "0";
							
							document.form1.n_mayor.disabled= true;
							document.form1.n_menor.disabled= false;
							document.form1.n_inferior.disabled= true;
							document.form1.n_superior.disabled= true;
						}
						
						else if(document.form1.nota[2].checked)/*valida q exista la fecha mayor*/
						{
							if(document.form1.n_inferior.value == "")
							document.form1.n_inferior.value= "0";
							
							if(document.form1.n_superior.value == "")
							document.form1.n_superior.value= "0";
								
							document.form1.n_mayor.disabled= true;
							document.form1.n_menor.disabled= true;
							document.form1.n_inferior.disabled= false;
							document.form1.n_superior.disabled= false;
						}
						else 
						{
							
							document.form1.nota[0].checked=true;/*opcion activa por defecto*/
							
							document.form1.n_mayor.value= "0";
							document.form1.n_menor.value= "";
							document.form1.n_inferior.value= "";
							document.form1.n_superior.value= "";
							
							document.form1.n_mayor.disabled= false;
							document.form1.n_menor.disabled= true;
							document.form1.n_inferior.disabled= true;
							document.form1.n_superior.disabled= true;
						}
						
					}
					
					cambio();

				</script>
				
				
			<cf_web_portlet_end>
		</td></tr>
	</table>
<cf_templatefooter>