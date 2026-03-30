<cfoutput>
<cfif modo eq 'CAMBIO'>
	<cfinvoke component="rh.Componentes.RH_Valoracion" method="fnGetE" returnvariable="rsE">
        <cfinvokeargument name="RHEVFid" value="#form.RHEVFid#">
    </cfinvoke>
</cfif>
<cfif modoD eq 'CAMBIO'>
	<cfinvoke component="rh.Componentes.RH_Valoracion" method="fnGetD" returnvariable="rsD">
        <cfinvokeargument name="RHEVFid" value="#form.RHEVFid#">
        <cfinvokeargument name="RHDVFid" value="#form.RHDVFid#">
    </cfinvoke>
</cfif>
<style type="text/css">
	.factores{
		font-size:18px;
		font-weight:bold;
	}
	.sTitulos{
		font-size:13px;
		font-weight:bold;
	}
</style>
<script language="javascript1.2" type="text/javascript">

	function funcAltaE(){
		return 	fnValidarE();
	}
	
	function funcCambioE(){
		return 	fnValidarE();
	}
	
	function fnValidarE(){
		error = "";
		if(rtrim(document.form1.RHEVFcodigo.value).length == 0)
			error = error + " - Código es requerido.\n";
		if(rtrim(document.form1.RHEVFdescripcion.value).length == 0)
			error = error + " - Descripción es requerido.\n";
		if(rtrim(document.form1.RHEVFfecha.value).length == 0)
			error = error + " - Fecha es requerido.\n";
		if(error.length > 0){
			alert("Errores encontrados:\n"+error);
			return false;
		}
		return true;
	}
	
	function funcAltaD(){
		error = "";
		if(rtrim(document.formD.RHPcodigo.value).length == 0)
			error = error + " - Puesto es requerido.\n";
		if(error.length > 0){
			alert("Errores encontrados:\n"+error);
			return false;
		}
		return true;
	}
	
	function rtrim(s) {
		return s.replace(/\s+$/, "");
	}

</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
    	<td colspan="2" align="center"><fieldset><legend>Encabezado</legend>
            <table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
                <form name="form1" method="post" action="Valoracion-sql.cfm">
                <tr>
                    <td align="right" width="50%"><strong>#LB_Codigo#</strong>:&nbsp;</td>
                    <td><input name="RHEVFcodigo" id="RHEVFcodigo" type="text" maxlength="10" value="#rsE.RHEVFcodigo#" /></td>
                </tr>
                <tr>
                    <td align="right" width="50%"><strong>#LB_Descripcion#</strong>:&nbsp;</td>
                    <td><input name="RHEVFdescripcion" id="RHEVFdescripcion" type="text" maxlength="60" value="#rsE.RHEVFdescripcion#" /></td>
                </tr>
                <tr>
                    <td align="right" width="50%"><strong>#LB_Fecha#</strong>:&nbsp;</td>
                    <td><cf_sifcalendario form="form1" name="RHEVFfecha" value="#dateformat(rsE.RHEVFfecha,'dd/mm/yyyy')#"></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <cf_botones modo="#modo#" sufijo="E">
                        <cfif isdefined('form.RHEVFid')>
                         <input name="RHEVFid" id="RHEVFid" type="hidden" value="#form.RHEVFid#"/>
                        </cfif>
                    </td>
                </tr>
                </form>
            </table>
    	</fieldset></td>
    </tr>
<cfif modo eq 'CAMBIO'>
    <tr><td colspan="2" align="center"><fieldset><legend>Detalle Puesto</legend>
    	<form name="formD" method="post" action="Valoracion-sql.cfm">
        	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                <tr>
                    <td align="center"><strong>#LB_Puesto#:&nbsp;</strong>
                        <cfset valuesArray = ArrayNew(1)>
                        <cfset readonly = 'no'>
                        <cfif modoD eq 'CAMBIO'>
                            <cfquery name="rsPuestoA" datasource="#session.DSN#">
                                select coalesce(RHPcodigoext,RHPcodigo) as RHPcodigoext,RHPcodigo, RHPdescpuesto
                                from RHPuestos
                                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsD.RHPcodigo#">
                            </cfquery>
                            <cfset ArrayAppend(valuesArray, rsPuestoA.RHPcodigo)>
                          <cfset ArrayAppend(valuesArray, rsPuestoA.RHPcodigoext)>
                          <cfset ArrayAppend(valuesArray, rsPuestoA.RHPdescpuesto)>
                          <cfset readonly = 'yes'>
                        </cfif>
                      <cf_conlis
                            campos="RHPcodigo,RHPcodigoext,RHPdescpuesto"
                            desplegables="N,S,S"
                            modificables="N,S,N"
                            size="0,10,50"
                            title="#LB_ListaDePuestos#"
                            tabla="RHPuestos a"
                            columnas="RHPcodigo as RHPcodigo, coalesce(RHPcodigoext,RHPcodigo) as RHPcodigoext, RHPdescpuesto as RHPdescpuesto"
                            filtro=" a.Ecodigo = #Session.Ecodigo# and a.RHPactivo = 1 and not exists(select 1 from RHDValoracionFactores dvf where dvf.RHEVFid = #form.RHEVFid# and dvf.RHPcodigo = a.RHPcodigo)"
                            desplegar="RHPcodigoext,RHPdescpuesto"
                            filtrar_por="coalesce(RHPcodigoext,RHPcodigo)|RHPdescpuesto"
                            filtrar_por_delimiters="|"
                            etiquetas="#LB_Codigo#,#LB_Descripcion#"
                            formatos="S,S"
                            align="left,left"
                            asignar="RHPcodigo,RHPcodigoext,RHPdescpuesto"
                            asignarformatos="I,S,S"
                            showEmptyListMsg="true"
                            tabindex="1"
                            form = "formD"
                            readonly="#readonly#"
                            valuesArray="#valuesArray#">
                    </td>
                </tr>
                <cfset lvarRHDVFdesripcion = "">
                <cfif modoD eq 'CAMBIO'>
                    <cfset lvarRHDVFdesripcion = rsD.RHDVFdesripcion>
                </cfif>
                <tr>
                    <td height="70px">
                        <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="left" titulo="#LB_Descripcion#">
                            <cf_rheditorhtml name="RHDVFdesripcion" value="#lvarRHDVFdesripcion#">
                        <cf_web_portlet_end>
                    </td>
                </tr>
                <tr>
                    <td>
                        <cf_botones modo="#modoD#" sufijo="D">
                        <input name="RHEVFid" id="RHEVFid" type="hidden" value="#form.RHEVFid#"/>
                        <cfif isdefined('form.RHDVFid')>
                         <input name="RHDVFid" id="RHDVFid" type="hidden" value="#form.RHDVFid#"/>
                        </cfif>
                    </td>
                </tr>
            </table>
        </form>
	</fieldset></td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td width="30%" valign="top">
			<cfinvoke component="rh.Componentes.RH_Valoracion" method="fnGetD" returnvariable="rsDs">
				<cfinvokeargument name="RHEVFid" value="#form.RHEVFid#">
			</cfinvoke>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				query="#rsDs#"
				desplegar="RHPcodigoext,RHPdescpuesto"
				etiquetas="#LB_Codigo#,#LB_Descripcion#"
				formatos="S,S"
				align="left,left"
				ira="Valoracion.cfm"
				showlink="true" 
				incluyeform="true"
				form_method="post"
				showEmptyListMsg="yes"
				keys="RHDVFid"
				usaAJAX = "true"
				conexion = "#session.DSN#"	
				PageIndex = "1"
				mostrar_filtro 	="true"		
			/>
		</td>
		<td>    
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
			<cfif modoD eq 'CAMBIO'><form name="formS" method="post" action="Valoracion-sql.cfm">
				<tr><td colspan="2"><fieldset><legend>Valoración</legend>
					<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
						<cfset camposCod = "">
						<cfif modoD eq 'CAMBIO'>
							<cfinvoke component="rh.Componentes.RH_Valoracion" method="fnGetS" returnvariable="rsSs">
								<cfinvokeargument name="RHDVFid" value="#form.RHDVFid#">
							</cfinvoke>
							<cfquery name="rsTotales" dbtype="query">
								select sum(RHSVFpuntos) as pts,  sum(RHSVFpuntosPropuesta) ptsP, sum(ptsSF) as ptsSF
								from rsSs
							</cfquery>
							<cfif rsSs.recordcount gt 0>
								<cfset lvarRHHFid =  -1>
								<cfset lvarCodAnterior =  "">
								<cfloop query="rsSs">
                                	<cfset lvarCodigoF = rsSs.tipo>
                                    <cfset lvarCodigoSF = rsSs.RHSVFid>
									<cfset camposCod = camposCod & trim(lvarCodigoF) & "&" & trim(lvarCodigoSF) & "|" & rsSs.RHSVFid &  ",">
									<cfif lvarRHHFid neq -1 and lvarRHHFid neq rsSs.RHHFid>
										<cfquery name="rsSubTotales" dbtype="query">
											select sum(RHSVFpuntos) as RHSVFpuntos, sum(RHSVFpuntosPropuesta) as RHSVFpuntosPropuesta, sum(ptsSF) as ptsSF from rsSs where RHHFid <cfif len(trim(lvarRHHFid)) gt 0 > = #lvarRHHFid# <cfelse> is null</cfif>
										</cfquery>
										<tr>
											<td style="border-right:ridge" nowrap><strong>Sub-Totales</strong></td>
											<td>&nbsp;</td>
											<td align="right" style="border-right:ridge;border-top:ridge">#fnFormatMoney(iif(len(trim(rsSubTotales.RHSVFpuntos)) gt 0,rsSubTotales.RHSVFpuntos,0))#</td>
											<td>&nbsp;</td>
											<td align="right" style="border-top:ridge"><cf_monto name="sTotales_#trim(lvarCodAnterior)#"  value="#iif(len(trim(rsSubTotales.RHSVFpuntosPropuesta)) gt 0,rsSubTotales.RHSVFpuntosPropuesta,0)#" size="8" decimales="2" negativos="false" readonly="true" style="border:none"></td>
											<td align="right" style="border-top:ridge" nowrap>&nbsp;de #fnFormatMoney(iif(len(trim(rsSubTotales.ptsSF)) gt 0,rsSubTotales.ptsSF,0))#</td>
										</tr>
										<tr><td colspan="6"><textarea title="Descripci&oacute;n del grado" id="et_#trim(lvarCodAnterior)#" rows="3" style="width:100%" readonly></textarea></td>
										<tr><td colspan="6">&nbsp;</td></tr>
										</table><cf_web_portlet_end></td></tr>
									</cfif>
									<cfif lvarRHHFid neq rsSs.RHHFid>
										<cfset lvarRHHFid = rsSs.RHHFid>
										<cfset lvarCodAnterior = rsSs.tipo>
										<tr>
											<td><cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#rsSs.descripcionF#">
												<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
												<tr>
												   <td class="sTitulos" rowspan="3" style="border-right:ridge" width="100%">Nombre</td>
												   <td align="center" colspan="2" class="sTitulos" style="border-right:ridge">Actual</td>
												   <td align="center" class="sTitulos" colspan="3">Propuesto</td>
												</tr>
												<tr>
												   <td align="center" class="sTitulos">Grado</td>
												   <td align="center" class="sTitulos" style="border-right:ridge">Pts</td>
												   <td align="center" class="sTitulos">Grado</td>
												   <td align="center" class="sTitulos" colspan="2">Pts</td>
												</tr>
												<tr>
													<td colspan="2" style="border-right:ridge">&nbsp;</td>
													<td colspan="3">&nbsp;</td>
												</tr>
									</cfif>
									<tr>
										<td style="border-right:ridge" nowrap><strong><cfif len(trim(rsSs.RHHSFid)) gt 0>#rsSs.descripcionSF#<cfelse>#rsSs.descripcion# (Desc. Alt.)</cfif></strong></td>
										<td align="center">#rsSs.RHSVFgrado#</td>
										<td align="right" style="border-right:ridge">#fnFormatMoney(rsSs.RHSVFpuntos)#</td>
										<cfif len(trim(rsSs.RHHSFid)) gt 0>
											<td align="right">
												<cfinvoke component="rh.Componentes.RH_Valoracion" method="fnGetGrados" returnvariable="rsGrados">
													<cfif len(trim(rsSs.RHHid))>
														<cfinvokeargument name="RHHid" value="#rsSs.RHHid#">
													<cfelseif len(trim(rsSs.RHECGid))>
														<cfinvokeargument name="RHECGid" value="#rsSs.RHECGid#">
													<cfelseif  len(trim(rsSs.RHDDVlinea))>
														<cfinvokeargument name="RHDDVlinea" value="#rsSs.RHDDVlinea#">
													</cfif>
												</cfinvoke>
												<select style="width:100%" id="RHSVFgradoPropuesta_#trim(lvarCodigoF)#_#trim(lvarCodigoSF)#" name="RHSVFgradoPropuesta_#trim(lvarCodigoF)#_#trim(lvarCodigoSF)#" onchange="fnActulizarPTS(#rsSs.ptsSF#,#rsGrados.recordcount#,this.value,'#trim(lvarCodigoF)#','#trim(lvarCodigoSF)#')" onblur="document.getElementById('et_#trim(lvarCodigoF)#').value=''" onfocus="fnActualizarMSG('#trim(lvarCodigoF)#','#trim(lvarCodigoSF)#',this.value);">
													<cfloop query="rsGrados">
														<option value="#rsGrados.grado#" <cfif rsSs.RHSVFgradoPropuesta eq rsGrados.grado>selected</cfif>>#rsGrados.grado#</option>
													</cfloop>
												</select>
												<cfloop query="rsGrados">
													<cfset MSG = replace(rsGrados.descripcion,'"',"'",'ALL')>
													<input type="hidden" name="l_#trim(lvarCodigoF)#_#trim(lvarCodigoSF)#_#rsGrados.grado#" id="l_#trim(lvarCodigoF)#_#trim(lvarCodigoSF)#_#rsGrados.grado#" value="#MSG#"/>
												</cfloop>
											</td>
											<td align="right" nowrap>
												<cf_monto name="RHSVFpuntosPropuesta_#trim(lvarCodigoF)#_#trim(lvarCodigoSF)#"  value="#rsSs.RHSVFpuntosPropuesta#" size="8" decimales="2" negativos="false" readonly="true"  style="border:none">
											</td>
											<td align="right" nowrap>&nbsp;de #fnFormatMoney(rsSs.ptsSF)#</td>
										<cfelse>
											<td align="center">#rsSs.RHSVFgradoPropuesta#<input type="hidden" name="RHSVFgradoPropuesta_#trim(lvarCodigoF)#_#trim(lvarCodigoSF)#" id="RHSVFgradoPropuesta_#trim(lvarCodigoF)#_#trim(lvarCodigoSF)#" value="#rsSs.RHSVFgradoPropuesta#" /></td>
											<td align="right" nowrap><cf_monto name="RHSVFpuntosPropuesta_#trim(lvarCodigoF)#_#trim(lvarCodigoSF)#"  value="#rsSs.RHSVFpuntosPropuesta#" size="8" decimales="2" negativos="false" readonly="true" style="border:none"></td>
											 <td align="right" nowrap>&nbsp;</td>
										</cfif>
									</tr>
								</cfloop>
								<cfquery name="rsSubTotales" dbtype="query">
									select sum(RHSVFpuntos) as RHSVFpuntos, sum(RHSVFpuntosPropuesta) as RHSVFpuntosPropuesta, sum(ptsSF) as ptsSF from rsSs where RHHFid <cfif len(trim(lvarRHHFid)) gt 0 > = #lvarRHHFid# <cfelse> is null</cfif>
								</cfquery>
								<tr>
									<td style="border-right:ridge" nowrap><strong>Sub-Totales</strong></td>
									<td>&nbsp;</td>
									<td align="right" style="border-right:ridge;border-top:ridge">#fnFormatMoney(iif(len(trim(rsSubTotales.RHSVFpuntos)) gt 0,rsSubTotales.RHSVFpuntos,0))#</td>
									<td>&nbsp;</td>
									<td align="right" style="border-top:ridge"><cf_monto name="sTotales_#trim(lvarCodAnterior)#"  value="#iif(len(trim(rsSubTotales.RHSVFpuntosPropuesta)) gt 0,rsSubTotales.RHSVFpuntosPropuesta,0)#" size="8" decimales="2" negativos="false" readonly="true" style="border:none"></td>
									<td align="right" style="border-top:ridge" nowrap>&nbsp;de #fnFormatMoney(iif(len(trim(rsSubTotales.ptsSF)) gt 0,rsSubTotales.ptsSF,0))#</td>
								</tr>
								<tr><td colspan="6"><textarea title="Descripci&oacute;n del grado" id="et_#trim(lvarCodAnterior)#" rows="3" style="width:100%" readonly></textarea></td>
								</table><cf_web_portlet_end></td></tr>
								<tr><td align="center"><cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Totales">
									<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
										<tr>
											<td align="center" class="sTitulos">PTS Actual</td>
											<td align="center" class="sTitulos">PTS Propuesto</td>
											<td align="center" class="sTitulos">PTS Diferiencia</td>
											<td align="center" class="sTitulos">PTS Máximo</td>
										</tr>
										<tr>
											<td align="center">#fnFormatMoney(rsTotales.pts)#</td>
											<td align="center"><cf_monto name="totales"  value="#rsTotales.ptsP#" size="8" decimales="2" negativos="false" readonly="true" style="border:none"></td>
											<td align="center"><cf_monto name="diferiencia"  value="#(rsTotales.ptsP - rsTotales.pts)#" size="8" decimales="2" negativos="false" readonly="true" style="border:none"></td>
											<td align="center">#fnFormatMoney(rsTotales.ptsSF)#</td>
										</tr>
									</table>
								<cf_web_portlet_end></td></tr>
								<tr><td><cf_botones modo="#modoD#" values="Guardar Cambios" names="Guardar" sufijo="S"><input name="RHSVFid" value="#camposCod#" type="hidden"/><input name="RHEVFid" id="RHEVFid" type="hidden" value="#form.RHEVFid#"/></td></tr>
							  <script type="text/javascript" language="javascript1.2">
									var arrayCodPts = new Array();
									<cfloop list="#camposCod#" index="i">
										<cfset cod =  ListGetAt(i,1,'|')>
										arrayCodPts.push(new Array("#ListGetAt(cod,1,'&')#","#ListGetAt(cod,2,'&')#"));
									</cfloop>
									
									function fnActulizarPTS(ptsSF,cgSF,g,codF,codSF){
										inp = document.getElementById("RHSVFpuntosPropuesta_" + codF + "_" + codSF);
										inp.value = redondear(ptsSF/cgSF*g,2);
										fm(inp,2,true,true);
										total = 0;
										sTotal = 0;
										for(i=0;i<arrayCodPts.length;i++){
											if(arrayCodPts[i][0] == codF){
												valor = document.getElementById('RHSVFpuntosPropuesta_' + arrayCodPts[i][0] + '_' + arrayCodPts[i][1]).value;
												sTotal = sTotal + parseFloat(valor);
											}
										}
										document.getElementById('sTotales_' + codF).value = redondear(sTotal,2);
										fm(document.getElementById('sTotales_' + codF),2,true,true);
									   
										for(i=0;i<arrayCodPts.length;i++){
											valor = document.getElementById('RHSVFpuntosPropuesta_' + arrayCodPts[i][0] + '_' + arrayCodPts[i][1]).value;
											total = total + parseFloat(valor);
										}
										document.getElementById('totales').value = redondear(total,2);
										fm(document.getElementById('diferiencia'),2,true,true);
										document.getElementById('diferiencia').value = redondear(total - #rsTotales.pts# ,2);
										fm(document.getElementById('diferiencia'),2,true,true);
										fnActualizarMSG(codF,codSF,g);
									}
									
									function fnActualizarMSG(codF,codSF,g){
										document.getElementById("et_" + codF).value = document.getElementById("l_" + codF + "_" + codSF + "_" + g).value;	
									}
								</script>
							<cfelse>
								<tr><td align="center">No existen factores ni subfactores  a valorar.</td></tr>
							</cfif>
						</cfif>
					</table></td></tr>
				</fieldset></td></tr>
			</form></cfif>
			</table>
		</td>
	</tr>
</cfif>
</table>
<cffunction name="fnFormatMoney" access="private" returntype="string">
    <cfargument name="Monto" type="numeric">
    <cfargument name="Decimales" type="numeric" default="2">
    <cfreturn LsCurrencyFormat(NumberFormat(Arguments.Monto,".99"),'none')>
</cffunction>
</cfoutput>
