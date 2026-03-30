<cfquery name="rsTipoVentaPerdida" datasource="#session.DSN#">
	select  VPid, 
			VPnombre 
	from TipoVentaPerdida
</cfquery>

<cfquery name="rsCDlimitecredito" datasource="#session.DSN#">
	select (coalesce(a.total_productos,0) + coalesce(b.CDcreditoutilizado,0)) as TotalCredito, 
		b.CDlimitecredito 
	from VentaE a	
		inner join ClienteDetallista b	
			on a.CDid = b.CDid  
	where VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.VentaID#">
</cfquery>

<script language="JavaScript1.2" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfoutput>
	<table width="90%" border="0" cellpadding="1" cellspacing="0" align="center">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td width="43%">
				<fieldset><legend><strong>Aprobaci&oacute;n de Cr&eacute;dito</strong>&nbsp;</legend>
					<table width="80%" border="0" cellpadding="2" cellspacing="0" align="center">
						<tr><td colspan="2">&nbsp;</td></tr>
						<tr class="titulolistas">
							<td nowrap colspan="2"><strong>Nuevo L&iacute;mite de Cr&eacute;dito</strong></td>
						</tr>
						<tr>
							<td nowrap>
								<input type="text" name="CDlimitecredito" value="#LSCurrencyFormat(rsCDlimitecredito.CDlimitecredito,'none')#" size="20" maxlength="8" 
									style="text-align:right;" 
									onBlur="javascript:fm(this,0);" 
									onFocus="javascript:this.value=qf(this); this.select();"  
									onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"> 
							</td>
							<td nowrap align="right">&nbsp;
							</td>
						</tr>
						<tr class="titulolistas">
                          <td nowrap colspan="2"><strong>Autorizaci&oacute;n del supervisor</strong></td>
					  </tr>
						<tr>
						  <td colspan="2"><input type="password" size="10" name="supervisor"></td>
						</tr>
						<tr>
						  <td colspan="2"><input type="button" name="LimpiarA" value="Limpiar L&iacute;mite" onClick="javascript: LimpiarAprobar();" >
						    &nbsp;
                            <input type="button" name="Aprobar" value="Aprobar Cr&eacute;dito" onClick="javascript: HabilitarAprobarCredito(); AprobarCredito(1,document.form1.CDlimitecredito.value);"></td>
					  </tr>
					</table>
				</fieldset>
			</td>
			<td width="4%">&nbsp;</td>
			<td width="43%">
				<fieldset><legend><strong>Rechazo de Cr&eacute;dito</strong>&nbsp;</legend>
					<table width="80%" border="0" cellpadding="2" cellspacing="0" align="center">
						<tr class="titulolistas">
							<td nowrap colspan="2"><strong>Motivo del Rechazo de Cr&eacute;dito</strong></td>
						</tr>
						<tr>
							<td nowrap align="right"><strong>Tipo de Venta:</strong>&nbsp;</td>
							<td nowrap>
								<select name="VPid">
									<cfloop query="rsTipoVentaPerdida">
										<option value="#rsTipoVentaPerdida.VPid#" >#rsTipoVentaPerdida.VPnombre#</option>
									</cfloop>		
								</select>
							</td>
						</tr>
						<tr>
							<td nowrap valign="top" align="right"><strong>Observaci&oacute;n:</strong>&nbsp;</td>
							<td nowrap align="right">
								<textarea name="observacion" cols="30" rows="2"></textarea>
							</td>
						</tr>
						<tr>
							<td colspan="2" nowrap align="center">
								<input type="button" name="LimpiarR" value="Limpiar Observaci&oacute;n" onClick="javascript: LimpiarRechazo();" >&nbsp;
								<input type="submit" name="Rechazar" value="Rechazar Cr&eacute;dito" onClick="javascript: HabilitarRechazarCredito(); RechazarCredito(2,document.form1.observacion.value);">
							</td>
						</tr>
					</table>
				</fieldset>
			</td>
			<input type="hidden" name="dato" value="">
			<input type="hidden" name="CDid" value="#form.CDid#">
			<input type="hidden" name="VentaID" value="#form.VentaID#">
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
</cfoutput>

<cfoutput>
<script type="text/javascript" language="javascript1.2">
	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("form1");
	
	function HabilitarAprobarCredito(){
		objForm.observacion.required = false;
		objForm.CDlimitecredito.required = true;
		objForm.CDlimitecredito.description="Nuevo Límite";
	}
	
	function HabilitarRechazarCredito(){
		objForm.CDlimitecredito.required = false;
		objForm.observacion.required = true;
		objForm.observacion.description="Observación";
	}

	function AprobarCredito(dato,credito){
		if (parseFloat(credito.replace(/,/g,'')) < #NumberFormat(rsCDlimitecredito.TotalCredito,'0.00')# ) {
			alert("Para poder aprobar este Nuevo Límite de Crédito debe ser un monto mínimo de #NumberFormat(rsCDlimitecredito.TotalCredito,',0.00')#");
			return false;
		}
		
		if (document.form1.supervisor.value != '1234') {
			alert("La clave de supervisor no es válida");
			return false;
		}
		
		document.form1.action = 'revisionCredito-sql.cfm';
		document.form1.dato.value = dato;
		document.form1.CDlimitecredito.value = credito;
		document.form1.submit();
	}
	
	function RechazarCredito(dato,observacion){
		document.form1.action = 'revisionCredito-sql.cfm';
		document.form1.dato.value = dato;
		document.form1.observacion.value = observacion;
	}
	
	function LimpiarAprobar(){
		document.form1.CDlimitecredito.value = "0.00";
	}
	
	function LimpiarRechazo(){
		document.form1.observacion.value = "";
	}
	
</script>
</cfoutput>