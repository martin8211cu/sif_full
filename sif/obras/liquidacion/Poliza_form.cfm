<cf_templatecss>
<cfif isdefined("Url.cconcepto") and not isdefined("form.cconcepto")>
	<cfset form.Cconcepto = url.Cconcepto>
</cfif>
<cfif isdefined("Url.edocumento") and not isdefined("form.edocumento")>
	<cfset form.edocumento = url.edocumento>
</cfif>

<cfif isdefined("Url.idcontable") and not isdefined("form.idcontable")>
	<cfset form.idcontable = url.idcontable>
</cfif>

<cfquery name="rsPerMes" datasource="#Session.DSN#">
	select Eperiodo, Emes, Edescripcion 
	from HEContables
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
</cfquery>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsDatosPersonales" datasource="#Session.DSN#">
	select substring(rtrim(ltrim(g.Pnombre))#_Cat#' '#_Cat#rtrim(ltrim(g.Papellido1))#_Cat#' '#_Cat#rtrim(ltrim(g.Papellido2)), 1, 50) as Pnombre,
	e.ECfechaaplica,  e.ECusucodigoaplica 
	from HEContables e , Usuario f , DatosPersonales g
	where e.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDcontable#">
	and e.ECusucodigoaplica =  f.Usucodigo
	and f.datos_personales = g.datos_personales
</cfquery>

<cfif isdefined("rsDatosPersonales") and rsDatosPersonales.RecordCount NEQ 0>
	<cfset NombreAplica = rsDatosPersonales.Pnombre>
	<cfset FechaAplica = rsDatosPersonales.ECfechaaplica>
	<cfelse>
	<cfset NombreAplica =  ''>
	<cfset FechaAplica =  ''>
</cfif>

<cfparam name="Form.Ccuenta" default="">

<cfinclude template="Funciones.cfm">

<cfquery datasource="#Session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfsavecontent variable="myquery">
	<cfoutput>
		<cfif not isdefined("url.Export")>
			select 
			a.IDcontable, 
			a.Dlinea, 
			a.Ecodigo, 
			a.Eperiodo, 
			a.Emes as Emes, 
			a.Cconcepto as CconceptoQuery, 
			a.Edocumento, 
			a.Ocodigo,
			d.Oficodigo, 
			a.Ddescripcion , 
			a.Ddocumento, 
			a.Dreferencia, 
			case when Dmovimiento='D' then 'Debito' else 'Credito' end as DMovimiento, 
			Dmovimiento as tipoMov,
			a.Ccuenta,
			b.Cformato, 
			a.Doriginal, 
			a.Dlocal, 
			c.Mnombre, 
			a.Dtipocambio
			from HDContables a
				inner join CContables b
					on b.Ccuenta = a.Ccuenta
				inner join Monedas c
					on c.Mcodigo = a.Mcodigo
				inner join Oficinas d
					on d.Ecodigo = a.Ecodigo
					and d.Ocodigo = a.Ocodigo
			where IDcontable = #Form.IDcontable#
		<cfelse>
			select 
				a.Eperiodo as Periodo, 
				a.Emes as Mes, 
				a.Cconcepto as Concepto, 
				a.Edocumento as Documento_Encabezado, 
				d.Oficodigo as Oficina, 
				a.Ddescripcion as Descripcion, 
				a.Ddocumento as Documento, 
				a.Dreferencia as Referencia, 
				case when Dmovimiento='D' then 'Debito' else 'Credito' end as Movimiento, 
				Dmovimiento as Tipo_Mov,
				a.Ccuenta as Cuenta,
				b.Cformato as Cuenta_Formato, 
				a.Doriginal as Original, 
				a.Dlocal as Local, 
				c.Mnombre as Moneda, 
				a.Dtipocambio as Tipo_Cambio
			from HDContables a
					inner join CContables b
						on b.Ccuenta = a.Ccuenta
					inner join Monedas c
						on c.Mcodigo = a.Mcodigo
					inner join Oficinas d
						on d.Ecodigo = a.Ecodigo
						and d.Ocodigo = a.Ocodigo
			where IDcontable = #Form.IDcontable#
		</cfif>
	</cfoutput>
</cfsavecontent>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset PolizaContable = t.Translate('PolizaContable','P&oacute;liza Contable')>
<cfset ConsPolCont = t.Translate('VerificaPolizaLiq','Verificaci&oacute;n de la P&oacute;liza de Liquidaci&oacute;n Externa')>

<cfsavecontent variable="encabezado1">
	<cfoutput>
		<tr>
			<td colspan="13" align="center" class="tituloAlterno">#rsEmpresa.Edescripcion#</td>
		</tr>
		<tr>
			<td colspan="13">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="13" class="subTitulo" align="center"><strong>#ConsPolCont#</strong></td>
		</tr>
		<tr>
			<td colspan="13" align="center">&nbsp; </td>
		</tr>
	</cfoutput>
</cfsavecontent>	
<cfset meses="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">
 
<cfquery name="rsDocumento" datasource="#session.DSN#">
	select count(1) as cantidad
	from HDContables
	where IDcontable = #Form.IDcontable#
</cfquery>


<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 10px;
		padding-bottom: 10px;
	}
</style>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr> 
		<td valign="top"> 
			<cfif isdefined("Url.IDcontable") and not isdefined("Form.IDcontable")>
				<cfparam name="Form.IDcontable" default="#Url.IDcontable#">
			</cfif>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<cfset LvarAction = "">
						<cfif isdefined("url.Saldoymov") and len(trim(url.Saldoymov))>
							<cfset LvarAction = "saldosymov02.cfm">
						<cfelse>
							<cfset LvarAction = "Poliza_form2.cfm">
						</cfif>
						<form action="<cfoutput>#LvarAction#</cfoutput>" name="formsql" method="get">
							<cfif isdefined("url.Saldoymov") and len(trim(url.Saldoymov))>
								<cfoutput>
									<input type="hidden" name="Periodo" value="<cfif isdefined("url.Periodo")>#url.Periodo#</cfif>">
									<input type="hidden" name="Oficina" value="<cfif isdefined("url.Periodo")>#Form.Oficina#</cfif>">
									<input type="hidden" name="Mes" value="<cfif isdefined("url.Periodo")>#Form.Mes#</cfif>">
									<input type="hidden" name="Ccuenta" value="<cfif isdefined("url.Periodo")>#Form.Ccuenta#</cfif>">
								</cfoutput>
							</cfif>
						</form>
					</td>
				</tr>
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
						
							<cfif rsDocumento.cantidad EQ 0>
								<cfoutput>#encabezado1#</cfoutput>
							</cfif>		
						
							<cftry>
								<cfset Lvarcontador = 0>
								<cfflush interval="512">
								<cf_jdbcquery_open name="rsProc" datasource="#session.DSN#">
									<cfoutput>#myquery#</cfoutput>
								</cf_jdbcquery_open>
								<cfoutput query="rsProc"> 
									<cfif currentRow mod 40 EQ 1>
										<cfif currentRow NEQ 1>
											<tr class="pageEnd"><td colspan="13">&nbsp;</td></tr>
										</cfif>
										#encabezado1#
										<tr>
											<td colspan="13"  nowrap>
												<table width="100%" border="0" cellspacing="0" cellpadding="0">
													<tr>
														<td width="15%"><font size="2">#PolizaContable#:</font></td>
														<td width="85%"><font size="2"><strong>#CconceptoQuery# - #Edocumento#</strong></font></td>
													</tr>
													<tr>
														<td>&nbsp;</td>
														<td><font size="2"><strong>#ListGetAt(meses, rsPermes.Emes, ',')#&nbsp;#rsPerMes.Eperiodo#</strong></font></td>
													</tr>
													<tr>
														<td><font size="2">Usuario que aplic&oacute;:</font></td>
														<td><font size="2"><strong><cfif len(NombreAplica)>#NombreAplica#<cfelse>Sin definir</cfif></strong></font></td>
													</tr>
													<tr>
														<td><font size="2">Fecha Aplica:</font></td>
														<td><font size="2"><strong><cfif len(FechaAplica)>#FechaAplica#<cfelse>Sin definir</cfif></strong></font></td>
													</tr>	
													<tr>
														<td><font size="2">Descripción:</font></td>
														<td><font size="2"><strong>#rsPerMes.Edescripcion#</strong></font></td>
													</tr>																			
												</table>
											</td>
										</tr>	
										<tr>			
											<td colspan="13"  nowrap  style="padding-right: 20px">&nbsp;</td>
										</tr>		
										<tr>
											<td align="left" width="94" bgcolor="##C8D7E3"><font size="2">L&iacute;nea</font></td>
											<td width="23" bgcolor="##C8D7E3">&nbsp;</td>
											<td width="280" bgcolor="##C8D7E3"><font size="2">Cuenta</font></td>
											<td width="127" bgcolor="##C8D7E3"><font size="2">Oficina</font></td>
											<td width="13" bgcolor="##C8D7E3">&nbsp;</td>
											<td width="614" align="left" bgcolor="##C8D7E3"><font size="2">Descripci&oacute;n</font></td>
											<td nowrap align="right" bgcolor="##C8D7E3"><font size="2">D&eacute;bitos</font></td>
											<td width="1%" align="left" bgcolor="##C8D7E3">&nbsp;</td>
											<td nowrap align="right" bgcolor="##C8D7E3"><font size="2">Cr&eacute;ditos</font></td>
											<td width="1" bgcolor="##C8D7E3">&nbsp;</td>
											<td width="111" align="right" bgcolor="##C8D7E3"><font size="2">Moneda</font></td>
											<td width="1" bgcolor="##C8D7E3">&nbsp;</td>
											<td width="105" align="right" nowrap bgcolor="##C8D7E3"><font size="2">Monto Origen</font></td>
										</tr>
									</cfif>				
									<tr <cfif Form.CCuenta EQ Ccuenta>style="font-weight:bold"</cfif>>
										<td >
											#Dlinea#
										</td>
										<td>&nbsp;</td>
										<td nowrap>
											#Cformato#
										</td>
										<td>#Oficodigo#</td>
										<td nowrap>&nbsp;</td>
										<td nowrap>
											<cfif len(Ddescripcion) GT 35>
												#Mid(Ddescripcion,1,35)#...
											<cfelse>
												#Ddescripcion#
											</cfif>
										</td>
										<td align="right" nowrap>
											<cfif Dmovimiento EQ "Debito">
												#LSCurrencyFormat(DLocal,'none')#
											<cfelse>
												#LSCurrencyFormat(0,'none')#
											</cfif>
										</td>
										<td>&nbsp;</td>
										<td nowrap align="right">
											<cfif #Dmovimiento# EQ "Credito">
												#LSCurrencyFormat(Dlocal,'none')#
											<cfelse>
												#LSCurrencyFormat(0,'none')#
											</cfif>
										</td>
										<td>&nbsp;</td>
										<td  align="right" nowrap>
											#Mnombre# 
										</td>
										<td>&nbsp;</td>
										<td align="right">
											#LSCUrrencyFormat(Doriginal,'none')#
										</td>
									</tr>
									</cfoutput>
								<cfcatch type="any">
									<cf_jdbcquery_close>
									<cfrethrow>
								</cfcatch>
							</cftry>
							<cf_jdbcquery_close>
							<tr>
								<td colspan="6">&nbsp;</td>
								<td align="right" nowrap>--------------------</td>
								<td>&nbsp;</td>
								<td align="right" nowrap>--------------------</td>
								<td colspan="4">&nbsp;</td>
							</tr>
							<tr>
								<cfquery name="rsTotDebCre" datasource="#session.DSN#">
									select 
										sum(case when Dmovimiento = 'D' then Dlocal else 0.00 end) as Debitos,
										sum(case when Dmovimiento = 'C' then Dlocal else 0.00 end) as Creditos
									from HDContables 
									where IDcontable = #form.IDcontable# 
								</cfquery>
								
								<td colspan="5">&nbsp;</td>
								<td align="right"><strong>Total:</strong></td>
								<td nowrap align="right">
									<strong><cfoutput>#LSCurrencyFormat(rsTotDebCre.Debitos,'none')#</cfoutput></strong>
								</td>
								<td>&nbsp;</td>
								<td align="right" nowrap>
									<strong><cfoutput>#LSCurrencyFormat(rsTotDebCre.Creditos,'none')#</cfoutput></strong>
								</td>
								<td colspan="4">&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr> 
			</table>
		</td>	
	</tr>
</table>	
<form>
	<table width="100%" align="center">	
		<tr>
			<td align="center">
			<cfoutput>
				<input type="button" value="Liquidar" onclick='location.href="OBobraLiquidacion_sql.cfm?OP=LL&OBOid=#Arguments.OBOid#&IDcontable=#Form.IDcontable#";' />
				<input type="button" value="Regresar" onclick='location.href="OBobraLiquidacion_sql.cfm?OP=L&OBOid=#Arguments.OBOid#";' />
			</cfoutput>
			</td>
		</tr>
	</table>
</form>


