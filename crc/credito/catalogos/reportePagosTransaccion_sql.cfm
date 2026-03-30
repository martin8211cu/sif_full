<cfparam name="modo" default="ALTA">




<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo1 		= t.Translate('LB_Titulo1','GRUPO COMERCIAL GRAN BAZAR')>
<cfset LB_Titulo2		= t.Translate('LB_Titulo2','Pagos recibidos por Transaccion')>
<cfset LB_Titulo3		= t.Translate('LB_Titulo3','Generado el')>

<cfset LB_Nombre		= t.Translate('LB_Nombre', 'Cuenta')>
<cfset LB_Cuenta		= t.Translate('LB_Cuenta', 'Cuenta')>
<cfset LB_TipoCuenta	= t.Translate('LB_TipoCuenta', 'Tipo Cuenta')>
<cfset LB_TipoTransa	= t.Translate('LB_TipoTransa', 'Tipo Transaccion')>
<cfset LB_FechaT		= t.Translate('LB_FechaT', 'Fecha')>
<cfset LB_FechaP		= t.Translate('LB_FechaP', 'Inicio de Pago')>
<cfset LB_Parcialidad	= t.Translate('LB_Parcialidad', 'Parcialidades')>
<cfset LB_Monto			= t.Translate('LB_Monto', 'Monto Original')>
<cfset LB_Interes		= t.Translate('LB_Interes', 'Intereses')>
<cfset LB_Pagado		= t.Translate('LB_Pagado', 'Monto Pagado')>
<cfset LB_Descuento		= t.Translate('LB_Descuento', 'Descuentos')>
<cfset LB_Adeudo		= t.Translate('LB_Adeudo', 'Adeudo')>

<cfoutput>
	
	<cfset prevPag="reportePagosTransaccion.cfm">
	<cfset targetAction="reportePagosTransaccion_sql.cfm">
	<cfinclude template="imprimirReporte.cfm" >

	<cfquery name="q_DatosReporte" datasource="#Session.DSN#">
		select 
			  c.Tipo
			, c.Numero
			, sn.SNidentificacion
			, sn.SNnombre
			, sn.SNid
			, t.TipoTransaccion
			, t.Fecha
			, t.FechaInicioPago
			, t.Parciales 
			, t.Monto
			, s.Intereses
			, s.Pagado
			, s.Descuento
			, ISNULL(t.Monto,0)+ISNULL(s.Intereses,0)-ISNULL(s.Pagado,0)-ISNULL(s.Descuento,0) as Adeudo
		from CRCTransaccion t
			inner join CRCCuentas c
				on t.CRCCuentasid = c.id
			inner join SNegocios sn
				on sn.SNid = c.SNegociosSNid
			inner join (
					select mc.CRCTransaccionid, sum(mc.Intereses) as Intereses, sum(mc.Pagado)  as Pagado , sum(mc.Descuento) as Descuento 
					from CRCMovimientoCuenta mc
					group by mc.CRCTransaccionid) as s
				on s.CRCTransaccionid = t.id
		where c.Ecodigo = #session.ecodigo#
			<cfif !isDefined('url.p')> and 1=0 </cfif>
			<cfif isdefined('form.tipoCta') && form.tipoCta neq ''>
				and rtrim(ltrim(c.Tipo)) = '#form.tipoCta#'
			</cfif>
			<cfif isdefined('form.SNid') && form.SNid neq ''>
				and rtrim(ltrim(sn.SNid)) = '#form.SNid#'
			</cfif>
			<cfif isdefined("Form.FechaHasta") && #Form.FechaHasta# neq "">
				<cfset form.FECHAHASTA = ListToArray(form.FECHAHASTA,'/')>
				<cfset form.FECHAHASTA = "#form.FECHAHASTA[3]#-#form.FECHAHASTA[2]#-#form.FECHAHASTA[1]#">
				and t.Fecha <= dateAdd(day, 1, <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaHasta#">)
			</cfif>
			<cfif isdefined("Form.FechaDesde") && #Form.FechaDesde# neq "">
				<cfset form.FECHADESDE = ListToArray(form.FECHADESDE,'/')>
				<cfset form.FECHADESDE = "#form.FECHADESDE[3]#-#form.FECHADESDE[2]#-#form.FECHADESDE[1]#">
				and t.Fecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaDesde#">
			</cfif>
			order by sn.SNid desc, c.Numero desc;
		;
	</cfquery>
	
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
										<cfif isdefined('form.tipoCta') && form.tipoCta neq ''> &amp; [Tipo Cuenta = #form.tipoCta#]</cfif>
										<cfif isdefined('form.SNid') && form.SNid neq ''> &amp; [SN = #form.SNid#]</cfif>
										<cfif isdefined('form.FechaHasta') && form.FechaHasta neq ''> &amp; [Fecha Hasta = #form.FechaHasta#]</cfif>
										<cfif isdefined('form.FechaDesde') && form.FechaDesde neq ''> &amp; [Fecha Desde = #form.FechaDesde#]</cfif>
									</td>
								</tr>
								<tr style="background-color: ##A9A9A9; ">
									<td>#LB_Nombre#</td>
									<td>#LB_Cuenta#</td>
									<td>#LB_TipoCuenta#</td>
									<td>#LB_TipoTransa#</td>
									<td>#LB_FechaT#</td>
									<td>#LB_FechaP#</td>
									<td>#LB_Parcialidad#</td>
									<td>#LB_Monto#</td>
									<td>#LB_Interes#</td>
									<td>#LB_Pagado#</td>
									<td>#LB_Descuento#</td>
									<td>#LB_Adeudo#</td>
								</tr>
								<cfset lastCuenta = 0>
								<cfset lastSN = 0>
								<cfset totalesSN = {}>
								<cfset totalesC = {}>
								<cfif q_DatosReporte.RecordCount gt 0>
									<cfloop query="q_DatosReporte">
										<cfif lastSN neq q_DatosReporte.SNid>
											<cfset lastSN = q_DatosReporte.SNid>
											<cfset totalesSN["#q_DatosReporte.SNid#"] = {"id"="#q_DatosReporte.SNid#","M"=0,"I"=0,"P"=0,"D"=0,"A"=0}>
											<tr style="background-color: ##CCCCCC;">
												<td>#q_DatosReporte.SNnombre#</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td id="s_#q_DatosReporte.SNid#_M">#LScurrencyFormat(0)#</td>
												<td id="s_#q_DatosReporte.SNid#_I">#LScurrencyFormat(0)#</td>
												<td id="s_#q_DatosReporte.SNid#_P">#LScurrencyFormat(0)#</td>
												<td id="s_#q_DatosReporte.SNid#_D">#LScurrencyFormat(0)#</td>
												<td id="s_#q_DatosReporte.SNid#_A">#LScurrencyFormat(0)#</td>
											</tr>
										</cfif>
										<cfif lastCuenta neq q_DatosReporte.Numero>
											<cfset lastCuenta = q_DatosReporte.Numero>
											<cfset totalesC["#q_DatosReporte.Numero#"] = {"id"="#q_DatosReporte.Numero#","M"=0,"I"=0,"P"=0,"D"=0,"A"=0}>
											<tr style="background-color: ##E8E8E8;">
												<td>&emsp;&ensp;#q_DatosReporte.SNnombre#</td>	
												<td>#q_DatosReporte.Numero#</td>
												<td>#q_DatosReporte.Tipo#</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td id="s_#q_DatosReporte.SNid#_M">#LScurrencyFormat(0)#</td>
												<td id="s_#q_DatosReporte.SNid#_I">#LScurrencyFormat(0)#</td>
												<td id="s_#q_DatosReporte.SNid#_P">#LScurrencyFormat(0)#</td>
												<td id="s_#q_DatosReporte.SNid#_D">#LScurrencyFormat(0)#</td>
												<td id="s_#q_DatosReporte.SNid#_A">#LScurrencyFormat(0)#</td>
											</tr>
										</cfif>
										<cfset m = q_DatosReporte.Monto>
										<cfset i = q_DatosReporte.Intereses>
										<cfset p = q_DatosReporte.Pagado>
										<cfset d = q_DatosReporte.Descuento>
										<cfset a = q_DatosReporte.Adeudo>
										<tr>
											<td>&emsp;&emsp;&ensp;#q_DatosReporte.SNnombre#</td>
											<td>#q_DatosReporte.Numero#</td>
											<td>#q_DatosReporte.Tipo#</td>
											<td>#q_DatosReporte.TipoTransaccion#</td>
											<td>#DateFormat(q_DatosReporte.Fecha,'yyyy-mm-dd')#</td>
											<td>#DateFormat(q_DatosReporte.FechaInicioPago,'yyyy-mm-dd')#</td>
											<td>#q_DatosReporte.Parciales#</td>
											<td id="s_#q_DatosReporte.SNid#_M">#LScurrencyFormat(m)#</td>
											<td id="s_#q_DatosReporte.SNid#_I">#LScurrencyFormat(i)#</td>
											<td id="s_#q_DatosReporte.SNid#_P">#LScurrencyFormat(p)#</td>
											<td id="s_#q_DatosReporte.SNid#_D">#LScurrencyFormat(d)#</td>
											<td id="s_#q_DatosReporte.SNid#_A">#LScurrencyFormat(a)#</td>
											
											<cfset totalesC["#q_DatosReporte.Numero#"].M += m>
											<cfset totalesC["#q_DatosReporte.Numero#"].I += i>
											<cfset totalesC["#q_DatosReporte.Numero#"].P += p>
											<cfset totalesC["#q_DatosReporte.Numero#"].D += d>
											<cfset totalesC["#q_DatosReporte.Numero#"].A += a>

											<cfset totalesSN["#q_DatosReporte.SNid#"].M += m>
											<cfset totalesSN["#q_DatosReporte.SNid#"].I += i>
											<cfset totalesSN["#q_DatosReporte.SNid#"].P += p>
											<cfset totalesSN["#q_DatosReporte.SNid#"].D += d>
											<cfset totalesSN["#q_DatosReporte.SNid#"].A += a>
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

	<cfloop collection="#totalesC#" item="item">
		<script>
			document.getElementById('c_#totalesC[item].id#_M').innerHTML = '#LSCurrencyFormat(totalesC[item].M)#'
			document.getElementById('c_#totalesC[item].id#_I').innerHTML = '#LSCurrencyFormat(totalesC[item].I)#'
			document.getElementById('c_#totalesC[item].id#_P').innerHTML = '#LSCurrencyFormat(totalesC[item].P)#'
			document.getElementById('c_#totalesC[item].id#_D').innerHTML = '#LSCurrencyFormat(totalesC[item].D)#'
			document.getElementById('c_#totalesC[item].id#_A').innerHTML = '#LSCurrencyFormat(totalesC[item].A)#'
		</script>
	</cfloop>
	<cfloop collection="#totalesSN#" item="item">
		<script>
			document.getElementById('s_#totalesSN[item].id#_M').innerHTML = '#LSCurrencyFormat(totalesSN[item].M)#'
			document.getElementById('s_#totalesSN[item].id#_I').innerHTML = '#LSCurrencyFormat(totalesSN[item].I)#'
			document.getElementById('s_#totalesSN[item].id#_P').innerHTML = '#LSCurrencyFormat(totalesSN[item].P)#'
			document.getElementById('s_#totalesSN[item].id#_D').innerHTML = '#LSCurrencyFormat(totalesSN[item].D)#'
			document.getElementById('s_#totalesSN[item].id#_A').innerHTML = '#LSCurrencyFormat(totalesSN[item].A)#'
		</script>
	</cfloop>


</cfoutput>
