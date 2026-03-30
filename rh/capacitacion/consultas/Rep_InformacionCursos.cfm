<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="<cfoutput>#LB_RecursosHumanos#</cfoutput>">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_ReporteInformacionDetalladaDeCursos"
				Default="Reporte información detallada de cursos"
				returnvariable="LB_ReporteInformacionDetalladaDeCursos"/> 
								
				
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_ReporteInformacionDetalladaDeCursos#">
					<form name="form1" method="get" 
							action="Rep_InformacionCursos-form.cfm" style="margin:0; " onSubmit="javascript: return validar(this);">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td width="5%">&nbsp;</td>
							<td width="40%" align="center" valign="top">
								<cf_web_portlet_start border="true" titulo="#LB_ReporteInformacionDetalladaDeCursos#" skin="info1">
									<table width="100%" align="center">
										<tr><td><p>
										<cf_translate  key="AYUDA_ReporteInformacionDetalladaDeCursos">
											Este reporte muestra la información de un determinado de un curso y los correpondientes empleados que se encuentran en el curso
										</cf_translate>
										.</p></td></tr>
									</table>
								<cf_web_portlet_end>
							</td>
							<td colspan="2" valign="top">
								<table width="100%" align="center" cellpadding="2" cellspacing="0" >
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Curso">Curso</cf_translate>:&nbsp;</td>
										<td>
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_ListadoDeCursos"
										Default="Listado de Cursos"
										returnvariable="LB_ListadoDeCursos"/> 
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Codigo"
										Default="Código"
										XmlFile="/rh/generales.xml"
										returnvariable="LB_Codigo"/> 
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Descripcion"
										Default="Descripción"
										XmlFile="/rh/generales.xml"
										returnvariable="LB_Descripcion"/> 
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_inicia"
										Default="Inicia"
										returnvariable="LB_inicia"/>
										
										<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Finaliza"
										Default="Finaliza"
										returnvariable="LB_Finaliza"/>
										
										<cf_conlis
											Campos="RHCid,RHCcodigo,RHCnombre"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,40"
											
											Title="#LB_ListadoDeCursos#"
											Tabla="RHCursos a
													inner join RHMateria b
													on a.Mcodigo = b.Mcodigo
													and CEcodigo = #session.CEcodigo#"
											tabindex="1"
											Columnas="RHCid,RHCcodigo,RHCnombre,RHCfdesde,RHCfhasta"
											Filtro="1=1 order by RHCfdesde desc,RHCnombre"
											Desplegar="RHCcodigo,RHCnombre,RHCfdesde,RHCfhasta"
											Etiquetas="#LB_Codigo#,#LB_Descripcion#,#LB_inicia#,#LB_Finaliza#"
											filtrar_por="RHCcodigo,RHCnombre,RHCfdesde,RHCfhasta"
											Formatos="S,S,D,D"
											Align="left,left,left,left"
											Asignar="RHCid,RHCcodigo,RHCnombre"
											Asignarformatos="I,S,S"/>
										</td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Formato">Formato</cf_translate>&nbsp;:</td>
										<td>
											<select name="formato" tabindex="1">
												<option value="flashpaper"><cf_translate  key="LB_Flashpaper">Flashpaper</cf_translate></option>
												<option value="pdf"><cf_translate  key="LB_PDF">PDF</cf_translate></option>
												<option value="excel"><cf_translate  key="LB_Excel">Excel</cf_translate></option>
											</select>
										</td>
									</tr>
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td align="center" colspan="2">
											<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="BTN_Limpiar"
											Default="Limpiar"
											XmlFile="/rh/generales.xml"
											returnvariable="BTN_Limpiar"/>
											
											<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="BTN_Consultar"
											Default="Consultar"
											XmlFile="/rh/generales.xml"
											returnvariable="BTN_Consultar"/>
										
											<cfoutput>
												<input type="submit" name="Consultar" value="#BTN_Consultar#" tabindex="1">&nbsp;
												<input type="reset" name="btnLimpiar" value="#BTN_Limpiar#" tabindex="1">
											</cfoutput>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					</form>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_SePresentaronLosSiguientesErrores"
					Default="Se presentaron los siguientes errores"
					XmlFile="/rh/generales.xml"
					returnvariable="MSG_SePresentaronLosSiguientesErrores"/>
					
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_ElCampocurso"
					Default="El campo curso"
					returnvariable="MSG_ElCampocurso"/>

					
					
					<script language="javascript1.2" type="text/javascript">
						<cfoutput>
						function validar(form){
							var mensaje = '';
							if ( form.RHCid.value == '' ){
								mensaje += ' - #MSG_ElCampocurso#.\n';
							}
						
							if ( mensaje != '' ){
								mensaje = '#MSG_SePresentaronLosSiguientesErrores#:\n' + mensaje;
								alert(mensaje);
								return false;
							}
							
							return true;
						}
						</cfoutput>
						document.form1.RHCcodigo.focus();
					</script>
				<cf_web_portlet_end>
			</td></tr>
		</table>
<cf_templatefooter>