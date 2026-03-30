<cfparam name="modo" default="ALTA">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo1 		= t.Translate('LB_Titulo1','Tiendas Full')>
<cfset LB_Titulo2		= t.Translate('LB_Titulo2','Reporte de Cuentas')>
<cfset LB_Titulo3		= t.Translate('LB_Titulo3','Generado el')>

<cfset LB_Numero			= t.Translate('LB_Numero', 'Numero de Cuenta')>
<cfset LB_Nombre			= t.Translate('LB_Nombre', 'Nombre de Socio')>
<cfset LB_Tipo				= t.Translate('LB_Tipo', 'Tipo')>
<cfset LB_Creacion			= t.Translate('LB_Creacion', 'Apertura de Credito')>
<cfset LB_Estado			= t.Translate('LB_Estado', 'Estatus de Cuenta')>
<cfset LB_LimCred			= t.Translate('LB_LimCred', 'Limite de Credito')>
<cfset LB_Categoria			= t.Translate('LB_Categoria', 'Categoria')>
<cfset LB_Direccion			= t.Translate('LB_Direccion', 'Direccion')>
<cfset LB_Telefono			= t.Translate('LB_Telefono', 'Telefono')>
<cfset LB_SaldoActual		= t.Translate('LB_SaldoActual', 'Saldo Actual')>
<cfset LB_Compras			= t.Translate('LB_Compras', 'Compras')>
<cfset LB_Pagos				= t.Translate('LB_Pagos', 'Pagos')>
<cfset LB_SaldoVencido		= t.Translate('LB_SaldoVencido', 'Saldo Vencido')>
<cfset LB_Interes			= t.Translate('LB_Interes', 'Intereses')>
<cfset LB_Condonaciones		= t.Translate('LB_Condonaciones', 'Condonaciones')>
<cfset LB_GastoCobranza		= t.Translate('LB_GastoCobranza', 'Gasto de Cobranza')>

<cfset prevPag="reporteCuentas.cfm">
<cfset targetAction="reporteCuentas_sql.cfm">
<cfinclude template="imprimirReporte.cfm" >

<cfquery name="q_DatosReporte" datasource="#Session.DSN#">
	select
	<cfif isdefined("form.resumen")>
		c.Tipo
		, ec.Descripcion
		, sum(c.MontoAprobado) MontoAprobado
		, case ltrim(rtrim(c.tipo))
			when 'D' then cd.Descripcion
			else '' end as Categoria
		, sum(c.SaldoActual) SaldoActual
		, sum(c.Compras) Compras
		, sum(c.Pagos) Pagos
		, sum(c.SaldoVencido) SaldoVencido
		, sum(c.Interes) Interes
		, sum(c.Condonaciones) Condonaciones
		, sum(c.GastoCobranza) GastoCobranza
	<cfelse>
		c.Numero
		, sn.SNnombre
		, c.Tipo
		, c.createdat
		, ec.Descripcion
		, dias.DiasTranscurridos <!--- NAva --->
		, c.MontoAprobado
		, case ltrim(rtrim(c.tipo))
			when 'D' then cd.Descripcion
			else '' end as Categoria
		, sn.SNdireccion
		, sn.SNtelefono
		, TmontReq.MontoRequerido <!--- NAva --->
		, c.SaldoActual
		, c.Compras
		, c.Pagos
		, c.SaldoVencido
		, c.Interes
		, c.Condonaciones
		, c.GastoCobranza
	</cfif>
	from CRCCuentas c
		inner join SNegocios sn
			on sn.SNid = c.SNegociosSNid
		inner join CRCEstatusCuentas ec
			on ec.id = c.CRCEstatusCuentasid
		left join CRCCategoriaDist cd
			on cd.id = c.CRCCategoriaDistid
		<!--- NAva Se agrega el siguiente codigo --->
		Left join (                      
			select 
			ct.CRCCuentasid,
			cm.Corte, 
			SUm (cm.MontoRequerido) as MontoRequerido,
			cm.status
			from CRCMovimientoCuenta CM
			inner join CRCTransaccion CT ON CM.CRCTransaccionid = ct.id
			where cm.status = 1
			group by
			ct.CRCCuentasid,
			cm.Corte, 
			cm.status
		) as TmontReq
			on C.id = TmontReq.CRCCuentasid
		left join (
			SELECT 
				h.CRCCuentasid,
				DATEDIFF(DAY, h.FechaCambio, GETDATE()) AS DiasTranscurridos
			FROM  (
				-- Obtener el último cambio a estado 'Suspendido' por cuenta
				SELECT 
					CRCCuentasid,
					MAX(FechaCambio) AS FechaCambio
				FROM dbo.CRCHistoricoEstadoCuenta
				WHERE CRCEstatusCuentasidNuevo = 3
				GROUP BY CRCCuentasid
			) as h
		) as dias
			on c.id = dias.CRCCuentasid
		<!--- NAva Termina Codigo --->
	where
		c.ecodigo = #session.ecodigo#
		<cfif !isDefined('url.p')> and 1=0 </cfif>
		and sn.eliminado is null
		<cfif isdefined ("Form.TipoCTA") and Form.TipoCTA neq "">
			<cfset  filtro= Replace(Form.TipoCTA,',',"','",'all')>
			and rtrim(ltrim(c.tipo)) in ('#PreserveSingleQuotes(filtro)#')
		</cfif>
		<cfif isDefined('form.estadoCuenta')>
			<cfset estadoC = listToArray(form.estadoCuenta,'|',false,false)> 
			<cfif ArrayLen(estadoC) gt 0 && estadoC[1] ge 0>
				and c.CRCEstatusCuentasid = #estadoC[1]#
			</cfif>
		</cfif>
		<cfif isdefined("Form.fechaCreacionIni") && Form.fechaCreacionIni neq "">
			<cfset form.fechaCreacionIni = ListToArray(form.fechaCreacionIni,'/')>
			<cfset form.fechaCreacionIni = "#form.fechaCreacionIni[3]#-#form.fechaCreacionIni[2]#-#form.fechaCreacionIni[1]#">
			and sn.SNfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fechaCreacionIni#">
		</cfif>
		<cfif isdefined("Form.fechaCreacionFin") && Form.fechaCreacionFin neq "">
			<cfset form.fechaCreacionFin = ListToArray(form.fechaCreacionFin,'/')>
			<cfset form.fechaCreacionFin = "#form.fechaCreacionFin[3]#-#form.fechaCreacionFin[2]#-#form.fechaCreacionFin[1]#">
			and sn.SNfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.fechaCreacionFin#">
		</cfif>
		<cfif isDefined('form.categoriaCuenta')>
			<cfset categoriaC = listToArray(form.categoriaCuenta,'|',false,false)> 
			<cfif ArrayLen(categoriaC) gt 0 && categoriaC[1] ge 0>
				and c.crccategoriadistid = case rtrim(ltrim(c.tipo))
					when 'D' then #categoriaC[1]#
					else c.crccategoriadistid
					end
			</cfif>
		</cfif>
		<cfif isdefined("form.resumen")>
			group by c.Tipo
			, ec.Descripcion
			, case ltrim(rtrim(c.tipo))
				when 'D' then cd.Descripcion
				else '' end
		</cfif>
</cfquery>

<cfquery name="rsCuentaTotal" dbtype="query">
	select sum(MontoAprobado) MontoAprobado
		, sum(SaldoActual) SaldoActual
		, sum(Compras) Compras
		, sum(Pagos) Pagos
		, sum(SaldoVencido) SaldoVencido
		, sum(Interes) Interes
		, sum(Condonaciones) Condonaciones
		, sum(GastoCobranza) GastoCobranza
	from q_DatosReporte
</cfquery>

<cfset modo="ALTA">


<cfoutput>
<!--- Tabla para mostrar resultados del reporte generado --->
<div id="#printableArea#">
	<table width="140%" cellpadding="2" cellspacing="0">
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
								<td <cfif not isdefined("form.resumen")>colspan="16"<cfelse>colspan="8"</cfif> align="right">
									Filtros:
									<cfif isdefined('Form.TipoCTA') && Form.TipoCTA neq ''> [Tipo de cuenta = (#Form.TipoCTA#)]</cfif>
									<cfif isDefined('form.estadoCuenta') > 
										<cfif ArrayLen(estadoC) gt 0 && estadoC[1] ge 0>[Estado de cuenta = (#estadoC[2]#)]</cfif>
									</cfif>
									<cfif isDefined('form.categoriaCuenta') > 
										<cfif ArrayLen(categoriaC) gt 0 && categoriaC[1] ge 0>[Categoria de Distribuidor = (#categoriaC[2]#)]</cfif>
									</cfif>
								</td>
							</tr>
							<tr style="background-color: ##A9A9A9;">
								<cfif not isdefined("form.resumen")>
									<td align="center">#LB_Numero#</td>
									<td align="center">#LB_Nombre#</td>
								</cfif>
								<td align="center">#LB_Tipo#</td>
								<cfif not isdefined("form.resumen")>
									<td align="center">#LB_Creacion#</td>
								</cfif>
								<td align="center">#LB_Estado#</td>
								<td align="center">Dias Transcurridos</td> <!--- NAva --->
								<cfif not isdefined("form.resumen")>
									<td align="right">#LB_LimCred#</td>
								</cfif>
								<td align="center">#LB_Categoria#</td>
								<cfif not isdefined("form.resumen")>
									<td align="center">#LB_Direccion#</td>
									<td align="center">#LB_Telefono#</td>
								</cfif>
								<td align="right">Monto Requerido</td> <!--- NAva --->
								<td align="right">#LB_SaldoActual#</td>
								<cfif not isdefined("form.resumen")>
									<td align="right">#LB_Compras#</td>
									<td align="right">#LB_Pagos#</td>
								</cfif>
								<td align="right">#LB_SaldoVencido#</td>
								<td align="right">#LB_Interes#</td>
								<td align="right">#LB_Condonaciones#</td>
								<td align="right">#LB_GastoCobranza#</td>
							</tr>
							<cfif q_DatosReporte.RecordCount gt 0>
								<cfloop query="q_DatosReporte">
									<tr>
										<cfif not isdefined("form.resumen")>
											<td align="center">#q_DatosReporte.Numero#</td>
											<td align="center">#q_DatosReporte.SNnombre#</td>
										</cfif>
										<td align="center">#q_DatosReporte.Tipo#</td>
										<cfif not isdefined("form.resumen")>
											<td align="center">#DateFormat(q_DatosReporte.createdat,"dd/mm/yyyy")#</td>
										</cfif>
										<td align="center">#q_DatosReporte.Descripcion#</td>
										<td align="right">#q_DatosReporte.DiasTranscurridos#</td> <!--- NAva --->
										<cfif not isdefined("form.resumen")>
											<td align="right">#lsCurrencyFormat(q_DatosReporte.MontoAprobado)#</td>
										</cfif>
										<td align="center">#q_DatosReporte.Categoria#</td>
										<cfif not isdefined("form.resumen")>
											<td align="center">#q_DatosReporte.SNdireccion#</td>
											<td align="center">#q_DatosReporte.SNtelefono#</td>
										</cfif>
										<td align="right">#lsCurrencyFormat(q_DatosReporte.MontoRequerido)#</td> <!--- NAva --->
										<td align="right">#lsCurrencyFormat(q_DatosReporte.SaldoActual)#</td>
										<cfif not isdefined("form.resumen")>
											<td align="right">#lsCurrencyFormat(q_DatosReporte.Compras)#</td>
											<td align="right">#lsCurrencyFormat(q_DatosReporte.Pagos)#</td>
										</cfif>
										<td align="right">#lsCurrencyFormat(q_DatosReporte.SaldoVencido)#</td>
										<td align="right">#lsCurrencyFormat(q_DatosReporte.Interes)#</td>
										<td align="right">#lsCurrencyFormat(q_DatosReporte.Condonaciones)#</td>
										<td align="right">#lsCurrencyFormat(q_DatosReporte.GastoCobranza)#</td>
									</tr>
								</cfloop>
								<tr style="background-color: ##A9A9A9; " align="center">
									<td align="right" <cfif not isdefined("form.resumen")>colspan="5"<cfelse>colspan="3"</cfif>>TOTAL</td>
									<cfif not isdefined("form.resumen")>
										<td align="right">#LScurrencyFormat(abs(rsCuentaTotal.MontoAprobado))#</td>
										<td colspan="3"></td>
									</cfif>
									<td align="right">#lsCurrencyFormat(abs(rsCuentaTotal.SaldoActual))#</td>
									<cfif not isdefined("form.resumen")>
										<td align="right">#lsCurrencyFormat(abs(rsCuentaTotal.Compras))#</td>
										<td align="right">#LScurrencyFormat(abs(rsCuentaTotal.Pagos))#</td>
									</cfif>
									<td align="right">#lsCurrencyFormat(abs(rsCuentaTotal.SaldoVencido))#</td>
									<td align="right">#lsCurrencyFormat(abs(rsCuentaTotal.Interes))#</td>
									<td align="right">#lsCurrencyFormat(abs(rsCuentaTotal.Condonaciones))#</td>
									<td align="right">#lsCurrencyFormat(abs(rsCuentaTotal.GastoCobranza))#</td>
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

