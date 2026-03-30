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

<cfset prevPag="reporteVentasxTienda.cfm">
<cfset targetAction="reporteVentasxTienda_sql.cfm">
<cfinclude template="imprimirReporte.cfm" >


<cfset databaseNameInt = "SIF_INTERFACES">
	<cfdbinfo
		type="dbnames"
		datasource="sifinterfaces"
		name="databasesName">
	<cfloop query="databasesName">
		<cfif FindNoCase("sif",#databasesName.DATABASE_NAME#) GT 0 AND FindNoCase("interfaces",#databasesName.DATABASE_NAME#) GT 0>
			<cfset databaseNameInt = #databasesName.DATABASE_NAME#>
		</cfif>
	</cfloop>
	
<cfquery name="rsReportePagxTie" datasource="#Session.DSN#">

	select top 50000 t.Tienda, t.sucursal, c.id, c.Numero, s.SNnombre as NombreCliente, t.Ticket,  
		t.TipoTransaccion as Tipo, t.Ecodigo, t.Monto, eq.EQUcodigoSIF, eq.EQUdescripcion,
		eq.EQUcodigoSIF + ' ' + eq.EQUdescripcion as TiendaDesc,
		case 
			when t.TipoTransaccion = 'TC' then 'Tarjeta'
			when t.TipoTransaccion = 'VC' then 'Vales'
			else 'No definido'
		end FormaPago, t.Fecha
	from CRCTransaccion t
	inner join CRCCuentas c
		on c.id = t.CRCCuentasid
	inner join SNegocios s
		on c.SNegociosSNid = s.SNid
	left join (
		select  * from #databaseNameInt#..SIFLD_Equivalencia
		where CATcodigo = 'SUCURSAL'
			and SIScodigo = 'LD'
			and EQUempOrigen = 1
			and EQUempSIF = #session.Ecodigo#
	) eq 
		on t.Ecodigo = eq.EQUempSIF
		and t.Tienda = eq.EQUcodigoOrigen
	where t.TipoTransaccion in ('VC', 'TC')
		and t.Ecodigo = #session.Ecodigo#
		and c.ecodigo = #session.ecodigo#
		<cfif isdefined("Form.tipoCta") and #Form.tipoCta# neq "">
			and c.Tipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.tipoCta#">
		</cfif>
		<cfif isdefined("Form.numcuenta") and #Form.numcuenta# neq "">
			and c.Numero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.numcuenta#">
		</cfif>
		<cfif isdefined("Form.tienda") and #Form.tienda# neq "">
			and t.Tienda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.tienda#">
		</cfif>
		<cfif isdefined("Form.FECHAHASTA") && Form.FECHAHASTA neq "">
			<cfset form.FECHAHASTA = ListToArray(form.FECHAHASTA,'/')>
			<cfset form.FECHAHASTA = "#form.FECHAHASTA[3]#-#form.FECHAHASTA[2]#-#form.FECHAHASTA[1]#">
			and t.Fecha <= dateAdd(day, 1, <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">)
		</cfif>
		<cfif isdefined("Form.FECHADESDE") && Form.FECHADESDE neq "">
			<cfset form.FECHADESDE = ListToArray(form.FECHADESDE,'/')>
			<cfset form.FECHADESDE = "#form.FECHADESDE[3]#-#form.FECHADESDE[2]#-#form.FECHADESDE[1]#">
			and t.Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FECHADESDE#">
		</cfif>
	order by t.Tienda, c.Tipo 
						
</cfquery>

<cfquery name="rsTienda" dbtype="query">
	select Tienda, TiendaDesc, sum(monto) as monto
	from rsReportePagxTie
	group by Tienda, TiendaDesc
</cfquery>

<cfquery name="rsTiendaTotal" dbtype="query">
	select sum(monto) as monto
	from rsReportePagxTie
</cfquery>


<cfset modo="ALTA">
<cfoutput>
<!--- Tabla para mostrar resultados del reporte generado --->
<div id="#printableArea#">
	<table width="100%" cellpadding="2" cellspacing="0">
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
									<cfif isdefined('Form.Tienda') && Form.Tienda neq ''> [Sucursal = #Form.Tienda#]</cfif>
									<cfif isdefined('Form.NumCuenta') && Form.NumCuenta neq ''> [Cuenta = #Form.NumCuenta#]</cfif>
									<cfif isdefined('Form.Tienda') && Form.Tienda neq ''> [Tienda = #Form.Tienda#]</cfif>
									<cfif isdefined('Form.CORTE') && Form.CORTE neq ''>[Corte = (#Form.CORTE#)]</cfif>
									<cfif isdefined('Form.fechaDesde') && Form.fechaDesde neq ''> [Fecha inicial = (#Form.fechaDesde#)]</cfif>
									<cfif isdefined('Form.fechaHasta') && Form.fechaHasta neq ''> [Fecha Final = (#Form.fechaHasta#)]</cfif>
									<cfif isDefined('form.resumen')> &amp; [resumen]<cfelse> &amp; [detalle]</cfif>
								</td>
							</tr>
							<tr style="background-color: ##A9A9A9;">
								<td>#LB_Tienda#</td>
								<cfif not isdefined("form.resumen")>
									<td>No. Cuenta</td>
									<td>#LB_NombCliente#</td>
									<td>#LB_Fecha#</td>
								</cfif>
								<td align="right">#LB_Monto#</td>
							</tr>
							<cfset totales = {}>
							<cfset idTienda = -1>
							<cfset lastTipo = ''>
							
							<cfif rsReportePagxTie.RecordCount gt 0>
								
								<cfloop query="rsTienda">
									<tr style="background-color: ##CCCCCC;">
										<td>#rsTienda.TiendaDesc#</td>
										<cfif not isdefined("form.resumen")>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
										</cfif>
										<td align="right">#LSCurrencyFormat(rsTienda.monto)#</td>
									</tr>
									<cfif not isdefined("form.resumen")>
									<cfquery name="rsTiendaTipo" dbtype="query">
										select Tienda, Tipo, FormaPago, TiendaDesc, sum(Monto) as monto
										from rsReportePagxTie
										where Tienda = '#rsTienda.Tienda#'
										group by Tienda, Tipo, FormaPago, TiendaDesc
									</cfquery>		
																
									<cfloop query="rsTiendaTipo">
										<tr style="background-color: ##E8E8E8;">
											<td align="center" colspan="4">#rsTiendaTipo.FormaPago#</td>
											<td align="right">#LSCurrencyFormat(rsTiendaTipo.monto)#</td>
										</tr>
										<cfquery name="rsTiendaDetalle" dbtype="query">
											select Tienda, TiendaDesc, Tipo, Monto, NombreCliente, Numero, fecha
											from rsReportePagxTie
											where Tienda = '#rsTienda.Tienda#'
												and Tipo = '#rsTiendaTipo.Tipo#'
										</cfquery>
										<cfloop query="rsTiendaDetalle">
											<tr>
												<td>&nbsp;</td>
												<td>#rsTiendaDetalle.Numero#</td>
												<td>#rsTiendaDetalle.NombreCliente#</td>
												<cfset fechaT = DateFormat(rsTiendaDetalle.fecha,'dd/mm/yyyy')>
												<td align="center">#fechaT#</td>
												<td align="right">#LSCurrencyFormat(rsTiendaDetalle.monto)#</td>
											</tr>
										</cfloop>
									</cfloop>
									</cfif>
								</cfloop>
								<tr style="background-color: ##A9A9A9;">
									<td>&nbsp;</td>
									<cfif not isdefined("form.resumen")>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
									</cfif>
									<td align="right"> <b>#LSCurrencyFormat(rsTiendaTotal.monto)#</b></td>
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
