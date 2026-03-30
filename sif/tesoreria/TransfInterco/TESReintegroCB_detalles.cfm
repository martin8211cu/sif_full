<cfset navegacion = "">
<cf_dbfunction name="OP_concat" returnvariable="cat">
<cfquery name="rsDocSinReintegrar" datasource="#session.dsn#">
	select 	a.TESDPid,
		case TESDPtipoDocumento
			when 0 then 'SP.' #cat# <cf_dbfunction name="to_char" args="sp.TESSPnumero">
			when 5 then 'SP.' #cat# <cf_dbfunction name="to_char" args="sp.TESSPnumero">
			when 1 then 'Doc.CxP.'
			when 2 then 'Ant.CxP.'
			when 3 then 'Ant.CxC.'
			when 4 then 'Ant.POS.'
			when 8 then 'Tran.CCH.'
			else 'Otro'
		end as tipo,
		a.TESDPdocumentoOri,<!---a.TESDPdescripcion---> b.TESOPbeneficiario as TESDPdescripcion,a.TESDPfechaPago,a.TESDPmontoPago, a.CFcuentaDB as CFcuenta
	from TESdetallePago a
		inner join TESordenPago b
			on a.TESOPid= b.TESOPid
		inner join TESsolicitudPago sp
			on sp.TESSPid= a.TESSPid
		inner join CFinanciera cf on cf.CFcuenta = a.CFcuentaDB
	where a.TESid				= #session.Tesoreria.TESid#
	  and a.TESDPtipoDocumento	not in (6,7)
	  and a.TESDPestado			= 12
	  and b.CBidPago			= #form.CBid#
	  and 	case 
				when a.TESDPtipoDocumento = 2 then coalesce((select EDsaldo from EDocumentosCP where IDdocumento = a.TESDPidDocumento),0) else 0
			end = 0
	  and 	(
			select count(1)
			  from TESreintegroDet
			 where TESDPid = a.TESDPid
			   and TESRDrechazado = 0
			) = 0
	UNION
	select 	a.TESDPid,
			'Liq.GE.' #cat# <cf_dbfunction name="to_char" args="GELnumero"> as tipo,
			 lg.GELGnumeroDoc as TESDPdocumentoOri,<!---lg.GELGdescripcion--->  b.TESOPbeneficiario as TESDPdescripcion
			 ,a.TESDPfechaPago,a.TESDPmontoPago, a.CFcuentaDB as CFcuenta
	  from TESdetallePago a
		inner join GEliquidacionGasto lg
			 on lg.GELid = a.TESDPidDocumento
			and lg.Linea = a.TESSPlinea
		inner join GEliquidacion bb
			on bb.GELid = a.TESDPidDocumento
		inner join TESordenPago b
			on a.TESOPid= b.TESOPid
		inner join CFinanciera cf on cf.CFcuenta = a.CFcuentaDB
	where a.TESid				= #session.Tesoreria.TESid#
	  and a.TESDPtipoDocumento	= 7
	  and a.TESDPestado			= 12
	  and b.CBidPago			= #form.CBid#
	  and 	(
			select count(1)
			  from TESreintegroDet
			 where TESDPid = a.TESDPid
			   and TESRDrechazado = 0
			) = 0
	UNION
	select 	a.TESDPid,
			'Liq.GE.' #cat# <cf_dbfunction name="to_char" args="GELnumero"> as tipo,
			lg.GELGnumeroDoc as TESDPdocumentoOri, tb.TESBeneficiario as TESDPdescripcion
			<!---lg.GELGdescripcion as TESDPdescripcion--->, a.TESDPfechaPago, a.TESDPmontoPago,a.CFcuentaDB as CFcuenta
	  from TESdetallePago a
		inner join GEliquidacion b
			on b.GELid = a.TESDPidDocumento
		inner join GEliquidacionGasto lg
			 on lg.GELid = a.TESDPidDocumento
			and lg.Linea = a.TESSPlinea
		inner join CFinanciera cf 
				on cf.CFcuenta = a.CFcuentaDB
		inner join TESbeneficiario tb
		  on b.TESBid = tb.TESBid
	where a.TESid				= #session.Tesoreria.TESid#
	  and a.TESDPtipoDocumento	= 7
	  and a.TESDPestado 		= 212
	  and b.CBidAnts			= #form.CBid#
	  and 	(
			select count(1)
			  from TESreintegroDet
			 where TESDPid = a.TESDPid
			   and TESRDrechazado = 0
			) = 0
	order by tipo,TESDPdocumentoOri
</cfquery>

<cfquery name="rsDetalleReintegro" datasource="#session.dsn#">
	select a.TESDPid,
			case TESDPtipoDocumento
				when 0 then 'SP.' #cat# <cf_dbfunction name="to_char" args="sp.TESSPnumero">
				when 5 then 'SP.' #cat# <cf_dbfunction name="to_char" args="sp.TESSPnumero">
				when 1 then 'Doc.CxP.'
				when 2 then 'Ant.CxP.'
				when 3 then 'Ant.CxC.'
				when 4 then 'Ant.POS.'
				when 7 then (select 'Liq.GE.' #cat# <cf_dbfunction name="to_char" args="GELnumero"> from GEliquidacion where GELid = a.TESDPidDocumento)
				when 8 then 'Tran.CCH.'
				else 'Otro'
			end as tipo,
			a.TESDPdocumentoOri,<!---a.TESDPdescripcion---> 
			case  when sp.TESBid is null  then  sn.SNnombre  else tb.TESBeneficiario end as TESDPdescripcion ,
			a.TESDPfechaPago, TESDPmontoPago
		from TESdetallePago a
			inner join TESreintegroDet d
				on d.TESDPid=a.TESDPid
			inner join TESsolicitudPago sp
				on sp.TESSPid= a.TESSPid
			left join TESbeneficiario tb
		  		on tb.TESBid = sp.TESBid
			left join SNegocios sn
				 on sn.Ecodigo  = sp.EcodigoOri
				and sn.SNcodigo = sp.SNcodigoOri
		where a.EcodigoOri=#session.Ecodigo#
		  and d.TESRnumero=#form.TESRnumero#
		order by tipo,TESDPdocumentoOri
</cfquery>

<cfoutput>
<form action="TESReintegroCB_sql.cfm" method="post" name="form2"> 
	<input type="hidden" name="TESRnumero" value="#rsForm.TESRnumero#" />
	<cfset LvarMonto=0>
	<table width="100%" border="1">
		<tr>
			<td width="50%" valign="top" align="left">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr class="tituloListas">
						<td colspan="11" class="tituloListas" align="center">Lista de Movimientos a Reintegrar</td>
					</tr>
				<cfif rsForm.TESRestado EQ 0>
					<tr class="tituloListas">
						<td align="center" colspan="11">
							<input type="submit" value="Eliminar" name="btnElimina" 
								<cfif rsDetalleReintegro.RecordCount eq 0>disabled</cfif>
							/>
						</td>
					</tr>
				</cfif>
					<tr class="tituloListas">
						<td width="1%" align="center">&nbsp;</td>
						<td nowrap><strong>Tipo Doc.</strong></td>
						<td width="1%" align="center">&nbsp;</td>
						<td nowrap><strong>Documento</strong></td>
						<td width="1%" align="center">&nbsp;</td>
						<td align="center" nowrap><strong>Descripción</strong></td>
						<td width="1%" align="center">&nbsp;</td>
						<td nowrap align="center"><strong>Fecha</strong></td>
						<td width="1%" align="center">&nbsp;</td>
						<td width="1%" align="center">&nbsp;</td>
						<td align="center" nowrap><strong>Gastos</strong></td>
					</tr>
						<cfif rsDetalleReintegro.RecordCount gt 0>
							<cfloop query="rsDetalleReintegro">
					<tr class="<cfif rsDetalleReintegro.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
						<td valign="middle" align="center"><input type="checkbox" name="eli" value="#rsDetalleReintegro.TESDPid#" ></td>
						<td valign="middle" align="left">#rsDetalleReintegro.Tipo#</td>
						<td width="1%" align="center">&nbsp;</td>
						<td valign="middle" align="left">#rsDetalleReintegro.TESDPdocumentoOri#</td>
						<td width="1%" align="center">&nbsp;</td>
						<td align="left" valign="middle">#rsDetalleReintegro.TESDPdescripcion#</td>
						<td width="1%" align="center">&nbsp;</td>
						<td valign="middle" align="left">#LSDateFormat(rsDetalleReintegro.TESDPfechaPago, 'dd/mm/yyyy')#</td>
						<td width="1%" align="right">&nbsp;</td>
						<td width="1%" align="right">&nbsp;</td>
						<td valign="middle" align="right">#NumberFormat(rsDetalleReintegro.TESDPmontoPago,",0.00")#</td>
					</tr>	
							<cfset LvarMonto=LvarMonto+rsDetalleReintegro.TESDPmontoPago>
							</cfloop>
						<cfelse>
					<tr><td colspan="5" align="center"><strong> - No existen solicitudes asignadas a este comprador - </strong></td></tr>
						</cfif>		
				</table>	
			</td>
			<td width="50%"  align="left" valign="top">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr class="tituloListas">
						<td colspan="11" class="tituloListas" align="center">Lista de Movimientos Disponibles</td>
					</tr>
				<cfif rsForm.TESRestado EQ 0>
					<tr class="tituloListas">
						<td align="center" colspan="11">
							<input type="submit" value="Agregar" name="btnAgrega"
								<cfif rsDocSinReintegrar.RecordCount eq 0>disabled</cfif>
							/>
						</td>
					</tr>
				</cfif>
					<tr class="tituloListas">
						<td width="1%" align="center">&nbsp;</td>
						<td nowrap><strong>Tipo Doc.</strong></td>
						<td width="1%" align="center">&nbsp;</td>
						<td nowrap><strong>Documento</strong></td>
						<td width="1%" align="center">&nbsp;</td>
						<td align="center" nowrap><strong>Descripción</strong></td>
						<td width="1%" align="center">&nbsp;</td>
						<td nowrap align="center"><strong>Fecha</strong></td>
						<td width="1%" align="center">&nbsp;</td>
						<td width="1%" align="center">&nbsp;</td>
						<td align="center" nowrap><strong>Gastos</strong></td>
					</tr>
						<cfif rsDocSinReintegrar.RecordCount gt 0>
							<cfloop query="rsDocSinReintegrar">
					<tr class="<cfif rsDocSinReintegrar.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
						<td valign="middle" align="center"><input type="checkbox" name="agr" value="#rsDocSinReintegrar.TESDPid#"></td>
						<td valign="middle" align="left">#rsDocSinReintegrar.Tipo#</td>
						<td width="1%" align="center">&nbsp;</td>
						<td valign="middle" align="left">#rsDocSinReintegrar.TESDPdocumentoOri#</td>
						<td width="1%" align="center">&nbsp;</td>
						<td align="left" valign="middle">#rsDocSinReintegrar.TESDPdescripcion#</td>
						<td width="1%" align="center">&nbsp;</td>
						<td valign="middle" align="left">#LSDateFormat(rsDocSinReintegrar.TESDPfechaPago, 'dd/mm/yyyy')#</td>
						<td width="1%" align="center">&nbsp;</td>
						<td width="1%" align="center">&nbsp;</td>
						<td valign="middle" align="right">#NumberFormat(rsDocSinReintegrar.TESDPmontoPago,",0.00")#</td>
					</tr>
							</cfloop>
						<cfelse>
					<tr><td colspan="5" align="center"><strong> - No existen solicitudes asignadas a este comprador - </strong></td></tr>
						</cfif>		
				</table>	
			</td>
		</tr>
	</table>
</form>

<script language="javascript" type="text/javascript">
	document.form1.montoA.value="#NumberFormat(LvarMonto,",9.99")#";
</script>

</cfoutput>

