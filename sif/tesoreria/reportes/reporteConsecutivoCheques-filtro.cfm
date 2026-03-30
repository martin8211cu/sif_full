<cf_templateheader title="Tesorer&iacute;a">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Consecutivo de Cheques'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfoutput>
			<form name="form1" method="get" style="margin:0;" action="reporteConsecutivoCheques.cfm">
				<table align="center" border="0" width="100%" cellpadding="1" cellspacing="0">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td align="right" width="40%"><strong>Cuenta Bancaria:</strong>&nbsp;</td>
						<td>
							<cf_conlis title="Lista de Cuentas Bancarias"
								campos = "CBid, CBcodigo, CBdescripcion" 
								desplegables = "N,S,S" 
								modificables = "N,S,N" 
								size = "0,0,40"
								tabla="CuentasBancos cb"
								columnas="cb.CBid,cb.CBcodigo,cb.CBdescripcion"
								filtro="cb.Ecodigo = #Session.Ecodigo# and cb.CBesTCE = 0 order by cb.CBcodigo"
								desplegar="CBcodigo, CBdescripcion"
								etiquetas="C&oacute;digo, Descripci&oacute;n"
								formatos="S,S"
								align="left,left"
								asignar="CBid, CBcodigo, CBdescripcion"
								asignarformatos="S,S,S"
								showEmptyListMsg="true"
								debug="false"
								tabindex="1">
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" align="right"><strong>Fecha desde:</strong>&nbsp;</td>
						<td><cf_sifcalendario name="fechaDes" tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><strong>Fecha hasta:</strong>&nbsp;</td>
						<td><cf_sifcalendario name="fechaHas" tabindex="1"></td>
					</tr>
					
					<tr>
						<td align="right"><strong>Consecutivo Inicial:</strong>&nbsp;</td>
						<td ><cf_monto tabindex="1" name="inicio" decimales="0" value=""></td>
					</tr>
					<tr>
						<td align="right"><strong>Consecutivo Final:</strong>&nbsp;</td>
						<td><cf_monto tabindex="1" name="final" decimales="0" value=""></td>
					</tr>
					<tr>
						<td align="right"><strong>Formato:</strong>&nbsp;</td>
						<td>
							<select name="formato" tabindex="1">
								<option value="flashpaper">flashpaper</option>
								<option value="pdf">pdf</option>
							</select>
						</td>
					</tr>
					<tr><td colspan="2" align="center"><cf_botones tabindex="1" include="Filtrar" exclude="Alta,Limpiar"></td></tr>
					<tr><td colspan="2">&nbsp;</td></tr>
				</table>
			</form>	
			</cfoutput>
	<cf_web_portlet_end>

		<cf_qforms>
		<script type="text/javascript" language="javascript1.2">
			objForm.CBid.required = true;
			objForm.CBid.description = 'Cuenta Bancaria';
			objForm.inicio.required = true;
			objForm.inicio.description = 'Consecutivo Inicial';
			/*objForm.final.required = true;
			objForm.final.description = 'Consecutivo Final';
			*/
			document.form1.CBcodigo.focus();
		</script>
<cf_templatefooter>