<cfif isdefined("url.Generar")>	
	
	<cfquery name="rsGarantiasXProceso" datasource="#session.DSN#" maxrows="5001">
		select
        	b.COEGid,
			  case when b.COEGTipoGarantia = 1 
			       then 'Participación' 
				   else 'Cumplimiento' 
				   end as COEGTipoGarantia, 
			 c.SNnombre,
			 b.COEGMontoTotal,
			 g.Mnombre,
			 b.COEGFechaRecibe,
			 case when b.COEGEstado = 1 
			   then 'Vigente' when b.COEGEstado = 2 
			   then 'Edicion' when b.COEGEstado = 3 
			   then 'En proceso de Ejecución' 
			                  when b.COEGEstado = 4 
			   then 'En ejecución'
			                  when b.COEGEstado = 5 
			   then 'Ejecutada' 
				              when b.COEGEstado = 6 
			   then 'En proceso Liberación' 
			                  when b.COEGEstado = 7 
			   then 'Liberada '
			   else 'Devuelta' 
			   end as COEGEstado,
			   c.SNnumero,
			   b.COEGReciboGarantia,
			   b.COEGVersion,
			   b.COEGNumeroControl   
        from COHEGarantia b			
			left join SNegocios c
				on c.SNid = b.SNid
			inner join Monedas g
				on g.Mcodigo = b.Mcodigo  			
        where b.Ecodigo = #session.Ecodigo#	
			and b.COEGContratoAsociado = 'N'
			and b.COEGVersionActiva= 1
			and b.COEGVersion = (select max(COEGVersion) from COHEGarantia x where b.COEGid = x.COEGid)		
			<!--- Estado --->
			<cfif isdefined("url.Estado") and len(trim(url.Estado)) and url.Estado NEQ '-1'>
				and b.COEGEstado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Estado#"> 
			</cfif>		
			<cfif isdefined('url.SNnumero1') and Len(trim(url.SNnumero1)) >
				and c.SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero1#">
			</cfif>			
			<!--- Fechas Desde / Hasta --->
			 <cfif isdefined("url.fechaDes") and len(trim(url.fechaDes)) and isdefined("url.fechaHas") and len(trim(url.fechaHas))>					
				<cfif datecompare(url.fechaDes, url.fechaHas) eq -1> 
					and b.COEGFechaRecibe between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#"> 
						and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
				<cfelseif datecompare(url.fechaDes, url.fechaHas) eq 1>
					and b.COEGFechaRecibe between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
				<cfelseif datecompare(url.fechaDes, url.fechaHas) eq 0>
					and b.COEGFechaRecibe between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
						and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
				</cfif>
			<cfelseif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
				and b.COEGFechaRecibe >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaDes)#">
			<cfelseif isdefined("url.fechaHas") and len(trim(url.fechaHas))>
				and b.COEGFechaRecibe <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaHas)#">
			</cfif> 			
		order by b.COEGid
	</cfquery>
		
	<cfquery name="rsDetalleGarantia" datasource="#session.DSN#" maxrows="5001">
		select a.CODGid,f.COTRDescripcion,a.CODGMonto,h.Mnombre,a.CODGFechaFin,g.Bdescripcion,b.COEGid
        from COHDGarantia a
			inner join COHEGarantia b
			on b.COEGid = a.COEGid			
			left join SNegocios d
			on d.SNid = b.SNid
			inner join COTipoRendicion f
			on 	f.COTRid = a.COTRid
			inner join Bancos g
			on g.Bid = a.Bid
			inner join Monedas h
			on h.Mcodigo = b.Mcodigo 			
        where a.Ecodigo = #session.Ecodigo#	
			and b.COEGid = a.COEGid	
			and b.COEGContratoAsociado = 'N'
			and b.COEGVersionActiva= 1	
			and a.COEGVersion = (select max(COEGVersion) from COHEGarantia x where b.COEGid = x.COEGid)
			<!--- Moneda --->
			<!---<cfif isdefined("url.Moneda") and len(trim(url.Moneda)) and url.Moneda NEQ '-1'>
				and c.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda#"> 
			</cfif>--->
			
			<!--- Tipo de transacción --->							
		order by a.CODGid
	</cfquery>
	
	<cfquery name="rsSeguimiento" datasource="#session.DSN#" maxrows="5001">
		select	a.COSGid,a.COEGid,a.COSGObservacion,a.COSGFecha,a.COSGUsucodigo,b.COEGid,b.CMPid
        from COSeguiGarantia a
			inner join COHEGarantia b 
				on b.COEGid = a.COEGid			
		where b.Ecodigo = #session.Ecodigo#	
		and b.COEGContratoAsociado = 'N'
		and b.COEGVersionActiva= 1
			and b.COEGVersion = (select max(COEGVersion) from COHEGarantia x where b.COEGid = x.COEGid)							
		order by a.COSGid
	</cfquery>

	<cfif isdefined("rsGarantiasXProceso") and rsGarantiasXProceso.recordcount gt 5000>
		<cf_errorCode	code = "50196" msg = "Se han generado mas de 5000 registros para este reporte.">
		<cfabort>
	</cfif>
	
	<style type="text/css">
    * { font-size:9px; font-family:Verdana, Arial, Helvetica, sans-serif }
    .niv1 { font-size: 18px; }
    .niv2 { font-size: 14px; }
    .niv3 { font-size: 12px; }
	.niv4 { font-size:11px; font-family:Verdana, Arial, Helvetica, sans-serif; border-bottom:solid; border-bottom-width:thin}
	.niv5 { font-size:3px; font-family:Verdana, Arial, Helvetica, sans-serif; height:1px}
    </style>

	
	<cf_htmlReportsHeaders 
		<!---title="Garantías por contrato" --->
		filename="Documentos.xls"
		irA="GarantiasSinContrato.cfm">
	<cfoutput>
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td colspan="8" align="center" style="font-size:24px;font-weight:bolder">#session.Enombre#</td>
			</tr>
			<tr>
				<td colspan="8" align="center" style="font-size:18px;font-weight:bolder">Detalle de Garantías sin Contrato</td>
			</tr>	
			<!---ver si proceso tiene garantias--->	
			<!---<cfset indice = 1 >
			<cfset tienegarantias = ArrayNew(1)>
			<cfflush interval="64">			
			<cfloop query="rsReporte">
				<cfflush interval="64">			
				<cfloop query="rsGarantiasXProceso">				
					<cfif #rsGarantiasXProceso.CMPid# EQ #rsReporte.CMPid#>
						<cfset ArrayAppend(tienegarantias, #rsReporte.CMPid#)> 					
						<!---<cfset tienegarantias[indice] = #rsReporte.CMPid#>
						<cfset indice = indice + 1 >--->							
					</cfif>
				</cfloop>
			</cfloop>
			<!---<cf_dump var="#tienegarantias#">--->
			<!---fin si proceso tiene garantias--->	
			
			<cfset PcG = ArrayToList(tienegarantias,',')>

					
			<cfflush interval="64">
			<cfloop query="rsReporte"><!---Procesos segun filtro--->
				
				<cfif ListFind(PcG,#rsReporte.CMPid#,',')><!---if si el proceso tenia garantias--->
				
				
				<tr bgcolor="##EAFFD5" style="font-size:18px"><!---Encabezado Procesos--->
					<td colspan="7" align="center"><strong>Proceso:&nbsp;</strong>#rsReporte.CMPProceso# &nbsp;&nbsp;
					<strong>Monto:&nbsp;</strong>#NumberFormat(rsReporte.CMPMontoProceso,',_.__')#&nbsp;&nbsp;					
					<strong>Moneda:&nbsp;</strong>#rsReporte.Mnombre#
					</td>					
				</tr>
				<tr><td colspan="7">&nbsp;</td></tr>--->
				<!---Garantias Por Proceso--->
				<tr><td colspan="8">&nbsp;</td></tr>
					<tr bgcolor="##E3EDEF"><!---Encabezado garantias--->
						<td class="niv4"><strong>Garantia</strong></td>
						<td class="niv4"><strong>N° Control</strong></td>
						<td class="niv4"><strong>Clase</strong></td>
						<td class="niv4"><strong>Proveedor</strong></td>
						<td class="niv4"><strong>Monto</strong></td>
						<td class="niv4"><strong>Moneda</strong></td>
						<td class="niv4"><strong>Fecha</strong></td>
						<td class="niv4"><strong>Estado</strong></td>
					</tr>
					<cfflush interval="64">
					<cfloop query="rsGarantiasXProceso">
						<!---<cfif #rsGarantiasXProceso.CMPid# EQ #rsReporte.CMPid#>	--->
							<tr>
								<td>#rsGarantiasXProceso.COEGReciboGarantia#- #rsGarantiasXProceso.COEGVersion#</td>
								<td>#rsGarantiasXProceso.COEGNumeroControl#</td>
								<td>#rsGarantiasXProceso.COEGTipoGarantia#</td>
								<td>#rsGarantiasXProceso.SNnombre#</td>
								<td>#NumberFormat(rsGarantiasXProceso.COEGMontoTotal,',_.__')#</td>
								<td>#rsGarantiasXProceso.Mnombre#</td>	
								<td>#LSDateFormat(rsGarantiasXProceso.COEGFechaRecibe,'dd/mm/yyyy')#</td>  
								<td>#rsGarantiasXProceso.COEGEstado#</td>							
							</tr>							
							<!---Encabezado detalle--->
							<tr>
								<td><strong>Detalles</strong></td>
								<td><strong>Doc.</strong></td>
								<td><strong>Tipo</strong></td>
								<td><strong>Monto</strong></td>
								<td><strong>Moneda</strong></td>
								<td><strong>Fecha Vencim.</strong></td>
								<td><strong>Banco</strong></td>
							</tr>
							<!---Detalles de Cada Garantia--->
								<cfflush interval="64">
								<cfloop query="rsDetalleGarantia">
									<cfif #rsGarantiasXProceso.COEGid# EQ #rsDetalleGarantia.COEGid# >
										<tr>
											<td><strong></strong></td>
											<td>#rsDetalleGarantia.CODGid#</td>
											<td>#rsDetalleGarantia.COTRDescripcion#</td>
											<td>#NumberFormat(rsDetalleGarantia.CODGMonto,',_.__')#</td>											
											<td>#rsDetalleGarantia.Mnombre#</td>
											<td>#DateFormat(rsDetalleGarantia.CODGFechaFin,'DD/MM/YYYY')#</td>
											<td>#rsDetalleGarantia.Bdescripcion#</td>
										</tr>
									</cfif>
								</cfloop>	<!---<tr><td colspan="7" style="height:auto">&nbsp;</td></tr>--->							
							<!---FIN Detalles de Cada Garantia--->
							
							<!---Seguimiento GARANTIA--->
							<cfif isdefined("url.Seguimiento") and #url.Seguimiento# EQ 'on'>								
									<tr>
										<td><strong><!---Detalles---></strong></td>
										<td><strong>Observaciones</strong></td>
										<td><strong>Usuario</strong></td>
										<td><strong>Fecha</strong></td>
										<td><strong>Observación</strong></td>
									</tr>
									<cfflush interval="64">
									<cfloop query="rsSeguimiento">
										<cfif #rsGarantiasXProceso.COEGid# EQ #rsSeguimiento.COEGid#>
											<tr>
												<td><strong><!---Detalles---></strong></td>
												<td><strong><!---Detalles---></strong></td>
												<td>#rsSeguimiento.COSGUsucodigo#</td>
												<td>#DateFormat(rsSeguimiento.COSGFecha,'DD/MM/YYYY')#</td>
												<td>#rsSeguimiento.COSGObservacion#</td>	
											</tr>									
										</cfif>
									</cfloop>
								 <tr><td colspan="7" style="height:auto">&nbsp;</td></tr>						
							</cfif>
							<!---FIN Seguimiento GARANTIA--->
							
						<!---</cfif>--->
					</cfloop>
					  <tr><td colspan="7" style="height:auto">&nbsp;</td></tr>		
					  <tr><td colspan="7" align="center" style="height:auto">------------ Fin del reporte ------------</td></tr>	
					<!---</cfif>fin si el proceso tenia garantias--->
					<!---FIN Garantias Por Proceso
			</cfloop>	--->				
		</table>
		</cfoutput>
</cfif>