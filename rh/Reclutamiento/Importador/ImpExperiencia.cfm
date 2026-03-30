<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Titulo"
	Default="Importador de Experiencia de Oferentes"
	returnvariable="LB_Titulo"/> 

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Verificacion_de_datos"
	Default="Datos V&aacute;lidos"
	returnvariable="LB_Verificacion_de_datos"/> 


<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start titulo="#LB_Titulo#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfoutput>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
					<td width="60%" valign="top">
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>
									<cf_sifFormatoArchivoImpr EIcodigo = 'IMPEXPER'>
								</td>
							</tr>						
						</table>
					</td>
					</td>
						<td width="40%" valign="top">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<cf_sifimportar EIcodigo="IMPEXPER" mode="in" />
									</td>
								</tr>
								<tr>
									<td>
										<cf_web_portlet_start titulo="#LB_Verificacion_de_datos#">
											
											<table width="100%"  border="0" cellspacing="2" cellpadding="2">
												<cf_translatedata name="get" tabla="NTipoIdentificacion" col="NTIdescripcion" returnvariable="LvarNTIdescripcion"/>
												<cfquery name="rsTipoIdent" datasource="#session.DSN#">
													select NTIcodigo, #LvarNTIdescripcion# as NTIdescripcion
													from NTipoIdentificacion
													where Ecodigo = #Session.Ecodigo#
													order by NTIdescripcion
												</cfquery>
												<tr valign="top">
													<td>
														<font  style="font-size:10px"><strong><cf_translate  key="LB_TipoIdentificacion">Tipo Identificaci&oacute;n</cf_translate></strong></font>
													</td>
													<td>
														<table width="100%"  border="0" cellspacing="0" cellpadding="0">
															<cfloop query="rsTipoIdent">
															 <tr>	
																<td>
																	<font  style="font-size:10px">#rsTipoIdent.NTIcodigo#</font>
																</td>
																<td>
																	<font  style="font-size:10px">#rsTipoIdent.NTIdescripcion#</font>
																</td>
															  </tr>
															</cfloop>
														</table>
														
													</td>
												</tr>
												<tr valign="top">
													<td>
														<font  style="font-size:10px"><strong><cf_translate  key="LB_Motivo_del_Retiro">Motivo del Retiro</cf_translate></strong></font>
													</td>
													<td>
														<table width="100%"  border="0" cellspacing="1" cellpadding="0">
															<tr>	
																<td nowrap><font  style="font-size:10px">0 &nbsp;&nbsp;<cf_translate key="CMB_Renuncia">Renuncia</cf_translate></font></td>
																<td nowrap><font  style="font-size:10px">10 &nbsp;<cf_translate key="CMB_Despido">Despido</cf_translate></font></td>
															</tr>
															<tr>	
																<td nowrap><font  style="font-size:10px">20 &nbsp;<cf_translate key="CMB_FinDeContrato">Fin de Contrato</cf_translate></font></td>
																<td nowrap><font  style="font-size:10px">30 &nbsp;<cf_translate key="CMB_FinDeProyecto">Fin de Proyecto</cf_translate></font></td>
															</tr>
															<tr>	
																<td nowrap><font  style="font-size:10px">40 &nbsp;<cf_translate key="CMB_CierreOperaciones">Cierre Operaciones</cf_translate>&nbsp;</font></td>
																<td nowrap><font  style="font-size:10px">50 &nbsp;<cf_translate key="CMB_Otros">Otros</cf_translate></font></td>
															</tr>
														</table>
														
													</td>
												</tr>
												<tr>
													<td valign="top">
														<font  style="font-size:10px"><strong>
														<cf_translate  key="LB_TrabajaActualmente">Trabaja Actualmente</cf_translate>
														</strong></font>
													</td>
													<td valign="top">
														<font  style="font-size:10px"><cf_translate  key="LB_Si">(1) Si</cf_translate>&nbsp;<cf_translate  key="LB_no">(0) No</cf_translate></font>
													</td>
												</tr>
											</table>
										<cf_web_portlet_end>
									</td>
								</tr>							
							</table>
						</td>
					</tr>		
				</table>
			</cfoutput>
	<cf_web_portlet_end>			
<cf_templatefooter>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Esta_seguro_de_realizar_el_cierre_de_mes"
	Default="¿ Esta seguro de realizar el cierre de mes ?"
	returnvariable="LB_Esta_seguro_de_realizar_el_cierre_de_mes"/> 	
	
<script language="JavaScript1.2">
	function recargar(){
			document.form1.submit();
	}
	function limpiar(){
		document.form1.RHPcodigo.value="";
		document.form1.RHPcodigoext.value="";
		document.form1.RHPdescpuesto.value="";
		document.form1.CFid.value="";
		document.form1.CFcodigo.value="";
		document.form1.CFdescripcion.value="";
		document.form1.RHEid.value="100";
		document.form1.dependencias.checked = false;
		
			
	}


</script>