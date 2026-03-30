<!--- Se cambia el valor numerico del mes inicial a letras --->
<cfif isdefined("form.MesInicial") and len(trim(form.MesInicial))>
	<cfset mesIni = "">
	<cfif #form.MesInicial# EQ 1>
		<cfset mesIni = "Enero">
	<cfelseif #form.MesInicial# EQ 2>
		<cfset mesIni = "Febrero">
	<cfelseif #form.MesInicial# EQ 3>
		<cfset mesIni = "Marzo">
	<cfelseif #form.MesInicial# EQ 4>
		<cfset mesIni = "Abril">
	<cfelseif #form.MesInicial# EQ 5>
		<cfset mesIni = "Mayo">
	<cfelseif #form.MesInicial# EQ 6>
		<cfset mesIni = "Junio">
	<cfelseif #form.MesInicial# EQ 7>
		<cfset mesIni = "Julio">
	<cfelseif #form.MesInicial# EQ 8>
		<cfset mesIni = "Agosto">
	<cfelseif #form.MesInicial# EQ 9>
		<cfset mesIni = "Septiembre">
	<cfelseif #form.MesInicial# EQ 10>
		<cfset mesIni = "Octubre">
	<cfelseif #form.MesInicial# EQ 11>
		<cfset mesIni = "Noviembre">
	<cfelseif #form.MesInicial# EQ 12>
		<cfset mesIni = "Diciembre">
	<cfelse>
		<cfset mesIni = "">
	</cfif>
</cfif> 

<!--- Se cambia el valor numerico del mes final a letras --->
<cfif isdefined("form.MesFinal") and len(trim(form.MesFinal))>
	<cfset mesFin = "">
	<cfif #form.MesInicial# EQ 1>
		<cfset mesFin = "Enero">
	<cfelseif #form.MesInicial# EQ 2>
		<cfset mesFin = "Febrero">
	<cfelseif #form.MesInicial# EQ 3>
		<cfset mesFin = "Marzo">
	<cfelseif #form.MesInicial# EQ 4>
		<cfset mesFin = "Abril">
	<cfelseif #form.MesInicial# EQ 5>
		<cfset mesFin = "Mayo">
	<cfelseif #form.MesInicial# EQ 6>
		<cfset mesFin = "Junio">
	<cfelseif #form.MesInicial# EQ 7>
		<cfset mesFin = "Julio">
	<cfelseif #form.MesInicial# EQ 8>
		<cfset mesFin = "Agosto">
	<cfelseif #form.MesInicial# EQ 9>
		<cfset mesFin = "Septiembre">
	<cfelseif #form.MesInicial# EQ 10>
		<cfset mesFin = "Octubre">
	<cfelseif #form.MesInicial# EQ 11>
		<cfset mesFin = "Noviembre">
	<cfelseif #form.MesInicial# EQ 12>
		<cfset mesFin = "Diciembre">
	<cfelse>
		<cfset mesFin = "">
	</cfif>
</cfif> 


<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0" border="0" >
	<tr><td><hr></td></tr>
	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="2" border="0" >
				<tr>
	  				<td align="center" class="subtitulo_seccion_black">
						INSTITUTO COSTARRICENSE DE ELECTRICIDAD
						<br>
						Reporte de Saldos por Cuenta
						<br>
						De  a 
						<br>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr><td><hr></td></tr>
	
	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" >
				<tr>
					<cfset TipoFormato = 3>
					<cfif TipoFormato EQ 1>
						<td align="center" class="subtitulo_seccion_sinfondo">
							<strong>Reporte Detallado</strong><br><br>
							<strong>Segmento:&nbsp;XX-XXXXXXXXXXXXXXX</strong>
						</td>
					<cfelseif TipoFormato EQ 2>
						<td align="center" class="subtitulo_seccion_sinfondo">
							<strong>Reporte Detallado por Mes</strong><br><br>
							<strong>Segmento:&nbsp;XX-XXXXXXXXXXXXXXX</strong>
						</td>
					<cfelseif TipoFormato EQ 3>
						<td align="center" class="subtitulo_seccion_sinfondo">
							<strong>Reporte Detallado por Asiento</strong><br><br>
							<strong>Segmento:&nbsp;XX-XXXXXXXXXXXXXXX</strong>
						</td>
					<cfelse>
						<td align="center" class="subtitulo_seccion_sinfondo">
							<strong>Reporte Resumido</strong><br><br>
							<strong>Segmento:&nbsp;XX-XXXXXXXXXXXXXXX</strong>
						</td>
					</cfif>
				</tr>
			</table>
		</td>
	</tr>

	<tr><td><hr></td></tr>

	<tr>
		<td nowrap>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" >
				<tr>
					<td nowrap class="subtitulo_seccion_black"><strong>Cuenta</strong></td>
					<td nowrap class="subtitulo_seccion_black"><strong>Descripci&oacute;n</strong></td>
					<td nowrap align="right" class="subtitulo_seccion_black"><strong>Inicial</strong></td>
					<td nowrap align="right" class="subtitulo_seccion_black"><strong>D&eacute;bitos</strong></td>
					<td nowrap align="right" class="subtitulo_seccion_black"><strong>Cr&eacute;ditos</strong></td>
					<td nowrap align="right" class="subtitulo_seccion_black"><strong>Final</strong></td>
				</tr>
				
				<cfloop query="rsCuentasContables">
					<tr>
						<td nowrap>#rsCuentasContables.Cuenta#</td>
						<td nowrap>#rsCuentasContables.Descripcion#</td>
						<td nowrap align="right">#LSCurrencyFormat(rsCuentasContables.SaldoInicial,'none')#</td>
						<td nowrap align="right">#LSCurrencyFormat(rsCuentasContables.Debitos,'none')#</td>
						<td nowrap align="right">#LSCurrencyFormat(rsCuentasContables.Creditos,'none')#</td>
						<td nowrap align="right">#LSCurrencyFormat(rsCuentasContables.Total,'none')#</td>
					</tr>
					
					<cfif #rsCuentasContables.detalle# EQ 1>
						<cfquery name="rsDetalle" datasource="desarrollo">
							select <cfswitch expression="#TipoFormato#">
									<cfcase value="1">t.CGTPER as Ano, t.CGTMES as Mes, t.CG5CON as Asiento, t.CGTBAT as Consecutivo, </cfcase>
									<cfcase value="2">t.CGTPER as Ano, t.CGTMES as Mes, </cfcase>
									<cfcase value="3">t.CGTPER as Ano, t.CGTMES as Mes, t.CG5CON as Asiento, </cfcase>
								</cfswitch>	
								sum(case when t.CGTTIP = 'D' then t.CGTMON else 0.00 end) as Debitos,
								sum(case when t.CGTTIP = 'C' then t.CGTMON else 0.00 end) as Creditos
							from 	#tbl_cuentas# c, #tbl_periodos# p, #tbl_asientos# a, #tbl_sucursales# o, CGT002 t
							where 	c.cgm1idniv = <cfqueryparam cfsqltype="cf_sql_integer" value="#idCta#">
								and t.CGM1ID = c.cgm1id
								and t.CGTPER = p.periodo
								and t.CGTMES = p.mes
								and t.CGE5COD = o.cge5cod
								and t.CG5CON = a.cg5con
							 <cfswitch expression="#TipoFormato#">
								<cfcase value="1">group by t.CGTPER, t.CGTMES, t.CG5CON, t.CGTBAT</cfcase>
								<cfcase value="2">group by t.CGTPER, t.CGTMES</cfcase>										
								<cfcase value="3">group by t.CGTPER, t.CGTMES, t.CG5CON</cfcase>										
							</cfswitch>	
						</cfquery>			
						
						<cfif TipoFormato NEQ 4>
							<cfif rsDetalle.RecordCount GT 0>
								<tr>
									<td nowrap><strong>&nbsp;</strong></td>
									<td nowrap colspan="4">
										<table width="100%" cellpadding="0" cellspacing="0" border="0" >
											<tr>
												<cfswitch expression="#TipoFormato#">
													<cfcase value="1">
														<td nowrap align="right" class="subtitulo_seccion_small"><strong>A&ntilde;o</strong></td>
														<td nowrap align="right" class="subtitulo_seccion_small"><strong>Mes</strong></td>
														<td nowrap align="right" class="subtitulo_seccion_small"><strong>Asiento</strong></td>
														<td nowrap align="right" class="subtitulo_seccion_small"><strong>Consecutivo</strong></td>
														<td nowrap align="right" class="subtitulo_seccion_small"><strong>D&eacute;bitos</strong></td>
														<td nowrap align="right" class="subtitulo_seccion_small"><strong>Cr&eacute;ditos</strong></td>
													</cfcase>
													<cfcase value="2">
														<td nowrap align="right" class="subtitulo_seccion_small"><strong>A&ntilde;o</strong></td>
														<td nowrap align="right" class="subtitulo_seccion_small"><strong>Mes</strong></td>
														<td nowrap align="right" class="subtitulo_seccion_small"><strong>D&eacute;bitos</strong></td>
														<td nowrap align="right" class="subtitulo_seccion_small"><strong>Cr&eacute;ditos</strong></td>
													</cfcase>
													<cfcase value="3">
														<td nowrap align="right" class="subtitulo_seccion_small"><strong>A&ntilde;o</strong></td>
														<td nowrap align="right" class="subtitulo_seccion_small"><strong>Mes</strong></td>
														<td nowrap align="right" class="subtitulo_seccion_small"><strong>Asiento</strong></td>
														<td nowrap align="right" class="subtitulo_seccion_small"><strong>D&eacute;bitos</strong></td>
														<td nowrap align="right" class="subtitulo_seccion_small"><strong>Cr&eacute;ditos</strong></td>
													</cfcase>
												</cfswitch>	
											</tr>
		
											<cfloop query="rsDetalle">
												<tr>
													<cfswitch expression="#TipoFormato#">
														<cfcase value="1">
															<td nowrap align="right">#rsDetalle.Ano#</td>
															<td nowrap align="right">#rsDetalle.Mes#</td>
															<td nowrap align="right">#rsDetalle.Asiento#</td>														
															<td nowrap align="right">#rsDetalle.Consecutivo#</td>														
															<td nowrap align="right">#LSCurrencyFormat(rsDetalle.Debitos,'none')#</td>
															<td nowrap align="right">#LSCurrencyFormat(rsDetalle.Creditos,'none')#</td>
														</cfcase>
														<cfcase value="2">
															<td nowrap align="right">#rsDetalle.Ano#</td>
															<td nowrap align="right">#rsDetalle.Mes#</td>
															<td nowrap align="right">#LSCurrencyFormat(rsDetalle.Debitos,'none')#</td>
															<td nowrap align="right">#LSCurrencyFormat(rsDetalle.Creditos,'none')#</td>
														</cfcase>
														<cfcase value="3">
															<td nowrap align="right">#rsDetalle.Ano#</td>
															<td nowrap align="right">#rsDetalle.Mes#</td>
															<td nowrap align="right">#rsDetalle.Asiento#</td>														
															<td nowrap align="right">#LSCurrencyFormat(rsDetalle.Debitos,'none')#</td>
															<td nowrap align="right">#LSCurrencyFormat(rsDetalle.Creditos,'none')#</td>
														</cfcase>
													</cfswitch>	
												</tr>
											</cfloop>
										</table>
									</td>
									<td nowrap><strong>&nbsp;</strong></td>
								</tr>
							</cfif>
						</cfif>
					</cfif>
				</cfloop>
			</table>
		</td>
	</tr>

	<tr><td><hr></td></tr>

	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" >
				<tr>
					<td width="11%" class="subtitulo_seccion_black"><strong>Par&aacute;metros:</strong></td>
					<td width="48%" class="subtitulo_seccion_black"><strong>Cuentas:</strong></td>
					<td width="41%" class="subtitulo_seccion_black"><strong>Asientos Fijos:</strong></td>
				</tr>
				
				<cfif 1 EQ 1>
					<tr>
						<td width="11%">&nbsp;</td>
						<td width="48%">930-01-751-**-024</td>
						<td width="41%">701 FONDOS DE TRABAJO - EFECTIVO</td>
					</tr>
				</cfif>
			</table>
		</td>
	</tr>

	<tr><td><hr></td></tr>
	
	<tr><td>&nbsp;</td></tr>

</table>
</cfoutput>