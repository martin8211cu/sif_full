<cfparam name="LvarDatosChequesDet" default="no">
<cfparam name="form.TESSPid" default="">
<cfquery name="rsTesoreria" datasource="#session.dsn#">
	Select t.TESid
	  from TESempresas te, Tesoreria t
	 where te.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	   and t.EcodigoAdm	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	   and t.TESid 		= te.TESid
</cfquery>


<cfinclude template="../../../Utiles/sifConcat.cfm">
<cfquery datasource="#session.dsn#" name="rsForm">
	 select e.Edescripcion #_Cat# ' - ' #_Cat# m.Miso4217 #_Cat# ' - ' #_Cat# b.Bdescripcion #_Cat# ' - ' #_Cat# cb.CBcodigo as ctaPago,
	 		cf.TESCFLid, cf.CBid, cf.TESCFDnumFormulario,cf.TESCFDestado, 
	 		cf.TESCFDentregadoId #_Cat# ' : ' #_Cat# cf.TESCFDentregado as Entregado,
			cf.TESCFDentregadoFecha, cf.TESCFDfechaRetencion, cf.TESCFDfechaEntrega, 
			
			cf.TESCFDmsgAnulacion,cf.TESMPcodigo,
			
			op.TESOPbeneficiarioId #_Cat# ' : ' #_Cat# op.TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(op.TESOPbeneficiarioSuf,'') as beneficiario,op.CBidPago,
			op.TESOPnumero, op.TESOPtotalPago, 
			op.TESOPfechaPago, cf.TESCFDfechaGeneracion, cf.TESCFDfechaEmision, 
			op.TESOPfechaGeneracion, op.TESOPfechaEmision,
			op.TESOPobservaciones,
			e.Edescripcion, b.Bdescripcion as bcoPago, m.Mnombre as monPago, m.Miso4217,
			cb.CBcodigo, mp.TESMPdescripcion, mp.FMT01COD,
			case TESCFDestado
				when 0 then 'Cheque En preparacion'
				when 1 then 
					case when TESOPestado = 110
						then 'Cheque Impreso sin Contabilizar'
						else 'Cheque Impreso'
					end
				when 2 then 'Cheque Entregado'
				when 3 then 
					case when TESCFLidReimpresion is null 
						then 'Cheque Anulado'
						else 'Cheque Anulado y Reimpreso'
					end
			end as Estado
		,	case TESOPestado
				when 10  then 'Preparacion'
				when 101 then 'En Aprobación'
				when 11  then 'En Emisión'
                when 110  then 'Sin Aplicar'
				when 12  then 'Aplicada'
				when 13  then 'Anulado'
			end as EstadoOP
		,	cf.TESOPid
		,	TESOPestado
		,	cf.TESCFLidReimpresion
		,	case when TESCFDestado = 3 then
				(
					select TESCFDnumFormulario 
					  from TEScontrolFormulariosD r 
					 where r.TESid = cf.TESid
					   and r.TESCFLid = cf.TESCFLidReimpresion
					   and r.TESOPid = cf.TESOPid
				)
			end as ChkReimpreso
		,	cc.Cformato
		,	cf.TESCFDfechaAnulacion

		,	{fn concat({fn concat({fn concat({fn concat(dpGen.Pnombre , ' ' )}, dpGen.Papellido1 )}, ' ' )}, dpGen.Papellido2 )} as UsuarioGen
		,	{fn concat({fn concat({fn concat({fn concat(dpEmi.Pnombre , ' ' )}, dpEmi.Papellido1 )}, ' ' )}, dpEmi.Papellido2 )} as UsuarioEmi
		,	{fn concat({fn concat({fn concat({fn concat(dpEnt.Pnombre , ' ' )}, dpEnt.Papellido1 )}, ' ' )}, dpEnt.Papellido2 )} as UsuarioEnt
		,	{fn concat({fn concat({fn concat({fn concat(dpAnu.Pnombre , ' ' )}, dpAnu.Papellido1 )}, ' ' )}, dpAnu.Papellido2 )} as UsuarioAnu
	from TEScontrolFormulariosD cf 
	
	left join TEScuentasBancos tcb 
	  on cf.TESid = tcb.TESid and
		 cf.CBid = tcb.CBid
	left join CuentasBancos cb 
	  on tcb.CBid = cb.CBid
	left join Monedas m 
	  on m.Mcodigo = cb.Mcodigo and 
		 m.Ecodigo = cb.Ecodigo 
	left join Bancos b 
	  on b.Ecodigo = cb.Ecodigo and 
		 b.Bid = cb.Bid 
	left outer join TESordenPago op 
	  on cf.TESOPid = op.TESOPid 
	left join Empresas e 
	  on op.EcodigoPago = e.Ecodigo 
	left join CContables cc
	  on op.Ccuenta = cc.Ccuenta
	 
	left join TESmedioPago mp
	  on mp.TESid = cf.TESid and
		 mp.CBid = cf.CBid and 
		 mp.TESMPcodigo = cf.TESMPcodigo

	left join Usuario uGen
		inner join DatosPersonales dpGen
			on dpGen.datos_personales=uGen.datos_personales
		on uGen.Usucodigo = cf.BMUsucodigo

	left join Usuario uEmi
		inner join DatosPersonales dpEmi
			on dpEmi.datos_personales=uEmi.datos_personales
		on uEmi.Usucodigo = cf.UsucodigoEmision

	left join Usuario uEnt
		inner join DatosPersonales dpEnt
			on dpEnt.datos_personales=uEnt.datos_personales
		on uEnt.Usucodigo = cf.UsucodigoEntrega

	left join Usuario uAnu
		inner join DatosPersonales dpAnu
			on dpAnu.datos_personales=uAnu.datos_personales
		on uAnu.Usucodigo = cf.UsucodigoAnulacion

	where cf.TESCFDnumFormulario=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFDnumFormulario#">
      and coalesce(cb.CBesTCE,0) = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		
	  and cf.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
	  and cf.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
	  and cf.TESMPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TESMPcodigo#">
	  and TESCFDestado #tipoCheque#
</cfquery>


<cfoutput> 
	<script language="JavaScript" src="../../../js/fechas.js"></script> 
	<input type="hidden" name="TESCFDnumFormulario" value="#form.TESCFDnumFormulario#" tabindex="-1">
	<input type="hidden" name="TESMPcodigo" value="#form.TESMPcodigo#" tabindex="-1">
	<input type="hidden" name="CBid" value="#form.CBid#" tabindex="-1">
	<table border="0" width="50%" align="center" summary="Tabla de entrada">
		<tr>
			<td valign="top" align="right"><strong>Num. Cheque:</strong></td>
			<td colspan="4" nowrap>
				<strong>
					#rsform.TESCFDnumFormulario#
					&nbsp;&nbsp;&nbsp;
					<strong>Cuenta:&nbsp;</strong>#rsForm.ctaPago#
				</strong>
			</td>
			<td width="200px">&nbsp;</td>
		</tr>
		<tr>
			<td align="right" nowrap>
				<strong>Estado:</strong></td>
			<td nowrap><strong>#rsForm.Estado#</strong></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td valign="top" align="right" nowrap title="Fecha Pago = Fecha del Cheque impreso en el formulario">
				<strong>Fecha de Pago:</strong>
			</td>
			<td nowrap colspan="2">
				#LSDateFormat(rsForm.TESOPfechaPago,'dd/mm/yyyy')#
			</td>
		</tr>
		<tr>
			<td valign="top" align="right" nowrap><strong>Beneficiario:</strong></td>
			<td nowrap colspan="3">#rsForm.beneficiario#</td>
		</tr>
		<tr>
			<td valign="top" align="right" nowrap><strong>Monto:</strong></td>
			<td nowrap>#LSCurrencyFormat(rsForm.TESOPtotalPago,'none')# #rsForm.monPago# </td>
		</tr>
		<tr><td>&nbsp;</td></tr>


		<tr>
			<td valign="top" align="right" nowrap title="Fecha Generación = Fecha en que se genera el formulario en el sistema al iniciar la Impresión de un Lote de Cheques, o bien, la que se registre en Emisión Manual">
				<strong>Generado:</strong>
			</td>
			<td nowrap>
				#LSDateFormat(rsForm.TESCFDfechaGeneracion,'dd/mm/yyyy')# #LSTimeFormat(rsForm.TESCFDfechaGeneracion)#
			</td>
			<td valign="top" align="right" nowrap >
				<strong>Por:</strong>
			</td>
			<td nowrap>
				#rsForm.UsuarioGen#
			</td>
		</tr>

		<tr>
			<td valign="top" align="right" nowrap title="Fecha Emisión = Fecha en que se registra el Resultado de la Impresión del Lote y se contabiliza el Pago">
				<strong>Emitido:</strong>
			</td>
			<td nowrap>
				#LSDateFormat(rsForm.TESCFDfechaEmision,'dd/mm/yyyy')# #LSTimeFormat(rsForm.TESCFDfechaEmision)#
			</td>
			<td valign="top" align="right" nowrap>
				<strong>Por:</strong>
			</td>
			<td nowrap>
				#rsForm.UsuarioEmi#
			</td>
		</tr>

	<cfif trim(rsForm.TESOPobservaciones) NEQ "">
		<tr><td>&nbsp;</td></tr>

		<tr>
			<td valign="top" align="right" nowrap>
				<strong>Observaciones:</strong>
			</td>
			<td valign="top">
				<font color="##0000FF">
					<strong>#replace(rsForm.TESOPobservaciones,chr(10),"<BR>","ALL")#</strong>
				</font>
			</td>
		</tr>
	</cfif>
	
	<cfif isdefined('rsForm.TESCFDestado') and rsForm.TESCFDestado EQ 2>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="right">
				<strong>Entregado:</strong>
			</td>
			<td nowrap>
				<cfif rsForm.TESCFDentregadoFecha NEQ "">
					#LSDateFormat(rsForm.TESCFDentregadoFecha,'dd/mm/yyyy')#
				</cfif>
			</td>
			<td valign="top" align="right" nowrap>
				<strong>A:</strong>
			</td>
			<td nowrap>
				#rsForm.Entregado#
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Registrado:</strong>
			</td>
			<td nowrap>
				<cfif rsForm.TESCFDfechaEntrega NEQ "">
					#LSDateFormat(rsForm.TESCFDfechaEntrega,'dd/mm/yyyy')# #LSTimeFormat(rsForm.TESCFDfechaEntrega)#
				</cfif>
			</td>
			<td valign="top" align="right" nowrap>
				<strong>Por:</strong>
			</td>
			<td nowrap>
				#rsForm.UsuarioEnt#
			</td>
		</tr>
	<cfelseif isdefined('rsForm.TESCFDestado') and rsForm.TESCFDestado EQ 3>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td valign="top" align="right" nowrap>
				<strong>Anulado:</strong>
			</td>
			<td nowrap>
				<cfif rsForm.TESCFDfechaAnulacion NEQ "">
					#LSDateFormat(rsForm.TESCFDfechaAnulacion,'dd/mm/yyyy')# #LSTimeFormat(rsForm.TESCFDfechaAnulacion)#
				</cfif>
			</td>
			<td align="right"><strong>Por:</strong></td>
			<td nowrap>
				#rsForm.UsuarioAnu#
			</td>
		</tr>
		<tr>
			<td align="right" nowrap><strong>Motivo Anulación:</strong></td>
			<td nowrap colspan="3">
				<font color="##FF0000">
				<cfif rsForm.TESCFLidReimpresion NEQ "">
					CHEQUE REIMPRESO CON CK. <a href="consultaCheques.cfm?TESCFDnumFormulario=#rsForm.ChkReimpreso#&CBid=#form.CBid#&TESMPcodigo=#form.TESMPcodigo#" style="text-decoration:underline;">#rsForm.ChkReimpreso#</a>
				<cfelseif trim(rsForm.TESCFDmsgAnulacion) EQ "">
					No se indicó
				<cfelse>
					#rsForm.TESCFDmsgAnulacion#
				</cfif>
				</font>
			</td>
		</tr>
	<cfelseif LEN(rsForm.TESCFDfechaRetencion) GT 0>
		<tr>
			<td align="right"><strong>Retenido hasta:</strong></td>
			<td>
				<cfif rsForm.TESCFDfechaRetencion NEQ "">
					#LSDateFormat(rsForm.TESCFDfechaRetencion,'dd/mm/yyyy')#
				</cfif>
			</td>
		</tr>
	</cfif>

		<tr><td colspan="4">&nbsp;</td></tr>
	</table>
</cfoutput>
	
	<cfif not LvarDatosChequesDet>
		<cfset LvarDatosChequesDet = true>
		<cfinclude template="datosChequesDet.cfm">
	</cfif>
