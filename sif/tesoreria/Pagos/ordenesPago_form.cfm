<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 05 de julio del 2005
	Motivo:	Se agregó un nuevo botón para listar nuevas solicitudes a agregar en la orden de pago
		paso = 3
----------->
<cfinvoke key="LB_Titulo" default="Preparación de Órdenes de Pago"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_CambioMoneda" default="Si cambia la Moneda de Pago, se actualizarán los tipos de cambio"	returnvariable="MSG_CambioMoneda"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_ActualizarTC" default="¿Desea actualizar los Tipos de Cambio"	returnvariable="MSG_ActualizarTC"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_EliminarOP" default="¿Desea ELIMINAR la Orden de Pago"	returnvariable="MSG_EliminarOP"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_OPEmitidaDesaAnular" default="La Orden de Pago ya fue emitida ¿Desea ANULAR la Orden de Pago"	returnvariable="MSG_OPEmitidaDesaAnular"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_ySusSP" default="y sus Solicitudes de Pago"	returnvariable="MSG_ySusSP"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_ModificoInformacion" default="Se modifico la información primero debe presionar <Cambiar>"	returnvariable="MSG_ModificoInformacion"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_OPVaciaOSinModificar" default="No se puede enviar a Emitir una Orden vacía o sin modificar"	returnvariable="MSG_OPVaciaOSinModificar"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_DigitarCta" default="Falta digitar la Cuenta de Pago"	returnvariable="MSG_DigitarCta"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_DigitarMedioPago" default="Falta digitar el Medio de Pago"	returnvariable="MSG_DigitarMedioPago"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_DigitarTC" default="Falta digitar el Tipo de Cambio de Pago"	returnvariable="MSG_DigitarTC"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_CtaDestinoTrans" default="La Cuenta Destino para la transferencia no puede quedar en blanco"	returnvariable="MSG_CtaDestinoTrans"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_NoEnviarEmitirCheque" default="No se puede <Enviar a Emitir> el Medio de Pago Cheque Manual. Utilice <Emitir Pago Manual>"	returnvariable="MSG_NoEnviarEmitirCheque"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_EnviarEmitirOP" default="¿Desea ENVIAR A EMITIR la Orden de Pago"	returnvariable="MSG_EnviarEmitirOP"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_DigitarInformaciónEmisionManual" default="¿Desea DIGITAR LA INFORMACION DE EMISION MANUAL de la Orden de Pago"	returnvariable="MSG_DigitarInformaciónEmisionManual"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_ImprimeSP" default ="Imprime la Solicitud de Pago después de enviarla a los procesos de Aprobación o Emisión" returnvariable="MSG_ImprimeSP" component="sif.Componentes.Translate" method="Translate" xmlfile = "/sif/tesoreria/Solicitudes/TESbtn_Aprobar.xml">
<cfinvoke key="MSG_EscojaCtaDestino" default ="Escoja la Cuenta Destino de la Transferencia" returnvariable="MSG_EscojaCtaDestino" component="sif.Componentes.Translate" method="Translate" xmlfile = "ordenesPago_form.xml">
<cfinvoke key="MSG_NoCtasParaMedioPag" default ="No hay cuentas para Medio de Pago y Moneda" returnvariable="MSG_NoCtasParaMedioPag" component="sif.Componentes.Translate" method="Translate" xmlfile = "ordenesPago_form.xml">
<cfinvoke key="MSG_ValidaCtasPago" default ="La Cuenta de Pago no puede quedar en blanco" returnvariable="MSG_ValidaCtasPago" component="sif.Componentes.Translate" method="Translate" xmlfile = "ordenesPago_form.xml">
<cfinvoke key="MSG_ValidaTC" default ="El Tipo de Cambio de Pago no puede quedar en cero" returnvariable="MSG_ValidaTC" component="sif.Componentes.Translate" method="Translate" xmlfile = "ordenesPago_form.xml">
<cfinvoke key="MSG_ValidaFechaPago" default ="La Fecha de Pago no puede quedar en blanco" returnvariable="MSG_ValidaFechaPago" component="sif.Componentes.Translate" method="Translate" xmlfile = "ordenesPago_form.xml">
<cfinvoke key="MSG_ReviseDatos" default="Por favor revise los siguiente datos"	returnvariable="MSG_ReviseDatos"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="/sif/tesoreria/solicitudes/solicitudesManual.xml"/>
<cfinvoke key="MSG_ValidaCtaDestino" default="La Cuenta Destino de la transferencia no puede quedar en blanco"	returnvariable="MSG_ValidaCtaDestino"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_ValidaReferencia" default="La Referencia no puede quedar en blanco"	returnvariable="MSG_ValidaReferencia"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="LB_SocioCorporativo" default="Socio Corporativo"	returnvariable="LB_SocioCorporativo"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="LB_SocioNegocios" default="Socio Negocios"	returnvariable="LB_SocioNegocios"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="LB_Beneficiario" default="Beneficiario"	returnvariable="LB_Beneficiario"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="LB_ClienteDetallista" default="Cliente Detallista"	returnvariable="LB_ClienteDetallista"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_FaltaCtaPago" default="Falta Cuenta de Pago"	returnvariable="MSG_FaltaCtaPago"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_EmpresaConOtraMon" default="Si cambia la Empresa de Pago y esta tiene otra Moneda Local, se actualizarán los tipos de cambio"	returnvariable="MSG_EmpresaConOtraMon"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_SoloCuentas" default="Sólo cuentas"	returnvariable="MSG_SoloCuentas"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_en" default="en"	returnvariable="MSG_en"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_Especiales" default="Especiales"	returnvariable="MSG_Especiales"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_CualquierCuentaCualquierBanco" default="Cualquier cuenta de cualquier Banco en"	returnvariable="MSG_CualquierCuentaCualquierBanco"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_SoloCtasMismoBanco" default="Sólo Cuentas Propias del Mismo Banco de Pago en"	returnvariable="MSG_SoloCtasMismoBanco"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_SoloCtasInterbancariasOtrosBancos" default="Sólo Cuentas Interbancarias de otros Bancos en"	returnvariable="MSG_SoloCtasInterbancariasOtrosBancos"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_SoloCtasInterbancariasCualquierBanco" default="Sólo Cuentas Interbancarias de cualquier Banco en"	returnvariable="MSG_SoloCtasInterbancariasCualquierBanco"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="MSG_CtasPropiasMismoBco" default="Ctas propias del mismo Bco e Interbancarias de otros en"	returnvariable="MSG_CtasPropiasMismoBco"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>

<cfinvoke key="BTN_Cambiar" default="Cambiar"	returnvariable="BTN_Cambiar"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="BTN_Eliminar" default="Eliminar"	returnvariable="BTN_Eliminar"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="BTN_Anular" default="Anular"	returnvariable="BTN_Anular"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="BTN_Duplicar" default="Duplicar"	returnvariable="BTN_Duplicar"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="BTN_SeleccionarSol" default="Seleccionar Solicitudes"	returnvariable="BTN_SeleccionarSol"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="BTN_ListaSol" default="Lista Solicitudes"	returnvariable="BTN_ListaSol"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="BTN_Imprimir" default="Imprimir"	returnvariable="BTN_Imprimir"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="BTN_EnvEmitir" default="Enviar a emitir"	returnvariable="BTN_EnvEmitir"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="BTN_EmitirPagoManual" default="Emitir Pago Manual"	returnvariable="BTN_EmitirPagoManual"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>
<cfinvoke key="BTN_ImprimirOrdenEnv" default="Imprimir Orden Enviada"	returnvariable="BTN_ImprimirOrdenEnv"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/>

<cfparam name="form.TESOPid" default="-1">

<cfquery name="rsSQL" datasource="#session.DSN#">
	select 	count(1) as cantidad,
			sum(case when TESDPtipoDocumento = 10 then 1 else 0 end) as cantidadTEF,
			min(TESDPidDocumento) as TESTILid
	  from TESdetallePago
	 where TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
</cfquery>

<cfset GvarTEFbcos = rsSQL.cantidadTEF GT 0>

<cfif GvarTEFbcos and rsSQL.cantidad GT 1>
	<!--- Cuando una OP de TEF para CB tiene mas de una SP:
			Si todas son tipo 10=TEF ctas, la OP se deja una SP y crea una OP por las demas 10
			Si hay de otro tipo, la OP se deja las SPs de otro tipo y crea una OP por todas las 10
	--->
	<cfquery name="rsTEF" datasource="#session.DSN#">
		select TESDPidDocumento as TESTILid, TESSPid
		  from TESdetallePago
		 where TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
		   and TESDPtipoDocumento = 10
		 <cfif rsSQL.cantidad EQ rsSQL.cantidadTEF>
		   and TESDPidDocumento <> #rsSQL.TESTILid#
		 </cfif>
	</cfquery>
	<cfloop query="rsTEF">
		<cfinvoke 	component="sif.tesoreria.Componentes.TESaplicacion"
					method="sbGeneraOP_TransferenciasCB"
					returnVariable = "LvarOP"
		>
			<cfinvokeargument name="TESTILid" value="#rsTEF.TESTILid#"/>
			<cfinvokeargument name="TESSPid" value="#rsTEF.TESSPid#"/>
		</cfinvoke>
	</cfloop>
	<cfthrow type="toUser" message="La Orden de TEF entre Cuentas Bancarias contiene más de una Solicitud de Pago, se separan las Solicitudes de TEF entre Cuentas. (F5 para continuar)">
<cfelseif GvarTEFbcos>
	<cfquery name="rsTEF" datasource="#Session.DSN#">
		select TESDPidDocumento as TESTILid
		  from TESdetallePago
		 where TESid 	= #session.Tesoreria.TESid#
		   and TESOPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
	</cfquery>
	<cfquery name="rsTEF" datasource="#Session.DSN#">
		select CBidOri, CBidDst
		  from TEStransfIntercomD
		 where TESid 	= #session.Tesoreria.TESid#
		   and TESTILid = <cfqueryparam value="#rsTEF.TESTILid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfset titulo = 'Preparación de Órdenes de TEF para Transferencia entre Cuentas Bancarias'>
<cfelse>
	<cfset titulo = '#LB_Titulo#'>
</cfif>
<cfif GvarDetalleGrande>
	<table 	align="center" border="0"
			style="border:1px solid #666666"
			cellspacing="0" cellpadding="0" width="100%">
		<tr>
			<td height="18" align="center"
				 style="font-weight:bold; color:#FFFFFF"
				 bgcolor="#3D648B"
			>
				<cfoutput>#titulo#</cfoutput>
			</td>
		</tr>
		<tr>
			<td>
				<cfset sbPoneForm()>
			</td>
		</tr>
	</table>
<cfelse>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<cfset sbPoneForm()>
	<cf_web_portlet_end>
</cfif>

<cffunction name="sbPoneForm" output="true" returntype="void">
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
			op.TESOPnumero, op.TESOPfechaPago,
			case
				when op.SNid		is not null and sn.SNidCorporativo is not null then '#LB_SocioCorporativo#'
				when op.SNid		is not null then '#LB_SocioNegocios#'
				when op.TESBid 		is not null then '#LB_Beneficiario#'
				when op.CDCcodigo 	is not null then '#LB_ClienteDetallista#'
				else 'N/A'
			end as TipoBeneficiario,
			cb.Bid, op.CBidPago, op.TESMPcodigo, tmp.TESTMPtipo, tmp.TESTGcodigoTipo, tmp.TESTGtipoCtas,
			op.EcodigoPago, op.Miso4217Pago,
			op.TESTPid,
			op.SNid, op.SNidP, op.TESBid, op.CDCcodigo, op.TESOPbeneficiario, op.TESOPbeneficiarioSuf,
			ep.Edescripcion,
			case when coalesce(op.TESOPtipoCambioPago, 0) = 0 then 1 else op.TESOPtipoCambioPago end as TESOPtipoCambioPago,
			op.Miso4217Pago, mep.Miso4217 as Miso4217EmpresaPago, mep.Mnombre as Mempresa,
			mp.Mnombre, op.TESOPtotalPago, TESEcodigo,
			op.TESOPobservaciones,op.TESOPinstruccion, op.TESOPmsgRechazo, op.ts_rversion,
			op.TESOPConceptoCIE, op.TESOPConvenioCIE, op.TESOPReferenciaCIE
		from TESordenPago op
			left join SNegocios sn
				 on sn.SNid	= op.SNid
			left join Monedas mp
				 on mp.Ecodigo	= op.EcodigoPago
				and mp.Miso4217	= op.Miso4217Pago
			left join Empresas ep
				inner join Monedas mep
					 on mep.Ecodigo	= ep.Ecodigo
					and mep.Mcodigo	= ep.Mcodigo
				 on ep.Ecodigo = op.EcodigoPago
			left join TESmedioPago tmp
				 on tmp.TESid 		= op.TESid
				and tmp.CBid 		= op.CBidPago
				and tmp.TESMPcodigo 	= op.TESMPcodigo
			left join CuentasBancos cb
				 on cb.CBid 	= op.CBidPago
				and cb.Ecodigo 	= op.EcodigoPago
		where op.TESOPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
		  and op.TESid = #session.Tesoreria.TESid#
		  and op.TESOPestado in (10,11)
	</cfquery>

	<cfquery name="rsSQL" datasource="#session.DSN#">
		select TESEcodigo
		  from TESendoso
		 where TESid 		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Tesoreria.TESid#" 		null="#Len(session.Tesoreria.TESid) Is 0#">
		   and TESEdefault	= 1
	</cfquery>
	<cfset LvarTESEcodigoDefault = rsSQL.recordCount GT 0>
	<cfif rsForm.TESEcodigo EQ "">
		<cfset LvarTESEcodigo = rsSQL.TESEcodigo>
	<cfelse>
		<cfset LvarTESEcodigo = rsForm.TESEcodigo>
	</cfif>

	<cfquery datasource="#session.dsn#" name="rsCtasDstTR">
		select TESTPid, TESTPbanco, Miso4217, TESTPcuenta, TESTPestado,
						Bid,
						TESTPcodigoTipo,
						TESTPcodigo,
						TESTPtipoCtaPropia
		  from TEStransferenciaP
		 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		 <cfif GvarTEFbcos>
		   and (CBid = #rsTEF.CBidDst# OR TESTPid = #rsForm.TESTPid#)
		 <cfelseif rsForm.SNidP NEQ "">
		   and SNidP = #rsForm.SNidP#
		 <cfelseif rsForm.TESBid NEQ "">
		   and TESBid = #rsForm.TESBid#
		 <cfelse>
		   and CDCcodigo = #rsForm.CDCcodigo#
		 </cfif>
		   and (TESTPestado <> 2			<!--- que no este inactivo --->
		   <cfif rsForm.TESTPid NEQ "">
		   		OR TESTPid = #rsForm.TESTPid#
		   </cfif>
		   		)
	</cfquery>

	<!--- Se va a pedir la cuenta destino del pago, unicamente para Transferencias Impresas o Electrónicas--->
	<cfset LvarTRI_TRE = (modo NEQ "ALTA" AND (rsForm.TESTMPtipo EQ "2" OR rsForm.TESTMPtipo EQ "3" OR rsForm.TESTMPtipo EQ "4"))>
	<cfif modo EQ "ALTA">
		<cfset LvarTESTPid = "">
	<cfelseif rsCtasDstTR.recordCount EQ 0>
		<cfset LvarTESTPid = "">
	<cfelseif LvarTRI_TRE AND rsForm.TESTPid EQ "">
		<!---
			Determina y graba Cuenta Destino default
		 --->
		<cfset LvarTESTPid = "">
		<cfif rsCtasDstTR.recordCount EQ 1>
			<cfset LvarTESTPid = rsCtasDstTR.TESTPid>
		</cfif>
		<cfloop query="rsCtasDstTR">
			<cfif rsCtasDstTR.TESTPestado EQ "1">
				<cfset LvarTESTPid = rsCtasDstTR.TESTPid>
				<cfbreak>
			</cfif>
		</cfloop>
	<cfelse>
		<cfset LvarTESTPid = rsForm.TESTPid>
	</cfif>

	<cfoutput>
		<script type="text/javascript">
		
			function btnSelected(name, f) {
				if (f != null) {
					return (f.botonSel.value == name)
				} else {
					return (botonActual == name)
				}
			}

			function validar(formulario)	{
				
					var error_input;
					var error_msg = '';
				if (btnSelected('Cambio',formulario)){

					if (formulario.CBidPago.value == "") {
						error_msg += "\n - #MSG_ValidaCtasPago#.";
						error_input = formulario.CBidPago;
					}
					else if (parseFloat(formulario.TESOPtipoCambioPago.value) == "0") {
						error_msg += "\n - #MSG_ValidaTC#.";
						error_input = formulario.TESOPtipoCambioPago;
					}
					if (formulario.TESOPfechaPago.value == "") {
						error_msg += "\n - #MSG_ValidaFechaPago#.";
						error_input = formulario.TESOPfechaPago;
					}
					var LvarCBid = document.getElementById("CBidPago").value.split(",")[0];
					var objTESMPcodigo = document.getElementById("TESMPcodigo");
					if (LvarTipoMedioPago[LvarCBid][objTESMPcodigo.selectedIndex] == "2" || LvarTipoMedioPago[LvarCBid][objTESMPcodigo.selectedIndex] == "3")
						if (formulario.TESTPid.value == "") {
								error_msg += "\n - #MSG_ValidaCtaDestino#.";
							error_input = formulario.TESTPid;
						}
						/*if (formulario.referenciaCIE.value == "") {
								error_msg += "\n - #MSG_ValidaReferencia#.";
							error_input = formulario.referenciaCIE;
						}*/
					// Validacion terminada
					if (error_msg.length != "") {
						alert("#MSG_ReviseDatos#:"+error_msg);
						error_input.focus();
						return false;
					}
				}
				if(formulario.TESMPcodigo.value == "CIE" && formulario.referenciaCIE.value == ""){
							error_msg += "\n - #MSG_ValidaReferencia#.";							
							alert("#MSG_ReviseDatos#: "+error_msg);
						return false;
				}

				return fnVerificarDet();
			}

			function fnCambioCBidPago (f)
			{
				if (f.CBidPago.value != "")
				{
					var LvarPago = f.CBidPago.value.split(",");

					if (f.Miso4217Pago.value == "" || f.Miso4217Pago.value == "")
					{
						location.href = "ordenesPago_sql.cfm?TESOPid=#form.TESOPid#&btnCBidPago=1&CBidPago=" + LvarPago[0];
						return true;
					}
					else if (f.Miso4217Pago.value != LvarPago[2])
					{
						if (confirm('#MSG_CambioMoneda#. \n#MSG_ActualizarTC#?'))
						{
							location.href = "ordenesPago_sql.cfm?TESOPid=#form.TESOPid#&btnCBidPago=1&CBidPago=" + LvarPago[0];
							return true;
						}
					}
					else if (f.Miso4217EmpresaPago.value != LvarPago[3])
					{
						if (confirm('#MSG_EmpresaConOtraMon#. \n#MSG_ActualizarTC#?'))
						{
							location.href = "ordenesPago_sql.cfm?TESOPid=#form.TESOPid#&btnCBidPago=1&CBidPago=" + LvarPago[0];
							return true;
						}
					}
					else
					{
						location.href = "ordenesPago_sql.cfm?TESOPid=#form.TESOPid#&btnCBidPago=1&CBidPago=" + LvarPago[0];
						return true;
					}

					f.CBidPago.selectedIndex = 0;
				<cfif #rsForm.CBidPago# NEQ "">
					for (var i=0; i<f.CBidPago.options.length; i++)
					{
						if (f.CBidPago.options[i].value.split(",")[0] == #rsForm.CBidPago#)
						{
							f.CBidPago.selectedIndex = i;
						}
					}
				</cfif>
				}
				return false;
			}
		//-->
		</script>

		<form action="ordenesPago_sql.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
			<input type="hidden" name="TESOPid" value="#form.TESOPid#" tabindex="-1">
			<input type="hidden" name="TRH" id="TRH"
					value="<cfif LvarTRI_TRE>1</cfif>"
					tabindex="-1">
			<table align="center" summary="Tabla de entrada" border="0" cellpadding="1" cellspacing="1">
				<tr>
					<td>&nbsp;</td>
					<td valign="top" align="right"><strong><cf_translate key=LB_NumOrden>Num. Orden</cf_translate>:</strong></td>
					<td valign="top">
						<strong>#LSNumberFormat(rsForm.TESOPnumero)#</strong>
					</td>
					<td valign="top" align="right">
						<strong><cf_translate key=LB_FechaOrden>Fecha Orden</cf_translate>:</strong>
					</td>
					<td valign="top" align="left">
						<strong>#LSDateFormat(rsForm.TESOPfechaGeneracion,"DD/MM/YYYY")#</strong>
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td align="right">
						<strong>#rsForm.TipoBeneficiario#:</strong>
					</td>
					<td valign="top" colspan="3">
						<strong>#rsForm.TESOPbeneficiario#</strong>
						<cfparam name="rsForm.TESOPbeneficiarioSuf" default="">
						<input type="text" name="TESOPbeneficiarioSuf" value="#rsForm.TESOPbeneficiarioSuf#" size="60" tabindex="1">
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td valign="top" align="right"><strong><cf_translate key=LB_CuentaPago>Cuenta de Pago</cf_translate>:</strong></td>
					<td colspan="3">
						<cfif #rsForm.CBidPago# EQ "">
							<cfset LvarNone = "yes">
						<cfelse>
							<cfset LvarNone = "yes">
						</cfif>

						<cfset session.tesoreria.CBidPago = -1>
						<cfif GvarTEFbcos>
							<cfset LvarCBidPago = rsTEF.CBidOri>
						<cfelse>
							<cfset LvarCBidPago = "">
						</cfif>
						<cf_cboTESCBid name="CBidPago" value="#rsForm.CBidPago#" Ccompuesto="yes" Dcompuesto="yes" none="#LvarNone#"
						cboTESMPcodigo="TESMPcodigo" onchange="return fnCambioCBidPago(this.form);GvarCambiado=true;" tabindex="1"
						CBid = "#LvarCBidPago#">
						<input type="hidden" name="Miso4217Pago" value="#rsForm.Miso4217Pago#" tabindex="-1">
						<input type="hidden" name="Miso4217EmpresaPago" value="#rsForm.Miso4217EmpresaPago#" tabindex="-1">
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td valign="top" align="right"><strong><cf_translate key=LB_MedioPago>Medio de Pago</cf_translate>:</strong></td>
					<td colspan="3" nowrap>
					<cfset session.tesoreria.TESMPcodigo = "">
					<cfif rsForm.CBidPago EQ "">
						<input type="hidden" name="TESMPcodigo" tabindex="-1">
					<cfelseif GvarTEFbcos>
						<cf_cboTESMPcodigo name="TESMPcodigo" value="#rsForm.TESMPcodigo#" CBid="CBidPago" CBidValue="#rsForm.CBidPago#" onChange="GvarCambiado=true; sbTESMPcodigoChange(this);" NoChks="true">
					<cfelse>
						<cf_cboTESMPcodigo name="TESMPcodigo" value="#rsForm.TESMPcodigo#" CBid="CBidPago" CBidValue="#rsForm.CBidPago#" onChange="GvarCambiado=true; sbTESMPcodigoChange(this);">
					</cfif>
					<input type="text" id="T_CTAS" style="width:500px;border:none;">
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr id="trCIE" <cfif isDefined("rsForm.TESMPcodigo") AND #UCASE(TRIM(rsForm.TESMPcodigo))# NEQ "CIE">style="display:none"</cfif>>
					<td>&nbsp;</td>
					<td valign="top" align="right"><strong><cf_translate key=LBMoneda>Concepto CIE</cf_translate>:</strong></td>
					<td><input type="text" name="conceptoCIE" id="conceptoCIE" maxlength="30" size="30" value="<cfif isDefined("rsForm.TESOPConceptoCIE")>#rsForm.TESOPConceptoCIE#</cfif>"></td>
					<td valign="top" align="right"><strong><cf_translate key=LBMoneda>Convenio CIE</cf_translate>:</strong></td>
					<td><input type="text" style="text-align:right;" name="convenioCIE" id="convenioCIE" maxlength="7" size="8" value="<cfif isDefined("rsForm.TESOPConvenioCIE")>#rsForm.TESOPConvenioCIE#</cfif>">
					 <strong><cf_translate key=LBMoneda>Referencia CIE</cf_translate>:</strong>
					 <input type="text" style="text-align:right;" name="referenciaCIE" id="referenciaCIE" maxlength="30" size="30" value="<cfif isDefined("rsForm.TESOPReferenciaCIE")>#rsForm.TESOPReferenciaCIE#</cfif>"></td>
				</tr>
<!---
				<tr>
					<td>&nbsp;</td>
					<td valign="top" align="right"><strong>Empresa de Pago:</strong></td>
					<td colspan="3">
						<input type="hidden" name="EcodigoPago" value="#rsForm.EcodigoPago#">
						<strong>#rsForm.Edescripcion#</strong>
					</td>
					<td>&nbsp;</td>
				</tr>
--->
				<tr>
					<td>&nbsp;</td>
					<td valign="top" align="right"><strong><cf_translate key=LBMoneda>Moneda</cf_translate> <cf_translate key=LB_EmpresaPago>Empresa Pago</cf_translate>:</strong></td>
					<td valign="top">
						<strong>#rsForm.Mempresa#</strong>
					</td>
					<td valign="top" align="right" rowspan="3">
						<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_translate key=LB_Observaciones>Observaciones</cf_translate>:
						</strong>
					</td>
					<td valign="top" rowspan="3">
						<textarea name="TESOPobservaciones" onChange="GvarCambiado=true;" cols="50" rows="4" id="TESOPobservaciones" tabindex="1"><cfif modo NEQ 'ALTA'>#trim(rsForm.TESOPobservaciones)#</cfif></textarea>
					</td>
					<td rowspan="3">&nbsp;</td>
				</tr>

				<tr>
					<td>&nbsp;</td>
					<td valign="top" align="right"><strong><cf_translate key=LB_TotalPagar>Total a Pagar</cf_translate>:</strong></td>
					<td valign="top" nowrap>
						<cfif rsForm.Miso4217Pago EQ "">
							<strong><cfoutput>**#MSG_FaltaCtaPago#**</cfoutput></strong>
						<cfelse>
							<strong>#numberFormat(rsForm.TESOPtotalPago,",0.00")# #rsForm.Mnombre#</strong>
						</cfif>
					</td>
				</tr>

				<tr>
					<td>&nbsp;</td>
					<td valign="top" align="right"><strong><cf_translate key=LB_TipoCambio>Tipo de Cambio</cf_translate>:</strong></td>
					<td valign="top" nowrap>
					<cfif rsForm.Miso4217Pago EQ "">
							<input name="TESOPtipoCambioPago" id="TESOPtipoCambioPago"
								value="0.0000"
								style="text-align:right; display:none;background-color:##FFFFFF;"
								readonly="yes"
								tabindex="-1"
								onChange="GvarCambiado=true;"
							>
					<cfelseif rsForm.Miso4217Pago EQ rsForm.Miso4217EmpresaPago>
							<input name="TESOPtipoCambioPago" id="TESOPtipoCambioPago"
								value="1.0000"
								style="text-align:right; display:none; background-color:##FFFFFF;"
								readonly="yes"
								tabindex="-1"
								onChange="GvarCambiado=true;"
							> n/a
					<cfelse>
							<input name="TESOPtipoCambioPago" id="TESOPtipoCambioPago"
								value="#NumberFormat(rsForm.TESOPtipoCambioPago,",0.0000")#"
								style="text-align:right;"
								tabindex="1"
								onFocus="this.value=qf(this); this.select();" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
								onChange="GvarCambiado=true; sbCambioTCP(this); fm(this,4);"
							> #rsForm.Miso4217EmpresaPago#s/#rsForm.Miso4217Pago#
					</cfif>

					</td>
				</tr>
				<tr>
					<td >&nbsp;</td>
					<td valign="top" align="right" nowrap="nowrap"><strong><cf_translate key=LB_FechaPago>Fecha Pago </cf_translate> <cf_translate key=LB_Solicitada>Solicitado</cf_translate>:</strong></td>
					<td valign="top">
						<cfset fechaSol = LSDateFormat(Now(),'dd/mm/yyyy') >
						<cfif modo NEQ 'ALTA'>
							<cfset fechaSol = LSDateFormat(rsForm.TESOPfechaPago,'dd/mm/yyyy') >
						</cfif>
						<cf_sifcalendario form="form1" value="#fechaSol#" name="TESOPfechaPago" onchange="GvarCambiado=true;" tabindex="1">
					</td>
					<td valign="top" align="right"><strong><cf_translate key=LB_InstruccionBanco>Instrucción al Banco </cf_translate>:</strong></td>
					<td valign="top">
						<input 	type="text" name="TESOPinstruccion" id="TESOPinstruccion" maxlength="40" size="45"
							tabindex="1"
							value="<cfif modo NEQ 'ALTA'>#trim(rsForm.TESOPinstruccion)#</cfif>"
								onChange="GvarCambiado = true;"
						>
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td colspan="3">
						<input  disabled="disabled" size="1" style="background-color:inherit; border:hidden 2px; width:0px;"/>
					</td>
					<td id="CK1" <cfif modo EQ 'ALTA' OR rsForm.TESTMPtipo NEQ "1">style="display:none;"</cfif> valign="top" align="right">
						<strong>Código Endoso:</strong>
					</td>
					<td id="CK2" <cfif modo EQ 'ALTA' OR rsForm.TESTMPtipo NEQ "1">style="display:none;"</cfif> valign="top">
						<select name="TESEcodigo" onChange="GvarCambiado=true;" tabindex="1">
						<cfif not LvarTESEcodigoDefault>
							<option value="">(Sin codigo de Endoso)</option>
						</cfif>
							<cfloop query="rsTESendoso">
							<option value="#rsTESendoso.TESEcodigo#" <cfif rsTESendoso.TESEcodigo EQ LvarTESEcodigo>selected</cfif>>#rsTESendoso.TESEdescripcion#</option>
							</cfloop>
						</select>
					</td>
					<td id="TR1" <cfif modo EQ 'ALTA' OR NOT LvarTRI_TRE>style="display:none;"</cfif> valign="top" align="right">
						<strong>Cuenta Destino:</strong>
					</td>
					<td id="TR2" <cfif modo EQ 'ALTA' OR NOT LvarTRI_TRE>style="display:none;"</cfif> valign="top">
							<select name="TESTPid" id="TESTPid" onChange="GvarCambiado=true;" tabindex="1">
							<cfif rsCtasDstTR.recordCount EQ 0>
								<option value="">(Debe registrar una Cuenta Destino en #rsForm.Miso4217Pago#s)</option>
							<cfelse>
								<cfif not GvarTEFbcos>
								<option value="">(#MSG_EscojaCtaDestino#)</option>
								</cfif>
								<cfloop query="rsCtasDstTR">
								<option value="<cfif rsCtasDstTR.TESTPestado NEQ "2">#rsCtasDstTR.TESTPid#</cfif>" <cfif rsCtasDstTR.TESTPid EQ LvarTESTPid>selected</cfif>>#rsCtasDstTR.TESTPbanco# - #rsCtasDstTR.Miso4217# - #rsCtasDstTR.TESTPcuenta#<cfif rsCtasDstTR.TESTPestado EQ "2"> (Cta.Borrada)</cfif></option>
								</cfloop>
							</cfif>
						</select>
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<cf_cboFormaPago TESOPFPtipoId="6" TESOPFPid="#form.TESOPid#">
				</tr>
			<cfif rsForm.TESOPmsgRechazo NEQ "">
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
			</cfif>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="6" class="formButtons" align="center">
						<input type="hidden" name="botonSel" value="" tabindex="-1">
					<cfif NOT isdefined("form.chkCancelados")>
						<input name="PASO" type="hidden" value="10" tabindex="-1">
						<input name="Cambio" type="submit" value="#BTN_Cambiar#"
							onClick="this.form.botonSel.value = 'Cambio';"
							tabindex="1"
						>
						<cfparam name="rsForm.TESOPmsgRechazo" default="">
						<cfif not GvarTEFbcos and rsForm.TESOPmsgRechazo EQ "">
							<input name="Baja" 	type="submit" value="#BTN_Eliminar#" tabindex="1"
								onClick="return confirm('#MSG_EliminarOP# #rsform.TESOPnumero#?');"
							>
						<cfelse>
							<input name="Anular OP" 	type="submit" value="#BTN_Anular#" tabindex="1"
								onClick="return confirm('#MSG_OPEmitidaDesaAnular# #rsform.TESOPnumero#, #MSG_ySusSP#?');"
							>
						</cfif>
					<cfelse>
						<input name="PASO" type="hidden" value="0" tabindex="-1">
						<input name="Duplicar" type="submit" value="#BTN_Duplicar#" tabindex="1"
							onClick="javascript: this.form.botonSel.value = this.name;">
					</cfif>
					<cfif not GvarTEFbcos>
						<input name="SeleccionarSP" type="button" id="SeleccionarSP" value="#BTN_SeleccionarSol#" tabindex="1"
						onClick="location.href='ordenesPago.cfm?PASO=3&TESOPid=#form.TESOPid#'">
					</cfif>
					<cfif isdefined("Session.Tesoreria.ordenesPagoIrLista") and len(Session.Tesoreria.ordenesPagoIrLista) GT 0>
						<input name="Lista_Ordenes" type="button" id="Lista_Ordenes" value="#BTN_ListaSol#"  tabindex="1"
							onClick="javascript: location.href='../Solicitudes/#Session.Tesoreria.ordenesPagoIrLista#';">
					<cfelse>
						<input name="Lista_Ordenes" type="button" id="Lista_Ordenes" value="Lista Ordenes" tabindex="1"
							onClick="javascript: location.href='ordenesPago.cfm';">
					</cfif>
					</td>
				</tr>
			<cfif NOT isdefined("form.chkCancelados")>
				<tr>
					<td colspan="6" class="formButtons" align="center">
						<input name="Imprimir" 	id="Imprimir" 	type="button" value="#BTN_Imprimir#"
							onClick="return funcImprimir();" tabindex="1"
						>
						<input name="AAprobar" 	id="AAprobar" 	type="submit" value="#BTN_EnvEmitir#"
							onClick="return fnEmitir('E');" tabindex="1"
						>
						<input name="EmisionManual" id="EmisionManual" type="submit" value="#BTN_EmitirPagoManual#"
							onClick="return fnEmitir('M');" tabindex="1"
						>
						<cfoutput>
						<script language="javascript">
						<cfif LvarTRI_TRE AND rsForm.TESTPid EQ "" AND LvarTESTPid NEQ "">
							var GvarCambiado = true;
						<cfelse>
							var GvarCambiado = false;
						</cfif>
							function fnEmitir(LvarTipo)
							{
								if(GvarCambiado)
								{
									alert("#MSG_ModificoInformacion#");
									return false;
								}
								if (!validar(document.getElementById("form1")))
									return false;
							<cfif rsForm.TESOPtotalPago EQ 0>
								alert('#MSG_OPVaciaOSinModificar#');
								return false;
							<cfelseif rsForm.CBidPago EQ "">
								alert('#MSG_DigitarCta#');
								return false;
							<cfelseif rsForm.TESMPcodigo EQ "">
								alert('#MSG_DigitarMedioPago#');
								return false;
							<cfelseif rsForm.TESOPtipoCambioPago EQ 0 OR rsForm.TESOPtipoCambioPago EQ "">
								alert('#MSG_DigitarTC#');
								return false;
							<cfelse>
								var LvarCB	= document.getElementById("CBidPago").value.split(",")[0];
								var LvarMP 	= document.getElementById("TESMPcodigo").selectedIndex;

								if (LvarTipoMedioPago[LvarCB][LvarMP] == "2" || LvarTipoMedioPago[LvarCB][LvarMP] == "3")
									if (document.form1.TESTPid.value == "")
									{
										alert("#MSG_CtaDestinoTrans#.");
										return false;
									}

								if (LvarTipo == "E")
									if (LvarSoloManual[LvarCB][LvarMP] == "1")
									{
										alert("#MSG_NoEnviarEmitirCheque#");
										return false;
									}
									else
										return confirm('#MSG_EnviarEmitirOP# #rsform.TESOPnumero#?');
								else if (LvarTipo == "M")
									if (confirm('#MSG_DigitarInformaciónEmisionManual# #rsform.TESOPnumero#?'))
									{
										location.href = "ordenesPago.cfm?PASO=11&TESOPid=#Form.TESOPid#";
									}
								return false;
							</cfif>
							}

							function funcImprimir()
							{
							<cfif rsForm.TESOPtotalPago EQ 0>
								alert("ERROR: No se puede Imprimir una Orden de Pago vacía");
								return false;
							</cfif>
							  var url = '/cfmx/sif/Utiles/genImpr.cfm?archivo=#JSStringFormat("/sif/tesoreria/Pagos/imprOrdenPago_form.cfm")#&imprime=1&TESOPid=#form.TESOPid#';
							  if (window.print && window.frames && window.frames.printerIframe) {
								var html = '';
								html += '<html>';
								html += '<body onload="parent.printFrame(window.frames.urlToPrint);">';
								html += '<iframe name="urlToPrint" src="' + url + '"><\/iframe>';
								html += '<\/body><\/html>';

								var ifd = window.frames.printerIframe.document;
								ifd.open();
								ifd.write(html);
								ifd.close();
							  }
							  else
							  {
								var win = window.open('', 'printerWindow', 'width=600,height=300,resizable,scrollbars,toolbar,menubar');
								var html = '';
								html += '<html>';
								html += '<frameset rows="100%, *" '
									 +  'onload="opener.printFrame(window.urlToPrint);window.close();">';
								html += '<frame name="urlToPrint" src="' + url + '" \/>';
								html += '<frame src="about:blank" \/>';
								html += '<\/frameset><\/html>';
								win.document.open();
								win.document.write(html);
								win.document.close();
							  }
							  return false;
							}

							function printFrame (frame)
							{
							  if (frame.print)
							  {
								frame.focus();
								frame.print();
								frame.src = "about:blank"
							  }
							}

						</script>
					   </cfoutput>
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
						<cfoutput><label for="chkImprimir" title="#MSG_ImprimeSP#">
						#BTN_ImprimirOrdenEnv#
						</label></cfoutput>
						</td>
						</tr></table>
					</td>
				</tr>
			</cfif>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="6" class="formButtons">
						<cfinclude template="ordenesPago_formDet.cfm">
					</td>
				</tr>
			</table>
			<cfif modo NEQ 'ALTA'>
				<cfset ts = "">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
					artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#" tabindex="-1">
			</cfif>
		</form>
	</cfoutput>
	<cfoutput>
	<script>
		var GvarCtasDstTRs = new Array();
		<cfloop query="rsCtasDstTR">
		GvarCtasDstTRs[#rsCtasDstTR.currentRow#] = {
				id	: '#rsCtasDstTR.TESTPid#',
				bid	: '#rsCtasDstTR.Bid#',
				iso : '#JSstringFormat(rsCtasDstTR.Miso4217)#',
				cta : '<cfif rsCtasDstTR.TESTPestado EQ 1>*</cfif>#JSstringFormat("#rsCtasDstTR.TESTPbanco# - #rsCtasDstTR.Miso4217# - #rsCtasDstTR.TESTPcuenta#")#',
				tc  : '#JSstringFormat(rsCtasDstTR.TESTPcodigoTipo)#',
				prp : '#JSstringFormat(rsCtasDstTR.TESTPtipoCtaPropia)#',
				sts : '#JSstringFormat(rsCtasDstTR.TESTPestado)#',
				msg : ''
			};
		</cfloop>

		// Construye el combo de Cuentas Destino

		// Solo se pueden escoger cuentas destino en la misma moneda de la cuenta de pago
		// TRM: No tiene más restricciones
		// TRI y TRE:
		//		1. Sólo se pueden escoger Cuentas Destino cuyo Tipo de Código Interbancario coincidan con el Tipo Cuenta Interbancaria del Medio de Pago
		//		2. Si el Tipo es Nacional "Cuenta Interbancaria" no debe tener marcado "TEF sólo para mismo Banco"
		//		3. Si el Tipo es Nacional pero diferencia entre cuentas Propias e Interbancario:
		//			a. La cuenta Destino debe estar asociada a un Banco
		//			b. Si el Medio de Pago es 'Sólo Cuentas Propias del Mismo Banco de Pago', la cuenta destino debe tener marcado el check de 'Sólo para TEF dentro del mismo Banco' y el Banco debe ser el mismo de la Cuenta de Pago
		//			c. Si el Medio de Pago es 'Sólo Cuentas Interbancarias de otros Bancos', la cuenta destino debe tener desmarcado el check de 'Sólo para TEF dentro del mismo Banco' y el Banco debe ser diferente al de la Cuenta de Pago
		//			d. Si el Medio de Pago es 'Sólo Cuentas Interbancarias de cualquier Banco', la cuenta destino debe tener desmarcado el check de 'Sólo para TEF dentro del mismo Banco'
		//		4. Si el Tipo es 'Ctas propias del mismo Bco e Interbancarias de otros':
		//			a. Si la cuenta está marcada como 'Propias' se debe asegurar que el Banco Pago = Banco Destino
		//			a. Si la cuenta no está marcada como 'Propias' se debe asegurar que el Banco Pago <> Banco Destino
		//		5. Si el Tipo es 'Cualquier cuenta de cualquier Banco':
		//			a. Si la cuenta está marcada como 'Propias' se debe asegurar que el Banco Pago = Banco Destino
		function sbTESTPidRefresh(CBid,MPidx)
		{
			var cboTESTPid = document.getElementById("TESTPid");

		<cfif rsCtasDstTR.recordCount EQ "0">
			cboTESTPid.options.length = 1;
			cboTESTPid.selectedIndex = 0;
			cboTESTPid.options[0] = new Option("(Debe registrar una Cuenta Destino en #rsForm.Miso4217Pago#s)","", true);
		<cfelse>
			var LvarMPtipoCodigo	= LvarTiposCtas[CBid][MPidx].tc;
			var LvarMPtipoCtas		= LvarTiposCtas[CBid][MPidx].tcn;
			var LvarMPtipoMedio		= LvarTipoMedioPago[CBid][MPidx];

			var LvarBuenas		= 0;
			var LvarBuenasIdx	= 0;
			var LvarSeleccion	= false;
			var LvarDefaultIdx	= 0;
			var LvarAnterior	= cboTESTPid.options[cboTESTPid.selectedIndex].value;
			var LvarAnteriorIdx	= 0;

			cboTESTPid.options.length = #rsCtasDstTR.recordCount#;

			for (var i=1; i<=#rsCtasDstTR.recordCount#; i++)
			{
				// Solo se pueden escoger cuentas de la misma moneda
				var LvarMSG = "";
				var LvarTC = "";
				if (GvarCtasDstTRs[i].tc == 0)
				{
					if (GvarCtasDstTRs[i].prp == "1")
						LvarTC = "Cuenta Propia";
					else
						LvarTC = "Interbancaria";
				}
				else if (GvarCtasDstTRs[i].tc == 1)
				{
					LvarTC = "ABA";
				}
				else if (GvarCtasDstTRs[i].tc == 2)
				{
					LvarTC = "SWIFT";
				}
				else if (GvarCtasDstTRs[i].tc == 3)
				{
					LvarTC = "IBAN";
				}
				else
				{
					LvarTC = "Especial";
				}

				if (GvarCtasDstTRs[i].cta,GvarCtasDstTRs[i].iso != "#rsForm.Miso4217Pago#")
				{
					LvarMSG = " (Otra Moneda)";
				}
				// TRM = 4: No tiene más restricciones
				else if (LvarMPtipoMedio != "4")
				{
					if (GvarCtasDstTRs[i].sts == 2)
					{
						LvarMSG = " (Cta.Borrada)";
						LvarTC  = "";
					}
					// el tipoCodigo de la Cuenta debe ser igual al tipoCodigo del Medio de Pago
					else if (LvarMPtipoCodigo != GvarCtasDstTRs[i].tc)
					{
						LvarMSG = " (Código " + LvarTC + ")";
						LvarTC  = "";
					}
					<!---
						0 = 'Cualquier cuenta de cualquier Banco'
						1 = 'Sólo Cuentas Propias del Mismo Banco de Pago'
						2 = 'Sólo Cuentas Interbancarias de otros Bancos'
						3 = 'Sólo Cuentas Interbancarias de cualquier Banco'
						4 = 'Ctas propias del mismo Bco e Interbancarias de otros'
					--->
					// si el tipoCodigo es Nacional
					else if (LvarMPtipoCodigo == 0)
					{
						// tipoCodigo es 'Nacional', el banco es obligatorio
						if (GvarCtasDstTRs[i].bid == "")
							LvarMSG = " (Falta Banco)";
						// tipoCta es 'Cualquier cuenta de cualquier Banco', verificar que cuando es Propia sea del mismo banco
						else if (LvarMPtipoCtas == 0)
						{
							if ( (GvarCtasDstTRs[i].prp == "1") && (GvarCtasDstTRs[i].bid != #rsForm.Bid#) )
								LvarMSG = " (Propia de Otro Bco)";
						}
						// tipoCta es 'Sólo Cuentas Propias del Mismo Banco de Pago', la cuenta debe ser Propia y del mismo Banco
						else if (LvarMPtipoCtas == 1)
						{
							if (GvarCtasDstTRs[i].bid != #rsForm.Bid#)
								LvarMSG = " (de Otro Banco)";
							else if (GvarCtasDstTRs[i].prp == "0")
								LvarMSG = " (no es cta Propia)";
						}
						// tipoCta es 'Sólo Cuentas Interbancarias de otros Bancos', la cuenta NO debe ser ni Propia ni del mismo Banco
						else if (LvarMPtipoCtas == 2)
						{
							if (GvarCtasDstTRs[i].bid == #rsForm.Bid#)
								LvarMSG = " (del Mismo Banco)";
							else if (GvarCtasDstTRs[i].prp == "1")
								LvarMSG = " (es cta Propia)";
						}
 						// tipoCta es 'Sólo Cuentas Interbancarias de cualquier Banco', la cuenta no debe ser Propia
						else if (LvarMPtipoCtas == 3)
						{
							if (GvarCtasDstTRs[i].prp == "1")
								LvarMSG = " (es cta Propia)";
						}
						// tipoCta es 'Cuentas Propias e Interbancarias de Otros Bancos', verificar que cuando es Propia sea del mismo banco y cuando no es propia no sea del mismo banco
						else if (LvarMPtipoCtas == 4)
						{
							if ( (GvarCtasDstTRs[i].prp == "1") && (GvarCtasDstTRs[i].bid != #rsForm.Bid#) )
								LvarMSG = " (Propia de Otro Bco)";
							else if ( (GvarCtasDstTRs[i].prp == "0") && (GvarCtasDstTRs[i].bid == #rsForm.Bid#) )
								LvarMSG = " (no es Propia)";
						}
					}
				}

				if (LvarMSG == "")
					LvarTC = " (" + LvarTC + ")";
				else
					LvarTC = "";

				cboTESTPid.options[i] =  new Option(GvarCtasDstTRs[i].cta + LvarMSG + LvarTC,GvarCtasDstTRs[i].id);
				if (LvarMSG == "")
				{
					LvarBuenas++;
					LvarBuenasIdx = i;
					cboTESTPid.options[i].disabled = false;
					if (GvarCtasDstTRs[i].id == LvarAnterior)
					{
						LvarAnteriorIdx = i;
						LvarSeleccion = true;
					}
					else if (GvarCtasDstTRs[i].sts == 1)
						LvarDefaultIdx = i;
				}
				else
				{
					cboTESTPid.options[i].disabled = true;
				}
			}
			if (LvarBuenas > 0)
				<cfif NOT GvarTEFbcos>
				cboTESTPid.options[0] = new Option("(#MSG_EscojaCtaDestino#)","", true);
				<cfelse>
				;
				</cfif>
			else
				cboTESTPid.options[0] = new Option("(#MSG_NoCtasParaMedioPag#)","", true);

			if (LvarSeleccion)
				cboTESTPid.selectedIndex = LvarAnteriorIdx;
			else if (LvarDefaultIdx == 0 && LvarBuenas == 1)
				cboTESTPid.selectedIndex = LvarBuenasIdx;
			else
				cboTESTPid.selectedIndex = LvarDefaultIdx;
		</cfif>
		}

		function sbTESMPcodigoChange(objTESMPcodigo)
		{
			<!--- VALIDACION PARA CAMPOS CIE --->
			if(objTESMPcodigo.value.length > 0 && objTESMPcodigo.value.trim().toUpperCase() === "CIE"){
				document.getElementById("trCIE").style.display = "";
			} else {
				document.getElementById("trCIE").style.display = "none";
			}

			var LvarCBid = document.getElementById("CBidPago").value.split(",")[0];
			document.getElementById("CK1").style.display = "none";
			document.getElementById("CK2").style.display = "none";
			document.getElementById("TR1").style.display = "none";
			document.getElementById("TR2").style.display = "none";
			document.getElementById("TRH").value = "";

			if (LvarCBid == "")
				return;

			var LvarMPtipoMedio		= LvarTipoMedioPago[LvarCBid][objTESMPcodigo.selectedIndex];
			var LvarMPtipoCodigo	= LvarTiposCtas[LvarCBid][objTESMPcodigo.selectedIndex].tc;
			var LvarMPtipoCtas		= LvarTiposCtas[LvarCBid][objTESMPcodigo.selectedIndex].tcn;

			if (LvarMPtipoMedio == "1")
			{
				document.getElementById("CK1").style.display = "";
				document.getElementById("CK2").style.display = "";
				document.getElementById("T_CTAS").value = "";
			}
			else if (LvarMPtipoMedio == "2" || LvarMPtipoMedio == "3" || LvarMPtipoMedio == "4")
			{
				if (LvarTipoMedioPago[LvarCBid][objTESMPcodigo.selectedIndex] == "4")
				{
					document.getElementById("TRH").value = "2";
				}
				else
				{
					document.getElementById("TRH").value = "1";
				}
				document.getElementById("TR1").style.display = "";
				document.getElementById("TR2").style.display = "";
				if (LvarMPtipoMedio == "4")
					document.getElementById("T_CTAS").value = "(#MSG_SoloCuentas# #MSG_en# #rsForm.Miso4217Pago#)";
				else if (LvarMPtipoCodigo == "0")
				{
					if (LvarMPtipoCtas == "0")
						document.getElementById("T_CTAS").value = "(#MSG_CualquierCuentaCualquierBanco# #rsForm.Miso4217Pago#)";
					else if (LvarMPtipoCtas == "1")
						document.getElementById("T_CTAS").value = "(#MSG_SoloCtasMismoBanco# #rsForm.Miso4217Pago#)";
					else if (LvarMPtipoCtas == "2")
						document.getElementById("T_CTAS").value = "(#MSG_SoloCtasInterbancariasOtrosBancos# #rsForm.Miso4217Pago#)";
					else if (LvarMPtipoCtas == "3")
						document.getElementById("T_CTAS").value = "(#MSG_SoloCtasInterbancariasCualquierBanco# #rsForm.Miso4217Pago#)";
					else if (LvarMPtipoCtas == "4")
						document.getElementById("T_CTAS").value = "(#MSG_CtasPropiasMismoBco# #rsForm.Miso4217Pago#)";
				}
				else if (LvarMPtipoCodigo == "1")
					document.getElementById("T_CTAS").value = "(#MSG_SoloCuentas#   ABA #MSG_en# #rsForm.Miso4217Pago#)";
				else if (LvarMPtipoCodigo == "2")
					document.getElementById("T_CTAS").value = "(#MSG_SoloCuentas#   SWIFT #MSG_en# #rsForm.Miso4217Pago#)";
				else if (LvarMPtipoCodigo == "3")
					document.getElementById("T_CTAS").value = "(#MSG_SoloCuentas#   IBAN #MSG_en# #rsForm.Miso4217Pago#)";
				else
					document.getElementById("T_CTAS").value = "(#MSG_SoloCuentas#   Especiales #MSG_en# #rsForm.Miso4217Pago#)";

				sbTESTPidRefresh(LvarCBid, objTESMPcodigo.selectedIndex);
			}
			//and Miso4217 = '#rsForm.Miso4217Pago#'
		}
	</script>
	<script>
		sbTESMPcodigoChange(document.getElementById("TESMPcodigo"));
		document.form1.TESOPbeneficiarioSuf.focus();
	</script>
</cfoutput>
</cffunction>


