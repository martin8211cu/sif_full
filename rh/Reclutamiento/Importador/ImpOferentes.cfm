<!--- <cfdump var="#form#"> --->

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Titulo"
	Default="Importador Oferentes"
	returnvariable="LB_Titulo"/> 

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Verificacion_de_datos"
	Default="Datos V&aacute;lidos"
	returnvariable="LB_Verificacion_de_datos"/> 


<cf_translatedata name="get" tabla="RHIdiomas" col="RHDescripcion" returnvariable="LvarRHDescripcion">
<cfquery name="rsIdiomas" datasource="#session.DSN#">
	select RHIid, RHIcodigo, #LvarRHDescripcion# as RHDescripcion 
	from RHIdiomas
	order by RHIid asc
</cfquery>
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
									<cf_sifFormatoArchivoImpr EIcodigo = 'IMPOFER'>
								</td>
							</tr>						
						</table>
					</td>
					</td>
						<td width="40%" valign="top">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>
										<cf_sifimportar EIcodigo="IMPOFER" mode="in" />
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
														<font  style="font-size:10px"><strong><cf_translate  key="LB_EstadoCivil">Estado Civil</cf_translate></strong></font>
													</td>
													<td>
														<table width="100%"  border="0" cellspacing="0" cellpadding="0">
															<tr>	
																<td>0</td><td><font  style="font-size:10px"><cf_translate key="CMB_SolteroA">Soltero(a)</cf_translate></font></td>
															</tr>
															<tr>	
																<td>1</td><td><font  style="font-size:10px"><cf_translate key="CMB_CasadoA">Casado(a)</cf_translate></font></td>
															</tr>
															<tr>	
																<td>2</td><td><font  style="font-size:10px"><cf_translate key="CMB_DivorciadoA">Divorciado(a)</cf_translate></font></td>
															</tr>
															<tr>	
																<td>3</td><td><font  style="font-size:10px"><cf_translate key="CMB_ViudoA">Viudo(a)</cf_translate></font></td>
															</tr>
															<tr>	
																<td>4</td><td><font  style="font-size:10px"><cf_translate key="CMB_UnionLibre">Union Libre</cf_translate></font></td>
															</tr>
															<tr>	
																<td>5</td><td><font  style="font-size:10px"><cf_translate key="CMB_SeparadoA">Separado(a)</cf_translate></font></td>
															</tr>
														</table>
														
													</td>
												</tr>
												<tr>
													<td>
														<font  style="font-size:10px"><strong><cf_translate  key="LB_Sexo">Sexo</cf_translate></strong></font>
													</td>
													<td>
														<font  style="font-size:10px"><cf_translate  key="LB_Femenino">(F) Femenimo</cf_translate>&nbsp;<cf_translate  key="LB_Masculino">(M) Masculino</cf_translate></font>
													</td>
												</tr>
												<tr>
													<td>
														<font  style="font-size:10px"><strong><cf_translate  key="LB_pais">Pa&iacute;s</cf_translate></strong></font>
													</td>
													<td>
														<font  style="font-size:10px"><cf_translate  key="LB_Paises">(CR) Costa Rica&nbsp;,(NI) Nicaragua&nbsp;,Etc.</cf_translate></font>
													</td>
												</tr>
												<tr valign="top">
													<td>
														<font  style="font-size:10px"><strong><cf_translate  key="LB_Idioma">Idioma</cf_translate></strong></font>
													</td>
													<td>
														<table width="100%"  border="0" cellspacing="0" cellpadding="0">
															<cfloop query="#rsIdiomas#">
																<tr>
																	<td><cfoutput>#RHIid#</cfoutput></td>
																	<td><font  style="font-size:10px"><cfoutput>#RHDescripcion#</cfoutput></td>
																</tr>
															</cfloop>
														</table>
													</td>
												</tr>
												<tr>
													<td>
														<font  style="font-size:10px"><strong><cf_translate  key="LB_Moneda">Moneda</cf_translate></strong></font>
													</td>
													<td>
														<font  style="font-size:10px"><cf_translate  key="LB_Paises">(CRC) Col&oacute;n&nbsp;,(USD) D&oacute;lar&nbsp;,(EUR) Euro&nbsp;,Etc.</cf_translate></font>
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