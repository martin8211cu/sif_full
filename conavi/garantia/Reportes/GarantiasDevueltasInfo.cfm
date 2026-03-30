<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
	<cf_htmlReportsHeaders 
		filename="Documentos.xls"
		irA="GarantiasDevueltas.cfm">	

	<cfif isdefined("form.fechaHas") and len(trim(form.fechaHas))>
	   <cfset LvarHasta = form.fechaHas>
	   <cfset StrucHasta = StructNew()>
	   <cfset LvarHastaPos = listlen(LvarHasta,'/')>
		
		<cfset VarDia = listgetat(LvarHasta,1,'/')>
		<cfset VarMes = listgetat(LvarHasta,2,'/')>
		<cfset VarAno = listgetat(LvarHasta,3,'/')>
			
		<cfset LvarHas =#CreateDatetime(VarAno,VarMes,VarDia,00,00,00)#>
		<cfset LvarHas = dateAdd("d",1,LvarHas)>
		<cfset LvarHas = dateAdd("s",-1,LvarHas)>
	</cfif>
	 <cfquery name="rsGarantiasXProceso" datasource="#session.DSN#" maxrows="5001">
		select
		     a.CMPProceso,a.CMPid,a.CMPMontoProceso, MP.Mnombre   as MonedaProc,
        	d.CODGid,
            d.CODGNumeroGarantia,
			d.CODGFechaFin,
            d.CODGMonto,
            MD.Mnombre as MonedaDet,
        	f.COTRDescripcion,            
            bd.Bdescripcion,
						 
        	 b.COEGFechaRecibe, 
			b.COEGid,
            case when b.COEGTipoGarantia = 1 
	            then 'Participación' 
    	        else 'Cumplimiento' 
            end as COEGTipoGarantia, 
            c.SNnombre, 
            b.COEGMontoTotal, 
            g.Mnombre,            
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
            b.COEGReciboGarantia ,
			b.COEGVersion,
            b.COEGNumeroControl,
			b.COEGFechaDevOEjec,
			cl.COLGnumeroControl,
			cl.COLGfechaDevolucion,
			cl.COLGObservacion			  
        from COHEGarantia b
		    inner join COHDGarantia d
			  on b.COEGid = d.COEGid
			  and b.COEGVersion = d.COEGVersion
			inner join  COLiberaGarantia cl
			  on b.COEGid = cl.COEGid 
			left join CMProceso a
				on b.CMPid  = a.CMPid
			inner join SNegocios c
				on c.SNid = b.SNid
			inner join Monedas g
				on g.Mcodigo = b.Mcodigo  	
			inner join Monedas MP
				on MP.Mcodigo = b.Mcodigo  
			inner join Monedas MD
				on MD.Mcodigo = d.CODGMcodigo
			inner join COTipoRendicion f
				on 	f.COTRid = d.COTRid
			inner join Bancos bd
				on bd.Bid = d.Bid		
						
        where b.Ecodigo = #session.Ecodigo#	
			and b.COEGVersionActiva= 1	
			and b.COEGEstado = 8		
			<!--- Fechas Desde / Hasta --->
			<cfif isdefined("form.fechaDes") and len(trim(form.fechaDes))>
				and b.COEGFechaDevOEjec >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">
				<!---cl.COLGfechaDevolucion---->
		    </cfif>
			<cfif isdefined("form.fechaHas") and len(trim(form.fechaHas))>
				and b.COEGFechaDevOEjec <= <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarHas#">
			</cfif>				 					
		order by b.COEGFechaDevOEjec, b.COEGFechaRecibe
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

	<cfoutput>
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td colspan="10" align="center" style="font-size:24px;font-weight:bolder">#session.Enombre#</td>
			</tr>
			<tr>
				<td colspan="10" align="center" style="font-size:18px;font-weight:bolder">Detalle de Garantías Devueltas</td>
			</tr>	



			<cfset LvarGarantia= "">
			<cfloop query="rsGarantiasXProceso"><!---Procesos segun filtro--->
						
 			 <cfif  LvarGarantia  neq rsGarantiasXProceso.COEGid>
				<tr><td colspan="10">&nbsp;</td></tr>
				<cfif len(rtrim(rsGarantiasXProceso.CMPProceso)) gt 0>
				<tr bgcolor="##E3EDEF"><!---Encabezado Procesos--->
					<td colspan="10" align="left" class="niv2"><strong class="niv2">Proceso:&nbsp;</strong>#rsGarantiasXProceso.CMPProceso# &nbsp;&nbsp;
					<strong class="niv2">Monto:&nbsp;</strong>#NumberFormat(rsGarantiasXProceso.CMPMontoProceso,',_.__')#&nbsp;&nbsp;					
					<strong class="niv2">Moneda:&nbsp;</strong>#rsGarantiasXProceso.MonedaProc#
					</td>
				</tr>
				</cfif>
				
				<!---Garantias Por Proceso--->
					
                            <tr bgcolor="##E3EDEF"><!---Encabezado garantias--->
                                
								<td class="niv4"><strong>Rec. Devolucion</strong></td>
								<td class="niv4"><strong>Fecha Devolución</strong></td>
								<td class="niv4"><strong>Garantia</strong></td>		
								<td class="niv4"><strong>Número Control</strong></td>	
								<td class="niv4"><strong>Fecha</strong></td>					
                                <td class="niv4"><strong>Tipo Garantía</strong></td>
                                <td class="niv4"><strong>Proveedor</strong></td>
                                <td align="right" class="niv4"><strong>Monto</strong></td>
                                <td align="center" class="niv4"><strong>Moneda</strong></td>
                                <td class="niv4"><strong>Observación</strong></td>
                            </tr>
                   
							<tr>
								<td>#rsGarantiasXProceso.COLGnumeroControl#</td>
								<td>#LSDateFormat(rsGarantiasXProceso.COEGFechaDevOEjec,'dd/mm/yyyy')#</td>  
								<td>#rsGarantiasXProceso.COEGReciboGarantia#-#rsGarantiasXProceso.COEGVersion#</td>							
								<td>#rsGarantiasXProceso.COEGNumeroControl#</td>
								<td>#LSDateFormat(rsGarantiasXProceso.COEGFechaRecibe,'dd/mm/yyyy')#</td>  
								<td>#rsGarantiasXProceso.COEGTipoGarantia#</td>
								<td>#rsGarantiasXProceso.SNnombre#</td>
								<td align="right">#NumberFormat(rsGarantiasXProceso.COEGMontoTotal,',_.__')#</td>
								<td align="center">#rsGarantiasXProceso.Mnombre#</td>	
								<td>#rsGarantiasXProceso.COLGObservacion	#</td>							
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
				 			<cfset LvarGarantia=#rsGarantiasXProceso.COEGid#>
						</cfif>	
							
							<tr>
								<td><strong></strong></td>
								<td>#rsGarantiasXProceso.CODGNumeroGarantia#</td>
								<td>#rsGarantiasXProceso.COTRDescripcion#</td>
								<td align="right">#NumberFormat(rsGarantiasXProceso.CODGMonto,',_.__')#</td>											
								<td align="center">#rsGarantiasXProceso.MonedaDet#</td>
								<td>#DateFormat(rsGarantiasXProceso.CODGFechaFin,'DD/MM/YYYY')#</td>
								<td>#rsGarantiasXProceso.Bdescripcion#</td>
							</tr>							
							<!---FIN Detalles de Cada Garantia--->
                            
							
                         			
			</cfloop>
            			    <tr align="center">
							 <td colspan="10" align="center">&nbsp;
							    
							 </td>							    
							</tr>	
						   <tr align="center">
							 <td colspan="10" align="center">
							    -------- FIN Detalle de Cada Garantias Recibidas ------
							 </td>							    
							</tr>						
		</table>
		</cfoutput>