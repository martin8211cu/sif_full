<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<br>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td width="1%" valign="top">
				<cfinclude template="/sif/menu.cfm">
			</td>
			<td valign="top">
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Perfil de Competencias'>
									

							<cfset navBarItems[1]  = "Calificaciones del Empleado">
							<cfset navBarLinks[1]  = "/cfmx/home/menu/pNavegacion.cfm">
							<cfset navBarStatusText[1]  = "Calificaciones del Empleado">
							<!--- <cfset Regresar  = "/cfmx/home/menu/modulo.cfm?s=RH&m=EVAL"> --->
							
							<cfinclude template="/rh/portlets/pNavegacion.cfm">
							<form name="form1" id="form1">
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
								  <tr>
								  	<td align="center" colspan="2" nowrap>
										<font size="+2"><cf_translate key="LB_PerfilDeCompetencias">Perfil de Competencias</cf_translate></font>
									  	
									</td>
								  </tr>
								  <tr>
									<td align="center">
										<cf_translate key="LB_SeleccioneLaRelacionQueDeseaImprimir">Seleccione la relaci&oacute;n que desea imprimir</cf_translate>
									</td>
								  </tr>
								  <tr>
									  <td>
									  </td>
								  </tr>
								  <tr>
									<td  align="center">
										<strong><cf_translate key="LB_Formato" XmlFile="/rh/generales.xml">Formato</cf_translate>:&nbsp;</strong>
										<select name="format" id="format">
											<option value="html"><cf_translate key="LB_EnLineaHTML">En l&iacute;nea (HTML)</cf_translate></option>
											<option value="pdf"><cf_translate key="LB_PDF" XmlFile="/rh/generales.xml">PDF</cf_translate></option> 
											<option value="excel"><cf_translate key="LB_Excel" XmlFile="/rh/generales.xml">Excel</cf_translate></option>
										</select>
										
									</td>
									<td  align="center">
										<cfoutput>
											<strong><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>:</strong>
											<cf_rhcfuncional  id="id_centro" tabindex="1">
										</cfoutput>
									</td>
								  </tr>
								</table>
							</form>
							
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="3">
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Descripcion"
										Default="Descripci&oacute;n"
										XmlFile="/rh/generales.xml"
										returnvariable="LB_Descripcion"/>
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Fecha"
										Default="Fecha"
										XmlFile="/rh/generales.xml"
										returnvariable="LB_Fecha"/>
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="MSG_NOSEHAREGISTRADONINGUNAEVALUACION"
										Default="NO SE HA REGISTRADO NINGUNA EVALUACION"
										returnvariable="MSG_NOSEHAREGISTRADONINGUNAEVALUACION"/>
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="MSG_DebeEscogerUnCentroFuncional"
										Default="Debe escoger un Centro Funcional"
										returnvariable="MSG_DebeEscogerUnCentroFuncional"/>
									<cfinvoke 
										 component="rh.Componentes.pListas"
										 method="pListaRH"
										 returnvariable="pListaRHRet">
											<cfinvokeargument name="tabla" value="RHEEvaluacionDes a"/>
											<cfinvokeargument name="columnas" value="a.RHEEid, a.RHEEdescripcion, convert(varchar,a.RHEEfecha,103) as RHEEfecha "/>
											<cfinvokeargument name="desplegar" value="RHEEdescripcion, RHEEfecha "/>
											<cfinvokeargument name="etiquetas" value="#LB_Descripcion#, #LB_Fecha#"/>
											<cfinvokeargument name="formatos" value="S, S"/>
											<cfinvokeargument name="filtro" value="a.Ecodigo = #session.Ecodigo# and a.RHEEestado in (3)"/>
											<cfinvokeargument name="align" value="left, center"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="funcion" value="reporte"/>
											<cfinvokeargument name="fparams" value="RHEEid"/>
											<cfinvokeargument name="checkboxes" value="N">
<!--- 												<cfinvokeargument name="keys" value="RHEEid"> 
												<cfinvokeargument name="formName" value="listaEvaluaciones">
												<cfinvokeargument name="incluyeform" value="false">--->
											<!--- <cfinvokeargument name="cortes" value="RHPdescpuesto"> --->
											<cfinvokeargument name="showEmptyListMsg" value="true">
											<cfinvokeargument name="EmptyListMsg" value="*** #MSG_NOSEHAREGISTRADONINGUNAEVALUACION# ***">
											<!--- <cfinvokeargument name="navegacion" value="#navegacion#"> --->
								  </cfinvoke>
								</td>
							</tr>
				
							
						</table>
						<script type="text/javascript">
							function reporte(RHEEid){

								if (document.form1.id_centro.value != "") {
									location.href='Perfil-rep.cfm?format='+document.form1.format.value+'&RHEEid='+RHEEid+'&id_centro='+document.form1.id_centro.value;
								}
								else {
									alert("<cfoutput>#MSG_DebeEscogerUnCentroFuncional#</cfoutput>l");
								}
							}
						</script>
					<cf_web_portlet_end>	
			</td>	
		</tr>
	</table>	
<cf_templatefooter>