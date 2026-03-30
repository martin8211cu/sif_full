<cf_dbfunction name="OP_concat" returnvariable="cat">
<!---<cfdump var="#url#">
<cf_dump var="#form#">--->
<!---<cfset form.chkResumen=#url.LvarchkResumen#>--->
<cf_htmlReportsHeaders 
		title="Reintegro Cuenta Bancaria" 
		filename="ReintegroCuentaBancaria.xls"
		irA="TESReintegroCB.cfm?TESRnumero=#url.TESRnumero#"
		download="no"
		preview="no"
		>
<form name="form1" method="post" action="TESarqueoCB.cfm">
<cfoutput>
<table width="100%" border="0">

<cfif   isdefined ('url.LvarCBid') and len(trim(url.LvarCBid)) gt 0>
	<cfset LvarCBid= url.LvarCBid>	
	
	<cfquery name="rsReintegroRep" datasource="#session.dsn#">
		select a.TESDPid,
			case TESDPtipoDocumento
					when 5 then 0
					else TESDPtipoDocumento
				end as tipo0,
				case TESDPtipoDocumento
					when 0 then  'Pagos Manuales no Reintegrados'
					when 5 then  'Pagos Manuales no Reintegrados'
					when 1 then  'Pagos Documentos CxP no Reintegrados'
					when 2 then  'Pagos Anticipos CxP no Reintegrados'
					when 3 then  'Pagos x Devoluciones Anticipos CxC no Reintegrados'
					when 4 then  'Pagos x Devoluciones Anticipos POS no Reintegrados'
					when 6 then  'Pagos x Anticipos Empleados no Reintegrados'
					when 7 then  'Pagos x Liquidaciones de Gasto Empleados no Liquidadas'
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
					when 7 then 'Liq.GE.'<!--- #cat# <cf_dbfunction name="to_char" args="GELnumero">--->
					when 8 then 'Tran.CCH.'
					when 10 then 'Reintegro CB.'
					else 'Otro'
				end as tipo2,
				
			a.TESDPdocumentoOri,a.TESDPdescripcion, 
			case  when sp.TESBid is null  then  sn.SNnombre  else tb.TESBeneficiario end as TESOPbeneficiario ,
			a.TESDPfechaPago, TESDPmontoPago,
			a.CFcuentaDB as CFcuenta
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
		  and d.TESRnumero=#url.TESRnumero#
		  
		 order by tipo1,TESDPdocumentoOri
	</cfquery>
	
	
	<cfquery name="rsTotal" dbtype="query">
		select sum(TESDPmontoPago) as Pagos
		  from rsReintegroRep
	</cfquery>	
	
	<cfquery  name="datosCB" datasource="#session.dsn#">
		select bp.Bdescripcion  #cat# '  ' #cat# cp.CBcodigo #cat# ' en ' #cat# mp.Mnombre as CBdescripcion,
			ep.Edescripcion, ep.Ecodigo
		 from CuentasBancos cp
				inner join Empresas ep
					 on ep.Ecodigo = cp.Ecodigo
				inner join Bancos bp
					 on bp.Bid = cp.Bid
				inner join Monedas mp
					 on mp.Ecodigo = cp.Ecodigo
					and mp.Mcodigo = cp.Mcodigo
		where cp.CBid=#LvarCBid#
        	and cp.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
	</cfquery>	
	
	<cfquery  name="datosReintegro" datasource="#session.dsn#">
		select TESRdescripcion 
		 from TESreintegro
		where TESRnumero=#url.TESRnumero#
	</cfquery>
	
	<cfquery datasource="#session.DSN#" name="rsEmpresa">
		select 
				Edescripcion,
				Ecodigo,
				ts_rversion
		from Empresas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
<cfelse>
	<cfset LvarCBid=''>
</cfif>
		
	
	<tr>
		<td align="left">
			<tr>
				<td align="center" valign="top" colspan="8"><strong>#rsEmpresa.Edescripcion#</strong></td>
			</tr>
			<tr>
				<td align="center" valign="top" colspan="8"><strong>Reintegros de Cuentas Bancarias</strong></td>
			</tr>
			<tr>
				<td align="center" valign="top" colspan="8"><strong>Cuenta:&nbsp;#datosCB.CBdescripcion#</strong></td>
			</tr>
			<tr>
				<td align="center" valign="top" colspan="8"><strong>#datosReintegro.TESRdescripcion#</strong></td>
			</tr>
			<cfif datosCB.Ecodigo neq rsEmpresa.Ecodigo>
			<tr>
				<td align="center" valign="top" colspan="8"><strong>Pertenece a :&nbsp;#datosCB.Edescripcion#</strong></td>
			</tr>
			</cfif>
			<tr>
				<td align="left" nowrap="nowrap" colspan="2"></td>
			</tr>
		</td>
	</tr>
	<tr>
	<td colspan="3">		
		<table width="%100" border="0" bordercolor="666666">
			<cfset sbPintarDetallado()>
		</table>
	</td>
	</tr>
	
</table>


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
	<tr bgcolor="##CCCCCC">	
		<td width="50"><strong>Concepto</strong></td>
		<td width="100"><strong>Tipo Doc.</strong></td>
		<td><strong>Documento</strong></td>
		<td><strong>Beneficiario</strong></td>	
		<td><strong>Descripcion</strong></td>	
		<td><strong>Fecha</strong></td>	
		<td align="right"><strong>Monto</strong></td>
	</tr>
	<!---<tr bgcolor="##CCCCCC">	
		<td colspan="4"><strong>SALDO ACTUAL LIBROS</strong></td>
		<td align="right"><strong>#rsSaldo.Mnombre#</strong></td>
		<td align="right"><strong>#NumberFormat(rsSaldo.Actual,",0.00")#</strong></td>
	</tr>
	<tr bgcolor="##CCCCCC">	
		<td colspan="6">&nbsp;</td>
	</tr>--->
	
	
		<cfoutput query="rsReintegroRep" group="tipo1">
			<tr>
				<td colspan="7"><strong>#rsReintegroRep.tipo1#</strong></td>
			</tr>
			<cfset LvarMontoTipo1=0>
			<cfoutput>
				<tr>
					<td>&nbsp;</td>
					<td>#rsReintegroRep.tipo2#</td>
					<td>#rsReintegroRep.TESDPdocumentoOri#</td>
					<td>#rsReintegroRep.TESOPbeneficiario#</td>
					<td>#rsReintegroRep.TESDPdescripcion#</td>
					<td>#LSDateFormat(rsReintegroRep.TESDPfechaPago,'dd/mm/yyyy')#</td>
					<td align="right">#NumberFormat(rsReintegroRep.TESDPmontoPago,",0.00")#</td>
				</tr>
				<cfset LvarMontoTipo1=LvarMontoTipo1+#rsReintegroRep.TESDPmontoPago#>
			</cfoutput>	
			<tr>
				<td align="right" colspan="6"><strong>Monto Total:</strong></td>
				<td align="right"><strong>#NumberFormat(LvarMontoTipo1,",0.00")#</strong></td>
			</tr>
		</cfoutput>	

	
	<tr bgcolor="##CCCCCC">	
		<td colspan="7">&nbsp;</td>
	</tr>
	<tr bgcolor="##CCCCCC">	
		<td colspan="5"><strong>TOTAL A REINTEGRAR</strong></td>
		<td align="right"><strong>#rsSaldo.Mnombre#</strong></td>
		<td align="right"><strong>#NumberFormat(rsTotal.Pagos,",0.00")#</strong></td>
	</tr>
	<!---<tr bgcolor="##CCCCCC">	
		<td colspan="6">&nbsp;</td>
	</tr>
	<tr bgcolor="##CCCCCC">	
		<td colspan="4"><strong>TOTAL = SALDO ACTUAL + PAGOS A REINTEGRAR</strong></td>
		<td align="right"><strong>#rsSaldo.Mnombre#</strong></td>
		<td align="right"><strong>#NumberFormat(rsSaldo.Actual + rsTotal.Pagos,",0.00")#</strong></td>
	</tr>--->
</cffunction>
</cfoutput>