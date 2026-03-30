<cfsetting requesttimeout="600">
<!--- Asigna variables default --->
<cfif isdefined ("form.TIPOFORMATO") or len(trim(form.TIPOFORMATO))>
	<cfset TipoFormato = form.TIPOFORMATO>
<cfelse> 
	<cfset TipoFormato = 4>
</cfif>

<cfif isdefined("form.ID_REPORTE") and len(trim(form.ID_REPORTE))>
	<cfset Id_Reporte = form.ID_REPORTE>
<cfelse>
	<cfset Id_Reporte = 1>	
</cfif> 

<cfif isdefined("form.ASIECONTIDLIST") and len(trim(form.ASIECONTIDLIST))>
	<cfset AsieContidList = form.ASIECONTIDLIST>
<cfelse>
	<cfset AsieContidList = "">	
</cfif> 

<cfif isdefined("form.ID_INCSUCURSAL") and len(trim(form.ID_INCSUCURSAL))>
	<cfset incsucursal = 1>
<cfelse>
	<cfset incsucursal = 0>
</cfif>

<cfset TituloReporte = "Reporte de Saldos por Cuenta">
<cfswitch expression="#Id_Reporte#">
	<cfcase value="1"> 
		<cfset TituloReporte = "Reporte de Saldos por Cuenta">
	</cfcase>
	<cfcase value="2"> 
		<cfset TituloReporte = "Reporte de Saldos por Rango de Cuentas">
	</cfcase>
	<cfcase value="3"> 
		<cfset TituloReporte = "Reporte de Saldos por Lista de Cuentas">
	</cfcase>
</cfswitch>	


<!--- Se cambia el valor numerico del mes inicial y mes final a letras --->
<cfif isdefined("form.MesInicial") and len(trim(form.MesInicial))>
	
	<cfif form.MesInicial EQ 1>
		<cfset MesInicial = "Enero">
	</cfif>
	<cfif form.MesInicial EQ 2 >
		<cfset MesInicial = "Febrero">
	</cfif>
	<cfif form.MesInicial EQ 3 >
		<cfset MesInicial = "Marzo">
	</cfif>
	<cfif form.MesInicial EQ 4 >
		<cfset MesInicial = "Abril">
	</cfif>
	<cfif form.MesInicial EQ 5 >
		<cfset MesInicial = "Mayo">
	</cfif>
	<cfif form.MesInicial EQ 6 >
		<cfset MesInicial = "Junio">
	</cfif>
	<cfif form.MesInicial EQ 7 >
		<cfset MesInicial = "Julio">
	</cfif>
	<cfif form.MesInicial EQ 8 >
		<cfset MesInicial = "Agosto">
	</cfif>
	<cfif form.MesInicial EQ 9 >
		<cfset MesInicial = "Septiembre">
	</cfif>
	<cfif form.MesInicial EQ 10 >
		<cfset MesInicial = "Octubre">
	</cfif>
	<cfif form.MesInicial EQ 11 >
		<cfset MesInicial = "Noviembre">
	</cfif>
	<cfif form.MesInicial EQ 12 >
		<cfset MesInicial = "Diciembre">
	</cfif>
</cfif>

<cfif isdefined("form.MesFinal") and len(trim(form.MesFinal))>
	
	<cfif form.MesFinal EQ 1>
		<cfset MesFinal = "Enero">
	</cfif>
	<cfif form.MesFinal EQ 2>
		<cfset MesFinal = "Febrero">
	</cfif>
	<cfif form.MesFinal EQ 3>
		<cfset MesFinal = "Marzo">
	</cfif>
	<cfif form.MesFinal EQ 4>
		<cfset MesFinal = "Abril">
	</cfif>
	<cfif form.MesFinal EQ 5>
		<cfset MesFinal = "Mayo">
	</cfif>
	<cfif form.MesFinal EQ 6>
		<cfset MesFinal = "Junio">
	</cfif>
	<cfif form.MesFinal EQ 7>
		<cfset MesFinal = "Julio">
	</cfif>
	<cfif form.MesFinal EQ 8>
		<cfset MesFinal = "Agosto">
	</cfif>
	<cfif form.MesInicial EQ 9>
		<cfset MesFinal = "Septiembre">
	</cfif>
	<cfif form.MesFinal EQ 10>
		<cfset MesFinal = "Octubre">
	</cfif>
	<cfif form.MesInicial EQ 11>
		<cfset MesFinal = "Noviembre">
	</cfif>
	<cfif form.MesFinal EQ 12>
		<cfset MesFinal = "Diciembre">
	</cfif>
</cfif>

<cfset contador = 1>

<cfoutput> 
<script language="javascript1.2" type="text/javascript">
	function regresar() {
		if (#Id_Reporte# == 1) {
			document.location = "../reportes/cmn_SaldosCuentas.cfm";
		}
		if (#Id_Reporte# == 2) {
			document.location = "../reportes/cmn_SaldosRangoCuentas.cfm";
		}
		if (#Id_Reporte# == 3) {
			document.location = "../reportes/cmn_SaldosAsientoCuentas.cfm";
		}
	}

	function imprimir() {
		var imprimir = document.getElementById("imprimir");
		var Regresar = document.getElementById("Regresar");
		imprimir.style.visibility='hidden';
		Regresar.style.visibility='hidden';
		window.print()	
		imprimir.style.visibility='visible';
		Regresar.style.visibility='visible';
	
	}


</script>
</cfoutput>
<cfoutput>
<!--- aqui se define las variables de session necesarias para que funcione la exportacion a excel --->
<cfset session.Ecodigo 			= '1' >
<cfset session.Usucodigo 		= session.usuario >
<cfset session.Ulocalizacion 	= 'conta'>
<cfset session.sitio.css    	= '/plantillas/login02/sif_login02.css'>

<!---  <cf_sifHTML2Word Titulo="Consulta de Cuentas Contables">
 --->	<link href="STYLE.CSS" rel="stylesheet" type="text/css">
	<table width="100%" cellpadding="0" cellspacing="0" border="0" >
		<tr>
			<td align="right" nowrap>
				<input type="button"  id="Regresar" name="Regresar" value="Regresar" onClick="regresar();">
				<input type="button"  id="Imprimir" name="Imprimir" value="Imprimir" onClick="imprimir();">
			</td>
		</tr>
		<tr><td><hr></td></tr>
		<tr>
			<td>
				<table width="100%" cellpadding="0" cellspacing="2" border="0" >
					<tr>
						<td align="center" class="subtitulo_seccion_black">
							INSTITUTO COSTARRICENSE DE ELECTRICIDAD
							<br>
							#TituloReporte#
							<br>
							De #MesInicial# #form.AnoInicial# a #MesFinal# #form.AnoInicial#
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
						<cfif form.segmento neq 'T'>
							<cfquery name="rsDesSeg1" datasource="#session.Conta.dsn#">
									select a.CGE5DES as CGE5DES
									from CGE005 a, CGE000 b
									where a.CGE1COD = b.CGE1COD
									and a.CGE5COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Segmento#">
									union all
									select CGE5DES  as CGE5DES
									from anex_sucursal
									where cod_suc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Segmento#">
							</cfquery>
							
							<cfif rsDesSeg1.RecordCount GT 0>
								<cfset DesSegmento = #rsDesSeg1.CGE5DES#>
							<cfelse>
								<cfset DesSegmento = "***">
							</cfif>
							
						</cfif>					
							
						<td align="center" class="subtitulo_seccion_sinfondo">
							<cfif TipoFormato EQ 1>
								<strong>Reporte Detallado</strong><br><br>
							<cfelseif TipoFormato EQ 2>
								<strong>Reporte Detallado por Mes</strong><br><br>
							<cfelseif TipoFormato EQ 3>
								<strong>Reporte Detallado por Asiento</strong><br><br>
							<cfelse>
								<strong>Reporte Resumido</strong><br><br>
							</cfif>
							<strong>Segmento:&nbsp;<cfif form.segmento eq 'T'>Todos<cfelse>#form.segmento# - #DesSegmento#</cfif></strong>
						</td>
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
					<!---  <cfflush> --->
					<cfloop query="rsCuentasContables">
						<cfif len(strAsientos) GT 0>
							<cfquery name="rsDatos" datasource="#session.Conta.dsn#">
							select 	
									isnull((
											select sum(CTSSAN)
											from tbl_cuentas ct, CGM007 s (index CGM00700)
											where ct.rptid = #llave#
 											  and ct.CuentaMayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentasContables.CuentaMayor#">
								  			  and s.CGM1ID = ct.CuentaDetalle
								  			  and s.CTSPER = #anoini#
								  			  and s.CTSMES = #mesini#
											  and s.CG5CON in (#strAsientos#)
											<cfif sucursal NEQ "T">
												and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
											</cfif>
									), 0.00) as SaldoIncial,
									isnull((
											select sum(CTSDEB)
											from tbl_cuentas ct, CGM007 s (index CGM00700)
											where ct.rptid = #llave#
 											    and ct.CuentaMayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentasContables.CuentaMayor#">
								  				and s.CGM1ID = ct.CuentaDetalle
							  					and s.CTSPER = #anoini#
												and s.CTSMES >= #mesini#
												and s.CTSMES <= #mesfin#
												and s.CG5CON in (#strAsientos#)
												<cfif sucursal NEQ "T">
													and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
												</cfif>
									), 0.00) as Debitos,
									isnull((
											select sum(CTSCRE)
											from tbl_cuentas ct, CGM007 s (index CGM00700)
											where ct.rptid = #llave#
 											    and ct.CuentaMayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentasContables.CuentaMayor#">
												and s.CGM1ID = ct.CuentaDetalle
							  					and s.CTSPER = #anoini#
												and s.CTSMES >= #mesini#
												and s.CTSMES <= #mesfin#
												and s.CG5CON in (#strAsientos#)
												<cfif sucursal NEQ "T">
													and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
												</cfif>
									), 0.00) as Creditos
							</cfquery>
						<cfelse>
							<cfquery name="rsDatos" datasource="#session.Conta.dsn#">
							select 	
									isnull((
											select sum(CTSSAN)
											from tbl_cuentas ct, CGM004 s (index CGM00400)
											where ct.rptid = #llave#
 											and ct.CuentaMayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentasContables.CuentaMayor#">
								  			  and s.CGM1ID = ct.CuentaDetalle
								  			  and s.CTSPER = #anoini#
								  			  and s.CTSMES = #mesini#
											<cfif sucursal NEQ "T">
												and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
											</cfif>
									), 0.00) as SaldoIncial,
									isnull((
											select sum(CTSDEB)
											from tbl_cuentas ct, CGM004 s (index CGM00400)
											where ct.rptid = #llave#
 											    and ct.CuentaMayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentasContables.CuentaMayor#">
								  				and s.CGM1ID = ct.CuentaDetalle
							  					and s.CTSPER = #anoini#
												and s.CTSMES >= #mesini#
												and s.CTSMES <= #mesfin#
												<cfif sucursal NEQ "T">
													and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
												</cfif>
									), 0.00) as Debitos,
									isnull((
											select sum(CTSCRE)
											from tbl_cuentas ct, CGM004 s (index CGM00400)
											where ct.rptid = #llave#
 											    and ct.CuentaMayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentasContables.CuentaMayor#">
												and s.CGM1ID = ct.CuentaDetalle
							  					and s.CTSPER = #anoini#
												and s.CTSMES >= #mesini#
												and s.CTSMES <= #mesfin#
												<cfif sucursal NEQ "T">
													and s.CGE5COD in (#PreserveSingleQuotes(strSucursales)#)
												</cfif>
									), 0.00) as Creditos
							</cfquery>
						</cfif>

						<cfif rsDatos.SaldoIncial NEQ 0.00 or rsDatos.Debitos NEQ 0.00 or rsDatos.Creditos NEQ 0.00>					
						 <tr>
							<cfif #rsCuentasContables.Detalle# EQ 0>
								<td nowrap><strong>#rsCuentasContables.FormatoCuenta#</strong></td>
								<td nowrap><strong>#rsCuentasContables.Descripcion#</strong></td>
								<td nowrap align="right"><strong>#LSCurrencyFormat(rsDatos.SaldoIncial,'none')#</strong></td>
								<td nowrap align="right"><strong>#LSCurrencyFormat(rsDatos.Debitos,'none')#</strong></td>
								<td nowrap align="right"><strong>#LSCurrencyFormat(rsDatos.Creditos,'none')#</strong></td>
								<td nowrap align="right"><strong>#LSCurrencyFormat(rsDatos.SaldoIncial + rsDatos.Debitos - rsDatos.Creditos,'none')#</strong></td>
							<cfelse>
								<td nowrap>#rsCuentasContables.FormatoCuenta#</td>
								<td nowrap>#rsCuentasContables.Descripcion#</td>
								<td nowrap align="right">#LSCurrencyFormat(rsDatos.SaldoIncial,'none')#</td>
								<td nowrap align="right">#LSCurrencyFormat(rsDatos.Debitos,'none')#</td>
								<td nowrap align="right">#LSCurrencyFormat(rsDatos.Creditos,'none')#</td>
								<td nowrap align="right">#LSCurrencyFormat(rsDatos.SaldoIncial + rsDatos.Debitos - rsDatos.Creditos,'none')#</td>
							</cfif>
						</tr> 
						<cfif rsCuentasContables.Detalle EQ 1 and TipoFormato NEQ 4>
							 <cfquery name="rsDetalle" datasource="#session.Conta.dsn#">
			
								select <cfswitch expression="#TipoFormato#">
										<cfcase value="1">
											<cfif incsucursal EQ 1>
												t.CGE5COD as Segmento,
											</cfif>
											t.CGTPER as Ano, t.CGTMES as Mes, t.CG5CON as Asiento, t.CGTBAT as Consecutivo, 
											sum(case when t.CGTTIP = 'D' then t.CGTMON else 0.00 end) as Debitos,
											sum(case when t.CGTTIP = 'C' then t.CGTMON else 0.00 end) as Creditos
											from 	tbl_cuentas c, CGT002 t (index CGT00202)
										</cfcase>
										<cfcase value="2">
											<cfif incsucursal EQ 1>
												t.CGE5COD as Segmento,
											</cfif>
											t.CTSPER as Ano, t.CTSMES as Mes, 
											sum(CTSDEB) as Debitos, sum(CTSCRE) as Creditos
											from 	tbl_cuentas c, CGM007 t (index CGM00700)
										</cfcase>
										<cfcase value="3">
											<cfif incsucursal EQ 1>
												t.CGE5COD as Segmento,
											</cfif>
											t.CTSPER as Ano, t.CTSMES as Mes, t.CG5CON as Asiento, 
											sum(CTSDEB) as Debitos, sum(CTSCRE) as Creditos
											from 	tbl_cuentas c, CGM007 t (index CGM00700)
											</cfcase>
									</cfswitch>	
								where 	c.rptid = #llave#
								  and c.CuentaMayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCuentasContables.CuentaMayor#">
								  and t.CGM1ID = c.CuentaDetalle
								<cfif TipoFormato EQ "1">
								  and t.CGTPER = <cfqueryparam cfsqltype="cf_sql_integer" value="#anoini#">
								  and t.CGTMES >= <cfqueryparam cfsqltype="cf_sql_integer" value="#mesini#"> 
								  and t.CGTMES <= <cfqueryparam cfsqltype="cf_sql_integer" value="#mesfin#">
								  and t.CGTPER * 100 + t.CGTMES between <cfqueryparam cfsqltype="cf_sql_integer" value="#anoini#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#mesini#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#anofin# "> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#mesfin#">
								<cfelse>
								  and t.CTSPER = <cfqueryparam cfsqltype="cf_sql_integer" value="#anoini#">
								  and t.CTSMES >= <cfqueryparam cfsqltype="cf_sql_integer" value="#mesini#"> 
								  and t.CTSMES <= <cfqueryparam cfsqltype="cf_sql_integer" value="#mesfin#">
								  and t.CTSPER * 100 + t.CTSMES between <cfqueryparam cfsqltype="cf_sql_integer" value="#anoini#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#mesini#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#anofin# "> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#mesfin#">
								</cfif>  
								<cfif len(strAsientos) GT 0>
									and t.CG5CON in (#strAsientos#)
								</cfif>
								<cfif len(strSucursales) GT 0>
										and t.CGE5COD in (#preservesinglequotes(strSucursales)#)
								</cfif>	
								<cfswitch expression="#TipoFormato#">
										<cfcase value="1">
											group by 
											<cfif incsucursal EQ 1>
												t.CGE5COD,
											</cfif>
											t.CGTPER, t.CGTMES, t.CG5CON, t.CGTBAT
										</cfcase>
										<cfcase value="2">
											group by 
											<cfif incsucursal EQ 1>
												t.CGE5COD,
											</cfif>
											t.CTSPER, t.CTSMES
											having sum(CTSDEB) != 0.00 or sum(CTSCRE) != 0.00
										</cfcase>										
										<cfcase value="3">
											group by 
											<cfif incsucursal EQ 1>
												t.CGE5COD,
											</cfif>
											t.CTSPER, t.CTSMES, t.CG5CON
											having sum(CTSDEB) != 0.00 or sum(CTSCRE) != 0.00
										</cfcase>										
								</cfswitch>	
							</cfquery>	
							<cfif TipoFormato NEQ 4>
								<cfif rsDetalle.RecordCount GT 0>
									<tr>
										<td nowrap>&nbsp;</td>
										<td nowrap colspan="4">
											<table width="100%" cellpadding="0" cellspacing="0" border="0" >
												<tr>
													<cfswitch expression="#TipoFormato#">
														<cfcase value="1">
															<cfif incsucursal EQ 1>
																<td nowrap align="right" class="subtitulo_seccion_small"><strong>Seg</strong></td>
															</cfif>
															<td nowrap align="right" class="subtitulo_seccion_small"><strong>A&ntilde;o</strong></td>
															<td nowrap align="right" class="subtitulo_seccion_small"><strong>Mes</strong></td>
															<td nowrap align="right" class="subtitulo_seccion_small"><strong>Asiento</strong></td>
															<td nowrap align="right" class="subtitulo_seccion_small"><strong>Consecutivo</strong></td>
															<td nowrap align="right" class="subtitulo_seccion_small"><strong>D&eacute;bitos</strong></td>
															<td nowrap align="right" class="subtitulo_seccion_small"><strong>Cr&eacute;ditos</strong></td>
														</cfcase>
														<cfcase value="2">
															<cfif incsucursal EQ 1>
																<td nowrap align="right" class="subtitulo_seccion_small"><strong>Seg</strong></td>
															</cfif>
															<td nowrap align="right" class="subtitulo_seccion_small"><strong>A&ntilde;o</strong></td>
															<td nowrap align="right" class="subtitulo_seccion_small"><strong>Mes</strong></td>
															<td nowrap align="right" class="subtitulo_seccion_small"><strong>D&eacute;bitos</strong></td>
															<td nowrap align="right" class="subtitulo_seccion_small"><strong>Cr&eacute;ditos</strong></td>
														</cfcase>
														<cfcase value="3">
															<cfif incsucursal EQ 1>
																<td nowrap align="right" class="subtitulo_seccion_small"><strong>Seg</strong></td>
															</cfif>
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
																<cfif incsucursal EQ 1>
																	<td nowrap align="right">#rsDetalle.Segmento#</td>
																</cfif>
																<td nowrap align="right">#rsDetalle.Ano#</td>
																<td nowrap align="right">#rsDetalle.Mes#</td>
																<td nowrap align="right">#rsDetalle.Asiento#</td>														
																<td nowrap align="right">#rsDetalle.Consecutivo#</td>														
																<td nowrap align="right">#LSCurrencyFormat(rsDetalle.Debitos,'none')#</td>
																<td nowrap align="right">#LSCurrencyFormat(rsDetalle.Creditos,'none')#</td>
															</cfcase>
															<cfcase value="2">
																<cfif incsucursal EQ 1>
																	<td nowrap align="right">#rsDetalle.Segmento#</td>
																</cfif>
																<td nowrap align="right">#rsDetalle.Ano#</td>
																<td nowrap align="right">#rsDetalle.Mes#</td>
																<td nowrap align="right">#LSCurrencyFormat(rsDetalle.Debitos,'none')#</td>
																<td nowrap align="right">#LSCurrencyFormat(rsDetalle.Creditos,'none')#</td>
															</cfcase>
															<cfcase value="3">
																<cfif incsucursal EQ 1>
																	<td nowrap align="right">#rsDetalle.Segmento#</td>
																</cfif>
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
						<!--- <cfif contador mod 20>
							<cfflush>
							<cfset contador = contador + 1>
						</cfif> --->
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
	
					<cfset LarrAsientos = ListToarray(AsieContidList)>
					<cfset cantAsientos = ArrayLen(LarrAsientos)>
					<cfif Id_Reporte neq 3>
							<cfset LarrCuentas = ListToarray(CUENTASLIST)>
					<cfelse>
							<cfset LarrCuentas = ListToarray(CUENTAIDLIST)>
					</cfif>
					<cfset cantCuentas = ArrayLen(LarrCuentas)>
					<cfif cantAsientos gt cantCuentas>
						<cfset cantmax = cantAsientos>
					<cfelse>
						<cfset cantmax = cantCuentas>
					</cfif>
	
					<cfloop index="i" from="1" to="#cantmax#">
						<cfif i lte cantAsientos>
							<cfquery name="rsDesAsiento" datasource="#session.Conta.dsn#">
								select CG5DES
								from CGM005
								where CG5CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#LarrAsientos[i]#">
							</cfquery> 	
						</cfif>
					
						<tr>
							<td width="11%">&nbsp;</td>
							<cfif i lte cantCuentas>
								<td width="48%">#mid(LarrCuentas[i],1,3)# #mid(LarrCuentas[i],4,len(LarrCuentas[i]))#</td>
							<cfelse>
								<td width="48%">&nbsp;</td>
							</cfif>
							
							<cfif i lte cantAsientos>
								<td width="41%">
									<table width="100%" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td width="25%" nowrap align="right" >#LarrAsientos[i]#</td>
											<td width="3%" nowrap >&nbsp;-&nbsp;</td>
											<td width="72%" nowrap >#rsDesAsiento.CG5DES#</td>
										</tr>
									</table>
								</td>
							<cfelse>
								<td width="41%">&nbsp;</td>
							</cfif>
						</tr>
					</cfloop>	
				</table>
			</td>
		</tr>
		<tr><td><hr></td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
<!--- </cf_sifHTML2Word>
 ---></cfoutput>