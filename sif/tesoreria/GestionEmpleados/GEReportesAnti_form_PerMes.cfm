<cf_templatecss>
<cf_htmlReportsHeaders 
	irA="GEReportesAnti_PerMes.cfm"
	FileName="Gestion Empleados.xls"
	title="Consulta"
>
<cfif not IsDefined("form.periodo") and not IsDefined("form.mes")>
	
	<script>
		alert('No se ha definido periodo o mes');
		history.back(-1)
	</script>
	
</cfif>

<!--- reporte de anticipos--->
<cfquery name="rsReporteA" datasource="#session.dsn#">
	select 
		gea.GEDEnsolicitud as GEAnumero, u.TESBeneficiario , a.GEAdescripcion, m.Miso4217, gea.GEDEmontototal,
		CASE 
		WHEN a.GEAestado = 0 THEN 'En Preparacion'
		WHEN a.GEAestado = 1 THEN 'En Aprobacion'
		WHEN a.GEAestado = 2 THEN 'Aprobada'
		WHEN a.GEAestado = 3 THEN 'Rechazada'
		WHEN a.GEAestado = 4 THEN 'Pagada'
		WHEN a.GEAestado = 5 THEN 'Liquidada'
		WHEN a.GEAestado = 6 THEN 'Terminado' END as EstadoAnticipo,
		gea.GEDEmes as mes,
		gea.GEDEperiodo as periodo,
		a.GEAfechaSolicitud,
		ssp.TESSPnumero,
		cf.CFdescripcion,
		a.GEAmanual as tipoCambio
		
	from 
		GEanticipoDetEmpleado gea 
		INNER JOIN GEanticipo a ON a.GEAid = gea.GEAid		
		INNER JOIN Monedas m ON m.Mcodigo = gea.GEDEidmoneda
		INNER JOIN TESbeneficiario u ON u.TESBid = gea.GEDEidempleado
		
		INNER JOIN CFuncional cf ON cf.CFid=a.CFid
		
		LEFT OUTER JOIN TESsolicitudPago ssp
		ON a.TESSPid = ssp.TESSPid
		
	WHERE
		gea.Ecodigo = #session.Ecodigo#
		AND gea.GELid IS NULL
		<cfif IsDefined("form.mes") and form.mes NEQ 'all' >
			AND gea.GEDEmes = #form.mes#
		</cfif>
		<cfif IsDefined("form.periodo") and form.periodo NEQ 'all' >
			AND gea.GEDEperiodo = #form.periodo#
		</cfif>

</cfquery>

<!--- reporte de liquidaciones --->
<cfquery name="rsReporteL" datasource="#session.dsn#">
	select 
		gea.GEDEnsolicitud as numeroL, u.TESBeneficiario, a.GELdescripcion, m.Miso4217, gea.GEDEmontototal, gea.GEDEreembolso,
		CASE 
		WHEN sp.TESSPestado = 2 THEN 'Aprobada'
		WHEN sp.TESSPestado = 10 THEN 'En Preparación OP' END as EstadoLiquidacion,
		gea.GEDEmes as mes,
		gea.GEDEperiodo as periodo,
		a.GELfecha,
		sp.TESSPnumero,
		a.GELtotalGastos, 
		a.GELtotalAnticipos,
		a.GELtotalDepositos,
		a.GELreembolso,
		cf.CFdescripcion,
		a.GELtipoCambio as tipoCambio
		
	from 
		GEanticipoDetEmpleado gea 				
		INNER JOIN Monedas m ON m.Mcodigo = gea.GEDEidmoneda
		INNER JOIN GEliquidacion a ON a.GELid = gea.GELid
		INNER JOIN TESsolicitudPago  sp on sp.TESSPid = a.TESSPid_Adicional
		INNER JOIN TESbeneficiario u ON u.TESBid = gea.GEDEidempleado
		
		INNER JOIN CFuncional cf ON cf.CFid=a.CFid
		
	WHERE
		gea.Ecodigo = #session.Ecodigo#
		<cfif IsDefined("form.mes") and form.mes NEQ 'all' >
			AND gea.GEDEmes = #form.mes#
		</cfif>
		<cfif IsDefined("form.periodo") and form.periodo NEQ 'all' >
			AND gea.GEDEperiodo = #form.periodo#
		</cfif>
		AND gea.GEAid IS NULL

</cfquery>

<style type="text/css">
	.RLTtopline 
	{
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color:#000000;
		border-top-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;		  
	}
	.par td
	{
		background:#f1f1f1;
	}
	.nones td, .par td
	{
		border-left:1px solid #fff;
		border-right:1px solid lightgray;
	}
</style>

<cfquery name="rsEmpresa" datasource="#session.dsn#">
	select Edescripcion 
	from Empresas
	where Ecodigo = #session.Ecodigo#
</cfquery>
	
<cfflush interval="64">
<table width="100%" cellpadding="0" cellspacing="0" border="0">	
	<tr class="listaPar">
		<td style="font-size:18px" colspan="12" align="center"><br/>
		<cfoutput>#rsEmpresa.Edescripcion#</cfoutput>
		</td>
	</tr>
	
	<tr class="listaPar" align="center">
		<td align="center">
			<cfoutput><strong>Fecha:</strong>#dateFormat(now(),'dd/mm/yyyy')#</cfoutput>
		</td>
	</tr>
	<tr class="listaPar" align="center">
		<td align="center"  style="font-size:16px" colspan="12">
			<strong>Reporte de Anticipos y Liquidaciones Pendientes al Cierre</strong>
		</td>
	</tr>
	<tr class="listaPar" align="center">
		<td align="center"  style="font-size:12px" colspan="12">
		<strong>Periodo: </strong><cfif IsDefined("form.periodo") and form.periodo NEQ 'all'><cfoutput>#form.periodo#</cfoutput><cfelse>Todos</cfif>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<strong>Mes: </strong><cfif IsDefined("form.mes") and form.mes NEQ 'all'><cfoutput>#form.mes#</cfoutput><cfelse>Todos</cfif>
		</td>
	</tr>
	<tr class="listaPar" align="center">
		<td align="center" >&nbsp;&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td nowrap="nowrap"colspan="12">&nbsp;</td>
	</tr>
	</table>	
	<table width="100%" cellpadding="2" cellspacing="0" border="0">
	<tr><td>
	<table width="100%" cellpadding="2" cellspacing="0" border="0">
	<tr bgcolor="CCCCCC" nowrap="nowrap" align="center" class="tituloListas"><td align="center" colspan="15">Anticipos Pendientes de Liquidar</td></tr>
		<tr bgcolor="CCCCCC" nowrap="nowrap" align="center" class="tituloListas">
			<td colspan="0" align="left" nowrap="nowrap">N° de <br/>Anticipo</td>
			<td colspan="1" align="left" nowrap="nowrap">Centro Funcional</td>
			<td colspan="0" align="left" nowrap="nowrap">Descripcion</td>
			<td colspan="0" align="left" nowrap="nowrap">Moneda</td>
			<td colspan="2" align="right" nowrap="nowrap">Monto</td>
			<td colspan="2" align="right" nowrap="nowrap">Tipo <br/> Cambio</td>
			<td colspan="2" align="right" nowrap="nowrap">Monto &nbsp;&nbsp;<br/>Moneda Local</td>
			<!---<td colspan="0" align="left" nowrap="nowrap">Estado</td>--->
			<td colspan="1" align="left" nowrap="nowrap">Solicitud <br/>de Pago</td>
			<td colspan="0" align="left" nowrap="nowrap">Fecha</td>			
			<td colspan="0" align="left" nowrap="nowrap">Beneficiario</td>	
			<cfif form.mes EQ 'all' AND form.periodo EQ 'all'>
			<td colspan="0" align="center" nowrap="nowrap">Periodo - Mes</td>
			</cfif>
		</tr>
		<cfset totalMontoLocal=0>
		<cfif  rsReporteA.recordcount GT 0>
			<cfset v1=0>
			<cfoutput query="rsReporteA">
				<tr class="<cfif v1 EQ 0><cfset v1=1>nones<cfelse><cfset v1=0>par</cfif>">
					<td align="left" style="font-size:9px">&nbsp; #rsReporteA.GEAnumero#&nbsp;</td>	
					<td align="left" style="font-size:9px" colspan="1">&nbsp; #rsReporteA.CFdescripcion#&nbsp;</td>	
					<td align="left" style="font-size:9px">&nbsp;#rsReporteA.GEAdescripcion#&nbsp;</td>
					<td align="left" style="font-size:9px">&nbsp;#rsReporteA.Miso4217#&nbsp;</td>
					<td align="right" style="font-size:9px" colspan="2">&nbsp;#LSNumberFormat(rsReporteA.GEDEmontototal, ",_.__")#&nbsp;</td>
					<td align="right" style="font-size:9px" colspan="2">&nbsp;#rsReporteA.tipoCambio#&nbsp;</td>
					<td align="right" style="font-size:9px" colspan="2">&nbsp;#LSNumberFormat((rsReporteA.GEDEmontototal*rsReporteA.tipoCambio), ",_.__")#&nbsp;</td>
					<!---<td align="left" style="font-size:9px">&nbsp;#rsReporteA.EstadoAnticipo#&nbsp;</td>--->
					<td align="left" style="font-size:9px" colspan="1">&nbsp;#rsReporteA.TESSPnumero#&nbsp;</td>
					<td align="left" style="font-size:9px">&nbsp;#LSDateFormat(rsReporteA.GEAfechaSolicitud,'DD-MM-YYYY')#&nbsp;</td>
					<td align="left" style="font-size:9px">&nbsp;#rsReporteA.TESBeneficiario#&nbsp;</td>
					<cfif form.mes EQ 'all' AND form.periodo EQ 'all'>
					<td align="center" style="font-size:9px">&nbsp;#rsReporteA.periodo#&nbsp;-&nbsp;#rsReporteA.mes#</td>
					</cfif>
				</tr>
				<cfset totalMontoLocal=totalMontoLocal+(rsReporteA.GEDEmontototal*rsReporteA.tipoCambio)>
			</cfoutput>
			<cfoutput>
			<tr bgcolor="lightgray">
				<td colspan="0" align="left" nowrap="nowrap"><b>Total:</b></td>
				<td colspan="5" align="right" nowrap="nowrap" style="font-size:9px">&nbsp;</td>
				<td colspan="4" align="right" nowrap="nowrap" style="font-size:9px">#LSNumberFormat(totalMontoLocal, ",_.__")#</td>
				<td colspan="4" align="left" nowrap="nowrap">&nbsp;</td>
			</tr>
			
			</cfoutput>
		</cfif>	
		</table></td></tr>
		<cfif rsReporteL.recordcount GT 0 >			
			<tr><td align="center" colspan="15">&nbsp;</td></tr>
			
			<tr><td>
			<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td align="center" class="tituloListas" colspan="15">Liquidaciones No Pagadas</td>
			</tr>
			<tr bgcolor="CCCCCC" nowrap="nowrap" align="center" class="tituloListas">
				<td colspan="0" align="left" nowrap="nowrap">N° Liquidaci&oacute;n</td>	
				<td colspan="0" align="left" nowrap="nowrap">Centro Funcional</td>	
				<td colspan="0" align="left" nowrap="nowrap">Descripcion</td>
				<td colspan="0" align="left" nowrap="nowrap">Moneda</td>
				<td colspan="0" align="right" nowrap="nowrap">Gasto</td>
				<td colspan="0" align="right" nowrap="nowrap">Anticipos</td>
				<td colspan="0" align="right" nowrap="nowrap">Depositos</td>
				<td colspan="0" align="right" nowrap="nowrap">Reembolso</td>
				<td colspan="0" align="center" nowrap="nowrap">Tipo <br/> Cambio</td>
				<td colspan="0" align="center" nowrap="nowrap">Reembolso<br/>Moneda Local</td>
				<!---<td colspan="0" align="left" nowrap="nowrap">Estado</td>--->
				<td colspan="0" align="left" nowrap="nowrap">Solicitud de <br/>Pago Generada</td>
				<td colspan="0" align="left">Fecha</td>				
				<td colspan="0" align="left" nowrap="nowrap">Beneficiario</td>
				<cfif form.mes EQ 'all' AND form.periodo EQ 'all'>
				<td colspan="0" align="center">Periodo - Mes</td>
				</cfif>
			</tr>
			<cfset v1=0>
			<cfset totalMontoLocal=0>
			<cfoutput query="rsReporteL">				
				<tr class="<cfif v1 EQ 0><cfset v1=1>nones<cfelse><cfset v1=0>par</cfif>">
					<td align="left" style="font-size:9px">&nbsp;#rsReporteL.numeroL#&nbsp;</td>
					<td align="left" style="font-size:9px">&nbsp;#rsReporteL.CFdescripcion#&nbsp;</td>
					<td align="left" style="font-size:9px">&nbsp;#rsReporteL.GELdescripcion#&nbsp;</td>
					<td align="left" style="font-size:9px">&nbsp;#rsReporteL.Miso4217#&nbsp;</td>
					<td align="right" style="font-size:9px">&nbsp;#LSNumberFormat(rsReporteL.GEDEmontototal, ",_.__")#&nbsp;</td>
					<td align="right" style="font-size:9px">&nbsp;#LSNumberFormat(rsReporteL.GELtotalAnticipos, ",_.__")#&nbsp;</td>
					<td align="right" style="font-size:9px">&nbsp;#LSNumberFormat(rsReporteL.GELtotalDepositos, ",_.__")#&nbsp;</td>
					<td align="right" style="font-size:9px">&nbsp;#LSNumberFormat(rsReporteL.GEDEreembolso, ",_.__")#&nbsp;</td>
					<td align="right" style="font-size:9px">&nbsp;#rsReporteL.tipoCambio#&nbsp;</td>
					<td align="right" style="font-size:9px">&nbsp;#LSNumberFormat((rsReporteL.GEDEreembolso*rsReporteL.tipoCambio), ",_.__")#&nbsp;</td>
					<!---<td align="left" style="font-size:9px">&nbsp;#rsReporteL.EstadoLiquidacion#&nbsp;</td>--->
					<td align="left" style="font-size:9px">&nbsp;#rsReporteL.TESSPnumero#&nbsp;</td>
					<td align="left" style="font-size:9px">&nbsp;#LSDateFormat(rsReporteL.GELfecha,'DD-MM-YYYY')#&nbsp;</td>					
					<td align="left" style="font-size:9px">&nbsp;#rsReporteL.TESBeneficiario#&nbsp;</td>
					<cfif form.mes EQ 'all' AND form.periodo EQ 'all'>
					<td align="center" style="font-size:9px">&nbsp;#rsReporteL.periodo#&nbsp;-&nbsp;#rsReporteL.mes#</td>
					</cfif>
				</tr>
				
				<cfset totalMontoLocal=totalMontoLocal+(rsReporteL.GEDEreembolso*rsReporteL.tipoCambio)>
			</cfoutput>
			<cfoutput>
			<tr bgcolor="lightgray">
				<td colspan="0" align="left" nowrap="nowrap"><b>Total:</b></td>
				<td colspan="4" align="right" style="font-size:9px" nowrap="nowrap">&nbsp;</td>
				<td colspan="1" align="right" style="font-size:9px" nowrap="nowrap">&nbsp;</td>
				<td colspan="1" align="right" style="font-size:9px" nowrap="nowrap">&nbsp;</td>
				<td colspan="1" align="right" style="font-size:9px" nowrap="nowrap">&nbsp;</td>
				<td colspan="2" align="right" style="font-size:9px" nowrap="nowrap">#LSNumberFormat(totalMontoLocal, ",_.__")#</td>
				<td colspan="4" align="left" nowrap="nowrap">&nbsp;</td>
			</tr>
			</cfoutput>
		
		</cfif>
		<cfif rsReporteL.recordcount EQ 0 AND rsReporteA.recordcount EQ 0>
			<tr>
				<td align="center" colspan="15" style="font-size:9px">-----------------    No se encontraron Registros    -----------------</td>
			</tr>
		</cfif>
		</table>
		</td></tr>
	</table>
	<br/>
	<table width="100%" align="center">
		<tr>
			<td align="center" colspan="15" style="font-size:9px">-----------------    FIN DEL REPORTE    -----------------</td>
		</tr>
	</table>
