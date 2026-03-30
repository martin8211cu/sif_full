<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 05 de diciembre del 2005
	Motivo: Correccion de error en nombre de campos en la forma, cambio de minusculas en nombre, esto para
			corregir error de javascript q se presentaba en Browser Mozilla.
 --->
<cfinvoke key="LB_Titulo" default="Lista de Ordenes de Pago en Emisión"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagos_manual.xml"/>
<cfinvoke key="BTN_RegistrarPago" default="Registrar Pago"	returnvariable="BTN_RegistrarPago"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagos_manual.xml"/>
<cfinvoke key="BTN_VolverOrden" default="Volver a Ordenes"	returnvariable="BTN_VolverOrden"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagos_manual.xml"/>
<cfinvoke key="BTN_ListaOrdenes" default="Lista de Ordenes"	returnvariable="BTN_ListaOrdenes"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagos_manual.xml"/>
<cfinvoke key="BTN_ListaSPAprobar" default="Lista SP Aprobar"	returnvariable="BTN_ListaSPAprobar"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagos_manual.xml"/>
<cfinvoke key="CHK_ImprimirOrdenEmitida" default="Imprimir Orden Emitida"	returnvariable="CHK_ImprimirOrdenEmitida"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagos_manual.xml"/>
<cfinvoke key="MSG_NumRefTransferencia" default="Debe digitar el Numero de Referencia de la Transferencia"	returnvariable="MSG_NumRefTransferencia"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagos_manual.xml"/>
<cfinvoke key="MSG_DigiteFechaPagoManual" default="Debe digitar la Fecha de Generación Manual"	returnvariable="MSG_DigiteFechaPagoManual"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPagos_manual.xml"/>
<cfinvoke key="MSG_DigiteFechaPago" default="Debe digitar la Fecha de Pago"	returnvariable="MSG_DigiteFechaPago"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPagos_manual.xml"/>
<cfinvoke key="MSG_DigiteBloqueFormularios" default="Debe digitar el Bloque de Formularios a Utilizar"	returnvariable="MSG_DigiteBloqueFormularios"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPagos_manual.xml"/>
<cfinvoke key="MSG_DigiteNumFormulario" default="Debe digitar el Número del Formulario Utilizado"	returnvariable="MSG_DigiteNumFormulario"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPagos_manual.xml"/>
<cfinvoke key="MSG_DigiteMotAnulacion" default="Debe digitar un Motivo de Anulación"	returnvariable="MSG_DigiteMotAnulacion"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPagos_manual.xml"/>
<cfinvoke key="MSG_ImprimeSPDespuesAprobOEmisión" default="Imprime la Solicitud de Pago después de enviarla a los procesos de Aprobación o Emisión"	returnvariable="MSG_ImprimeSPDespuesAprobOEmisión"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPagos_manual.xml"/>

<cfparam name="form.TESOPid" default=""> 

<cfoutput><cfset titulo = '#LB_Titulo#'></cfoutput>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cfif isdefined('form.TESOPid') and len(trim(form.TESOPid))>
		<cfset modo = 'CAMBIO'>
	<cfelse>
		<cf_errorCode	code = "50750" msg = "No se puede incluir una Orden de Pago manualmente">
	</cfif>

	<cfquery datasource="#session.dsn#" name="rsTESendoso">
		select TESEcodigo, TESEdescripcion 
		  from TESendoso
		 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
	</cfquery>
	
	<cfquery datasource="#session.dsn#" name="rsForm">
		Select op.TESOPid, TESOPfechaGeneracion,
			op.CBidPago, op.TESMPcodigo, op.EcodigoPago, op.Miso4217Pago,
			op.SNid, op.TESOPbeneficiario,
			ep.Edescripcion,
			op.TESOPtipoCambioPago, op.Miso4217Pago, mep.Miso4217 as Miso4217EmpresaPago, mep.Mnombre as Mempresa,
			op.TESOPnumero, op.TESOPfechaPago, TESOPfechaEmision,
			op.TESOPtotalPago, TESEcodigo,
			op.TESOPobservaciones, op.TESOPmsgRechazo, op.ts_rversion,
			b.Bdescripcion, cb.CBcodigo,
			TESTMPtipo, TESMPdescripcion, TESMPsoloManual
		from TESordenPago op
			inner join Empresas ep
				inner join Monedas mep
					 on mep.Ecodigo	= ep.Ecodigo
					and mep.Mcodigo	= ep.Mcodigo
				 on ep.Ecodigo = op.EcodigoPago
			inner join CuentasBancos cb
				inner join Bancos b
					 on b.Bid = cb.Bid
				 on cb.Ecodigo  = op.EcodigoPago
				and cb.CBid		= op.CBidPago
			inner join TESmedioPago mp
				 on mp.TESid		= op.TESid
				and mp.CBid			= op.CBidPago
				and mp.TESMPcodigo 	= op.TESMPcodigo
		where op.TESOPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
		  and op.TESid = #session.Tesoreria.TESid#
		  and op.TESOPestado in (10,11)
	</cfquery>

	<cfoutput>
		<form action="ordenesPago_sql.cfm" method="post" name="form1" id="form1">
			<input type="hidden" name="TESOPid" value="#form.TESOPid#">
			<cfif modo NEQ 'ALTA'>
				<cfset ts = "">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
					artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#">
			</cfif>
			<input type="hidden" name="CBid" value="#rsForm.CBidPago#">
			<input type="hidden" name="TESMPcodigo" value="#rsForm.TESMPcodigo#">
            <table align="center" summary="Tabla de entrada" border=0 cellpadding="1" cellspacing="1">
              <tr>
                <td>&nbsp;</td>
                <td valign="top" align="right"><strong><cf_translate key=LB_NumOrden>Num. Orden</cf_translate>:</strong></td>
                <td valign="top"> <strong>#LSNumberFormat(rsForm.TESOPnumero)#</strong> </td>
                <td valign="top" align="left" colspan="2"> <strong><cf_translate key=LB_FechaOrden>Fecha Orden</cf_translate>: #LSDateFormat(rsForm.TESOPfechaGeneracion,"DD/MM/YYYY")#</strong> </td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td valign="top" align="right">
                  <cfif rsForm.SNid NEQ "">
                    <strong><cf_translate key=LB_SocioNegocio>Socio de Negocio</cf_translate>:</strong>
                    <cfelse>
                    <strong><cf_translate key=LB_Beneficiario>Beneficiario</cf_translate>:</strong>
                  </cfif>
                </td>
                <td valign="top" colspan="3"> <strong>#rsForm.TESOPbeneficiario#</strong> </td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td valign="top" align="right"><strong><cf_translate key=LB_EmpresaPago>Empresa de Pago</cf_translate>:</strong></td>
                <td colspan="3">
                  <input type="hidden" name="EcodigoPago" value="#rsForm.EcodigoPago#">
                  <strong>#rsForm.Edescripcion#</strong> </td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td valign="top" align="right"><strong><cf_translate key=LB_BancoPago>Banco de Pago</cf_translate>:</strong></td>
                <td colspan="3">
                  <input type="hidden" name="EcodigoPago" value="#rsForm.EcodigoPago#">
                  <strong>#rsForm.Bdescripcion#</strong> </td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td valign="top" align="right"><strong><cf_translate key=LB_CuentaPago>Cuenta de Pago</cf_translate>:</strong></td>
                <td colspan="3">
                  <input type="hidden" name="EcodigoPago" value="#rsForm.EcodigoPago#">
                  <strong>#rsForm.CBcodigo#</strong> </td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td valign="top" align="right"><strong><cf_translate key=LB_MedioPago>Medio de Pago</cf_translate>:</strong></td>
                <td colspan="3"> <strong>#rsForm.TESMPdescripcion#</strong>
                    <input type="hidden" name="TESTMPtipo" value="#rsForm.TESTMPtipo#">
                    <input type="hidden" name="TESMPsoloManual" value="#rsForm.TESMPsoloManual#">
                </td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td valign="top" align="right"><strong><cf_translate key=LB_TotalPagar>Total a Pagar</cf_translate>:</strong></td>
                <td valign="top"> <strong>#rsForm.Miso4217Pago#&nbsp;&nbsp;#numberFormat(rsForm.TESOPtotalPago,",0.00")#</strong> </td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td align="right"><strong><cf_translate key=LB_FechaGenManual>Fecha de Generación Manual</cf_translate>:</strong></td>
                <td valign="top">
                  <cfset fechaEmision = LSDateFormat(Now(),'dd/mm/yyyy') >
                  <cf_sifcalendario form="form1" value="#fechaEmision#" name="FechaGeneracionManual" onchange="GvarCambiado=true;" tabindex="1"> </td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td align="right"><strong><cf_translate key=LB_FechaPago>Fecha de Pago</cf_translate>:</strong></td>
                <td valign="top">
                  <cfset fechaSol = LSDateFormat(Now(),'dd/mm/yyyy') >
                  <cfif modo NEQ 'ALTA'>
                    <cfset fechaSol = LSDateFormat(rsForm.TESOPfechaPago,'dd/mm/yyyy') >
                  </cfif>
                  <cf_sifcalendario form="form1" value="#fechaSol#" name="TESOPFechaPago" onchange="GvarCambiado=true;" tabindex="1"> </td>
              </tr>
			<cfif rsform.TESTMPtipo EQ 1>
                <cfquery datasource="#session.dsn#" name="rsTESCFT">
					select 	TESCFTnumInicial, TESCFTnumFinal, TESCFTultimo, 
							TESCFTimprimiendo, TESCFTmanual, 
							case TESCFTultimo when 0 then TESCFTnumInicial else TESCFTultimo+1 end as TESCFTsiguiente 
							, (
								<cf_dbfunction name="to_char" args="TESCFLid" returnvariable="LvarStrLote">
								select min(<cf_dbfunction name="concat"  args="TESCFLtipo+'. '+#preserveSingleQuotes(LvarStrLote)#" delimiters="+">)
								  from TEScontrolFormulariosL 
								 where TESid			= TEScontrolFormulariosT.TESid
								   and CBid				= TEScontrolFormulariosT.CBid
								   and TESMPcodigo		= TEScontrolFormulariosT.TESMPcodigo
								   and TESCFTnumInicial = TEScontrolFormulariosT.TESCFTnumInicial
								   and TESCFLestado		= 1
								) as Lote
					  from TEScontrolFormulariosT 
					 where TESid		=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
					   and CBid			=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBidPago#">
					   and TESMPcodigo	=	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">
					   and TESCFTultimo < TESCFTnumFinal
                </cfquery>
                <tr>
                  <td>&nbsp;</td>
                  <td valign="top" align="right">
				  		<strong><cf_translate key=LB_Observaciones>Observaciones</cf_translate>:</strong></td>
                  <td valign="top" colspan="3">
                    <textarea name="TESOPobservaciones" onChange="GvarCambiado=true;" cols="50" rows="4" id="TESOPobservaciones" tabindex="1"><cfif modo NEQ 'ALTA'>#trim(rsForm.TESOPobservaciones)#</cfif></textarea>
                  </td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td valign="top" align="right"> <strong><cf_translate key=LB_BloqueFormularios>Bloque de Formularios</cf_translate>:</strong> </td>
                  <td valign="top">
                    <select name="TESCFT" id="TESCFT" <cfif rsForm.TESMPsoloManual EQ "0">onChange="sbCambiarTESCFT(this);"</cfif> tabindex="1">
                      <cfif rsTESCFT.RecordCount NEQ 1>
                        <option value=""></option>
                      </cfif>
					  <cfset LvarPonerNota = false>
                      <cfloop query="rsTESCFT">
                        <cfif rsForm.TESMPsoloManual EQ "1">
                          <option value="#rsTESCFT.TESCFTnumInicial#,#rsTESCFT.TESCFTnumFinal#,-1">desde #NumberFormat(rsTESCFT.TESCFTnumInicial,"000000")# hasta #NumberFormat(rsTESCFT.TESCFTnumFinal,"000000")#</option>
                        <cfelseif rsTESCFT.TESCFTimprimiendo EQ "0">
                          <option value="#rsTESCFT.TESCFTnumInicial#,#rsTESCFT.TESCFTnumFinal#,#rsTESCFT.TESCFTsiguiente#">desde #NumberFormat(rsTESCFT.TESCFTnumInicial,"000000")# hasta #NumberFormat(rsTESCFT.TESCFTnumFinal,"000000")#, siguiente #NumberFormat(rsTESCFT.TESCFTsiguiente,"000000")#</option>
                        <cfelseif rsTESCFT.Lote NEQ "">
                          <option value="">desde #NumberFormat(rsTESCFT.TESCFTnumInicial,"000000")# hasta #NumberFormat(rsTESCFT.TESCFTnumFinal,"000000")#, (OCUPADO por L-#rsTESCFT.Lote#)</option>
						  <cfset LvarPonerNota = true>
						<cfelse>
                          <option value="">desde #NumberFormat(rsTESCFT.TESCFTnumInicial,"000000")# hasta #NumberFormat(rsTESCFT.TESCFTnumFinal,"000000")#, (BLOQUE OCUPADO sin lote en impresión)</option>
                        </cfif>
                      </cfloop>
                    </select>
                  </td>
                </tr>
				<cfif LvarPonerNota>
					<tr>
						<td colspan="2"></td>
						<td>
							<font color="##FF0000">
								&nbsp;&nbsp;&nbsp;L-I. = <cf_translate key=LB_LoteImpCheques>Lote de Impresión de Cheques</cf_translate>
							</font>
						</td>
					</tr>				
					<tr>
						<td colspan="2"></td>
						<td>
							<font color="##FF0000">
								&nbsp;&nbsp;&nbsp;L-R. = <cf_translate key=LB_LoteReImpCheques>Lote de Reimpresión de Cheques</cf_translate>
							</font>
						</td>
					</tr>				
				</cfif>
                <tr>
                  <td>&nbsp;</td>
                  <td valign="top" align="right"> <strong><cf_translate key=LB_NumeroFormulario>Numero de Formulario</cf_translate>:</strong> </td>
                  <td valign="top">
                    <input type="text" name="TESCFDnumFormulario" id="TESCFDnumFormulario" tabindex="1"
							value="<cfif rsTESCFT.RecordCount EQ 1>#rsTESCFT.TESCFTsiguiente#</cfif>" size="10">
                    <input type="hidden" name="TESCFDmsgAnulacion" id="TESCFDmsgAnulacion" value="">
                  </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td valign="top" align="right">&nbsp; </td>
                  <td valign="top">
                    <input 	type="checkbox" name="chkEntrega" id="chkEntrega" value="1" tabindex="1" 
								onClick="document.getElementById('trEntrega').style.display = this.checked ? '' : 'none';">
                    <strong><cf_translate key=LB_RegistrarEntrega>Registrar Entrega</cf_translate></strong> </td>
                </tr>
                <tr id="trEntrega" style="display:none;">
                  <td colspan="6" align="center">
                    <fieldset>
                    <legend><strong><cf_translate key=LB_DatosEntrega>Datos de Entrega</cf_translate></strong></legend>
                    <table align="center" width="50%">
                      <tr>
                        <td nowrap><strong><cf_translate key=LB_EntregadoA>Entregado a</cf_translate>:</strong></td>
                        <td><input name="TESCFDentregadoId" id="TESCFDentregadoId" 	type="text" value="" size="15" tabindex="1"></td>
                        <td><input name="TESCFDentregado" 	id="TESCFDentregado" 	type="text" value="" size="50" tabindex="1"></td>
                      </tr>
                      <tr>
                        <td align="right" nowrap><strong><cf_translate key=LB_FechaEntrega>Fecha de Entrega</cf_translate>:</strong></td>
                        <td><cf_sifcalendario name="TESCFDentregadoFecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1"
										onchange="funcfechaEnt(this);"></td>
                      </tr>
                    </table>
                  </fieldset></td>
                </tr>
			<cfelse>
                <tr>
                  <td>&nbsp;</td>
                  <td valign="top" align="right"> <strong><cf_translate key=LB_NumeroReferencia>Numero de Referencia</cf_translate>:</strong> </td>
                  <td valign="top">
                    <input type="text" name="TESTreferencia" id="TESTreferencia" size="10" maxlength="30">
                  </td>
                </tr>
			</cfif>
              <tr>
                <td>&nbsp;</td>
                <td valign="top" align="right">
                  <cfif isdefined("form.chkCancelados")>
                    <strong><cf_translate key=LB_MotivoCancelacion>Motivo Cancelacion</cf_translate>:</strong>
                    <cfelse>
                    <strong><cf_translate key=LB_MotivoReimpresion>Motivo de Reimpresión</cf_translate>:</strong>
                  </cfif>
                </td>
                <td colspan="3" valign="top"><font style="color:##FF0000; font-weight:bold;">#rsForm.TESOPmsgRechazo#</font></td>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td colspan="6" class="formButtons" align="center">
                  <input type="hidden" name="botonSel" value="">
                  <input name="PASO" type="hidden" value="11">
                  	<cfoutput><input name="btnEmitirManual" 	id="btnEmitirManual" 	type="submit" value="#BTN_RegistrarPago#" tabindex="1" 
							onClick="return fnEmitir();"
						></cfoutput>
                  <cfif isdefined("Session.Tesoreria.ordenesPagoIrLista") AND Session.Tesoreria.ordenesPagoIrLista EQ "ordenesPagoManual.cfm">
                    <cfoutput><input name="Lista_Ordenes" type="button" id="Lista_Ordenes" tabindex="1"
							value="#BTN_ListaOrdenes#" onClick="javascript: location.href='ordenesPagoManual.cfm';"></cfoutput>
                    <cfelse>
                    	<cfoutput><input name="Orden" type="button" value="#BTN_VolverOrden#" tabindex="1" 
							onClick="javascript: location.href='ordenesPago.cfm?PASO=10&&TESOPid=#Form.TESOPid#';"></cfoutput>
                    <cfif isdefined("Session.Tesoreria.IrListaSPA") and Session.Tesoreria.IrListaSPA>
                      	<cfoutput><input name="Lista_Ordenes" type="button" id="Lista_Ordenes" tabindex="1"
								value="#BTN_ListaSPAprobar#" onClick="javascript: location.href='../Solicitudes/solicitudesAprobar.cfm';"></cfoutput>
                      <cfelse>
                      <cfoutput><input name="Lista_Ordenes" type="button" id="Lista_Ordenes" tabindex="1"
								value="#BTN_ListaOrdenes#" onClick="javascript: location.href='ordenesPago.cfm';"></cfoutput>
                    </cfif>
                  </cfif>
                </td>
              </tr>
				<tr>
					<td colspan="6" align="center">
						<table><tr>
						<td style="background-color: ##D4D0C8; border:outset 2px ##FFFFFF;">
						<cf_navegacion name="chkImprimir" session default="1">
						<input 	type="checkbox" name="chkImprimir" id="chkImprimir" value="1"
								style="background-color:inherit;"
								<cfif form.chkImprimir NEQ "0">
								checked
								</cfif>
						/>
						<label for="chkImprimir" title="#MSG_ImprimeSPDespuesAprobOEmisión#">
						Imprimir Orden emitida
						</label>
						</td>
						</tr></table>
					</td>
				</tr>
            </table>
        </form>
			<cfinclude template="detalleOPs.cfm">

<script language="javascript">
	function sbCambiarTESCFT(TESCFT)
	{
		if (TESCFT.value == "")
			document.getElementById("TESCFDnumFormulario").value = "";
		else
			document.getElementById("TESCFDnumFormulario").value = TESCFT.value.split(",")[2];
	}

	function fnEmitir()
	{
		var LvarFecha = document.getElementById("FechaGeneracionManual");
		if (LvarFecha.value == "")
		{
			alert ("#MSG_DigiteFechaPagoManual#");
			LvarFecha.focus();
			return false;
		}
		LvarFecha = document.getElementById("TESOPFechaPago");
		if (LvarFecha.value == "")
		{
			alert ("#MSG_DigiteFechaPago#");
			LvarFecha.focus();
			return false;
		}

<cfif rsForm.TESTMPtipo EQ "1">
		var LvarTESCFT				= document.getElementById("TESCFT");
			var LvarTESCFDnumFormulario	= document.getElementById("TESCFDnumFormulario");
		if (LvarTESCFT.value == "")
		{
			alert ("#MSG_DigiteBloqueFormularios#");
			LvarTESCFT.focus();
			return false;
		}
		if (LvarTESCFDnumFormulario.value == "")
		{
			alert ("#MSG_DigiteNumFormulario#");
			LvarTESCFDnumFormulario.focus();
			return false;
		}
		if (document.getElementById("chkEntrega").checked)
		{
			var LvarValue = document.getElementById("TESCFDentregadoId");
			if (LvarValue.value == "")
			{
				alert ("Debe digitar la Identificacion de la persona que retira el cheque");
				LvarValue.focus();
				return false;
			}
			LvarValue = document.getElementById("TESCFDentregado");
			if (LvarValue.value == "")
			{
				alert ("Debe digitar el Nombre de la persona que retira el cheque");
				LvarValue.focus();
				return false;
			}
			LvarValue = document.getElementById("TESCFDentregadoFecha");
			if (LvarValue.value == "")
			{
				alert ("Debe digitar la Fecha de Entrega");
				LvarValue.focus();
				return false;
			}
		}
		var LvarTESCFT		= LvarTESCFT.value.split(",");
		var LvarInicio		= parseInt(LvarTESCFT[0]);
		var LvarFinal		= parseInt(LvarTESCFT[1]);
		var LvarSiguiente	= parseInt(LvarTESCFT[2]);
		var LvarPrimero		= parseInt(LvarTESCFDnumFormulario.value);

		if (LvarPrimero < LvarSiguiente)
		{
			alert ("El Número del Primer Formulario a Imprimir no puede ser menor al siguiente formulario libre en el Bloque de Formularios");
			LvarTESCFDnumFormulario.focus();
			return false;
		}

		if (LvarPrimero > LvarFinal)
		{
			alert ("El Número del Primer Formulario a Imprimir no puede ser mayor al ultimo formulario del Bloque de Formularios");
			LvarTESCFDnumFormulario.focus();
			return false;
		}

	<cfif rsForm.TESMPsoloManual EQ "0">
		if (LvarPrimero > LvarSiguiente)
		{
			if (confirm ("El Siguiente Formulario a imprimir en el Bloque era el " + LvarSiguiente + " pero se ha cambiado esta secuencia \n¿Desea anular los Formularios del " + LvarSiguiente + " al " + (LvarPrimero-1) + "?"))
			{
				var LvarMsgAnulacion = prompt("Anulación de Formularios Iniciales antes de Imprimir el Lote. #MSG_DigiteMotAnulacion#!","");
				if (LvarMsgAnulacion && LvarMsgAnulacion != ""){
					document.getElementById("TESCFDmsgAnulacion").value = LvarMsgAnulacion;
					return true;
				}
				if (LvarMsgAnulacion == "")
					alert("#MSG_DigiteMotAnulacion#!");
				return false;
			}
			else
				return false;
		}
	</cfif>
<cfelse>
		var LvarTESTreferencia	= document.getElementById("TESTreferencia");
		if (LvarTESTreferencia.value == "")
		{
			alert ("#MSG_NumRefTransferencia#");
			LvarTESTreferencia.focus();
			return false;
		}
</cfif>
		return true;
	}
	document.form1.FechaGeneracionManual.focus();	

</script>
	</cfoutput>

	<cf_web_portlet_end>
