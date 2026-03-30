<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Consulta_de_Ocupacion_de_Plazas"
	Default="Consulta de Ocupación de Plazas"
	returnvariable="LB_Consulta_de_Ocupacion_de_Plazas"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Consulta_de_Ocupacion_de_Plazas"
	Default="Consulta de Ocupación de Plazas"
	returnvariable="LB_Consulta_de_Ocupacion_de_Plazas"/>
	
	
<cfinvoke component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"
	Default="Código" Key="LB_Codigo" returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"
	Default="Descripción" Key="LB_Descripcion" returnvariable="LB_Descripcion"/>
	<!---<cf_dump var="#LB_Descripcion#">--->
<cfinvoke component="sif.Componentes.Translate" method="Translate" 
	Default="Listado de Plazas" Key="LB_ListadoDePlazas" returnvariable="LB_ListadoDePlazas"/>


	<script>window.jQuery || document.write('<script src="/cfmx/jquery/librerias/jquery-2.0.2.min.js"><\/script>')</script> 
	<script src="/cfmx/jquery/librerias/underscore-min.js"></script> 

<cf_templateheader title="#LB_Consulta_de_Ocupacion_de_Plazas#">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_ConsultadePlazas"
				Default="Consulta de Plazas"
				returnvariable="LB_ConsultadePlazas"/> 
								
				
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_ConsultadePlazas#">
					<form name="form1" method="post" action="consultaPlazas-resultado.cfm" style="margin:0;">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td colspan="4"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<td width="5%">&nbsp;</td>
							<td width="40%" align="center" valign="top">
								<cf_web_portlet_start border="true" titulo="#LB_ConsultadePlazas#" skin="info1">
									<table width="100%" align="center">
										<tr><td><p>
										<cf_translate  key="AYUDA_ReporteInformacionDetalladaDeConsultadePlazas">
											Esta consulta despliega un listado de las plazas que estan 100% ocupadas por centro funcional,así como quien posee esa plaza</cf_translate>
										.</p></td></tr>
									</table>
								<cf_web_portlet_end>
							</td>
							<td colspan="2" valign="top">
								<table width="100%" align="center" cellpadding="2" cellspacing="0" >
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_CentroFuncional" xmlfile="/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</td>
										<td><cf_rhcfuncional></td>
										<td><input type="checkbox" name="incluirDependencias"><cf_translate  key="LB_IncluirDependencias" xmlFile="/rh/generales.xml">Incluir Dependencias</cf_translate></td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Plaza">Plaza</cf_translate>&nbsp;:</td>
										<td>
											<cf_conlis
											campos="RHPid,RHPcodigo,RHPdescripcion"
											desplegables="N,S,S"
											modificables="N,S,N"
											size="0,10,25"
											title="#LB_ListadoDePlazas#"
											tabla="RHPlazas"
											columnas="RHPid,RHPcodigo,RHPdescripcion"
											filtro="Ecodigo=#SESSION.ECODIGO#"
											desplegar="RHPcodigo,RHPdescripcion"
											filtrar_por="RHPcodigo,RHPdescripcion"
											etiquetas="#LB_Codigo#,#LB_Descripcion#"
											formatos="S,S"
											align="left,left"
											asignar="RHPid,RHPcodigo,RHPdescripcion"
											asignarformatos="S, S, S"
											showEmptyListMsg="true"
											EmptyListMsg="-- No se encontraron Plazas asoc --"
											tabindex="1"
											MaxRowsQuery="500">
										</td>
									</tr>
									<tr>
										<td width="10%" align="right" nowrap ><cf_translate  key="LB_Curso"><b>Puesto</b></cf_translate>:&nbsp;</td>
										<td> <cf_rhpuesto tabindex="1" name="RHPpuesto"></td>
									</tr>

									<!---------- Estatus de plaza ------------->
									<tr>
										<td  align="right" nowrap><cf_translate key="LB_Activa" xmlFile="/rh/generales.xml">Estado de Plazas</cf_translate>:&nbsp;&nbsp;</td>
										<td>
											<select name="estado">
												<option value=""><cf_translate key="LB_Todas" xmlFile="/rh/generales.xml">Todas</cf_translate></option>
												<option value="1"><cf_translate key="LB_Activa" xmlFile="/rh/generales.xml">Activas</cf_translate></option>
												<option value="2"><cf_translate key="LB_Inactivas" xmlFile="/rh/generales.xml">Inactivas</cf_translate></option>
											</select>
										</td>
									</tr>

								  <!---------- ordenamiento de los datos------------->

									<tr>
										<td  align="right" nowrap><cf_translate key="LB_Ordenar_por" xmlFile="/rh/generales.xml">Ordenar por</cf_translate>:&nbsp;</td>
										<td>
											<select name="OrderBy">
												<option value="4"><cf_translate key="LB_Empresa" xmlFile="/rh/generales.xml">Empresa</cf_translate></option>
												<option value="1"><cf_translate key="LB_CodigoDePlaza" xmlFile="/rh/generales.xml">Código de Plaza</cf_translate></option>
												<option value="2"><cf_translate key="LB_NombreDePlaza" xmlFile="/rh/generales.xml">Nombre de Plaza</cf_translate></option>
												<option value="3"><cf_translate key="LB_CentroFuncional" xmlFile="/rh/generales.xml">Centro Funcional</cf_translate></option>
											</select>
										</td>
									</tr>
								<!---- agrupado por centro funcional------>
								<tr>	
									<td></td>
									<td colspan="3">
										<div class="checkbox">
							            	<label>
							             		<input type="checkbox" name="agruparPorCF" id="agruparPorCF"><cf_translate key="LB_AgrupadoPorCentroFuncional" xmlFile="/rh/generales.xml">Agrupado por Centro Funcional</cf_translate>
							            	</label>
							            </div>
									</td>
								</tr>
								<!---- check de consulta corporativa------>
									<tr>	
										<td></td>
										<td colspan="3">
											<div class="checkbox">
								            	<label>
								             		<input type="checkbox" name="esCorporativo" id="esCorporativo"><cf_translate key="LB_EsCorporativo" xmlFile="/rh/generales.xml">Es Corporativo</cf_translate>?
								            	</label>
								            </div>
										</td>
									</tr>
									<!----- Se pinta el arbol---->
									<tr>
										<td></td>
										<td id="divArbol" style="display:none" colspan="3">
												<cf_translatedata tabla="Empresas" col="e.Edescripcion" name="get" returnvariable="LvarEdescripcion"/>
												<cfquery datasource="#session.dsn#" name="datosArbol" maxrows="50">
													select #LvarEdescripcion# as Edescripcion,e.Ecodigo
													from Empresas e
													where  cliente_empresarial=#session.CEcodigo#
													order by e.Edescripcion
												</cfquery>

												<cfsavecontent variable="data">
													{
													"key":"0",
													"label":"<cf_translate key="LB_TodasLasEmpresas" xmlFile="/rh/generales.xml">Todas las Empresas</cf_translate>",
													"values":[
															<cfoutput query="datosArbol">
															 {
															        "key": "#trim(Ecodigo)#",
															        "label": "#trim(Edescripcion)#"
															        
															    }<cfif currentrow neq recordcount>,</cfif>
															</cfoutput>
															]
													}
												</cfsavecontent>
												<cf_jtree data="#data#">
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
				<cf_web_portlet_end>
			</td></tr>
		</table>
<cf_templatefooter>

<!---<script language="javascript1.2" type="text/javascript">
	<cfoutput>
	function validar(form){
	var mensaje = '';
	if ( form.CFcodigo.value == '' ){
	mensaje += ' - El campo Código de Centro Funcional es requerido.\n';
	}
	
	if ( mensaje != '' ){
	mensaje = 'Se presentaron los siguiente errores:\n' + mensaje;
	alert(mensaje);
	return false;
	}
	
	return true;
	}
	</cfoutput>
	
		$(function() {
		$("#esCorporativo").click(function(){
				if( $(this).is(':checked') ){
					$("#divArbol").show();
				}else{
					$("#divArbol").hide();
				}
			}
		);
	});
	
</script>--->