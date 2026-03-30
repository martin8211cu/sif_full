<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
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
                 <!---================= TRADUCCION ====================---->
				  <cfinvoke component="sif.Componentes.TranslateDB"
					method="Translate"
					VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
					Default="Exportaci&oacute;n de Informaci&oacute;n de Planilla"
					VSgrupo="103"
					returnvariable="nombre_proceso"/>

				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Exportacion"
					Default="Exportaci&oacute;n"
					returnvariable="LB_Exportacion"/>

				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Cambiar"
					Default="Cambiar"
					returnvariable="BTN_Cambiar"/>

				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_Consecutivo"
					Default="Consecutivo"
					returnvariable="MSG_Consecutivo"/>

				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_no_puede_ser_cero"
					Default=" no puede ser cero"
					returnvariable="MSG_no_puede_ser_cero"/>

				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_ErrorExportacion"
					Default="Error Exportaci&oacute;n"
					returnvariable="LB_ErrorExportacion"/>

				  <cf_web_portlet_start border="true" titulo="#nombre_proceso#" skin="#Session.Preferences.Skin#">
						<cfif (isdefined("Form.Bid") and len(trim(Form.Bid)) gt 0) and (isdefined("Form.EIid") and len(trim(Form.EIid)) gt 0)>
							<cfset Regresar = "Exportacion.cfm?Bid=#Form.Bid#&EIid=#Form.EIid#">
						<cfelse>
							<cfset Regresar = "Exportacion.cfm">
						</cfif>
						<cfinclude template="/rh/portlets/pNavegacionPago.cfm">
						<table>
							<tr>
								<td valign="top" width="50%">
									<table width="100%">
										<tr>
											<td>

												<cf_web_portlet_start border="true" titulo="#LB_Exportacion#" skin="info1">
													<table width="100%">

														<tr><td><p>
														<cf_translate key="LB_EnEsteProcesoSeGeneraraLaInformacionParaPagoAlBanco">
															En este proceso, se generará la información para pago al Banco.
															Seleccione el tipo de generación que desea, y presione la opción <strong>Generar</strong>
															para obtener el archivo.
														</cf_translate>
														</p></td></tr>
													</table>
												<cf_web_portlet_end>
											</td>
										</tr>
									</table>
								</td>
								<td width="50%">
									<cfparam name="Form.ERNid" type="numeric">
									<cfif (isdefined("Form.Bid") and len(trim(Form.Bid)) gt 0)
										and (isdefined("Form.EIid") and len(trim(Form.EIid)) gt 0)>
										<cfquery name="rs0" datasource="#session.DSN#">
											select EIid,RHEdescripcion
											from RHExportaciones
											where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
												and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
												and EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
										</cfquery>
										<cfquery name="rs" datasource="sifcontrol">
											select EIcodigo
											from EImportador
											where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
										</cfquery>
										<cfset EIcodigo = rs.EIcodigo>
									<cfelse>
										<cfset EIcodigo = "EX_CHEQUE">
									</cfif>
									<table width="100%">
											<tr>
												<td width="1%" nowrap><strong><cf_translate key="LB_Datos_del_Lote">Datos del Lote</cf_translate></strong></td><td width="99%">&nbsp;</td>
											</tr>
											<tr><td nowrap valign="top">
												<cf_translate key="LB_Consecutivo_de_Archivo">Consecutivo de Archivo</cf_translate>&nbsp;:&nbsp;
											</td>
											<td valign="top">
												<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
												<script language="javascript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
												<script language="JavaScript1.2" type="text/javascript">
													<!--//
													// specify the path where the "/qforms/" subfolder is located
													qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
													// loads all default libraries
													qFormAPI.include("*");
													//-->
												</script>
												<cfif isdefined("form.rhparam210") and len(trim(form.rhparam210)) gt 0>
													<cfquery name="rsVerifica" datasource="#session.DSN#">
														select 1
														from RHParametros
														where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
														  and Pcodigo = 210
													</cfquery>
													<cfif rsVerifica.RecordCount EQ 0>
														<cfinvoke component="sif.Componentes.Translate"
															method="Translate"
															Key="LB_Consecutivo_de_Archivo_de_Planilla"
															Default="Consecutivo de Archivo de Planilla"
															returnvariable="LB_Consecutivo_de_Archivo_de_Planilla"/>

														<cfquery datasource="#session.DSN#">
															insert RHParametros(Ecodigo, Pcodigo, Pvalor, Pdescripcion)
															values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
																	210,
																	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rhparam210#">,
																	'#LB_Consecutivo_de_Archivo_de_Planilla#')
														</cfquery>
													<cfelse>
														<cfquery datasource="#session.DSN#">
															update RHParametros
																set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.rhparam210#">
															where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
															  and Pcodigo = 210
														</cfquery>
													</cfif>
												</cfif>
												<cfquery name="rs" datasource="#session.DSN#">
													select Pvalor
													from RHParametros
													where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
													  and Pcodigo = 210
												</cfquery>
												<cfoutput>
												<form name="formrhparam210" method="post">
												<input type="hidden" value="#form.ERNid#" name="ERNid" id="ERNid">
												<cfif isdefined("form.Bid") and len(trim(form.Bid)) gt 0>
												<input type="hidden" value="#form.Bid#" name="Bid" id="Bid">
												</cfif>
												<cfif isdefined("form.EIid") and len(trim(form.EIid)) gt 0>
												<input type="hidden" value="#form.EIid#" name="EIid" id="EIid">
												</cfif>
                                                <cfif isdefined("form.Estado") and len(trim(form.Estado)) NEQ ''>
												<input type="hidden" value="#form.Estado#" name="Estado" id="Estado">
												</cfif>
												<table width="100%"  border="0" cellspacing="0" cellpadding="0">
												  <tr>
													<td>
														<cfquery name="rsBNSINPE" datasource="sifcontrol">
														select EIcodigo
														from EImportador
														where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
														and rtrim(ltrim(EIcodigo))='BNSINPE'
														</cfquery>
														<input
															name="rhparam210"
															id="MERPorden"
															style="text-align:right"
															onKeyPress="return acceptNum(event)"
															size="5"
															<cfif rsBNSINPE.RecordCount gt 0>
															maxlength="5"
															<cfelse>
															maxlength="3"
															</cfif>
															<cfif rs.RecordCount gt 0 and len(trim(rs.pvalor)) gt 0>
																value="#rs.pvalor#"
															<cfelse>
																value="0"
															</cfif>
														>
													</td>
												  </tr>
												</table>
												  <tr>
													<td colspan="2" align="center">
														<input type="submit" name="sbGuardar" id="sbGuardar" value="#BTN_Cambiar#"
                                                       <!---<cfif form.vEstado eq "p">disabled="disabled" </cfif>--->>
													</td>
												  </tr>
												</form>
												</cfoutput>
												<script language="JavaScript1.2" type="text/javascript">
													<!--//
													qFormAPI.errorColor = "#FFFFCC";
													objFormR = new qForm("formrhparam210");
													<cfoutput>
													//validacion de campo numerico
													objFormR.rhparam210.required = true;
													objFormR.rhparam210.description="#MSG_Consecutivo#";
													objFormR.rhparam210.validateNumeric(objFormR.rhparam210.description+' '+'#MSG_no_puede_ser_cero#');
													//-->
													</cfoutput>
												</script>
											</td>
										</tr>
									</table>
                                    <cfif isDefined("form.vEstado") and form.vEstado eq "p">
                                        <cf_web_portlet_start border="true" titulo="#LB_ErrorExportacion#" skin="info1">
                                            <table width="100%">
                                                <tr><td><p>
                                                <cf_translate key="LB_ErrorProcesoSeGeneraraLaInformacionParaPagoAlBanco">
                                                	No se puede generar un archivo al banco de una nómina en proceso.
                                                </cf_translate>
                                                </p></td></tr>
                                            </table>
                                        <cf_web_portlet_end>
                                    <cfelse>
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
									  <tr>
										<td>
											<cfdump var="#EIcodigo#">
											<cf_sifimportar EIcodigo="#EIcodigo#" EIid="#Form.EIid#" mode="out">
												<!--- EcodigoASP --->
												<cf_sifimportarparam name="EcodigoASP" value="#session.EcodigoSDC#">

												<!--- ERNid --->
												<cf_sifimportarparam name="ERNid" value="#Form.ERNid#">
												<cfset url.ERNid = Form.ERNid>

												<!--- Bid --->
												<cfif isdefined("Form.Bid") and len(trim(Form.Bid)) gt 0>
													<cf_sifimportarparam name="Bid" value="#Form.Bid#">
													<cfset url.Bid = Form.Bid>
												</cfif>
												<cf_sifimportarparam name="Estado" value="#Form.Estado#">

												<cfif isdefined("form.parametros") and len(trim(form.parametros)) >
													<cfset parametros = '' >
													<cfloop list="#form.parametros#" index="i" delimiters=",">
														<cfif isdefined("form.#i#") >
															<cfset valor = form[#i#] >
															<cf_sifimportarparam name="#i#" value="#valor#">
														</cfif>
													</cfloop>
												</cfif>


											</cf_sifimportar>
										</td>
									  </tr>
									</table>
                                    </cfif>
								</td>
							</tr>
						</table>
	                <cf_web_portlet_end>
				</td>
			</tr>
		</table>
<cf_templatefooter>