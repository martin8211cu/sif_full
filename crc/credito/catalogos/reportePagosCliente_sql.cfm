<cfparam name="modo" default="ALTA">




<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo1 		= t.Translate('LB_Titulo1','Tiendas Full')>
<cfset LB_Titulo2		= t.Translate('LB_Titulo2','Pagos recibidos por cliente')>
<cfset LB_Titulo3		= t.Translate('LB_Titulo3','Generado el')>

<cfset LB_Cuenta		= t.Translate('LB_Cuenta', 'Cuenta')>
<cfset LB_TipoCuenta	= t.Translate('LB_TipoCuenta', 'Tipo Cuenta')>
<cfset LB_Nombre		= t.Translate('LB_Nombre', 'Nombre')>
<cfset LB_Region		= t.Translate('LB_Region', 'Region')>
<cfset LB_Sucursal		= t.Translate('LB_Sucursal', 'Sucursal')>
<cfset LB_Pago			= t.Translate('LB_Pago', 'Pago')>
<cfset LB_Estado		= t.Translate('LB_Estado', 'Estado')>
<cfset LB_Descuento		= t.Translate('LB_Descuento', 'Descuento')>
<cfset LB_Neto			= t.Translate('LB_Neto', 'Neto')>
<cfset LB_Fecha			= t.Translate('LB_Fecha', 'Fecha')>

<cfoutput>
	
	<cfset prevPag="reportePagosCliente.cfm">
	<cfset targetAction="reportePagosCliente_sql.cfm">
	<cfinclude template="imprimirReporte.cfm" >

	<cfquery name="q_DatosReporte" datasource="#Session.DSN#">
		select 
		c.Numero
		, c.Tipo
		, sn.SNnombre
		, isnull(case when t.ReversaId > 0 then - t.Monto else t.Monto end,0) Monto
		, t.Fecha
		, sn.SNid
		, isnull(case when t.ReversaId > 0 then - isNull(t.Descuento,0) else isNull(t.Descuento,0) end,0) Descuento
		, o.Odescripcion as sucursal
		, zv.nombre_zona as region
		, coalesce(e.Descripcion,'-----') as estado
	from CRCTransaccion t
		left join CRCEstatusCuentas e
			on t.estatusCliente = e.id
		inner join CRCCuentas c
			on c.id = t.CRCCuentasid
		inner join SNegocios sn
			on sn.SNid = c.SNegociosSNid
	   	inner join ETransacciones et
			on et.ETnumero = t.etnumero
		<!--- 	
		inner join FCajas fc
			on fc.FCid = et.FCid 
		--->
		inner join Oficinas o
			on o.Ocodigo = et.Ocodigo
		inner join ZonaVenta zv
			on zv.id_zona = o.id_zona
	where t.Ecodigo = #Session.Ecodigo#
		<cfif !isDefined('url.p')> and 1=0 </cfif>
		and TipoTransaccion = 'PG'
		<cfif isdefined('form.tipoCta') && form.tipoCta neq ''>
			and rtrim(ltrim(c.Tipo)) = '#form.tipoCta#'
		</cfif>
		<cfif isdefined('form.SNid') && form.SNid neq ''>
			and rtrim(ltrim(c.SNegociosSNid)) = '#form.SNid#'
		</cfif>
		<cfif isdefined("Form.FechaHasta") && #Form.FechaHasta# neq "">
			<cfset form.FECHAHASTA = ListToArray(form.FECHAHASTA,'/')>
			<cfset form.FECHAHASTA = "#form.FECHAHASTA[3]#-#form.FECHAHASTA[2]#-#form.FECHAHASTA[1]#">
			and t.Fecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">
		</cfif>
		<cfif isdefined("Form.FechaDesde") && #Form.FechaDesde# neq "">
			<cfset form.FECHADESDE = ListToArray(form.FECHADESDE,'/')>
			<cfset form.FECHADESDE = "#form.FECHADESDE[3]#-#form.FECHADESDE[2]#-#form.FECHADESDE[1]#">
			and t.Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaDesde#">
		</cfif>
		<cfif isdefined("Form.estado") and Form.estado neq "">
			and e.id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.estado#">
		</cfif>
		order by sn.SNid desc, c.Numero desc, t.Fecha;
	</cfquery>

	<cfquery name="rsClienteTotal" dbtype="query">
		select sum(Monto) as Monto, sum(Descuento) Descuento
		from q_DatosReporte
	</cfquery>

	<cfquery name="rsEstados" datasource="#Session.DSN#">
	select id,Descripcion,Orden from CRCEstatusCuentas
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	<cfif isdefined("Form.estado") and Form.estado neq "">
		and id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.estado#">
	</cfif>
	order by Orden
</cfquery>

	<cftry>
		<cfset netoT = rsClienteTotal.Monto>
		<cfset descT = rsClienteTotal.Descuento>
		<cfset pagoT = rsClienteTotal.Monto - descT>
	<cfcatch type="any">
	</cfcatch>
	</cftry>
	
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
										Filtros: [Transacciones = PG] 
										<cfif isdefined('form.tipoCta') && form.tipoCta neq ''> &amp; [Tipo Cuenta = #form.tipoCta#]</cfif>
										<cfif isdefined('form.SNid') && form.SNid neq ''> &amp; [Socio Negocios = #form.SNnombre#]</cfif>
										<cfif isdefined('form.FechaHasta') && form.FechaHasta neq ''> &amp; [Fecha Hasta = #form.FechaHasta#]</cfif>
										<cfif isdefined('form.FechaDesde') && form.FechaDesde neq ''> &amp; [Fecha Desde = #form.FechaDesde#]</cfif>
										<cfif isDefined('form.resumen')> &amp; [resumen]<cfelse> &amp; [detalle]</cfif>
										<cfif isdefined('Form.estado') && Form.estado neq ''> [Estado cliente = #rsEstados.Descripcion#]</cfif>
									</td>
								</tr>
								<tr style="background-color: ##A9A9A9; " align="center">
									<td>#LB_Nombre#</td>
									<td>#LB_Cuenta#</td>
									<td>#LB_TipoCuenta#</td>
									<td>#LB_Fecha#</td>
									<td>#LB_Region#</td>
									<td>#LB_Sucursal#</td>
									<td>#LB_Pago#</td>
									<td>#LB_Estado#</td>
									<td>#LB_Descuento#</td>
									<td>#LB_Neto#</td>
								</tr>
								<cfset lastCuenta = 0>
								<cfset lastSN = 0>
								<cfset totalesSN = {}>
								<cfset totalesC = {}>
								<cfif q_DatosReporte.RecordCount gt 0>
									<cfloop query="q_DatosReporte">
										<cfif lastSN neq q_DatosReporte.SNid>
											<cfset lastSN = q_DatosReporte.SNid>
											<cfset totalesSN["#q_DatosReporte.SNid#"] = {"id"="#q_DatosReporte.SNid#","Pago"=0,"Desc"=0,"Neto"=0}>
											<tr style="background-color: ##CCCCCC;" align="center">
												<td align="left">#q_DatosReporte.SNnombre#</td>	
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td id="s_#q_DatosReporte.SNid#_Pago">#LScurrencyFormat(0)#</td>
												<td>&nbsp;</td>
												<td id="s_#q_DatosReporte.SNid#_Desc">#lsCurrencyFormat(0)#</td>
												<td id="s_#q_DatosReporte.SNid#_Neto">#lsCurrencyFormat(0)#</td>
											</tr>
										</cfif>
										<cfif lastCuenta neq q_DatosReporte.Numero>
											<cfset lastCuenta = q_DatosReporte.Numero>
											<cfset totalesC["#q_DatosReporte.Numero#"] = {"id"="#q_DatosReporte.Numero#","Pago"=0,"Desc"=0,"Neto"=0}>
											<tr style="background-color: ##E8E8E8;" align="center">
												<td align="left">&emsp;&ensp;#q_DatosReporte.SNnombre#</td>	
												<td>#q_DatosReporte.Numero#</td>
												<td>#q_DatosReporte.Tipo#</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td id="c_#q_DatosReporte.Numero#_Pago">#LScurrencyFormat(0)#</td>
												<td>&nbsp;</td>
												<td id="c_#q_DatosReporte.Numero#_Desc">#lsCurrencyFormat(0)#</td>
												<td id="c_#q_DatosReporte.Numero#_Neto">#lsCurrencyFormat(0)#</td>
											</tr>
										</cfif>
										<cfset neto = q_DatosReporte.Monto>
										<cfset desc = q_DatosReporte.Descuento>
										<cfset pago = q_DatosReporte.Monto - desc>
										<cfif !isDefined('form.resumen')>
											<tr align="center" <cfif pago lt 0> style="color: red;"</cfif>>
												<td align="left">&emsp;&emsp;&ensp;#q_DatosReporte.SNnombre#</td>	
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>#DateFormat(q_DatosReporte.Fecha,"dd/mm/yyyy")#</td>
												<td>#q_DatosReporte.region#</td>
												<td>#q_DatosReporte.sucursal#</td>
												<td >#LScurrencyFormat(pago)#</td>
												<td>#q_DatosReporte.estado#</td>
												<td>#lsCurrencyFormat(desc)#</td>
												<td>#lsCurrencyFormat(neto)#</td>
											</tr>
										</cfif>
											<cfset totalesC["#q_DatosReporte.Numero#"].Pago += pago>
											<cfset totalesC["#q_DatosReporte.Numero#"].Desc += desc>
											<cfset totalesC["#q_DatosReporte.Numero#"].Neto += neto>
											<cfset totalesSN["#q_DatosReporte.SNid#"].Pago += pago>
											<cfset totalesSN["#q_DatosReporte.SNid#"].Desc += desc>
											<cfset totalesSN["#q_DatosReporte.SNid#"].Neto += neto>
									</cfloop>
									<tr style="background-color: ##A9A9A9; " align="center">
										<td align="right" colspan="6">TOTAL</td>
										<td >#LScurrencyFormat(pagoT)#</td>
										<td>&nbsp;</td>
										<td>#lsCurrencyFormat(descT)#</td>
										<td>#lsCurrencyFormat(netoT)#</td>
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

	<cfloop collection="#totalesC#" item="item">
		<script>
			document.getElementById('c_#totalesC[item].id#_Pago').innerHTML = '#LSCurrencyFormat(totalesC[item].Pago)#'
			document.getElementById('c_#totalesC[item].id#_Desc').innerHTML = '#LSCurrencyFormat(totalesC[item].Desc)#'
			document.getElementById('c_#totalesC[item].id#_Neto').innerHTML = '#LSCurrencyFormat(totalesC[item].Neto)#'
		</script>
	</cfloop>
	<cfloop collection="#totalesSN#" item="item">
		<script>
			document.getElementById('s_#totalesSN[item].id#_Pago').innerHTML = '#LSCurrencyFormat(totalesSN[item].Pago)#'
			document.getElementById('s_#totalesSN[item].id#_Desc').innerHTML = '#LSCurrencyFormat(totalesSN[item].Desc)#'
			document.getElementById('s_#totalesSN[item].id#_Neto').innerHTML = '#LSCurrencyFormat(totalesSN[item].Neto)#'
		</script>
	</cfloop>


</cfoutput>
