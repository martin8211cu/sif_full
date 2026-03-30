<!--- Modificado el 29/03/2006 para permitir cero en vida útil y cambiar las etiquetas de vida útil y monto. DAG --->
<!--- Definiciones iniciales de la pantalla --->










<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = '_JA'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = '_Aux'>
</cfif>

<cfif isdefined("url.AGTPid") and len(trim(url.AGTPid))><cfset form.AGTPid = url.AGTPid></cfif>
<cfif isdefined("url.ADTPlinea") and len(trim(url.ADTPlinea))><cfset form.ADTPlinea = url.ADTPlinea></cfif>
<cfif isdefined("form.LADTPlinea") and len(trim(form.LADTPlinea))><cfset form.ADTPlinea = form.LADTPlinea></cfif>
<cfif isdefined("form.AGTPid") and len(trim(form.AGTPid))>
	<cfset modocambio = true>
<cfelse>
	<cfset modocambio = false>
</cfif>
<cfif isdefined("form.ADTPlinea") and len(trim(form.ADTPlinea))>
	<cfset mododetcambio = true>
	<cfset form.LADTPlinea = form.ADTPlinea>
<cfelse>
	<cfset mododetcambio = false>
</cfif>
<cfif isdefined('form.params')>
	<cfset params = form.params>
</cfif>
<cfif modocambio>
	<cfquery name="rsAGTProceso" datasource="#session.dsn#">
		select
			a.AGTPid,
			a.AGTPdescripcion,
			a.AFRmotivo,
			a.AGTPrazon,
			a.ts_rversion,
			a.AGTPfalta,
			<cf_dbfunction name="concat" args="c.Pnombre,' ', c.Papellido1,' ',c.Papellido2"> as nombre
		from AGTProceso a
			inner join Usuario b on a.Usucodigo = b.Usucodigo
			inner join DatosPersonales c on b.datos_personales = c.datos_personales					
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  and a.AGTPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
	</cfquery>
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp= "#rsAGTProceso.ts_rversion#" returnvariable="ts"/>
	<cfif mododetcambio>
		<cfquery name="rsADTProceso" datasource="#session.dsn#">
		select  ADTPlinea, c.Aid, c.Aplaca, c.Adescripcion, ADTPrazon, 
				a.ts_rversion, AFSvaladq, AFSvalmej, AFSvalrev, 			
				AFSvaladq + AFSvalmej+ AFSvalrev as AFSvaltot,
				AFSdepacumadq, 	AFSdepacummej, 	AFSdepacumrev, 	
				AFSdepacumadq + AFSdepacummej + AFSdepacumrev as AFSdepacumtot,
				AFSvaladq - AFSdepacumadq as AFSsaldoadq,
				AFSvalmej - AFSdepacummej as AFSsaldomej,
				AFSvalrev - AFSdepacumrev as AFSsaldorev,
				case when (AFSvaladq - AFSdepacumadq) > 0.00 then TAmontolocadq * 100 / (AFSvaladq - AFSdepacumadq) else 0.00 end as PRCmontolocadq,
				case when (AFSvalmej - AFSdepacummej) > 0.00 then TAmontolocmej * 100 / (AFSvalmej - AFSdepacummej) else 0.00 end as PRCmontolocmej,
				case when (AFSvalrev - AFSdepacumrev) > 0.00 then TAmontolocrev * 100 / (AFSvalrev - AFSdepacumrev) else 0.00 end as PRCmontolocrev,
				case when ((AFSvaladq + AFSvalmej + AFSvalrev) - (AFSdepacumadq + AFSdepacummej + AFSdepacumrev)) > 0.00 
					then (TAmontolocadq + TAmontolocmej + TAmontolocrev) * 100 / ((AFSvaladq + AFSvalmej+ AFSvalrev) - (AFSdepacumadq + AFSdepacummej + AFSdepacumrev)) 
					else 0.00 end as PRCmontoloctot,
				(AFSvaladq + AFSvalmej + AFSvalrev) - (AFSdepacumadq + AFSdepacummej + AFSdepacumrev) as AFSsaldotot,				
				TAmontolocadq, 	TAmontolocmej, 	TAmontolocrev, 	TAmontolocadq + TAmontolocmej + TAmontolocrev as TAmontoloctot,
				TAvutil, AFSvutiladq,AFSsaldovutiladq 
			from ADTProceso a 
				inner join AGTProceso b on a.AGTPid = b.AGTPid and a.Ecodigo = b.Ecodigo
				inner join Activos c on a.Aid = c.Aid and a.Ecodigo = c.Ecodigo
				inner join AFSaldos d on a.Aid = d.Aid and a.Ecodigo = d.Ecodigo and d.AFSperiodo = b.AGTPperiodo and d.AFSmes = b.AGTPmes
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
			and a.AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
			and a.ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ADTPlinea#">
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
											<input name="AGTPdescripcion" type="text" size="60" maxlength="80" <cfif modocambio>value="#rsAGTProceso.AGTPdescripcion#"</cfif>>
										</td>
									</tr>
									<tr>
										<td><strong>Justificaci&oacute;n&nbsp;:&nbsp;</strong></td>
										<td>&nbsp;&nbsp;</td>
										<td>
											<input name="AGTPrazon" type="text" size="60" maxlength="255" <cfif modocambio>value="#rsAGTProceso.AGTPrazon#"</cfif>>
										</td>
									</tr>
								</table>
							</fieldset>
						<cfelse>
							<fieldset><legend>Relaci&oacute;n de mejora</legend>
								<table width="104%" align="center"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="16%"><strong>Descripci&oacute;n&nbsp;:&nbsp;</strong></td>
										<td width="38%">
											#rsAGTProceso.AGTPdescripcion#
											<input name="AGTPdescripcion" type="hidden" value="#rsAGTProceso.AGTPdescripcion#">
										</td>
										<td width="17%" align="left"><strong>Creado por:</strong></td>
										<td width="29%" align="left">#rsAGTProceso.nombre#</td>										
									</tr>
									<tr>
										<td width="16%"><strong>Justificaci&oacute;n&nbsp;:&nbsp;</strong></td>
										<td align="left">
											#rsAGTProceso.AGTPrazon#
											<input name="AGTPrazon" type="hidden" value="#rsAGTProceso.AGTPrazon#">
										</td>
										<td align="left"><strong>Fecha:</strong></td>
										<td align="left">#LSDateFormat(rsAGTProceso.AGTPfalta,"dd/mm/yyyy")#</td>
									</tr>
							</table>
							</fieldset>
							<cfset params = params& '&AGTPid=#form.AGTPid#'>
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
												<cf_sifactivo form="fagtproceso" query="#rsADTProceso#" modificable="false">
											<cfelse>
												<cf_sifactivo form="fagtproceso">
											</cfif>
										</td>
										<cfif not mododetcambio>
										<td rowspan="2" valign="middle">
                                        	<cfif (isdefined("session.LvarJA") and not session.LvarJA) or (not isdefined("session.LvarJA"))>
                                            	<cf_botones values="Asociar">
                                            </cfif>
											
										</td>
										</cfif>
									</tr>
									<tr>
										<td><strong>Justificaci&oacute;n&nbsp;:&nbsp;</strong></td>
										<td>&nbsp;&nbsp;</td>
										<td>
											<input name="ADTPrazon" type="text" size="60" maxlength="255" value="<cfif mododetcambio>#rsADTProceso.ADTPrazon#<cfelse>#rsAGTProceso.AGTPrazon#</cfif>">
										</td>
									</tr>
								</table>
							</fieldset>
							<br>
							<cfif mododetcambio>
								<fieldset><legend>Informaci&oacute;n de Activo</legend>
									<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="AreaFiltro" align="center">
									  <tr>
											<td width="28%">&nbsp;</td>
											<td width="15%" align="left"><strong>Adquisición&nbsp;&nbsp;</strong></td>
											<td width="15%" align="left"><strong>Mejoras&nbsp;&nbsp;</strong></td>
											<td width="15%" align="left"><strong>Reevaluación&nbsp;&nbsp;</strong></td>
											<td width="15%" align="left"><strong>Total&nbsp;&nbsp;</strong></td>
									  </tr>
										  <tr>
											<td align="right"><strong>Valor&nbsp;:&nbsp;</strong></td>
											<td align="left"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSvaladq,'none')#<cfelse>0.00</cfif>&nbsp;</td>
											<td align="left"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSvalmej,'none')#<cfelse>0.00</cfif>&nbsp;</td>
											<td align="left"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSvalrev,'none')#<cfelse>0.00</cfif>&nbsp;</td>
											<td align="left"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSvaltot,'none')#<cfelse>0.00</cfif>&nbsp;</td>
										  </tr>
										  <tr>
											<td align="right"><strong>Dep. Acum&nbsp;:&nbsp;</strong></td>
											<td align="left"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSdepacumadq,'none')#<cfelse>0.00</cfif>&nbsp;</td>
											<td align="left"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSdepacummej,'none')#<cfelse>0.00</cfif>&nbsp;</td>
											<td align="left"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSdepacumrev,'none')#<cfelse>0.00</cfif>&nbsp;</td>
											<td align="left"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSdepacumtot,'none')#<cfelse>0.00</cfif>&nbsp;</td>
										  </tr>
										  <tr>
											<td align="right"><strong>Valor en Libros&nbsp;:&nbsp;</strong></td>
											<td align="left"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSsaldoadq,'none')#<cfelse>0.00</cfif>&nbsp;</td>
											<td align="left"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSsaldomej,'none')#<cfelse>0.00</cfif>&nbsp;</td>
											<td align="left"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSsaldorev,'none')#<cfelse>0.00</cfif>&nbsp;</td>
											<td align="left"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSsaldotot,'none')#<cfelse>0.00</cfif>&nbsp;</td>
										  </tr>
										  <tr><td>&nbsp;</td></tr>
										  <tr>
											<td align="right"><strong>Vida Util&nbsp;:&nbsp;</strong></td>
											<td align="left"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSvutiladq,'none')#<cfelse>0</cfif>&nbsp;</td>
										  </tr>
										  <tr>
											<td align="right"><strong>Saldo Vida util&nbsp;:&nbsp;</strong></td>
											<td align="left"><cfif mododetcambio>#LSCurrencyFormat(rsADTProceso.AFSsaldovutiladq,'none')#<cfelse>0</cfif>&nbsp;</td>
										  </tr>
										  <tr><td>&nbsp;</td></tr>
										  <tr>
											<td colspan="5">
											<table width="60%"  border="0" cellspacing="0" cellpadding="0" align="center">
											  <tr>
												<td width="50%" align="left"><strong>INCREMENTO EN VIDA UTIL  : </strong></td>
												<td width="10%" align="left"><cfif mododetcambio><cf_monto name="TAVutil" form="fagtproceso" query="#rsADTProceso#" negativos="true"><cfelse><cf_monto name="TAVutil" form="fagtproceso" negativos="true"></cfif></td>
											  </tr>
											  <tr>
												<td width="50%"  align="left"><strong>INCREMENTO EN MONTO&nbsp;:&nbsp;</strong></td>
												<td width="10%"  align="left"><cfif mododetcambio><cf_monto name="TAmontolocmej" form="fagtproceso" query="#rsADTProceso#"><cfelse><cf_monto name="TAmontolocmej" form="fagtproceso"></cfif></td>
											  </tr>
											</table></td>
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
                                        
                                      
                                        
										<cfif mododetcambio>
                                        	<input type="hidden" name = "ts_rversiondet" value ="#tsdet#">
                                            <input type="hidden" name = "ADTPlinea" value ="#form.ADTPlinea#">
                                        	<cfif isdefined("session.LvarJA") and session.LvarJA><!--- Es Jefe Administrativo --->
                                            	<!--- Aca solo va mostrar el botón Regresar ---> 
	                                            <cfset botonesex[1] = "CambioDet">
                                                <cfset botonesex[2] = "BajaDet">
                                                <cfset botonesex[3] = "Baja">
                                                <cfset botonesex[4] = "NuevoDet">
                                                <cf_botones modocambio="#modocambio#" mododet="CAMBIO" excludearray="#botonesex#" form="fagtproceso"               regresar="agtProceso_genera_#botonAccion[IDtrans][1]#_JA.cfm?#params#"       nameenc="Grupo" genero="M" include="#Aplicar#"> 
                                            <cfelseif isdefined("session.LvarJA") and not session.LvarJA> <!--- Es auxiliar --->
                                            	<!--- Acá muestra los botones normalmente (Modificar, Eliminar, Eliminar Grupo, Nuevo y regresar) --->
                                                <cf_botones modocambio="#modocambio#" mododet="CAMBIO" form="fagtproceso"               regresar="agtProceso_genera_#botonAccion[IDtrans][1]#_Aux.cfm?#params#" 		nameenc="Grupo" genero="M"> 
                                        	<cfelse><!--- Si no viene la variable session.LvarJA Se deja como estaba --->
                                            	<cf_botones modocambio="#modocambio#" mododet="CAMBIO" form="fagtproceso" nameenc="Grupo" genero="M" include="#Aplicar#"  regresar="agtProceso_genera_#botonAccion[IDtrans][1]#.cfm?#params#"> 
                                            </cfif>
                                        <cfelse>
                                        	<cfif isdefined("session.LvarJA") and session.LvarJA>
                                                <td rowspan="0" colspan="0">
													<!--- Aca solo va mostrar el botón Regresar ---> 
                                                    <cfset botonesex[1] = "Cambio">
                                                    <cfset botonesex[2] = "Baja">
                                                    <cfset botonesex[3] = "Nuevo">
                                                	<cf_botones modocambio="#modocambio#" excludearray="#botonesex#" form="fagtproceso" include="#Aplicar#" regresar="agtProceso_#botonAccion[IDtrans][1]#_JA.cfm?#params#">
                                                </td>																					
                                            <cfelseif isdefined("session.LvarJA") and not session.LvarJA> <!--- Es auxiliar --->
	                                            <td rowspan="0">											
                                                	<cfset Importar = "Importar">
                                                <td rowspan="0" colspan="0">
                                                	<cf_botones modocambio="#modocambio#" form="fagtproceso" include="#Importar#" regresar="agtProceso_#botonAccion[IDtrans][1]#_Aux.cfm?#params#" >
                                                </td>
                                                </td>
                                            <cfelse>								
                                                <td rowspan="0">											
                                                <cfset Importar = "Importar">
                                                <td rowspan="0" colspan="0"><cf_botones modocambio="#modocambio#" form="fagtproceso" include="#Importar#,#Aplicar#" regresar="agtProceso_#botonAccion[IDtrans][1]#.cfm?#params#" ></td>																					
                                                </td>
                                            </cfif>
                                        </cfif>
										<cfif modocambio>
											<input type="hidden" name = "ts_rversion" value ="#ts#">
											<input type="hidden" name = "AGTPid" value ="#form.AGTPid#">
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
		
									<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
										tabla="
											ADTProceso a
												inner join Activos b on 
													a.Aid = b.Aid and 
													a.Ecodigo = b.Ecodigo"
										columnas="
											AGTPid as LAGTPid, ADTPlinea as LADTPlinea, TAmontolocadq as LTAmontolocadq, TAmontolocmej as LTAmontolocmej, 
											TAmontolocrev as LTAmontolocrev, b.Aid as LAid, rtrim(b.Aplaca) as LAplaca, rtrim(b.Adescripcion) as LAdescripcion, 
											TAmontolocadq + TAmontolocmej + TAmontolocrev as LTAmontoloctot, TAvutil"
										desplegar="LAplaca, LAdescripcion, LTAmontolocmej"
										etiquetas="Placa, Descripci&oacute;n, MEJ."
										formatos="S, S, M"
										formname="fagtproceso"
										incluyeform="false"
										filtro="
											a.Ecodigo = #session.ecodigo#
											and a.AGTPid = #form.AGTPid#"
										align="left, left, right"
										ajustar="N, N, N"
										keys="LADTPlinea"
										ira="agtProceso_genera_#botonAccion[IDtrans][1]##LvarPar#.cfm"
										MaxRows="8"
										filtrar_automatico="true"
										mostrar_filtro="true"
										filtrar_por="Aplaca,Adescripcion,TAmontolocmej"
										navegacion="#navegacion#">
								</fieldset>
							</cfif>
						<cfelse>
 							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<cfset Aplicar = "">
                                        
										<cf_botones modocambio="#modocambio#" form="fagtproceso" include="#Aplicar#"  regresar="agtProceso_#botonAccion[IDtrans][1]#.cfm?#params#">
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

<!---funciones en javascript de los demás campos--->
<script language="javascript" type="text/javascript">
<!--//
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
	qFormAPI.errorColor = "#FFFFCC";
	qffagtproceso = new qForm("fagtproceso");

	function funcTAmontolocmej()
	{		
		LvarVU = qffagtproceso.TAVutil.obj.value
		LvarVU = LvarVU.replace(',','');

		if (LvarVU < 0)
		{
			qffagtproceso.TAmontolocmej.obj.value = '0.00';
		}
	}
	
	function funcTAVutil()
	{
		LvarVU = qffagtproceso.TAVutil.obj.value
		LvarVU = LvarVU.replace(',','');

		if (LvarVU < 0)
		{
			qffagtproceso.TAmontolocmej.obj.value = '0.00';
		}	
	}

	function funcCambioDet() {
		LvarVU = qffagtproceso.TAVutil.obj.value
		LvarVU = LvarVU.replace(',','');
			
		if (LvarVU >= 0 && qffagtproceso.TAmontolocmej.obj.value == 0.00) {
			alert('El monto debe ser mayor a cero');
			return false;
		}
	}
	function habilitarValidacion(){
		qffagtproceso.AGTPdescripcion.required = true;
		<cfif modocambio>
			qffagtproceso.Aid.required = false;
		</cfif>
	}
	function deshabilitarValidacion(){
		qffagtproceso.AGTPdescripcion.required = false;
		<cfif modocambio>
			qffagtproceso.Aid.required = false;
		</cfif>
	}
	function _qfinit(){	
		habilitarValidacion();
		<cfoutput>
		qffagtproceso.AGTPdescripcion.description = "#JSStringFormat('Descripción')#";
		</cfoutput>
	}
	<cfif modocambio>
	<cfoutput>
	qffagtproceso.Aid.description = "#JSStringFormat('Activo')#";
	qffagtproceso.Aid.required = true;
	function funcAsociar(){
		qffagtproceso.Aid.required = true;
	}
	</cfoutput>
	</cfif>
	function _forminit(){
		var form = document.fagtproceso;
		_qfinit()
		<cfif modocambio>
		qffagtproceso.Aplaca.obj.focus();
		<cfelse>
		qffagtproceso.AGTPdescripcion.obj.focus();
		</cfif>
		<cfif mododetcambio>
			form.TAVutil.focus();
		</cfif>		
	}
	_forminit();
//-->
</script>