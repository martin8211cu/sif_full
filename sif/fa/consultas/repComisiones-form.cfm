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
}
</style>

<cfset filtro = ''>

<!--- Fechas --->
<cfif isdefined("form.fechai") and len(trim(form.fechai)) and isdefined("form.fechaf") and len(trim(form.fechaf)) >
	<cfset vfechai = LSParseDateTime(form.fechai)>
	<cfset vfechaf = LSParseDateTime(form.fechaf)>
	<cfif vfechai gt vfechaf>
		<cfset tmp = vfechai>
		<cfset vfechai = vfechaf >
		<cfset vfechaf = tmp >
		<cfset vdesde = form.fechaf>
		<cfset vhasta = form.fechai>
	<cfelse>
		<cfset vdesde = form.fechai>
		<cfset vhasta = form.fechaf>
	</cfif> 
	<cfset filtro = filtro & " and a.ETfecha between #vfechai# and #vfechaf# " >
<cfelseif isdefined("form.fechai") and len(trim(form.fechai))  >
	<cfset vfechai = LSParseDateTime(form.fechai)>
	<cfset filtro = filtro & " and a.ETfecha >= #vfechai# " >
<cfelseif isdefined("form.fechaf") and len(trim(form.fechaf)) >
	<cfset vfechaf = LSParseDateTime(form.fechaf)>
	<cfset filtro = filtro & " and a.ETfecha <= #vfechaf# " >
</cfif>

<cfif isdefined("form.FVid") and len(trim(form.FVid))>
	<cfset filtro = filtro & " and a.FVid = #form.FVid# " >
</cfif>

<cfset pagadas = 'Todas (pagadas y no pagadas)' >
<cfif isdefined("form.Cpagada") and form.Cpagada eq 1 >
	<cfset filtro = filtro & " and a.Cpagada = 1 " >
	<cfset pagadas = 'Pagadas' >
<cfelseif isdefined("form.Cpagada") and form.Cpagada eq 2 >
	<cfset filtro = filtro & " and a.Cpagada = 0 " >
	<cfset pagadas = 'No pagadas' >
</cfif>

<cfquery name="data" datasource="#session.DSN#">
	select a.FVid, b.FVnombre, FVidentificacion, d.Mcodigo, e.Mnombre, a.ETfecha, sum(a.Cmonto) as Ctotal, sum(a.Ccomision) as Ccomision
	from Comisiones a
	
	inner join FVendedores b
	on a.FVid=b.FVid
	and a.Ecodigo=b.Ecodigo
	
	inner join DTransacciones c
	on a.DTlinea=c.DTlinea
	and a.Ecodigo=c.Ecodigo
	and c.DTborrado=0
	
	inner join ETransacciones d
	on c.FCid=d.FCid
	and c.ETnumero=d.ETnumero
	
	inner join Monedas e
	on d.Mcodigo=e.Mcodigo
	and d.Ecodigo=e.Ecodigo
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
	#preservesinglequotes(filtro)#
	
	group by a.FVid, b.FVnombre, FVidentificacion, d.Mcodigo, e.Mnombre, a.ETfecha  
	order by FVnombre, e.Mnombre, a.ETfecha
</cfquery>

<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0"> <!--- tabla 1--->
		<!--- Encabezado --->
		<tr><td>
			<table width="100%" cellpadding="0" cellspacing="0" > <!--- tabla 1.1 --->
				<tr><td colspan="2" align="center"><strong><font size="3">Consulta de Comisiones por Vendedor</font></strong></td></tr>
				<!--- Vendedor --->
				<cfif isdefined("form.FVid") and len(trim(form.FVid))>
					<cfquery name="rsVendedor" datasource="#session.DSN#">
						select FVnombre, FVidentificacion
						from FVendedores
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and FVid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FVid#">
					</cfquery>
					<tr>
						<td width="45%" align="center"><strong>Vendedor:&nbsp;</strong>
						<strong>#rsVendedor.FVnombre# (#rsVendedor.FVidentificacion#)</strong></td>
					</tr>
				</cfif>
				
				<!--- Fechas --->
				<cfif isdefined("form.fechai") and len(trim(form.fechai)) and isdefined("form.fechaf") and len(trim(form.fechaf)) >
					<tr><td colspan="2" align="center"><strong>Fechas: desde #vdesde# &nbsp; hasta: #vhasta#</strong></td>
					</tr>
				<cfelseif isdefined("form.fechai") and len(trim(form.fechai))  >
					<tr><td colspan="2" align="center"><strong>Fecha desde #form.fechai#</strong></td>
					</tr>
				<cfelseif isdefined("form.fechaf") and len(trim(form.fechaf)) >
					<tr><td colspan="2" align="center">Fecha hasta: #form.fechaf#</td></tr>
				</cfif>
				
				<!--- Pagadas --->
				<tr><td align="center"><strong>Tipo de comisi&oacute;n:&nbsp;<strong>#pagadas#</strong></strong></td></tr>
				<tr><td colspan="2"><hr size="1"></td></tr>
	
			</table> <!--- tabla 1.1 --->
		</td></tr>	<!--- Encabezado --->
		
		<cfif data.recordCount gt 0>
			<!--- Consulta ---> 	
			<tr><td>
				<table width="100%" cellpadding="0" cellspacing="0" border="0"> <!--- table 1.2 --->
					<cfset vendedor = ''>
					<cfset moneda = ''>
					<cfset monto_total = 0>
					<cfset comision_total = 0>
					<cfloop query="data">
						<cfif vendedor neq data.FVid>
							<cfif moneda neq data.Mnombre and len(trim(vendedor))>
								<tr style="text-indent:30; ">
									<td class="topline"><strong>Total</strong></td>
									<td class="topline" align="right"><strong>#LSCurrencyFormat(monto_total, 'none')#</strong></td>
									<td class="topline" align="right"><strong>#LSCurrencyFormat(comision_total, 'none')#</strong></td>
								</tr>	
							</cfif>
						
							<cfif len(trim(vendedor))><tr><td>&nbsp;</td></tr></cfif>
							<!---<tr style="text-indent:10; padding:3;" bgcolor="##E8E8E8">--->
							<tr style="text-indent:10; padding:3;" bgcolor="##B6D0F1">
								<td colspan="3"><strong>#data.FVnombre#</strong><cfif len(trim(data.FVidentificacion))><strong>(#data.FVidentificacion#)</strong></cfif></td>
							</tr>
							<cfset moneda = ''>
						</cfif>
		
						<cfif moneda neq data.Mcodigo>
							<cfif len(trim(moneda))>
								<tr style="text-indent:30; ">
									<td class="topline"><strong>Total</strong></td>
									<td class="topline" align="right"><strong>#LSCurrencyFormat(monto_total, 'none')#</strong></td>
									<td class="topline" align="right"><strong>#LSCurrencyFormat(comision_total, 'none')#</strong></td>
								</tr>
								<tr><td>&nbsp;</td></tr>
							</cfif>
							<tr style="text-indent:30; padding:3;" >
								<td colspan="5"><strong>#data.Mnombre#</strong></td>
							</tr>
							<tr style="text-indent:50; ">
								<td class="tituloListas" >Fecha</td>
								<td class="tituloListas"  align="right">Monto Vendido</td>
								<td class="tituloListas"  align="right">Comisi&oacute;n</td>
							</tr>
							<cfset monto_total = 0>
							<cfset comision_total = 0>
						</cfif>
		
						<cfset monto_total = monto_total + data.Ctotal>
						<cfset comision_total = comision_total + data.Ccomision>
						<tr style="text-indent:50; padding:2; cursor:hand; " class="<cfif data.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" onclick="procesar(#data.FVid#,'#LSDateFormat(data.ETfecha,'dd/mm/yyyy')#');">
							<td>#LSdateFormat(data.ETfecha,'dd/mm/yyyy')#</td>
							<td align="right">#LSCurrencyFormat(data.Ctotal, 'none')#</td>
							<td align="right">#LSCurrencyFormat(data.Ccomision, 'none')#</td>
						</tr>
						<cfset vendedor = data.FVid>
						<cfset moneda = data.Mcodigo>
					</cfloop>
					
					<!--- ultimo total --->
					<tr style="text-indent:30; ">
						<td class="topline"><strong>Total</strong></td>
						<td  class="topline" align="right"><strong>#LSCurrencyFormat(monto_total, 'none')#</strong></td>
						<td class="topline" align="right"><strong>#LSCurrencyFormat(comision_total, 'none')#</strong></td>
					</tr>	
				</table><!--- table 1.2 --->
			</td></tr> <!--- Consulta ---> 	
		<cfelse>
			<tr><td align="center"><font size="2"><strong>- No se encontraron registros -</strong></font></td></tr>
			<tr><td align="center"><input type="button" name="regresar" value="Regresar" onClick="location.href='Comisiones.cfm'"></td></tr>
		</cfif>
	</table>
</cfoutput>

<script type="text/javascript" language="javascript1.2">
	function procesar(fvid, fecha){
		location.href = 'repComisionesDetalle.cfm?FVid='+fvid+"&ETfecha="+fecha;
	}
</script>