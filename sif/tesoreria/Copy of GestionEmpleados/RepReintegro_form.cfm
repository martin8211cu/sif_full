<cf_htmlReportsHeaders 
		title="Impresion Reintegro" 
		filename="Reintegro.xls"
		irA="RepReintegros.cfm?band=1"
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
		<td colspan="8" align="center"><strong>Reintegro:</strong>#rs1.CCHcod#</td>
	</tr>
	<tr>
		<td colspan="8" align="center"><strong>Fecha:</strong>#LSDateFormat(now(),"DD/MM/YYYY")#</td>
	</tr>
	<tr>
		<td colspan="8" align="center"><strong>Caja Chica:</strong>#rs1.cod#-#rs1.descrip#</td>
	</tr>
	<tr>
		<td colspan="8" align="center"><strong>Custodio:</strong>#rs1.name#</td>
	</tr>
	<tr>
		<td colspan="8" align="center"><strong>Solicitud Pago:</strong><cfif isdefined('rsSP')> #rsSP.TESSPnumero# <cfelse> No se ha emitido</cfif></td>
	</tr>
	<tr>
		<td colspan="8" align="center"><strong>Orden Pago:</strong><cfif isdefined('rsSP')> #rsSP.TESOPnumero# <cfelse> No se ha emitido</cfif> </td>
	</tr>
	<tr>
		<td align="center" class="RLTtopline" bgcolor="CCCCCC" colspan="8">Detalles del Reintegro</td>
	</tr>
	<cfset total=0>
	<cfloop query="rsSQL">
		<cfquery name="rs2" datasource="#session.dsn#">
			select a.CCHTrelacionada,(select GELnumero from GEliquidacion where GELid=a.CCHTrelacionada) as num from CCHTransaccionesProceso a where a.CCHTid=#rsSQL.CCHTAtranRelacionada#
		</cfquery>
		<tr>
			<td class="listaPar" colspan="8"><strong>Liquidación:</strong>#rs2.num#</td>
		</tr>
		<tr>
				<td><strong>Documento</strong></td>
				<td><strong>Monto Original</strong></td>
				<td><strong>Moneda</strong></td>
				<td><strong>Tipo de Cambio</strong></td>
				<td><strong>Monto Total</strong></td>
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
	<tr><td align="right" colspan="8"><strong>Total:</strong>#total#</td></tr>

</table>
</cfoutput>

