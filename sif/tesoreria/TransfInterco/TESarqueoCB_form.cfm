<cf_dbfunction name="OP_concat" returnvariable="cat">
<cfif isdefined ("form.arqueoCH") and form.arqueoCH eq true> 
	<cfset arqueo = true>
    <cfset action = 'TESarqueoCH.cfm'>
    <cfset mes1 = 'Pagos Documentos no Reintegrados'>
    <cfset mes2 = 'Pagos Anticipos liquidados no reintegrados'>
    <cfset mes22 = 'Pagos Anticipos no liquidados'>
<cfelse>
	<cfset arqueo = false>
    <cfset action = 'TESarqueoCB.cfm'>
    <cfset mes1 = 'Pagos Documentos CxP no Reintegrados'>
    <cfset mes2 = 'Pagos Anticipos CxP liquidados no reintegrados'>
    <cfset mes22 = 'Pagos Anticipos CxP  no liquidados'>
</cfif>
<form name="form1" method="post" action="#action#">
<cfoutput>
<table width="100%">
	<tr>
		<td align="right">
			<strong>Trabajar con Tesorería:</strong>
		</td>
		<td>	
			<cf_cboTESid onchange="this.form.submit();" tabindex="1">
		</td>
	</tr>

<cfif   isdefined ('form.CBid') and len(trim(form.CBid)) gt 0>
	<cfset modo ='CAMBIO'>
	<cfset LvarCBid= ListFirst(form.CBid)>	
	
	
	<!--- Pagos no reintegrados --->
	<cfquery name="rsArqueo" datasource="#session.dsn#">
		<!--- Todo menos LiqGE: Manuales, CxP, CxC/POS, AntGE, CCh --->
		select 	a.TESDPid, 
			case TESDPtipoDocumento
				when 5 then 0
				else TESDPtipoDocumento
			end as tipo0,
			case TESDPtipoDocumento
				when 0 then  'Pagos Manuales no Reintegrados'
				when 5 then  'Pagos Manuales no Reintegrados'
				when 1 then  '#mes1#'
				<!---when 2 then  'Pagos Anticipos CxP no Reintegrados'--->
				when 3 then  'Pagos x Devoluciones Anticipos CxC no Reintegrados'
				when 4 then  'Pagos x Devoluciones Anticipos POS no Reintegrados'
				<!---when 6 then  'Pagos x Anticipos Empleados no Reintegrados'--->
				when 8 then  'Pagos x Transacciones de Caja Chica no Reintegradas'
				when 10 then 'Pagos x Reintegros a otras Cuentas Bancarias no Reintegradas'
				else 'Otro'
			end as tipo1,
			case TESDPtipoDocumento
				when 0 then 'SP.' #cat# <cf_dbfunction name="to_char" args="sp.TESSPnumero">
				when 5 then 'SP.' #cat# <cf_dbfunction name="to_char" args="sp.TESSPnumero">
				when 1 then 'Doc.CxP.'
				when 2 then 'Ant.CxP.'
				when 3 then 'Ant.CxC.'
				when 4 then 'Ant.POS.'
				when 6 then 'Ant.GE.'
				when 8 then 'Tran.CCH.'
				when 10 then 'Reintegro CB.'
				else 'Otro'
			end as tipo2,
			a.TESDPdocumentoOri,
			a.TESDPdescripcion,
			b.TESOPbeneficiario,
			a.TESDPfechaPago,
			case 
					when a.TESDPtipoDocumento = 6 
						then coalesce((select GEADmonto-GEADutilizado from GEanticipoDet where GEADid = a.TESDPidDocumento),0) 
						else a.TESDPmontoPago
			end as TESDPmontoPago,
			a.CFcuentaDB as CFcuenta
		from TESdetallePago a
			inner join TESordenPago b
				on a.TESOPid= b.TESOPid
			inner join TESsolicitudPago sp
				on sp.TESSPid= a.TESSPid
			inner join CFinanciera cf on cf.CFcuenta = a.CFcuentaDB
		where a.TESid				= #session.Tesoreria.TESid#
		  and a.TESDPtipoDocumento	in (0,5,1,3,4,8,10)
		  and a.TESDPestado			= 12
		  and b.CBidPago			= #LvarCBid#
		  and 	case 
					when a.TESDPtipoDocumento = 6 
						then coalesce((select GEADmonto-GEADutilizado from GEanticipoDet where GEADid = a.TESDPidDocumento),0) 
						else 1
				end > 0
		  and 	(
				select count(1)
				  from TESreintegroDet rd
					inner join TESreintegro re
						 on re.TESRnumero = rd.TESRnumero
						and re.TESRestado in (1,11,2,12)
				 where rd.TESDPid = a.TESDPid
				   and rd.TESRDrechazado = 0
				) = 0
		UNION
					select 	a.TESDPid,
			case TESDPtipoDocumento
				when 5 then 0
				else TESDPtipoDocumento
			end as tipo0,
			case TESDPtipoDocumento
				when 2 then  '#mes2#'
			end as tipo1,
			case TESDPtipoDocumento
				when 2 then 'Ant.CxP.'
			end as tipo2,
			a.TESDPdocumentoOri,
			a.TESDPdescripcion,
			b.TESOPbeneficiario,
			a.TESDPfechaPago,
			case 
					when a.TESDPtipoDocumento = 6 
						then coalesce((select GEADmonto-GEADutilizado from GEanticipoDet where GEADid = a.TESDPidDocumento),0) 
						else a.TESDPmontoPago
			end as TESDPmontoPago,
			a.CFcuentaDB as CFcuenta
		from TESdetallePago a
			inner join TESordenPago b
				on a.TESOPid= b.TESOPid
			inner join TESsolicitudPago sp
				on sp.TESSPid= a.TESSPid
			inner join CFinanciera cf on cf.CFcuenta = a.CFcuentaDB
		where a.TESid				= #session.Tesoreria.TESid#
		  and a.TESDPtipoDocumento	in (2)
		  and a.TESDPestado			= 12
		  and b.CBidPago			= #LvarCBid#
		  and coalesce((select EDsaldo from EDocumentosCP where IDdocumento = a.TESDPidDocumento),0) = 0
		  and 	(
				select count(1)
				  from TESreintegroDet rd
					inner join TESreintegro re
						 on re.TESRnumero = rd.TESRnumero
						and re.TESRestado in (1,11,2,12)
				 where rd.TESDPid = a.TESDPid
				   and rd.TESRDrechazado = 0
				) = 0
		UNION
		select 	a.TESDPid,
			case TESDPtipoDocumento
				when 5 then 0
				else TESDPtipoDocumento
			end as tipo0,
			case TESDPtipoDocumento
				when 2 then  '#mes22#'
			end as tipo1,
			case TESDPtipoDocumento
				when 2 then 'Ant.CxPL'
			end as tipo2,
			a.TESDPdocumentoOri,
			a.TESDPdescripcion,
			b.TESOPbeneficiario,
			a.TESDPfechaPago,
			case 
					when a.TESDPtipoDocumento = 6 
						then coalesce((select GEADmonto-GEADutilizado from GEanticipoDet where GEADid = a.TESDPidDocumento),0) 
						else a.TESDPmontoPago
			end as TESDPmontoPago,
			a.CFcuentaDB as CFcuenta
		from TESdetallePago a
			inner join TESordenPago b
				on a.TESOPid= b.TESOPid
			inner join TESsolicitudPago sp
				on sp.TESSPid= a.TESSPid
			inner join CFinanciera cf on cf.CFcuenta = a.CFcuentaDB
		where a.TESid				= #session.Tesoreria.TESid#
		  and a.TESDPtipoDocumento	in (2)
		  and a.TESDPestado			= 12
		  and b.CBidPago			= #LvarCBid#
		  and coalesce((select EDsaldo from EDocumentosCP where IDdocumento = a.TESDPidDocumento),0) > 0
		  and 	(
				select count(1)
				  from TESreintegroDet rd
					inner join TESreintegro re
						 on re.TESRnumero = rd.TESRnumero
						and re.TESRestado in (1,11,2,12)
				 where rd.TESDPid = a.TESDPid
				   and rd.TESRDrechazado = 0
				) = 0
		UNION
		select 	a.TESDPid,
			case TESDPtipoDocumento
				when 5 then 0
				else TESDPtipoDocumento
			end as tipo0,
			case TESDPtipoDocumento
				when 6 then  'Pagos x Anticipos Empleados no Reintegrados'
			end as tipo1,
			case TESDPtipoDocumento
				when 6 then 'Ant.GE.'
			end as tipo2,
			a.TESDPdocumentoOri,
			a.TESDPdescripcion,
			b.TESOPbeneficiario,
			a.TESDPfechaPago,
			a.TESDPmontoPago,
			a.CFcuentaDB as CFcuenta
		from TESdetallePago a
			inner join TESordenPago b
				on a.TESOPid= b.TESOPid
			inner join TESsolicitudPago sp
				on sp.TESSPid= a.TESSPid
			inner join CFinanciera cf on cf.CFcuenta = a.CFcuentaDB
			inner join GEanticipo ga
			  on a.TESSPid = ga.TESSPid
		where a.TESid				= #session.Tesoreria.TESid#
		  and a.TESDPtipoDocumento	in (6)
		  and a.TESDPestado			= 12
		  and b.CBidPago			= #LvarCBid#
		 <!--- and coalesce((select GEADmonto-GEADutilizado from GEanticipoDet where GEADid = a.TESDPidDocumento),0)  > 0--->
<!---		  and (
				(
					select count(1)
					  from GEliquidacionAnts d
						inner join GEliquidacion e
						 on e.GELid 		= d.GELid
						and e.GELestado 	in (0,1,2,4,5)
					 where d.GEAid = ga.GEAid
				) <
				(
					select count(1)
					  from GEanticipoDet f
					 where f.GEAid = ga.GEAid
					   and f.GEADmonto - f.GEADutilizado - f.TESDPaprobadopendiente > 0
				) 
			)--->
						 and 
			(
				(
					select count(1)
					  from GEanticipoDet f
					 where f.GEAid = ga.GEAid
					   and f.GEADmonto - f.GEADutilizado - f.TESDPaprobadopendiente > 0
				) > 0
				or
				(
				(
					select count(1)
					  from GEanticipoDet f
						inner join  GEliquidacionAnts d
						  on d.GEAid = f.GEAid
						inner join GEliquidacion e
						 on e.GELid 		= d.GELid
							and e.GELestado 	in (0,1,2,3)
					  where f.GEAid = ga.GEAid
					   and f.GEADmonto - f.GEADutilizado - f.TESDPaprobadopendiente = 0
					   and (select count(1)
					  			from GEanticipoDet f
								inner join  GEliquidacionAnts d
						  			on d.GEAid = f.GEAid
								inner join GEliquidacion e
						 			on e.GELid 		= d.GELid
									and e.GELestado not in (0,1,2,3)
					  			where f.GEAid = ga.GEAid
					   				and f.GEADmonto - f.GEADutilizado - f.TESDPaprobadopendiente = 0)=0
				) > 0
				)
			)
		UNION			
		<!--- LiqGE con OP --->
		select a.TESDPid, 
				7 as Tipo0,
				'Pagos x Liquidaciones de Gasto Empleados no Liquidadas' as tipo1,
				'Liq.GE.' #cat# <cf_dbfunction name="to_char" args="GELnumero"> as tipo2,
				 lg.GELGnumeroDoc as TESDPdocumentoOri,
				 a.TESDPdescripcion,
				 b.TESOPbeneficiario,
				 a.TESDPfechaPago,a.TESDPmontoPago, a.CFcuentaDB as CFcuenta
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
		  and b.CBidPago			= #LvarCBid#
		  and 	(
				select count(1)
				  from TESreintegroDet rd
					inner join TESreintegro re
						 on re.TESRnumero = rd.TESRnumero
						and re.TESRestado in (1,11,2,12)
				 where rd.TESDPid = a.TESDPid
				   and rd.TESRDrechazado = 0
				) = 0
		UNION
		<!--- LiqGE sin OP --->
		select 	a.TESDPid,
				7 as tipo0,
				'Pagos x Liquidaciones de Gasto Empleados no Liquidadas' as tipo1,
				'Liq.GE.' #cat# <cf_dbfunction name="to_char" args="GELnumero"> as tipo2,
				lg.GELGnumeroDoc as TESDPdocumentoOri, 
				lg.GELGdescripcion as TESDPdescripcion, 
				tb.TESBeneficiario as TESOPbeneficiario,
				a.TESDPfechaPago, a.TESDPmontoPago,a.CFcuentaDB as CFcuenta
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
		  and b.CBidAnts			= #LvarCBid#
		  and 	(
				select count(1)
				  from TESreintegroDet rd
					inner join TESreintegro re
						 on re.TESRnumero = rd.TESRnumero
						and re.TESRestado in (1,11,2,12)
				 where rd.TESDPid = a.TESDPid
				   and rd.TESRDrechazado = 0
				) = 0
		UNION
		select 	1,
				100 as tipo0,
				'Reintegros en Trámite pendientes de Pago' as tipo1,
				'Reintegro CB.' as tipo2,
				<cf_dbfunction name="to_char" args="TESRnumero">,
				TESRdescripcion as TESDPdescripcion,
				'&nbsp;' as TESOPbeneficiario,
				(select TESTILfecha from TEStransfIntercomL where TESTILid = r.TESTILid) as TESDPfechaPago, TESRmonto as TESDPmontoPago, 0 as CFcuenta
			from TESreintegro r
			where CBid = #LvarCBid#
			and r.TESRestado in (1,11)
		order by tipo1,TESDPdocumentoOri
		
	</cfquery>

	<cfif isdefined('form.chkResumen') and len(trim(#form.chkResumen#))>
		<cfquery name="rsArqueo" dbtype="query">
			select tipo0, tipo1, sum(TESDPmontoPago) as TESDPmontoPago
			from rsArqueo
			group by tipo0, tipo1
			order by tipo0
		</cfquery>
		<cfset LvarchkResumen=form.chkResumen>
	<cfelse>
		<cfset LvarchkResumen=''>	
	</cfif>

	<cfquery name="rsTotal" dbtype="query">
		select sum(TESDPmontoPago) as Pagos
		  from rsArqueo
	</cfquery>
<cfelse>
	<cfset modo = 'ALTA'>
	<cfset LvarCBid=''>
	<cfset LvarchkResumen=''>
</cfif>
<cfset vparams ="">
<cfset vparams = vparams & "&LvarCBid=" & LvarCBid & "&LvarchkResumen=" & LvarchkResumen & "&Lvararqueo=" & arqueo >

	<tr>		
		<td align="right"><strong>Cuenta Bancaria:</strong>&nbsp;</td>
		<td>
			<cf_cboTESCBid reintegro="yes" name="CBid" value="#LvarCBid#" Ccompuesto="yes" Dcompuesto="yes" none="yes" tabindex="1" ><!---disabled="#disabled#"--->
		</td>
	</tr>
	<tr>		
		<td align="right"><strong>Fecha:</strong>&nbsp;</td>
		<td>
			#LSDateFormat(Now(),'dd/mm/yyyy')#
		</td>
	</tr>
	<tr>		
		<td align="right"><strong>Resumen:</strong>&nbsp;</td>
		<td>
			<input name="chkResumen" type="checkbox" id="chkResumen" checked="checked" />
              <input name="arqueoCH" type="hidden" id="arqueoCH" value="<cfif isdefined ("form.arqueoCH") and form.arqueoCH eq true>true<cfelse>false</cfif>"/>
		</td>
	</tr>
	
	<tr>
		<td colspan="3" align="center" nowrap="nowrap">
		<cfif modo eq 'ALTA'>
			<input type="submit" value="Generar" name="Generar" id="Generar" />
			<!---<input type="submit" value="Regresar" name="Regresar" />--->
		<cfelse>
			<cf_botones values='Regresar' name='Regresar'>
		</cfif>
		</td>
	</tr>
	<cfif modo eq 'CAMBIO'>
		<tr>
			<td colspan="3">
				<table width="100%" border="0" cellpadding="2" cellspacing="0">
					<tr>
						<td valign="top">
							<cf_rhimprime datos="/sif/tesoreria/TransfInterco/TESarqueoCBRep.cfm" paramsuri="#vparams#">
						</td>	
					</tr>
				</table>
			</td>
		</tr>
	</cfif>
	<cfif modo eq 'CAMBIO'>
		<tr>
		<td colspan="3">		
			<legend><strong>Resultados del arqueo</strong></legend>
			<table width="%100" border="1" bordercolor="666666">
				<cfset sbPintarDetallado()>
			</table>
		</td>
		</tr>
	</cfif>
</table>
</cfoutput>

<script language="javascript">

</script>
<cffunction name="sbPintarDetallado" output="true">
	<cfquery name="rsSaldo" datasource="#session.DSN#" >	
		select 	m.Mnombre, 
				coalesce(sb.Sinicial,0) +
				coalesce(
					(
					   select coalesce(sum(MLmonto*case when BTtipo='D' then 1 else -1 end),0)
					   from MLibros ml
						inner join BTransacciones bt on bt.BTid = ml.BTid
					   where ml.CBid = cb.CBid
						 and ml.MLperiodo	= sb.Periodo
						 and ml.MLmes		= sb.Mes
					), 0)
				as Actual
		  from CuentasBancos cb
				inner join Monedas m
					 on m.Mcodigo = cb.Mcodigo
			left join SaldosBancarios sb
				 on sb.CBid = cb.CBid
				and sb.Periodo	= #datePart("YYYY",now())#
				and sb.Mes		= #datePart("M",now())#
		 where cb.CBid = #LvarCBid#
         	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
	</cfquery>
	<tr bgcolor="CCCCCC">	
		<td width="50"><strong>Concepto</strong></td>
	<cfif isdefined('form.chkResumen') and len(trim(#form.chkResumen#))>
		<td  colspan="3">&nbsp;</td>
		<td >&nbsp;</td>
	<cfelse>
		<td width="100"><strong>Tipo Doc.</strong></td>
		<td><strong>Documento</strong></td>
		<td><strong>Beneficiario</strong></td>	
		<td><strong>Fecha</strong></td>	
	</cfif>
		<td align="right"><strong>Monto</strong></td>
	</tr>
	<tr bgcolor="CCCCCC">	
		<td colspan="4"><strong>SALDO ACTUAL LIBROS</strong></td>
		<td align="right"><strong>#rsSaldo.Mnombre#</strong></td>
		<td align="right"><strong>#NumberFormat(rsSaldo.Actual,",0.00")#</strong></td>
	</tr>
	<tr bgcolor="CCCCCC">	
		<td colspan="6">&nbsp;</td>
	</tr>
	
	<cfif isdefined('form.chkResumen') and len(trim(#form.chkResumen#))>
		<cfoutput query="rsArqueo">
			<tr>
				<td colspan="5"><strong>#rsArqueo.tipo1#</strong></td>
				<td align="right">#NumberFormat(rsArqueo.TESDPmontoPago,",0.00")#</td>
			</tr>
		</cfoutput>	
	<cfelse>
		<cfoutput query="rsArqueo" group="tipo1">
			<cfif tipo0 EQ 100>
			<tr>
				<td colspan="6">&nbsp;</strong></td>
			</tr>
			</cfif>
			<tr>
				<td colspan="6"><strong>#rsArqueo.tipo1#</strong></td>
			</tr>
			<cfset LvarMontoTipo1=0>
			<cfoutput>
				<tr>
					<td>&nbsp;</td>
					<td><strong>#rsArqueo.tipo2#</strong></td>
					<td><strong>#rsArqueo.TESDPdocumentoOri#</strong></td>
					<td>#rsArqueo.TESOPbeneficiario#</td>
					<td>#LSDateFormat(rsArqueo.TESDPfechaPago,'dd/mm/yyyy')#</td>
					<td align="right">#NumberFormat(rsArqueo.TESDPmontoPago,",0.00")#</td>
				</tr>
			<cfset LvarMontoTipo1=LvarMontoTipo1+#rsArqueo.TESDPmontoPago#>	
			</cfoutput>	
			<tr>
				<td align="right" colspan="5"><strong>Monto Total:</strong></td>
				<td align="right"><strong>#NumberFormat(LvarMontoTipo1,",0.00")#</strong></td>
			</tr>
		</cfoutput>	
	</cfif>
	
	<tr bgcolor="CCCCCC">	
		<td colspan="6">&nbsp;</td>
	</tr>
	<tr bgcolor="CCCCCC">	
		<td colspan="4"><strong>TOTAL PAGOS REALIZADOS SIN REINTEGRAR</strong></td>
		<td align="right"><strong>#rsSaldo.Mnombre#</strong></td>
		<td align="right"><strong>#NumberFormat(rsTotal.Pagos,",0.00")#</strong></td>
	</tr>
	<tr bgcolor="CCCCCC">	
		<td colspan="6">&nbsp;</td>
	</tr>
	<tr bgcolor="CCCCCC">	
		<td colspan="4"><strong>TOTAL = SALDO ACTUAL + PAGOS A REINTEGRAR</strong></td>
		<td align="right"><strong>#rsSaldo.Mnombre#</strong></td>
		<td align="right"><strong>#NumberFormat(rsSaldo.Actual + rsTotal.Pagos,",0.00")#</strong></td>
	</tr>
</cffunction>