<cf_htmlReportsHeaders
		title="Historico de Garantías" 
		filename="Documentos.xls"
		irA="VencimientoDocGarantias.cfm">
	<cfquery name="rsDetalleGarantia" datasource="#session.DSN#" maxrows="5001">
		select 
        	a.CODGFechaFin, 
            a.CODGid, 
            c.CMPid, 
            d.SNnombre,
            case when b.COEGTipoGarantia = 1 
			then 
            	'Participación' 
            else 
            	'Cumplimiento' 
           end as COEGTipoGarantia,
           a.CODGNumeroGarantia, 
		   a.COTRid, 
           b.COEGid, 
           b.COEGReciboGarantia,
		   b.COEGVersion,
           a.CODGMonto, 
		   h.Msimbolo,
           h.Mnombre, 
           g.Bdescripcion, 
           c.CMPProceso, 
		   f.COTRCodigo,
		   f.COTRDescripcion, 
           b.COEGPersonaEntrega,
           b.COEGIdentificacion,
		   b.COEGNumeroControl
       	from COHDGarantia a
		inner join COHEGarantia b
			on b.COEGid = a.COEGid
			and b.COEGVersion = a.COEGVersion 
		left join CMProceso c
		on c.CMPid  = b.CMPid
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
		and COEGEstado not in (2,5,7,8)	
		<!--- Tipo de transacción --->
		<cfif isdefined("form.Proceso") and len(trim(form.Proceso)) and form.Proceso NEQ '-1'>
			and c.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Proceso#">
		</cfif>
		<cfif isdefined('form.SNnumero1') and Len(trim(form.SNnumero1))>
			and d.SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumero1#">
		</cfif>
		<!--- Fechas Desde / Hasta --->
		 <cfif isdefined("form.fechaDes") and len(trim(form.fechaDes)) and isdefined("form.fechaHas") and len(trim(form.fechaHas))>					
			<cfif datecompare(form.fechaDes, form.fechaHas) eq -1> 
				and a.CODGFechaFin between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#"> 
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaHas)#">
			<cfelseif datecompare(form.fechaDes, form.fechaHas) eq 1>
				and a.CODGFechaFin between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaHas)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">
			<cfelseif datecompare(form.fechaDes, form.fechaHas) eq 0>
				and a.CODGFechaFin between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaHas)#">
			</cfif>
		<cfelseif isdefined("form.fechaDes") and len(trim(form.fechaDes))>
			and a.CODGFechaFin >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaDes)#">
		<cfelseif isdefined("form.fechaHas") and len(trim(form.fechaHas))>
			and a.CODGFechaFin <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fechaHas)#">
		</cfif> 
		<cfif isdefined("form.Trendicion") and len(trim(form.Trendicion)) and form.Trendicion neq -1>
				and f.COTRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Trendicion#">
	    </cfif> 					
	order by a.CODGFechaFin,c.CMPid,b.SNid
	</cfquery>
	
	<cfif isdefined("rsDetalleGarantia") and rsDetalleGarantia.recordcount gt 5000>
		<cf_errorCode	code = "50196" msg = "Se han generado mas de 5000 registros para este reporte.">
		<cfabort>
	</cfif>
<style type="text/css"> 
     * { font-size:12px; font-family:Verdana, Arial, Helvetica, sans-serif }
	.encabezado{
		text-align:center;
		font-size:24px;
		font-weight:bolder;
	}
	.titulos{
		background-color:#E3EDEF;
		text-align:center;
		font-weight:bold;
	}
</style>	


	<cfoutput>
		<table cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td colspan="23" class="encabezado">#session.Enombre#</td>
			</tr>
			<tr>
				<td colspan="23" class="encabezado">Documentos de Garantías Vencidos</td>
			</tr>	
			<tr>
				<td colspan="23">&nbsp;</td>
			</tr>		
			 <tr>
				<td class="titulos">Fecha Vencim.	</td><td class="titulos">&nbsp;&nbsp;&nbsp;&nbsp;</td>				
				<td class="titulos">Provedor		</td><td class="titulos">&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td class="titulos">Clase			</td><td class="titulos">&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td class="titulos">Tipo			</td><td class="titulos">&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td class="titulos">N° Control		</td><td class="titulos">&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td class="titulos">N°Garantia		</td><td class="titulos">&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td class="titulos">Recibo			</td><td class="titulos">&nbsp;&nbsp;&nbsp;&nbsp;</td>				
				<td class="titulos">Monto			</td><td class="titulos">&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td class="titulos">Banco			</td><td class="titulos">&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td class="titulos">Proceso</td><td class="titulos">&nbsp;&nbsp;&nbsp;&nbsp;</td>
		    </tr>	
			<cfflush interval="64">
			<cfset LvarLinea= 1>
 			<cfloop query="rsDetalleGarantia"><!---Procesos segun filtro--->
				<!---Detalles de Cada Garantia--->
                <tr>
					<td nowrap="nowrap"> #DateFormat(rsDetalleGarantia.CODGFechaFin,'DD/MM/YYYY')#			</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td nowrap="nowrap">#rsDetalleGarantia.SNnombre#										</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td nowrap="nowrap">#rsDetalleGarantia.COEGTipoGarantia#								</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    <td nowrap="nowrap">#rsDetalleGarantia.COTRCodigo#									    </td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>								
					<td nowrap="nowrap">#rsDetalleGarantia.COEGNumeroControl#   	    					</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>								
                    <td nowrap="nowrap" align="left">#rsDetalleGarantia.CODGNumeroGarantia#				    </td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td nowrap="nowrap" align="center">#rsDetalleGarantia.COEGReciboGarantia#-#rsDetalleGarantia.COEGVersion#</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>													
                    <td nowrap="nowrap" align="right">#rsDetalleGarantia.Msimbolo##NumberFormat(rsDetalleGarantia.CODGMonto,',_.__')#	</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>																			
                    <td width="20%" nowrap="wrap">#rsDetalleGarantia.Bdescripcion#									</td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td  width="45%">#rsDetalleGarantia.CMPProceso#</td>                     
				</tr>
				<!---FIN Detalles de Cada Garantia--->				
			</cfloop>
			<tr>
			    <td  align="center" colspan="23">&nbsp;</td>
			</tr>	
			<tr>
				<td  align="center" colspan="23">--------------------- Última línea  ---------------------</td>
			</tr>					
	</table>
	</cfoutput>
