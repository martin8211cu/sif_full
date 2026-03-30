<cfparam name="modo" default="ALTA">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo1 		= t.Translate('LB_Titulo1','Tiendas Full')>
<cfset LB_Titulo2		= t.Translate('LB_Titulo2','Reporte de Convenios')>
<cfset LB_Titulo3		= t.Translate('LB_Titulo3','Generado el')>

<cfset LB_SNIdentificacion		= t.Translate('LB_SNIdentificacion', 'Identificacion')>
<cfset LB_SNnombre				= t.Translate('LB_SNnombre', 'Nombre')>
<cfset LB_NUMERO				= t.Translate('LB_NUMERO', 'Num. Cuenta')>
<cfset LB_TIPOCTA				= t.Translate('LB_TIPOCTA', 'Tipo Cuenta')>
<cfset LB_CODIGO				= t.Translate('LB_CODIGO', 'Codigo')>
<cfset LB_DESCRIPCION			= t.Translate('LB_DESCRIPCION', 'Descripcion')>
<cfset LB_MONTO					= t.Translate('LB_MONTO', 'Monto')>
<cfset LB_MONTOT				= t.Translate('LB_MONTOT', 'Monto')>
<cfset LB_GASTO					= t.Translate('LB_GASTO', 'Gasto Cobranza')>
<cfset LB_TOTAL					= t.Translate('LB_TOTAL', 'Total')>
<cfset LB_ID					= t.Translate('LB_ID', 'ID')>
<cfset LB_Fecha					= t.Translate('LB_Fecha', 'Fecha')>
<cfset LB_PARCIALES				= t.Translate('LB_PARCIALES', 'Parcialidades')>
<cfset LB_MontoParcial				= t.Translate('LB_MontoParcial', 'Monto Parcial')>
<cfset LB_Observaciones			= t.Translate('LB_Observaciones', 'Observaciones')>
<cfset LB_TipoTransaccion		= t.Translate('LB_TipoT', 'Tipo')>
<cfset LB_Recalendariza			= t.Translate('LB_Recalendariza', 'Recalendarizacion')>


<cfset prevPag="reporteConvenio.cfm">
<cfset targetAction="reporteConvenio_sql.cfm">
<cfinclude template="imprimirReporte.cfm" >

<cfquery name="q_DatosReporte" datasource="#Session.DSN#">
	select distinct
		  sn.SNid
		, sn.SNnombre
		, sn.SNidentificacion
		, c.Numero
		, c.id as ctaID
		, c.Tipo
		, cv.id as cvID
		, cv.CodigoConvenio
		, cv.DescripConvenio
		, cv.MontoConvenio
		, cv.MontoGastoCobranza
		, cv.esPorcentaje
		, cv.Parcialidades
		, t.id as tID
		, t.Fecha
		, t.Monto
		, t.TipoTransaccion
		, t.Observaciones
		, t.Parciales
	from CRCMovimientoCuenta mc
		inner join CRCTransaccion t
			on t.id = mc.CRCTransaccionid
		inner join CRCCuentas c
			on c.id = t.CRCCuentasid
		inner join SNegocios sn
			on sn.SNid = c.SNegociosSNid
		inner join CRCConvenios cv
			on mc.CRCConveniosid = cv.id 
	where
		sn.ecodigo = #session.ecodigo#
		<cfif !isDefined('url.p')> and 1=0 </cfif>
		and mc.CRCConveniosid is not null
		and (sn.disT = 1 or sn.TarjH = 1 or sn.Mayor = 1)
		and sn.eliminado is null
		<cfif isdefined("Form.SNID") and Form.SNID neq "">
			and c.SNegociosSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNID#">
		</cfif>
		<cfif isdefined("Form.TipoCTA") and Form.TipoCTA neq "">
			<cfset  filtro= Replace(Form.TipoCTA,',',"','",'all')>
			and rtrim(ltrim(c.tipo)) in ('#PreserveSingleQuotes(filtro)#')
		</cfif>
		<cfif isdefined("Form.CanceladosT") >
			and c.CRCEstatusCuentasid = (select id from CRCCategoriaDist where Ecodigo = #session.ecodigo# and id = (select Pvalor from CRCParametros where Ecodigo = #session.ecodigo# and Pcodigo = '30100110'))
		</cfif>
	order by
		sn.SNid, c.Numero
</cfquery>

<cfquery name="q_SubqueryC" dbtype="query">
	select 
		  distinct(cvID) as cvID
		, SNid
		, SNnombre
		, SNidentificacion
		, Numero
		, ctaID
		, Tipo
		, CodigoConvenio
		, DescripConvenio
		, MontoConvenio
		, MontoGastoCobranza
		, esPorcentaje
		, Parcialidades
	from q_DatosReporte
</cfquery>

<cfset border = "width='100%' border='1' cellpadding='3' cellspacing='0'">

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
								<td colspan="11" align="right">
									Filtros: [Socio Negocio no eliminado]
									<cfif isdefined('Form.Nombre') && Form.Nombre neq ''> &amp; [Cliente = #Form.Nombre#]</cfif>
									<cfif isdefined('Form.TipoCTA') && Form.TipoCTA neq ''> &amp; [Tipo de cuenta = (#Form.TipoCTA#)]</cfif>
									<cfif isdefined("Form.CanceladosT") > &amp; [Convenios Cancelados]</cfif>
								</td>
							</tr>
							<cfif q_SubqueryC.RecordCount gt 0>
								<cfset currentClienteID = -1>
								<cfset currentCuentaID = -1>
								<cfset currentConvenioID = -1>

								<cfloop query="q_SubqueryC">

									<cfif isdefined('form.detallesT')>
										<cfif currentConvenioID neq -1 && q_SubqueryC.cvID neq currentConvenioID>
											<cfset html = recalendarizacion(currentConvenioID)>
											#html#
										</cfif>
									</cfif>
									<cfif q_SubqueryC.SNid neq currentClienteID>
										<cfset currentClienteID = q_SubqueryC.SNid>
										<tr style="background-color: ##A9A9A9; ">
											<td><b>#LB_SNnombre#:</b> #q_SubqueryC.SNnombre#</td>
											<td><b>#LB_SNIdentificacion#:</b> #q_SubqueryC.SNidentificacion#</td>
										</tr>
									</cfif>
									<cfif q_SubqueryC.ctaID neq currentCuentaID>
										<cfset currentCuentaID = q_SubqueryC.ctaID>
										<tr style="background-color: ##CCCCCC;">
											<td><b>#LB_Numero#:</b> #q_SubqueryC.Numero#</td>
											<td><b>#LB_TipoCta#:</b> #q_SubqueryC.Tipo#</td>
										</tr>
									</cfif>
									<cfif q_SubqueryC.cvID neq currentConvenioID>
										<cfset currentConvenioID = q_SubqueryC.cvID>
										<cfif q_SubqueryC.esPorcentaje eq 0> 
											<cfset MontoCobranza = q_SubqueryC.MontoGastoCobranza>
										<cfelse>
											<cfset MontoCobranza = (q_SubqueryC.MontoGastoCobranza/100) * q_SubqueryC.MontoConvenio>
										</cfif>
										
										<tr style="background-color: ##E8E8E8;" align="center"> 
											<td ><b>Convenio</b></td>
											<td >
												<table  #border#>
													<tr align="center">
														<td><b>#LB_Codigo#</b></td>
														<td><b>#LB_Descripcion#</b></td>
														<td><b>#LB_Monto#</b></td>
														<td><b>#LB_Gasto#</b></td>
														<td><b>#LB_Total#</b></td>
														<td><b>#LB_Parciales#</b></td>
														<td><b>#LB_MontoParcial#</b></td>
													</tr>
													<tr align="center">
														<td>#q_SubqueryC.CodigoConvenio#</td>
														<td>#q_SubqueryC.DescripConvenio#</td>
														<td>#LSCurrencyFormat(q_SubqueryC.MontoConvenio)#</td>
														<td>#LSCurrencyFormat(MontoCobranza)#</td>
														<td>#LSCurrencyFormat(MontoCobranza + q_SubqueryC.MontoConvenio)#</td>
														<td>#q_SubqueryC.Parcialidades#</td>
														<td>#LSCurrencyFormat((MontoCobranza + q_SubqueryC.MontoConvenio)/q_SubqueryC.Parcialidades)#</td>
													</tr>
												</table>
											</td>
										</tr>
									</cfif>
									<cfif isdefined('form.detallesT')>
										<cfquery name="q_SubqueryT" dbtype="query">
											select 
												  tID
												, Fecha
												, Monto
												, TipoTransaccion
												, Observaciones
												, Parciales
											from q_DatosReporte where cvID = #currentConvenioID#
										</cfquery>
										<tr><td>&nbsp;</td></tr>
										<tr align="center">
											<td><b>Transacciones</b></td>
											<td>
												<table  #border#>
													<tr align="center">
														<td><b>#LB_ID#</b></td>
														<td><b>#LB_Fecha#</b></td>
														<td><b>#LB_MontoT#</b></td>
														<td><b>#LB_TipoTransaccion#</b></td>
														<td><b>#LB_Parciales#</b></td>
														<td><b>#LB_Observaciones#</b></td>
													</tr>
													<cfloop query="q_SubqueryT">
														<tr align="center">
															<td>#q_SubqueryT.TID#</td>
															<td>#DateFormat(q_SubqueryT.Fecha,'dd/mm/yyyy')#</td>
															<td>#LSCurrencyFormat(q_SubqueryT.Monto)#</td>
															<td>#q_SubqueryT.TipoTransaccion#</td>
															<td>#q_SubqueryT.Parciales#</td>
															<td align="left">#q_SubqueryT.Observaciones#</td>
														</tr>
													</cfloop>
												</table>
											</td>
										</tr>
									</cfif>
								</cfloop>
								<cfif isdefined('form.detallesT')>
									<cfset html = recalendarizacion(currentConvenioID)>
									#html#
								</cfif>
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

<cffunction  name="recalendarizacion">
	<cfargument  name="convenioID">
	<cfoutput>
	<cfsavecontent variable = "html"> 
	<cfquery name="q_Recal" datasource="#session.dsn#">
		select mc.*
			, t.id as idT
			, t.Fecha as FechaT
			, t.Monto as MontoT
			, t.TipoTransaccion as TipoT
			, t.Observaciones as ObservacionT
			, t.Parciales as ParcialesT
		from CRCMovimientoCuenta mc
			inner join CRCTransaccion t
				on t.id = mc.CRCTransaccionid
			inner join CRCConvenios cv
				on cv.tidRecal = t.id
		where
			cv.id = #arguments.convenioID#
	</cfquery>
	<tr><td>&nbsp;</td></tr>
	<tr align="center">
		<td><b>Recalendarizacion</b></td>
		<td>
			<table #border#>
				<tr  align="center">
					<td><b>Corte</b></td>
					<td><b>Monto Requerido</b></td>
					<td><b>Monto A Pagar</b></td>
					<td><b>Descuento</b></td>
					<td><b>Pagado</b></td>
					<td><b>Intereses</b></td>
					<td><b>Saldo Vencido</b></td>
					<td><b>Descripcion</b></td>
				</tr>
				<cfloop query="q_Recal">
					<tr align="center">
						<td>#q_Recal.Corte#</td>
						<td>#LSCurrencyFormat(q_Recal.MontoRequerido)#</td>
						<td>#LSCurrencyFormat(q_Recal.MontoAPagar)#</td>
						<td>#LSCurrencyFormat(q_Recal.Descuento)#</td>
						<td>#LSCurrencyFormat(q_Recal.Pagado)#</td>
						<td>#LSCurrencyFormat(q_Recal.Intereses)#</td>
						<td>#LSCurrencyFormat(q_Recal.SaldoVencido)#</td>
						<td>#Left(q_Recal.Descripcion,7)#</td>
					</tr>
				</cfloop>
			</table>
		</td>
	</tr>
	</cfsavecontent>
	</cfoutput>
	<cfreturn html>
</cffunction>
