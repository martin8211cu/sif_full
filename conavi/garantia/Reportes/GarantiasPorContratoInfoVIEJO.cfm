<cfif isdefined("url.Generar")>	
	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
		select
        	a.CMPProceso,a.CMPid,b.COEGid,b.COEGFechaRecibe, b.COEGMontoTotal, g.Mnombre   
        from CMProceso a
			inner join COEGarantia b
				on b.CMPid  = a.CMPid
			inner join SNegocios c
				on c.SNid = b.SNid
			inner join CODGarantia d
				on d.COEGid = b.COEGid
			inner join COTipoRendicion e
				on 	e.COTRid = d.COTRid
			inner join Bancos f
				on f.Bid = d.Bid
			inner join Monedas g
				on g.Mcodigo = b.Mcodigo  			
        where a.Ecodigo = #session.Ecodigo#			
			<!--- Moneda --->
			<cfif isdefined("url.Moneda") and len(trim(url.Moneda)) and url.Moneda NEQ '-1'>
				and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda#"> 
			</cfif>
			
			<!--- Tipo de transacción --->
			<cfif isdefined("url.Proceso") and len(trim(url.Proceso)) and url.Proceso NEQ '-1'>
				and a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Proceso#">
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
	<!---	order by f.Mnombre, b.SNnombre--->
	</cfquery>
		
	<cfquery name="rsDetalleGarantia" datasource="#session.DSN#" maxrows="5001">
		select a.CODGid, a.COEGid, case when b.COEGTipoGarantia = 1 then 'Participación' else 'Cumplimiento' end as COEGTipoGarantia, a.CODGMonto , h.Mnombre, a.CODGFechaFin , g.Bdescripcion   
        from CODGarantia a
			inner join COEGarantia b
			on b.COEGid = a.COEGid
			inner join CMProceso c
			on c.CMPid  = b.CMPid
			inner join SNegocios d
			on d.SNid = b.SNid
			inner join COTipoRendicion f
			on 	f.COTRid = a.COTRid
			inner join Bancos g
			on g.Bid = a.Bid
			inner join Monedas h
			on h.Mcodigo = b.Mcodigo 			
        where a.Ecodigo = #session.Ecodigo#	
			and b.COEGid = a.COEGid		
			<!--- Moneda --->
			<cfif isdefined("url.Moneda") and len(trim(url.Moneda)) and url.Moneda NEQ '-1'>
				and c.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Moneda#"> 
			</cfif>
			
			<!--- Tipo de transacción --->
			<cfif isdefined("url.Proceso") and len(trim(url.Proceso)) and url.Proceso NEQ '-1'>
				and c.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Proceso#">
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
	<!---	order by f.Mnombre, b.SNnombre--->
	</cfquery>
	
	
	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
		<cf_errorCode	code = "50196" msg = "Se han generado mas de 5000 registros para este reporte.">
		<cfabort>
	</cfif>

	<!--- Busca nombre del Socio de Negocios 1 --->
	<!---<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
		<cfquery name="rsSNcodigo" datasource="#session.DSN#">
			select SNnombre
			from SNegocios
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
			and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>--->	
	
	<!--- Busca el nombre de la moneda inicial --->
	<cfif isdefined("url.moneda")	and len(trim(url.moneda))>
		<cfquery name="rsMonedaIni" datasource="#session.DSN#">
			select Mcodigo, Mnombre
			from Monedas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.moneda#">
		</cfquery>
	</cfif>
	
	<cf_htmlReportsHeaders 
		title="Garantías por contrato" 
		filename="Documentos.xls"
		irA="GarantiasPorContrato.cfm">
	<cfoutput>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td colspan="7" align="center" style="font-size:24px;font-weight:bolder">#session.Enombre#</td>
			</tr>
			<tr>
				<td colspan="7" align="center" style="font-size:24px;font-weight:bolder">Garantías por contrato</td>
			</tr>
			<tr>
				<td colspan="7">&nbsp;</td>
			</tr>
			<tr bgcolor="##CCCCCC">
				<td><strong>Proceso</strong></td>
				<td><strong>Garantía</strong></td>
				<td><strong>Monto</strong></td>
				<td><strong>Moneda</strong></td>
				<td><strong>Fecha</strong></td>
			</tr>
			<cfflush interval="64">
			<cfloop query="rsReporte">
				<tr>
					<td>#rsReporte.CMPProceso#</td>
					<td>#rsReporte.COEGid#</td>
					<td>#rsReporte.COEGMontoTotal#</td>
					<td>#rsReporte.Mnombre#</td>
					<td>#DateFormat(rsReporte.COEGFechaRecibe,'DD/MM/YYYY')#</td>
				</tr>
			</cfloop>
						
			<tr bgcolor="##CCCCCC">
				<td><strong>Documento</strong></td>
				<td><strong>Tipo</strong></td>
				<td><strong>Monto</strong></td>
				<td><strong>Moneda</strong></td>
				<td><strong>Fecha Vencimiento</strong></td>
				<td><strong>Banco</strong></td>
			</tr>
			<cfflush interval="64">
			<cfloop query="rsDetalleGarantia">
				<tr>
					<td>#rsDetalleGarantia.COEGid#</td>
					<td>#rsDetalleGarantia.COEGTipoGarantia#</td>
					<td>#rsDetalleGarantia.CODGMonto#</td>
					<td>#rsDetalleGarantia.Mnombre#</td>
					<td>#DateFormat(rsDetalleGarantia.CODGFechaFin,'DD/MM/YYYY')#</td>
					<td>#rsDetalleGarantia.Bdescripcion#</td>
				</tr>
			</cfloop>
				
		</table>
		</cfoutput>
	
		<!---</cfreport>--->
	<!---</cfif>--->
</cfif>