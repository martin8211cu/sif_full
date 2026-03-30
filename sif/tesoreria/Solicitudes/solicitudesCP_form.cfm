<cfparam name="form.TESSPid" default="">

<cfif isdefined('form.TESSPid') and len(trim(form.TESSPid))>
	<cfset modo = 'CAMBIO'>
	<cfquery datasource="#session.dsn#" name="rsSQL">
		select count(1) as cantidad
		from TESdetallePagoCPC
		where TESSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
	</cfquery>
	<cfif rsSQL.cantidad EQ 0>
		<cfinvoke 	component="sif.tesoreria.Componentes.TESafectaciones"
					method="sbCalculaAfectacionesPago"
					TESSPid		= "#form.TESSPid#"
					updateSP	= "true"
		>
	</cfif>
<cfelse>
	<cf_errorCode	code = "50794" msg = "No se puede incluir una solicitud manualmente">
</cfif>

<cfset titulo = 'Preparación de una Solicitud de Pago de Documentos de CxP'>
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
		<tr><td><cfset sbPoneForm()></td></tr>
	</table>
<cfelse>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<cfset sbPoneForm()>
	<cf_web_portlet_end>
</cfif>

<cffunction name="sbPoneForm" output="true" returntype="void">
	<cfquery datasource="#session.dsn#" name="rsForm">
		SELECT sp.TESSPid,
		       sp.TESSPestado,
		       s.SNnombre,
		       sp.CFid,
		       sp.TESSPnumero,
		       sp.TESSPfechaSolicitud,
		       sp.TESSPfechaPagar,
		       sp.McodigoOri,
		       m.Mnombre,
			   m.Miso4217,
		       sp.TESSPtotalPagarOri,
		       sp.TESSPobservaciones,
		       sp.TESSPmsgRechazo,
		       sp.ts_rversion,
		       TESOPobservaciones,
		       TESOPinstruccion,
		       TESOPbeneficiarioSuf,
		  (SELECT COUNT(1)
		   FROM TESdetallePago
		   WHERE TESSPid = sp.TESSPid
		     AND CPCid IS NOT NULL) AS Multas,
		     CBidPago,
		     TESMPcodigoPago
		FROM TESsolicitudPago sp
		INNER JOIN Monedas m ON m.Ecodigo = sp.EcodigoOri
		AND m.Mcodigo = sp.McodigoOri
		INNER JOIN SNegocios s ON s.SNcodigo = sp.SNcodigoOri
		AND s.Ecodigo = sp.EcodigoOri
		WHERE TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
	</cfquery>

	<cfoutput>
		<script type="text/javascript">
		<!--
			function btnSelected(name, f) {
				if (f != null) {
					return (f.botonSel.value == name)
				} else {
					return (botonActual == name)
				}
			}

			function validar(formulario)	{
				if (btnSelected('Cambio',formulario)){
					var error_input;
					var error_msg = '';

					if (formulario.cboCFid.value == "") {
						error_msg += "\n - el Centro Funcional no puede quedar en blanco.";
						error_input = formulario.cboCFid;
					}
					if (formulario.TESSPfechaPagar.value == "") {
						error_msg += "\n - la Fecha de la Solicitud no puede quedar en blanco.";
						error_input = formulario.TESSPfechaPagar;
					}
					// Validacion terminada
					if (error_msg.length != "") {
						alert("Por favor revise los siguiente datos:"+error_msg);
						error_input.focus();
						return false;
					}
				}
				if (btnSelected('Lista_Solicitudes',formulario)){
					formulario.PASO.value='0';
					formulario.TESSPid.value='';
					formulario.action='solicitudesCP.cfm';
				}

				return fnVerificarDet();
			}
		//-->

		</script>

		<form action="solicitudesCP_sql.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
			<input type="hidden" name="TESSPid" value="#form.TESSPid#">
			<table align="center" border="0" summary="Tabla de entrada">
				<tr>
					<td valign="top" align="right">
						<strong>Núm. Solicitud:&nbsp;</strong>
					</td>
					<td valign="top">
						<strong>#LSNumberFormat(rsForm.TESSPnumero)#</strong>
						<input type="hidden" name="TESSPnumero" value="#rsForm.TESSPnumero#">
					</td>
					<td valign="top" align="right">
						<strong>Fecha Solicitud:&nbsp;</strong>
					</td>
					<td valign="top">
						<strong>#LSDateFormat(rsForm.TESSPfechaSolicitud,"DD/MM/YYYY")#</strong>
					</td>
				</tr>

				<tr><td>&nbsp;</td></tr>

				<tr>
					<td align="right">
						<strong>Centro&nbsp;Funcional:&nbsp;</strong>
					</td>
					<td colspan="3">
					  <cfif modo neq 'ALTA'>
						<cf_cboCFid query="#rsForm#" cambiarSP="yes" tabindex="1">
					  <cfelse>
						<cf_cboCFid tabindex="1">
					  </cfif>
					</td>
				</tr>

				<tr>
					<td valign="top" nowrap align="right">
						<strong>Socio Negocio:&nbsp;</strong>
					</td>
					<td valign="top" colspan="3" nowrap="nowrap">
						<table>
							<tr>
								<td valign="top">
									<strong>#rsForm.SNnombre#</strong>
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
				<tr>
					<td valign="top" align="right"><strong><cf_translate key=LB_CuentaPago>Cuenta de Pago</cf_translate>:</strong></td>
					<td colspan="3">
						<cfset session.tesoreria.CBidPago = -1>
						<cfset LvarCBidPago = "">
						<cf_cboTESCBid name="CBidPago" value="#rsForm.CBidPago#" Ccompuesto="yes" Dcompuesto="yes" none="yes"
						cboTESMPcodigo="TESMPcodigo" onchange="return fnCambioCBidPago(this.form);GvarCambiado=true;" tabindex="1"
						CBid = "#LvarCBidPago#">
						<input type="hidden" name="McodigoOri" value="#rsForm.McodigoOri#" tabindex="-1">
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td valign="top" align="right"><strong><cf_translate key=LB_MedioPago>Medio de Pago</cf_translate>:</strong></td>
					<td colspan="3" nowrap>
						<cfset session.tesoreria.TESMPcodigo = "">
						<div id="medioPago">
							<cf_cboTESMPcodigo name="TESMPcodigo" value="#rsForm.TESMPcodigoPago#" CBid="CBidPago" CBidValue="" onChange="GvarCambiado=true; sbTESMPcodigoChange(this);">
						</div>
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<cfif MODO NEQ "ALTA">
					<cf_cboFormaPago TESOPFPtipoId="5" TESOPFPid="#rsForm.TESSPid#">
					</cfif>
				</tr>

				<tr>
					<td valign="top" align="right">
						<strong>Moneda:&nbsp;</strong>
					</td>
					<td valign="top">
						<input type="text"
							disabled="yes"
							value="<cfif  modo NEQ 'ALTA'>#rsForm.Mnombre#</cfif>"
							style="text-align:left; border:solid 1px ##CCCCCC;"
							tabindex="-1"
						>
					</td>

					<td rowspan="3" valign="top" align="right" nowrap>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<strong>Observaciones para OP:</strong>
					</td>
					<td rowspan="3" valign="top" valign="top">
						<textarea name="TESOPobservaciones" cols="50" rows="4" tabindex="1" id="TESOPobservaciones"><cfif modo NEQ 'ALTA'>#trim(rsForm.TESOPobservaciones)#</cfif></textarea>
					</td>
				</tr>

				<tr>
					<td valign="top" align="right">
					<!--- Moneda Local --->
					<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
						select Mcodigo
						from Empresas
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					</cfquery>
					<cfif rsMonedaLocal.Mcodigo EQ rsForm.McodigoOri>
						<strong>Tipo de Cambio:&nbsp;</strong>
						<cfset LvarTC = 1>
					<cfelse>
						<strong>Tipo Cambio Histórico:&nbsp;</strong>
						<cfquery name="TCsug" datasource="#Session.DSN#">
							select tc.Hfecha, tc.TCcompra, tc.TCventa
							from Htipocambio tc
							where tc.Ecodigo = #Session.Ecodigo#
							   and tc.Mcodigo = #rsForm.McodigoOri#
							   and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
							   and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
						</cfquery>
						<cfset LvarTC = TCsug.TCcompra>
					</cfif>
					</td>
					<td valign="top">
						<input type="text"
							value="<cfif  modo NEQ 'ALTA'>#NumberFormat(LvarTC,",0.0000")#</cfif>"
							disabled="yes"
							style="text-align:left; border:solid 1px ##CCCCCC;"
							tabindex="-1"
						>
					</td>
				</tr>

				<tr>
					<td valign="top" align="right" nowrap><strong>Total Pago Solicitado:&nbsp;</strong></td>
					<td valign="top">
						<input type="text"
							readonly="yes"
							value="<cfif  modo NEQ 'ALTA'>#numberFormat(rsForm.TESSPtotalPagarOri,",0.00")#<cfelse>0.00</cfif>"
							style="text-align:right; border:solid 1px ##CCCCCC;"
							tabindex="-1"
						>
					</td>
				</tr>

				<tr>
					<td valign="top" nowrap align="right">
						<strong>Fecha Pago Solicitado:&nbsp;</strong>
					</td>
					<td valign="top">
						<cfset fechaSol = LSDateFormat(Now(),'dd/mm/yyyy') >
						<cfif modo NEQ 'ALTA'>
							<cfset fechaSol = LSDateFormat(rsForm.TESSPfechaPagar,'dd/mm/yyyy') >
						</cfif>
						<cf_sifcalendario form="form1" value="#fechaSol#" name="TESSPfechaPagar" tabindex="1">
					</td>

					<td valign="top" nowrap align="right">
						<strong>Instrucción al Banco:&nbsp;</strong>
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

 				<tr height="50">
					<td valign="top" align="right">
					<cfif isdefined("form.chkCancelados")>
						<strong>Motivo Cancelacion:</strong>
					<cfelse>
						<strong>Motivo Rechazo Anterior:</strong>
					</cfif>
					</td>
					<td valign="top" colspan="3"><font style="color:##FF0000; font-weight:bold;">#rsForm.TESSPmsgRechazo#</font></td>
				</tr>
				<tr>
					<td colspan="4" class="formButtons" align="center">
					<input type="hidden" name="botonSel" value="">
					<cfif NOT isdefined("form.chkCancelados")>
						<input name="PASO" 		type="hidden" value="10">
						<cfset LvarExclude = "Nuevo">
						<cfset LvarIncludeValues= "Seleccionar Documentos de CxP, Crédito">
						<cfset LvarInclude		= "btnSel,Credito">
					<cfelse>
						<input name="PASO" type="hidden" value="0">
						<cfset LvarExclude = "Cambio,Baja,Nuevo">
					</cfif>
					</td>
				</tr>

				<tr>
					<td colspan="4" class="formButtons" align="center">
						<cfinclude template="TESbtn_Aprobar.cfm">
						<script language="javascript">
							function funcBaja ()
							{
								return confirm('¿Desea ELIMINAR la Solicitud de Pago ## #rsform.TESSPnumero#?');
							}
							function funcbtnSel ()
							{
								location.href='solicitudesCP.cfm?PASO=3&TESSPid=#Form.TESSPid#&Mcodigo=#rsForm.McodigoOri#';
								return false;
							}
							var popUpWin;
							function funcCredito ()
							{
								  if(popUpWin)
								  {
									if(!popUpWin.closed) popUpWin.close();
								  }
								popUpWin = window.open ('solicitudesCP_sql.cfm?creditos=#form.TESSPid#', 'credito', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width=750,height=200,left=350, top=350,screenX=400,screenY=400');
								window.onfocus = function() {
										popUpWin.close();
										popUpWin = null;
									  };
								return false;
							}
						</script>
					</td>
				</tr>
				<tr>
					<td colspan="4">&nbsp;

					</td>
				</tr>
				<tr>
					<td colspan="4" class="formButtons">
						<cfinclude template="solicitudesCP_formDet.cfm">
					</td>
				</tr>
				<tr>
					<td colspan="4" class="formButtons">
						<cfinclude template="solicitudesCP_Cesion.cfm">
					</td>
				</tr>
			</table>
			<cfif modo NEQ 'ALTA'>
				<cfset ts = "">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
					artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#">
			</cfif>
		</form>
	</cfoutput>
</cffunction>
<script language="javascript" type="text/javascript">
	document.form1.TESSPfechaPagar.focus();

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
</script>

