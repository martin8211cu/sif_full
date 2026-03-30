<!-- InstanceBegin template="/Templates/LMenuRH1.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
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

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->	
                    <!-- InstanceBeginEditable name="MenuJS" --> 
		  <!-- InstanceEndEditable -->					
					<!-- InstanceBeginEditable name="Mantenimiento" --> 
				<!--- <cfif not isdefined("url.tipo")	>
					hola1 --->
					<cfset titulo = "">
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_ReporteDeMarcas"
					Default="Reporte de Marcas"
					returnvariable="titulo"/> 

					<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
					<!--- <SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
					<SCRIPT language="JavaScript">
						<!--//
						// specify the path where the "/qforms/" subfolder is located
						qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
						// loads all default libraries
						qFormAPI.include("*");
						//qFormAPI.include("validation");
						//qFormAPI.include("functions", null, "12");
						//-->
					</SCRIPT> --->
				
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
									
					<script language="javascript" type="text/javascript">
						function limpiar() {
							document.form1.CFdescripcion.value = "";
							document.form1.CFcodigo.value = "";
							document.form1.id_centro.value = "";
							document.form1.fdesde.value = "";
							document.form1.fhasta.value = "";
						}
						function inclDepen(obj){
							if(obj.checked){
								if(document.form1.CFcodigo.value == ''){
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_PrimeroDebeSeleccionarUnCentroFuncional"
									Default="Primero debe seleccionar un centro funcional"
									returnvariable="LB_PrimeroDebeSeleccionarUnCentroFuncional"/> 
									
									
									alert("<cfoutput>#LB_PrimeroDebeSeleccionarUnCentroFuncional#</cfoutput>");	
									obj.checked = false;
								}
							}
						}
					</script>
				
					<cfoutput>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_ConsultaDeMarcas"
						Default="Consulta de Marcas"
						returnvariable="LB_ConsultaDeMarcas"/>
						
						
						<form method="post" name="form1" action="Marcas-form.cfm">
							<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
									<td width="50%">
										<table width="100%">
											<tr>
												<td height="173" valign="top">	
													<cf_web_portlet_start border="true" titulo="#LB_ConsultaDeMarcas#" skin="info1">
														<div align="justify">
														  <p>
														  
														  <cf_translate  key="AYUDA_EnEsteReporteSeMuestranLasMarcas">
														  En &eacute;ste reporte 
														  se muestran las marcas agrupadas por: Funcionario, Supervisor,
														  centro funcional en
														  fin, agrupados
														  &eacute;stos seg&uacute;n los requerimientos del usuario, brinda
														  adem&aacute;s
														  otros detalles de las
														  marcas como: Entrada
														  Autorizada, Salida
														  Autorizada, horas extras,
														  etc...
														  </cf_translate>
														  </p>
													</div>
												  <cf_web_portlet_end>							  </td>
											</tr>
										</table>  
									</td>
									<td width="50%" valign="top">
										<table width="100%" cellpadding="0" cellspacing="0" align="center">
											
											<tr>
											  <td align="center" nowrap colspan="3"><div align="left"><strong><cf_translate  key="LB_Empleado">Empleado</cf_translate>:</strong>&nbsp;
												   <cf_rhempleado tabindex="1" size = "50">
											  </div></td>
										  </tr>
										  <tr>
										  	<td><strong><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:</strong></td>
											<td><strong><cf_translate  key="LB_Desde">Desde</cf_translate>:</strong></td>
											<td><strong><cf_translate  key="LB_Hasta">Hasta</cf_translate>:</strong></td>
										  </tr>
										   <tr> 
												<td nowrap>
													<cfoutput>
                                                        <cf_rhcfuncional  id="id_centro" tabindex="1">
													</cfoutput>
												</td>
												<td nowrap>
													<cfif isdefined("Form.fdesde")>
														<cfset fecha = Form.fdesde>
														<cfelse>
														<cfset fecha = "">
													</cfif>
													<cf_sifcalendario form="form1" value="#fecha#" name="fdesde">
												</td>
												
												<td nowrap>
													<cfif isdefined("Form.fhasta")>
														<cfset fecha = Form.fhasta>
														<cfelse>
														<cfset fecha = "">
													</cfif>
													<cf_sifcalendario form="form1" value="#fecha#" name="fhasta">
												</td>
										  </tr>
											<tr>
												<td colspan="3">
													<strong><cf_translate  key="LB_IncluirDependencias">Incluir Dependencias</cf_translate> :</strong>
													<input name="ckDPen"  onClick="javascript: inclDepen(this);"type="checkbox" value="checkbox" >																							
												</td>
										    </tr>																						
										  
											<tr>
												<td colspan="3" align="center">
													<fieldset><legend><cf_translate  key="LB_CortePor">Corte por</cf_translate></legend>
														<table width="100%"  border="0" cellspacing="0" cellpadding="0">
														  <tr>
															<td width="26%" align="right" nowrap><strong><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:</strong></td>
															<td width="8%"><input name="ckCF" type="checkbox" value="checkbox" ></td>
															<td width="24%" align="right"><strong><cf_translate  key="LB_Funcionario">Funcionario</cf_translate>:</strong> </td>
															<td width="9%"><input name="ckF" type="checkbox" value="checkbox" ></td>
															<td width="20%" align="right"><strong><cf_translate  key="LB_Supervisor">Supervisor</cf_translate>:</strong></td>
															<td width="13%"><input name="ckSP" type="checkbox" value="checkbox" ></td>
														  </tr>
														</table>													
													</fieldset>
												</td>
										    </tr>
											<tr>
												<td colspan="3" align="center">&nbsp;</td>
										    </tr>																						
											<tr>
												<td align="center" colspan="3">
												<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												Key="BTN_Generar"
												Default="Generar"
												XmlFile="/rh/generales.xml"
												returnvariable="BTN_Generar"/>
												
												<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												Key="BTN_Limpiar"
												Default="Limpiar"
												XmlFile="/rh/generales.xml"
												returnvariable="BTN_Limpiar"/>
												
												
												<input type="submit" value="#BTN_Generar#" name="Reporte">
												<input type="button" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript: limpiar();"></td>
										  </tr>
										</table>
									</td>
								</tr>
							</table>
						</form>
					</cfoutput>
					<!--- 	<SCRIPT language="JavaScript">
							qFormAPI.errorColor = "#FFFFCC";
							objForm = new qForm("form1");
							
							objForm.DEid.required = true;
							objForm.DEid.description="identificación de Colaborador";		
						</script> --->
				    <cf_web_portlet_end>
				<!--- <cfelse>
					hola2
					<cfinclude template="CompetenciasBase-form.cfm">
					
				</cfif> --->
      <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->