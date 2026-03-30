<!--- OPARRALES 2019-01-23
	- Reporte para mostrar conceptos aplicables en Liquidacion/Finiquitos
	- Filtrados por Empleado y/o Fecha de cesantia.
 --->
<cf_htmlreportsheaders
			title="Reporte de Finiquitos/Liquidaciones"
			filename="RptFiniquitosLiquidaciones#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls"
			ira="RptFiniquito.cfm"
			method="url">
<cfquery name="rsInfoEnc" datasource="#session.dsn#">
	select
		concat(LTRIM(RTRIM(de.DEidentificacion)),' - ',LTRIM(RTRIM(de.DEnombre)),' ',LTRIM(RTRIM(de.DEapellido1)),' ',LTRIM(RTRIM(de.DEapellido2))) AS NombreEmpleado,
		dle.DLfvigencia,
		concat(LTRIM(RTRIM(pu.RHPcodigo)),' - ',LTRIM(RTRIM(pu.RHPdescpuesto))) as RHPdescpuesto,
		concat(LTRIM(RTRIM(cf.CFcodigo)),' - ',LTRIM(RTRIM(cf.CFdescripcion))) as CFcodigo,
		cf.CFid,
		de.DEid,
		de.RFC,
		de.DESeguroSocial,
		dle.Tcodigo
	from RHLiqFL lf
	inner join DatosEmpleado de
		on de.DEid = lf.DEid
		and lf.Ecodigo = de.Ecodigo
	inner join DLaboralesEmpleado dle
		on dle.DEid = lf.DEid
		and lf.Ecodigo = dle.Ecodigo
		and lf.DLlinea = dle.DLlinea
	inner join RHPlazas pl
		on dle.RHPid = pl.RHPid
		and dle.Ecodigo = pl.Ecodigo
	inner join RHPuestos pu
		on pu.RHPcodigo = dle.RHPcodigo
		and pu.Ecodigo = dle.Ecodigo
	inner join CFuncional cf
		on cf.CFid = pl.CFid
		and cf.Ecodigo = pl.Ecodigo
	where 1 = 1
	<cfif IsDefined('form.FIni') and Trim(form.FIni) neq ''>
		<cfset arrFec = ListToArray(form.FIni,'/')>
		<cfset varFec = CreateDate(arrFec[3],arrFec[2],arrFec[1])>
		and dle.DLfvigencia >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(varFec,'YYYY-MM-dd')#">
	</cfif>

	<cfif IsDefined('form.FFin') and Trim(form.FFin) neq ''>
		<cfset arrFec = ListToArray(form.FFin,'/')>
		<cfset varFec = CreateDate(arrFec[3],arrFec[2],arrFec[1])>
		and dle.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(varFec,'YYYY-MM-dd')#">
	</cfif>
	<cfif IsDefined('form.DEid') and Trim(form.DEid) neq ''>
		and lf.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfif>
	order by dle.DLfvigencia desc
</cfquery>

<cfquery name="rsEmp" datasource="#session.dsn#">
	select
		Edescripcion
	from
		Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cfset separadoTablasEnc = "padding-right: 5px; padding-left: 25px;">
<cfset separadoContenido = "padding-right: 5px; padding-left: 5px;">
<cfset encabezado = "font-size: 85%; font-weight:bold; padding-left:5px; padding-right:5px;">
<cfset contenidoEnc  = "font-size: 85%; padding-left:5px; padding-right:5px;">
<cfset contenido  = "font-size: 75%; padding-left:5px; padding-right:5px;">
<cfset resaltar   = "font-size:120%; font-weight:bold; padding-left:5px; padding-right:5px;">
<cfset miniBold   = "font-size:100%; font-weight:bold; padding-left:5px; padding-right:5px;">

<style>
	@media all {
	   div.saltopagina{
	      display: none;
	   }
	}
	@media print{
	   div.saltopagina{
	      display:block;
	      page-break-before:always;
	   }
	}
</style>
<cfset countPage=1>
<cfoutput>
	<cfloop query="rsInfoEnc">
		<table width="100%" align="center">
			<tr>
				<td colspan="4">
					<table width="100%" align="center">
						<tr>
							<td style="#resaltar#" align="center">
								#rsEmp.Edescripcion#
							</td>
						</tr>
						<tr>
							<td style="#minibold#" align="center">
								Recibo de Finiquito - Liquidacion
							</td>
						</tr>
						<cfquery name="rsCP" datasource="#session.dsn#">
							select
								SUBSTRING(ltrim(rtrim(convert(char,CPdesde,120))),1,10) as CPdesde,
								SUBSTRING(ltrim(rtrim(convert(char,CPhasta,120))),1,10) as CPhasta
							from
							CalendarioPagos
							where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DLfvigencia#"> between CPdesde and CPhasta
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Tcodigo#">
						</cfquery>
						<tr>
							<td style="#minibold#" align="center">
								<label style="#encabezado#">
									Calendario de Pago:
								</label>
								<label style="#contenidoEnc#">
									Desde: #rsCP.CPdesde# Hasta: #rsCP.CPhasta#
								</label>
							</td>
						</tr>
						<cfif (IsDefined('form.FFECHA') and Trim(form.FFecha) neq '') or (IsDefined('form.DEid') and Trim(form.DEid) neq '')>
							<tr>
								<td align="center" style="#minibold#">
									Filtrado Por
								</td>
							</tr>
							<cfif (IsDefined('form.FFECHA') and Trim(form.FFecha) neq '') and (IsDefined('form.DEid') and Trim(form.DEid) neq '')>
								<tr>
									<td align="center">
										<label style="#encabezado#">Empleado:</label>&nbsp;<label style="#contenidoEnc#">#rsInfoEnc.NombreEmpleado#</label>&nbsp;
										<label style="#encabezado#">Fecha:</label>&nbsp;<label style="#contenidoEnc#">#LSDateFormat(varFec,'dd-MM-YYYY')#</label>
									</td>
								</tr>
							<cfelseif IsDefined('form.FFECHA') and Trim(form.FFecha) neq ''>
								<tr>
									<td align="center">
										<label style="#encabezado#">Fecha:</label>&nbsp;<label style="#contenidoEnc#">#LSDateFormat(varFec,'dd-MM-YYYY')#</label>
									</td>
								</tr>
							<cfelse>
								<tr>
									<td align="center">
										<label style="#encabezado#">Empleado:</label>&nbsp;<label style="#contenidoEnc#">#rsInfoEnc.NombreEmpleado#</label>
									</td>
								</tr>
							</cfif>
						</cfif>
					</table>
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td colspan="4">
					<table width="100%" align="center" style="border-collapse: collapse; border: 1px solid black;">
						<tr>
							<td width="30%" style="#encabezado#" bgcolor="##CCCCCC">Fecha baja</td>
							<td width="40%" style="#encabezado#" bgcolor="##CCCCCC">Nombre Empleado</td>
							<td width="30%" style="#encabezado#" bgcolor="##CCCCCC">No. Afiliacion IMSS</td>
						</tr>
						<tr>
							<td width="30%" style="#contenidoEnc#">#Ucase(LSDateFormat(DLfvigencia,'dd-MMMM-YYYY','es_MX'))#</td>
							<td width="40%" style="#contenidoEnc#">#NombreEmpleado#</td>
							<td width="30%" style="#contenidoEnc#">#DESeguroSocial#</td>
						</tr>

						<tr>
							<td width="30%" style="#encabezado#" bgcolor="##CCCCCC">Puesto</td>
							<td width="40%" style="#encabezado#" bgcolor="##CCCCCC">Centro Funcional</td>
							<td width="30%" style="#encabezado#" bgcolor="##CCCCCC">Reg. Fed de Contribuyentes</td>

						</tr>
						<tr>
							<td width="30%" style="#contenidoEnc#">#RHPdescpuesto#</td>
							<td width="40%" style="#contenidoEnc#">#CFcodigo#</td>
							<td width="30%" style="#contenidoEnc#">#RFC#</td>
						</tr>
						<tr>
							<td colspan="2"></td>
						</tr>
						<cfquery name="rsConceptosTodos" datasource="#session.dsn#">
							select
								TipoReg,
								descripcion,
								cantidad,
								importe,
								resultado
							from
							(
								select
									'Deducciones' as TipoReg,
									RHLCdescripcion as descripcion,
									1 as cantidad,
									importe,
									importe as resultado
								from RHLiqCargas
								where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">

								union

								select
									'Deducciones' as TipoReg,
									RHLDdescripcion as descripcion,
									1 as cantidad,
									importe,
									importe as resultado
								from RHLiqDeduccion
								where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">

								union

								Select
									'Percepciones' as TipoReg,
									i.RHLPdescripcion as descripcion,
									round(dd.DDCcant,4) as cantidad,
									dd.DDCimporte as importe,
									round(dd.DDCres,4) as resultado
								from RHLiqIngresos i
								inner join DDConceptosEmpleado dd
									on dd.DLlinea = i.DLlinea
									and dd.CIid = i.CIid
								where i.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">

								union

								select
									'Deducciones' as TipoReg,
									'I.S.R' as descripcion,
									1 as cantidad,
									RHLFLisptF as importe,
									RHLFLisptF as resultado
								from RHLiqFL
								where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">

							) obj
							order by TipoReg
						</cfquery>

						<cfquery name="rsDeduc" dbtype="query">
							select
								descripcion,
								cantidad,
								importe,
								resultado
							from rsConceptosTodos
							where TipoReg = 'Deducciones'
						</cfquery>
						<cfquery name="rsSumDeduc" dbtype="query">
							select
								sum(resultado) sumImporte
							from rsConceptosTodos
							where TipoReg = 'Deducciones'
						</cfquery>

						<cfquery name="rsPerc" dbtype="query">
							select
								descripcion,
								cantidad,
								importe,
								resultado
							from rsConceptosTodos
							where TipoReg = 'Percepciones'
						</cfquery>
						<cfquery name="rsSumPerc" dbtype="query">
							select
								sum(resultado) sumImporte
							from rsConceptosTodos
							where TipoReg = 'Percepciones'
						</cfquery>

						<cfset countD = rsDeduc.RecordCount>
						<cfset countP = rsPerc.RecordCount>
						<tr>
							<td colspan="3">
								<table width="100%" align="center">
									<tr>
										<td width="50%">
											<table width="100%" align="center" style="border-collapse: collapse; border: 1px solid black;">
												<tr>
													<td></td>
												</tr>
												<tr>
													<td bgcolor="##CCCCCC" style="#encabezado#">Descripcion</td>
													<td bgcolor="##CCCCCC" style="#encabezado#">Cantidad</td>
													<td bgcolor="##CCCCCC" style="#encabezado#">Monto</td>
													<td bgcolor="##CCCCCC" style="#encabezado#">Total</td>
												</tr>
												<cfloop query="rsPerc">
													<tr>
														<td style="#contenido#">#descripcion#</td>
														<td style="#contenido#">#LSNumberFormat(cantidad,'9.0000')#</td>
														<td style="#contenido#">#LSNumberFormat(importe,'9.0000')#</td>
														<td style="#contenido#">#LSNumberFormat(resultado,'9.0000')#</td>
													</tr>
												</cfloop>
												<cfif countP lt countD>
													<cfloop from="1" to="#countD-countP#" index="i">
														<tr>
															<td style="#contenido#">&nbsp;</td>
															<td style="#contenido#">&nbsp;</td>
															<td style="#contenido#">&nbsp;</td>
															<td style="#contenido#">&nbsp;</td>
														</tr>
													</cfloop>
												</cfif>
												<tr>
													<td colspan="3" align="right" bgcolor="##CFFDDDD" style="#encabezado#">TOTAL:&nbsp;</td>
													<td align="left" bgcolor="##CFFDDDD" style="#contenidoEnc#">#LSNumberFormat(rsSumPerc.sumImporte,'9.0000')#</td>
												</tr>
											</table>
										</td>
										<td width="50%">
											<table width="100%" align="center" style="border-collapse: collapse; border: 1px solid black;">
												<tr>
													<td></td>
												</tr>
												<tr>
													<td bgcolor="##CCCCCC" style="#encabezado#">Descripcion</td>
													<td bgcolor="##CCCCCC" style="#encabezado#">Cantidad</td>
													<td bgcolor="##CCCCCC" style="#encabezado#">Monto</td>
													<td bgcolor="##CCCCCC" style="#encabezado#">Total</td>
												</tr>
												<cfloop query="rsDeduc">
													<tr>
														<td style="#contenido#">#descripcion#</td>
														<td style="#contenido#">#LSNumberFormat(cantidad,'9.0000')#</td>
														<td style="#contenido#">#LSNumberFormat(importe,'9.0000')#</td>
														<td style="#contenido#">#LSNumberFormat(resultado,'9.0000')#</td>
													</tr>
												</cfloop>

												<cfif countD lt countP>
													<cfloop from="1" to="#countP-countD#" index="i">
														<tr>
															<td style="#contenido#">&nbsp;</td>
															<td style="#contenido#">&nbsp;</td>
															<td style="#contenido#">&nbsp;</td>
															<td style="#contenido#">&nbsp;</td>
														</tr>
													</cfloop>
												</cfif>

												<tr>
													<td colspan="3" align="right" bgcolor="##CFFDDDD" style="#encabezado#">TOTAL:&nbsp;</td>
													<td align="left" bgcolor="##CFFDDDD" style="#contenidoEnc#">#LSNumberFormat(rsSumDeduc.sumImporte,'9.0000')#</td>
												</tr>
											</table>
										</td>

									</tr>
									<tr>
										<td colspan="2" align="right">
											<table width="100%" border="0">
												<tr>
													<td width="95%" align="right" style="#miniBold#">Total:&nbsp;</td>
													<td width="5%" align="left" style="#contenidoEnc#">#LSNumberFormat((rsSumPerc.sumImporte - rsSumDeduc.sumImporte),'9.00')#</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr><td colspan="2">&nbsp;</td></tr>
									<tr>
										<td colspan="2">
											<table width="100%" align="center">
												<tr>
													<td colspan="" width="55%" style="text-align: justify; text-justify: inter-word; #contenido#" >
														Recibi de #rsEmp.Edescripcion# la cantidad indicada que cubre a la fecha el importe de mi salario, tiempo extra
														septimo dia y todas las percepciones y prestaciones a las que tengo derecho sin que se me adeude alguna cantidad por otro concepto.
													</td>
													<td colspan="" align="center" width="45%" style="#miniBold#">
														<p>
															<hr width="75%"/>
														</p>
														<strong>Firma del Empleado</strong>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</table>
		<cfif countPage mod 2 eq 0 and rsInfoEnc.RecordCount neq countPage>
			<div class="saltopagina"></div>
		</cfif>
		<cfset countPage++>

	</cfloop>
</cfoutput>