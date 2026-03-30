<cf_templateheader title="Tesorer&iacute;a">
		<cf_web_portlet_start _start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte Entrega de Cheques a Recepción'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfoutput>
			<form name="form1" method="get" style="margin:0;" action="reporteChequesImpresosRecepcion.cfm">
				<table align="center" width="100%" cellpadding="2" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="right" width="45%"><strong>Tesorer&iacute;a:</strong>&nbsp;</td>
						<td><cf_cboTESid  tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><strong>Fecha Inicial:</strong>&nbsp;</td>
						<td ><cf_sifcalendario name="finicio"  tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><strong>Fecha Final:</strong>&nbsp;</td>
						<td><cf_sifcalendario name="ffinal"  tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><strong>Consecutivo Inicial:</strong>&nbsp;</td>
						<td ><cf_monto tabindex="1" name="inicio" decimales="0" value=""></td>
					</tr>
					<tr>
						<td align="right"><strong>Consecutivo Final:</strong>&nbsp;</td>
						<td><cf_monto tabindex="1" name="final" decimales="0" value=""></td>
					</tr>
					
					<!--- <tr>
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
						<td align="right"><strong>Socio:</strong>&nbsp;</td>
						<td><cf_sifsociosnegocios2 SNcodigo="idsocio" SNnombre="nsocio" SNnumero="socio" SNtiposocio="P" frame="framesocio" tabindex="1"></td>
					</tr>--->
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
		<cf_web_portlet_start _end>

		<cf_qforms>
		<script type="text/javascript" language="javascript1.2">
			/*function limpiar(){
				document.form1.CBid.value=''; 
				document.form1.CBcodigo.value=''; 
				return false;
			}*/

			objForm.TESid.required = true;
			objForm.TESid.description = 'Tesorería';
			objForm.finicio.required = true;
			objForm.finicio.description = 'Fecha Inicial';
			objForm.ffinal.required = true;
			objForm.ffinal.description = 'Fecha Final';
			document.form1.TESid.focus();
		</script>
<cf_templatefooter>