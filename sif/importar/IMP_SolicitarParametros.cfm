<cf_template template="#session.sitio.template#">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EjecucionDeScriptsDeExportacion"
	Default="Ejecuci&oacute;n de Scripts de Exportaci&oacute;n "
	returnvariable="LB_EjecucionDeScriptsDeExportacion"/> 	
	
	<cf_templatearea name="title">
		<cfoutput>#LB_EjecucionDeScriptsDeExportacion#</cfoutput>
	</cf_templatearea>
	<cf_templatearea name="body">
		<cfif not isdefined("FORM.Directo") and isdefined("URL.Directo")>
			<cfset FORM.Directo =URL.Directo>
		</cfif>
		<cfif not isdefined("FORM.Directo") and not isdefined("URL.Directo")>
			<cfset FORM.Directo ="N">
		</cfif>	
		<cfif not isdefined("FORM.MODULO") and isdefined("URL.MODULO")>
			<cfset FORM.MODULO =URL.MODULO>
		</cfif>
		<cfif not isdefined("FORM.PARAMETROS") and isdefined("URL.PARAMETROS")>
			<cfset FORM.PARAMETROS =URL.PARAMETROS>
		</cfif>		
		<cfif FORM.Directo EQ 'S'>
			<cfif not isdefined("FORM.EIcodigo") and isdefined("URL.EIcodigo")>
				<cfset FORM.EIcodigo =URL.EIcodigo>
			</cfif>	
			<cfif not isdefined("FORM.EIid") and isdefined("URL.EIid")>
				<cfset FORM.EIid =URL.EIid>
			</cfif>	
		</cfif>		

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_EjecucionDeScriptsDeExportacion#'>
			<cfoutput>
			<cfquery name="RSValidaExportador" datasource="sifcontrol">
				select a.EIid
					from EImportador a 
					inner join  EImportadorEmpresa b 
					on a.EIid = b.EIid
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigosdc#"> 
					inner join  EImportadorUsuario c 
					on b.EIid = c.EIid
					and  b.Ecodigo = c.Ecodigo
					and  c.Usucodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> 
					where not a.EIcodigo like '%.[0-9][0-9][0-9]'
					and a.EIexporta  = 1
					and a.EIid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
				union
				select a.EIid
					from EImportador a 
					inner join  EImportadorEmpresa b 
					on a.EIid = b.EIid
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigosdc#"> 
					left outer join  EImportadorUsuario c 
					on b.EIid = c.EIid
					and  b.Ecodigo = c.Ecodigo
					and c.EIid is null
					and c.Ecodigo is null
					and c.Usucodigo is null		
					where not a.EIcodigo like '%.[0-9][0-9][0-9]'
					and a.EIexporta  = 1
					and a.EIid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
			</cfquery>			
			<cfif RSValidaExportador.recordCount GT 0>
				<cfquery name="rsScript" datasource="sifcontrol">
					select EIid, EIcodigo, EImodulo, EIexporta, EIimporta, EIdescripcion,coalesce(EIcfparam,'') as EIcfparam
					from EImportador
					where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
					order by upper(EIcodigo)
				</cfquery>
				
				<cfquery name="rsDetalle" datasource="sifcontrol">
					select DInumero, DInombre, DIdescripcion, DItipo, DIlongitud
					from DImportador
					where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
					and DInumero < 0
				</cfquery>
				<form name="form" action="IMP_EjecutarExportador.cfm" method="post">
					<input type="hidden" name="MODULO" value="#FORM.MODULO#">
					<input type="hidden" name="PARAMETROS" value="#FORM.PARAMETROS#">
					<input type="hidden" name="EIid" value="#Form.EIid#">
					<cfif rsDetalle.recordCount GT 0>
						<table width="100%"  border="0">
							<tr>
								<td  valign="top" width="35%" ><cf_sifFormatoArchivoImpr EIcodigo = "#rsScript.EICODIGO#" Tipo="E"></td>
								<td  valign="top" width="65%" >
									<table width="100%"  border="0" cellspacing="0" cellpadding="2">
										<tr>
											<td colspan="2">&nbsp;</td>
										</tr>
										<tr>
										  <td align="right" style="padding-right: 10px; "><strong><cf_translate  key="LB_Empresa">Empresa</cf_translate>:</strong></td>
										  <td>#Session.Enombre#</td>
										</tr>
										<tr> 
											<td align="right" width="50%" style="padding-right: 10px; ">
												<strong><cf_translate  key="LB_ScriptQueDeseaEjecutar">Script que desea ejecutar</cf_translate>:</strong>
											</td>
											<td> 
												#rsScript.EIcodigo# - #rsScript.EIdescripcion#
											</td>
										</tr>
										<tr>
											<td colspan="2">&nbsp;</td>
										</tr>
										<tr>
											<td colspan="2" align="center"><strong><cf_translate  key="LB_PORFAVORSUMINISTRELOSSIGUIENTESPARAMETROS">POR FAVOR SUMINISTRE LOS SIGUIENTES PARAMETROS</cf_translate></strong></td>
										</tr>
										<cfif isdefined("rsScript.EIcfparam") and len(trim(rsScript.EIcfparam)) >
											<tr><td colspan="2" align="center">
											<cfinclude template="#rsScript.EIcfparam#">
											</td></tr>
										<cfelse>
											<cfif len(trim(FORM.PARAMETROS))>
												<cfset arreglo = listtoarray(FORM.PARAMETROS,"|")>	
											</cfif>
											
											<cfloop query="rsDetalle">
														
														<cfif isdefined("arreglo")>
															<cfset EnviaValor = false>
															
															<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
																<cfset arreglo2 = listtoarray(arreglo[i],"=")>
																<cfif trim(arreglo2[1]) eq trim(rsDetalle.DInombre)>
																	<cfset EnviaValor = true>
																	<cfset Valor = arreglo2[2]>
																</cfif>
															</cfloop>
															<cfif EnviaValor>
																<tr>
																	<td align="right" width="50%" style="padding-right: 10px; ">
																		<strong>#rsDetalle.DIdescripcion#:</strong>
																	</td>
																	<td> 
																		#Valor#
																		<input type="hidden" name="#rsDetalle.DInombre#" value="#Valor#">
																	</td>
																</tr>																						
															<cfelse>
																<tr>
																	<td align="right" width="50%" style="padding-right: 10px; ">
																		<strong>#rsDetalle.DIdescripcion#:</strong>
																	</td>
																	<td> 
																		<input type="text" name="#rsDetalle.DInombre#" value="">
																	</td>
																</tr>		
															</cfif>
														<cfelse>
															<tr>
																<td align="right" width="50%" style="padding-right: 10px; ">
																	<strong>#rsDetalle.DIdescripcion#:</strong>
																</td>
																<td> 
																	<input type="text" name="#rsDetalle.DInombre#" value="">
																</td>
															</tr>																		
														</cfif>
											</cfloop>											
										</cfif>										
										<tr>
											<td colspan="2">&nbsp;</td>
										</tr>
										<tr align="center">
										  <td colspan="2" style="padding-right: 10px; ">
											<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="BTN_Anterior"
											Default="Anterior"
											returnvariable="BTN_Anterior"/>
											
											<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="BTN_Siguiente"
											Default="Siguiente"
											returnvariable="BTN_Siguiente"/>
											
											
											<cfif FORM.Directo EQ 'N'>
												<input name="btnAnterior" type="submit" id="btnAnterior" value="<cfoutput>#BTN_Anterior#</cfoutput>" onClick="javascript: Regresar();">
											</cfif>		
											<input name="btnSiguiente" type="submit" id="btnSiguiente" value=<cfoutput>"#BTN_Siguiente#</cfoutput>" >
										  </td>
										</tr>
										<tr>
											<td colspan="2">&nbsp;</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</cfif>			
				<cfelse>
					<table width="100%"  border="0">
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
						<tr>
						  <td align="center" colspan="2" style="padding-right: 10px; "><strong><cf_translate  key="LB_Empresa">Empresa</cf_translate>:</strong>  #Session.Enombre#</td>
					  </tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>		  
						<tr> 
							<td align="center"  colspan="2" style="padding-right: 10px; ">
								<cf_translate  key="LB_ElUsuario">El Usuario</cf_translate>  <strong>#Session.usulogin#</strong>  <cf_translate  key="LB_NoTieneDerechosParaUtilizarElExportador">no tiene derechos para utilizar el exportador</cf_translate>
							</td>
						</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>						
						<tr align="center">
						  <td colspan="2" style="padding-right: 10px; ">
							<cfif FORM.Directo EQ 'N'>
								<cfinvoke component="sif.Componentes.Translate"
								method="Translate"
								Key="BTN_Anterior"
								Default="Anterior"
								returnvariable="BTN_Anterior"/>
								
								<input name="btnAnterior" type="submit" id="btnAnterior" value="<cfoutput>#BTN_Anterior#</cfoutput>" onClick="javascript: Regresar();">
							</cfif>		
						  </td>
						</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>				
					</table>
				</cfif>
			</form>
			</cfoutput>
		<cf_web_portlet_end>	
	</cf_templatearea>
</cf_template>
<script language="JavaScript1.2" type="text/javascript">
	function Regresar(){
		document.form.action="IMP_SeleccionExportadores.cfm";
		document.form.submit();
	}	

</script>	
	






