<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 16 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Anulación de cheques
----------->
<cfset titulo = 'Anluaci&oacute;n de Cheques'>
<cfset tipoCheque = '= 1'>
 
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
<cfoutput>
<cfif isdefined("GvarAnulacionEspecial")>
<form action="anulacionCheques2_sql.cfm" method="post" name="form1" id="form1">
<cfelse>
<form action="anulacionCheques_sql.cfm" method="post" name="form1" id="form1">
</cfif>
	<cfset LvarDatosChequesDet = true>
	<cfinclude template="datosCheques.cfm">
	<table border="0" width="50%" align="center">

	<cfif isdefined("GvarAnulacionEspecial")>
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select count(1) as cantidad
			  from TESdetallePago
			 where TESOPid = #rsForm.TESOPid#
			   and TESDPtipoDocumento NOT IN (0,5,1)
		</cfquery>
		<cfif rsSQL.cantidad GT 0>
			<cfthrow message="La órden de pago #rsForm.TESOPnumero# tiene solicitudes de pago que no ni manuales ni pagos de CxP">
		</cfif>
		<cfif rsForm.TESOPestado NEQ 12>
			<cfthrow message="La órden de pago #rsForm.TESOPnumero# no ha sido aplicada">
		</cfif>
		<tr>
			<td align="right" nowrap valign="top">
				<p><strong>Anulación Especial de Cheque: </strong></p>
			<td colspan="3" align="left" valign="top">
				Sólo se permiten cheques que incluyan únicamente Solicitudes de Pago Manual o Pago de CxP.<BR>
				<BR>
				1) Anula el formulario del cheque<BR>
				2) Anula la orden de pago<BR>
				3) Anula las solicitudes de pago manual<BR>
				4) No reversa los movimientos contables ni presupuestarios<BR>
				5) Traslada el monto del cheque a una cuenta de balance dada:<BR>
				<table>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td colspan="2"><strong>Cuenta Financiera</strong></td>
						<td>&nbsp;&nbsp;&nbsp;</td>
						<td><strong>Debito</strong></td>
						<td><strong>Credito</strong></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>Bancos</td>
						<td>&nbsp;</td>
						<td>&nbsp;&nbsp;&nbsp;</td>
						<td>MontoCheque</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>CuentaDestino</td>
						<td>&nbsp;&nbsp;&nbsp;</td>
						<td>&nbsp;</td>
						<td>MontoCheque</td>
					</tr>
				</table>
				<strong>PRECAUCION: Esta anulación es DEFINITIVA y no se puede Reversar.  Cualquier ajuste se deberá hacer por Contabilidad</strong>
			</td>
		</tr>
		<tr>
			<td align="right" nowrap valign="top">
				<strong>Cuenta Financiera Destino del Monto de Cheque:</strong>
			</td>
			<td colspan="3" align="left" valign="top">
				<cfquery name="rsSQL" datasource="#session.DSN#">
					select min(EcodigoOri) as EcodigoOri
					  from TESsolicitudPago
					 where TESOPid = #rsForm.TESOPid#
				</cfquery>
				<cf_cuentas 	Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" tabindex="1"
								cmayor="cmayor" 
								ccuenta="Ccuenta" 
								Cdescripcion="Cdescripcion1" 
								cformato="Cformato" 
								form="form1"
								Ecodigo="23"
								Intercompany="#rsSQL.EcodigoOri NEQ session.Ecodigo#"
				>
				<cfif rsSQL.EcodigoOri NEQ session.Ecodigo>
					<script language="javascript">
						window.setTimeout("sbEcodigoOri();",1);
						function sbEcodigoOri()
						{
							for(i=0;i<document.form1.Ecodigo_Ccuenta.options.length;i++)
							{
								if (document.form1.Ecodigo_Ccuenta.options[i].value == '#rsSQL.EcodigoOri#')
								{
									document.form1.Ecodigo_Ccuenta.options[0].value = document.form1.Ecodigo_Ccuenta.options[i].value;
									document.form1.Ecodigo_Ccuenta.options[0].text = document.form1.Ecodigo_Ccuenta.options[i].text;
									document.form1.Ecodigo_Ccuenta.options.length = 1;
									document.form1.Ecodigo_Ccuenta.selectedItem = 0;
									document.form1.cmayor.value='';
									document.form1.Ccuenta.value='';
									document.form1.CFcuenta.value='';
									document.form1.Cformato.value='';
									document.form1.Cdescripcion1.value='';
									LvarEcodigo_Ccuenta = document.form1.Ecodigo_Ccuenta.options[0].value;
								  return true;
								}								  
							}
						}
					</script>
				</cfif>
			</td>
		</tr>
	<cfelse>
		<tr>
				<td colspan="2">
					La anulación de Cheques se utiliza cuando hay que anular el FORMULARIO DE CHEQUE
					pero sin anular la Orden de Pago, generalmente porque hubo un error en el registro 
					manual del Cheque o porque hay que sustituir el Cheque original, 
					pero siempre hay que realizar el pago.
					<BR>Sin no se va a volver a pagar la Orden de Pago, utilice mejor la opcion <strong>Anulación de Orden de Pago Emitida</strong>.
					<BR>Se va a ejecutar el siguiente proceso:
					<cfif rsForm.TESOPestado EQ 12>
					<li>Reversar el Pago Contablemente
					</cfif>
					<li>Anular el Formulario del Cheque
					<li>Dejar la Orden de Pago EN EMISION lista para volverse a Pagar
				</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</cfif>
		<tr>
			<td align="right" nowrap valign="top"><strong>Motivo Anulación:</strong></td>
			<td colspan="3" align="left" valign="top">
				<textarea name="TESOPmsgRechazo" rows="2" style="width:450px;" tabindex="1"></textarea>
			</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td colspan="4" class="formButtons" align="center">
			<cfif isdefined("GvarAnulacionEspecial")>
				<input name="AnularEspecial" 	type="submit" value="Anulacion y Traslado" tabindex="1">
			<cfelse>
				<input name="Anular" 	type="submit" value="Anular" tabindex="1">
			</cfif>
				<input name="Lista_Cheques" type="button" id="btnSelFac" value="Lista Cheques" tabindex="1"
					onClick="location.href='#irA#';">
			</td>
		</tr>
	</table>
	<cfinclude template="datosChequesDet.cfm">
</form>
</cfoutput>
	<cf_web_portlet_end>
<cf_qforms form="form1" objForm="objForm1">
<script language="javascript">
	objForm1.CFcuenta.required = true;
	objForm1.CFcuenta.description = "Cuenta Financiera destino del Traslado";
	objForm1.TESOPmsgRechazo.required = true;
	objForm1.TESOPmsgRechazo.description = "Motivo de la Anulación";
	document.form1.cmayor.focus();
</script>
