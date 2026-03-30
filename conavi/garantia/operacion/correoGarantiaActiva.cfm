<!--- Encabezado de la Garantia--->
<cfquery name="rsEncabezado" datasource="#session.dsn#">
		select eg.COEGReciboGarantia, eg.COEGPersonaEntrega,
			eg.COEGVersion, eg.COEGFechaRecibe, s.SNnombre as SocioDeNegocio,
			case when eg.COEGVersion = 1 then 'activad' else 'reactivad' end msg,
			m.Msimbolo, sum(case when eg.Mcodigo = dg.CODGMcodigo then CODGMonto else CODGMonto * dg.CODGTipoCambio / coalesce(tc.TCventa,1) end) as MontoTotal,
		    case eg.COEGTipoGarantia
			 when 1 then  'Participación'
     		 when 2 then  'Cumplimiento'
			 else  'No definido'
			 end as TipoGarantia,
			coalesce(cmp.CMPdescripcion,'Ninguno') as ProcesoDesc,<!---Se deja de usar el ProcesoDesc por el ProcesoID para que quede igual a la reimpresion de garantia--->
            coalesce(p.CMPProceso,'-- NO ASIGNADO --') as ProcesoID,
			COEGNumeroControl		
			from COHEGarantia eg
				inner join COHDGarantia  dg
					on dg.COEGid = eg.COEGid
					and dg.COEGVersion = eg.COEGVersion
				inner join SNegocios s
					on s.SNid = eg.SNid  
				inner join Monedas m
					on m.Mcodigo = eg.Mcodigo
    		    left outer join CMProcesoCompra cmp
	     		    on eg.CMPid = cmp.CMPid
                left outer join CMProceso p 
					on p.CMPid = eg.CMPid	    
				left outer join Htipocambio tc
           			on tc.Mcodigo = eg.Mcodigo and tc.Hfecha <= eg.COEGFechaRecibe and tc.Hfechah > eg.COEGFechaRecibe
			where eg.COEGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COEGid#">
			  and eg.COEGVersionActiva = 1
			group by eg.COEGReciboGarantia, eg.COEGPersonaEntrega,
			eg.COEGVersion, eg.COEGFechaRecibe, s.SNnombre, m.Msimbolo,COEGTipoGarantia,CMPdescripcion,CMPProceso,COEGNumeroControl
</cfquery>
<!---Detalles de la garantia--->
<cfquery name="rsDetalles" datasource="#session.dsn#">
	select dg.CODGNumeroGarantia, 
	       dg.CODGid, 
		   dg.CODGFechaFin, 
		   dg.CODGMonto,
		   tr.COTRDescripcion,
		   b.Bdescripcion,
		   m.Miso4217,
		   dg.CODGObservacion		  	
		from COHDGarantia  dg
			inner join COHEGarantia  eg
				on dg.COEGid = eg.COEGid
				and dg.COEGVersion = eg.COEGVersion		
			inner join COTipoRendicion tr
				on tr.COTRid = dg.COTRid
			inner join Bancos b
				on b.Bid= dg.Bid
			inner join Monedas m
				on m.Mcodigo = dg.CODGMcodigo
		where dg.COEGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COEGid#">
		  and eg.COEGVersionActiva = 1
		 
</cfquery>
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0" border="1">
	<tr>
	  <td align="center" colspan="2" bgcolor="##99CC33"><strong style="font-size:24px">Se ha #rsEncabezado.msg#o la Garantía</strong></td>
	</tr>
<tr><td>
<table width="100%" cellpadding="0" cellspacing="0">

	<tr>
	  <td align="center" colspan="2"><strong>#rsEncabezado.COEGReciboGarantia#-#rsEncabezado.COEGVersion#</strong></td>
	</tr>
	<tr>
		<td align="left"><strong>Número control:</strong>&nbsp;#rsEncabezado.COEGNumeroControl#</td>
	  	<td align="left"><strong>Tipo Garantía:</strong>&nbsp;#rsEncabezado.TipoGarantia#</td>
	</tr>
	<tr>
	    <td class="2" align="left"><strong>Fecha Recepción:</strong>&nbsp;#LSDateFormat(rsEncabezado.COEGFechaRecibe, 'dd/mm/yyyy hh:mm:ss')#</td>
	</tr>
	<tr>
		<td colspan="2"><strong>Persona entrega:</strong>&nbsp;#rsEncabezado.COEGPersonaEntrega#</td>
	</tr>
	<tr>
		<td colspan="2"><strong>Socio de Negocio:</strong>&nbsp;#rsEncabezado.SocioDeNegocio#</td>
	</tr>			
	<tr>
	  <td align="left"><strong>Total Garantía:</strong>&nbsp;#rsEncabezado.Msimbolo# #LSNumberFormat(rsEncabezado.MontoTotal, ',9.00')#  </td>
	  <td align="left"><strong>Contrato asociado:</strong>&nbsp;#rsEncabezado.ProcesoID#</td>
	</tr>	
	<tr><td>&nbsp;</td></tr>
	<tr><td><strong>Lineas de Detalle</strong>:</td></tr>
	<tr>
		<td colspan="2">	
			<table width="100%" border="1">
				<tr>
					<td width="13%" bgcolor="CCCCCC" align="left">Numero</td>
					<td width="10%" bgcolor="CCCCCC" align="left">Monto</td>
					<td width="9%" bgcolor="CCCCCC" align="left">Moneda</td>
					<td width="21%" bgcolor="CCCCCC" align="left">Banco Emisor</td>
					<td width="22%" bgcolor="CCCCCC" align="left">Tipo de Rendición</td>
					<td width="22%" bgcolor="CCCCCC" align="left">Fecha Vencimiento</td>
				</tr>
				<cfloop query="rsDetalles">
					<tr>
						<td nowrap="nowrap" style="padding:3px;font-size:12px">#rsDetalles.CODGNumeroGarantia#</td>
						<td nowrap="nowrap" style="padding:3px;font-size:12px">#LSNumberFormat(rsDetalles.CODGMonto, ',9.00')#</td>
						<td nowrap="nowrap" style="padding:3px;font-size:12px">#rsDetalles.Miso4217#</td>
						<td nowrap="nowrap" style="padding:3px;font-size:12px">#rsDetalles.Bdescripcion#</td>
						<td nowrap="nowrap" style="padding:3px;font-size:12px">#rsDetalles.COTRDescripcion#</td>
						<td nowrap="nowrap" style="padding:3px;font-size:12px">#LsDateFormat(rsDetalles.CODGFechaFin,'dd/mm/yyyy')#</td>
					</tr>
				    <tr>
				        <td colspan="6" bgcolor="CCCCCC" align="left">Observación: #rsDetalles.CODGObservacion#</td>
				    </tr>
				 </cfloop>
			</table>
		</td>	
	</tr>
</table>
</td></tr></table>
</cfoutput>
