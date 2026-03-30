<!--- PRE CARGA DE VALORES --->
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfif isdefined("url.ETLCid") and len(trim(url.ETLCid)) gt 0 and not isdefined("form.ETLCid")  >
	<cfset form.ETLCid = url.ETLCid>
</cfif>
<cfif isdefined("form.ETLCid") and len(trim(form.ETLCid)) gt 0 >
	<cfquery name="rs" datasource="#Session.DSN#">
		Select 	
			ETLCid,
			ETLCpatrono,     
			ETLCnomPatrono,
			ETLCcomercial,
			ETLCdireccionEmp,
			ETLCcodigoElectoral,
			ETLCdescripcion,
			ETLCcantidadEmpleados,
			ETLCubicacion,
			ETLCplanilla,
			ETLCtelefonoL1,
			ETLCtelefonoL2,
			ETLCtelefonoE1,
			ETLCtelefonoE2,
			ETLCtelefonoE3,
			ETLCotrassenasE1,
			ETLCotrassenasE2,
			ETLCotrassenasE3,
			ETLCnomRepresentante,
			ETLCcedRepresentante,
			ETLCtel1Representante,
			ETLCtel2Representante,
			ETLCtel3Representante,
			ETLCdir1Representante,
			ETLCdir2Representante,
			ETLCdir3Representante,
			ETLCespecial,
            ETLCreferencia,
			ts_rversion
		from EmpresasTLC 
		where 
			ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#" >	
	</cfquery>	
	<cfquery name="rs2" datasource="#Session.DSN#">
		select
			FTLCid,
			FTLCcedula,
			FTLCformato,
			FTLCnombreCKC,
            FTLCapellido1CKC,
            FTLCapellido2CKC,
			FTLCopcion1,
			FTLCopcion2,
			FTLCopcion3,
			FTLCopcion4,
			FTLCdescricion1,
			FTLCdescricion2,
			FTLCdescricion3,
			FTLCdescricion4		
		from EmpFormatoTLC 
		where 
			ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#" >	
	</cfquery>


</cfif>

<!--- AREA DE TRADUCCION --->
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tratado_De_Libre_Comercio"
	Default="Tratado de Libre Comercio"
	returnvariable="LB_title"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empresas"
	Default="Empresas"
	returnvariable="LB_Empresas"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Informacion_General"
	Default="Informaci&oacute;n General"
	returnvariable="LB_Informacion_General"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Responsable"
	Default="Responsable"
	returnvariable="LB_Responsable"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Informacion_Adicional"
	Default="Informaci&oacute;n Adicional"
	returnvariable="LB_Informacion_Adicional"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Referencia"
	Default="Referencia"
	returnvariable="LB_Referencia"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Formato_para_importacion_de_personas"
	Default="Formato para carga e importaci&oacute;n de personas"
	returnvariable="LB_Formato_para_importacion_de_personas"/>
	
	

<!--- AREA DE COSULTAS --->



<!--- AREA DE FORM --->

<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
	<cf_templatearea name="title">
		<cfoutput>#LB_title#</cfoutput>
	</cf_templatearea>
	
<cf_templatearea name="body">
		<cf_templatecss>
		 <link href="/cfmx/sif/rh/css/rh.css" rel="stylesheet" type="text/css"><!--- --->
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
		<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>

		<cfinclude template="../../../../sif/Utiles/params.cfm">
		<cfset regresar = "/cfmx/hosting/tratado/index.cfm">

		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Empresas#'>
			<cfoutput>
			<form style="margin:0" name="form1" method="post"  action="Empresas-SQL.cfm"  onSubmit="return validar();" >
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr><td colspan="2"><cfinclude template="../../../../sif/portlets/pNavegacion.cfm"></td></tr>
					<tr>
						<td valign="top" bgcolor="##A0BAD3" colspan="2">
							<cfinclude template="frame-botones.cfm">
						</td>
					</tr>
					<tr>
						<td valign="top">
							<fieldset>
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td colspan="2">
											<fieldset><legend>#LB_Informacion_General#</legend>
												<table width="100%" border="0" cellpadding="0" cellspacing="2">
													<tr>
														<td nowrap="nowrap"><font   style="font-size:10px"><cf_translate key="LB_CedulaJuridica">C&eacute;dula Jur&iacute;dica</cf_translate></font></td>
														<td>
															<input 
																name="ETLCpatrono" 
																type="text" 
																id="ETLCpatrono"  
																tabindex="1"
																style="font-size:10px" 
																maxlength="15"
																size="15"
																value="<cfif isdefined("rs.ETLCpatrono") and len(trim(rs.ETLCpatrono))>#rs.ETLCpatrono#</cfif>">
														</td>
														<td>&nbsp;
															 
														</td>
														<td  nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Codigo_Electoral">C&oacute;digo Electoral</cf_translate></font></td>
														<td>
															<input 
																name="ETLCcodigoElectoral" 
																type="text" 
																id="ETLCcodigoElectoral"  
																tabindex="1"
																style="font-size:10px" 
																maxlength="10"
																size="10"
																value="<cfif isdefined("rs.ETLCcodigoElectoral") and len(trim(rs.ETLCcodigoElectoral))>#rs.ETLCcodigoElectoral#</cfif>">
														</td>		
													</tr>
													<tr>
														<td  nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Nombre_Patronal">Nombre Patronal</cf_translate></font></td>
														<td>
															<input 
																name="ETLCnomPatrono" 
																type="text" 
																id="ETLCnomPatrono"  
																tabindex="1"
																style="font-size:10px" 
																maxlength="150"
																size="60"
																value="<cfif isdefined("rs.ETLCnomPatrono") and len(trim(rs.ETLCnomPatrono))>#rs.ETLCnomPatrono#</cfif>">
														</td>
														<td>&nbsp;
															 
														</td>
														<td  nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Nombre_Comercial">Nombre Comercial</cf_translate></font></td>
														<td>
															<input 
																name="ETLCcomercial" 
																type="text" 
																id="ETLCcomercial"  
																tabindex="1"
																style="font-size:10px" 
																maxlength="150"
																size="60"
																value="<cfif isdefined("rs.ETLCcomercial") and len(trim(rs.ETLCcomercial))>#rs.ETLCcomercial#</cfif>">
														</td>
													</tr>
													<tr>
														<td  nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Cantidad_de_Empleados">Cantidad de Empleados</cf_translate></font></td>
														<td>
															<input 
																name="ETLCcantidadEmpleados" 
																type="text" 
																id="ETLCcantidadEmpleados" 
																tabindex="1" 
																style="text-align: right; font-size:10px" 
																onBlur="javascript: fm(this,0);"  
																onFocus="javascript:this.value=qf(this); this.select();"  
																onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
																value="<cfif isdefined("rs.ETLCcantidadEmpleados") and len(trim(rs.ETLCcantidadEmpleados))>#LSNumberFormat(rs.ETLCcantidadEmpleados,',9')#<cfelse>0</cfif>">
														</td>
														<td>&nbsp;
															 
														</td>
														<td  nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Planilla">Planilla</cf_translate></font></td>
														<td>
															<input 
																name="ETLCplanilla" 
																type="text" 
																id="ETLCplanilla" 
																tabindex="1" 
																style="text-align: right; font-size:10px" 
																onBlur="javascript: fm(this,0);"  
																onFocus="javascript:this.value=qf(this); this.select();"  
																onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
																value="<cfif isdefined("rs.ETLCplanilla") and len(trim(rs.ETLCplanilla))>#LSNumberFormat(rs.ETLCplanilla,',9')#<cfelse>0.00</cfif>">
														</td>
													</tr>
													<tr>
														<td valign="top"><font  style="font-size:10px"><cf_translate key="LB_Actividad">Actividad</cf_translate></font></td>
														<td >
															<textarea tabindex="1" style="font-size:10px" name="ETLCdescripcion" id="ETLCdescripcion" rows="2" style="width: 100%;"><cfif isdefined("rs.ETLCdescripcion") and len(trim(rs.ETLCdescripcion))>#rs.ETLCdescripcion#</cfif></textarea>
														</td>
														<td>&nbsp;
															 
														</td>
														<td  nowrap="nowrap" valign="top"><font  style="font-size:10px"><cf_translate key="LB_Ubicacion">Ubicaci&oacute;n</cf_translate></font></td>
														<td valign="top">
															<input 
																name="ETLCubicacion" 
																type="text" 
																id="ETLCubicacion"  
																tabindex="1"
																style="font-size:10px" 
																maxlength="10"
																size="10"
																value="<cfif isdefined("rs.ETLCubicacion") and len(trim(rs.ETLCubicacion))>#rs.ETLCubicacion#</cfif>">
														</td>
													</tr>
                                                    <tr>
														<td valign="top"><font  style="font-size:10px"><cf_translate key="LB_Las_personas_se_referencias_por">Las personas se referencias por ?</cf_translate></font></td>
														<td >

															<input 
																name="ETLCreferencia" 
																type="text" 
																id="ETLCreferencia"  
																tabindex="1"
																style="font-size:10px" 
																maxlength="60"
																size="60"
																value="<cfif isdefined("rs.ETLCreferencia") and len(trim(rs.ETLCreferencia))>#rs.ETLCreferencia#</cfif>">
														</td>
														<td colspan="3">&nbsp;	</td>
												</table>
											</fieldset>
										</td>	
									<tr>
									<tr>
										<td valign="top">
											<fieldset><legend>#LB_Informacion_Adicional#</legend>
												<table width="100%" border="0" cellpadding="0" cellspacing="0">
													<tr>
														<td  nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Telefonos_Laborales">Telefonos Laborales</cf_translate></font></td>
														<td>
															<input 
																name="ETLCtelefonoL1" 
																type="text" 
																id="ETLCtelefonoL1"  
																tabindex="1"
																style="font-size:10px" 
																maxlength="20"
																size="20"
																value="<cfif isdefined("rs.ETLCtelefonoL1") and len(trim(rs.ETLCtelefonoL1))>#rs.ETLCtelefonoL1#</cfif>">
														</td>
														<td>&nbsp;</td>
														<td>
															<input 
																name="ETLCtelefonoL2" 
																type="text" 
																id="ETLCtelefonoL2"  
																tabindex="1"
																style="font-size:10px" 
																maxlength="20"
																size="20"
																value="<cfif isdefined("rs.ETLCtelefonoL2") and len(trim(rs.ETLCtelefonoL2))>#rs.ETLCtelefonoL2#</cfif>">
														</td>
													</tr>
													<tr>
														<td nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Telefonos_Empresa">Telefonos Empresa</cf_translate></font></td>
														<td>
															<input 
																name="ETLCtelefonoE1" 
																type="text" 
																id="ETLCtelefonoE1"  
																tabindex="1"
																style="font-size:10px" 
																maxlength="20"
																size="20"
																value="<cfif isdefined("rs.ETLCtelefonoE1") and len(trim(rs.ETLCtelefonoE1))>#rs.ETLCtelefonoE1#</cfif>">
														</td>
														<td>&nbsp;</td>
														<td>
															<input 
																name="ETLCtelefonoE2" 
																type="text" 
																id="ETLCtelefonoE2"  
																tabindex="1"
																style="font-size:10px" 
																maxlength="20"
																size="20"
																value="<cfif isdefined("rs.ETLCtelefonoE2") and len(trim(rs.ETLCtelefonoE2))>#rs.ETLCtelefonoE2#</cfif>">
														</td>
														<td>&nbsp;</td>
														<td>
															<input 
																name="ETLCtelefonoE3" 
																type="text" 
																id="ETLCtelefonoE3"  
																tabindex="1"
																style="font-size:10px" 
																maxlength="20"
																size="20"
																value="<cfif isdefined("rs.ETLCtelefonoE3") and len(trim(rs.ETLCtelefonoE3))>#rs.ETLCtelefonoE3#</cfif>">
														</td>
													</tr>
													<tr bgcolor="##A0BAD3" align="center">	
														<td colspan="6"><font  style="font-size:10px"><b><cf_translate key="LB_Direccion">Direcci&oacute;n</cf_translate></b></font></td>
													</tr>
													<tr>
														<td colspan="5"  align="center">
															<cfif IsDefined('rs.ETLCdireccionEmp') And Len(rs.ETLCdireccionEmp)>
																	<cf_direccion action="input" title="" key="#rs.ETLCdireccionEmp#" tamano_letra ="10" negrita ="false">
															<cfelse>
																	<cf_direccion title="" action="input" tamano_letra ="10" negrita ="false">	
															</cfif>
															
																					
														</td>
													</tr>
													<tr bgcolor="##A0BAD3" align="center">	
														<td colspan="6"><font  style="font-size:10px"><b><cf_translate key="LB_Otras_Referencias">Otras Referencias</cf_translate></b></font></td>
													</tr>
													<tr>
														<td colspan="6">
															<fieldset><legend>#LB_Referencia# (1)</legend>
																<table width="100%" border="0" cellpadding="0" cellspacing="0">
																	<tr>	
																		<td  width="20%"><font  style="font-size:10px"><cf_translate key="LB_Telefono">Tel&eacute;fono</cf_translate></font></td>
																		<td>
																			<input 
																				name="ETLCtelefonoL1" 
																				type="text" 
																				id="ETLCtelefonoL1"  
																				tabindex="1"
																				style="font-size:10px" 
																				maxlength="20"
																				size="50"
																				value="<cfif isdefined("rs.ETLCtelefonoL1") and len(trim(rs.ETLCtelefonoL1))>#rs.ETLCtelefonoL1#</cfif>">
																		</td>
																	</tr>
																	<tr>
																		<td><font  style="font-size:10px"><cf_translate key="LB_Direccion">Direcci&oacute;n</cf_translate></font></td>
																		<td>
																			<textarea tabindex="1" style="font-size:10px" name="ETLCotrassenasE1" id="ETLCotrassenasE1" rows="2" style="width: 100%;"><cfif isdefined("rs.ETLCotrassenasE1") and len(trim(rs.ETLCotrassenasE1))>#rs.ETLCotrassenasE1#</cfif></textarea>
																		</td>
																	</tr>																
																</table>
															</fieldset>
														</td>
													</tr>	
													<tr>
														<td colspan="6">
															<fieldset><legend>#LB_Referencia# (2)</legend>
																<table width="100%" border="0" cellpadding="0" cellspacing="0">
																	<tr>	
																		<td  width="20%"><font  style="font-size:10px"><cf_translate key="LB_Telefono">Tel&eacute;fono</cf_translate></font></td>
																		<td>
																			<input 
																				name="ETLCtelefonoL2" 
																				type="text" 
																				id="ETLCtelefonoL2"  
																				tabindex="1"
																				style="font-size:10px" 
																				maxlength="20"
																				size="50"
																				value="<cfif isdefined("rs.ETLCtelefonoL2") and len(trim(rs.ETLCtelefonoL2))>#rs.ETLCtelefonoL2#</cfif>">
																		</td>
																	</tr>
																	<tr>
																		<td><font  style="font-size:10px"><cf_translate key="LB_Direccion">Direcci&oacute;n</cf_translate></font></td>
																		<td>
																			<textarea tabindex="1" style="font-size:10px" name="ETLCotrassenasE2" id="ETLCotrassenasE2" rows="2" style="width: 100%;"><cfif isdefined("rs.ETLCotrassenasE2") and len(trim(rs.ETLCotrassenasE2))>#rs.ETLCotrassenasE2#</cfif></textarea>
																		</td>
																	</tr>																
																</table>
															</fieldset>
														</td>
													</tr>
													<tr>
														<td colspan="6">
															<fieldset><legend>#LB_Referencia# (3)</legend>
																<table width="100%" border="0" cellpadding="0" cellspacing="0">
																	<tr>	
																		<td  width="20%"><font  style="font-size:10px"><cf_translate key="LB_Telefono">Tel&eacute;fono</cf_translate></font></td>
																		<td>
																			<input 
																				name="ETLCtelefonoL3" 
																				type="text" 
																				id="ETLCtelefonoL3"  
																				tabindex="1"
																				style="font-size:10px" 
																				maxlength="20"
																				size="50"
																				value="<cfif isdefined("rs.ETLCtelefonoL3") and len(trim(rs.ETLCtelefonoL3))>#rs.ETLCtelefonoL3#</cfif>">
																		</td>
																	</tr>
																	<tr>
																		<td><font  style="font-size:10px"><cf_translate key="LB_Direccion">Direcci&oacute;n</cf_translate></font></td>
																		<td>
																			<textarea tabindex="1" style="font-size:10px" name="ETLCotrassenasE3" id="ETLCotrassenasE3" rows="2" style="width: 100%;"><cfif isdefined("rs.ETLCotrassenasE3") and len(trim(rs.ETLCotrassenasE3))>#rs.ETLCotrassenasE3#</cfif></textarea>
																		</td>
																	</tr>																
																</table>
															</fieldset>
														</td>
													</tr>
												</table>
											</fieldset>
										</td>	
										<td width="45%" valign="top">
											<fieldset><legend>#LB_Responsable#</legend>
												<table width="100%" border="0" cellpadding="0" cellspacing="0">
													<tr>
														<td><font  style="font-size:10px"><cf_translate key="LB_Cedula">C&eacute;dula</cf_translate></font></td>
														<td>
															<input 
																name="ETLCcedRepresentante" 
																type="text" 
																id="ETLCcedRepresentante"  
																tabindex="1"
																style="font-size:10px" 
																maxlength="50"
																size="50"
																value="<cfif isdefined("rs.ETLCcedRepresentante") and len(trim(rs.ETLCcedRepresentante))>#rs.ETLCcedRepresentante#</cfif>">
														</td>
													</tr>
													<tr>
														<td><font  style="font-size:10px"><cf_translate key="LB_Nombre">Nombre</cf_translate></font></td>
														<td>
															<input 
																name="ETLCnomRepresentante" 
																type="text" 
																id="ETLCnomRepresentante"  
																tabindex="1"
																style="font-size:10px" 
																maxlength="80"
																size="50"
																value="<cfif isdefined("rs.ETLCnomRepresentante") and len(trim(rs.ETLCnomRepresentante))>#rs.ETLCnomRepresentante#</cfif>">
														</td>
													</tr>	
													<tr>
														<td colspan="2">
															<fieldset><legend>#LB_Referencia# (1)</legend>
																<table width="100%" border="0" cellpadding="0" cellspacing="0">
																	<tr>	
																		<td  width="20%"><font  style="font-size:10px"><cf_translate key="LB_Telefono">Tel&eacute;fono</cf_translate></font></td>
																		<td>
																			<input 
																				name="ETLCtel1Representante" 
																				type="text" 
																				id="ETLCtel1Representante"  
																				tabindex="1"
																				style="font-size:10px" 
																				maxlength="20"
																				size="20"
																				value="<cfif isdefined("rs.ETLCtel1Representante") and len(trim(rs.ETLCtel1Representante))>#rs.ETLCtel1Representante#</cfif>">
																		</td>
																	</tr>
																	<tr>
																		<td><font  style="font-size:10px"><cf_translate key="LB_Direccion">Direcci&oacute;n</cf_translate></font></td>
																		<td>
																			<textarea tabindex="1" style="font-size:10px" name="ETLCdir1Representante" id="ETLCdir1Representante" rows="2" style="width: 100%;"><cfif isdefined("rs.ETLCdir1Representante") and len(trim(rs.ETLCdir1Representante))>#rs.ETLCdir1Representante#</cfif></textarea>
																		</td>
																	</tr>																
																</table>
															</fieldset>
														</td>
													</tr>
													<tr>
														<td colspan="2">
															<fieldset><legend>#LB_Referencia# (2)</legend>
																<table width="100%" border="0" cellpadding="0" cellspacing="0">
																	<tr>	
																		<td  width="20%"><font  style="font-size:10px"><cf_translate key="LB_Telefono">Tel&eacute;fono</cf_translate></font></td>
																		<td>
																			<input 
																				name="ETLCtel2Representante" 
																				type="text" 
																				id="ETLCtel2Representante"  
																				tabindex="1"
																				style="font-size:10px" 
																				maxlength="20"
																				size="20"
																				value="<cfif isdefined("rs.ETLCtel2Representante") and len(trim(rs.ETLCtel2Representante))>#rs.ETLCtel2Representante#</cfif>">
																		</td>
																	</tr>
																	<tr>
																		<td><font  style="font-size:10px"><cf_translate key="LB_Direccion">Direcci&oacute;n</cf_translate></font></td>
																		<td>
																			<textarea tabindex="1" style="font-size:10px" name="ETLCdir2Representante" id="ETLCdir2Representante" rows="2" style="width: 100%;"><cfif isdefined("rs.ETLCdir2Representante") and len(trim(rs.ETLCdir2Representante))>#rs.ETLCdir2Representante#</cfif></textarea>
																		</td>
																	</tr>																
																</table>
															</fieldset>
														</td>
													</tr>
													<tr>
														<td colspan="2">
															<fieldset><legend>#LB_Referencia# (3)</legend>
																<table width="100%" border="0" cellpadding="0" cellspacing="0">
																	<tr>	
																		<td  width="20%"><font  style="font-size:10px"><cf_translate key="LB_Telefono">Tel&eacute;fono</cf_translate></font></td>
																		<td>
																			<input 
																				name="ETLCtel3Representante" 
																				type="text" 
																				id="ETLCtel3Representante"  
																				tabindex="1"
																				style="font-size:10px" 
																				maxlength="20"
																				size="20"
																				value="<cfif isdefined("rs.ETLCtel3Representante") and len(trim(rs.ETLCtel3Representante))>#rs.ETLCtel3Representante#</cfif>">
																		</td>
																	</tr>
																	<tr>
																		<td><font  style="font-size:10px"><cf_translate key="LB_Direccion">Direcci&oacute;n</cf_translate></font></td>
																		<td>
																			<textarea tabindex="1" style="font-size:10px" name="ETLCdir3Representante" id="ETLCdir3Representante" rows="2" style="width: 100%;"><cfif isdefined("rs.ETLCdir3Representante") and len(trim(rs.ETLCdir3Representante))>#rs.ETLCdir3Representante#</cfif></textarea>
																		</td>
																	</tr>																
																</table>
															</fieldset>
														</td>
													</tr>
												</table>
											</fieldset>
											<cfif isdefined("form.ETLCid") and len(trim(form.ETLCid)) gt 0 >
												<fieldset><legend>#LB_Formato_para_importacion_de_personas#</legend>
													<table width="100%" border="0" cellpadding="0" cellspacing="0">
														<tr>
															<td width="5%">
																<input 
																	name="FTLCcedula" 
																	type="checkbox" 
																	id="FTLCcedula"  
																	tabindex="1"
																	style="font-size:10px"  
																	checked 
																	>
															</td>
															<td><font  style="font-size:10px"><cf_translate key="LB_Cedula">C&eacute;dula</cf_translate></font></td>
														</tr>
														<tr>
															<td>&nbsp;</td>
															<td><font  style="font-size:10px"><cf_translate key="LB_Formato_Cedula">Formato C&eacute;dula</cf_translate></font></td>
														</tr>
														<tr>
															<td>&nbsp;</td>
															<td>
                                                               <!--- <select name="FTLCformato" id="FTLCformato" style="font-size:10px" tabindex="1">
                                                                    <option value="##################" <cfif isdefined("rs2.FTLCformato") and rs2.FTLCformato EQ '##################'> selected</cfif>>XXXXXXXXX</option>
                                                                    <option value="##-########-########" <cfif isdefined("rs2.FTLCformato") and rs2.FTLCformato EQ '##-########-########'> selected</cfif>>##-########-########</option>
                                                                    <option value="##-######-######" <cfif isdefined("rs2.FTLCformato") and rs2.FTLCformato EQ '##-######-######'> selected</cfif>>##-######-######</option>
                                                                </select>  --->   
                                                                <select name="FTLCformato" id="FTLCformato" style="font-size:10px" tabindex="1" onchange="javascript:PintaAyuda()">
                                                                    <option value="1" <cfif isdefined("rs2.FTLCformato") and rs2.FTLCformato EQ 1> selected</cfif>>XXXXXXXXX</option>
                                                                    <option value="2" <cfif isdefined("rs2.FTLCformato") and rs2.FTLCformato EQ 2> selected</cfif>>XXXXXXX</option>
                                                                    <option value="3" <cfif isdefined("rs2.FTLCformato") and rs2.FTLCformato EQ 3> selected</cfif>>X-XXXX-XXXX</option>
                                                                    <option value="4" <cfif isdefined("rs2.FTLCformato") and rs2.FTLCformato EQ 4> selected</cfif>>X-XXX-XXX</option>
                                                                </select>
                                                               
                                                                
															</td>
														</tr>
                                                        <tr>
															<td>&nbsp;</td>
                                                            <td>    
                                                                <input 
                                                                name="EJEMPLO" 
                                                                type="text" 
                                                                id="EJEMPLO"  
                                                                size="80"
                                                                tabindex="1"
                                                                style="font-size:10px;border: medium none; text-align:left; size:auto;"  
                                                                value="">
                                                            <td>
                                                        </tr>    
														<tr>
															<td>
																<input 
																	name="FTLCnombreCKC" 
																	type="checkbox" 
																	id="FTLCnombreCKC"  
																	tabindex="1"
																	style="font-size:10px"  
																	<cfif isdefined("rs2") and rs2.FTLCnombreCKC eq 1>checked</cfif>>
															</td>
															<td><font  style="font-size:10px"><cf_translate key="LB_Nombre">Nombre</cf_translate></font></td>
														</tr>
														<tr>
															<td>
																<input 
																	name="FTLCapellido1CKC" 
																	type="checkbox" 
																	id="FTLCapellido1CKC"  
																	tabindex="1"
																	style="font-size:10px"  
																	<cfif isdefined("rs2") and rs2.FTLCapellido1CKC eq 1>checked</cfif>>
															</td>
															<td><font  style="font-size:10px"><cf_translate key="LB_Primer_Apellido">Primer Apellido</cf_translate></font></td>
														</tr>
														<tr>
															<td>
																<input 
																	name="FTLCapellido2CKC" 
																	type="checkbox" 
																	id="FTLCapellido2CKC"  
																	tabindex="1"
																	style="font-size:10px"  
																	<cfif isdefined("rs2") and rs2.FTLCapellido2CKC eq 1>checked</cfif>>
															</td>
															<td><font  style="font-size:10px"><cf_translate key="LB_Segundo_Apellido">Segundo Apellido</cf_translate></font></td>
														</tr>
                                                        <tr>
                                                        	<td>&nbsp;</td>
                                                            <td>
                                                        	<font  style="font-size:10px"><cfif isdefined("rs2.FTLCdescricion1") and len(trim(rs2.FTLCdescricion1))>#rs2.FTLCdescricion1#&nbsp;<cf_translate key="LB_Referencia">(Referencia)</cf_translate></font></cfif>
                                                            </td>
 														</tr>
                                                        <tr>
															<td>
																<input 
																	name="FTLCopcion2" 
																	type="checkbox" 
																	id="FTLCopcion2"  
																	tabindex="1"
																	style="font-size:10px"  
																	<cfif isdefined("rs2") and rs2.FTLCopcion2 eq 1>checked</cfif>>
															</td>
															<td>
															<input 
																	name="FTLCdescricion2" 
																	type="text" 
																	id="FTLCdescricion2"  
																	tabindex="1"
																	style="font-size:10px" 
																	maxlength="50"
																	size="50"
																	value="<cfif isdefined("rs2") and len(trim(rs2.FTLCdescricion2))>#rs2.FTLCdescricion2#</cfif>">
															</td>
														</tr>
														<tr>
															<td>
																<input 
																	name="FTLCopcion3" 
																	type="checkbox" 
																	id="FTLCopcion3"  
																	tabindex="1"
																	style="font-size:10px"  
																	<cfif isdefined("rs2") and rs2.FTLCopcion3 eq 1>checked</cfif>>
															</td>
															<td>
															<input 
																	name="FTLCdescricion3" 
																	type="text" 
																	id="FTLCdescricion3"  
																	tabindex="1"
																	style="font-size:10px" 
																	maxlength="50"
																	size="50"
																	value="<cfif isdefined("rs2") and len(trim(rs2.FTLCdescricion3))>#rs2.FTLCdescricion3#</cfif>">
															</td>
														</tr>
														<tr>
															<td>
																<input 
																	name="FTLCopcion4" 
																	type="checkbox" 
																	id="FTLCopcion4"  
																	tabindex="1"
																	style="font-size:10px"  
																	<cfif isdefined("rs2") and rs2.FTLCopcion4 eq 1>checked</cfif>>
															</td>
															<td>
															<input 
																	name="FTLCdescricion4" 
																	type="text" 
																	id="FTLCdescricion4"  
																	tabindex="1"
																	style="font-size:10px" 
																	maxlength="50"
																	size="50"
																	value="<cfif isdefined("rs2") and len(trim(rs2.FTLCdescricion4))>#rs2.FTLCdescricion4#</cfif>">
															</td>
														</tr>
													</table>
												</fieldset>
											</cfif>
										</td>
										
									<tr>
								</table>
							</fieldset>	
							
						</td>
					</tr>	
				</table>
				<cfset ts = "">	
				<cfif isdefined("form.ETLCid") and len(trim(form.ETLCid)) gt 0 >
					<cfinvoke 
						component="sif.Componentes.DButils"
						method="toTimeStamp"
						returnvariable="ts">
						<cfinvokeargument name="arTimeStamp" value="#rs.ts_rversion#"/>
					</cfinvoke>
				</cfif>
				<input type="hidden" name="ts_rversion" value="<cfif isdefined("form.ETLCid") and len(trim(form.ETLCid)) gt 0 >#ts#</cfif>">
				<input name="ETLCid" type="hidden" id="ETLCid" value="<cfif isdefined("form.ETLCid") and len(trim(form.ETLCid)) gt 0 >#form.ETLCid#</cfif>">
				<input name="FTLCid" type="hidden" id="FTLCid" value="<cfif isdefined("rs2.FTLCid") and len(trim(rs2.FTLCid)) gt 0 >#rs2.FTLCid#</cfif>">


				<input name="AccionAEjecutar" type="hidden" id="AccionAEjecutar" value="">
			</form>
			</cfoutput>
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_CedulaJuridica_es_requerido"
Default="Cedula Jurídica es requerido"
returnvariable="LB_CedulaJuridica"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Nombre_Patronal_es_requerido"
Default="Nombre Patronal es requerido"
returnvariable="LB_Nombre_Patronal"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_La_referencia_a_las_personas_es_requerido"
Default="La referencia a las personas es requerido"
returnvariable="LB_Referencia"/>


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_PorFavorReviseLosSiguienteDatos"
Default="Por favor revise los siguiente datos"	
returnvariable="MSG_PorFavorReviseLosSiguienteDatos"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_Formato_de_la_cedula"
Default="Formato de la Cédula"	
returnvariable="MSG_Formato_de_la_cedula"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_ejemplo_cedula1"
Default="Cédula con 9 dígitos, ejemplo 102340567"	
returnvariable="MSG_ejemplo_cedula1"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_ejemplo_cedula2"
Default="Cédula con 7 dígitos, ejemplo 1234567"	
returnvariable="MSG_ejemplo_cedula2"/>    

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_ejemplo_cedula3"
Default="Cédula con 9 dígitos y separador, ejemplo 1-0234-0567"	
returnvariable="MSG_ejemplo_cedula3"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_ejemplo_cedula4"
Default="Cédula con 7 dígitos y separador, ejemplo 1-234-567"	
returnvariable="MSG_ejemplo_cedula4"/>  

<script language="javascript" type="text/javascript">
	<!--//
	<cfoutput>
	
	function validar(){
		var error_msg = '';
		if (document.form1.ETLCpatrono.value == ""){
			error_msg += "\n - <cfoutput>#LB_CedulaJuridica#</cfoutput>.";
		}
		if (document.form1.ETLCnomPatrono.value == ""){
			error_msg += "\n - <cfoutput>#LB_Nombre_Patronal#</cfoutput>.";
		}
		
		if (document.form1.ETLCreferencia.value == ""){
			error_msg += "\n - <cfoutput>#LB_Referencia#</cfoutput>.";
		}

		<cfif isdefined("form.ETLCid") and len(trim(form.ETLCid)) gt 0 >
			if (document.form1.FTLCformato.value == ""){
				error_msg += "\n - <cfoutput>#MSG_Formato_de_la_cedula#</cfoutput>.";
			}
		</cfif>
				
		if (error_msg.length != "") {
			alert("<cfoutput>#MSG_PorFavorReviseLosSiguienteDatos#</cfoutput>:"+error_msg);
			return false;
		}
		return true;	
	
	}

	function funcAgregar(){
		if(validar()){
			document.form1.AccionAEjecutar.value="AGREGAR";
			document.form1.submit();
		}
	}
	
	
	
	function PintaAyuda(){
		if (document.form1.FTLCformato.value == '1'){
			document.form1.EJEMPLO.value = '<cfoutput>#MSG_ejemplo_cedula1#</cfoutput>';
		}
		if (document.form1.FTLCformato.value == '2'){
			document.form1.EJEMPLO.value = '<cfoutput>#MSG_ejemplo_cedula2#</cfoutput>';
		}
		if (document.form1.FTLCformato.value == '3'){
			document.form1.EJEMPLO.value = '<cfoutput>#MSG_ejemplo_cedula3#</cfoutput>';
		}
		if (document.form1.FTLCformato.value == '4'){
			document.form1.EJEMPLO.value = '<cfoutput>#MSG_ejemplo_cedula4#</cfoutput>';
		}
	}
			
	PintaAyuda();
	
	function funcLimpiar(){
		document.form1.reset();
	}	

	function funcRegresar(){
		location.href ='Empresas-lista.cfm';
	}
	
	function funcModificar(){
		if(validar()){
			document.form1.AccionAEjecutar.value="MODIFICAR";
			document.form1.submit();
		}
	}

	function funcEliminar(){
		document.form1.AccionAEjecutar.value="ELIMINAR";
		document.form1.submit();
	}	
	
	function funcNuevo(){
		document.form1.AccionAEjecutar.value="NUEVO";
		document.form1.submit();
	}
	
	function  funcPersonas(){
		document.form1.action ="/cfmx/hosting/tratado/operacion/personas/Personas-lista.cfm"
		document.form1.submit();
	
	
	}
	
	</cfoutput>	
	//-->
</script>