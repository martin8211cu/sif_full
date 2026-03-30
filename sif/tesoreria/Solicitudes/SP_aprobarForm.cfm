<cfif isdefined('form.TESSPid') and len(trim(form.TESSPid))>
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cf_errorCode	code = "50794" msg = "No se puede incluir una solicitud manualmente">
</cfif>

<cfquery datasource="#session.dsn#" name="rsForm">
	Select sp.TESid,
		sp.TESSPtipoDocumento,
		case TESSPtipoDocumento
				when 0 		then 'Manual'
				when 1 		then 'CxP' 
				when 2 		then 'Antic.CxP' 
				when 3 		then 'Antic.CxC' 
				when 4 		then 'Antic.POS' 
				when 5 		then 'ManualCF' 
				when 6 		then 'Antic.GE' 
				when 7 		then 'Liqui.GE' 
				when 8		then 'Fondo.CCh' 
				when 9 		then 'Reint.CCh' 
				when 10		then 'TEF Bcos' 
				when 100 	then 'Interfaz' 
				else 'Otro'
		end as Origen,
		case TESSPtipoDocumento
				when 0 		then 'Solicitud de Pago Manual'
				when 5 		then 'Solicitud de Pago Manual por Centro Funcional' 
				when 1 		then 'Solicitud de Pago de Documento de CxP' 
				when 2 		then 'Solicitud de Pago de Anticipos a Proveedores de CxP' 
				when 3 		then 'Solicitud de Devolución de Anticipos a Clientes de CxC' 
				when 4 		then 'Solicitud de Devolución de Anticipos a Clientes de POS' 
				when 6 		then 'Solicitud de Pago de Anticipos a Empleados' 
				when 7 		then 'Solicitud de Pago de Liquidación a Gastos de Empleados' 
				when 8		then 'Solicitud de Pago para Fondos de Caja Chica' 
				when 9 		then 'Solicitud de Pago para Reintegro de Caja Chica' 
				when 10		then 'Solicitud de Transferencias entre Cuentas Bancarias' 
				when 100 	then 'Solicitud de Pago por Interfaz' 
				else 'Otro'
		end as Origen2,
		sp.TESSPid, sp.TESSPestado, 
		sp.SNcodigoOri, sp.TESBid,
		coalesce(s.SNnombre,s.SNnombrePago,TESBeneficiario,CDCnombre) as SNnombre, 
		sp.TESSPnumero, sp.TESSPfechaSolicitud, sp.TESSPfechaPagar,
		McodigoOri, m.Mnombre, sp.TESSPtotalPagarOri, TESSPtipoCambioOriManual,
		sp.TESSPmsgRechazo, sp.ts_rversion,
		E.Edescripcion, 
		sp.CFid, cf.CFcodigo, cf.CFdescripcion,
		t.TESdescripcion, adm.Edescripcion as ADMdescripcion

		,TESOPobservaciones
		,TESOPinstruccion
		,TESOPbeneficiarioSuf

	from TESsolicitudPago sp
		inner join Empresas E
			 on E.Ecodigo = sp.EcodigoOri
		inner join Monedas m
			 on m.Ecodigo = sp.EcodigoOri
			and m.Mcodigo = sp.McodigoOri
		inner join Tesoreria t
			inner join Empresas adm
				on adm.Ecodigo = t.EcodigoAdm
		   on t.TESid = sp.TESid
		left join CFuncional cf
			 on cf.CFid	= sp.CFid
		left join SNegocios s
			 on s.Ecodigo 	= sp.EcodigoOri
			and s.SNcodigo 	= sp.SNcodigoOri
		left join TESbeneficiario tb
			 on tb.TESBid	= sp.TESBid
		left join ClientesDetallistasCorp cd
			 on cd.CDCcodigo	= sp.CDCcodigo
	where TESSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
		<cfif isdefined("LvarRechazoTesoreria")>
		and TESid = #session.Tesoreria.TESid#
		<cfelse>
		and EcodigoOri = #session.Ecodigo#
		</cfif>
</cfquery>

<cfoutput>
	<form action="solicitudesAprobar_sql.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
		<input type="hidden" name="TESSPid" value="#form.TESSPid#">
		<table align="center" summary="Tabla de entrada" border="0">
			<tr>
				<td align="center" colspan="4" bgcolor="##CCCCCC"><strong>#rsForm.Origen2#</strong></td>
				
			</tr>

			<cfif isdefined("LvarRechazoTesoreria")>
			<tr>
				<td valign="top" align="right"><strong>Empresa Origen:</strong></td>
				<td valign="top" colspan="2">
					<strong>#rsForm.Edescripcion#</strong>
					<input name="TESid" type="hidden" value="#session.Tesoreria.TESid#">
				</td>
			</tr>
			</cfif>

			<tr>
				<td valign="top" align="right">
					<strong>Núm. Solicitud:&nbsp;</strong>
				</td>
				<td valign="top">						
					<strong>#rsForm.Origen# #LSNumberFormat(rsForm.TESSPnumero)#</strong>
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
					<strong>#rsForm.CFcodigo# - #rsForm.CFdescripcion#
				</td>
			</tr>									

			<tr>
				<td valign="top" nowrap align="right">
					<cfif rsForm.SNcodigoOri NEQ "">
						<strong>Socio de Negocio:&nbsp;</strong>
					<cfelseif rsForm.TESBid NEQ "">
						<strong>Beneficiario:&nbsp;</strong>
					<cfelse>
						<strong>Cliente Detallista:&nbsp;</strong>
					</cfif>
				</td>
				<td valign="top" colspan="3">
					<strong>#rsForm.SNnombre# #rsForm.TESOPbeneficiarioSuf#</strong>
				</td>
			</tr>						

			<tr>
				<td valign="top" align="right">
					<strong>Moneda:&nbsp;</strong>
				</td>
				<td valign="top">
					<input type="text"
						disabled="yes"
						value="#rsForm.Mnombre#"
						style="text-align:left; border:solid 1px ##CCCCCC;"
						tabindex="-1"
					>
					
				</td>

				<td rowspan="3" valign="top" align="right" nowrap>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<strong>Observaciones para OP:</strong>
				</td>
				<td rowspan="3" valign="top" valign="top">
					<textarea name="TESOPobservaciones" cols="50" rows="4" tabindex="1" id="TESOPobservaciones"
							onkeypress="return false;">><cfif modo NEQ 'ALTA'>#trim(rsForm.TESOPobservaciones)#</cfif></textarea>
				</td>
			</tr>

			<tr>
				<td valign="top" align="right">
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select Mcodigo
					  from Empresas
					 where Ecodigo = #Session.Ecodigo#
				</cfquery>
				<cfif rsSQL.Mcodigo EQ rsForm.McodigoOri>
					<cfset LvarTClabel = "Tipo Cambio">
					<cfset LvarTC = 1>
				<cfelseif isdefined("rsForm.TESSPtipoDocumento") AND listFind("0,5",rsForm.TESSPtipoDocumento) AND isdefined("rsForm.TESSPtipoCambioOriManual") AND isnumeric(rsForm.TESSPtipoCambioOriManual)>
					<cfset LvarTClabel = "Tipo Cambio">
					<cfset LvarTC = rsForm.TESSPtipoCambioOriManual>
				<cfelse>
					<cfset LvarTClabel = "Tipo Cambio Histórico">
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
				<strong>#LvarTClabel#:&nbsp;</strong>
				</td>
				<td valign="top">
					<input type="text"
						value="#NumberFormat(LvarTC,",0.0000")#"
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



			<tr>
				<td valign="top" align="right">
				</td>
			<tr>
				<td valign="top" align="right"><strong>Total Pago Solicitado:</strong></td>
				<td valign="top">
					<strong>#numberFormat(rsForm.TESSPtotalPagarOri,",0.00")# #rsForm.Mnombre#</strong>
				</td>
				<cfif rsForm.TESSPtipoDocumento EQ 0 OR rsForm.TESSPtipoDocumento EQ 5>
				<td valign="top" align="right"><strong>Tipo Cambio:</strong></td>
				<td valign="top">
					<strong>#numberFormat(rsForm.TESSPtipoCambioOriManual,",0.00")# #rsForm.Mnombre#</strong>
				</td>
				</cfif>
			</tr>						
			<tr>
				<td valign="top" align="right"><strong>Fecha Pago Solicitado:</strong></td>
				<td valign="top">
					<cfset fechaSol = LSDateFormat(Now(),'dd/mm/yyyy') >
					<cfif modo NEQ 'ALTA'>
						<cfset fechaSol = LSDateFormat(rsForm.TESSPfechaPagar,'dd/mm/yyyy') >
					</cfif>
					<cf_sifcalendario form="form1" value="#fechaSol#" name="TESSPfechaPagar" tabindex="1">
				</td>
			</tr>						

			<tr>
				<td valign="top" align="right"><strong>Pagar en Tesorería:</strong></td>
				<td valign="top" colspan="3">
					<select name="cboCambioTESid" id="cboCambioTESid" onchange="if (this.value != '') return ">
						<option value="">#rsForm.TESdescripcion# (Adm: #rsForm.ADMdescripcion#)</option>
					</select>
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
				<td valign="top" colspan="3">
					<font style="color:##FF0000; font-weight:bold;">#rsForm.TESSPmsgRechazo#</font>
					<input type="hidden" name="TESSPmsgRechazo" value="">
				</td>
			</tr>						

			<tr>
				<td colspan="4" class="formButtons" align="center">
					<cfset LvarAprobar = true>
					<cfset LvarExclude = "Cambio,Baja,Nuevo">
					<cfinclude template="TESbtn_Aprobar.cfm">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
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


