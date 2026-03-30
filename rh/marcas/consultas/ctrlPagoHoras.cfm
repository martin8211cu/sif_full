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
					<!----=================== TRADUCCION ======================---->
					<cfinvoke component="sif.Componentes.TranslateDB"
						method="Translate"
						VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
						Default="Reporte Control de Pago de Horas"
						VSgrupo="103"
						returnvariable="nombre_proceso"/>
					
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_Primero_debe_seleccionar_un_centro_funcional"
						Default="Primero debe seleccionar un centro funcional"	
						returnvariable="MSG_Primero_debe_seleccionar_un_centro_funcional"/>

					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_Error_tambien_debe_seleccionar_la_fecha_hasta"
						Default="Error, también debe seleccionar la fecha hasta"	
						returnvariable="MSG_Error_tambien_debe_seleccionar_la_fecha_hasta"/>
					
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_Error_tambien_debe_seleccionar_la_fecha_desde"
						Default="Error, también debe seleccionar la fecha desde"	
						returnvariable="MSG_Error_tambien_debe_seleccionar_la_fecha_desde"/>
					
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_Error_la_fecha_de_inicio_no_debe_ser_mayor_que_la_fecha_final"
						Default="Error, la fecha de inicio no debe ser mayor que la fecha final"	
						returnvariable="MSG_Error_la_fecha_de_inicio_no_debe_ser_mayor_que_la_fecha_final"/>
						
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Generar"
						Default="Generar"
						returnvariable="BTN_Generar"/>	
						
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Limpiar"
						Default="Limpiar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Limpiar"/>	
						
					<cf_web_portlet_start border="true" titulo="#nombre_proceso#" skin="#Session.Preferences.Skin#">
			
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
									<cfoutput>
									alert("#MSG_Primero_debe_seleccionar_un_centro_funcional#");	
									obj.checked = false;
									</cfoutput>
								}
							}
						}
						function VALIDAFECHAS(INICIO,FIN){
							var valorINICIO=0;
							var valorFIN=0;
							INICIO = INICIO.substring(6,10) + INICIO.substring(3,5) + INICIO.substring(0,2);
							FIN = FIN.substring(6,10) + FIN.substring(3,5) + FIN.substring(0,2);
							valorINICIO = parseInt(INICIO);
							valorFIN = parseInt(FIN);

							if (valorINICIO > valorFIN)
							   return false;
							return true;
						}								
						function validaPagoHoras(){
							<cfoutput>
							if(document.form1.fdesde.value != '' && document.form1.fhasta.value == ''){
								alert("#MSG_Error_tambien_debe_seleccionar_la_fecha_hasta#");
								return false;
							}else{
								if(document.form1.fhasta.value != '' && document.form1.fdesde.value == ''){
									alert("#MSG_Error_tambien_debe_seleccionar_la_fecha_desde#");
									return false;									
								}else{
									if(!VALIDAFECHAS(document.form1.fdesde.value,document.form1.fhasta.value)){
										alert("#MSG_Error_la_fecha_de_inicio_no_debe_ser_mayor_que_la_fecha_final#");
										return false;
									}
								}
							}
							</cfoutput>
							return true;
						}
					</script>
				
					<cfoutput>
						<form method="post" name="form1" action="ctrlPagoHoras-form.cfm" onSubmit="javascript: return validaPagoHoras();">
							<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
									<td width="50%">
										<table width="100%">
											<tr>
												<td height="173" valign="top">	
													<cfinvoke component="sif.Componentes.TranslateDB"
														method="Translate"
														VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
														Default="Control de Pago de Horas"
														VSgrupo="103"
														returnvariable="Titulo"/>
													<cf_web_portlet_start border="true" titulo="#Titulo#" skin="info1">
													<div align="justify">
													  <p><cf_translate key="AYUDA_En_este_reporte_se_muestra_la_totalizacion_de_hora_autorizadas_a_cada_funcionario">En este reporte 
													  se muestra la totalizaci&oacute;n de las horas autorizadas o no de cada   Funcionario agrupados por Centro Funcional al cual pertenecen.</cf_translate></p>
													</div>
												  <cf_web_portlet_end></td>
											</tr>
										</table>  
									</td>
									<td width="50%" valign="top">
										<table width="100%" cellpadding="0" cellspacing="0" align="center">
											
											<tr>
											  <td align="center" nowrap colspan="3"><div align="left"><strong><cf_translate key="LB_Empleado">Empleado:</cf_translate></strong>&nbsp;
												   <cf_rhempleado tabindex="1" size = "50">
											  </div></td>
										  </tr>
										  <tr>
										  	<td><strong><cf_translate key="LB_Centro_Funcional">Centro Funcional:</cf_translate></strong></td>
											<td><strong><cf_translate key="LB_Desde">Desde:</cf_translate></strong></td>
											<td><strong><cf_translate key="LB_Hasta">Hasta:</cf_translate></strong></td>
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
												<td align="center" nowrap><strong><cf_translate key="LB_Incluir_dependencias">Incluir Dependencias :</cf_translate></strong>
                                                  <input name="ckDPen"  onClick="javascript: inclDepen(this);"type="checkbox" value="checkbox" ></td>
											<td align="center" nowrap><strong><cf_translate key="LB_Horas">Horas:</cf_translate>
											  <select name="tipoHora" id="tipoHora">
											    <option value="-1">-- <cf_translate key="LB_Todas">Todas</cf_translate> --</option>
											    <option value="0"><cf_translate key="LB_Autorizadas">Autorizadas</cf_translate></option>
											    <option value="1"><cf_translate key="LB_No_Autotizadas">No Autorizadas</cf_translate></option>
										      </select>
											</strong></td>
											    <td align="center" nowrap>&nbsp;</td>
											</tr>
											<tr>
												<td colspan="3" align="center">&nbsp;</td>
										    </tr>																						
											<tr>
												<td align="center" colspan="3"><input type="submit" value="#BTN_Generar#" name="Reporte">
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