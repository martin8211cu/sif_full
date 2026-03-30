<cfparam name="modo" default="ALTA">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo1 		= t.Translate('LB_Titulo1','Tiendas Full')>
<cfset LB_Titulo2		= t.Translate('LB_Titulo2','Reporte de uso Vales')>
<cfset LB_Titulo3		= t.Translate('LB_Titulo3','Generado el')>
<cfset LB_Tienda		= t.Translate('LB_Tienda', 'Tienda')>
<cfset LB_FechaCompra	= t.Translate('LB_FechaCo', 'Fecha Compra')>
<cfset LB_Cuenta		= t.Translate('LB_Cuenta', 'Cuenta')>
<cfset LB_Cliente		= t.Translate('LB_Cliente', 'Cliente')>
<cfset LB_CURPUsu		= t.Translate('LB_CuentaUsu', 'CURP Usuario de Vale')>
<cfset LB_UsuVales		= t.Translate('LB_UsuVales', 'Usuario de Vale')>
<cfset LB_ValeOValExt	= t.Translate('LB_ValeOValExt', 'Vale o Vale Ext')>
<cfset LB_Monto			= t.Translate('LB_Monto', 'Monto')>
<cfset LvarPagina = "reporteVales.cfm">

		

<cfset prevPag="reporteVales.cfm">
<cfset targetAction="reporteVales_sql.cfm">
<cfinclude template="imprimirReporte.cfm" >

<cfquery name="rsReporteVales" datasource="#Session.DSN#">

select t.Tienda as tienda, t.Fecha as fecha, c.Numero as cuenta, sn.SNnombre as cliente, t.CURP as cuentaUsu, t.cliente as usuarioVale, t.Folio as valOValExt, t.Monto as monto, co.Codigo as corte, sn.SNid as SNID,
 t.Parciales
	from CRCTransaccion t 
	inner join CRCCuentas c 
		on t.CRCCuentasid = c.id
	inner join SNegocios sn 
		on sn.SNid = c.SNegociosSNid
	inner join CRCCortes co
		on convert(date, t.Fecha) between convert(date, co.FechaInicio) and convert(date, co.FechaFin)
		and co.Tipo = 'D'
	where
	c.ecodigo = #session.ecodigo#
	and t.TipoTransaccion = 'VC'
	<cfif !isDefined('url.p')> and 1=0 </cfif>
	AND Rtrim(Ltrim(isNull(t.folio,''))) <> ''
	<cfif isdefined ("Form.SNID") and Form.SNID neq "">
		and SNID= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNID#">
	</cfif>
	<cfif isdefined ("Form.NUMERO") and Form.NUMERO neq "">
		and c.Numero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.NUMERO#">
	</cfif>
	<cfif isdefined("Form.CORTE") and Form.CORTE neq "">
		and co.Codigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CORTE#">
	<cfelse>
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
	</cfif>
	order by t.Tienda, t.Fecha	
</cfquery>
<cfset modo="ALTA">


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
									<cfif isdefined('Form.Nombre') && Form.Nombre neq ''> [Cliente = #Form.Nombre#]</cfif>
									<cfif isdefined('Form.NUMERO') && Form.NUMERO neq ''> [Cuenta = #Form.NUMERO#]</cfif>
									<cfif isdefined('Form.CORTE') && Form.CORTE neq ''>[Corte = (#Form.CORTE#)]</cfif>
									<cfif isdefined('Form.fechaDesde') && Form.fechaDesde neq ''> [Fecha inicial = (#Form.fechaDesde#)]</cfif>
									<cfif isdefined('Form.fechaHasta') && Form.fechaHasta neq ''> [Fecha Final = (#Form.fechaHasta#)]</cfif>
								</td>
							</tr>
							<tr style="background-color: ##A9A9A9;">
								<td>#LB_Tienda#</td>
								<td>#LB_FechaCompra#</td>
								<td>#LB_Cuenta#</td>
								<td>#LB_Cliente#</td>
								<td>#LB_CURPUsu#</td>
								<td>#LB_UsuVales#</td>
								<td>#LB_ValeOValExt#</td>
								<td>Parcialidades</td>
								<td>#LB_Monto#</td>
							</tr>
							<cfif rsReporteVales.RecordCount gt 0>
								<cfloop query="rsReporteVales">
									<tr>
										<td>#rsReporteVales.tienda#</td>
										<td>#DateFormat(rsReporteVales.fecha,"dd/mm/yyyy")#</td>
										<td>#rsReporteVales.cuenta#</td>
										<td>#rsReporteVales.cliente#</td>
										<td>#rsReporteVales.cuentaUsu#</td>
										<td>#rsReporteVales.usuarioVale#</td>
										<td>#rsReporteVales.valOValExt#</td>
										<td>#rsReporteVales.Parciales#</td>
										<td>#LSCurrencyFormat(rsReporteVales.monto)#</td>
									</tr>
								</cfloop>
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

