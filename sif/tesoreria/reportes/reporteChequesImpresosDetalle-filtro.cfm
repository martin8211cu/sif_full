<cf_templateheader title="Tesorer&iacute;a">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Cheques Impresos Detallado'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfoutput>
			<form name="form1" method="get" style="margin:0;" action="reporteChequesImpresosDetalle.cfm" onsubmit="javascript:return validar();">
				<table align="center" border="0" width="100%" cellpadding="2" cellspacing="0">
					<tr><td colspan="3">&nbsp;</td></tr>
					<tr>
						<td align="right" width="45%"><strong>Tesorer&iacute;a:</strong>&nbsp;</td>
						<td colspan="2"><cf_cboTESid  tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><strong>Fecha Inicial:</strong>&nbsp;</td>
						<td colspan="2"><cf_sifcalendario name="dia"  tabindex="1"></td>
					</tr>
					
					<tr>
						<td align="right"><strong>Banco Inicial:</strong>&nbsp;</td>
						<td colspan="2">
							<cf_conlis title="Lista de Bancos"
									campos = "Bid_inicio, Bdescripcion_inicio" 
									desplegables = "N,S" 
									modificables = "N,N" 
									size = "0,40"
									tabla="Bancos b"
									columnas="b.Bid as Bid_inicio, b.Bdescripcion as Bdescripcion_inicio"
									filtro="b.Ecodigo = #Session.Ecodigo# order by b.Bdescripcion asc"
									desplegar="Bdescripcion_inicio"
									etiquetas="Descripci&oacute;n"
									formatos="S"
									align="left"
									asignar="Bid_inicio, Bdescripcion_inicio"
									asignarformatos="S,S"
									showEmptyListMsg="true"
									debug="false"
									tabindex="1"
									filtrar_por="b.Bdescripcion" >
						</td>
					</tr>
					
					<tr>
						<td align="right"><strong>Banco Final:</strong>&nbsp;</td>
						<td colspan="2">
							<cf_conlis title="Lista de Bancos"
									campos = "Bid_final, Bdescripcion_final" 
									desplegables = "N,S" 
									modificables = "N,N" 
									size = "0,40"
									tabla="Bancos b"
									columnas="b.Bid as Bid_final, b.Bdescripcion as Bdescripcion_final"
									filtro="b.Ecodigo = #Session.Ecodigo# order by b.Bdescripcion asc"
									desplegar="Bdescripcion_final"
									etiquetas="Descripci&oacute;n"
									formatos="S"
									align="left"
									asignar="Bid_final, Bdescripcion_final"
									asignarformatos="S,S"
									showEmptyListMsg="true"
									debug="false"
									tabindex="1"
									filtrar_por="b.Bdescripcion" >
						</td>
					</tr>
					
					<tr>
						<td align="right"><strong>Cuenta Bancaria:</strong>&nbsp;</td>
						<td>
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="1%">
										<cf_conlis title="Lista de Cuentas Bancarias"
												campos = "CBid, CBcodigo,CBdescripcion" 
												desplegables = "N,S,N" 
												modificables = "N,N,N" 
												size = "0,50,0"
												tabla="CuentasBancos a inner join Bancos b on b.Bid=a.Bid"
												columnas="a.CBid, b.Bdescripcion, a.CBcodigo, a.CBdescripcion"
												filtro="a.Ecodigo=#session.ecodigo# and a.CBesTCE = 0 order by b.Bdescripcion, a.CBcodigo"
												desplegar="CBcodigo,CBdescripcion"
												etiquetas="Cuenta, Descripción"
												formatos="S,S"
												align="left,left"
												asignar="CBid, CBcodigo"
												asignarformatos="S,S"
												showEmptyListMsg="true"
												debug="false"
												tabindex="1"
												cortes="Bdescripcion"> 
								</td>
								<td width="99%"><a href="##"><img onclick="javascript:limpiar();" border="0" src="../../imagenes/Borrar01_S.gif" /></a></td></td>
							</tr>
						</table>
					</tr>
					
					<tr>
						<td nowrap align="right"><strong>Id. Beneficiario:</strong></td>
						<td colspan="2">
							<input type="text" name="TESOPBeneficiarioId_F" value="<!--- <cfoutput>#form.TESBeneficiarioId_F#</cfoutput> --->" size="60" tabindex="1">
						</td>
					</tr>
					<tr>
						<td nowrap align="right"><strong>Nom. Beneficiario:</strong></td>
						<td colspan="2">
							<input type="text" name="TESOPBeneficiario_F" value="<!--- <cfoutput>#form.TESBeneficiario_F#</cfoutput> --->" size="60" tabindex="1">
						</td>
					</tr>
					<tr>
						<td nowrap align="right"><strong>Socio Negocios:</strong></td>
						<td colspan="2">
							<cf_sifsociosnegocios2 form="form1" SNtiposocio="P" frame="framesocio" SNnombre='SNnombre_F' SNcodigo='SNcodigo_F' tabindex="1">
						</td>
					</tr>
					<tr>
						<td nowrap align="right"><strong>Cliente Contado:</strong></td>
						<td colspan="2">
							<cf_tesbeneficiarios form="form1" TESBid="TESBid_F" tabindex="1"> <!--- TESBidValue="#Form.TESBid_F#" --->
						</td>
					</tr>
					<tr>
						<td nowrap align="right"><strong>Cliente Detallista:</strong></td>
						<td colspan="2">
							<cf_sifClienteDetCorp form="form1" CDCidentificacion="CDCidentificacion_F" CDCcodigo="CDCcodigo_F" tabindex="1"> <!--- idquery="#Form.CDCcodigo_F#" --->
						</td>
					</tr>
					
					
					
					<!--- <tr>
						<td align="right"><strong>Socio:</strong>&nbsp;</td>
						<td><cf_sifsociosnegocios2 SNcodigo="idsocio" SNnombre="nsocio" SNnumero="socio" SNtiposocio="P" frame="framesocio" tabindex="1"></td>
					</tr> --->
					
					<tr>
						<td align="right"><strong>Formato:</strong>&nbsp;</td>
						<td colspan="2">
							<select name="formato" tabindex="1">
								<option value="flashpaper">flashpaper</option>
								<option value="pdf">pdf</option>
							</select>
						</td>
					</tr>
					<tr><td colspan="3" align="center"><cf_botones tabindex="1" include="Filtrar" exclude="Alta,Limpiar"></td></tr>
					<tr><td colspan="3">&nbsp;</td></tr>
				</table>
			</form>	
			</cfoutput>
	<cf_web_portlet_end>

		<cf_qforms>
		<script type="text/javascript" language="javascript1.2">
			function limpiar(){
					document.form1.CBid.value=''; 
					document.form1.CBcodigo.value=''; 
					return false;
			}
			
			objForm.TESid.required = true;
			objForm.TESid.description = 'Tesorería';
			objForm.dia.required = true;
			objForm.dia.description = 'Fecha';
			objForm.Bdescripcion_inicio.required = true;
			objForm.Bdescripcion_inicio.description = 'Banco Inicial';
			objForm.Bdescripcion_final.required = true;
			objForm.Bdescripcion_final.description = 'Banco Final';
			
			function validar(){
				document.form1.Bdescripcion_inicio.disabled = false;
				document.form1.Bdescripcion_final.disabled = false;
			}
			document.form1.TESid.focus();
			
		</script>
<cf_templatefooter>