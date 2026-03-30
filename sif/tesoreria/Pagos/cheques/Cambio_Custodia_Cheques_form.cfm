<!---
	Creado por: Gustavo Fonseca Hernández
	Fecha: 22 de junio del 2005
	Motivo: Nueva opción para Módulo de Tesorería, Cambio Custodia de Cheques.
--->
<!--- <cfdump var="#form#"> --->
<cfset entrega = ''>
<cfquery name="rsLugares" datasource="#session.DSN#">
	select TESid, TESCFLUid, TESCFLUdescripcion
	from TESCFlugares
		where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESid#">
</cfquery>
<cfquery name="rsEstados" datasource="#session.DSN#">
	select TESid, TESCFEid, TESCFEdescripcion, BMUsucodigo, ts_rversion, TESCFEimpreso, TESCFEentregado, TESCFEanulado
	from TESCFestados
	where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESid#">
		and TESCFEimpreso = 0 
		and TESCFEentregado = 0 
		and TESCFEanulado = 0
</cfquery>

<cfquery name="rsCustodiado" datasource="#session.DSN#">
	select EcodigoPago 
	from  TESordenPago
	where TESOPid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
</cfquery>

<cfoutput>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#" width="100%">
	<form action="Cambio_Custodia_Cheques_sql.cfm" method="post" name="form1" id="form1"
		  onsubmit="return fnProcessRegistrar();"
		  >
		<cfset LvarDatosChequesDet = true>
		<cfinclude template="datosCheques.cfm">
		<table width="85%" align="center"> 	
			<tr>
				<td colspan="4">
					<fieldset>
						<legend><strong>Cambio&nbsp;Custodia&nbsp;de&nbsp;Cheques</strong></legend>
						<table align="center" width="50%">
							<tr>
								<td align="right" nowrap><strong>Fecha&nbsp;Movimiento:&nbsp;</strong></td>
								<td><cf_sifcalendario name="fechaMovimiento" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1"></td>
							</tr>
							<tr>
								<td align="right" nowrap><strong>Custodiado&nbsp;en:&nbsp;</strong></td>
								<td>
									<select name="TESCFLUid" tabindex="1">
										<option value="">(Escoja un valor)</option>
										<cfloop query="rsLugares">
											<option value="#TESCFLUid#" <cfif isdefined('form.TESCFLUdescripcion') and len(trim(form.TESCFLUdescripcion)) and form.TESCFLUdescripcion EQ rsLugares.TESCFLUdescripcion>selected</cfif>>#rsLugares.TESCFLUdescripcion#</option>
										</cfloop>
									</select>
									
								</td>
							</tr>
							<tr>
								<td align="right" nowrap><strong>Razón;</strong></td>
								<td>
									<select name="TESCFEid" tabindex="1">
										<option value="">(Escoja un valor)</option>
										<cfloop query="rsEstados">
											<option value="#TESCFEid#" <cfif isdefined('form.TESCFEdescripcion') and len(trim(form.TESCFEdescripcion)) and form.TESCFEdescripcion EQ rsEstados.TESCFEdescripcion>selected</cfif>>#rsEstados.TESCFEdescripcion#</option>
										</cfloop>
									</select>
								</td>
							</tr>
							
							<tr>
								<td align="right" nowrap><strong>Custodiado&nbsp;por:&nbsp;</strong></td>
								<td><cf_sifusuario Ecodigo ="#session.Ecodigo#" tabindex="1"></td>
							</tr>
							<tr>
								<td align="right" nowrap valign="top"><strong>Observaciones:&nbsp;</strong></td>
								<td><textarea name="TESCFBobservacion" style="width:100% " tabindex="1"></textarea></td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
							<tr>
								<td colspan="3"  align="center">
									<cfif rsForm.TESCFDfechaRetencion GT Now()>
										<script>
											alert('El Cheque se encuentra RETENIDO.');
										</script>
									</cfif>
									<cfif rsTesoreria.recordCount GT 0>
										<cfset session.Tesoreria.TESid = rsTesoreria.TESid>
										<input name="Cambio" type="submit" value="Registrar Cambio Custodia" tabindex="1"
											<cfif rsForm.TESCFDfechaRetencion GT Now()>disabled</cfif>
										>
									</cfif>
									<input name="Lista_Cheques" type="button" id="btnSelFac" value="Lista Cheques" tabindex="1"
										onClick="location.href='Cambio_Custodia_Cheques.cfm';"
									>
								</td>
							</tr>
							<tr><td colspan="2">&nbsp;</td></tr>
						</table>
					</fieldset>
				</td>
			</tr>
		</table>
	</form>
	<cfinclude template="datosChequesDet.cfm">
	<cf_web_portlet_end>
</cfoutput>

<cf_qforms form="form1" objForm="objForm">
<script language="javascript">
	objForm.fechaMovimiento.required = true;
	objForm.fechaMovimiento.description = "Fecha Movimiento";
	objForm.TESCFLUid.required = true;
	objForm.TESCFLUid.description = "Custodiado en";
	objForm.TESCFEid.required = true;
	objForm.TESCFEid.description = "Razón";
	objForm.Usulogin.required = true;
	objForm.Usulogin.description = "Custodiado por";
	objForm.TESCFBobservacion.required = true;
	objForm.TESCFBobservacion.description = "Observaciones";

	function fnProcessRegistrar()
	{
		var now = new Date();
		var Entrega = document.form1.fechaMovimiento.value;

		if (toFecha(Entrega) > now)
		{
			alert('La fecha del Movimiento debe ser anterior o igual al día de hoy.');
			return false;
		}
		else if (confirm('¿Registrar la nueva CUSTODIA del cheque # <cfoutput>#rsform.TESCFDnumFormulario#</cfoutput>?'))
		{
			return true;
		}
		else
			return false;
	}
	
	function funcLimpiar()
	{
		document.form1.reset();
	}
	document.form1.fechaMovimiento.focus();
</script>
