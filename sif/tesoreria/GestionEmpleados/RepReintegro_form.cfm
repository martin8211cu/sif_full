<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ImpresionReintegro" default = "Impresion Reintegro" returnvariable="LB_ImpresionReintegro" xmlfile = "RepReintegro_form.xml">

<cf_htmlReportsHeaders 
		title="#LB_ImpresionReintegro#" 
		filename="Reintegro.xls"
		irA="RepReintegros#LvarCFM#.cfm?band=1"
		download="no"
		preview="no">


<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<style type="text/css">
		 .RLTtopline {
		  border-bottom-width: 1px;
		  border-bottom-style: solid;
		  border-bottom-color:#000000;
		  border-top-color: #000000;
		  border-top-width: 1px;
		  border-top-style: solid;
		  
		 } 
</style>

<cfquery name="rs1" datasource="#session.dsn#">
	select a.CCHcod,CCHTrelacionada,  
	(select CCHcodigo from CCHica where CCHid=a.CCHid) as cod,
	(select CCHdescripcion from CCHica where CCHid=a.CCHid) as descrip,
	(select DEnombre #LvarCNCT# ' '#LvarCNCT# DEapellido1 #LvarCNCT# ' ' #LvarCNCT# DEapellido2  from DatosEmpleado where DEid=(select CCHresponsable from CCHica where CCHid=a.CCHid)) as name,
    a.CCHTmonto
	 from CCHTransaccionesProceso a
	 where CCHTid=#form.CCHTid#
</cfquery>
<cfquery name="rsSQL" datasource="#session.dsn#">
	select CCHTAtranRelacionada
	from CCHTransaccionesAplicadas
	where CCHTAreintegro=#form.CCHTid#
	and CCHTtipo='GASTO'
</cfquery>

<cfif len(trim(#rs1.CCHTrelacionada#))>
	<cfquery name="rsSP" datasource="#session.dsn#">
		select TESSPnumero,TESOPnumero 
		from TESsolicitudPago sp
			left join TESordenPago op
				on op.TESOPid=sp.TESOPid
		where TESSPid=   #rs1.CCHTrelacionada#
	</cfquery>
</cfif>

<cfoutput>
<table width="100%">
	<tr>
		<td colspan="8" align="center"><strong><cf_translate key = LB_Reintegro xmlfile = "RepReintegro_form.xml">Reintegro</cf_translate>:</strong>#rs1.CCHcod#</td>
	</tr>
	<tr>
		<td colspan="8" align="center"><strong><cf_translate key = LB_Fecha xmlfile = "RepReintegro_form.xml">Fecha</cf_translate>:</strong>#LSDateFormat(now(),"DD/MM/YYYY")#</td>
	</tr>
	<tr>
		<td colspan="8" align="center"><strong><cf_translate key = LB_CajaChica xmlfile = "RepReintegro_form.xml">Caja Chica</cf_translate>:</strong>#rs1.cod#-#rs1.descrip#</td>
	</tr>
	<tr>
		<td colspan="8" align="center"><strong><cf_translate key = LB_Custodio xmlfile = "RepReintegro_form.xml">Custodio</cf_translate>:</strong>#rs1.name#</td>
	</tr>
	<tr>
		<td colspan="8" align="center"><strong><cf_translate key = LB_SolicitudPago xmlfile = "RepReintegro_form.xml">Solicitud Pago</cf_translate>:</strong><cfif isdefined('rsSP')> #rsSP.TESSPnumero# <cfelse> <cf_translate key = LB_NoSeHaEmitido xmlfile = "RepReintegro_form.xml">No se ha emitido</cf_translate></cfif></td>
	</tr>
	<tr>
		<td colspan="8" align="center"><strong><cf_translate key = LB_OrdenPago xmlfile = "RepReintegro_form.xml">Orden Pago</cf_translate>:</strong><cfif isdefined('rsSP')> #rsSP.TESOPnumero# <cfelse><cf_translate key = LB_NoSeHaEmitido xmlfile = "RepReintegro_form.xml">No se ha emitido</cf_translate></cfif> </td>
	</tr>
	<tr>
		<td align="center" class="RLTtopline" bgcolor="CCCCCC" colspan="8"><cf_translate key = LB_DetalleReintegro xmlfile = "RepReintegro_form.xml">Detalles del Reintegro</cf_translate></td>
	</tr>
	<cfset total=0>
	<cfloop query="rsSQL">
		<cfquery name="rs2" datasource="#session.dsn#">
			select a.CCHTrelacionada,(select GELnumero from GEliquidacion where GELid=a.CCHTrelacionada) as num from CCHTransaccionesProceso a where a.CCHTid=#rsSQL.CCHTAtranRelacionada#
		</cfquery>
		<tr>
			<td class="listaPar" colspan="8"><strong><cf_translate key = LB_Liquidacion xmlfile = "RepReintegro_form.xml">Liquidación</cf_translate>:</strong>#rs2.num#</td>
		</tr>
		<tr>
				<td><strong><cf_translate key = LB_Documento xmlfile = "RepReintegro_form.xml">Documento</cf_translate></strong></td>
				<td><strong><cf_translate key = LB_MontoOriginal xmlfile = "RepReintegro_form.xml">Monto Original</cf_translate></strong></td>
				<td><strong><cf_translate key = LB_Moneda xmlfile = "RepReintegro_form.xml">Moneda</cf_translate></strong></td>
				<td><strong><cf_translate key = LB_TipoCambio xmlfile = "RepReintegro_form.xml">Tipo de Cambio</cf_translate></strong></td>
				<td><strong><cf_translate key = LB_MontoTotal xmlfile = "RepReintegro_form.xml">Monto Total</cf_translate></strong></td>
		</tr>
	
				<cfquery name="rsSQL1" datasource="#session.dsn#">
					select a.GELGnumeroDoc,a.GELGtotalOri,a.GELGtipoCambio,
					a.Mcodigo,a.GELGtotal,
					(select Miso4217 from Monedas where Mcodigo=a.Mcodigo) as moneda
					from GEliquidacionGasto a
					where GELid=#rs2.CCHTrelacionada# 
				</cfquery>
				
			<cfloop query="rsSQL1">

					<tr>
						<td>#rsSQL1.GELGnumeroDoc#</td>
						<td>#rsSQL1.GELGtotalOri#</td>
						<td>#rsSQL1.moneda#</td>
						<td>#rsSQL1.GELGtipoCambio#</td>
						<td>#rsSQL1.GELGtotal#</td>
					</tr>
					<cfset total=total+#rsSQL1.GELGtotal#>
			</cfloop>
	</cfloop>
	<tr><td align="right" colspan="8"><strong><cf_translate key = LB_Total xmlfile = "RepReintegro_form.xml">Total</cf_translate>:</strong>#total#</td></tr>

</table>
</cfoutput>

