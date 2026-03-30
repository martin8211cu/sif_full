<!----
		Modificado por Hector Garcia Beita
		Motivo: validador para la redirección en caso de ser invocada desde la 
		opcion de conciliacion bancaria de el modulo de tarjetas de
		credito empresariales mediante un include
--->
<cfset LvarIrAFrameConfig="frame-config.cfm">
<cfset LvarIrAConciliacion="/cfmx/sif/mb/operacion/Conciliacion.cfm">
<cfset LvarIrAConciApply="Conciliacion-Apply.cfm">
<cfset LvarCBesTCE=0><!---Filtro para los querys TCE o CuentasBancarias--->
<cfif isdefined("LvarTCEOperaRPresumenConci")>
	<cfset LvarIrAFrameConfig="/sif/tce/operaciones/TCEframe-config.cfm">
	<cfset LvarIrAConciliacion="/cfmx/sif/tce/operaciones/TCEConciliacion.cfm">
	<cfset LvarIrAConciApply="TCEConciliacion-Apply.cfm">
	<cfset LvarCBesTCE=1><!---Filtro para los querys TCE o CuentasBancarias--->
</cfif>



<cfif isdefined('url.ECid') and isdefined('url.imprimir')>
	<cfset form.ECid = url.ECid>
</cfif>
<!---solo aplica para los detalles del reporte conciliacion resumida--->
<cfif isdefined('url.detalles')>
	<script language="javascript1.2">
		window.print();
	</script>	
</cfif>

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>	
<cfquery name="rsUsuario" datasource="#session.DSN#">
	select Usulogin, Pnombre, Papellido1, Papellido2
	from Usuario u
	inner join DatosPersonales dp
	   on dp.datos_personales = u.datos_personales
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  and Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usulogin#">
</cfquery>

<cfquery name="rsDatosEC" datasource="#session.DSN#">
	select ec.ECid,
		ec.ECdescripcion,
		b.Bdescripcion, 
		cb.CBdescripcion, 
		cb.CBcodigo,
		ec.Bid,
		coalesce(ec.ECdesde, <cf_dbfunction name="now">) as ECdesde,
		coalesce(ec.EChasta, <cf_dbfunction name="now">) as EChasta	
	from ECuentaBancaria ec
	inner join CuentasBancos cb
	   on cb.CBid = ec.CBid
	  and cb.Bid = ec.Bid
	  and cb.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	inner join Bancos b
	   on b.Bid = cb.Bid
	  and b.Ecodigo = cb.Ecodigo
	where ec.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
    	and cb.CBesTCE = #LvarCBesTCE#
</cfquery>


<cfset vparams ="">
<cfset vparams = vparams & "&ECid=" & form.ECid >

	<!---Redireccion frame-config.cfm o TCEframe-config.cfm(TCE)--->
	<cfinclude template="#LvarIrAFrameConfig#">
		<cfif not (isDefined("Form.ECid") and Len(Trim(Form.ECid)))>
		
		<!---redireccion Conciliacion.cfm o TCEConciliacion.cfm (TCE)--->
			<cflocation addtoken="no" url="#LvarIrAConciliacion#">
		</cfif>
		<cfquery name="rsTransacciones" datasource="#Session.DSN#">
			select b.BTid, b.BTcodigo,
				case b.BTtipo when 'D' then '+' when 'C' then '-' else '' end as SumaResta,
				b.BTdescripcion
			from BTransacciones b
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
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
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
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
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="50">
			  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="GN">
		</cfquery>
		<cfquery name="rsMes" datasource="#Session.DSN#">
			select Pvalor as Mes
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="60">
			  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="GN">
		</cfquery>
		<cfquery name="rsEC" datasource="#session.DSN#">
			select 
				CBid, 
				<cf_dbfunction name="date_part" args="mm,EChasta" > as mes, 
				<cf_dbfunction name="date_part" args="yyyy,EChasta" > as periodo,
                ECdesde,
				EChasta, 
				Bid, 
				ECsaldofin,
				ECobservacion
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
			where b.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEC.Bid#">
			order by b.Bid, b.BTEcodigo, b.BTEdescripcion, b.BTEtipo
		</cfquery>
		
		<cfquery name="rsSaldoLibros" datasource="#Session.DSN#">
			select 
				 <cfif LvarCBesTCE eq 0>             
                   <!--- BANCOS--->
                    round( (select coalesce(sum(sb.Sinicial),0.00)
						from SaldosBancarios sb
						where sb.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEC.CBid#"><!--- --- Cuenta Bancaria del Estado de Cuenta--->
						and Periodo = #rsEC.periodo#<!------ Año del Estado de Cuenta--->
						and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEC.mes#">       <!--- --- Mes del Estado de Cuenta--->
						)      						
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
		<cfif not isdefined("url.imprimir")>
			<cfinclude template="../../portlets/pNavegacion.cfm">
		</cfif>
		<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
			<tr>
				<td width="100%" valign="top">
						
						<!---redireccion Conciliacion-Apply.cfm o TCEConciliacion-Apply.cfm--->
						<form method="post" name="form1" action="<cfoutput>#LvarIrAConciApply#</cfoutput>">
							<input name="ECid" type="hidden" value="<cfif isDefined('Form.ECid') and Form.ECid NEQ ''><cfoutput>#Form.ECid#</cfoutput></cfif>">
							
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td colspan="3">
										<cfoutput>
											<table width="100%" border="0">
												<tr>
													<td><span style="font-size:14px"><strong>#rsEmpresa.Edescripcion#</strong></span></td>
													<td align="right"><font size="2">#LSDateFormat(Now(),'dd/mm/yyyy')#</font></td>
												</tr>
												<tr>
													<td colspan="2">
														<span style="font-size:14px"><strong>Resumen de Conciliaci&oacute;n Bancaria</strong></span>
													</td>
												</tr>
												<tr>
													<td colspan="2">
														<span style="font-size:14px"><strong>#rsDatosEC.Bdescripcion#</strong></span>
													</td>
												</tr>
												<tr>
													<td nowrap>
														<span style="font-size:12px">
															<strong>Cuenta:</strong>
															#rsDatosEC.CBdescripcion#  #rsDatosEC.CBcodigo#
														</span>
													</td>
												</tr>
												<tr> 
													<td nowrap>
														<span style="font-size:11px">#rsDatosEC.ECdescripcion#</span>
													</td>
												</tr>
											</table>
										</cfoutput>
									</td>
								</tr>
								<tr><td colspan="3">&nbsp;</td></tr>
								<tr>
									<td colspan="2" valign="top">
										<table width="100%" border="0" cellpadding="1" cellspacing="0">
											<tr>
												<td width="33%" nowrap bgcolor="#FFFFFF"> <font size="2" face="Arial, Helvetica, sans-serif">Saldo a la fecha:</font> <strong> <font color="#0099CC" size="2" face="Arial, Helvetica, sans-serif"> &nbsp;<cfoutput>#LSDateFormat(rsEC.EChasta,'dd-mm-yyyy')#</cfoutput> </font> </strong> </td>
											</tr>												
											<tr bgcolor="#ECECEC">
												<td nowrap> <font size="2"><strong>&nbsp;Saldo seg&uacute;n Bancos:</strong></font> </td>
												<td width="15%" align="right"> <font size="2"> <strong><cfoutput>#LSCurrencyFormat(SaldoLibros,"none")#</cfoutput></strong> </font> </td>
												<td width="3%">&nbsp;</td>
												<td width="25%" nowrap> <font size="2"><strong>&nbsp;Saldo seg&uacute;n Libros:</strong></font> </td>
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
									<td width="50%">
										<table width="100%" align="left" cellpadding="0" cellspacing="1">
											<tr bgcolor="#E2E2E2">
												<td><strong>&nbsp;Suma/Resta</strong></td>
												<td nowrap><strong>&nbsp;Docs.  NO conciliados</strong></td>
												<td><strong>&nbsp;Cantidad</strong></td>
												<td align="right"><strong>Monto</strong></td>
											</tr>
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
															<td><cfif Len(Trim(descripcion))>#descripcion#<cfelse>&nbsp;</cfif></td>
															<td align="center"><cfif Len(Trim(cant))>#cant#<cfelse>&nbsp;</cfif></td>
															<td align="right"><cfif Len(Trim(despliegue))>#LSNumberFormat(despliegue,',9.00')#<cfelse>&nbsp;</cfif></td>
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
												<cfset suma1 = SaldoLibros+DebitosBancos-CreditosBancos>
												<cfset suma2 = SaldoBancos+DebitosLibros-CreditosLibros>
												<cfset LvarDiferencia = suma2 - suma1>
												<td width="33%"> <font size="2"><strong>&nbsp;Sumas Iguales</strong>:</font> </td>
												<td width="16%" align="right"> <font size="2"><strong><cfoutput>#LSCurrencyFormat(suma1,'none')#</cfoutput></strong></font> </td>
												<td width="51%" align="right"> <font size="2"><strong><cfoutput>#LSCurrencyFormat(suma2,"none")#</cfoutput></strong></font> </td>
											</tr>
											<tr>
												<td colspan="3" align="right"> <font size="2"><strong>Diferencia entre bancos y Libros:&nbsp;&nbsp;<cfoutput>#LSCurrencyFormat(( LvarDiferencia) ,"none")#</cfoutput></strong></font> </td>
											</tr>
											<tr><td colspan="3">&nbsp;</td></tr>
										</table>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<table width="100%" border="0" cellpadding="0" cellspacing="0">
											<tr>
												 Observaciones:
												  <td colspan="1" rowspan="6" valign="top" align="left">
													<cfoutput>#rsEC.ECobservacion#</cfoutput>  
												 </td>
											</tr>
										</table>
									</td>	
								</tr>		
								<tr><td colspan="2"><font size="2"><strong>Preparado por:&nbsp;</strong><cfoutput>#rsUsuario.Pnombre# #rsUsuario.Papellido1# #rsUsuario.Papellido2# (#rsUsuario.Usulogin#)</font></cfoutput></td></tr>
								<tr><td colspan="2">&nbsp;</td></tr>
								<tr><td colspan="2">&nbsp;</td></tr>
								<tr><td colspan="2"><font size="2"><strong>Revisado por:&nbsp;___________________________</strong></td></tr>
							</table>
						</form>
				</td>
			</tr>
		</table>
