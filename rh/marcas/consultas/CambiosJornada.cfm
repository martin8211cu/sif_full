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
					<!---=============== TRADUCCION ===================--->
					<cfinvoke component="sif.Componentes.TranslateDB"
						method="Translate"
						VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
						Default="Reporte de Cambios de Jornada"
						VSgrupo="103"
						returnvariable="nombre_proceso"/>
					
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Lista_de_Usuarios"
						Default="Lista de Usuarios"	
						returnvariable="LB_Lista_de_Usuarios"/>
						
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Limpiar"
						Default="Limpiar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Limpiar"/>
					
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Generar"
						Default="Generar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Generar"/>
						
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_Fecha_Desde_Cambio_de_Jornada"
						Default="Fecha Desde Cambio de Jornada"	
						returnvariable="MSG_Fecha_Desde_Cambio_de_Jornada"/>
					
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_Fecha_Hasta_Cambio_de_Jornada"
						Default="Fecha Hasta Cambio de Jornada"	
						returnvariable="MSG_Fecha_Hasta_Cambio_de_Jornada"/>		
						
						
					<cf_web_portlet_start border="true" titulo="#nombre_proceso#" skin="#Session.Preferences.Skin#">
							<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
						<SCRIPT language="JavaScript">
							<!--//
							// specify the path where the "/qforms/" subfolder is located
							qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
							// loads all default libraries
							qFormAPI.include("*");
							//qFormAPI.include("validation");
							//qFormAPI.include("functions", null, "12");
							//-->
						</SCRIPT>	
						<!--- Javascript --->
						
						
						<script language="JavaScript" type="text/javascript">
							function validar(f) {
								return true;
							}
							var popUpWin=0; 
							function popUpWindow(URLStr, left, top, width, height)
							{
							  if(popUpWin) {
								if(!popUpWin.closed) popUpWin.close();
							  }
							  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
							}

							function doConlisUsuarios() {
								var w = 650;
								var h = 500;
								var l = (screen.width-w)/2;
								var t = (screen.height-h)/2;
								popUpWindow("../operacion/ConlisUsuariosAutorizacion.cfm?form=form1&usuario=Usuario&nombre=Nombre",l,t,w,h);
							}
						
						</script>
				
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
									
					<script language="javascript" type="text/javascript">
						function limpiar() {
							document.form1.CFdescripcion.value = "";
							document.form1.CFcodigo.value = "";
							document.form1.id_centro.value = "";
							document.form1.fdesde.value = "";
							document.form1.fhasta.value = "";
							document.form1.Usuario.value = "";
							document.form1.Nombre.value = "";
						}
					</script>
						<cfoutput>
						<form method="post" name="form1" action="CambiosJornada-form.cfm">
							<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
									<td width="50%">
										<table width="100%">
											<tr>
												<td height="173" valign="top">														
													<cf_web_portlet_start border="true" titulo="#nombre_proceso#" skin="info1">
														<div align="justify">
														  <p><cf_translate key="AYUDA_EnEsteReporteSeMuestranLosCambiosDeJornadaAplicados">En &eacute;ste reporte 
														  se muestran los cambios de jornada que ya se aplicaron, agrupadas estas por : 
														  Centro Funcional o por supervisor. Este filtro se hará entre fechas y tomará únicamente 
														  aquellas marcas que hayan sido aplicado.</cf_translate>
														  </p>
													</div>
												  <cf_web_portlet_end>							  
												</td>
											</tr>
										</table>  
									</td>
									<td width="50%" valign="top">
										<table width="100%" cellpadding="0" cellspacing="0" align="center">
											<tr>
												<td align="right" nowrap >
													<strong><cf_translate key="LB_Supervisor">Supervisor:</cf_translate></strong>
												</td>
												<td width="">	
													<input name="Nombre" type="text" value="" tabindex="-1" readonly size="50" maxlength="180">
						  							<a href="##"><img src="/cfmx/rh/imagenes/Description.gif" alt="#LB_Lista_de_Usuarios#" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisUsuarios();"></a>
													<input type="hidden" id="Usuario" name="Usuario" value="">
											  	</td>
											</tr>
											<tr>
												<td align="right" nowrap><strong><cf_translate key="LB_Centro_Funcional">Centro Funcional:</cf_translate></strong></td>
												<td  nowrap>
													<cfoutput>
														<cf_rhcfuncional  id="id_centro" tabindex="1">
													</cfoutput>
												</td>
											</tr>
											<tr>
												<td align="right"><strong><cf_translate key="LB_Desde">Desde:</cf_translate></strong></td>
												<td nowrap>
													<cfif isdefined("Form.fdesde")>
														<cfset fecha = Form.fdesde>
													<cfelse>
														<cfset fecha = "">
													</cfif>
													<cf_sifcalendario form="form1" value="#fecha#" name="fdesde">
												</td>
											</tr>
											<tr> 
												<td align="right"><strong><cf_translate key="LB_Hasta">Hasta:</cf_translate></strong></td>
												<td nowrap>
													<cfif isdefined("Form.fhasta")>
														<cfset fecha = Form.fhasta>
													<cfelse>
														<cfset fecha = "">
													</cfif>
													<cf_sifcalendario form="form1" value="#fecha#" name="fhasta">
												</td>												
											</tr>
											<tr><td>&nbsp;</td></tr>
											<tr><td>&nbsp;</td></tr>
											<!--- <tr>
												<td align="center"><strong>Centro Funcional:</strong><input name="ckCF" type="checkbox" value="checkbox" ></td>
												<td align="center"><strong>Supervisor:</strong><input name="ckSP" type="checkbox" value="checkbox" ></td>
												<td align="center"><strong>Funcionario:</strong><input name="ckF" type="checkbox" value="checkbox" ></td>
											</tr> --->
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
						<SCRIPT language="JavaScript">
							qFormAPI.errorColor = "#FFFFCC";
							objForm = new qForm("form1");
							<cfoutput>
								objForm.fdesde.required = true;
								objForm.fdesde.description="#MSG_Fecha_Desde_Cambio_de_Jornada#";		
								objForm.fhasta.required = true;
								objForm.fhasta.description="#MSG_Fecha_Hasta_Cambio_de_Jornada#";		
							</cfoutput>
						</script> 
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