<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 09 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Entrega de cheques
----------->

<cfset entrega = ''>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cfoutput>
	<form action="entregaCheques_sql.cfm" method="post" name="form1" id="form1"
		 onsubmit="return fnProcessRegistrar();"
	>
		<cfset LvarDatosChequesDet = true>
		<cfinclude template="datosCheques.cfm">
		<cfif isdefined('devolver')>
			<table width="85%" align="center"> 	
				<tr><td colspan="5">&nbsp;</td></tr>
				<tr>
					<td align="right" nowrap valign="top"><strong>Motivo Devolución:&nbsp;</strong></td>
					<td><textarea cols="60"  rows="4" name="TESCFBobservacion" tabindex="1"></textarea></td>
				</tr>
				<tr><td colspan="5">&nbsp;</td></tr>
				<tr>
					<td colspan="5" class="formButtons" align="center">
						<input name="devolver" type="hidden" value="#devolver#" tabindex="-1">
						<cfset session.Tesoreria.TESid = rsTesoreria.TESid>
						<input name="Devolver" 	type="submit" value="Registrar la Devolución" tabindex="1">
						<input name="Lista_Cheques" type="button" id="btnSelFac" value="Lista Cheques" tabindex="1"
							onClick="location.href='entregaChequesDevolver.cfm';">
					</td>
				</tr>
			</table>
			<cf_qforms form="form1" objForm="objForm">
			<script language="javascript">
				objForm.TESCFBobservacion.required = true;
				objForm.TESCFBobservacion.description = "Motivo de la Devolución";
			</script>
		<cfelseif DateFormat(rsForm.TESCFDfechaRetencion,"YYYYMMDD") GTE DateFormat(Now(),"YYYYMMDD")>
			<table width="85%" align="center"> 	
				<tr>
					<td align="center" style="color:##FF0000">
						El Cheque se encuentra Retenido hasta el #DateFormat(rsForm.TESCFDfechaRetencion,"DD/MM/YYYY")#
					</td>
				</tr>
				<tr><td colspan="5">&nbsp;</td></tr>
				<tr>
					<td align="center">
						<input name="Lista_Cheques" type="button" id="btnSelFac" value="Lista Cheques" tabindex="1"
							onClick="location.href='entregaCheques<cfif isdefined('custodia')>Custodia</cfif>.cfm';">
					</td>
				</tr>
			</table>
		<cfelse>
			<table width="85%" align="center"> 	
				<tr>
					<td colspan="4">
						<fieldset>
							<legend><strong>Datos de Entrega</strong></legend>
							<table align="center" width="50%">
								<cfif DateFormat(rsForm.TESOPfechaPago,"YYYYMMDD") GT DateFormat(Now(),"YYYYMMDD")>
								<tr>
									<td nowrap><strong>Fecha Pago:</strong></td>
									<td colspan="3" style="color:##FF0000">
										El Cheque debe entregarse hasta el #DateFormat(rsForm.TESOPfechaPago,"DD/MM/YYYY")#
									</td>
								</tr>
								</cfif>
								<tr>
									<td nowrap><strong>Entregado a:</strong></td>
									<td><input name="TESCFDentregadoId" type="text" value="" size="15" tabindex="1"></td>
									<td><input name="TESCFDentregado" type="text" value="" size="50" tabindex="1"></td>
								</tr>
								<tr>
									<td align="right" nowrap><strong>Fecha de Entrega:</strong></td>
									<td><cf_sifcalendario name="fechaEntrega" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"
										onChange="funcfechaEnt(this);" tabindex="1"></td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
				<tr><td colspan="5">&nbsp;</td></tr>
				<tr>
					<td colspan="5" class="formButtons" align="center">
					<cfif isdefined('custodia')>
						<input name="custodia" type="hidden" value="#custodia#" tabindex="-1">
					</cfif>
					<cfif rsTesoreria.recordCount GT 0>
						<cfset session.Tesoreria.TESid = rsTesoreria.TESid>
						<input name="Entrega" 	type="submit" value="Registrar Entrega" 
							<cfif DateFormat(rsForm.TESCFDfechaRetencion,"YYYYMMDD") GTE DateFormat(Now(),"YYYYMMDD")>
								disabled
							</cfif> 
							tabindex="1">
					</cfif>
					<input name="Lista_Cheques" type="button" id="btnSelFac" value="Lista Cheques" tabindex="1"
						onClick="location.href='entregaCheques<cfif isdefined('custodia')>Custodia</cfif>.cfm';">
					</td>
				</tr>
			</table>
			<cf_qforms form="form1" objForm="objForm">
			<script language="javascript">
				objForm.fechaEntrega.required = true;
				objForm.fechaEntrega.description = "Fecha de Entrega";
				objForm.TESCFDentregadoId.required = true;
				objForm.TESCFDentregadoId.description = "Identificación";
				objForm.TESCFDentregado.required = true;
				objForm.TESCFDentregado.description = "Nombre";
			
				function fnProcessRegistrar(){
					var now = new today();
					var Entrega = document.form1.fechaEntrega.value;
			
					if (toFecha(Entrega) > now){
						alert('La fecha de Entrega debe ser anterior o igual al día de hoy.');
						return false;
				<cfif DateFormat(rsForm.TESOPfechaPago,"YYYYMMDD") GT DateFormat(Now(),"YYYYMMDD")>
					}else if (confirm('El Cheque debe entregarse hasta el #DateFormat(rsForm.TESOPfechaPago,"DD/MM/YYYY")#\n\n¿Desea Registrar la ENTREGA del cheque ## #rsform.TESCFDnumFormulario#?')){
				<cfelse>
					}else if (confirm('¿Desea Registrar la ENTREGA del cheque ## #rsform.TESCFDnumFormulario#?')){
				</cfif>
						return true;
					}else
						return false;
				}
				
				function funcfechaEnt(fechaEnt){
					var now = new today();
			
					if (toFecha(fechaEnt.value) > now){
						alert('La fecha de Entrega debe ser anterior o igual al día de hoy.');
						return false;
					}
				}
			</script>
		</cfif>
		<cfinclude template="datosChequesDet.cfm">
	</form>
	</cfoutput>
	<cf_web_portlet_end>
<script language="javascript" type="text/javascript">
	<cfif isdefined('devolver')>
		document.form1.TESCFBobservacion.focus();
	<cfelseif DateFormat(rsForm.TESCFDfechaRetencion,"YYYYMMDD") GTE DateFormat(Now(),"YYYYMMDD")>
		document.form1.Lista_Cheques.focus();
	<cfelse>
		document.form1.TESCFDentregadoId.focus();
	</cfif>
</script>