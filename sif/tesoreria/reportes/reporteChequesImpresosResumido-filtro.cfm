<cf_templateheader title="Tesorer&iacute;a">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Cheques Impresos Resumido'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfoutput>
			<form name="form1" method="get" style="margin:0;" action="reporteChequesImpresosResumido.cfm">
				<table align="center" width="100%" cellpadding="2" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="right" width="45%"><strong>Tesorer&iacute;a:</strong>&nbsp;</td>
						<td><cf_cboTESid  tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><strong>Fecha Inicial:</strong>&nbsp;</td>
						<td ><cf_sifcalendario name="inicio"  tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><strong>Fecha Final:</strong>&nbsp;</td>
						<td><cf_sifcalendario name="ffinal"  tabindex="1"></td>
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
									<td width="99%"><a href="##"><img onclick="javascript:limpiar();" border="0" src="../../imagenes/Borrar01_S.gif" /></a></td>
								</tr>
							</table>
						</td>
					</tr>

					<tr>
						<td nowrap align="right"><strong>Id. Beneficiario:</strong></td>
						<td>
							<input type="text" name="TESOPBeneficiarioId_F" value="<!--- <cfoutput>#form.TESBeneficiarioId_F#</cfoutput> --->" size="60" tabindex="1">
						</td>
					</tr>
					<tr>
						<td nowrap align="right"><strong>Nom. Beneficiario:</strong></td>
						<td>
							<input type="text" name="TESOPBeneficiario_F" value="<!--- <cfoutput>#form.TESBeneficiario_F#</cfoutput> --->" size="60" tabindex="1">
						</td>
					</tr>
					<tr>
						<td nowrap align="right"><strong>Socio Negocios:</strong></td>
						<td>
							<cf_sifsociosnegocios2 form="form1" SNtiposocio="P" frame="framesocio" SNnombre='SNnombre_F' SNcodigo='SNcodigo_F' tabindex="1"> <!--- idquery="#form.SNcodigo_F#" --->
						</td>
					</tr>
					<tr>
						<td nowrap align="right"><strong>Cliente Contado:</strong></td>
						<td>
							<cf_tesbeneficiarios form="form1" TESBid="TESBid_F" tabindex="1"> <!--- TESBidValue="#Form.TESBid_F#" --->
						</td>
					</tr>
					<tr>
						<td nowrap align="right"><strong>Cliente Detallista:</strong></td>
						<td>
							<cf_sifClienteDetCorp form="form1" CDCidentificacion="CDCidentificacion_F" CDCcodigo="CDCcodigo_F" tabindex="1"> <!--- idquery="#Form.CDCcodigo_F#" --->
						</td>
					</tr> 
					
					<tr>
						<td align="right"><strong>Formato:</strong>&nbsp;</td>
						<td>
							<select name="formato" tabindex="1"  tabindex="1">
								<option value="flashpaper">flashpaper</option>
								<option value="pdf">pdf</option>
							</select>
						</td>
					</tr>
					<tr><td colspan="2" align="center"><cf_botones tabindex="1" include="Filtrar" exclude="Alta,Limpiar"></td></tr>
					<tr><td>&nbsp;</td></tr>
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
			objForm.inicio.required = true;
			objForm.inicio.description = 'Fecha Inicial';
			objForm.ffinal.required = true;
			objForm.ffinal.description = 'Fecha Final';
			document.form1.TESid.focus();
		</script>
<cf_templatefooter>