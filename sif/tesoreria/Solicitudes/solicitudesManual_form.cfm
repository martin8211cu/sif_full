<!---
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 8-6-2005.
		Motivo: Se inclueye el tag "tesbeneficiarios".
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 8-7-2005.
		Motivo: Se modifica para que a la hora de agregar un Beneficiario nuevo en el colis se abra en un pop up la ventana de mantenimiento
		de beneficiarios y que al agregar se cierra la ventana y se regresan los datos del beneficiario al conlis inicial.
 --->
<cfinvoke key="MSG_ValidaCF" default="El Centro Funcional no puede quedar en blanco"	returnvariable="MSG_ValidaCF"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="MSG_ValidaIdentBeneficiario" default="La Identificación del Beneficiario no puede quedar en blanco, cuando no se indicó Socio de Negocios"	returnvariable="MSG_ValidaIdentBeneficiario"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="MSG_ValidaNomBeneficiario" default="El nombre del Beneficiario no puede quedar en blanco, cuando no se indicó Socio de Negocios"	returnvariable="MSG_ValidaNomBeneficiario"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="MSG_ValidaFecha" default="La Fecha a Pagar no puede quedar en blanco"	returnvariable="MSG_ValidaFecha"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="MSG_ValidaMoneda" default="La Moneda no puede quedar en blanco"	returnvariable="MSG_ValidaMoneda"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="MSG_ValidaMonto" default="El Monto Total a Pagar no puede quedar en blanco"	returnvariable="MSG_ValidaMonto"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>
<cfinvoke key="MSG_ReviseDatos" default="Por favor revise los siguiente datos"	returnvariable="MSG_ReviseDatos"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="solicitudesManual.xml"/>

 <cfif isdefined("LvarPorCFuncional")>
	<cfset LvarTipoDocumento = 5>
	<cfset LvarSufijoForm = "CF">
<cfelse>
	<cfset LvarTipoDocumento = 0>
	<cfset LvarSufijoForm = "">
</cfif>

<cfif isdefined("LvarFiltroPorUsuario") and #LvarFiltroPorUsuario#>
	<cfset LvarTipoDocumento = 5>
	<cfset LvarSufijoForm = "CFusuario">
</cfif>

<cfparam name="form.TESSPid" default="">

<cfif isdefined('form.TESSPid') and len(trim(form.TESSPid))>
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset modo = 'ALTA'>
</cfif>

<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="rsForm">
		Select
			a.TESSPid,
			a.TESSPfechaSolicitud,
			a.TESSPnumero,
			a.SNcodigoOri,
			a.TESSPfechaPagar,
			a.McodigoOri,
			a.TESBid, sn.SNid,
			a.TESSPtipoCambioOriManual,
			a.TESSPtotalPagarOri,
			a.TESSPmsgRechazo,
			case when a.CFid not in (select CFid from CFuncional where ecodigo = #session.ecodigo#)
				then (select CFid from CFuncional where ecodigo = 2 and lower(CFcodigo) = lower('RAIZ'))
				else a.CFid
			end  CFid,
			b.Ocodigo,
			a.BMUsucodigo,
			a.ts_rversion

			,TESOPobservaciones
			,TESOPinstruccion
			,TESOPbeneficiarioSuf
			,PagoTercero
			,(select count(1) from TESdetallePago where TESSPid = a.TESSPid)
			as Sufciencias
			,a.CBidPago
			,a.TESMPcodigoPago

		  from TESsolicitudPago a
				left outer join CFuncional b
					on b.CFid 		= a.CFid
					and b.Ecodigo 	= a.EcodigoOri
				left outer join SNegocios sn
					on sn.SNcodigo	= a.SNcodigoOri
					and sn.Ecodigo 	= a.EcodigoOri
		 where a.EcodigoOri			= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		   and a.TESSPid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
		   <cfif LvarTipoDocumento NEQ "" and LvarTipoDocumento NEQ 0>
		   and a.TESSPtipoDocumento	= #LvarTipoDocumento#
		   </cfif>
	</cfquery>

</cfif>

<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select <cf_dbfunction name="to_char" args="Mcodigo"> as Mcodigo
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfoutput>
	<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>

	<form action="solicitudesManual#LvarSufijoForm#_sql.cfm" onSubmit="return validar(this);" method="post" name="form1" id="form1" style="margin: 0;">
		<cfoutput>

			  <script type="text/javascript">
				<!--
					function funcLimpiaTESBid()
					{
						document.form1.SNcodigoOri.value = "";
						document.form1.SNnumero.value = "";
						document.form1.SNnombre.value = "";

					}

					function funcTESBid()

					{
						if ( confirm("¿Desea agregar un nuevo Beneficiario?"))
							{
								var popUpWinTESB=0;
								function popUpWindowTESBid(URLStr, left, top, width, height){
									if(popUpWinTESB) {
										if(!popUpWinTESB.closed) popUpWinTESB.close();
									}
									popUpWinTESB = open(URLStr, 'popUpWinTESB', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
									window.onfocus = closePopUpTESBid;
								}
								function closePopUpTESBid(){
									if(popUpWinTESB) {
										if(!popUpWinTESB.closed) popUpWinTESB.close();
										popUpWinTESB=null;
									}
								}
								function doMantenBeneficiario(LvarTESBeneficiarioId) {
											var params ="";
											var LLvarTESBeneficiarioId = LvarTESBeneficiarioId;
											params = "?formulario=form1&solicitudmanual=true";
											popUpWindowTESBid("/cfmx/sif/tesoreria/Parametros/Beneficiarios_form.cfm"+params+"&TESBeneficiarioIdPopUp="+LLvarTESBeneficiarioId,200,200,630,400);
								}

								doMantenBeneficiario(document.form1.TESBeneficiarioId.value);

							return false;
							}
						else {
							document.form1.TESBeneficiarioId.value="";
							document.form1.TESBid.value="";
							document.form1.TESBeneficiario.value="";
							document.form1.TESBeneficiario.disabled = true;
							return false;
							}
					}

					function funcSNnumero()
					{
						document.form1.TESBid.value = "";
						document.form1.TESBeneficiarioId.value = "";
						document.form1.TESBeneficiario.value = "";
					}


				//-->
			</script>

			<table align="center" summary="Tabla de entrada" border="0">
				<tr>
					<td valign="top" align="right">
						<strong><cf_translate key=LB_NumSolicitud>Núm. Solicitud</cf_translate>:&nbsp;</strong>
					</td>
					<td valign="top">
						<cfif modo NEQ 'ALTA'>
							<strong>#rsForm.TESSPnumero#</strong>
							<input type="hidden" name="TESSPnumero" value="#rsForm.TESSPnumero#">
						<cfelse>
							&nbsp;&nbsp; -- <cf_translate key=LB_NuevaSolicitudPago>Nueva Solicitud de Pago</cf_translate> --
						</cfif>
					</td>
					<td valign="top" align="right">
						<strong><cf_translate key=LB_FechaSolicitud>Fecha Solicitud</cf_translate>:&nbsp;</strong>
					</td>
					<td valign="top">
						<cfif modo NEQ 'ALTA'>
						<strong>#LSDateFormat(rsForm.TESSPfechaSolicitud,"DD/MM/YYYY")#</strong>
						<cfelse>
							&nbsp;&nbsp; <strong>#LSDateFormat(now(),"DD/MM/YYYY")#</strong>
						</cfif>
					</td>
				</tr>

				<tr><td>&nbsp;</td></tr>


				<tr>
					<td align="right">
						<strong><cf_translate key=LB_CentroFuncional>Centro&nbsp;Funcional</cf_translate>:&nbsp;</strong>
					</td>
					<td colspan="3">
					  <cfif modo neq 'ALTA'>
						<cf_cboCFid query="#rsForm#" cambiarSP="yes" tabindex="1" readonly="#LvarTipoDocumento EQ 0 AND rsForm.Sufciencias GT 0#">
					  <cfelse>
						<cf_cboCFid tabindex="1">
					  </cfif>
					</td>
				</tr>

			<cfset LvarModificable = (modo EQ 'ALTA' OR rsForm.TESSPtotalPagarOri EQ 0)>
			<cfif Modo NEQ "ALTA">
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select count(1) as cantidad
					  from TESOPformaPago f
					 where TESOPFPtipoId = 5
					   and TESOPFPid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
					   and coalesce(f.TESOPFPtipo,-1) >= 1
				</cfquery>
				<cfset LvarModificable = rsSQL.cantidad EQ 0>
			</cfif>

			<cfif LvarModificable>
				<tr>
					<td valign="top" nowrap align="right">
						<strong><cf_translate key=LB_SocioNegocio>Socio Negocio</cf_translate>:&nbsp;</strong>
					</td>
					<td valign="top" colspan="3" nowrap="nowrap">
									<cfif NOT LvarModificable>
										<cfif rsForm.SNcodigoOri EQ "">
											<input type="hidden" name="SNcodigoOri" value="">
										<cfelse>
											<input type="hidden" name="TESBid" value="">
										</cfif>
									</cfif>
									<cfif modo NEQ 'ALTA'>
										<cf_sifsociosnegocios2 CargaCtaOrigen="SI" form="form1" SNcodigo='SNcodigoOri' idquery="#rsForm.SNcodigoOri#" tabindex="1" modificable="#LvarModificable#">
									<cfelse>
										<cf_sifsociosnegocios2 CargaCtaOrigen="SI" form="form1" SNcodigo='SNcodigoOri'  tabindex="1">
									</cfif>
								</td>
				</tr>
				<tr>
					<td valign="top" align="right">
									<strong>&nbsp;<cf_translate key=LB_Beneficiario>Beneficiario</cf_translate>:&nbsp;</strong>
								</td>
								<td>
									<cfif modo NEQ 'ALTA'>
										<cf_tesbeneficiarios CargaCtaOrigen="SI" form="form1" tabindex="1" TESBidValue="#rsForm.TESBid#" TESBid="TESBid" modificable="#LvarModificable#">
									<cfelse>
										<cf_tesbeneficiarios CargaCtaOrigen="SI" form="form1" tabindex="1">
									</cfif>
								</td>
							</tr>
				<tr>
					<td valign="top" align="right">
					</td>
					<td></td>
					<td valign="top" nowrap align="right">
						<strong><cf_translate key=LB_SufijoNombreCK>Sufijo de Nombre en CK</cf_translate>:&nbsp;</strong>
					</td>
					<td colspan="2">
						<input type="text"
							name="TESOPbeneficiarioSuf"
							id="TESOPbeneficiarioSuf"
							onfocus="this.select();"
							tabindex="1"
							size="40"
							maxlength="255"
							value="<cfif  modo NEQ 'ALTA'>#rsForm.TESOPbeneficiarioSuf#</cfif>"
						>
					</td>
				</tr>
			<cfelseif rsForm.SNcodigoOri NEQ "">
				<tr>
					<td valign="top" nowrap align="right">
						<strong><cf_translate key=LB_SocioNegocio>Socio Negocio</cf_translate>:&nbsp;</strong>
					</td>
					<td valign="top" colspan="3">
						<table>
							<tr>
								<td>
									<cfif NOT LvarModificable>
										<input type="hidden" name="TESBid" value="">
									</cfif>
									<cfif modo NEQ 'ALTA'>
										<cf_sifsociosnegocios2 CargaCtaOrigen="SI" form="form1" SNcodigo='SNcodigoOri' idquery="#rsForm.SNcodigoOri#" tabindex="1" modificable="#LvarModificable#">
									<cfelse>
										<cf_sifsociosnegocios2 CargaCtaOrigen="SI" form="form1" SNcodigo='SNcodigoOri'  tabindex="1">
									</cfif>
								</td>
								<td>
									<input type="text"
										name="TESOPbeneficiarioSuf"
										id="TESOPbeneficiarioSuf"
										onfocus="this.select();"
										tabindex="1"
										size="40"
										maxlength="255"
										value="<cfif  modo NEQ 'ALTA'>#rsForm.TESOPbeneficiarioSuf#</cfif>"
									>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			<cfelse>
				<tr>
					<td valign="top" align="right"><strong><cf_translate key=LB_Beneficiario>Beneficiario</cf_translate>:&nbsp;</strong></td>
					<td valign="top" colspan="3">
						<table>
							<tr>
								<td>
									<cfif NOT LvarModificable>
										<input type="hidden" name="SNcodigoOri" value="">
									</cfif>
									<cfif modo NEQ 'ALTA'>
										<cf_tesbeneficiarios CargaCtaOrigen="SI" form="form1" tabindex="1" TESBidValue="#rsForm.TESBid#" TESBid="TESBid" modificable="#LvarModificable#">
									<cfelse>
										<cf_tesbeneficiarios CargaCtaOrigen="SI" form="form1" tabindex="1">
									</cfif>
								</td>
								<td>
									<input type="text"
										name="TESOPbeneficiarioSuf"
										id="TESOPbeneficiarioSuf"
										onfocus="this.select();"
										tabindex="1"
										size="40"
										maxlength="255"
										value="<cfif  modo NEQ 'ALTA'>#rsForm.TESOPbeneficiarioSuf#</cfif>"
									>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</cfif>

				<tr>
					<td valign="top" align="right"><strong><cf_translate key=LB_CuentaPago>Cuenta de Pago</cf_translate>:</strong></td>
					<td colspan="3">
						<div id="datosCtaOrigen" >
						<cfset session.tesoreria.CBidPago = -1>
						<cfset LvarCBidPago = "">
						<cfset l_CBidPago = "">
						<cfif modo NEQ 'ALTA'>
							<cfset l_CBidPago = #rsForm.CBidPago#>
						</cfif>
						<cf_cboTESCBid name="CBidPago" value="#l_CBidPago#" Ccompuesto="yes" Dcompuesto="yes" none="yes"
						cboTESMPcodigo="TESMPcodigo" onchange="return fnCambioCBidPago(this.form);GvarCambiado=true;" tabindex="1"
						CBid = "#LvarCBidPago#">
						</div>
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td valign="top" align="right"><strong><cf_translate key=LB_MedioPago>Medio de Pago</cf_translate>:</strong></td>
					<td colspan="3" nowrap>
						<cfset session.tesoreria.TESMPcodigo = "">
						<cfset l_TESMPcodigoPago = "">
						<cfif modo NEQ 'ALTA'>
							<cfset l_TESMPcodigoPago = #rsForm.TESMPcodigoPago#>
						</cfif>
						<div id="medioPago">
							<cf_cboTESMPcodigo name="TESMPcodigo" value="#l_TESMPcodigoPago#" CBid="CBidPago" CBidValue="" onChange="GvarCambiado=true; sbTESMPcodigoChange(this);">
						</div>
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td valign="top" align="right">
						<strong>&nbsp;<cf_translate key=LB_PagoTercero>Pago Tercero</cf_translate>:&nbsp;</strong>
					</td>
					<td><input type="checkbox" name="chkPT" id="chkPT" value="" <cfif  modo NEQ 'ALTA'><cfif  rsForm.PagoTercero EQ 1> checked </cfif><cfelse> checked </cfif> ></td>
				</tr>

			<cfif Modo NEQ "ALTA">
				<tr>
					<cf_cboFormaPago TESOPFPtipoId="5" TESOPFPid="#form.TESSPid#">
				</tr>
			</cfif>

				<tr>
					<td valign="top" align="right">
						<strong><cf_translate key=LB_Moneda>Moneda</cf_translate>:&nbsp;</strong>
					</td>
					<td valign="top">
						<cfif  modo NEQ 'ALTA'>
							<cfquery name="rsMoneda" datasource="#session.DSN#">
								select Mcodigo, Mnombre
								from Monedas
								where 1=1

								<cfif isdefined("rsForm.McodigoOri") and len(trim(rsForm.McodigoOri)) GT 0>
									and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.McodigoOri#">
								</cfif>
									and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							</cfquery>
							<cfset LvarMnombreSP = rsMoneda.Mnombre>
							<cfif rsForm.TESSPtotalPagarOri GT 0>
								<cf_sifmonedas onChange="asignaTC();" valueTC="#rsForm.TESSPtipoCambioOriManual#"
									form="form1" Mcodigo="McodigoOri" query="#rsMoneda#"
									FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="1" habilita="N">
							<cfelse>
								<cf_sifmonedas onChange="asignaTC();" valueTC="#rsForm.TESSPtipoCambioOriManual#"
									form="form1" Mcodigo="McodigoOri" query="#rsMoneda#"
									FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="1">
							</cfif>
						<cfelse>
							<cf_sifmonedas onChange="asignaTC();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"
								form="form1" Mcodigo="McodigoOri"  tabindex="1">
						</cfif>
					</td>

					<td rowspan="3" valign="top" align="right" nowrap>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<strong><cf_translate key=LB_Observaciones>Observaciones para OP</cf_translate>:</strong>
					</td>
					<td rowspan="3" valign="top">
						<textarea name="TESOPobservaciones" cols="50" rows="4" tabindex="1" id="TESOPobservaciones"><cfif modo NEQ 'ALTA'>#trim(rsForm.TESOPobservaciones)#</cfif></textarea>
					</td>
				</tr>
				<tr>
					<td valign="top" align="right"><strong><cf_translate key=LB_TipoCambio>Tipo de Cambio</cf_translate>:&nbsp;</strong></td>
					<td valign="top">
						<input name="TESSPtipoCambioOriManual"
							id="TESSPtipoCambioOriManual"
							maxlength="10"
							value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsForm.TESSPtipoCambioOriManual,",0.0000")#</cfif>"
							style="text-align:right;"
							onFocus="this.value=qf(this); this.select();"
							onBlur="javascript: fm(this,4);"
							onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
							tabindex="1"
						>
					</td>
				</tr>
				<tr>
					<td valign="top" align="right" nowrap><strong><cf_translate key=LB_TotalPagoSolicitado>Total Pago Solicitado</cf_translate>:&nbsp;</strong></td>
					<td valign="top">
						<input type="text"
							name="TESSPtotalPagarOri"
							id="TESSPtotalPagarOri5"
							readonly="yes"
							value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsForm.TESSPtotalPagarOri,",0.00")#<cfelse>0.00</cfif>"
							style="text-align:right; border:solid 1px ##CCCCCC;"
							tabindex="-1"
						>
					</td>
				</tr>

				<tr>
					<td valign="top" nowrap align="right">
						<strong><cf_translate key=LB_FechaPagoSolicitado>Fecha Pago Solicitado</cf_translate>:&nbsp;</strong>
					</td>
					<td valign="top">
						<cfset fechadoc = LSDateFormat(Now(),'dd/mm/yyyy')>
						<cfif modo NEQ 'ALTA'>
							<cfset fechadoc = LSDateFormat(rsForm.TESSPfechaPagar,'dd/mm/yyyy') >
						</cfif>
						<cf_sifcalendario form="form1" value="#fechadoc#" name="TESSPfechaPagar" tabindex="1">
					</td>

					<td valign="top" nowrap align="right">
						<strong><cf_translate key=LB_InstruccionBanco>Instrucción al Banco</cf_translate>:&nbsp;</strong>
					</td>
					<td>
						<input type="text"
							name="TESOPinstruccion"
							id="TESOPinstruccion"
							onfocus="this.select();"
							tabindex="1"
							size="50"
							maxlength="40"
							value="<cfif  modo NEQ 'ALTA'>#rsForm.TESOPinstruccion#</cfif>"
						>
					</td>
				</tr>
				<tr>
					<td valign="top" nowrap align="right">
						<cfif isdefined("form.chkCancelados")>
							<strong><cf_translate key=LB_MotivoCancelacion>Motivo Cancelacion</cf_translate>:&nbsp;</strong>
						<cfelse>
							<strong><cf_translate key=LB_MotivoRechazoAnterior>Motivo Rechazo Anterior</cf_translate>:&nbsp;</strong>
						</cfif>
					</td>
					<td colspan="3" valign="top">
						<font style="color:##FF0000; font-weight:bold;">
						<cfif modo NEQ "ALTA" and isdefined('rsForm')>
							#rsForm.TESSPmsgRechazo#
						</cfif>
						</font>
					</td>
				</tr>
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr>
					<td colspan="4" class="formButtons" align="center">
						<cfif modo NEQ 'ALTA'>
							<input type="hidden" name="TESSPid" value="#HTMLEditFormat(rsForm.TESSPid)#">
							<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(rsForm.BMUsucodigo)#">

							<cfset ts = "">
							<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
								artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
							</cfinvoke>
							<input type="hidden" name="ts_rversion" value="#ts#">
						</cfif>
						<cfinclude template="TESbtn_Aprobar.cfm">
					</td>
				</tr>
			</table>
		</cfoutput>
	</form>

	<cfoutput>
	<script type="text/javascript">
		function fnCambioCBidPago(f) {
			<!--- \sif\tesoreria\Solicitudes\ajaxTESMedioPago.cfm --->
			<!--- CBidPago --->
		    var ajaxRequest; // The variable that makes Ajax possible!
		    var vID_tipo_gasto = '';
		    var vmodoD = '';
			var CBidPago = f.CBidPago.value;
		    try {
		        // Opera 8.0+, Firefox, Safari
		        ajaxRequest = new XMLHttpRequest();
		    } catch (e) {
		        // Internet Explorer Browsers
		        try {
		            ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
		        } catch (e) {
		            try {
		                ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
		            } catch (e) {
		                // Something went wrong
		                alert("Your browser broke!");
		                return false;
		            }
		        }
		    }
		    ajaxRequest.open("GET", '/cfmx/sif/tesoreria/Solicitudes/ajaxTESMedioPago.cfm?modo=solPagoCxP&CBidPago='+CBidPago, false);
		    ajaxRequest.send(null);
		    document.getElementById("medioPago").innerHTML = ajaxRequest.responseText;
		}
	<!--
		function validar(formulario)	{
			if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1)){
				var error_input;
				var error_msg = '';

				if (formulario.cboCFid.value == "") {
					error_msg += "\n - #MSG_ValidaCF#.";
					error_input = formulario.cboCFid;
				}

				if (formulario.SNcodigoOri.value == "") {
					if(formulario.TESBeneficiarioId.value == ''){
						error_msg += "\n - #MSG_ValidaIdentBeneficiario#.";
						error_input = formulario.TESBeneficiarioId;
					}
					if(formulario.TESBeneficiario.value == ''){
						error_msg += "\n - #MSG_ValidaNomBeneficiario#.";
						error_input = formulario.TESBeneficiario;
					}
				}

				if (formulario.TESSPfechaPagar.value == "") {
					error_msg += "\n - #MSG_ValidaFecha#.";
					error_input = formulario.TESSPfechaPagar;
				}



				if (formulario.McodigoOri.value == "") {
					error_msg += "\n - #MSG_ValidaMoneda#.";
					error_input = formulario.McodigoOri;
				}

				if (formulario.TESSPtotalPagarOri.value == "") {
					error_msg += "\n - #MSG_ValidaMonto#.";
					error_input = formulario.TESSPtotalPagarOri;
				}

				// Validacion terminada
				if (error_msg.length != "") {
					alert("#MSG_ReviseDatos#:"+error_msg);

					return false;
				}

			}

			formulario.TESSPtipoCambioOriManual.value = qf(formulario.TESSPtipoCambioOriManual);
			formulario.TESSPtotalPagarOri.value = qf(formulario.TESSPtotalPagarOri);

			if(formulario.TESSPtipoCambioOriManual.disabled)
				formulario.TESSPtipoCambioOriManual.disabled = false;
			return true;
	}

	/* aquí asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
	function asignaTC() {
		if (document.form1.McodigoOri.value == "#rsMonedaLocal.Mcodigo#") {
			formatCurrency(document.form1.TC,2);
			document.form1.TESSPtipoCambioOriManual.disabled = true;
		}
		else
			document.form1.TESSPtipoCambioOriManual.disabled = false;
		var estado = document.form1.TESSPtipoCambioOriManual.disabled;
		document.form1.TESSPtipoCambioOriManual.disabled = false;
		document.form1.TESSPtipoCambioOriManual.value = fm(document.form1.TC.value,4);
		document.form1.TESSPtipoCambioOriManual.disabled = estado;
	}

	asignaTC();
	document.form1.cboCFid.focus();
	//-->
	</script>
</cfoutput>
</cfoutput>


<cfif isdefined('form.TESSPid') and len(trim(form.TESSPid))>
	<table width="100%"  border="0">
	  <tr>
		<td colspan="2"><hr></td>
	  </tr>
	  <tr>
		<td valign="top" width="50%">
			<cfset LvarIncluyeForm=true>
			<cfinclude template="solicitudesManualDet_lista.cfm">
		</td>
		<td valign="top" width="50%">
	<cfif NOT isdefined("form.chkCancelados") OR isdefined('form.TESDPid') and len(trim(form.TESDPid))>
			<cfinclude template="solicitudesManualDet_form.cfm">
	</cfif>
		</td>
	  </tr>
	</table>
</cfif>
