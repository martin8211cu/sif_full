
<cfset LvarIrAFrameConfig="frame-config.cfm">
<cfset LvarIrAFrameProgre="frame-Progreso.cfm">
 <cfset LvarIrAConciliacion="/cfmx/sif/mb/operacion/Conciliacion.cfm">
<cfset LvarIrRPartidasSinCon="RPPartidasSinConciliar.cfm">
<cfset LvarIrARPresumConci="RPresumenConciliacion.cfm">
<cfset LvarIrAOperaRPresumConci="../../sif/mb/operacion/RPresumenConciliacion.cfm">
<cfset LvarIrAResConGuard="ResConGuardaObs.cfm">
<cfset LvarIrAConciliaApply="Conciliacion-Apply.cfm"> 
<cfset LvarCBesTCE=0><!---Filtro para los querys TCE o CuentasBancarias--->
<cfif isdefined("LvarTCEresumenCon")>
	<cfset LvarIrAFrameConfig="../../tce/operaciones/TCEframe-config.cfm">
	<cfset LvarIrAFrameProgre="../../tce/operaciones/TCEframe-Progreso.cfm">
 	<cfset LvarIrAConciliacion="../../sif/tce/operaciones/TCEConciliacion.cfm">
	<cfset LvarIrRPartidasSinCon="TCERPPartidasSinConciliar.cfm">
	<cfset LvarIrARPresumConci="TCERPresumenConciliacion.cfm">
	<cfset LvarIrAOperaRPresumConci="../../sif/tce/operaciones/TCEOperaRPresumenConciliacion.cfm">
 	<cfset LvarIrAResConGuard="TCEResConGuardaObs.cfm">
	<cfset LvarIrAConciliaApply="TCEConciliacion-Apply.cfm"> 
 	<cfset LvarCBesTCE=1><!---Filtro para los querys TCE o CuentasBancarias--->
</cfif>	
	 
	
<cfif isdefined('url.ECid') and isdefined('url.imprimir')>
	<cfset form.ECid = url.ECid>
</cfif>

<cf_dbfunction name="now" returnvariable="now">
<cfquery name="rsDatosEC" datasource="#session.DSN#">
	select ec.ECid,
		ec.ECdescripcion,
		b.Bdescripcion, 
		cb.CBdescripcion, 
		ec.Bid,
		coalesce(ec.ECdesde, #now# ) as ECdesde,
		coalesce(ec.EChasta, #now# ) as EChasta	
	from ECuentaBancaria ec
	inner join CuentasBancos cb
	   on cb.CBid = ec.CBid
	  and cb.Bid = ec.Bid
	  and cb.Ecodigo =  #Session.Ecodigo# 
	inner join Bancos b
	   on b.Bid = cb.Bid
	  and b.Ecodigo = cb.Ecodigo
	where ec.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
 		<!---Filtro para tarjetas de credito o cuentas bancarias--->
		and cb.CBesTCE = #LvarCBesTCE#
</cfquery>

<cfset vparams ="">
<cfset vparams = vparams & "&ECid=" & form.ECid >
		
	<cfif not (isDefined("Form.ECid") and Len(Trim(Form.ECid)))>
		<!---Redireccion Conciliacion.cfm o TCEConciliacion.cfm (TCE)--->
		<cflocation addtoken="no" url="#LvarIrAConciliacion#">
	</cfif>
		<cfquery name="rsTransacciones" datasource="#Session.DSN#">
			select b.BTid, b.BTcodigo,
				case b.BTtipo when 'D' then '+' when 'C' then '-' else '' end as SumaResta,
				b.BTdescripcion
			from BTransacciones b
			where b.Ecodigo = #Session.Ecodigo#
			order by b.BTid, b.BTcodigo, b.BTdescripcion, b.BTtipo
		</cfquery>
		<cfquery name="rsResumenConcLibros" datasource="#Session.DSN#">
			select 
				b.BTid, b.BTcodigo, 
				case b.BTtipo when 'D' then '+' when 'C' then '-' else '' end as SumaResta,
				b.BTdescripcion, 
				count(c.CDLidtrans) as Cantidad, 
				round(coalesce(sum(c.CDLmonto), 0.00),2) as Despliegue, 
				round(coalesce(sum(c.CDLmonto), 0.00),2) as Suma 
			from CDLibros c, MLibros a, ECuentaBancaria ec, BTransacciones b
			where c.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
			  and c.MLid = a.MLid
			  and c.CDLconciliado = 'N'
			  and c.CDLgrupo is null
			  and c.ECid = ec.ECid
			  and a.CBid = ec.CBid
			  and b.Ecodigo =  #Session.Ecodigo# 
			  and b.BTid = c.CDLidtrans
			group by b.BTid, b.BTcodigo, b.BTdescripcion, b.BTtipo ,case b.BTtipo when 'D' then '+' when 'C' then '-' else '' end
		</cfquery>
		<cfset suma1 = 0>
		<cfset suma2 = 0>
		<cfquery name="rsDebitosLibros" dbtype="query">
		select sum(Suma) as Suma from rsResumenConcLibros where SumaResta = '+'
		</cfquery>
		<cfif rsDebitosLibros.recordCount GT 0>
			<cfset DebitosLibros = rsDebitosLibros.Suma>
			<cfelse>
			<cfset DebitosLibros = 0.00>
		</cfif>
		<cfquery name="rsCreditosLibros" dbtype="query">
		select sum(Suma) as Suma from rsResumenConcLibros where SumaResta = '-'
		</cfquery>
		<cfif rsCreditosLibros.recordCount GT 0>
			<cfset CreditosLibros = rsCreditosLibros.Suma>
			<cfelse>
			<cfset CreditosLibros = 0.00>
		</cfif>
		<cfquery name="rsResumenConcBancos" datasource="#Session.DSN#">
			select c.Bid, c.BTEcodigo, 
				case c.BTEtipo when 'D' then '+' when 'C' then '-' else '' end as SumaResta,
				c.BTEdescripcion, 
				count(b.BTEcodigo) as Cantidad, 
				round(coalesce(sum(cd.CDBmonto), 0.00),2) as Despliegue, 
				round(coalesce(sum(cd.CDBmonto), 0.00),2) as Suma 
			from CDBancos cd, DCuentaBancaria b, TransaccionesBanco c
			where cd.ECid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
			and cd.CDBconciliado 	= 'N'
			and cd.CDBgrupo is null
			and cd.CDBlinea 	   	= b.Linea
			and b.Bid 		  		= c.Bid
			and b.BTEcodigo 	   	= c.BTEcodigo
            and b.Ecodigo =  #Session.Ecodigo# 
			group by c.Bid, c.BTEcodigo, c.BTEdescripcion, c.BTEtipo, case c.BTEtipo when 'D' then '+' when 'C' then '-' else '' end
		</cfquery>
		<cfquery name="rsDebitosBancos" dbtype="query">
			select sum(Suma) as Suma from rsResumenConcBancos where SumaResta = '+'
		</cfquery>
		<cfif rsDebitosBancos.recordCount GT 0>
			<cfset DebitosBancos = rsDebitosBancos.Suma>
			<cfelse>
			<cfset DebitosBancos = 0.00>
		</cfif>
		<cfquery name="rsCreditosBancos" dbtype="query">
			select sum(Suma) as Suma from rsResumenConcBancos where SumaResta = '-'
		</cfquery>
		<cfif rsCreditosBancos.recordCount GT 0>
			<cfset CreditosBancos = rsCreditosBancos.Suma>
			<cfelse>
			<cfset CreditosBancos = 0.00>
		</cfif>
		<cfquery name="rsPeriodo" datasource="#Session.DSN#">
			select Pvalor as Periodo
			from Parametros
			where Ecodigo =  #Session.Ecodigo# 
			  and Pcodigo = 50
			  and Mcodigo = 'GN'
		</cfquery>
		<cfquery name="rsMes" datasource="#Session.DSN#">
			select Pvalor as Mes
			from Parametros
			where Ecodigo =  #Session.Ecodigo# 
			  and Pcodigo = 60
			  and Mcodigo = 'GN'
		</cfquery>
		<cfquery name="rsEC" datasource="#session.DSN#">
			select CBid,ECdesde,EChasta, Bid, ECsaldofin, ECobservacion,
				<cf_dbfunction name="date_part" args="mm,EChasta"> as mes, 
				<cf_dbfunction name="date_part" args="yyyy,EChasta"> as periodo
			from ECuentaBancaria
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
		</cfquery>
		<cfset fechaCorte = #rsEC.EChasta#>
		<cfset fechaCorte = Dateadd('d',1,fechaCorte)>
		<cfquery name="rsTransaccionesB" datasource="#Session.DSN#">
			select b.Bid, b.BTEcodigo,
			case b.BTEtipo when 'D' then '+' when 'C' then '-' else '' end as SumaResta,
			b.BTEdescripcion
			from TransaccionesBanco b
			where b.Bid = #rsEC.Bid#
			order by b.Bid, b.BTEcodigo, b.BTEdescripcion, b.BTEtipo
		</cfquery>
		<cfquery name="rsSaldoLibros" datasource="#Session.DSN#">
			select 
                <cfif LvarCBesTCE eq 0>             
                   <!--- BANCOS--->
                        round(coalesce((
                            select sum(sb.Sinicial)
                             from SaldosBancarios sb
                            where sb.CBid = #rsEC.CBid#       <!---Cuenta Bancaria del Estado de Cuenta--->
                            and Periodo   = #rsEC.periodo#    <!---Año del Estado de Cuenta--->
                            and Mes       = #rsEC.mes#        <!---Mes del Estado de Cuenta--->
                            ),0.00)
						+ 
                        coalesce((select sum(MLmonto * case when MLtipomov = 'D' then 1 else -1 end) 
                                    from MLibros
                                    where CBid    = #rsEC.CBid#      <!--- Cuenta Bancaria del Estado de Cuenta--->
                                    and MLperiodo = #rsEC.periodo#   <!--- Año del Estado de Cuenta--->
                                    and MLmes     = #rsEC.mes#       <!--- Mes del Estado de Cuenta--->
                                    and MLfecha   < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaCorte#">  <!--- Fecha del Estado de Cuenta (Fecha Hasta)--->
                                    ) , 0.00),2) as Saldo 
                                    
				<cfelse>
                <!--- TCE--->
                        coalesce((select sum(MLmonto * case when MLtipomov = 'D' then 1 else -1 end) 
                                    from MLibros
                                    where CBid    = #rsEC.CBid#      <!--- Cuenta Bancaria del Estado de Cuenta--->
								    and MLfecha   < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaCorte#">  <!--- Fecha del Estado de Cuenta (Fecha Hasta)--->
                                    ) , 0.00) as Saldo 
                </cfif>
			from dual
		</cfquery>

		<cfif rsSaldoLibros.recordCount GT 0>
			<cfset SaldoLibros = rsSaldoLibros.Saldo>
			<cfelse>
			<cfset SaldoLibros = 0.00>
		</cfif>
		<cfif rsEC.recordCount GT 0>
			<cfset SaldoBancos = rsEC.ECsaldofin>
		<cfelse>
			<cfset SaldoBancos = 0.00>
		</cfif>
		
        <!---ERBG Modoficación SCNo 1823232 Inicia 94358.81--->
		<cfquery name="rsConciliadosLibros" datasource="#Session.DSN#">
            select coalesce(sum(CDLmonto * case when CDLtipomov = 'D' then -1 else 1 end),0) as SaldoConciliadoLibro 
            from CDLibros a
                inner join MLibros b
                on b.MLid = a.MLid
                inner join BTransacciones c
                on c.BTid = a.CDLidtrans
            where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
              and a.CDLconciliado = 'S'        
        </cfquery>
        <cfset sumaLibros = 0>
		<cfif rsConciliadosLibros.recordCount GT 0>
        	<cfset sumaLibros = #rsConciliadosLibros.SaldoConciliadoLibro#>
        </cfif>
		<cfquery name="rsConciliadosBancos" datasource="#Session.DSN#">
            select coalesce(sum(CDBmonto * case when CDBtipomov = 'D' then -1 else 1 end),0) as SaldoConciliadoBanco
            from CDBancos a
                inner join TransaccionesBanco b 
                on b.Bid = a.Bid 
               and b.BTEcodigo = a.BTEcodigo
            where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
              and a.CDBconciliado = 'S'  
       	</cfquery>
        <cfset sumaBancos = 0>
		<cfif rsConciliadosBancos.recordCount GT 0>
        	<cfset sumaBancos = #rsConciliadosBancos.SaldoConciliadoBanco#>
       	</cfif>
        <!---ERBG Modoficación SCNo 1823232 Fim--->
<cf_templateheader title="Resumen Conciliación">
	<cfif not isdefined("url.imprimir")>
    <cfinclude template="../../portlets/pNavegacion.cfm">
	</cfif>
	<!---Redireccion frame-config.cfm o TCEframe-config.cfm (TCE)--->
		<cfinclude template="#LvarIrAFrameConfig#">
        <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo=''>
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td width="85%" valign="top">
					<!--- <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Resumen de Conciliaci&oacute;n'> --->
				
						<!---Redireccion Conciliacion-Apply.cfm o TCEConciliacion-Apply.cfm (TCE)--->
						<form method="post" name="form1" action="<cfoutput>#LvarIrAConciliaApply#</cfoutput>">
							<input name="ECid" type="hidden" value="<cfif isDefined('Form.ECid') and Form.ECid NEQ ''><cfoutput>#Form.ECid#</cfoutput></cfif>">
							
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr><td>&nbsp;</td></tr>
								<cfif not isdefined("url.imprimir")>
									<tr>
										<td colspan="3">
											<table width="100%" border="0" cellpadding="2" cellspacing="0">
												<tr>
													<td valign="top">
														
														<!---Redireccion RPresumenConciliacion.cfm o TCERPresumenConciliacion.cfm (TCE)--->
														<cf_rhimprime datos="#LvarIrAOperaRPresumConci#" paramsuri="#vparams#">
													</td>	
												</tr>
											</table>
										</td>
									</tr>
								</cfif>
								<tr>
									<td colspan="3">
										<table width="100%" border="0">
											<tr>
												<td align="right" nowrap><span style="font-size:10px"><strong>Cuenta:</strong></span></td>
												<td nowrap>
													<span style="font-size:10px">
														<cfif isDefined("Form.ECid")>
															<cfoutput>#rsDatosEC.Bdescripcion# - #rsDatosEC.CBdescripcion#</cfoutput>
														<cfelse>
															<cfoutput>#rsDatosEC.getField(1,3)# - #v.getField(1,4)#</cfoutput>
														</cfif>
													</span>
												</td>
											</tr>
											<tr> 
												<td align="right" nowrap>&nbsp;</td>
												<td nowrap>
													<span style="font-size:10px"><cfoutput>#rsDatosEC.ECdescripcion#</cfoutput></span>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr><td colspan="3">&nbsp;</td></tr>
								<tr>
									<td colspan="2" valign="top">
										<table width="100%" border="0" cellpadding="1" cellspacing="0">
											<tr>
												<td width="33%" nowrap> <font size="2" face="Arial, Helvetica, sans-serif">Saldo a la fecha:</font> <strong> <font color="#0099CC" size="2" face="Arial, Helvetica, sans-serif"> &nbsp;<cfoutput>#LSDateFormat(rsEC.EChasta,'dd-mm-yyyy')#</cfoutput> </font> </strong> </td>
											</tr>												
											<tr bgcolor="#ECECEC">
												<td nowrap> <font size="2"><strong>&nbsp;Saldo seg&uacute;n Libros:</strong></font> </td>
												<td width="15%" align="right"> <font size="2"> <strong><cfoutput>#LSCurrencyFormat(SaldoLibros,"none")#</cfoutput></strong> </font> </td>
												<td width="3%">&nbsp;</td>
												<td width="25%" nowrap> <font size="2"><strong>&nbsp;Saldo seg&uacute;n Bancos:</strong></font> </td>
												<td width="24%" align="right"> <font size="2"> <strong><cfoutput>#LSCurrencyFormat(SaldoBancos,"none")#</cfoutput></strong> </font> </td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td width="50%" valign="top">
										<table width="100%" align="left" cellpadding="0" cellspacing="1" border="0">
											<tr  class="subTitulo">
												<td bgcolor="#E2E2E2"><strong>&nbsp;Suma/Resta</strong></td>
												<td nowrap bgcolor="#E2E2E2"><strong>&nbsp;Docs. NO conciliados</strong></td>
												<td bgcolor="#E2E2E2"><strong>&nbsp;Cantidad</strong></td>
												<td bgcolor="#E2E2E2" align="right"><strong>Monto</strong></td>
												<td>&nbsp;</td>
											</tr>
<!---											<cfloop query="rsTransacciones">
												<cfoutput>
													<cfset ids = ValueList(rsResumenConcLibros.BTid, ',')>
													<cfset pos = ListFind(ids, rsTransacciones.BTid, ',')>
													<cfif pos GT 0>
														<cfset sumaresta = ListGetAt(ValueList(rsResumenConcLibros.SumaResta, ','), pos, ',')>
														<cfset descripcion = ListGetAt(ValueList(rsResumenConcLibros.BTdescripcion, ','), pos, ',')>
														<cfset cant = ListGetAt(ValueList(rsResumenConcLibros.Cantidad, ','), pos, ',')>
														<cfset despliegue = ListGetAt(ValueList(rsResumenConcLibros.Despliegue, ','), pos, ',')>
													<cfelse>
														<cfset sumaresta = "">
														<cfset descripcion = rsTransacciones.BTdescripcion>
														<cfset cant = "0">
														<cfset despliegue = "0.00">
													</cfif>
													<cfif despliegue gt 0>
														<tr <cfif rsTransacciones.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
															<td align="center"><cfif Len(Trim(sumaresta))>#sumaresta#<cfelse>&nbsp;</cfif></td>
															<td nowrap><cfif Len(Trim(descripcion))>#descripcion#<cfelse>&nbsp;</cfif></td>
															<td align="center"><cfif Len(Trim(cant))>#cant#<cfelse>&nbsp;</cfif></td>
															<td align="right"><cfif Len(Trim(despliegue))>#LSNumberFormat(despliegue,',9.00')#<cfelse>&nbsp;</cfif></td>
															<td>&nbsp;</td>
														</tr>
													</cfif>
												</cfoutput>
											</cfloop>--->
											<cfloop query="rsTransaccionesB">
												<cfoutput>
													<cfset ids = ValueList(rsResumenConcBancos.BTEcodigo, ',')>
													<cfset pos = ListFind(ids, rsTransaccionesB.BTEcodigo, ',')>
													<cfif pos GT 0>
														<cfset sumaresta = ListGetAt(ValueList(rsResumenConcBancos.SumaResta, ','), pos, ',')>
														<cfset descripcion = ListGetAt(ValueList(rsResumenConcBancos.BTEdescripcion, ','), pos, ',')>
														<cfset cant = ListGetAt(ValueList(rsResumenConcBancos.Cantidad, ','), pos, ',')>
														<cfset despliegue = ListGetAt(ValueList(rsResumenConcBancos.Despliegue, ','), pos, ',')>
													<cfelse>
														<cfset sumaresta = "">
														<cfset descripcion = rsTransaccionesB.BTEdescripcion>
														<cfset cant = "0">
														<cfset despliegue = "0.00">
													</cfif>

													<cfif despliegue gt 0>
														<tr <cfif rsTransacciones.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
															<td align="center"><cfif Len(Trim(sumaresta))>#sumaresta#<cfelse>&nbsp;</cfif></td>
															<td><cfif Len(Trim(descripcion))>#descripcion#<cfelse>&nbsp;</cfif></td>
															<td align="center"><cfif Len(Trim(cant))>#cant#<cfelse>&nbsp;</cfif></td>
															<td align="right"><cfif Len(Trim(despliegue))>#LSNumberFormat(despliegue,',9.00')#<cfelse>&nbsp;</cfif></td>
														</tr>
													</cfif>
												</cfoutput>
											</cfloop>
										</table>
									</td>
									<td width="50%" valign="top">
										<table width="100%" align="left" cellpadding="0" cellspacing="1">
											<tr bgcolor="#E2E2E2">
												<td><strong>&nbsp;Suma/Resta</strong></td>
												<td nowrap><strong>&nbsp;Docs.  NO conciliados</strong></td>
												<td><strong>&nbsp;Cantidad</strong></td>
												<td align="right"><strong>Monto</strong></td>
											</tr>
											<!---<cfloop query="rsTransaccionesB">
												<cfoutput>
													<cfset ids = ValueList(rsResumenConcBancos.BTEcodigo, ',')>
													<cfset pos = ListFind(ids, rsTransaccionesB.BTEcodigo, ',')>
													<cfif pos GT 0>
														<cfset sumaresta = ListGetAt(ValueList(rsResumenConcBancos.SumaResta, ','), pos, ',')>
														<cfset descripcion = ListGetAt(ValueList(rsResumenConcBancos.BTEdescripcion, ','), pos, ',')>
														<cfset cant = ListGetAt(ValueList(rsResumenConcBancos.Cantidad, ','), pos, ',')>
														<cfset despliegue = ListGetAt(ValueList(rsResumenConcBancos.Despliegue, ','), pos, ',')>
													<cfelse>
														<cfset sumaresta = "">
														<cfset descripcion = rsTransaccionesB.BTEdescripcion>
														<cfset cant = "0">
														<cfset despliegue = "0.00">
													</cfif>

													<cfif despliegue gt 0>
														<tr <cfif rsTransacciones.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
															<td align="center"><cfif Len(Trim(sumaresta))>#sumaresta#<cfelse>&nbsp;</cfif></td>
															<td><cfif Len(Trim(descripcion))>#descripcion#<cfelse>&nbsp;</cfif></td>
															<td align="center"><cfif Len(Trim(cant))>#cant#<cfelse>&nbsp;</cfif></td>
															<td align="right"><cfif Len(Trim(despliegue))>#LSNumberFormat(despliegue,',9.00')#<cfelse>&nbsp;</cfif></td>
														</tr>
													</cfif>
												</cfoutput>
											</cfloop>--->
											<cfloop query="rsTransacciones">
												<cfoutput>
													<cfset ids = ValueList(rsResumenConcLibros.BTid, ',')>
													<cfset pos = ListFind(ids, rsTransacciones.BTid, ',')>
													<cfif pos GT 0>
														<cfset sumaresta = ListGetAt(ValueList(rsResumenConcLibros.SumaResta, ','), pos, ',')>
														<cfset descripcion = ListGetAt(ValueList(rsResumenConcLibros.BTdescripcion, ','), pos, ',')>
														<cfset cant = ListGetAt(ValueList(rsResumenConcLibros.Cantidad, ','), pos, ',')>
														<cfset despliegue = ListGetAt(ValueList(rsResumenConcLibros.Despliegue, ','), pos, ',')>
													<cfelse>
														<cfset sumaresta = "">
														<cfset descripcion = rsTransacciones.BTdescripcion>
														<cfset cant = "0">
														<cfset despliegue = "0.00">
													</cfif>
													<cfif despliegue gt 0>
														<tr <cfif rsTransacciones.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
															<td align="center"><cfif Len(Trim(sumaresta))>#sumaresta#<cfelse>&nbsp;</cfif></td>
															<td nowrap><cfif Len(Trim(descripcion))>#descripcion#<cfelse>&nbsp;</cfif></td>
															<td align="center"><cfif Len(Trim(cant))>#cant#<cfelse>&nbsp;</cfif></td>
															<td align="right"><cfif Len(Trim(despliegue))>#LSNumberFormat(despliegue,',9.00')#<cfelse>&nbsp;</cfif></td>
															<td>&nbsp;</td>
														</tr>
													</cfif>
												</cfoutput>
											</cfloop>
										</table>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<table width="100%" border="0" cellpadding="0" cellspacing="0">
											<tr bgcolor="#E8E8E8">
												<cfif SaldoLibros EQ ''>
													<cfset SaldoLibros = 0>
												</cfif>
												<cfif DebitosLibros EQ ''>
													<cfset DebitosLibros = 0>
												</cfif>
												<cfif CreditosLibros EQ ''>
													<cfset CreditosLibros = 0>
												</cfif>
												<cfif SaldoBancos EQ ''>
													<cfset SaldoBancos = 0>
												</cfif>
												<cfif DebitosBancos EQ ''>
													<cfset DebitosBancos = 0>
												</cfif>
												<cfif CreditosBancos EQ ''>
													<cfset CreditosBancos = 0>
												</cfif>
												<!---<cfset suma1 = SaldoLibros+DebitosLibros-CreditosLibros>
												<cfset suma2 = SaldoBancos+DebitosBancos-CreditosBancos>--->
												<cfset suma1 = SaldoLibros+DebitosBancos-CreditosBancos>
												<cfset suma2 = SaldoBancos+DebitosLibros-CreditosLibros>
												<cfset LvarDiferencia = suma2 - suma1>
												<cfset suma1 = suma1 + LvarDiferencia>
												<cfset LvarDiferencia = suma2 - suma1>
												<td width="33%"> <font size="2"><strong>&nbsp;Sumas Iguales</strong>:</font> </td>
												<td width="16%" align="right"> <font size="2"><strong><cfoutput>#LSCurrencyFormat(suma1,'none')#</cfoutput></strong></font> </td>
												<td width="51%" align="right"> <font size="2"><strong><cfoutput>#LSCurrencyFormat(suma2,"none")#</cfoutput></strong></font> </td>
											</tr>
											<tr>
												<td colspan="3" align="right"> <font size="2"><strong>Diferencia entre bancos y Libros:&nbsp;&nbsp;<cfoutput>#LSCurrencyFormat(( LvarDiferencia) ,"none")#</cfoutput></strong></font> </td>
											</tr>
											<tr><td colspan="3">&nbsp;</td></tr>
											<tr> 
											  	<td colspan="2" align="center" valign="top" > 
													<cfif not isdefined("url.imprimir")>
                                                    <!---ERBG Modoficación SCNo 1823232 Inicia--->
                                                    	<cfif LvarCBesTCE eq 0>
															<input type="button" name="Conciliar" value="Aplicar Conciliación" onClick="javascript:return valida('<cfoutput>#suma1#</cfoutput>','<cfoutput>#suma2#</cfoutput>');">
                                                        <cfelse>
															<input type="button" name="Conciliar" value="Aplicar Conciliación" onClick="javascript:return valida('<cfoutput>#sumaBancos#</cfoutput>','<cfoutput>#sumaLibros#</cfoutput>');">
                                                        </cfif>
                                                    <!---ERBG Modoficación SCNo 1823232 Fin--->    	
													</cfif>
												</td>
												<td colspan="1" align="center" valign="top"> 
													
													<!---Boton de inconformidades--->
													<cfif IsDefined("LvarTCEresumenCon") and not isdefined("url.imprimir")>
														<!---Pagina de Disconformidades--->
 														<input type="button" name="Inconformidad" value="Inconformidades" onClick="javascript:funcInconforme();">
<!--- 														<input type="hidden" name="LvarECid" value="<cfif isDefined('Form.ECid') and Form.ECid NEQ ''><cfoutput>#Form.ECid#</cfoutput></cfif>">
--->													</cfif>
												</td>
											</tr>
										</table>
										
										<table width="100%" border="0" cellpadding="0" cellspacing="0">
											<tr>
												 Observaciones:
												  <td colspan="1" rowspan="6" valign="top" align="left">
													<textarea name="ObserConcialiacion" onkeypress="" cols="94" rows="4" MAXLENGTH=250><cfoutput>#rsEC.ECobservacion#</cfoutput>  
													</textarea>		    
												 </td>
												 <td colspan="1" align="left" valign="top"> 
													<cfif not isdefined("url.imprimir")>
														<input type="button" name="GuardarObs" value="Guardar Observación" onClick="GuardaObservacion();">
													</cfif>
												</td>
											</tr>
										</table>
										
										<cfset form.Tipo = 0>
										<!--- MODIFICACION 17 DE MAYO DEL 2005 OPCIONES DE IMPRESION ANA VILLAVICENCIO --->
										<cfif not isdefined("url.imprimir")>
											<table align="center" width="100%" border="0" cellpadding="1" cellspacing="0">
												<tr><td colspan="2">&nbsp;</td></tr>
												<tr class="tituloAlterno">
													<td width="50%"> <font size="2"><strong>Consulta de Documentos</strong></font> </td>
													<td width="50%"> <font size="2"><strong>Reporte de Partidas</strong></font> </td>
												</tr>
											</table>
											<table align="center" width="75%" border="0" cellpadding="1" cellspacing="0">
												<tr>
													<td width="61%">
														<input name="CM" type="radio" value="0"  <cfif isdefined('form.CM')>checked</cfif> id="CM"
												onclick="javascript: 	document.form1.CA.checked=false;
																		document.form1.TC.checked=false;
																		document.form1.PSC.checked=false;
																		document.form1.PC.checked=false;
                                                                        <cfif isdefined("LvarTCEresumenCon")>
																		document.form1.PCI.checked=false;
                                                                        </cfif>
																		document.form1.Tipo =0;"
												style=" border:0; background:background-color">
														<label for="CM"><span style="font-size:11px">Conciliaci&oacute;n Manual</span></label>
													</td>
													<td width="61%">
														<input name="PC" type="radio" value="1"  <cfif isdefined('form.PC')>checked</cfif> id="PC"
												onclick="javascript: 	document.form1.CM.checked=false;
                                                						document.form1.CA.checked=false;
																		document.form1.TC.checked=false;
																		document.form1.PSC.checked=false;
                                                                        <cfif isdefined("LvarTCEresumenCon")>
																		document.form1.PCI.checked=false;
                                                                        </cfif>
																		document.form1.Tipo=4;"
												style=" border:0; background:background-color">
														<label for="PC"><span style="font-size:11px">Partidas Conciliadas</span></label>
													</td>
												</tr>
												<tr>
													<td>
														<input name="CA" type="radio" value="1"  <cfif isdefined('form.CA')>checked</cfif> id="CA"
												onclick="javascript: 	document.form1.CM.checked=false;
																		document.form1.TC.checked=false;
																		document.form1.PSC.checked=false;
																		document.form1.PC.checked=false;
                                                                        <cfif isdefined("LvarTCEresumenCon")>
																		document.form1.PCI.checked=false;
                                                                        </cfif>
																		document.form1.Tipo=1;"
												style=" border:0; background:background-color">
														<label for="CA"><span style="font-size:11px">Conciliaci&oacute;n Autom&aacute;tica</span></label>
													</td>
													<td>
														<input name="PSC" type="radio" value="1"  <cfif isdefined('form.PSC')>checked</cfif> id="PSC"
												onclick="javascript: 	document.form1.CM.checked=false;
                                                						document.form1.CA.checked=false;
																		document.form1.TC.checked=false;
																		document.form1.PC.checked=false;
                                                                        <cfif isdefined("LvarTCEresumenCon")>
																		document.form1.PCI.checked=false;
                                                                        </cfif>
																		document.form1.Tipo=5;"
												style=" border:0; background:background-color">
														<label for="PSC"><span style="font-size:11px">Partidas sin Conciliar</span></label>
													</td>
												</tr>
												<tr>
													<td width="60%">
														<input name="TC" type="radio" value="1"  <cfif isdefined('form.TC')>checked</cfif> id="TC"
												onclick="javascript: 	document.form1.CM.checked=false;
																		document.form1.CA.checked=false;
																		document.form1.PSC.checked=false;
																		document.form1.PC.checked=false;
                                                                        <cfif isdefined("LvarTCEresumenCon")>
																		document.form1.PCI.checked=false;
                                                                        </cfif>
																		document.form1.Tipo=2;"
												style=" border:0; background:background-color">
														<label for="TC"><span style="font-size:11px">Todos los Documentos</span></label>
													</td>
													<!---REPORTE PARTIDAS CON INCONFORMIDAD--->														
													<cfif isdefined("LvarTCEresumenCon")>	
														<td width="61%">
															<input name="PCI" type="radio" value="1"  <cfif isdefined('form.PCI')>checked</cfif> id="PCI"
															onclick="javascript: 	document.form1.CM.checked=false;
																					document.form1.PC.checked=false;
																					document.form1.CA.checked=false;
																					document.form1.PSC.checked=false;
																					document.form1.TC.checked=false;
																					document.form1.Tipo=6;"
															style=" border:0; background:background-color">
															<label for="PCI"><span style="font-size:11px">Partidas con Inconformidad</span></label>
														</td>
														</cfif>
													<!------>
												</tr>
												<tr>
													<td>&nbsp;</td>
												</tr>
												<tr align="center">
													<td colspan="2">
														<input name="Imprimir" type="button" value="Generar" onclick="javascript:ImprimeReporte(document.form1.Tipo);">
													</td>
												</tr>
												<tr><td>&nbsp;</td></tr>
											</table>
										</cfif>
										<!--- FIN MODIFICACION 17 DE MAYO DEL 2005 --->
									</td>
								</tr>
								<iframe name="GuardaObs" id="GuardaObs" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
							</table>
						</form>
					<!--- <cf_web_portlet_end> --->
				</td>
				<td width="15%" valign="top">
					<cfif not isdefined("url.imprimir")>
						
						<!---Redireccion frame-Progreso.cfm o TCEframe-Progreso.cfm (TCE)--->
						<cfinclude template="#LvarIrAFrameProgre#">
						<br>
						<div class="textoAyuda"> <strong>Pasos para Realizar la Operación:</strong><br>
							<br>
							Para aplicar todos los documentos conciliados presione el bot&oacute;n de <font color="#003399"><strong>Aplicar Conciliación</strong></font>.<br>
							<br>
						</div>
					</cfif>
				</td>
			</tr>
		</table>
		<cf_web_portlet_end>
	<cf_templatefooter>
		<script language="JavaScript1.2">
			<!--//		
			function GuardaObservacion(){
				varObs=document.form1.ObserConcialiacion.value;
				varECid=document.form1.ECid.value;
				
				<!---Redirección ResConGuardaObs.cfm o TCEResConGuardaObs.cfm--->
				document.getElementById('GuardaObs').src = '<cfoutput>#LvarIrAResConGuard#</cfoutput>?Observacion='+varObs+'&ECid='+varECid+'';
			}
			
			function ImprimeReporte(Tipo){ 
				if (Tipo < 4){
				<cfoutput>
				<!---Redireccion RPresumenConciliacion.cfm o TCERPresumenConciliacion.cfm (TCE)--->
				var PARAM  = "../Reportes/<cfoutput>#LvarIrARPresumConci#</cfoutput>?ECid= <cfif isdefined('form.ECid')>#form.ECid#</cfif>&Tipo="+Tipo; 
				open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=no,width=800,height=400');
					return false;
				</cfoutput>
				}else
				{
				<!---Reporte partidas con Inconformidad--->
				<cfoutput>
				if (Tipo == 6){cons = 'N';
						var PARAM  = "../Reportes/RPPartidasConInconformidad.cfm?ECid= <cfif isdefined('form.ECid')>#form.ECid#</cfif>&CBid=#rsEC.CBid#&Bid=#rsEC.Bid#&cons="+cons;
						open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=no,width=800,height=400');
							return false;
				</cfoutput>
					}

				<cfoutput>
					var cons;
				if (Tipo == 4)cons = 'S'; else cons = 'N'
				<!---Redireccion RPPartidasSinConciliar.cfm o TCERPPartidasSinConciliar.cfm (TCE)--->
				var PARAM  = "../Reportes/<cfoutput>#LvarIrRPartidasSinCon#</cfoutput>?ECid= <cfif isdefined('form.ECid')>#form.ECid#</cfif>&CBid=#rsEC.CBid#&Bid=#rsEC.Bid#&cons="+cons; 
				open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=no,width=800,height=400');
					return false;
				</cfoutput>
				}
			}
			function valida(suma1,suma2) {
				<!---if (Math.floor(suma1*100) == Math.floor(suma2*100)){--->
				if (Math.round(suma1*100) == Math.round(suma2*100)){
					if (confirm("¿Desea aplicar la Conciliación?")) {
						document.form1.submit();
					}
					else
						return false;
				}else{
					alert("No son cantidades iguales. No es posible conciliar");
					return false;
				}
				
			}
			function funcInconforme() 
			{
				<!---Redireccion resumenConciliacion.cfm o resumenConciliacion.cfm (TCE)--->
				 var PARAM ="/cfmx/sif/tce/operaciones/TCEInconformidades.cfm?LvarECid=<cfoutput>#Form.ECid#</cfoutput>"
				 <!---var PARAM ="/cfmx/sif/tce/operaciones/TCEInconformidades.cfm?LvarECid=5000000000000315"--->
				 open(PARAM,'','left=10%,top=120%,scrollbars=yes,resizable=no,width=1300,height=640');
  			}
			//-->
		</script>
 