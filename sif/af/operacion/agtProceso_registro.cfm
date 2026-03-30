<!--- Definiciones iniciales de la pantalla --->
<cfif isdefined("url.AGTPid") and len(trim(url.AGTPid))><cfset form.AGTPid = url.AGTPid></cfif>
<cfif isdefined("url.ADTPlinea") and len(trim(url.ADTPlinea))><cfset form.ADTPlinea = url.ADTPlinea></cfif>
<cfif isdefined("form.LADTPlinea") and len(trim(form.LADTPlinea))><cfset form.ADTPlinea = form.LADTPlinea></cfif>
<!--- Comportamientos de  de la pantalla --->
<!--- tipodetventa indica que el tipo de la captura va a ser para un retiro de activos fijos por venta --->
<cfif isdefined('form.params')>
	<cfset params = form.params>
</cfif>
<cfset tipodetventa = false>
<cfset modocambio = false>
<cfset mododetcambio = false>
<cfif isdefined("form.AGTPid") and len(trim(form.AGTPid))>
	<cfset modocambio = true>
</cfif>
<cfif isdefined("form.ADTPlinea") and len(trim(form.ADTPlinea))>
	<cfset mododetcambio = true>
	<cfset form.LADTPlinea = form.ADTPlinea>
</cfif>

<cfif modocambio>
	<cfquery name="rsAGTProceso" datasource="#session.dsn#">
		select
			a.AGTPid, 
			a.AGTPdescripcion, 
			a.AFRmotivo, 
			a.AGTPrazon, 
			d.AFResventa,
			a.ts_rversion, 
			a.Usucodigo, 
			a.AGTPfalta,
			a.AGTPexterno,
			<cf_dbfunction name="concat" args="c.Pnombre +' ' + c.Papellido1 +' ' +c.Papellido2" delimiters="+">  as nombre
		from AGTProceso a		
			inner join Usuario b on a.Usucodigo = b.Usucodigo
			inner join DatosPersonales c on b.datos_personales = c.datos_personales			
			left outer join AFRetiroCuentas d on d.Ecodigo = a.Ecodigo and d.AFRmotivo = a.AFRmotivo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  and a.AGTPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
	</cfquery>
	<cfif rsAGTProceso.AFResventa EQ 'S'>
		<cfset tipodetventa = true>
	</cfif>
	<cfset Vsistext = rsAGTProceso.AGTPexterno>
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp= "#rsAGTProceso.ts_rversion#" returnvariable="ts"/>

	<cfif mododetcambio>
		<cfquery name="rsADTProceso" datasource="#session.dsn#">
			select ADTPlinea, c.Aid, c.Aplaca, c.Adescripcion, ADTPrazon, a.ts_rversion, a.Aiddestino, coalesce(e.Aplaca,a.Aplacadestino) as Aplacadestino, e.Adescripcion as Adescripciondestino, 
				AFSvaladq, 			AFSvalmej, 			AFSvalrev, 			AFSvaladq 		+ AFSvalmej 		+ AFSvalrev 		as AFSvaltot,
				AFSdepacumadq, 	AFSdepacummej, 	AFSdepacumrev, 	AFSdepacumadq + AFSdepacummej + AFSdepacumrev as AFSdepacumtot,
				AFSvaladq - AFSdepacumadq as AFSsaldoadq,
				AFSvalmej - AFSdepacummej as AFSsaldomej,
				AFSvalrev - AFSdepacumrev as AFSsaldorev,
				case when (AFSvaladq) > 0.00 then TAmontolocadq * 100 / AFSvaladq else 0.00 end as PRCmontolocadq,
				case when (AFSvalmej) > 0.00 then TAmontolocmej * 100 / AFSvalmej else 0.00 end as PRCmontolocmej,
				case when (AFSvalrev) <> 0.00 then TAmontolocrev * 100 / AFSvalrev else 0.00 end as PRCmontolocrev,
				case when ((AFSvaladq 		+ AFSvalmej 		+ AFSvalrev)) > 0.00 then (TAmontolocadq + TAmontolocmej + TAmontolocrev) * 100 / ((AFSvaladq 		+ AFSvalmej 		+ AFSvalrev)) else 0.00 end as PRCmontoloctot,
				TAmontodepadq,
				TAmontodepmej,
				TAmontodeprev,
				TAmontodepadq + 
				TAmontodepmej + 
				TAmontodeprev as TAmontodeptot,
				(AFSvaladq 		+ AFSvalmej 		+ AFSvalrev) - (AFSdepacumadq + AFSdepacummej + AFSdepacumrev) as AFSsaldotot,
				TAmontolocadq, 	TAmontolocmej, 	TAmontolocrev, 	TAmontolocadq + TAmontolocmej + TAmontolocrev as TAmontoloctot,
				TAmontolocventa, Icodigo, case when Icodigo is not null then TAmontolocventa + round(coalesce((select Iporcentaje from Impuestos where Ecodigo = a.Ecodigo and  Icodigo = a.Icodigo ),0.00)*coalesce(TAmontolocventa,0.00)/100.00,2)  else 0.00 end as TAtotallocventa,
                a.TipoCuentaRetiro, a.SNcodigo, a.CCTcodigo
			from ADTProceso a 
				inner join AGTProceso b on a.AGTPid = b.AGTPid and a.Ecodigo = b.Ecodigo
				inner join Activos c on a.Aid = c.Aid and a.Ecodigo = c.Ecodigo
				inner join AFSaldos d on a.Aid = d.Aid and a.Ecodigo = d.Ecodigo and d.AFSperiodo = b.AGTPperiodo and d.AFSmes = b.AGTPmes
				left outer join Activos e on a.Aiddestino = e.Aid and a.Ecodigo = e.Ecodigo
			where a.Ecodigo = #session.ecodigo#
			and a.AGTPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
			and a.ADTPlinea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.ADTPlinea#">
		</cfquery>		
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp= "#rsADTProceso.ts_rversion#" returnvariable="tsdet"/>
	</cfif>
</cfif>
<!---Incluye API de Qforms--->
<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>

<cfoutput>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
<input name="params" type="hidden" value="#params#">
  <tr>
    <td align="center">
			<table width="0%" align="center"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<cfif not modocambio>
							<fieldset><legend>Informaci&oacute;n requerida</legend>
								<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td><strong>Descripci&oacute;n&nbsp;:&nbsp;</strong></td>
										<td>&nbsp;&nbsp;</td>
										<td>
											<input name="AGTPdescripcion" type="text" size="60" maxlength="80" tabindex="1"
												<cfif modocambio>value="#rsAGTProceso.AGTPdescripcion#"</cfif>>
										</td>
									</tr>
									<cfif IDtrans eq 5>
										<cfquery name="AFRmotivos" datasource="#session.dsn#">
											select AFRmotivo, AFRdescripcion
											from AFRetiroCuentas
											where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
										</cfquery>
										<tr>
											<td><strong>Motivo&nbsp;:&nbsp;</strong></td>
											<td>&nbsp;&nbsp;</td>
											<td>
												<select name="AFRmotivo" onChange="javascript:setDescripcion();" tabindex="2">
													<cfloop query="AFRmotivos">
														<option value="#AFRmotivos.AFRmotivo#" <cfif modocambio and rsAGTProceso.AFRmotivo EQ AFRmotivos.AFRmotivo>selected</cfif>>#AFRmotivos.AFRdescripcion#</option>
													</cfloop>
												</select>
											</td>
										</tr>
									</cfif>
									<tr>
										<td><strong>Justificaci&oacute;n&nbsp;:&nbsp;</strong></td>
										<td>&nbsp;&nbsp;</td>
										<td>
											<input name="AGTPrazon" type="text" size="60" maxlength="255" tabindex="3"
												<cfif modocambio>value="#rsAGTProceso.AGTPrazon#"</cfif>>
										</td>
									</tr>
								</table>
							</fieldset>
						<cfelse>
							<fieldset><legend>Relaci&oacute;n de Retiro</legend>
								<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="12%"><strong>Descripci&oacute;n:&nbsp;&nbsp;</strong></td>
										<td width="34%" align="left">#rsAGTProceso.AGTPdescripcion#
											<input name="AGTPdescripcion" type="hidden" size="60" maxlength="80" tabindex="-1"
												value="#rsAGTProceso.AGTPdescripcion#">
										</td>
										<td width="13%" align="left"><strong>Creado por:</strong></td>
										<td width="41%" align="left">#rsAGTProceso.nombre#</td>
									</tr>
									<cfsavecontent variable="Tds_Fecha">
										<td align="left"><strong>Fecha:</strong></td>
										<td align="left">#LSDateFormat(rsAGTProceso.AGTPfalta,"dd/mm/yyyy")#</td>
									</cfsavecontent>
									<cfif IDtrans eq 5>
										<cfquery name="AFRmotivos" datasource="#session.dsn#">
											select AFRmotivo, AFRdescripcion
											from AFRetiroCuentas
											where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
										</cfquery>
										<tr>
											<td width="12%"><strong>Motivo:&nbsp;&nbsp;</strong></td>
											<td align="left">
												<cfloop query="AFRmotivos">
													<cfif modocambio and rsAGTProceso.AFRmotivo EQ AFRmotivos.AFRmotivo>
														#AFRmotivos.AFRdescripcion#
														<input name="AFRmotivo"	type="hidden" value="#AFRmotivos.AFRmotivo#">
													</cfif>
												</cfloop>												
											</td>
											#Tds_Fecha#
											<cfset Tds_Fecha = "">
										</tr>
									</cfif>
									<tr>
										<td width="12%" rowspan="2"><strong>Justificaci&oacute;n:&nbsp;&nbsp;</strong></td>
										<td align="left" rowspan="2">
											#rsAGTProceso.AGTPrazon#
											<input name="AGTPrazon" type="hidden" size="60" maxlength="255" tabindex="-1"
												value="#rsAGTProceso.AGTPrazon#">
										</td>
										#Tds_Fecha#
									</tr>
								</table>
							</fieldset>						
						</cfif>

						<cfif modocambio>
														
							<br>
							<fieldset><legend>Asociar Activos a Relaci&oacute;n</legend>
						
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td><strong>Activo&nbsp;:&nbsp;</strong></td>
										<td>&nbsp;&nbsp;</td>
										<td>
											<cfif mododetcambio>
												<cf_sifactivo form="fagtproceso" query="#rsADTProceso#" modificable="false" 
												tabindex="1">
											<cfelse>
												<cf_sifactivo form="fagtproceso" 
												tabindex="1">
											</cfif>
										</td>
										<cfif not mododetcambio>
										<td rowspan="3" valign="middle">
											<cfif (isdefined("session.LvarJA") and not session.LvarJA) or (not isdefined("session.LvarJA"))>
												<cfif isdefined("Vsistext") and Vsistext eq 0>
													<cf_botones values="Asociar" tabindex="2">
												</cfif>
                                            </cfif>
										</td>
										</cfif>
									</tr>
									<cfif IDtrans eq 8>
									<tr>
										<td><strong>Activo destino&nbsp;:&nbsp;</strong></td>
										<td>&nbsp;&nbsp;</td>
										<td>
											<cfif mododetcambio>
												<cf_sifactivo form="fagtproceso" query="#rsADTProceso#" modificable="false" 
												tabindex="1" name="Aiddestino" placa="Aplacadestino" desc="Adescripciondestino">
											<cfelse>
												<cf_sifactivo form="fagtproceso" 
												tabindex="1" name="Aiddestino" placa="Aplacadestino" desc="Adescripciondestino" 
												permitenuevo="true" funcion="funcLimpiarAplacadestino" fparams="Aiddestino">
											</cfif>
										</td>
									</tr>
									</cfif>
									<tr>
										<td><strong>Justificaci&oacute;n&nbsp;:&nbsp;</strong></td>
										<td>&nbsp;&nbsp;</td>
										<td>
											<input name="ADTPrazon" type="text" size="60" maxlength="255" tabindex="1"
												value="<cfif mododetcambio>#rsADTProceso.ADTPrazon#<cfelse>#rsAGTProceso.AGTPrazon#</cfif>">
										</td>
									</tr>
								</table>
							</fieldset>
							<br>
							
							<cfif mododetcambio and tipodetventa>
								<fieldset><legend>Informaci&oacute;n de Activo</legend>
									<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
										<tr>
											<td>
												<table width="100%"  border="0" cellspacing="0" cellpadding="0">
													<tr>
														<td>&nbsp;</td>
														<td align="right"><strong>ADQ.&nbsp;&nbsp;</strong></td>
														<td align="right"><strong>MEJ.&nbsp;&nbsp;</strong></td>
														<td align="right"><strong>REV.&nbsp;&nbsp;</strong></td>
														<td align="right"><strong>TOTAL.&nbsp;&nbsp;</strong></td>
													</tr>
													<tr>
														<td align="right"><strong>VALOR&nbsp;:&nbsp;</strong></td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSvaladq,'none')#<cfelse>0.00</cfif>&nbsp;</td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSvalmej,'none')#<cfelse>0.00</cfif>&nbsp;</td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSvalrev,'none')#<cfelse>0.00</cfif>&nbsp;</td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSvaltot,'none')#<cfelse>0.00</cfif>&nbsp;</td>
													</tr>
													<tr>
														<td align="right"><strong>DEP&nbsp;:&nbsp;</strong></td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSdepacumadq,'none')#<cfelse>0.00</cfif>&nbsp;</td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSdepacummej,'none')#<cfelse>0.00</cfif>&nbsp;</td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSdepacumrev,'none')#<cfelse>0.00</cfif>&nbsp;</td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSdepacumtot,'none')#<cfelse>0.00</cfif>&nbsp;</td>
													</tr>
													<tr>
														<td align="right"><strong>VALOR LIBROS&nbsp;:&nbsp;</strong></td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSsaldoadq,'none')#<cfelse>0.00</cfif>&nbsp;</td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSsaldomej,'none')#<cfelse>0.00</cfif>&nbsp;</td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSsaldorev,'none')#<cfelse>0.00</cfif>&nbsp;</td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSsaldotot,'none')#<cfelse>0.00</cfif>&nbsp;</td>
													</tr>
													<tr>
														<td>
															 <strong>Monto Venta&nbsp;:&nbsp;</strong>
														</td>
														<td align="right" colspan="4"><cfif mododetcambio><cf_monto name="TAmontolocventa" form="fagtproceso" query="#rsADTProceso#" onBlur="funcTAmontolocventa();"><cfelse><cf_monto name="TAmontolocventa" form="fagtproceso" onBlur="funcTAmontolocventa();"></cfif></td>
													</tr>
                                                    <tr>
														<td>
															 <strong>Cuenta para Retiro&nbsp;:&nbsp;</strong>
														</td>
														<td align="right" colspan="4">
															<select id="TipoCuentaR" name="TipoCuentaR" onChange="javascript:funcTipoCuenta();" tabindex="1">
																<option value="0" selected>Dinero en Tránsito</option>
                                                                <option value="1" <cfif mododetcambio and rsADTProceso.TipoCuentaRetiro EQ 1>selected</cfif>>Cuenta Cliente</option>
															</select>
                                                        </td>
													</tr>
													<tr id="DatosSocio" style="display:none">
                                                    	<td colspan="6">
                                                        	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
                                                                <tr>
                                                                    <td>
                                                                         <strong>Socio Negocios&nbsp;:&nbsp;</strong>
                                                                    </td>
                                                                    <td align="right">
                                                                        <cfif rsADTProceso.TipoCuentaRetiro EQ 1 and isdefined("rsADTProceso.SNcodigo") and len(trim(rsADTProceso.SNcodigo)) GT 0>
                                                                            <cf_sifsociosnegocios2 form="fagtproceso" idquery="#rsADTProceso.SNcodigo#" size="43"  tabindex="2" SNtiposocio = 'C'>
                                                                        <cfelse>
                                                                            <cf_sifsociosnegocios2 form="fagtproceso" size="43"  tabindex="2" SNtiposocio = 'C'>
                                                                        </cfif>		                                                                        		                                                                    </td>
                                                                </tr>
                                                                <cfquery datasource="#session.dsn#" name="rsTransaccionesCC">
                                                                    select CCTcodigo, CCTdescripcion
                                                                    from CCTransacciones
                                                                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                                                                    and CCTtipo like 'D'
                                                                </cfquery>
                                                                <tr>
                                                                    <td>
                                                                         <strong>Transacción&nbsp;:&nbsp;</strong>
                                                                    </td>
                                                                    <td align="right" colspan="4">
                                                                        <select name="CCTcodigo" tabindex="3">
                                                                            <cfloop query="rsTransaccionesCC">
                                                                                <option value="#rsTransaccionesCC.CCTcodigo#" <cfif mododetcambio and rsADTProceso.CCTcodigo EQ rsTransaccionesCC.CCTcodigo>selected</cfif>>#rsTransaccionesCC.CCTcodigo#-#rsTransaccionesCC.CCTdescripcion#</option>
                                                                            </cfloop>
                                                                        </select>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
													<cfquery name="rsImpuestos" datasource="#Session.DSN#">
														select Icodigo, Idescripcion, Iporcentaje
														from Impuestos 
														where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
														order by Idescripcion                                 
													</cfquery>
													<tr>
														<td>
															 <strong>Impuesto&nbsp;:&nbsp;</strong>
														</td>
														<td align="right" colspan="4">
															<select name="Icodigo" onChange="javascript:funcTAmontolocventa();" tabindex="4">
																<cfloop query="rsImpuestos">
																	<option value="#rsImpuestos.Icodigo#|#rsImpuestos.Iporcentaje#" 
																		<cfif mododetcambio and rsADTProceso.Icodigo EQ rsImpuestos.Icodigo>selected</cfif>>
																		#rsImpuestos.Icodigo# - #rsImpuestos.Idescripcion# 
																	</option>
																</cfloop>
															</select>
													</tr>
													<tr>
														<td>
															 <strong>Total&nbsp;:&nbsp;</strong>
														</td>
														<td align="right" colspan="4">
															<cfif mododetcambio>
																<cf_monto name="TAtotallocventa" form="fagtproceso" query="#rsADTProceso#" modificable="false" class="cajasinbordeb" tabindex="-1"><cfelse><cf_monto name="TAtotallocventa" form="fagtproceso" modificable="false" class="cajasinbordeb" tabindex="-1">
															</cfif>
                                                         </td>
													</tr>
												</table>
											</td>
										</tr>
									</table>									
								</fieldset>
							<cfelseif mododetcambio>
								<fieldset><legend>Informaci&oacute;n de Activo</legend>
									<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
										<tr>
											<td>
												<table width="100%"  border="0" cellspacing="0" cellpadding="0">
													<tr>
														<td>&nbsp;</td>
														<td align="right"><strong>ADQ.&nbsp;&nbsp;</strong></td>
														<td align="right"><strong>MEJ.&nbsp;&nbsp;</strong></td>
														<td align="right"><strong>REV.&nbsp;&nbsp;</strong></td>
														<td align="right"><strong>TOTAL.&nbsp;&nbsp;</strong></td>
													</tr>
													<cfif rsADTProceso.recordcount gt 0>
													<cfquery name="CountActivoOrigen" datasource="#session.dsn#">
														select count(AGTPid) as total
															from ADTProceso
														where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
														and Ecodigo = #session.Ecodigo#
														and Aid = #rsADTProceso.Aid#
													</cfquery>
												</cfif>
													<cfif isdefined("CountActivoOrigen") and CountActivoOrigen.total GT 1>
														<cfquery name="CountActivoOrigenDisp" datasource="#session.dsn#">
															select SUM(TAmontolocadq) as TOT_TAmontolocadq, SUM(TAmontolocmej) as TOT_TAmontolocmej,
																   SUM(TAmontolocrev) as TOT_TAmontolocrev, SUM(TAmontolocadq + TAmontolocmej + TAmontolocrev) as TOT_TAmontoloctot
																from ADTProceso
															where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
															and Ecodigo = #session.Ecodigo#
															and Aid = #rsADTProceso.Aid#
														</cfquery>
														<input type="hidden" name="TOT_TAmontolocadq" id="TOT_TAmontolocadq" value="#rsADTProceso.AFSvaladq-CountActivoOrigenDisp.TOT_TAmontolocadq#" tabindex="-1">
														<input type="hidden" name="TOT_TAmontolocmej" id="TOT_TAmontolocmej" value="#rsADTProceso.AFSvalmej-CountActivoOrigenDisp.TOT_TAmontolocmej#" tabindex="-1">
														<input type="hidden" name="TOT_TAmontolocrev" id="TOT_TAmontolocrev" value="#rsADTProceso.AFSvalrev-CountActivoOrigenDisp.TOT_TAmontolocrev#" tabindex="-1">
														<input type="hidden" name="TOT_TAmontoloctot" id="TOT_TAmontoloctot" value="#rsADTProceso.AFSvaltot-CountActivoOrigenDisp.TOT_TAmontoloctot#" tabindex="-1">
													<tr>
														<td align="right"><font color="FF0000"><strong>DISPONIBLE&nbsp;:&nbsp;</strong></font></td>
														<td align="right"><font color="FF0000"><strong><cfif mododetcambio><span id="TOT_TAmontolocadq_TXT">#LSCurrencyFormat(rsADTProceso.AFSvaladq-CountActivoOrigenDisp.TOT_TAmontolocadq,'none')#</span><cfelse>0.00</cfif>&nbsp;</strong></font></td>
														<td align="right"><font color="FF0000"><strong><cfif mododetcambio><span id="TOT_TAmontolocmej_TXT">#LSCurrencyFormat(rsADTProceso.AFSvalmej-CountActivoOrigenDisp.TOT_TAmontolocmej,'none')#</span><cfelse>0.00</cfif>&nbsp;</strong></font></td>
														<td align="right"><font color="FF0000"><strong><cfif mododetcambio><span id="TOT_TAmontolocrev_TXT">#LSCurrencyFormat(rsADTProceso.AFSvalrev-CountActivoOrigenDisp.TOT_TAmontolocrev,'none')#</span><cfelse>0.00</cfif>&nbsp;</strong></font></td>
														<td align="right"><font color="FF0000"><strong><cfif mododetcambio><span id="TOT_TAmontoloctot_TXT">#LSCurrencyFormat(rsADTProceso.AFSvaltot-CountActivoOrigenDisp.TOT_TAmontoloctot,'none')#</span><cfelse>0.00</cfif>&nbsp;</strong></font></td>
													</tr>
													<cfelse>
														<input type="hidden" name="TOT_TAmontolocadq" id="TOT_TAmontolocadq" value="#rsADTProceso.AFSvaladq#" tabindex="-1">
														<input type="hidden" name="TOT_TAmontolocmej" id="TOT_TAmontolocmej" value="#rsADTProceso.AFSvalmej#" tabindex="-1">
														<input type="hidden" name="TOT_TAmontolocrev" id="TOT_TAmontolocrev" value="#rsADTProceso.AFSvalrev#" tabindex="-1">
														<input type="hidden" name="TOT_TAmontoloctot" id="TOT_TAmontoloctot" value="#rsADTProceso.AFSvaltot#" tabindex="-1">
													</cfif>
													<tr>
														<td align="right"><strong>VALOR&nbsp;:&nbsp;</strong></td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSvaladq,'none')#<cfelse>0.00</cfif>&nbsp;</td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSvalmej,'none')#<cfelse>0.00</cfif>&nbsp;</td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSvalrev,'none')#<cfelse>0.00</cfif>&nbsp;</td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSvaltot,'none')#<cfelse>0.00</cfif>&nbsp;</td>
													</tr>
													<tr>
														<td align="right"><strong>DEP&nbsp;:&nbsp;</strong></td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSdepacumadq,'none')#<cfelse>0.00</cfif>&nbsp;</td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSdepacummej,'none')#<cfelse>0.00</cfif>&nbsp;</td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSdepacumrev,'none')#<cfelse>0.00</cfif>&nbsp;</td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSdepacumtot,'none')#<cfelse>0.00</cfif>&nbsp;</td>
													</tr>
													<tr>
														<td align="right"><strong>VALOR LIBROS&nbsp;:&nbsp;</strong></td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSsaldoadq,'none')#<cfelse>0.00</cfif>&nbsp;</td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSsaldomej,'none')#<cfelse>0.00</cfif>&nbsp;</td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSsaldorev,'none')#<cfelse>0.00</cfif>&nbsp;</td>
														<td align="right"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSsaldotot,'none')#<cfelse>0.00</cfif>&nbsp;</td>
													</tr>
													<tr>
														<td>
															<!--- 
															<select name="PORCMON">
																<option value="0"><strong>PORC(%)&nbsp;:&nbsp;</strong></option>
																<option value="1"><strong>MONTO&nbsp;:&nbsp;</strong></option>
															</select>
															 --->
															 
															 <strong>PORC(%)&nbsp;:&nbsp;</strong>
														</td>
														<td align="right"><cfif mododetcambio><cfif isdefined("Vsistext") and Vsistext eq 1><cf_monto name="PRCmontolocadq" form="fagtproceso" query="#rsADTProceso#" modificable="false" tabindex="3" decimales="8"><cfelse><cf_monto name="PRCmontolocadq" form="fagtproceso" query="#rsADTProceso#" tabindex="3" decimales="8"></cfif><cfelse><cf_monto name="PRCmontolocadq" form="fagtproceso" tabindex="3" decimales="8"></cfif></td>
														<td align="right"><cfif mododetcambio><cfif isdefined("Vsistext") and Vsistext eq 1><cf_monto name="PRCmontolocmej" form="fagtproceso" query="#rsADTProceso#" modificable="false" tabindex="3" decimales="8"><cfelse><cf_monto name="PRCmontolocmej" form="fagtproceso" query="#rsADTProceso#" tabindex="3" decimales="8"></cfif><cfelse><cf_monto name="PRCmontolocmej" form="fagtproceso" tabindex="3" decimales="8"></cfif></td>
														<td align="right"><cfif mododetcambio><cfif isdefined("Vsistext") and Vsistext eq 1><cf_monto name="PRCmontolocrev" form="fagtproceso" query="#rsADTProceso#" modificable="false" tabindex="3" decimales="8"><cfelse><cf_monto name="PRCmontolocrev" form="fagtproceso" query="#rsADTProceso#" tabindex="3" decimales="8"></cfif><cfelse><cf_monto name="PRCmontolocrev" form="fagtproceso" tabindex="3" decimales="8"></cfif></td>
														<td align="right"><cfif mododetcambio><cf_monto name="PRCmontoloctot" form="fagtproceso" query="#rsADTProceso#" modificable="false" tabindex="3"><cfelse><cf_monto name="PRCmontoloctot" form="fagtproceso" modificable="false" tabindex="3"></cfif></td>
													</tr>
														<cfif mododetcambio><input type="hidden" name="ORIG_TAmontolocadq" id="ORIG_TAmontolocadq" value="#rsADTProceso.TAmontolocadq#" tabindex="-1"><cfelse><input type="hidden" name="AFSvaladq" id="AFSvaladq" tabindex="-1"></cfif>
														<cfif mododetcambio><input type="hidden" name="ORIG_TAmontolocmej" id="ORIG_TAmontolocmej" value="#rsADTProceso.TAmontolocmej#" tabindex="-1"><cfelse><input type="hidden" name="AFSvalmej" id="AFSvalmej" tabindex="-1"></cfif>
														<cfif mododetcambio><input type="hidden" name="ORIG_TAmontolocrev" id="ORIG_TAmontolocrev" value="#rsADTProceso.TAmontolocrev#" tabindex="-1"><cfelse><input type="hidden" name="AFSvalrev" id="AFSvalrev" tabindex="-1"></cfif>
														<cfif mododetcambio><input type="hidden" name="ORIG_TAmontoloctot" id="ORIG_TAmontoloctot" value="#rsADTProceso.TAmontoloctot#" tabindex="-1"><cfelse><input type="hidden" name="AFSvaltot" id="AFSvaltot" tabindex="-1"></cfif>
													<tr>
														<td><strong>MONTO&nbsp;:&nbsp;</strong></td>
														<td align="right"><cfif mododetcambio><input type="hidden" name="HTAmontolocadq" id="HTAmontolocadq" value="#rsADTProceso.AFSvaladq#" tabindex="-1"><!---20050405 AFSsaldoadq---><cfif isdefined("Vsistext") and Vsistext eq 1><cf_monto name="TAmontolocadq" form="fagtproceso" query="#rsADTProceso#" tabindex="3" modificable="false"><cfelse><cf_monto name="TAmontolocadq" form="fagtproceso" query="#rsADTProceso#" tabindex="3"></cfif><cfelse><input type="hidden" name="HTAmontolocadq" id="HTAmontolocadq" tabindex="-1"><cf_monto name="TAmontolocadq" form="fagtproceso" tabindex="3"></cfif></td>
														<td align="right"><cfif mododetcambio><input type="hidden" name="HTAmontolocmej" id="HTAmontolocmej" value="#rsADTProceso.AFSvalmej#" tabindex="-1"><!---20050405 AFSsaldomej---><cfif isdefined("Vsistext") and Vsistext eq 1><cf_monto name="TAmontolocmej" form="fagtproceso" query="#rsADTProceso#" tabindex="3" modificable="false"><cfelse><cf_monto name="TAmontolocmej" form="fagtproceso" query="#rsADTProceso#" tabindex="3"></cfif><cfelse><input type="hidden" name="HTAmontolocmej" id="HTAmontolocmej" tabindex="-1"><cf_monto name="TAmontolocmej" form="fagtproceso" tabindex="3"></cfif></td>
														<td align="right"><cfif mododetcambio><input type="hidden" name="HTAmontolocrev" id="HTAmontolocrev" value="#rsADTProceso.AFSvalrev#" tabindex="-1"><!---20050405 AFSsaldorev---><cfif isdefined("Vsistext") and Vsistext eq 1><cf_monto name="TAmontolocrev" form="fagtproceso" query="#rsADTProceso#" tabindex="3" modificable="false"><cfelse><cf_monto name="TAmontolocrev" form="fagtproceso" query="#rsADTProceso#" tabindex="3"></cfif><cfelse><input type="hidden" name="HTAmontolocrev" id="HTAmontolocrev" tabindex="-1"><cf_monto name="TAmontolocrev" form="fagtproceso" tabindex="3"></cfif></td>
														<td align="right"><cfif mododetcambio><input type="hidden" name="HTAmontoloctot" id="HTAmontoloctot" value="#rsADTProceso.AFSvaltot#" tabindex="-1"><!---20050405 AFSsaldotot---><cf_monto name="TAmontoloctot" form="fagtproceso" query="#rsADTProceso#" tabindex="3" modificable="false"><cfelse><input type="hidden" name="HTAmontoloctot"  tabindex="-1" id="HTAmontoloctot"><cf_monto name="TAmontoloctot" form="fagtproceso" modificable="false" tabindex="3"></cfif></td>
													</tr>
													<tr>
														<td><strong>DEP. ACUM.&nbsp;:&nbsp;</strong></td>
														<td align="right"><cfif mododetcambio><input type="hidden" name="HTAmontodepadq" id="HTAmontodepadq" value="#rsADTProceso.AFSdepacumadq#" disabled tabindex="-1"><cf_monto name="TAmontodepadq" form="fagtproceso" query="#rsADTProceso#" modificable="false" tabindex="3"><cfelse><cf_monto name="TAmontodepadq" form="fagtproceso" modificable="false" tabindex="3"></cfif></td>
														<td align="right"><cfif mododetcambio><input type="hidden" name="HTAmontodepmej" id="HTAmontodepmej" value="#rsADTProceso.AFSdepacummej#" disabled tabindex="-1"><cf_monto name="TAmontodepmej" form="fagtproceso" query="#rsADTProceso#" modificable="false" tabindex="3"><cfelse><cf_monto name="TAmontodepmej" form="fagtproceso" modificable="false" tabindex="3"> </cfif></td>
														<td align="right"><cfif mododetcambio><input type="hidden" name="HTAmontodeprev" id="HTAmontodeprev" value="#rsADTProceso.AFSdepacumrev#" disabled tabindex="-1"><cf_monto name="TAmontodeprev" form="fagtproceso" query="#rsADTProceso#" modificable="false" tabindex="3"><cfelse><cf_monto name="TAmontodeprev" form="fagtproceso" modificable="false" tabindex="3"></cfif></td>
														<td align="right"><cfif mododetcambio><input type="hidden" name="HTAmontodeptot" id="HTAmontodeptot" value="#rsADTProceso.AFSdepacumtot#" disabled tabindex="-1"><cf_monto name="TAmontodeptot" form="fagtproceso" query="#rsADTProceso#" modificable="false" tabindex="3"><cfelse><cf_monto name="TAmontodeptot" form="fagtproceso" modificable="false" tabindex="3"></cfif></td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</fieldset>
							</cfif>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">	
										<cfif modocambio>
											<cfset Aplicar = "Aplicar">
										<cfelse>
											<cfset Aplicar = "">
										</cfif>

										<cfset LvarPar = ''>
										<cfif isdefined("session.LvarJA") and session.LvarJA>
                                            <cfset LvarPar = '_JA'>
                                        <cfelseif isdefined("session.LvarJA") and not session.LvarJA>
                                            <cfset LvarPar = '_Aux'>
                                        </cfif>
                                        
										<cfif mododetcambio>											
											<cfif isdefined("session.LvarJA") and session.LvarJA><!--- Es Jefe Administrativo --->
												<!--- Aca solo va mostrar el botón Regresar ---> 
												  <cfset botonesex[1] = "CambioDet">
													<cfset botonesex[2] = "BajaDet">
													<cfset botonesex[3] = "Baja">
													<cfset botonesex[4] = "NuevoDet">
												  <cf_botones modocambio="#modocambio#" mododet="CAMBIO" excludearray="#botonesex#" form="fagtproceso" tabindex="3"  regresar="agtProceso_genera_#botonAccion[IDtrans][1]##LvarPar#.cfm?#params#&AGTPid=#form.AGTPid#"	nameenc="Grupo" genero="M" >
											  <cfelseif isdefined("session.LvarJA") and not session.LvarJA> <!--- Es auxiliar --->
													<!--- Acá muestra los botones normalmente (Modificar, Eliminar, Eliminar Grupo, Nuevo y regresar) --->
													<cf_botones modocambio="#modocambio#"  mododet="CAMBIO" form="fagtproceso" tabindex="3"  regresar="agtProceso_genera_#botonAccion[IDtrans][1]##LvarPar#.cfm?#params#&AGTPid=#form.AGTPid#"	nameenc="Grupo" genero="M" >
                                     <cfelse>
												<cfif isdefined("Vsistext") and Vsistext eq 1> 
                                                    <cfset botonesex[1] = "CambioDet">
                                                    <cfset botonesex[2] = "BajaDet">
                                                    <cfset botonesex[3] = "Baja">
                                                    <cfset botonesex[4] = "NuevoDet">
                                                    <cf_botones modocambio="#modocambio#" excludearray="#botonesex#" mododet="CAMBIO" form="fagtproceso" tabindex="3"  regresar="agtProceso_genera_#botonAccion[IDtrans][1]#.cfm?#params#&AGTPid=#form.AGTPid#"	nameenc="Grupo" genero="M" >
                                                <cfelse>
																    <cf_botones modocambio="#modocambio#" mododet="CAMBIO" form="fagtproceso" tabindex="3"  regresar="agtProceso_genera_#botonAccion[IDtrans][1]#.cfm?#params#&AGTPid=#form.AGTPid#"	nameenc="Grupo" genero="M" >
                                                </cfif>
                                                <cfif isdefined("CountActivoOrigen") and CountActivoOrigen.total GT 1>
                                                    <br /><font color="FF0000">El Activo Origen tiene otras Transacciones de Traslado Pendientes,<br />en <strong>DISPONIBLE</strong> aparece el Monto Disponible de Traslado.</font>
                                                </cfif>
                                            </cfif>
	                                        <input type="hidden" name = "ts_rversiondet" value ="#tsdet#" tabindex="-1">
                                            <input type="hidden" name = "ADTPlinea" value ="#form.ADTPlinea#" tabindex="-1">
										<cfelse>
											<cfif isdefined("session.LvarJA") and session.LvarJA>
    	                                        <cfset botonesexc[1] = "CAMBIO">
	                                            <cfset botonesexc[2] = "BAJA">
                                                <cfset botonesexc[3] = "Nuevo">
                                                <cf_botones modocambio="#modocambio#" excludearray="#botonesexc#" form="fagtproceso" include="#Aplicar#" tabindex="3" regresar="agtProceso_#botonAccion[IDtrans][1]##LvarPar#.cfm?#params#&AGTPid=#form.AGTPid#">	
                                            <cfelseif isdefined("session.LvarJA") and not session.LvarJA>
														      <cf_botones modocambio="#modocambio#" form="fagtproceso" tabindex="3" regresar="agtProceso_#botonAccion[IDtrans][1]##LvarPar#.cfm?#params#&AGTPid=#form.AGTPid#">
                                            <cfelse>
												<cfif isdefined("Vsistext") and Vsistext eq 1>
													 <cfset botonesexc[1] = "CAMBIO">
													 <cfset botonesexc[2] = "BAJA">
													 <cf_botones modocambio="#modocambio#" excludearray="#botonesexc#" form="fagtproceso" include="#Aplicar#" tabindex="3" regresar="agtProceso_#botonAccion[IDtrans][1]#.cfm?#params#&AGTPid=#form.AGTPid#">
												<cfelse>
													<cfset Importar = "Importar">
													<cfif IDtrans eq 5>
													 <cf_botones modocambio="#modocambio#" form="fagtproceso" include=",#Aplicar#,Imprimir" tabindex="3" regresar="agtProceso_#botonAccion[IDtrans][1]#.cfm?#params#&AGTPid=#form.AGTPid#">
													<cfelse>
													 <cf_botones modocambio="#modocambio#" form="fagtproceso" include=",#Aplicar#" tabindex="3" regresar="agtProceso_#botonAccion[IDtrans][1]#.cfm?#params#&AGTPid=#form.AGTPid#">
													</cfif>
												</cfif>
										  </cfif>
										</cfif>
										<cfif modocambio>
											<input type="hidden" name = "ts_rversion" value ="#ts#" tabindex="-1">
											<input type="hidden" name ="AGTPid" id="AGTPid" value ="#form.AGTPid#" tabindex="-1">
										</cfif>
									</td>
								  </tr>		
							</table>	
							<br>
							<cfif not mododetcambio>
								<fieldset><legend>Lista de Activos Asociados a Relaci&oacute;n</legend>
									
									<cfset navegacion = "">
									
									<cfif isdefined("form.AGTPid") and len(trim(#form.AGTPid#)) neq 0>
										<cfset navegacion = navegacion & "AGTPid="&form.AGTPid>	
									</cfif>
									
									<cfif isdefined("form.ADTPlinea")and len(trim(form.ADTPlinea))NEQ 0>
										<cfif navegacion NEQ "">
											<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "ADTPlinea="&form.ADTPlinea>
										<cfelse>	
											<cfset navegacion = navegacion & 'ADTPlinea='&form.ADTPlinea>
										</cfif> 
									</cfif>
									
									<cfif isdefined("form.LADTPlinea")and len(trim(form.LADTPlinea))NEQ 0>
										<cfif navegacion NEQ "">
											<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "LADTPlinea="&form.LADTPlinea>
										<cfelse>	
											<cfset navegacion = navegacion & 'LADTPlinea='&form.LADTPlinea>
										</cfif> 
									</cfif>
									<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  params>
									<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
										tabla="
											ADTProceso a
												inner join Activos b on
													a.Aid = b.Aid and 
													a.Ecodigo = b.Ecodigo"
										columnas="
											AGTPid as LAGTPid, ADTPlinea as LADTPlinea, TAmontolocadq as LTAmontolocadq, TAmontolocmej as LTAmontolocmej, 
											TAmontolocrev as LTAmontolocrev, b.Aid as LAid, rtrim(b.Aplaca) as LAplaca, rtrim(b.Adescripcion) as LAdescripcion, 
											TAmontolocadq + TAmontolocmej + TAmontolocrev as LTAmontoloctot"
										desplegar="LAplaca, LAdescripcion, LTAmontolocadq, LTAmontolocmej, LTAmontolocrev, 
											LTAmontoloctot"
										etiquetas="Placa, Descripci&oacute;n, ADQ., MEJ., REV., TOT."
										formatos="S, S, M, M, M, M"
										formname="fagtproceso"
										incluyeform="false"
										filtro="
											a.Ecodigo = #session.ecodigo# and 
											a.AGTPid = #form.AGTPid#"
										align="left, left, right, right, right, right"
										ajustar="N, N, N, N, N, N"
										keys="LADTPlinea"
										ira="agtProceso_genera_#botonAccion[IDtrans][1]##LvarPar#.cfm"
										MaxRows="8"
										filtrar_automatico="true"
										mostrar_filtro="true"
										filtrar_por="Aplaca, Adescripcion, TAmontolocadq, TAmontolocmej, TAmontolocrev, TAmontolocadq + TAmontolocmej + TAmontolocrev"
										navegacion="#navegacion#">
								</fieldset>
							</cfif>
						<cfelse>
 							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<cfset Aplicar = "">										
                                        <cf_botones modocambio="#modocambio#" form="fagtproceso" include="#Aplicar#" tabindex="3"  regresar="agtProceso_#botonAccion[IDtrans][1]##LvarPar#.cfm?#params#">
									</td>
								</tr>
							</table>
						</cfif>
					<td>
			</tr>
			<cfif isdefined("Vsistext") and Vsistext eq 1>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center">
					<font color="##FF0000">El Retiro no puede ser modificado ni eliminado porque proviene de un sistema externo</font>
				</td>
			</tr>
			</cfif>
		</table>
  </tr>
  <tr><td>&nbsp;</td></tr>
</table>
</cfoutput>

<!---funciones en javascript de los demás campos--->
<script language="javascript" type="text/javascript">
<!--//
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
	qFormAPI.errorColor = "#FFFFCC";
	qffagtproceso = new qForm("fagtproceso");
	funcTipoCuenta();
	
	function habilitarValidacion(){
		qffagtproceso.AGTPdescripcion.required = true;
		<cfif IDtrans eq 5>
		qffagtproceso.AFRmotivo.required = true;
		</cfif>
		<cfif modocambio>
			qffagtproceso.Aplaca.required = false;
			<cfif IDtrans eq 8>
			qffagtproceso.Aplacadestino.required = false;
			</cfif>
		</cfif>
	}
	function deshabilitarValidacion(){
		qffagtproceso.AGTPdescripcion.required = false;
		<cfif IDtrans eq 5>
		qffagtproceso.AFRmotivo.required = false;
		</cfif>
		<cfif modocambio>
			qffagtproceso.Aplaca.required = false;
			<cfif IDtrans eq 8>
			qffagtproceso.Aplacadestino.required = false;
			</cfif>
		</cfif>
	}
	function _qfinit(){
		habilitarValidacion();
		<cfoutput>
		qffagtproceso.AGTPdescripcion.description = "#JSStringFormat('Descripción')#";
		<cfif IDtrans eq 5>
		qffagtproceso.AFRmotivo.description = "#JSStringFormat('Motivo')#";
		</cfif>
		</cfoutput>
	}
	<cfif IDtrans eq 5>
	function setDescripcion(){
		<cfoutput query="AFRmotivos">
			if (qffagtproceso.AFRmotivo.getValue()!='' && qffagtproceso.AFRmotivo.getValue()==#AFRmotivos.AFRmotivo#)
				qffagtproceso.AGTPdescripcion.obj.value="#botonAccion[IDtrans][4]# por #AFRmotivos.AFRdescripcion#";
		</cfoutput>
	}
	</cfif>
	<cfif modocambio>
		
		<cfoutput>
		qffagtproceso.Aplaca.description = "#JSStringFormat('Activo')#";
		qffagtproceso.Aplaca.required = true;
		<cfif IDtrans eq 8>
			qffagtproceso.Aplacadestino.description = "#JSStringFormat('Activo Destino')#";
			qffagtproceso.Aplacadestino.required = true;
		</cfif>
		<cfif isdefined("Vsistext") and Vsistext eq 1>
			
			function funcAsociar(){}
			function funcTAmontolocadq(){}
			function funcTAmontolocmej(){}
			function funcTAmontolocrev(){}
			function funcPRCmontolocadq(){}
			function funcPRCmontolocmej(){}
			function funcPRCmontolocrev(){}
			function funcTAmontodepadq(){}
			function funcTAmontodepmej(){}	
			function funcTAmontodeprev(){}
					
		<cfelse>
			<cfif mododetcambio>
			newvalue_TAmontolocadq = parseFloat(convertIt(document.fagtproceso.TOT_TAmontolocadq.value));
			newvalue_TAmontolocmej = parseFloat(convertIt(document.fagtproceso.TOT_TAmontolocmej.value));
			newvalue_TAmontolocrev = parseFloat(convertIt(document.fagtproceso.TOT_TAmontolocrev.value));
			
			</cfif>
			<cfif mododetcambio and isdefined("CountActivoOrigen") and CountActivoOrigen.total GT 1>
			function funcTOT_Saldos(){
				newvalue_TAmontoloctot = Math.round((newvalue_TAmontolocadq + newvalue_TAmontolocmej + newvalue_TAmontolocrev)*100)/100;
				document.getElementById('TOT_TAmontoloctot_TXT').innerHTML=newvalue_TAmontoloctot;				
			}
			</cfif>
			function funcAsociar(){
				<cfif modocambio>
					qffagtproceso.Aplaca.required = true;
					<cfif IDtrans eq 8>
					qffagtproceso.Aplacadestino.required = true;
					</cfif>
				</cfif>
			}
			function funcTAmontolocadq(){
			if (parseFloat(qf(qffagtproceso.TAmontolocadq.getValue())) > parseFloat(qf(qffagtproceso.HTAmontolocadq.getValue()))) 
			{
			  qffagtproceso.TAmontolocadq.obj.value = fm(qf(qffagtproceso.HTAmontolocadq.getValue()),8);
			}
			
			 qffagtproceso.TAmontoloctot.obj.value = fm( parseFloat(qf(qffagtproceso.TAmontolocadq.getValue()))+
			                                              parseFloat(qf(qffagtproceso.TAmontolocmej.getValue()))+
														  parseFloat(qf(qffagtproceso.TAmontolocrev.getValue())) ,8);
			   if (parseFloat(qf(qffagtproceso.HTAmontolocadq.getValue()))>0.00)
			       qffagtproceso.PRCmontolocadq.obj.value = fm(parseFloat(qf(qffagtproceso.TAmontolocadq.getValue())) * 100 / 
				                                               parseFloat(qf(qffagtproceso.HTAmontolocadq.getValue()))
															   ,8);
				 else qffagtproceso.PRCmontoloctot.obj.value = 0.00;
				 
				 if (parseFloat(qf(qffagtproceso.HTAmontoloctot.getValue())) > 0.00)
				 
				  qffagtproceso.PRCmontoloctot.obj.value=fm(parseFloat(qf(qffagtproceso.TAmontoloctot.getValue()))*100/
				                                            parseFloat(qf(qffagtproceso.HTAmontoloctot.getValue())),8); 
				else qffagtproceso.PRCmontoloctot.obj.value=0.00;
				
				<cfif mododetcambio and isdefined("CountActivoOrigen") and CountActivoOrigen.total GT 1>
				//Manejo de Saldos Disponibles
				ORIG_TAmontolocadq = parseFloat(convertIt(document.fagtproceso.ORIG_TAmontolocadq.value));
				TAmontolocadq = parseFloat(convertIt(document.fagtproceso.TAmontolocadq.value));
				TOT_TAmontolocadq = parseFloat(convertIt(document.fagtproceso.TOT_TAmontolocadq.value));
				newvalue_TAmontolocadq = Math.round(((ORIG_TAmontolocadq-TAmontolocadq)+TOT_TAmontolocadq)*100)/100;
				document.getElementById('TOT_TAmontolocadq_TXT').innerHTML=newvalue_TAmontolocadq;
				funcTOT_Saldos();
				//Manejo de Saldos Disponibles
				</cfif>
				qffagtproceso.TAmontodepadq.value = fm(parseFloat(qf(qffagtproceso.TAmontodepadq.getValue())) + parseFloat(qf(qffagtproceso.TAmontodepmej.getValue())) + parseFloat(qf(qffagtproceso.TAmontodeprev.getValue())),2);
				funcTAmontodepadq();
			}
			function funcTAmontolocmej(){if (parseFloat(qf(qffagtproceso.TAmontolocmej.getValue())) > parseFloat(qf(qffagtproceso.HTAmontolocmej.getValue()))) {qffagtproceso.TAmontolocmej.obj.value = fm(qf(qffagtproceso.HTAmontolocmej.getValue()),8);} qffagtproceso.TAmontoloctot.obj.value = fm( parseFloat(qf(qffagtproceso.TAmontolocadq.getValue()))+parseFloat(qf(qffagtproceso.TAmontolocmej.getValue()))+parseFloat(qf(qffagtproceso.TAmontolocrev.getValue())) ,8); if (parseFloat(qf(qffagtproceso.HTAmontolocmej.getValue()))>0.00) qffagtproceso.PRCmontolocmej.obj.value = fm(parseFloat(qf(qffagtproceso.TAmontolocmej.getValue())) * 100 / parseFloat(qf(qffagtproceso.HTAmontolocmej.getValue())),8); else qffagtproceso.PRCmontoloctot.obj.value = 0.00; if (parseFloat(qf(qffagtproceso.HTAmontoloctot.getValue())) > 0.00) qffagtproceso.PRCmontoloctot.obj.value=fm(parseFloat(qf(qffagtproceso.TAmontoloctot.getValue()))*100/parseFloat(qf(qffagtproceso.HTAmontoloctot.getValue())),8); else qffagtproceso.PRCmontoloctot.obj.value=0.00;
				<cfif mododetcambio and isdefined("CountActivoOrigen") and CountActivoOrigen.total GT 1>
				//Manejo de Saldos Disponibles
				ORIG_TAmontolocmej = parseFloat(convertIt(document.fagtproceso.ORIG_TAmontolocmej.value));
				TAmontolocmej = parseFloat(convertIt(document.fagtproceso.TAmontolocmej.value));
				TOT_TAmontolocmej = parseFloat(convertIt(document.fagtproceso.TOT_TAmontolocmej.value));
				newvalue_TAmontolocmej = Math.round(((ORIG_TAmontolocmej-TAmontolocmej)+TOT_TAmontolocmej)*100)/100;
				document.getElementById('TOT_TAmontolocmej_TXT').innerHTML=newvalue_TAmontolocmej;
				funcTOT_Saldos();
				//Manejo de Saldos Disponibles
				</cfif>
				funcTAmontodepmej();
			}
			function funcTAmontolocrev(){
	        var Validar = 0;	

			if (Math.abs(qf(qffagtproceso.TAmontolocrev.getValue())) > Math.abs(qffagtproceso.HTAmontolocrev.getValue())) 
			{
				qffagtproceso.TAmontolocrev.obj.value = fm(qf(qffagtproceso.HTAmontolocrev.getValue()),8);
				Validar = 1;
			} 
			if (qf(qffagtproceso.TAmontolocrev.obj.value) > 0 && Validar == 0)
			{
				var VarSigno = (Math.abs(qffagtproceso.HTAmontolocrev.getValue()) / qf(qffagtproceso.HTAmontolocrev.getValue()));
				qffagtproceso.TAmontolocrev.obj.value = fm(qf(qffagtproceso.TAmontolocrev.getValue())* VarSigno,2) ;
			}
			   		   
			    qffagtproceso.TAmontoloctot.obj.value = 
				                                       fm( parseFloat(qf(qffagtproceso.TAmontolocadq.getValue()))+
													       parseFloat(qf(qffagtproceso.TAmontolocmej.getValue()))+
														   parseFloat(qf(qffagtproceso.TAmontolocrev.getValue())) ,8); 
				  if (Math.abs(qffagtproceso.HTAmontolocrev.getValue())>0.00) 
				  {         qffagtproceso.PRCmontolocrev.obj.value = 
						                           fm(parseFloat(qf(qffagtproceso.TAmontolocrev.getValue())) * 100 /
												      parseFloat(qf(qffagtproceso.HTAmontolocrev.getValue()))
													  ,8); 
		          }
				  else
				  {
				   qffagtproceso.PRCmontoloctot.obj.value = 0.00;
				  }
				  
				 /* alert(qffagtproceso.PRCmontolocrev.obj.value);*/
				  if (parseFloat(qf(qffagtproceso.HTAmontoloctot.getValue())) > 0.00)
				  {
				   qffagtproceso.PRCmontoloctot.obj.value=
				                                          fm(parseFloat(qf(qffagtproceso.TAmontoloctot.getValue()))*100/
														   parseFloat(qf(qffagtproceso.HTAmontoloctot.getValue())),8);													   
			      }
				   else qffagtproceso.PRCmontoloctot.obj.value=0.00;
				   
				<cfif mododetcambio and isdefined("CountActivoOrigen") and CountActivoOrigen.total GT 1>
				//Manejo de Saldos Disponibles
				ORIG_TAmontolocrev = parseFloat(convertIt(document.fagtproceso.ORIG_TAmontolocrev.value));
				TAmontolocrev = parseFloat(convertIt(document.fagtproceso.TAmontolocrev.value));
				TOT_TAmontolocrev = parseFloat(convertIt(document.fagtproceso.TOT_TAmontolocrev.value));
				newvalue_TAmontolocrev = Math.round(((ORIG_TAmontolocrev-TAmontolocrev)+TOT_TAmontolocrev)*100)/100;
				document.getElementById('TOT_TAmontolocrev_TXT').innerHTML=newvalue_TAmontolocrev;
				funcTOT_Saldos();
				//Manejo de Saldos Disponibles
				</cfif>
				funcTAmontodeprev();
			}
			function funcPRCmontolocadq(){
			if (parseFloat(qf(qffagtproceso.PRCmontolocadq.getValue())) > 100.00){qffagtproceso.PRCmontolocadq.obj.value="100.00"} 
			qffagtproceso.TAmontolocadq.obj.value = fm(parseFloat(qf(qffagtproceso.HTAmontolocadq.getValue()))*parseFloat(qf(qffagtproceso.PRCmontolocadq.getValue()))/100,2);
			/*alert(qffagtproceso.TAmontolocadq.obj.value);*/
			funcTAmontolocadq();if (parseFloat(qf(qffagtproceso.HTAmontoloctot.getValue())) > 0.00) qffagtproceso.PRCmontoloctot.obj.value=fm(parseFloat(qf(qffagtproceso.TAmontoloctot.getValue()))*100/parseFloat(qf(qffagtproceso.HTAmontoloctot.getValue())),2); else qffagtproceso.PRCmontoloctot.obj.value=0.00;
				funcTAmontodepadq();
			}
			function funcPRCmontolocmej(){if (parseFloat(qf(qffagtproceso.PRCmontolocmej.getValue())) > 100.00){qffagtproceso.PRCmontolocmej.obj.value="100.00"} qffagtproceso.TAmontolocmej.obj.value = fm(parseFloat(qf(qffagtproceso.HTAmontolocmej.getValue()))*parseFloat(qf(qffagtproceso.PRCmontolocmej.getValue()))/100,2);funcTAmontolocmej();if (parseFloat(qf(qffagtproceso.HTAmontoloctot.getValue())) > 0.00) qffagtproceso.PRCmontoloctot.obj.value=fm(parseFloat(qf(qffagtproceso.TAmontoloctot.getValue()))*100/parseFloat(qf(qffagtproceso.HTAmontoloctot.getValue())),2); else qffagtproceso.PRCmontoloctot.obj.value=0.00;
				funcTAmontodepmej();
			}
			function funcPRCmontolocrev(){
			
			  
			if (parseFloat(qf(qffagtproceso.PRCmontolocrev.getValue())) > 100.00)
			  {
			      qffagtproceso.PRCmontolocrev.obj.value="100.00"
			  }
			  
			   qffagtproceso.TAmontolocrev.obj.value = fm(parseFloat(qf(qffagtproceso.HTAmontolocrev.getValue()))* parseFloat(qf(qffagtproceso.PRCmontolocrev.getValue()))/100,2);
			 
			   funcTAmontolocrev();
			   if (Math.abs(qffagtproceso.HTAmontoloctot.getValue()) > 0.00){
			     qffagtproceso.PRCmontoloctot.obj.value= fm(parseFloat(qf(qffagtproceso.TAmontoloctot.getValue()))*100/
				                                            parseFloat(qf(qffagtproceso.HTAmontoloctot.getValue())),2); 											
				}
				else
				{
				  qffagtproceso.PRCmontoloctot.obj.value=0.00;
				}
				funcTAmontodeprev();
			}
			function funcTAmontodepadq(){
				if(parseFloat(qf(qffagtproceso.HTAmontolocadq.getValue())) > 0.00){
					qffagtproceso.TAmontodepadq.obj.value = fm( parseFloat(qf(qffagtproceso.TAmontolocadq.getValue())) * parseFloat(qf(qffagtproceso.HTAmontodepadq.getValue())) / parseFloat(qf(qffagtproceso.HTAmontolocadq.getValue())) ,2);
				}
				else{
					qffagtproceso.TAmontodepadq.obj.value = "0.00";
				}
				qffagtproceso.TAmontodeptot.obj.value = fm(parseFloat(qf(qffagtproceso.TAmontodepadq.getValue())) + parseFloat(qf(qffagtproceso.TAmontodepmej.getValue())) + parseFloat(qf(qffagtproceso.TAmontodeprev.getValue())),2);
			}
			function funcTAmontodepmej(){
				if(parseFloat(qf(qffagtproceso.HTAmontolocmej.getValue())) > 0.00){
					qffagtproceso.TAmontodepmej.obj.value = fm( parseFloat(qf(qffagtproceso.TAmontolocmej.getValue())) * parseFloat(qf(qffagtproceso.HTAmontodepmej.getValue())) / parseFloat(qf(qffagtproceso.HTAmontolocmej.getValue())) ,2);
				}
				else{
					qffagtproceso.TAmontodepmej.obj.value = "0.00";
				}
				qffagtproceso.TAmontodeptot.obj.value = fm(parseFloat(qf(qffagtproceso.TAmontodepadq.getValue())) + parseFloat(qf(qffagtproceso.TAmontodepmej.getValue())) + parseFloat(qf(qffagtproceso.TAmontodeprev.getValue())),2);
			}	
			function funcTAmontodeprev(){
				if(parseFloat(qf(qffagtproceso.HTAmontolocrev.getValue())) > 0.00){
					qffagtproceso.TAmontodeprev.obj.value = fm( parseFloat(qf(qffagtproceso.TAmontolocrev.getValue())) * parseFloat(qf(qffagtproceso.HTAmontodeprev.getValue())) / parseFloat(qf(qffagtproceso.HTAmontolocrev.getValue())) ,2);
				}
				else{
					qffagtproceso.TAmontodeprev.obj.value = "0.00";
				}
				qffagtproceso.TAmontodeptot.obj.value = fm(parseFloat(qf(qffagtproceso.TAmontodepadq.getValue())) + parseFloat(qf(qffagtproceso.TAmontodepmej.getValue())) + parseFloat(qf(qffagtproceso.TAmontodeprev.getValue())),2);
			}
			
		</cfif>
		</cfoutput>
	</cfif>
	function convertIt(_a) {
	  var _c = _a;
	  var _x = _a.indexOf("$");
	  if (_x == -1 ) _x = _a.indexOf(",");
	  if (_x != -1) {
		var _p1 = _a.substr(0,_x);
		var _p2 = _a.substr(_x+1,_a.length);
		_c = convertIt(_p1+_p2);
	  }
	  return (_c);
	}
	<cfif mododetcambio>
	function funcCambioDet(){
		document.fagtproceso.TOT_TAmontolocadq.value = newvalue_TAmontolocadq;
		document.fagtproceso.TOT_TAmontolocmej.value = newvalue_TAmontolocmej;
		document.fagtproceso.TOT_TAmontolocrev.value = newvalue_TAmontolocrev;

		if ((parseFloat(document.fagtproceso.TOT_TAmontolocadq.value) >= 0)
		&& (parseFloat(document.fagtproceso.TOT_TAmontolocmej.value) >= 0)
		&& (parseFloat(Math.abs(document.fagtproceso.TOT_TAmontolocrev.value)) >= 0))
		{
			return true;
		}
		else {
			alert('Alguno de los Montos se excede de los Saldos Disponibles !');
			return false;
		}
	}
	</cfif>
	function funcTAmontolocventa(){
		document.fagtproceso.TAtotallocventa.value = fm(parseFloat(qf(document.fagtproceso.TAmontolocventa.value)) + (parseFloat(qf(document.fagtproceso.TAmontolocventa.value)) * parseFloat(qf(document.fagtproceso.Icodigo.value.split('|')[1])) / 100.00),2);
	}
	function funcTipoCuenta(){
		if (document.getElementById('TipoCuentaR').value == 0) {
			document.getElementById('DatosSocio').style.display='none';
		}
		else {
			document.getElementById('DatosSocio').style.display='';
		}
	}
	function funcAplicar(){
		return confirm("¿Desea aplicar la Transacción?");
	}
	function funcLimpiarAplacadestino(Aiddestino){
		if (Aiddestino.length==0){
			qffagtproceso.Aiddestino.obj.value="";
			qffagtproceso.Adescripciondestino.obj.value="";
		}
	}
	function _forminit(){
		var form = document.fagtproceso;
		_qfinit()
		<cfif IDtrans eq 5>
		setDescripcion();
		</cfif>
		<cfif modocambio>
		qffagtproceso.Aplaca.obj.focus();
		<cfelse>
		qffagtproceso.AGTPdescripcion.obj.focus();
		</cfif>
		<cfif mododetcambio and tipodetventa>
			form.TAmontolocventa.focus();
		<cfelseif mododetcambio>
			form.PRCmontolocadq.focus();
		</cfif>
	}
	_forminit();
//-->
	<cfif mododetcambio>
	funcPRCmontolocadq();
	funcPRCmontolocmej();
	funcPRCmontolocrev();
	</cfif>
	
		var popUpWinSN=0;
		function popUpWindow(URLStr, left, top, width, height){
			if(popUpWinSN) {
				if(!popUpWinSN.closed) popUpWinSN.close();
			}
			popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			window.onfocus = closePopUp;
		}
		
		function funcImprimir(){
			var LvarAGTPid= document.fagtproceso.AGTPid.value;
			<cfoutput>
			popUpWindow("/cfmx/sif/af/operacion/Retiro_Activos_Fijos-rpt.cfm?AGTPid="+LvarAGTPid,150,150,800,500);
			</cfoutput>
		}
		
		function closePopUp(){
			if(popUpWinSN) {
				if(!popUpWinSN.closed) popUpWinSN.close();
				popUpWinSN=null;
			}
		}
</script>