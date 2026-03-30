<cfparam name="modo" default="ALTA">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo1		= t.Translate('LB_Titulo1','Tiendas Full')>
<cfset LB_Titulo2		= t.Translate('LB_Titulo2','Pagos en Tienda')>
<cfset LB_Titulo3		= t.Translate('LB_Titulo3','Generado el')>
<cfset LB_IdTienda		= t.Translate('LB_IdTienda', 'ID Tienda')>
<cfset LB_NoCliente		= t.Translate('LB_NoCliente', 'No. Cliente')>
<cfset LB_NombCliente	= t.Translate('LB_NombCliente', 'Nombre Cliente')>
<cfset LB_Tienda		= t.Translate('LB_Tienda', 'Tienda')>
<cfset LB_Monto			= t.Translate('LB_Monto', 'Monto')>
<cfset LB_Fecha			= t.Translate('LB_Fecha', 'Fecha')>

<cfset prevPag="reportePagoxTienda.cfm">
<cfset targetAction="reportePagoxTienda_sql.cfm">
<cfinclude template="imprimirReporte.cfm" >

<cfquery name="rsReportePagxTie" datasource="#Session.DSN#">

	select 
		o.Odescripcion as Tienda
		, o.Ocodigo as ID_Tienda
		, sn.SNnumero as No_Cliente
		, c.Numero
		, sn.SNnombre as NombreCliente
		, case c.Tipo 
			when 'D' then 'Vales'
				when 'TC' then 'Tarjeta de Credito'
				else 'Tarjeta Mayorista' 
			end Tipo
		, c.Tipo as idTipo
		, case when t.ReversaId > 0 
			then (t.Monto - t.Descuento) * -1
			else t.Monto - t.Descuento 
		end montoD
		, t.Descuento as descuento
		, t.Fecha as fecha
		,t.Corte as corte
		, sn.SNid as SNID
		, case f.Tipo
			when 'E' then 'Efectivo'
			when 'T' then 
				case when 
						et.FCid = (select Pvalor from CRCParametros where Pcodigo = '30200506' and Ecodigo = 2) 
					then COALESCE(NULLIF(et.ETobservacion, ''), 'Banco NR')
					else 'Tarjeta'
				end
			else 'No definido'
			end FormaPago
		, case when t.ReversaId > 0 
			then (isnull(f.FPmontoori,0) - isnull(f.FPVuelto,0) - CASE isnull(f.Tipo,0) WHEN 'T' then case when isnull(et.ETcomision,0) > 0 then round(cast(isnull(f.FPmontoori - f.FPmontoori/(1+(isnull(pc.FATporccom,0)/100)),0) as money),2)  else 0 end else 0 end) * -1
			else isnull(f.FPmontoori,0) - isnull(f.FPVuelto,0) - CASE isnull(f.Tipo,0) WHEN 'T' then case when isnull(et.ETcomision,0) > 0 then round(cast(isnull(f.FPmontoori - f.FPmontoori/(1+(isnull(pc.FATporccom,0)/100)),0) as money),2)  else 0 end else 0 end 
		end monto,
		coalesce(e.Descripcion,'-----') as Estado
	from CRCTransaccion t 
	left join CRCEstatusCuentas e
		on t.estatusCliente = e.id
	inner join CRCCuentas c 
		on t.CRCCuentasid = c.id
	inner join SNegocios sn 
		on sn.SNid = c.SNegociosSNid
	inner join ETransacciones et 
		on t.ETnumero = et.ETnumero
	inner join DTransacciones d
		on et.ETnumero = d.ETnumero
		and d.DTborrado = 0
	inner join FPagos f
		on et.ETnumero = f.ETnumero
		and d.ETnumero = f.ETnumero
	inner join Oficinas o 
		on o.Ocodigo = et.Ocodigo 
		and o.Ecodigo = c.Ecodigo
	inner join CRCCortes co
		on convert(date, t.Fecha) between convert(date, co.FechaInicio) and convert(date, co.FechaFin)
		and rtrim(ltrim(co.tipo)) = rtrim(ltrim(c.tipo))
	left join FATarjetas pc on pc.Ecodigo = t.Ecodigo and pc.FATid = f.FPtipotarjeta
	where
		c.ecodigo = #session.ecodigo#
		<cfif !isDefined('url.p')> and 1=0 </cfif>
		and t.TipoTransaccion = 'PG'
		<cfif isdefined ("Form.Numero") and #Form.Numero# neq "">
			and c.Numero= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Numero#">
		</cfif>
		<cfif isdefined ("Form.TIENDA") and #Form.TIENDA# neq "">
			and o.Ocodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TIENDA#">
		</cfif>
		<cfif isdefined("Form.CORTE") and #Form.CORTE# neq "">
			and co.Codigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CORTE#">
		</cfif>
		<cfif isdefined("Form.tipoCta") and #Form.tipoCta# neq "">
			and c.Tipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.tipoCta#">
		</cfif>
		<cfif isdefined("Form.FECHAHASTA") && Form.FECHAHASTA neq "">
			<cfset form.FECHAHASTA = ListToArray(form.FECHAHASTA,'/')>
			<cfset form.FECHAHASTA = "#form.FECHAHASTA[3]#-#form.FECHAHASTA[2]#-#form.FECHAHASTA[1]#">
			and t.Fecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">
		</cfif>
		<cfif isdefined("Form.FECHADESDE") && Form.FECHADESDE neq "">
			<cfset form.FECHADESDE = ListToArray(form.FECHADESDE,'/')>
			<cfset form.FECHADESDE = "#form.FECHADESDE[3]#-#form.FECHADESDE[2]#-#form.FECHADESDE[1]#">
			and t.Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FECHADESDE#">
		</cfif>
		<cfif isdefined("Form.estado") and Form.estado neq "">
			and e.id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.estado#">
		</cfif>
		AND isnull(f.FPmontoori,0) - isnull(f.FPVuelto,0) - CASE isnull(f.Tipo,0) WHEN 'T' then isnull(et.ETcomision,0) else 0 end > 0
	order by t.Tienda, c.Tipo 
						
</cfquery>

<cfquery name="rsTienda" dbtype="query">
	select ID_Tienda, Tienda, sum(monto) as monto
	from rsReportePagxTie
	group by ID_Tienda, Tienda
</cfquery>

<cfquery name="rsTiendaTotal" dbtype="query">
	select sum(monto) as monto
	from rsReportePagxTie
</cfquery>

<cfquery name="rsEstados" datasource="#Session.DSN#">
	select id,Descripcion,Orden from CRCEstatusCuentas
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	<cfif isdefined("Form.estado") and Form.estado neq "">
		and id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.estado#">
	</cfif>
	order by Orden
</cfquery>

<cfset modo="ALTA">
<cfoutput>
<!--- Tabla para mostrar resultados del reporte generado --->
<div id="#printableArea#">
	<table width="100%" cellpadding="2" cellspacing="0" border="0">
		<tr>
			<td valign="top">
			
				<table  width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="4">&nbsp;</td></tr>
					
					<tr>
						
						<td height="22" align="center" width="40%">
							<span class="style1" style="font-family: verdana; font-size: 200%">#LB_Titulo1#</span><br>
							<span style="font-family: verdana; font-size: 100%"><strong>#LB_Titulo2#</strong><br></span>
							<strong>#LB_Titulo3# #LSDateFormat(Now(),'dd/mm/yyyy')#</strong><br>
						</td>

					</tr>
					<tr height="22" align="center"></tr>
					<tr>
						<table width="100%" border="0">
							<tr>
								<td colspan="9" align="right">
									Filtros:
									<cfif isdefined('Form.SNnombre') && Form.SNnombre neq ''> [Cliente = #Form.SNnombre#]</cfif>
									<cfif isdefined('Form.Tienda') && Form.Tienda neq ''> [Tienda = #Form.Tienda#]</cfif>
									<cfif isdefined('Form.CORTE') && Form.CORTE neq ''>[Corte = (#Form.CORTE#)]</cfif>
									<cfif isdefined('Form.fechaDesde') && Form.fechaDesde neq ''> [Fecha inicial = (#Form.fechaDesde#)]</cfif>
									<cfif isdefined('Form.fechaHasta') && Form.fechaHasta neq ''> [Fecha Final = (#Form.fechaHasta#)]</cfif>
									<cfif isDefined('form.resumen')> &amp; [resumen]<cfelse> &amp; [detalle]</cfif>
									<cfif isdefined('Form.estado') && Form.estado neq ''> [Estado cliente = #rsEstados.Descripcion#]</cfif>
								</td>
							</tr>
							<tr style="background-color: ##A9A9A9;">
								<td>#LB_IdTienda#</td>
								<td>#LB_Tienda#</td>
								<td>No. Cuenta</td>
								<td>#LB_NombCliente#</td>
								<td>#LB_Fecha#</td>
								<td>Forma de Pago</td>
								<td>Estado</td>
								<td align="right">#LB_Monto#</td>
							</tr>
							<cfset totales = {}>
							<cfset idTienda = -1>
							<cfset lastTipo = ''>
							<cfif rsReportePagxTie.RecordCount gt 0>
								<cfloop query="rsTienda">
									<tr style="background-color: ##CCCCCC;">
										<td>#rsTienda.ID_Tienda#</td>
										<td>#rsTienda.Tienda#</td>
										<td colspan="5">&nbsp;</td>
										<td align="right">#LSCurrencyFormat(rsTienda.monto)#</td>
									</tr>
									<cfif not isdefined("form.resumen")>
									<cfquery name="rsTiendaTipo" dbtype="query">
										select ID_Tienda, Tienda, Tipo, sum(monto) as monto
										from rsReportePagxTie
										where ID_Tienda = #rsTienda.ID_Tienda#
										group by ID_Tienda, Tienda, Tipo
									</cfquery>									
									<cfloop query="rsTiendaTipo">
										<tr style="background-color: ##E8E8E8;">
											<td align="center" colspan="7">#rsTiendaTipo.Tipo#</td>
											<td align="right">#LSCurrencyFormat(rsTiendaTipo.monto)#</td>
										</tr>
										<cfquery name="rsTiendaDetalle" dbtype="query">
											select ID_Tienda, Tienda, Tipo, monto, NombreCliente, Numero, fecha, FormaPago, estado
											from rsReportePagxTie
											where ID_Tienda = #rsTienda.ID_Tienda#
												and Tipo = '#rsTiendaTipo.Tipo#'
										</cfquery>
										<cfloop query="rsTiendaDetalle">
											<tr align="center" <cfif monto lt 0> style="color: red;"</cfif>>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>#rsTiendaDetalle.Numero#</td>
												<td>#rsTiendaDetalle.NombreCliente#</td>
												<cfset fechaT = DateFormat(rsTiendaDetalle.fecha,'dd/mm/yyyy')>
												<td>#fechaT#</td>
												<td>#rsTiendaDetalle.FormaPago#</td>
												<td>#rsTiendaDetalle.estado#</td>
												<td align="right">#LSCurrencyFormat(rsTiendaDetalle.monto)#</td>
											</tr>
										</cfloop>
									</cfloop>
									</cfif>
								</cfloop>
								<tr style="background-color: ##CCCCCC;">
									<td colspan="7" align="right"><b>TOTAL</b></td>
									<td align="right"><b>#LSCurrencyFormat(rsTiendaTotal.monto)#</b></td>
								</tr>
							<cfelse>
								<tr><td colspan="9">&nbsp;</td></tr>
								<tr><td colspan="9" align="center"><font color="red"><span style="text-align: center;">--- No se encontraron resultados ---</span></font></td></tr>
							</cfif>
						</table>
					</tr>
				</table>
			</td>	
		</tr>
	</table>
</div>

</cfoutput>
