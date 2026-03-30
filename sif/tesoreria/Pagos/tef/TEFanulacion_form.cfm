<!--- 
	Creado por: Oscar Bonilla
		Fecha: 4-NOV-2009
		Motivo: Emisión de Transferencias de Fondos
				Impresión de Instrucciones de Pago y
				Generación de Transferencias Electrónicas
--->
<cfparam name="form.TESOPid" default="">

<cfset titulo = 'Anulación de Transferencias de Fondos y Pagos con Tarjeta de Crédito Empresarial'>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cfoutput>
	<cfinclude template="../encabezadoOPs.cfm">
	<form action="TEFanulacion_sql.cfm" method="post" name="form1" id="form1">
		<input type="hidden" name="TESOPid" value="#form.TESOPid#">
		<input type="hidden" name="CBid" value="#rsform.CBidPago#">
		<input type="hidden" name="TESMPcodigo" value="#rsform.TESMPcodigo#">
		<input type="hidden" name="TESTDid" value="#rsform.TESTDid#">
		
		<table align="center" summary="Tabla de entrada" border="0" cellpadding="1" cellspacing="1">
			<tr>
				<td colspan="2">
					<table width="80%" align="center"><tr><td>
					La anulación del Medio de Pago se utiliza cuando hay que anular el DOCUMENTO DE PAGO
					pero sin anular la Orden de Pago, generalmente porque hubo un error en el registro 
					manual del Documento o porque hay que sustituir el Documento original, 
					pero siempre hay que realizar el pago.
					<BR>Sin no se va a volver a pagar la Orden de Pago, utilice mejor la opcion <strong>Anulación de Orden de Pago Emitida</strong>.
					<BR>Se va a ejecutar el siguiente proceso:
					<li>Reversar el Pago Contablemente
					<li>Anular el Registro del Documento de Pago
					<li>Dejar la Órden de Pago EN EMISION lista para volverse a Pagar
					</td></tr></table>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td valign="top" align="right" width="33%">
					<strong>Motivo de Anulaci&oacute;n:</strong>
				</td>
				<td valign="top" width="66%">
					<textarea name="TESOPmsgRechazo" id="TESOPmsgRechazo" cols="70" tabindex="1"></textarea>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="2" class="formButtons" align="center">
				  <input name="Anular" type="submit" value="Anular" tabindex="1">
				  <input name="Lista" type="button" id="Lista" tabindex="1"
				  	value="Lista Pagos" onClick="javascript: location.href='TEFanulacion.cfm';">
				</td>
			</tr>
		</table>
	</form>
	<cfinclude template="../detalleOPs.cfm">
	</cfoutput>
	<cf_web_portlet_end>
<cf_qforms form="form1" objForm="objForm">
<script language="javascript">
		objForm.TESOPmsgRechazo.required = true;
		objForm.TESOPmsgRechazo.description = "Motivo de la Anulación";
</script>
