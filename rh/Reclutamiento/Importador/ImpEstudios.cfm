<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Titulo"
	Default="Importador de Estudios Realizados de Oferentes"
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
									<cf_sifFormatoArchivoImpr EIcodigo = 'IMPEXEDUC'>
								</td>
							</tr>						
						</table>
					</td>
					</td>
						<td width="40%" valign="top">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<cf_sifimportar EIcodigo="IMPEXEDUC" mode="in" />
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
												<tr>
													<td valign="top">
														<font  style="font-size:10px"><strong>
														<cf_translate  key="LB_Sin_terminar">Estudios sin terminar</cf_translate>
														</strong></font>
													</td>
													<td valign="top">
														<font  style="font-size:10px"><cf_translate  key="LB_Si">(1) Si</cf_translate>&nbsp;<cf_translate  key="LB_no">(0) No</cf_translate></font>
													</td>
												</tr>
													<td valign="top" colspan="2">
														&nbsp;<br /><br />
													</td>
												<tr>
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