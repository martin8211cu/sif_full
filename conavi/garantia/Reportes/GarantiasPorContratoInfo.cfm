<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
<cfif isdefined("url.Generar")>	
	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
		select
        	a.CMPProceso,a.CMPid,a.CMPMontoProceso, g.Mnombre   
        from CMProceso a
			inner join Monedas g
				on g.Mcodigo = a.Mcodigo  			
        where a.Ecodigo = #session.Ecodigo#			
			<!--- Tipo de transacción --->
			<cfif isdefined("url.Proceso") and len(trim(url.Proceso)) and url.Proceso NEQ '-1'>
				and a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Proceso#">
			</cfif>		
					
		order by a.CMPid
	</cfquery>

	  <cf_dbfunction name = "op_concat" returnvariable = "_Cat">
	  <cf_dbfunction name="to_char" args="b.COEGReciboGarantia" 	datasource="#session.dsn#" returnvariable="LvarCOEGReciboGarantia">
	  <cf_dbfunction name="to_char" args="b.COEGVersion" 		datasource="#session.dsn#" returnvariable="LvarCOEGVersion">
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
            b.COEGFechaRecibe , 
            case 
                when b.COEGEstado = 1 then 'Vigente' 
                when b.COEGEstado = 2 then 'Edicion' 
                when b.COEGEstado = 3 then 'En proceso de Ejecución' 
                when b.COEGEstado = 4 then 'En ejecución' 
                when b.COEGEstado = 5 then 'Ejecutada' 
                when b.COEGEstado = 6 then 'En proceso Liberación' 
                when b.COEGEstado = 7 then 'Liberada 'else 'Devuelta' 
            end as COEGEstado, 
            a.CMPid, 
            c.SNnumero, 
			b.COEGNumeroControl,
            #preservesinglequotes(LvarCOEGReciboGarantia)# #_Cat#  '-' #_Cat#  #preservesinglequotes(LvarCOEGVersion)# as GarantiaRecibo  
        from COHEGarantia b
			left join CMProceso a
				on b.CMPid  = a.CMPid
			inner join SNegocios c
				on c.SNid = b.SNid
			inner join Monedas g
				on g.Mcodigo = b.Mcodigo  			
        where b.Ecodigo = #session.Ecodigo#	
			and b.COEGVersionActiva= 1
			and b.COEGVersion = (select max(COEGVersion) from COHEGarantia x where b.COEGid = x.COEGid)
				
			<!--- Estado --->
			<cfif isdefined("url.Estado") and len(trim(url.Estado)) and url.Estado NEQ '-1'>
				and b.COEGEstado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Estado#"> 
			</cfif>
			
			<!--- Tipo de transacción --->
			<cfif isdefined("url.Proceso") and len(trim(url.Proceso)) and url.Proceso NEQ '-1'>
				and a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Proceso#">
			</cfif>			
			<cfif isdefined('url.SNnumero1') and Len(trim(url.SNnumero1))>
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
		order by b.COEGReciboGarantia,b.COEGid
	</cfquery>
		
	<cfquery name="rsDetalleGarantia" datasource="#session.DSN#" maxrows="5001">
		select 
        	a.CODGid,
            a.CODGNumeroGarantia,
        	f.COTRDescripcion,
            a.CODGMonto,
            h.Mnombre,
            a.CODGFechaFin,
            g.Bdescripcion,
            b.COEGid
        from COHDGarantia a
			inner join COHEGarantia b
			on b.COEGid = a.COEGid
			left join CMProceso c
			on c.CMPid  = b.CMPid
			inner join COTipoRendicion f
			on 	f.COTRid = a.COTRid
			inner join Bancos g
			on g.Bid = a.Bid
			inner join Monedas h
			on h.Mcodigo = a.CODGMcodigo
        where b.Ecodigo = #session.Ecodigo#	
			and b.COEGid = a.COEGid	
			and b.COEGVersionActiva= 1
			and a.COEGVersion = (select max(COEGVersion) from COHEGarantia x where b.COEGid = x.COEGid)	
			<!--- Tipo de transacción --->
			<cfif isdefined("url.Proceso") and len(trim(url.Proceso)) and url.Proceso NEQ '-1'>
				and c.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Proceso#">
			</cfif>					
		order by a.CODGid
	</cfquery>
	
	
	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
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
		filename="Documentos.xls"
		irA="GarantiasPorContrato.cfm">
	<cfoutput>
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td colspan="8" align="center" style="font-size:24px;font-weight:bolder">#session.Enombre#</td>
			</tr>
			<tr>
				<td colspan="8" align="center" style="font-size:18px;font-weight:bolder">Detalle de Garantías por Contrato</td>
			</tr>	
			
			<!---ver si proceso tiene garantias--->	
			<cfset indice = 1 >
			<cfset tienegarantias = ArrayNew(1)>
			<cfflush interval="64">			
			<cfloop query="rsReporte">
				<cfflush interval="64">			
				<cfloop query="rsGarantiasXProceso">				
					<cfif rsGarantiasXProceso.CMPid EQ rsReporte.CMPid>
						<cfset ArrayAppend(tienegarantias, #rsReporte.CMPid#)> 					
					</cfif>
				</cfloop>
			</cfloop>
			<!---fin si proceso tiene garantias--->	
			
			<cfset PcG = ArrayToList(tienegarantias,',')>

			<cfflush interval="64">
			<cfloop query="rsReporte"><!---Procesos segun filtro--->
				
				<cfif ListFind(PcG,#rsReporte.CMPid#,',')><!---if si el proceso tenia garantias--->
				
				<tr><td colspan="8">&nbsp;</td></tr>
				<tr bgcolor="##E3EDEF"><!---Encabezado Procesos--->
					<td colspan="8" align="left" class="niv2"><strong class="niv2">Proceso:&nbsp;</strong>#rsReporte.CMPProceso# &nbsp;&nbsp;
					<strong class="niv2">Monto:&nbsp;</strong>#NumberFormat(rsReporte.CMPMontoProceso,',_.__')#&nbsp;&nbsp;					
					<strong class="niv2">Moneda:&nbsp;</strong>#rsReporte.Mnombre#
					</td>
				</tr>
				
				<!---Garantias Por Proceso--->
					<cfflush interval="64">
					<cfloop query="rsGarantiasXProceso">
                    	<cfif rsGarantiasXProceso.CMPid EQ rsReporte.CMPid>
                            <tr bgcolor="##E3EDEF"><!---Encabezado garantias--->
                                <td class="niv4"><strong>Garantia</strong></td>	
								 <td class="niv4"><strong>N° Control</strong></td>								
                                <td class="niv4"><strong>Tipo Garantía</strong></td>
                                <td class="niv4"><strong>Proveedor</strong></td>
                                <td align="right" class="niv4"><strong>Monto</strong></td>
                                <td align="center" class="niv4"><strong>Moneda</strong></td>
                                <td class="niv4"><strong>Fecha</strong></td>
                                <td class="niv4"><strong>Estado</strong></td>
                            </tr>
                        </cfif>
						<cfif rsGarantiasXProceso.CMPid EQ rsReporte.CMPid>	
							<tr>
								<td>#rsGarantiasXProceso.GarantiaRecibo#</td>
								<td>#rsGarantiasXProceso.COEGNumeroControl#</td>								
								<td>#rsGarantiasXProceso.COEGTipoGarantia#</td>
								<td>#rsGarantiasXProceso.SNnombre#</td>
								<td align="right">#NumberFormat(rsGarantiasXProceso.COEGMontoTotal,',_.__')#</td>
								<td align="center">#rsGarantiasXProceso.Mnombre#</td>	
								<td>#LSDateFormat(rsGarantiasXProceso.COEGFechaRecibe,'dd/mm/yyyy')#</td>  
								<td>#rsGarantiasXProceso.COEGEstado#</td>							
							</tr>							
							<!---Encabezado detalle--->
							<tr>
								<td><strong>Detalles</strong></td>
								<td><strong>Doc.</strong></td>
								<td><strong>Tipo Rendición</strong></td>
								<td align="right"><strong>Monto</strong></td>
								<td align="center"><strong>Moneda</strong></td>
								<td><strong>Fecha Vencim.</strong></td>
								<td><strong>Banco</strong></td>
							</tr>
							<!---Detalles de Cada Garantia--->
								<cfflush interval="64">
								<cfloop query="rsDetalleGarantia">
									<cfif rsGarantiasXProceso.COEGid EQ rsDetalleGarantia.COEGid <!---and #rsGarantiasXProceso.CMPid# EQ #rsReporte.CMPid#--->>
										<tr>
											<td><strong></strong></td>
											<td>#rsDetalleGarantia.CODGNumeroGarantia#</td>
											<td>#rsDetalleGarantia.COTRDescripcion#</td>
											<td align="right">#NumberFormat(rsDetalleGarantia.CODGMonto,',_.__')#</td>											
											<td align="center">#rsDetalleGarantia.Mnombre#</td>
											<td>#DateFormat(rsDetalleGarantia.CODGFechaFin,'DD/MM/YYYY')#</td>
											<td>#rsDetalleGarantia.Bdescripcion#</td>
										</tr>
									</cfif>
								</cfloop>
							<!---FIN Detalles de Cada Garantia--->
                            <tr><td class="niv5" colspan="7">&nbsp;</td></tr>
							
							<!---Seguimiento GARANTIA--->
							<cfset LvarNombre = "f.Pnombre #_Cat# '' #_Cat# f.Papellido1 #_Cat# '' #_Cat# f.Papellido2">
                            <cfquery name="rsSeguimiento" datasource="#session.DSN#">
                                select	
                                	a.COSGid,
                                    a.COEGid,
                                    a.COSGObservacion,
                                    a.COSGFecha,
                                    a.COSGUsucodigo,
                                    b.COEGid,
                                    b.CMPid,
                                    #LvarNombre# as nombre
                                from COSeguiGarantia a
                                    inner join COHEGarantia b 
                                        on b.COEGid = a.COEGid
                                    inner join Usuario c
                                    	on c.Usucodigo = a.COSGUsucodigo
                                    left join CMProceso d
                                        on d.CMPid  = b.CMPid
									left outer join DatosPersonales f
										on  c.datos_personales= f.datos_personales	
                                where b.Ecodigo = #session.Ecodigo#
                                and b.COEGid = a.COEGid	
                                    and b.COEGVersionActiva= 1
                                    and b.COEGVersion = (select max(COEGVersion) from COHEGarantia x where b.COEGid = x.COEGid)
                                    and d.CMPid = #rsReporte.CMPid#
                                    and b.COEGid = #rsGarantiasXProceso.COEGid#
                                order by a.COSGid
                            </cfquery>
							<cfif isdefined("url.Seguimiento") and url.Seguimiento EQ 'on' and rsSeguimiento.recordcount gt 0>
									<tr>
										<td><strong><!---Detalles---></strong></td>
										<td><strong>Observaciones</strong></td>
										<td><strong>Usuario</strong></td>
										<td><strong>Fecha</strong></td>
										<td><strong>Observación</strong></td>
									</tr>
									<cfflush interval="64">
									<cfloop query="rsSeguimiento">
                                        <tr>
                                            <td><strong><!---Detalles---></strong></td>
                                            <td><strong><!---Detalles---></strong></td>
                                            <td>#rsSeguimiento.nombre#</td>
                                            <td>#DateFormat(rsSeguimiento.COSGFecha,'DD/MM/YYYY')#</td>
                                            <td>#rsSeguimiento.COSGObservacion#</td>	
                                        </tr>
									</cfloop> 
                                    <tr><td colspan="7" style="height:auto">&nbsp;</td></tr>						
							</cfif>
							<!---FIN Seguimiento GARANTIA--->
						</cfif>
					</cfloop>
					
					</cfif><!---fin si el proceso tenia garantias--->
					<!---FIN Garantias Por Proceso--->
			</cfloop>					
		</table>
		</cfoutput>
</cfif>