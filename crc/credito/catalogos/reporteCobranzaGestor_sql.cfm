<cfparam name="modo" default="ALTA">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo1 		= t.Translate('LB_Titulo1','Tiendas Full')>
<cfset LB_Titulo2		= t.Translate('LB_Titulo2','Reporte de Cobranza de Gestores')>
<cfset LB_Titulo3		= t.Translate('LB_Titulo3','Generado el')>

<cfset LB_Numero		= t.Translate('LB_Numero', 'Numero de Cuenta')>
<cfset LB_Nombre		= t.Translate('LB_Nombre', 'Nombre de Socio')>
<cfset LB_Fecha			= t.Translate('LB_Fecha', 'Fecha de Cobro')>
<cfset LB_total			= t.Translate('LB_total', 'Total')>
<cfset LB_Subtotal		= t.Translate('LB_Subtotal', 'SubTotal')>
<cfset LB_Descuento		= t.Translate('LB_Descuento', 'Descuento')>
<cfset LB_Comision		= t.Translate('LB_Comision', 'Comision')>
<cfset LB_Porcentaje	= t.Translate('LB_Porcentaje', 'Porcentaje')>
<cfset LvarPagina = "reporteFolios.cfm">

<cfset prevPag="reporteCobranzaGestor.cfm">
<cfset targetAction="reporteCobranzaGestor_sql.cfm">
<cfinclude template="imprimirReporte.cfm" >

<cfquery name="q_DatosReporte" datasource="#Session.DSN#">
	select 
		d.CRCDEid
		, de.DEnombre + ' ' + de.DEapellido1 + ' ' + de.DEapellido2 As Empleadoe
		, e.ETfecha
		, round(sum(d.DTpreciou),2) DTtotal
		, round(sum(d.DTtotal),2) DTSubTotal
		, round(sum(d.DTdeslinea),2) DTdeslinea
		, round(sum(d.DTpreciou*d.CRCDEidPorc/100),2) DTtotalComision
		, c.Numero
		, d.CRCDEidPorc
		, sn.SNnombre
	from ETransacciones e 
		inner join DTransacciones d 
			on d.ETnumero = e.ETnumero 
		inner join FPAgos f 
			on e.ETnumero = f.ETnumero 
		inner join CRCCuentas c 
			on d.CRCCuentaid = c.id 
		inner join SNegocios sn 
			on c.SNegociosSNid = sn.SNid
		inner join DatosEmpleado de 
			on d.CRCDEid = de.DEid
	where
		e.Ecodigo = #session.ecodigo# and e.ETestado = 'C'
		and d.DTborrado = 0
		<cfif !isDefined('url.p')> and 1=0 </cfif>
		<cfif isdefined("Form.FECHAHASTA") && Form.FECHAHASTA neq "">
			<cfset form.FECHAHASTA = ListToArray(form.FECHAHASTA,'/')>
			<cfset form.FECHAHASTA = "#form.FECHAHASTA[3]#-#form.FECHAHASTA[2]#-#form.FECHAHASTA[1]#">
			and e.ETfecha <= dateAdd(day, 1, <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">)
		</cfif>
		<cfif isdefined("Form.FECHADESDE") && Form.FECHADESDE neq "">
			<cfset form.FECHADESDE = ListToArray(form.FECHADESDE,'/')>
			<cfset form.FECHADESDE = "#form.FECHADESDE[3]#-#form.FECHADESDE[2]#-#form.FECHADESDE[1]#">
			and e.ETfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FECHADESDE#">
		</cfif>	
		<cfif isdefined ("Form.DEid") and Form.DEid neq "">
			and d.CRCDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		</cfif>
	group by 
		d.CRCDEid
		, de.DEnombre + ' ' + de.DEapellido1 + ' ' + de.DEapellido2
		, e.ETfecha
		, c.Numero
		, d.CRCDEidPorc
		, sn.SNnombre
order by e.ETfecha, d.CRCDEid
</cfquery>
<cfset modo="ALTA">

<cfquery name="rsTotal" dbtype="query">
	select sum(DTtotal) DTtotal, sum(DTSubTotal) DTSubTotal, sum(DTdeslinea) DTdeslinea, sum(DTtotalComision) DTtotalComision
	from q_DatosReporte
</cfquery>

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
									<cfif isdefined('Form.DENOMBREC') && Form.DENOMBREC neq ''> [Gestor/Abogado = #Form.DENOMBREC#]</cfif>
									<cfif isdefined('Form.fechaDesde') && Form.fechaDesde neq ''> [Fecha inicial = (#Form.fechaDesde#)]</cfif>
									<cfif isdefined('Form.fechaHasta') && Form.fechaHasta neq ''> [Fecha Final = (#Form.fechaHasta#)]</cfif>
								</td>
							</tr>
							<tr style="background-color: ##A9A9A9;">
								<td>#LB_Nombre#</td>
								<td>#LB_Numero#</td>
								<td>#LB_Fecha#</td>
								<td>#LB_total#</td>
								<td>#LB_Subtotal#</td>
								<td>#LB_Descuento#</td>
								<td>#LB_Comision#</td>
								<td>#LB_Porcentaje#</td>
							</tr>
							<cfif q_DatosReporte.RecordCount gt 0>
								<cfloop query="q_DatosReporte">
									<tr>
										<td>#q_DatosReporte.SNnombre#</td>
										<td>#q_DatosReporte.Numero#</td>
										<td>#q_DatosReporte.ETfecha#</td>
										<td align="right">#LSCurrencyFormat(q_DatosReporte.DTtotal)#</td>
										<td align="right">#LSCurrencyFormat(q_DatosReporte.DTSubTotal)#</td>
										<td align="right">#LSCurrencyFormat(q_DatosReporte.DTdeslinea)#</td>
										<td align="right">#LSCurrencyFormat(q_DatosReporte.DTtotalComision)#</td>
										<td align="right">#lsNumberFormat(q_DatosReporte.CRCDEidPorc,"0.00")# %</td>
									</tr>
								</cfloop>
								<tr style="background-color: ##A9A9A9;">
									<td colspan="3" align="right"><b>TOTAL</b></td>
									<td align="right"><b>#LSCurrencyFormat(rsTotal.DTtotal)#</b></td>
									<td align="right"><b>#LSCurrencyFormat(rsTotal.DTSubTotal)#</b></td>
									<td align="right"><b>#LSCurrencyFormat(rsTotal.DTdeslinea)#</b></td>
									<td align="right"><b>#LSCurrencyFormat(rsTotal.DTtotalComision)#</b></td>
									<td></td>
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

