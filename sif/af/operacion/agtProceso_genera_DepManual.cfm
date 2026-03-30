<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = '_JA'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = '_Aux'>
</cfif>
<!--- Definiciones iniciales de la pantalla --->
<cfif isdefined("url.AGTPid") and len(trim(url.AGTPid))><cfset form.AGTPid = url.AGTPid></cfif>
<cfif isdefined("url.ADTPlinea") and len(trim(url.ADTPlinea))><cfset form.ADTPlinea = url.ADTPlinea></cfif>
<cfif isdefined("form.LADTPlinea") and len(trim(form.LADTPlinea))><cfset form.ADTPlinea = form.LADTPlinea></cfif>
<!--- Comportamientos de  de la pantalla --->
<cfif isdefined('form.params')>
	<cfset params = form.params>
</cfif>
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
			a.ts_rversion, 
			a.Usucodigo, 
			a.AGTPfalta,
			<cf_dbfunction name="concat" args="c.Pnombre,' ',c.Papellido1, ' ',c.Papellido2"> as nombre
		from AGTProceso a		
			inner join Usuario b on a.Usucodigo = b.Usucodigo
			inner join DatosPersonales c on b.datos_personales = c.datos_personales			
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  and a.AGTPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
	</cfquery>

	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp= "#rsAGTProceso.ts_rversion#" returnvariable="ts"/>

	<cfif mododetcambio>
		<cfquery name="rsADTProceso" datasource="#session.dsn#">
			select ADTPlinea, 
					c.Aid, 
					c.Aplaca, 
					c.Adescripcion, 
					ADTPrazon, 
					a.ts_rversion, 
					a.Aiddestino, 
					coalesce(e.Aplaca,a.Aplacadestino) as Aplacadestino, 
					e.Adescripcion as Adescripciondestino, 
					
					AFSvaladq, 			
					AFSvalmej, 			
					AFSvalrev, 			
					(AFSvaladq + AFSvalmej + AFSvalrev) as AFSvaltot,
					
					AFSdepacumadq, 	
					AFSdepacummej, 	
					AFSdepacumrev, 						
					(AFSdepacumadq + AFSdepacummej + AFSdepacumrev) as AFSdepacumtot,
					
					(AFSvaladq - AFSdepacumadq) as AFSsaldoadq,
					(AFSvalmej - AFSdepacummej) as AFSsaldomej,
					(AFSvalrev - AFSdepacumrev) as AFSsaldorev,
				
					TAmontodepadq,
					TAmontodepmej,
					TAmontodeprev,
					(TAmontodepadq + TAmontodepmej + TAmontodeprev) as TAmontodeptot,
					
					((AFSvaladq + AFSvalmej + AFSvalrev) - (AFSdepacumadq + AFSdepacummej + AFSdepacumrev)) as AFSsaldotot,
					
					TAmontolocadq, 	
					TAmontolocmej, 	
					TAmontolocrev, 	
					(TAmontolocadq + TAmontolocmej + TAmontolocrev) as TAmontoloctot,
					
					TAmontolocventa, 
					Icodigo, 
					case when Icodigo is not null then 
						TAmontolocventa + round(coalesce((	select Iporcentaje 
															from Impuestos 
															where Ecodigo = a.Ecodigo 
															  and  Icodigo = a.Icodigo ),0.00)* coalesce(TAmontolocventa,0.00)/100.00,2)  
					else 
						0.00 
					end as TAtotallocventa 
					
			from ADTProceso a 
				inner join AGTProceso b 
						on a.AGTPid = b.AGTPid 
						and a.Ecodigo = b.Ecodigo
				inner join Activos c 
						on a.Aid = c.Aid 
						and a.Ecodigo = c.Ecodigo
				inner join AFSaldos d 
						on a.Aid = d.Aid 
						and a.Ecodigo = d.Ecodigo 
						and d.AFSperiodo = b.AGTPperiodo 
						and d.AFSmes = b.AGTPmes
				left outer join Activos e 
						on a.Aiddestino = e.Aid 
						and a.Ecodigo = e.Ecodigo
			where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
			  and a.AGTPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
			  and a.ADTPlinea 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ADTPlinea#">
		</cfquery>
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp= "#rsADTProceso.ts_rversion#" returnvariable="tsdet"/>
	</cfif>
</cfif>
<!---Incluye API de Qforms--->


<cf_templateheader title="Activos Fijos">
  <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Inclusi&oacute;n de Transacciones de Depreciaci&oacute;n Manual">

<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>

<form name="fagtproceso" action="agtProceso_sql_DepManual<cfoutput>#LvarPar#</cfoutput>.cfm" method="post">


<cfoutput>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
<cfif not isdefined("params")><cfset params = ""></cfif>
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
											<input name="AGTPdescripcion" type="text" size="60" maxlength="80" tabindex="1">
										</td>
									</tr>									
								</table>
							</fieldset>
						<cfelse>
							<fieldset><legend>Relaci&oacute;n de Depreciacin Manual</legend>
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
										<td align="left">#DateFormat(rsAGTProceso.AGTPfalta,"dd/mm/yyyy")#</td>
									</cfsavecontent>
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
												<cf_botones values="Asociar" tabindex="2">
                                            </cfif>
										</td>
										</cfif>
									</tr>
								</table>
							</fieldset>
							<br>
							
							<cfif mododetcambio>
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
														<td align="right"><strong>DEPRECIACION&nbsp;:&nbsp;</strong></td>
														<td align="right"><cfif mododetcambio><input type="hidden" name="HTAmontolocadq" id="HTAmontolocadq" value="#rsADTProceso.TAmontolocadq#" disabled tabindex="-1"><cf_monto name="TAmontolocadq" form="fagtproceso" query="#rsADTProceso#" modificable="true" tabindex="3" negativos="true" onChange="javascript:VerMnts(1);"><cfelse><cf_monto name="TAmontolocadq" form="fagtproceso" modificable="false" tabindex="3"></cfif></td>
														<td align="right"><cfif mododetcambio><input type="hidden" name="HTAmontolocmej" id="HTAmontolocmej" value="#rsADTProceso.TAmontolocmej#" disabled tabindex="-1"><cf_monto name="TAmontolocmej" form="fagtproceso" query="#rsADTProceso#" modificable="true" tabindex="3" negativos="true" onChange="javascript:VerMnts(2);"><cfelse><cf_monto name="TAmontolocmej" form="fagtproceso" modificable="false" tabindex="3"> </cfif></td>
														<td align="right"><cfif mododetcambio><input type="hidden" name="HTAmontolocrev" id="HTAmontolocrev" value="#rsADTProceso.TAmontolocrev#" disabled tabindex="-1"><cf_monto name="TAmontolocrev" form="fagtproceso" query="#rsADTProceso#" modificable="true" tabindex="3" negativos="true" onChange="javascript:VerMnts(3);"><cfelse><cf_monto name="TAmontolocrev" form="fagtproceso" modificable="false" tabindex="3"></cfif></td>
														<td align="right">&nbsp;</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
									<br>
									* Montos positivos no pueden exceder el valor actual en libros<br>
									* Montos negativos no pueden exceder la depreciaci&oacute;n acumulada<br>
									* Montos negativos solo pueden aplicarse a activos con saldos de vida &uacute;til<br>
								</fieldset>
								<cfset params = params& '&AGTPid=#form.AGTPid#'>
							</cfif>							
			
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">	
										
										<cfif modocambio>
											<!---<cfset Aplicar = "Aplicar,Ver_Reporte">--->
											<cfset Aplicar = "Ver_Reporte">
										<cfelse>
											<cfset Aplicar = "">
										</cfif>
										<cfif mododetcambio>											
											<cfif isdefined("session.LvarJA") and session.LvarJA>
                                            	<cfset botonesex[1] = "CambioDet">
                                                <cfset botonesex[2] = "BajaDet">
                                                <cfset botonesex[3] = "Baja">
                                                <cfset botonesex[4] = "NuevoDet">
												<cf_botones modocambio="#modocambio#" mododet="CAMBIO" excludearray="#botonesex#" form="fagtproceso" tabindex="3"  regresar="agtProceso_genera_DepManual#LvarPar#.cfm?#params#" nameenc="Grupo" genero="M" include="#Aplicar#" exclude="Cambio">
                                            <cfelseif isdefined("session.LvarJA") and not session.LvarJA>
                                                <cf_botones modocambio="#modocambio#" mododet="CAMBIO" form="fagtproceso" tabindex="3"  regresar="agtProceso_genera_DepManual#LvarPar#.cfm?#params#" nameenc="Grupo" genero="M" include="Importar" exclude="Cambio">
											<cfelse>
												<cf_botones modocambio="#modocambio#" mododet="CAMBIO" form="fagtproceso" tabindex="3"  regresar="agtProceso_genera_DepManual.cfm?#params#"	nameenc="Grupo" genero="M" include="Importar,#Aplicar#" exclude="Cambio">
                                            </cfif>
											<input type="hidden" name = "ts_rversiondet" value ="#tsdet#" tabindex="-1">
											<input type="hidden" name = "ADTPlinea" value ="#form.ADTPlinea#" tabindex="-1">
										<cfelse>
                                        	<cfif isdefined("session.LvarJA") and session.LvarJA>
                                            	<cfset botonesex[1] = "Cambio">
                                                <cfset botonesex[2] = "BajaDet">
                                                <cfset botonesex[3] = "Baja">
                                                <cfset botonesex[4] = "Nuevo">
                                                <cfset botonesex[5] = "NuevoDet">
                                                <cfset botonesex[6] = "Importar">

                                                <cf_botones modocambio="#modocambio#" excludearray="#botonesex#" form="fagtproceso" include="#Aplicar#" tabindex="3" regresar="agtProceso_DEPRECIACION#LvarPar#.cfm?#params#" exclude="Cambio">
                                            <cfelseif isdefined("session.LvarJA") and not session.LvarJA>
                                                <cf_botones modocambio="#modocambio#" form="fagtproceso" include="Importar" tabindex="3" regresar="agtProceso_DEPRECIACION#LvarPar#.cfm?#params#" exclude="Cambio">
											<cfelse>
												<cf_botones modocambio="#modocambio#" form="fagtproceso" include="Importar,#Aplicar#" tabindex="3" regresar="agtProceso_DEPRECIACION.cfm?#params#" exclude="Cambio">
                                            </cfif>
										</cfif>
										<cfif modocambio>
											<input type="hidden" name = "ts_rversion" value ="#ts#" tabindex="-1">
											<input type="hidden" name = "AGTPid" value ="#form.AGTPid#" tabindex="-1">
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
										ira="agtProceso_genera_DepManual#LvarPar#.cfm"
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
										<cf_botones modocambio="#modocambio#" form="fagtproceso" include="#Aplicar#" tabindex="3"  regresar="agtProceso_DEPRECIACION#LvarPar#.cfm?#params#">
									</td>
								</tr>
							</table>
						</cfif>
					<td>
			</tr>
			
		</table>
  </tr>
  <tr><td>&nbsp;</td></tr>
</table>
</cfoutput>

</form>

	<cf_web_portlet_end>
<cf_templatefooter>

<!---funciones en javascript de los dems campos--->
<script language="javascript" type="text/javascript">
<!--//
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
	qFormAPI.errorColor = "#FFFFCC";
	qffagtproceso = new qForm("fagtproceso");

	function habilitarValidacion(){
		qffagtproceso.AGTPdescripcion.required = true;
		<cfif modocambio>
			qffagtproceso.Aplaca.required = false;
		</cfif>
	}
	function deshabilitarValidacion(){
		qffagtproceso.AGTPdescripcion.required = false;
		<cfif modocambio>
			qffagtproceso.Aplaca.required = false;
		</cfif>
	}
	function _qfinit(){
		habilitarValidacion();
		<cfoutput>
		qffagtproceso.AGTPdescripcion.description = "#JSStringFormat('Descripcin')#";
		</cfoutput>
	}
	function setDescripcion(){
		qffagtproceso.AGTPdescripcion.obj.value="";		
	}

	<cfif modocambio>
		
		<cfoutput>
		qffagtproceso.Aplaca.description = "#JSStringFormat('Activo')#";
		qffagtproceso.Aplaca.required = true;

		function funcAsociar(){
			<cfif modocambio>
				qffagtproceso.Aplaca.required = true;
			</cfif>
			if (qffagtproceso.Aplaca == '')
			{
				alert('Advertencia: Es necesario digitar o elegir una placa válida');
				return false;
			}	
		}
		</cfoutput>
	</cfif>
	function VerMnts(ban){
		
		MntAdq = qf(document.fagtproceso.TAmontolocadq.value);
		MntMej = qf(document.fagtproceso.TAmontolocmej.value);
		MntRev = qf(document.fagtproceso.TAmontolocrev.value);
		error  = 0;
		
		
		if (ban == 1){
			//verifica mejora y revaluacion
			if (MntAdq != 0){
				if (MntAdq > 0){
					//en caso de la adquisicion ser positiva el resto debe ser positivo
					if (MntMej < 0 || MntRev < 0)
						error=1;
				}		
				else
				{
					if (MntMej > 0 || MntRev > 0)
						error=1;			
				}
			}	
		}	
		if (ban == 2){
			//verifica adquisicion y revaluacion			
			if (MntMej != 0){
				if (MntMej > 0){
					//en caso de la adquisicion ser positiva el resto debe ser positivo
					if (MntAdq < 0 || MntRev < 0)
						error=1;
				}		
				else
				{
					if (MntAdq > 0 || MntRev > 0)
						error=1;			
				}
			}				
		}
		if (ban == 3){
			//verifica adquisicion y mejora
			if (MntRev != 0){
				if (MntRev > 0){
					//en caso de la adquisicion ser positiva el resto debe ser positivo
					if (MntMej < 0 || MntAdq < 0)
						error=1;
				}		
				else
				{
					if (MntMej > 0 || MntAdq > 0)
						error=1;			
				}
			}	
		}

		/*if (error == 1){
			switch (ban){
			case 1:
				document.fagtproceso.TAmontolocadq.value = "0.00";
				break;
			case 2:
				document.fagtproceso.TAmontolocmej.value = "0.00";
				break;
			case 3:
				document.fagtproceso.TAmontolocrev.value = "0.00";
				break;
			}
			alert("Todos los montos deben ser de un mismo signo.")
		}*/
		}
	function funcAplicar(){
		return confirm("Desea aplicar la Transacción?");
	}
	function funcVer_Reporte()
	{
		document.fagtproceso.action = "agtProceso_detalles_DepManual<cfoutput>#LvarPar#</cfoutput>.cfm?DepMnl=1&AGTPid=<cfif modocambio><cfoutput>#form.AGTPid#</cfoutput><cfelse>-1</cfif>";
		return true;
	}
	function _forminit(){
		var form = document.fagtproceso;
		_qfinit()
		//setDescripcion();
		<cfif modocambio>
		qffagtproceso.Aplaca.obj.focus();
		<cfelse>
		qffagtproceso.AGTPdescripcion.obj.focus();
		</cfif>
		
		<cfif mododetcambio>
			form.TAmontolocadq.focus();
		</cfif>
	}
	_forminit();
//-->
</script>
