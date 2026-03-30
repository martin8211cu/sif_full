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
<cfquery name="data" datasource="#session.DSN#">
	select a.FVid, b.FVnombre, FVidentificacion, d.Mcodigo, e.Mnombre, a.ETfecha, c.DTlinea, DTdescripcion, DTcant, DTpreciou, DTtotal, a.FCid, a.ETnumero, a.Cmonto, a.Cporcentaje, a.Ccomision 
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
	and a.FVid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FVid#">	
    and a.ETfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.ETfecha)#">
    and a.ETfecha < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,LSParseDateTime(form.ETfecha))#">
	order by FVnombre, e.Mnombre, a.ETfecha	
</cfquery>

<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0"> <!--- tabla 1--->
		<!--- Encabezado --->
		<tr><td>
			<table width="100%" cellpadding="0" cellspacing="0" > <!--- tabla 1.1 --->
				<tr><td colspan="2" align="center"><strong><font size="3">Consulta Detalle de Comisiones por Vendedor</font></strong></td></tr>
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
				
				<tr><td colspan="2" align="center"><strong>Fecha: #LSDateFormat(form.ETfecha,'dd/mm/yyyy')#</strong></td></tr>
	
			</table> <!--- tabla 1.1 --->
		</td></tr>	<!--- Encabezado --->
		
		<cfif data.recordCount gt 0>
			<!--- Consulta ---> 	
			<tr><td>
				<table width="100%" cellpadding="0" cellspacing="0" border="0"> <!--- table 1.2 --->
					<cfset moneda = ''>
					<cfset monto_total = 0>
					<cfset comision_total = 0>
					<cfloop query="data">
						<cfif moneda neq data.Mcodigo>
							<cfif len(trim(moneda))>
								<tr style="text-indent:30; ">
									<td class="topline"><strong>Total</strong></td>
									<td class="topline">&nbsp;</td>
									<td class="topline">&nbsp;</td>
									<td class="topline" align="right"><strong>#LSCurrencyFormat(monto_total, 'none')#</strong></td>
									<td class="topline" align="right"><strong>#LSCurrencyFormat(comision_total, 'none')#</strong></td>
								</tr>
								<tr><td>&nbsp;</td></tr>
							</cfif>

							<tr style="text-indent:30; padding:3;"  bgcolor="##B6D0F1">
								<td colspan="6"><strong>Moneda: #data.Mnombre#</strong></td>
							</tr>

							<tr style="text-indent:50; ">
								<td class="tituloListas" >Descripci&oacute;n</td>
								<td class="tituloListas"  align="right">Cantidad</td>
								<td class="tituloListas"  align="right">Precio Unitario</td>
								<td class="tituloListas"  align="right">Monto Total</td>
								<td class="tituloListas"  align="right">Porcentaje de Comisi&oacute;n</td>
								<td class="tituloListas"  align="right">Comisi&oacute;n</td>
							</tr>
							<cfset monto_total = 0>
							<cfset comision_total = 0>
						</cfif>
		
						<cfset monto_total = monto_total + data.DTtotal>
						<cfset comision_total = comision_total + data.Ccomision>
						<tr style="text-indent:50; padding:2; cursor:hand; " class="<cfif data.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
							<td>#data.DTdescripcion#</td>
							<td align="right">#LSCurrencyFormat(data.DTcant, 'none')#</td>
							<td align="right">#LSCurrencyFormat(data.DTpreciou, 'none')#</td>
							<td align="right">#LSCurrencyFormat(data.Cmonto, 'none')#</td>
							<td align="right">#LSCurrencyFormat(data.Cporcentaje, 'none')#</td>
							<td align="right">#LSCurrencyFormat(data.Ccomision, 'none')#</td>
						</tr>
						<cfset moneda = data.Mcodigo>
					</cfloop>
					
					<!--- ultimo total --->
					<tr style="text-indent:30; ">
						<td class="topline"><strong>Total</strong></td>
						<td class="topline">&nbsp;</td>
						<td class="topline">&nbsp;</td>
						<td  class="topline" align="right"><strong>#LSCurrencyFormat(monto_total, 'none')#</strong></td>
						<td class="topline" >&nbsp;</td>
						<td class="topline" align="right"><strong>#LSCurrencyFormat(comision_total, 'none')#</strong></td>
					</tr>	
				</table><!--- table 1.2 --->
			</td></tr> <!--- Consulta ---> 	
		<cfelse>
			<tr><td align="center"><font size="2"><strong>- No se encontraron registros -</strong></font></td></tr>
		</cfif>
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center"><input type="button" name="regresar" value="Regresar" onClick="history.back();"></td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
</cfoutput>