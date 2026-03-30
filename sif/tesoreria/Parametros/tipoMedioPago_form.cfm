<cfif isdefined("form.CBid") and isdefined("form.TESMPcodigo")
		AND form.CBid NEQ "" AND form.TESMPcodigo NEQ "">
	<cfset MODO = "CAMBIO">
<cfelse>
	<cfset MODO = "ALTA">
</cfif>

<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="rsForm">
		select 	CBid, TESMPcodigo, TESMPdescripcion, FMT01COD, FMT01CODemail, TESTGid,
				TESTMPtipo, TESMPcodigo, TESMPdescripcion, TESMPsoloManual, ts_rversion
				,TESTGcodigoTipo,TESTGtipoCtas,TESTGtipoConfirma,TESenviaCorreo,TESMPcodigoDisp
		 from TESmedioPago m
		where m.TESid = #session.Tesoreria.TESid#
		  and m.CBid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
		  and m.TESMPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
	</cfquery>
</cfif>

<cfquery name="rsSQL" datasource="#session.dsn#">
	select TESTMPdescripcion
	  from TEStipoMedioPago
	 where TESTMPtipo = 5
</cfquery>
<cfif rsSQL.TESTMPdescripcion NEQ "TCE = Pago con Tarjeta Credito">
	<!---
		TESTMPtipo  TESTMPdescripcion                   TESTMPexplicacion                                                                                                                                                                              TESTMPformatoImpresion TESTMPformatoArchivo TESTMPcontrolFormulario
		----------- ----------------------------------- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- -------------------- -----------------------
		1           CHK = Cheque                        Cada Orden de Pago se convierte en un Cheque que se Imprime con la Opcion Emision de Cheques (a traves del ActiveX soinPrintDocs.ocx) y se lleva todo el control de Formularios de Cheques     1                      0                    1                      
		2           TRI = Transferencia Impresa         Varias Ordenes de Pago se incluyen en un Reporte impreso, donde se le indica al Banco las transferencias que debe realizar                                                                     1                      0                    0                      
		3           TRE = Transferencia Electronica     Varias Ordenes de Pago se incluyen en un solo Archivo electronico, donde se le indica al Banco las transferencias que debe realizar                                                            0                      1                    0                      
		4           TRM = Transferencia Manual          Cada Orden de Pago se convierte en una Transferencia Manual que sólo se puede registrar con la Opcion Emision Manual                                                                           0                      0                    0                      
		5           TCE = Tarjeta Credito Empresarial   Cada Orden de Pago se convierte en un Pago por Tarjeta que sólo se puede registrar con la Opcion Emision Manual                                                                                0                      0                    0                      
	--->
    <!---SML 09012015. Se agrego el nuevo Campo TESTMPcodigo para relacionarlo con la Contabilidad Electronica--->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		insert into TEStipoMedioPago
			(TESTMPtipo, TESTMPdescripcion, TESTMPexplicacion, TESTMPformatoImpresion, TESTMPformatoArchivo, TESTMPcontrolFormulario,TESTMPcodigo)
		select 1, 'CHK', 'CHK = Cheque Impreso o Manual', 	1, 0, 1, 'CHK' from dual where not exists (select 1 from TEStipoMedioPago where TESTMPtipo = 1)
		UNION
		select 2, 'TRI', 'TRI = Transferencia Impresa', 	1, 0, 0, 'TRI' from dual where not exists (select 1 from TEStipoMedioPago where TESTMPtipo = 2)
		UNION
		select 3, 'TRE', 'TRE = Transferencia Electrónica',	0, 1, 0, 'TRE' from dual where not exists (select 1 from TEStipoMedioPago where TESTMPtipo = 3)
		UNION
		select 4, 'TRM', 'TRM = Transferencia Manual', 		0, 0, 0, 'TRM' from dual where not exists (select 1 from TEStipoMedioPago where TESTMPtipo = 4)
		UNION
		select 5, 'TCE', 'TCE = Pago con Tarjeta Credito', 	0, 0, 0, 'TCE' from dual where not exists (select 1 from TEStipoMedioPago where TESTMPtipo = 5)
	</cfquery>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		update TEStipoMedioPago
		   set  TESTMPdescripcion = 'CHK = Cheque Impreso o Manual',
		   		TESTMPexplicacion = 'Cada Orden de Pago se convierte en un Cheque que se Imprime con la Opcion Emision de Cheques (a traves del ActiveX soinPrintDocs.ocx) y se lleva todo el control de Formularios de Cheques'
		 where TESTMPtipo = 1
	</cfquery>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		update TEStipoMedioPago
		   set  TESTMPdescripcion = 'TRI = Transferencia Impresa',
		   		TESTMPexplicacion = 'Varias Ordenes de Pago se incluyen en un Reporte impreso, donde se le indica al Banco las transferencias que debe realizar'
		 where TESTMPtipo = 2
	</cfquery>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		update TEStipoMedioPago
		   set  TESTMPdescripcion = 'TRE = Transferencia Electronica',
		   		TESTMPexplicacion = 'Varias Ordenes de Pago se incluyen en un solo Archivo electronico, donde se le indica al Banco las transferencias que debe realizar'
		 where TESTMPtipo = 3
	</cfquery>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		update TEStipoMedioPago
		   set  TESTMPdescripcion = 'TRM = Transferencia Manual',
		   		TESTMPexplicacion = 'Cada Orden de Pago se convierte en una Transferencia Manual que sólo se puede registrar con la Opcion Emision Manual'
		 where TESTMPtipo = 4
	</cfquery>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		update TEStipoMedioPago
		   set  TESTMPdescripcion = 'TCE = Pago con Tarjeta Credito',
		   		TESTMPexplicacion = 'Cada Orden de Pago se convierte en un Pago con Tarjeta de Crédito Empresarial que sólo se puede registrar con la Opcion Emision Manual'
		 where TESTMPtipo = 5
	</cfquery>
</cfif>

<cfquery name="rsTEStipoMedioPago" datasource="#session.dsn#">
	select TESTMPtipo, TESTMPdescripcion, TESTMPformatoImpresion, TESTMPformatoArchivo, TESTMPcontrolFormulario
	  from TEStipoMedioPago
	 where TESTMPtipo in (1,2,3,4)
</cfquery>
<cfquery name="rsFMT001ocx" datasource="#session.dsn#">
	select FMT01COD, FMT01DES
	  from FMT001
	 where Ecodigo = #session.Ecodigo#
	   and FMT01tipfmt = 2
</cfquery>
<cfquery name="rsFMT001carta" datasource="#session.dsn#">
	select FMT01COD, FMT01DES
	  from FMT001
	 where Ecodigo = #session.Ecodigo#
	   and FMT01tipfmt = 3
</cfquery>
<cfquery name="rsGenera" datasource="#session.dsn#">
	select TESTGid, TESTGdescripcion, 
		TESTGcodigoTipo,
		TESTGtipoCtas,
		TESTGtipoConfirma,
		case TESTGcodigoTipo
			when 0 then  <!--- Cuentas Nacionales --->
				case TESTGtipoCtas
					when 0 then 'Cualquier cuenta de cualquier Banco'
					when 1 then 'Sólo Cuentas Propias del Mismo Banco de Pago'
					when 2 then 'Sólo Cuentas Interbancarias de otros Bancos'
					when 3 then 'Sólo Cuentas Interbancarias de cualquier Banco'
					when 4 then 'Ctas propias del mismo Bco e Interbancarias de otros'
				end
			when 1 then 'Cuentas ABA'
			when 2 then 'Cuentas SWIFT'
			when 3 then 'Cuentas IBAN'
			else 'Otro tipo de cuenta'
		end as tipoCuenta,
		case TESTGtipoConfirma
			when 1 then 'una confirmación por Lote'
			when 2 then 'una confirmación por OP'
		end as tipoConfirma
	  from TEStransferenciaG
	 where TESTGactivo = 1
</cfquery>

<script language="javascript">
	function fnValidar(f)
	{
		var LvarValidar = (f.botonSel.value == 'Alta' || f.botonSel.value == 'Cambio');

		if (LvarValidar)
		{
			if (f.TESMPcodigo.value == "")
			{
				alert('El Código no puede quedar en blanco');
				f.TESMPcodigo.focus();
				return false;
			}
			if (f.TESMPdescripcion.value == "")
			{
				alert('La Descripción no puede quedar en blanco');
				f.TESMPdescripcion.focus();
				return false;
			}
			
			if (document.getElementById("FIocx").style.display != "none" && (f.FMT01CODocx.value == "") )
			{
				alert('El Formato soinPrintDocs para Cheques no puede quedar en blanco');
				f.FMT01CODocx.focus();
				return false;
			}
			if (document.getElementById("FIcarta").style.display != "none" && (f.FMT01CODcarta.value == ""))
			{
				alert('El Formato Carta para Instrucción no puede quedar en blanco');
				f.FMT01CODcarta.focus();
				return false;
			}
			if (document.getElementById("PG").style.display != "none" && (f.TESTGid.value == ",,," || f.TESTGid.value == ""))
			{
				alert('El Parámetro de Generación no puede quedar en blanco');
				f.TESTGid.focus();
				return false;
			}
		}
		f.CBid.disabled=false;
		return true;
	}
	function sbCambioTESTMPtipo(t, firstTime)
	{
		var LvarTipo = t.value.split(",");
		// [0]: Tipo:				1=CHK, 2=TRI, 3=TRE, 4=TRM
		// [1]: Formato Impreso		1		1		0		0
		// [2]: Generación Archivo	0		0		1		0		
		// [3]: Control Formulario	1		0		0		0
		document.getElementById("FIocx").style.display = (LvarTipo[0] == 1 && LvarTipo[1] == 1) ? "" : "none";

		var isTRI = (LvarTipo[0] == 2 && LvarTipo[1] == 1) ? "" : "none";
		document.getElementById("FIcarta").style.display = isTRI;
		document.getElementById("FI1").style.display = isTRI;
		document.getElementById("FI2").style.display = isTRI;
		
		var isTRE = (LvarTipo[2] == 1) ? "" : "none";
		document.getElementById("PG").style.display = isTRE;
		document.getElementById("PG1").style.display = isTRE;
		document.getElementById("PG2").style.display = isTRE;

		var isCHK = (LvarTipo[3] == 1) ? "" : "none";
		document.getElementById("CF").style.display = isCHK;

		if (!firstTime)
			document.getElementById("TESMPsoloManual").checked = false;
		<cfif Modo NEQ "ALTA" AND rsForm.TESMPsoloManual EQ "1">
		else
		{
			document.getElementById("FIocx").style.display = "none";
			document.getElementById("FIcarta").style.display = "none";
		}
		</cfif>
		if (LvarTipo[0] == 1)
			document.getElementById("FMT01COD").value = document.getElementById("FMT01CODocx").value;
		else if (LvarTipo[0] == 1)
			document.getElementById("FMT01COD").value = document.getElementById("FMT01CODcarta").value;
	}	
</script>
<form action="tipoMedioPago_sql.cfm" method="post" onSubmit="return fnValidar(this);" name="form1">
	<table>
		<tr>
			<td colspan="3">
				<strong>Cuenta de Pago:</strong><BR>
				<cfif modo NEQ "ALTA">
					<cf_cboTESCBid Dcompuesto="yes" Ccompuesto="no" disabled="yes" value="#rsForm.CBid#" disable="yes" tabindex="1">
					<cfoutput><input type="hidden" name="CBid" value="#rsForm.CBid#" /></cfoutput>
				<cfelse>
					<cf_cboTESCBid Dcompuesto="yes" Ccompuesto="no" tabindex="1">
				</cfif>
			</td>
		</tr>
		<tr>
			<td><strong>Codigo Medio de Pago:</strong><BR>
				<cfoutput>
				<input name="TESMPcodigo" size="10" <cfif modo NEQ "ALTA">value="#rsForm.TESMPcodigo#"</cfif> tabindex="1">
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td><strong>Codigo para Dispersi&oacute;n de Pagos:</strong><BR>
				<cfoutput>
				<input name="TESMPcodigoDisp" size="5" <cfif modo NEQ "ALTA">value="#rsForm.TESMPcodigoDisp#"</cfif> tabindex="1">
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td colspan="3">
				<strong>Descripcion:</strong>
				<BR>
				<cfoutput>
				<input name="TESMPdescripcion" size="80" <cfif modo NEQ "ALTA">value="#rsForm.TESMPdescripcion#"</cfif> tabindex="1">
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td colspan="3"><strong>Tipo Medio de Pago:</strong><BR>
				<select name="TESTMPtipo" id="TESTMPtipo" onChange="sbCambioTESTMPtipo(this);" tabindex="1">
				<cfoutput query="rsTEStipoMedioPago">
					<option value="#TESTMPtipo#,#TESTMPformatoImpresion#,#TESTMPformatoArchivo#,#TESTMPcontrolFormulario#" <cfif Modo NEQ "ALTA" AND TESTMPtipo EQ rsForm.TESTMPtipo>selected</cfif>>#TESTMPdescripcion#</option>
				</cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td>
				<cfparam name="rsForm.FMT01COD" default="">
				<input type="hidden" name="FMT01COD" id="FMT01COD" value="<cfoutput>#trim(rsForm.FMT01COD)#</cfoutput>">
			</td>
		</tr>
		<tr id="FIocx">
			<td colspan="3">
				<strong>Formato de Impresion para Cheques (tipo soinPrintDocs):</strong>
				<BR>
				<select name="FMT01CODocx" id="FMT01CODocx" tabindex="1" onchange="document.getElementById('FMT01COD').value=this.value;">
					<option value="">(Escojer un Formato tipo soinPrintDocs)</option>
				<cfoutput query="rsFMT001ocx">
					<option value="#FMT01COD#" <cfif Modo NEQ "ALTA" AND FMT01COD EQ rsForm.FMT01COD>selected</cfif>>#FMT01COD# - #FMT01DES#</option>
				</cfoutput>
				</select>
			</td>
		</tr>
		<tr id="FIcarta">
			<td colspan="3">
				<strong>Formato de Impresion para Instrucciones de Pago Impresas (tipo Carta):</strong>
				<BR>
				<select name="FMT01CODcarta" id="FMT01CODcarta" tabindex="1" onchange="document.getElementById('FMT01COD').value=this.value;">
					<option value="">(Escojer un Formato tipo Carta)</option>
				<cfoutput query="rsFMT001carta">
					<option value="#FMT01COD#" <cfif Modo NEQ "ALTA" AND FMT01COD EQ rsForm.FMT01COD>selected</cfif>>#FMT01COD# - #FMT01DES#</option>
				</cfoutput>
				</select>
			</td>
		</tr>
		<tr id="FI1">
			<td nowrap="nowrap">
				&nbsp;&nbsp;&nbsp;
				<strong>Tipo Cuenta Destino:</strong>
			</td>
			<td colspan="2" nowrap="nowrap">
				<cfif Modo NEQ "ALTA" AND rsForm.TESTMPtipo EQ "2">
					<cfset LvarTESTGcodigoTipo		= rsform.TESTGcodigoTipo>
					<cfset LvarTESTGtipoCtas		= rsform.TESTGtipoCtas>
					<cfset LvarTESTGtipoConfirma	= rsform.TESTGtipoConfirma>
				<cfelse>
					<cfset LvarTESTGcodigoTipo 		= "0">
					<cfset LvarTESTGtipoCtas		= "0">
					<cfset LvarTESTGtipoConfirma	= "">
				</cfif>
				<cfif LvarTESTGcodigoTipo NEQ 0>
					<cfset LvarDisabled		 = "disabled">
					<cfset LvarTESTGtipoCtas = "0">
				<cfelse>
					<cfset LvarDisabled = "">
				</cfif>
				<select name="TESTGcodigoTipo" id="TESTGcodigoTipo" onchange="var LvarCod0 = (this.value == '0'); this.form.TESTGtipoCtas.disabled = !LvarCod0;  if (!LvarCod0) this.form.TESTGtipoCtas.selectedIndex = 0;">
					<option value="0" <cfif LvarTESTGcodigoTipo EQ '0'>selected</cfif>>Cuentas Nacionales</option>
					<option value="1" <cfif LvarTESTGcodigoTipo EQ '1'>selected</cfif>>Cuentas ABA</option>
					<option value="2" <cfif LvarTESTGcodigoTipo EQ '2'>selected</cfif>>Cuentas SWIFT</option>
					<option value="3" <cfif LvarTESTGcodigoTipo EQ '3'>selected</cfif>>Cuentas IBAN</option>
					<option value="10" <cfif LvarTESTGcodigoTipo EQ '10'>selected</cfif>>Cuentas Especiales</option>
				</select>
					<!---
						0 = 'Cualquier cuenta de cualquier Banco'
						1 = 'Sólo Cuentas Propias del Mismo Banco de Pago'
						2 = 'Sólo Cuentas Interbancarias de otros Bancos'
						3 = 'Sólo Cuentas Interbancarias de cualquier Banco'
						4 = 'Ctas propias del mismo Bco e Interbancarias de otros'
					--->
				<select name="TESTGtipoCtas" id="TESTGtipoCtas"<cfoutput>#LvarDisabled#</cfoutput>>
					<option value="0" <cfif LvarTESTGtipoCtas EQ '0'>selected</cfif>>Cualquier cuenta de cualquier Banco</option>
					<option value="1" <cfif LvarTESTGtipoCtas EQ '1'>selected</cfif>>Sólo Cuentas Propias del Mismo Banco de Pago</option>
					<option value="2" <cfif LvarTESTGtipoCtas EQ '2'>selected</cfif>>Sólo Cuentas Interbancarias de otros Bancos</option>
					<option value="3" <cfif LvarTESTGtipoCtas EQ '3'>selected</cfif>>Sólo Cuentas Interbancarias de cualquier Banco</option>
					<option value="4" <cfif LvarTESTGtipoCtas EQ '4'>selected</cfif>>Ctas propias del mismo Bco e Interbancarias de otros</option>
				</select>
			</td>
		</tr>
		<tr id="FI2">
			<td>
				&nbsp;&nbsp;&nbsp;
				<strong>Tipo Confirmación:</strong>
			</td>
			<td colspan="2">
				<select name="TESTGtipoConfirma" id="TESTGtipoConfirma">
					<option value="1" <cfif LvarTESTGtipoConfirma EQ '1'>selected</cfif>>Una única confirmación por Lote</option>
					<option value="2" <cfif LvarTESTGtipoConfirma EQ '2'>selected</cfif>>Una confirmación por Orden Pago</option>
				</select>
			</td>
		</tr>
		<tr id="CF">
			<td colspan="3">
				<strong>Requiere Control de Formularios</strong>
				<br>
				<input type="checkbox" name="TESMPsoloManual" id="TESMPsoloManual"  tabindex="1"
					value="1" <cfif Modo NEQ "ALTA" AND rsForm.TESMPsoloManual EQ "1">checked</cfif>
					onClick="document.getElementById('FI').style.display = !this.checked  ? '' : 'none';">
				Se puede utilizar consecutivos en desorden (Sólo cheques Manuales) 
			</td>
		</tr>
		<tr id="PG">
			<td colspan="3">
				<strong>Parámetros de Generación:</strong>
				<BR>
				<select name="TESTGid" id="TESTGid" tabindex="1" onchange="sbTESTGidChange(this);">
					<option value=",,,">(Escoger Formato de Generación de Archivo)</option>
				<cfoutput query="rsGenera">
					<option value="#TESTGid#,#TESTGcodigoTipo#,#TESTGtipoCtas#,#TESTGtipoConfirma#" <cfif Modo NEQ "ALTA" AND TESTGid EQ rsForm.TESTGid>selected</cfif>>#TESTGdescripcion#</option>
				</cfoutput>
				</select>
			</td>
		</tr>
		<tr id="PG1">
			<td nowrap="nowrap">
				&nbsp;&nbsp;&nbsp;
				<strong>Tipo Cuenta Destino:</strong>
			</td>
			<td colspan="2" nowrap="nowrap">
					<span id="TipoCuenta"></span>
			</td>
		</tr>
		<tr id="PG2">
			<td nowrap="nowrap">
				&nbsp;&nbsp;&nbsp;
				<strong>Tipo Confirmación:</strong>
			</td>
			<td colspan="2" nowrap="nowrap">
					<span id="TipoConfirma"></span>
			</td>
		</tr>
		<tr>
			<td colspan="3">
            	<!---Se comenta el FMT01CODemail para en lugar de eligir que tipo, lo que se indique es si envia correo o no con el TESenviaCorreo--->
				<!---<strong>Formato de Impresion para eMail al Beneficiario (tipo Carta):</strong>--->
                <BR>
                <strong>Envia eMail al Beneficiario:</strong>
				
				<!---<select name="FMT01CODemail" id="FMT01CODemail" tabindex="1">
					<option value="">(Puede escojer un Formato tipo Carta)</option>
				<cfoutput query="rsFMT001carta">
					<option value="#FMT01COD#" <cfif Modo NEQ "ALTA" AND FMT01COD EQ rsForm.FMT01CODemail>selected</cfif>>#FMT01COD# - #FMT01DES#</option>
				</cfoutput>
				</select>--->
                <input type="checkbox" name="TESenviaCorreo" id="TESenviaCorreo" <cfif Modo NEQ "ALTA" AND rsForm.TESenviaCorreo EQ 1>checked="checked"  </cfif> />
			</td>
		</tr>
		<tr>
			<td colspan="3">
				<cfif modo NEQ 'ALTA'>
					<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
						artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
					</cfinvoke>
					<cfoutput>
					<input type="hidden" name="ts_rversion" value="#ts#">
					</cfoutput>
				</cfif>
				<cf_botones modo="#Modo#" tabindex="1">
			</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
				<p>
					<cfif modo NEQ 'ALTA'>
						<cfoutput>
							<img src="/cfmx/sif/ad/catalogos/formatos/flash-FMT01imgfpre.cfm?FMT01COD=#rsForm.FMT01COD#" width="400">
						</cfoutput>
					</cfif>
			</p>
		</tr>

	</table>
</form>
<script language="javascript">
	function sbTESTGidChange(o)
	{
		var LvarTCta = document.getElementById("TipoCuenta");
		var LvarTCfm = document.getElementById("TipoConfirma");
		if (o.value == "")
		{
			LvarTCta.innerHTML = "";
			LvarTCfm.innerHTML = "";
			return;
		}
		var LvarTESTGidParam = o.value.split(",");
		{
			TESTGcodigoTipo   = LvarTESTGidParam[1];
			TESTGtipoCtas	  = LvarTESTGidParam[2];
			TESTGtipoConfirma = LvarTESTGidParam[3];

			if (TESTGcodigoTipo == "")
			{
				LvarTCta.innerHTML = "";
				LvarTCfm.innerHTML = "";
			}
			else 
			{
				if (TESTGcodigoTipo == 0)
				{
					if (TESTGtipoCtas == 0)
					{
						LvarTCta.innerHTML = "Cualquier cuenta de cualquier Banco";
					}
					else if (TESTGtipoCtas == 1)
					{
						LvarTCta.innerHTML = "Sólo Cuentas Propias del Mismo Banco de Pago";
					}
					else if (TESTGtipoCtas == 2)
					{
						LvarTCta.innerHTML = "Sólo Cuentas Interbancarias de otros Bancos";
					}
					else if (TESTGtipoCtas == 3)
					{
						LvarTCta.innerHTML = "Sólo Cuentas Interbancarias de cualquier Banco";
					}
					else if (TESTGtipoCtas == 4)
					{
						LvarTCta.innerHTML = "Ctas propias del mismo Bco e Interbancarias de otros";
					}
				}
				else if (TESTGcodigoTipo == 1)
				{
					TESTGtipoCtas = "0";
					LvarTCta.innerHTML = "Código ABA";
				}
				else if (TESTGcodigoTipo == 2)
				{
					TESTGtipoCtas = "0";
					LvarTCta.innerHTML = "Código SWIFT";
				}
				else if (TESTGcodigoTipo == 3)
				{
					TESTGtipoCtas = "0";
					LvarTCta.innerHTML = "Código IBAN";
				}
				else
				{
					TESTGtipoCtas = "0";
					LvarTCta.innerHTML = "Código Especial";
				}
	
				if (TESTGtipoConfirma == 1)
				{
					LvarTCfm.innerHTML = "Una única confirmación por Lote";
				}
				else if (TESTGtipoConfirma == 2)
				{
					LvarTCfm.innerHTML = "Una confirmación por cada Orden de Pago";
				}
			}
		}		
	}
	<cfif modo NEQ 'ALTA'>
	<cfoutput>
	</cfoutput>
	</cfif>	
</script>
<script language="javascript">
	sbCambioTESTMPtipo (document.getElementById("TESTMPtipo"),true);
	sbTESTGidChange(document.getElementById("TESTGid"));
	<cfif modo NEQ 'ALTA'>
		document.form1.TESMPcodigo.focus();
	<cfelse>
		document.frmTES.TESid.focus();
	</cfif>
</script>
