<style type="text/css">
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>

<cfif isdefined("url.TDcodigoini") and not isdefined("form.TDcodigoini")>
	<cfset form.TDcodigoini = url.TDcodigoini >
</cfif>
<cfif isdefined("url.TDcodigofin") and not isdefined("form.TDcodigofin")>
	<cfset form.TDcodigofin = url.TDcodigofin >
</cfif>

<cfif isdefined("url.DEidentificacion1") and not isdefined("form.DEidentificacion1")>
	<cfset form.DEidentificacion1 = url.DEidentificacion1 >
</cfif>
<cfif isdefined("url.DEidentificacion2") and not isdefined("form.DEidentificacion2")>
	<cfset form.DEidentificacion2 = url.DEidentificacion2 >
</cfif>

<!--- le da vuelta a los codigos, si aplica el caso --->
<cfif isdefined("form.TDcodigoini") and len(trim(form.TDcodigoini)) and isdefined("form.TDcodigofin") and len(trim(form.TDcodigofin))>
	<cfif CompareNoCase(form.TDcodigoini, form.TDcodigofin) gt 0 >
		<cfset tmp = form.TDcodigoini >
		<cfset form.TDcodigoini = form.TDcodigofin >
		<cfset form.TDcodigofin = tmp >
	</cfif>
</cfif>

<cfif isdefined("form.DEidentificacion1") and len(trim(form.DEidentificacion1)) and isdefined("form.DEidentificacion2") and len(trim(form.DEidentificacion2))>
	<cfif CompareNoCase(form.DEidentificacion1, form.DEidentificacion2) gt 0 >
		<cfset tmp = form.DEidentificacion1 >
		<cfset form.DEidentificacion1 = form.DEidentificacion2 >
		<cfset form.DEidentificacion2 = tmp >
	</cfif>
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="data" datasource="#session.DSN#">
	select 	a.DEid,
			c.DEnombre #_Cat# ' ' #_Cat# c.DEapellido1 #_Cat# ' ' #_Cat# c.DEapellido2 as DEnombre,
			c.DEidentificacion,
			a.Dreferencia, 
			b.TDcodigo,
			b.TDdescripcion,  
			a.Dfechaini, 
			a.Dmonto, 
			a.Dmonto - a.Dsaldo as Dmontopagado, 
			a.Dsaldo,
			a.Dfechadoc
	from DeduccionesEmpleado a
	
	inner join TDeduccion b
	  on a.TDid=b.TDid
	  and a.Ecodigo=b.Ecodigo
	  and b.TDfinanciada=1
	  and a.Dsaldo > 0
	  
	<cfif isdefined("form.TDcodigoini") and len(trim(form.TDcodigoini)) and isdefined("form.TDcodigofin") and len(trim(form.TDcodigofin))>
		and b.TDcodigo between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TDcodigoini#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TDcodigofin#">
	<cfelseif isdefined("form.TDcodigoini") and len(trim(form.TDcodigoini))>
		and b.TDcodigo >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TDcodigoini#">
	<cfelseif isdefined("form.TDcodigofin") and len(trim(form.TDcodigofin))>
		and b.TDcodigo <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TDcodigofin#">
	</cfif>
	
	inner join DatosEmpleado c
	  on a.DEid=c.DEid
	  and a.Ecodigo=c.Ecodigo
	  
	<cfif isdefined("form.DEidentificacion1") and len(trim(form.DEidentificacion1)) and isdefined("form.DEidentificacion2") and len(trim(form.DEidentificacion2))>
		and c.DEidentificacion between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEidentificacion1#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEidentificacion2#">
	<cfelseif isdefined("form.DEidentificacion1") and len(trim(form.DEidentificacion1))>
		and c.DEidentificacion >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEidentificacion1#">
	<cfelseif isdefined("form.DEidentificacion2") and len(trim(form.DEidentificacion2))>
		and c.DEidentificacion <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEidentificacion2#">
	</cfif>
	
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	
	and exists (
		select 1
		from DeduccionesEmpleadoPlan x
		where x.Did = a.Did
	)
	
	order by c.DEidentificacion 
</cfquery>

<cfoutput>

<table width="99%" cellpadding="0" cellspacing="0">
	<tr><td align="center"><font size="5">#session.enombre#</font></td></tr>
	<tr><td align="center">Saldos Totales por Empleado</td></tr>
	<tr><td align="center"><strong>Fecha:</strong> #LSDateFormat(Now(),'dd/mm/yyyy')#  &nbsp; <strong>Hora:</strong> #TimeFormat(Now(), "hh:mm:ss tt")#</td></tr>
	<tr><td align="center">&nbsp;</td></tr>
</table>
<br>

<cfif data.recordcount gt 0 >
	<table width="99%" cellpadding="0" cellspacing="0" align="center">
		<cfset corte = '' >
		<!--- totales por empleado--->
		<cfset vMontoTotal  = 0 >
		<cfset vMontoPagado = 0 >
		<cfset vSaldo       = 0 >
	
		<!--- totales generales --->
		<cfset vMontoTotalGeneral  = 0 >
		<cfset vMontoPagadoGeneral = 0 >
		<cfset vSaldoGeneral       = 0 >
		<cfloop query="data">
			<cfif corte neq data.DEid>
				<cfif data.CurrentRow neq 1>
					<tr>
						<td class="topLine"><strong>Total</strong></td>
						<td class="topLine" colspan="4" align="right"><strong>#LSNumberFormat(vMontoTotal,',9.00')#</strong></td>
						<td class="topLine" align="right"><strong>#LSNumberFormat(vMontoPagado,',9.00')#</strong></td>
						<td class="topLine" align="right"><strong>#LSNumberFormat(vSaldo,',9.00')#</strong></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>&nbsp;</td></tr>
				</cfif>
				<tr><td colspan="7"><strong><font size="2">#data.DEidentificacion#</font></strong>&nbsp;<strong><font size="2">#data.DEnombre#</font></strong></td></tr>
	
				<tr class="tituloListas">
					<td><strong>Documento</strong></td>
					<td><strong>Deducci&oacute;n</strong></td>
					<td><strong>Fecha Doc.</strong></td>
					<td><strong>Fecha Inicio</strong></td>
					<td align="right"><strong>Monto Total</strong></td>
					<td align="right"><strong>Monto Pagado</strong></td>
					<td align="right"><strong>Saldo</strong></td>
				</tr>
				<cfset vMontoTotal  = 0 >
				<cfset vMontoPagado = 0 >
				<cfset vSaldo = 0 >
			</cfif>
	
			<tr class="<cfif data.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
				<td nowrap>#data.Dreferencia#</td>
				<td nowrap>#data.TDcodigo# - #data.TDdescripcion#</td>
				<td>#LSDateFormat(data.Dfechadoc,'dd/mm/yyyy')#</td>
				<td>#LSDateFormat(data.Dfechaini,'dd/mm/yyyy')#</td>
				<td align="right" nowrap>#LSNumberFormat(data.Dmonto,',9.00')#</td>
				<td align="right" nowrap>#LSNumberFormat(data.Dmontopagado,',9.00')#</td>
				<td align="right" nowrap>#LSNumberFormat(Dsaldo,',9.00')#</td>
			</tr>
			<cfset corte = data.DEid >
	
			<!--- totales por empleado --->
			<cfset vMontoTotal  = vMontoTotal + data.Dmonto >
			<cfset vMontoPagado = vMontoPagado + data.Dmontopagado >
			<cfset vSaldo = vSaldo + data.Dsaldo >
	
			<!--- totales generales --->
			<cfset vMontoTotalGeneral  = vMontoTotalGeneral + data.Dmonto>
			<cfset vMontoPagadoGeneral = vMontoPagadoGeneral + data.Dmontopagado>
			<cfset vSaldoGeneral       = vSaldoGeneral + data.Dsaldo>
		</cfloop>
		
		<!--- pinta el ultimo total --->
		<tr>
			<td class="topLine"><strong>Total</strong></td>
			<td class="topLine" colspan="4" align="right" nowrap><strong>#LSNumberFormat(vMontoTotal,',9.00')#</strong></td>
			<td class="topLine" align="right" nowrap><strong>#LSNumberFormat(vMontoPagado,',9.00')#</strong></td>
			<td class="topLine" align="right" nowrap><strong>#LSNumberFormat(vSaldo,',9.00')#</strong></td>
		</tr>
		
		<!--- Total general --->
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td class="topLine"><strong>Totales generales</strong></td>
			<td class="topLine" colspan="4" align="right"><strong>#LSNumberFormat(vMontoTotalGeneral,',9.00')#</strong></td>
			<td class="topLine" align="right"><strong>#LSNumberFormat(vMontoPagadoGeneral,',9.00')#</strong></td>
			<td class="topLine" align="right"><strong>#LSNumberFormat(vSaldoGeneral,',9.00')#</strong></td>
		</tr>
		
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="7" align="center">------------ Fin del Reporte ------------</td></tr>
	</table>
<cfelse>
	<table width="99%" align="center" cellpadding="0" cellspacing="0">
		<tr><td align="center"><strong><font size="2">No se encontraron registros</font></strong></td></tr>
	</table>
</cfif>
</cfoutput>