<cfoutput>
<cfset titulo = 'Detalle de la Orden de Pago'>
<cfquery datasource="#session.dsn#" name="lista">
	select
		dp.TESOPid,
		dp.TESSPid,
		dp.TESDPid,
		op.CBidPago,
		mp.Mnombre, mp.Miso4217 as Miso4217Pago, mep.Miso4217 as Miso4217EmpresaPago,
		sp.TESSPnumero,
		sp.TESSPfechaPagar,
		e.Edescripcion,
		dp.TESDPmoduloOri,
		dp.TESDPdocumentoOri, 
		dp.TESDPreferenciaOri,
		dp.Miso4217Ori,
		dp.TESDPmontoAprobadoOri,
		coalesce(op.TESOPtipoCambioPago, 0) as TESOPtipoCambioPago,
		coalesce(dp.TESDPtipoCambioOri, 0) as TESDPtipoCambioOri,
		coalesce(dp.TESDPfactorConversion, 0) as TESDPfactorConversion,
		coalesce(dp.TESDPmontoPago, 0) as TESDPmontoPago,
		dp.TESDPmontoPagoLocal,
		cf.CFformato 
	  ,	case sp.TESSPtipoDocumento
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
		end as TIPO
	from TESordenPago op
		left join TESdetallePago dp
			inner join TESsolicitudPago sp
			  on sp.TESid 	= dp.TESid
			 and sp.TESSPid = dp.TESSPid
			inner join Empresas e
			  on e.Ecodigo = dp.EcodigoOri
			inner join CFinanciera cf
				 on cf.Ecodigo  = dp.EcodigoOri
				and cf.CFcuenta = dp.CFcuentaDB
			inner join Monedas m
				 on m.Miso4217	= dp.Miso4217Ori
				and m.Ecodigo	= dp.EcodigoOri
		  on dp.TESid 	= op.TESid
		 and dp.TESOPid = op.TESOPid
		left join Empresas ep
			inner join Monedas mep
			   on mep.Mcodigo = ep.Mcodigo
			  and mep.Ecodigo = ep.Ecodigo
		  on ep.Ecodigo = op.EcodigoPago
		left join Monedas mp
		  on mp.Miso4217	= op.Miso4217Pago
		 and mp.Ecodigo		= op.EcodigoPago
	where <!--- op.TESid = #session.tesoreria.TESid# --->
    
	  op.TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.TESOPid#" null="#rsform.TESOPid EQ ""#">
</cfquery>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#" width="80%">
	<table align="center" border="0" cellspacing="0" cellpadding="0" width="100%">
<cfif isdefined("LvarEncabezadoOP")>
		<tr>
			<td colspan="2" align="left">&nbsp;&nbsp;&nbsp;<strong>Num.Orden:&nbsp;</strong></td>
			<td colspan="2">#rsForm.TESOPnumero#</td>
			<td align="right" title="Fecha OP = Fecha en que se generó la Orden de Pago"><strong>Fecha OP:&nbsp;</strong></td>
			<td>#LSDateFormat(rsform.TESOPfechaGeneracion,'dd/mm/yyyy')#</td>
			<td colspan="2" align="left">&nbsp;</td>
			<td align="right"><strong>Estado:&nbsp;</strong></td>
			<td align="left" nowrap=>#rsform.EstadoOP#</td>
		</tr>
		<tr>
			<td colspan="3" align="left">&nbsp;</td>
			<td colspan="2" align="right"><strong>Cuenta Crédito:&nbsp;</strong></td>
			<td colspan="3">#rsform.Cformato#</td>
			<td align="right" nowrap><strong>Total Pago #rsform.Miso4217#:&nbsp;</strong></td>
			<td>#LSCurrencyFormat(rsForm.TESOPtotalPago,'none')#</td>
		</tr>
		<tr style=" height:2px;">
			<td colspan="10" style="border-bottom:solid 1px ##A9A9A9; font-size:1px">&nbsp;</td>
		</tr>
</cfif>
		<tr>
			<td class="tituloListas">&nbsp;</td>
			<td class="tituloListas" align="left"><strong>Num. Solicitud</strong></td>
			<td class="tituloListas" align="center"><strong>Fecha&nbsp;Pago<BR>Solicitada</strong></td>
			<td class="tituloListas" align="left"><strong>Origen</strong></td>
			<td class="tituloListas" align="left"><strong>Documento&nbsp;</strong></td>
			<td class="tituloListas" align="left"><strong>Referencia</strong></td>
			<td class="tituloListas" align="right"><strong>Monto<BR>Documento</strong></td>
			<td class="tituloListas" align="center"><strong>Tipo&nbsp;Cambio<BR>Documento</strong></td>
			<td class="tituloListas" align="center"><strong>Factor<BR>Conversion</strong></td>
			<td class="tituloListas" align="right"><strong>Monto&nbsp;Pago<BR>#lista.Mnombre#<BR>(#lista.Miso4217Pago#)</strong></td>
		</tr>
		<cfset LvarTotalSP = 0>
		<cfset LvarLista = "ListaPar">
		<cfset LvarSolicitud = "">
		<cfloop query="lista">
			<cfset LvarTotalSP = LvarTotalSP + lista.TESDPmontoPago>
			<cfif LvarLista NEQ "ListaPar">
				<cfset LvarLista = "ListaPar">
			<cfelse>
				<cfset LvarLista = "ListaNon">
			</cfif>
	<cfif LvarSolicitud NEQ lista.TESSPid>
				<cfset LvarSolicitud = lista.TESSPid>
		<tr class="#LvarLista#">
			<td>&nbsp;</td>
			<td align="left" nowrap>
				#TESSPnumero#
			</td>
			<td align="left" nowrap>
				#LSDateFormat(lista.TESSPfechaPagar,"DD/MM/YYYY")#
			</td>
			<td align="center" nowrap>
				#lista.tipo#&nbsp;
			</td>
			<td align="left" nowrap colspan="7">
				<strong>Empresa del Documento:</strong> #lista.Edescripcion#
			</td>
				<cfif LvarLista NEQ "ListaPar">
					<cfset LvarLista = "ListaPar">
				<cfelse>
					<cfset LvarLista = "ListaNon">
				</cfif>
		</tr>
	</cfif>
		
		<tr class="#LvarLista#">
			<td colspan="3">&nbsp;</td>
			<td align="center" nowrap>
				#lista.TESDPmoduloOri#
			</td>
			<td align="left" nowrap>
				#lista.TESDPdocumentoOri#
			</td>
			<td align="left" nowrap>
				#lista.TESDPreferenciaOri#
			</td>
			<td align="right" nowrap>
				#NumberFormat(lista.TESDPmontoAprobadoOri,",0.00")#
				#lista.Miso4217Ori#&nbsp;&nbsp;
			</td>

		<cfif #lista.Miso4217EmpresaPago# EQ #lista.Miso4217Ori#>
			<td align="center">
				n/a
			</td>
		<cfelse>
			<td align="right" nowrap>
				#NumberFormat(lista.TESDPtipoCambioOri,",0.0000")#
				#lista.Miso4217EmpresaPago#s/#lista.Miso4217Ori#
			</td>
		</cfif>

		<cfif #lista.Miso4217Pago# EQ #lista.Miso4217Ori#>
			<td align="center">
				n/a
			</td>
		<cfelse>
			<td align="right" nowrap>
				#NumberFormat(lista.TESDPfactorConversion,",0.0000")#
				#lista.Miso4217Pago#s/#lista.Miso4217Ori#
			</td>
		</cfif>

			<td align="right" nowrap>
				#NumberFormat(lista.TESDPmontoPago,",0.00")#
			</td>
		</tr>
<cfif isdefined("LvarCuentaDbOP")>
		<tr class="#LvarLista#">
			<td colspan="5">&nbsp;</td>
			<td colspan="5">Cuenta Débito: #lista.CFformato#</td>
		</tr>
</cfif>
		</cfloop>
		<tr><td>&nbsp;</td></tr>
	</table>

	<cf_web_portlet_end>
</cfoutput>