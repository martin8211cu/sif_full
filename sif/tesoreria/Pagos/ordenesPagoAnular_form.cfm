<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 27 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Anulación de ordenes de pago
----------->

<cfinvoke key="LB_Titulo" default="Anulación de Órdenes de Pago Emitidas"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoAnular_form.xml"/>
<cfparam name="form.TESOPid" default="">
<cfinvoke key="MSG_AnulacionOPEmitida" default="La Anulación de Orden de Pago Emitida se utiliza cuando hay que anular el DOCUMENTO DE PAGO
porque ya no se va a realizar el pago, por tanto, queda anulados la Orden de Pago y los Solicitudes asociadas"	returnvariable="MSG_AnulacionOPEmitida"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="MSG_VolverPagOP" default="Si se desea volver a pagar la Orden de Pago, utilice mejor las opcion"	returnvariable="MSG_VolverPagOP"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="MSG_AnulaciónChkOTrans" default="Anulación de Cheques o Transferencias o Pagos con Tarjeta"	returnvariable="MSG_AnulaciónChkOTrans"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="MSG_RevContablemente" default="Reversar el Pago Contablemente"	returnvariable="MSG_RevContablemente"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="MSG_EjecutarSigProceso" default="Se va a ejecutar el siguiente proceso"	returnvariable="MSG_EjecutarSigProceso"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_AnuRegDoc" default="Anular el Registro del Documento de Pago"	returnvariable="LB_AnuRegDoc"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_AnuOrdenPago" default="Anular la Orden de Pago"	returnvariable="LB_AnuOrdenPago"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_AnularSPAsociadas" default="Anular las Solicitudes de Pago asociadas"	returnvariable="LB_AnularSPAsociadas"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="MSG_NoPuedeAnular" default="No se puede anular porque ya se entregó NUM"	returnvariable="MSG_NoPuedeAnular"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_MotAnulacion" default="Motivo de la Anulación"	returnvariable="LB_MotAnulacion"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="BTN_Anular" default="Anular"	returnvariable="BTN_Anular"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>
<cfinvoke key="LB_ListaOrdenes" default="Lista Ordenes"	returnvariable="LB_ListaOrdenes"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagoanular.xml"/>

<cfoutput><cfset titulo = '#LB_Titulo#'></cfoutput>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cfoutput>
	<cfinclude template="encabezadoOPs.cfm">
	<form action="ordenesPagoAnular_sql.cfm" method="post" name="form1" id="form1">
		<input type="hidden" name="TESOPid" value="#form.TESOPid#">
		<input type="hidden" name="TESMPcodigo" value="#rsform.TESMPcodigo#">
		<table align="center" summary="Tabla de entrada" border="0" cellpadding="1" cellspacing="1">
			<tr><td>&nbsp;</td></tr>
		<cfif not find ("Entregado",#rsForm.EstadoPago#)>
				<td colspan="2">
					<table width="80%" align="center"><tr><td>
					<cfoutput>#MSG_AnulacionOPEmitida#.
					<BR>#MSG_VolverPagOP#. <strong>#MSG_AnulaciónChkOTrans#</strong>.
					<BR>#MSG_EjecutarSigProceso#:
					<cfif rsForm.TESOPestado EQ 12>
					<li>#MSG_RevContablemente#
					</cfif>
					<li>#LB_AnuRegDoc#
					<li>#LB_AnuOrdenPago#
					<li>#LB_AnularSPAsociadas#</cfoutput>
					</td></tr></table>
				</td>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td valign="top" align="right" width="33%">
					<strong><cf_translate key=LB_MotAnulacion>Motivo de Anulación</cf_translate>:</strong>
				</td>
				<td valign="top" width="66%">
					<textarea name="TESOPmsgRechazo" id="TESOPmsgRechazo" cols="70" tabindex="1"></textarea>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="2" class="formButtons" align="center">
				  <input name="Anular" type="submit" value="#BTN_Anular#" tabindex="1">
				  <input name="Lista_Ordenes" type="button" id="Lista_Ordenes" tabindex="1"
				  	value="#LB_ListaOrdenes#" onClick="javascript: location.href='ordenesPagoAnular.cfm';">
				</td>
			</tr>
		<cfelse>
			<tr>
				<td align="center" style="color:##CC0000">
					<cfoutput>#MSG_NoPuedeAnular#</cfoutput>. #rsForm.DocPago# #rsForm.NumPago#
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="2" class="formButtons" align="center">
				  <input name="Lista_Ordenes" type="button" id="Lista_Ordenes" tabindex="1"
				  	value="#LB_ListaOrdenes#" onClick="javascript: location.href='ordenesPagoAnular.cfm';">
				</td>
			</tr>
		</cfif>
		</table>
	</form>
	<cfinclude template="detalleOPs.cfm">
	</cfoutput>
	<cf_web_portlet_end>
<cf_qforms form="form1" objForm="objForm">
<cfoutput>
<script language="javascript">
		objForm.TESOPmsgRechazo.required = true;
		objForm.TESOPmsgRechazo.description = "#LB_MotAnulacion#";
</script>
</cfoutput>
