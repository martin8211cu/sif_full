
<cfif isdefined("url.AFESid") and len(trim(url.AFESid))>
	<cfset form.AFESid = url.AFESid>
	<cfset modocambio = true>
<cfelseif isdefined("form.AFESid") and len(trim(form.AFESid))>
	<cfset form.AFESid = form.AFESid>
	<cfset modocambio = true>
    <cfset CambioDetalle = true>
<cfelse>
	<cfset modocambio = false>
</cfif>

<cfif isdefined("form.AFESDid") and len(trim(form.AFESDid))>
	<cfset modocambio = true>
	<cfset mododetcambio = true>
	<cfset form.AFESDid = form.AFESDid>
<cfelseif isdefined("CambioDetalle") and CambioDetalle EQ true>
	<cfset mododetcambio = false>
<cfelse>
	<cfset mododetcambio = false>
</cfif>
<cfif isdefined('form.params')>
	<cfset params = form.params>
</cfif>


<cfquery name="rsFechaHoy" datasource="#Session.DSN#">
	<!---select <cf_dbfunction name='today'> as Fecha
    from dual--->
 select  convert(varchar(10),GETDATE(),103)as Fecha from dual

</cfquery>

<cfquery name="rsMotivo" datasource="#Session.DSN#">
				select
                    a.Ecodigo,
                    a.AFMSid,
                    a.AFMScodigo,
                    a.AFMSdescripcion
				from AFMotivosSalida a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
                    order by a.AFMSid
</cfquery>

<cfquery name="rsDestino" datasource="#Session.DSN#">

		       select
                    a.Ecodigo,
                    a.AFDSid,
                    a.AFDcodigo,
                    a.AFDdescripcion
				from AFDestinosSalida a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
					order by a.AFDSid
</cfquery>

<cfif modocambio>
	<cfquery name="rsVerificaMov" datasource="#session.dsn#">
    	select
			a.TipoMovimiento
		from AFEntradaSalidaE a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		  and a.AFESid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">
    </cfquery>

    <cfif rsVerificaMov.TipoMovimiento EQ 1 or rsVerificaMov.TipoMovimiento EQ 4>
            <cfquery name="rsEntradaSalida" datasource="#session.dsn#">
            select
                case when (a.TipoMovimiento = 1) then 'Entrada'
                WHEN (a.TipoMovimiento = 2) then 'Salida'
				WHEN (a.TipoMovimiento = 3) then 'Comodato'
				WHEN (a.TipoMovimiento = 4) then 'Comodato Devuelto' end  as TipoMovimiento,
                a.Fecha,
                a.Observaciones,
                a.ts_rversion
            from AFEntradaSalidaE a
                inner join Usuario b on a.Usuaplica = b.Usucodigo
                inner join DatosPersonales c on b.datos_personales = c.datos_personales
            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
              and a.AFESid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">
            </cfquery>
	<cfelseif rsVerificaMov.TipoMovimiento EQ 2 or rsVerificaMov.TipoMovimiento EQ 3>

            <cfquery name="rsEntradaSalida" datasource="#session.dsn#">
                select
                    a.AFESid,
                    a.Ecodigo,
                    case when (a.TipoMovimiento = 1) then 'Entrada'
                    WHEN (a.TipoMovimiento = 2) then 'Salida'
					WHEN (a.TipoMovimiento = 3) then 'Comodato'
					WHEN (a.TipoMovimiento = 4) then 'Comodato Devuelto' end  as TipoMovimiento,
                    a.Descripcion,
                    a.AFMSid,
				<cfif rsVerificaMov.TipoMovimiento NEQ 3>
                    e.AFMSdescripcion,
				</cfif>
                    a.Fecha,
                    a.AFDSid,
                    d.AFDdescripcion,
                    a.FechaRegreso,
                    a.Autoriza,
                    a.Observaciones,
                    a.ts_rversion,
					a.contrato
                from AFEntradaSalidaE a
                    inner join AFDestinosSalida d
                        on d.AFDSid = a.AFDSid
                        and a.Ecodigo = d.Ecodigo
				<cfif rsVerificaMov.TipoMovimiento NEQ 3>
                    inner join AFMotivosSalida e
                        on e.AFMSid = a.AFMSid
                        and a.Ecodigo = e.Ecodigo
				</cfif>
                    inner join Usuario b on a.Usuaplica = b.Usucodigo
                    inner join DatosPersonales c on b.datos_personales = c.datos_personales
                where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
                  and a.AFESid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">
            </cfquery>
</cfif>
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp= "#rsEntradaSalida.ts_rversion#" returnvariable="ts"/>
	<cfif mododetcambio>
		<cfquery name="rsADTProceso" datasource="#session.dsn#">
		select  c.Aid,
        		c.Aplaca,
                c.Adescripcion,
                c.Aserie,
                a.ts_rversion
			from AFEntradaSalidaE a
				inner join AFEntradaSalidaD b on a.AFESid = b.AFESid
				inner join Activos c on c.Aid = b.Aid and a.Ecodigo = c.Ecodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
			and a.AFESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFESid#">
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
									<tr id = "div34">
                                        <td valign="top" id = "div35">&nbsp;</td>
										<td id = "div36"><strong>Tipo Movimiento:&nbsp;</strong></td>

										<td id = "div37">
                                               <select name="Movimiento" id = "Movimiento" tabindex="1" onchange="mostrar(this.value)">
                                                  <option value="" >--Seleccione Movimiento--</option>
                                                  <option value="1" >Entrada</option>
                                                  <option value="2" >Salida</option>
												  <option value="3" >Comodato</option>
												  <option value="4" >Comodato Devuelto</option>
                                               </select>
										</td>
									</tr>

                                    <tr  id = "div1">
                                    	<td valign="top" id = "div2">&nbsp;</td>
                                        <td id = "div3"><strong>Descripci&oacute;n&nbsp;:</strong></td>
                                            <td id = "div4">
                                                <input name="Descripcion" type="text" size="80" maxlength="50">
                                        </td>
									</tr>

                                    <tr id = "div5">
                                        <td valign="top" id="div6">&nbsp;</td>
										<td id = "div7"><strong>Motivo:&nbsp;</strong></td>
											<td id = "div8">
                                                <select name="Motivo" tabindex="1">
                                                <option value="">--Seleccionar Motivo--</option>
                                                <cfloop query="rsMotivo">
                                                      <option value="#AFMSid#">#AFMSdescripcion#</option>
                                                </cfloop>
                                                 </select>
											</td>
									</tr>

                                    <tr id = "div9">
                                        <td valign="top" id = "div10">&nbsp;</td>
										<td id = "div11"><strong>Fecha:&nbsp;</strong></td>
										<td id = "div12">
											<cfif  modocambio>
                                                <cf_sifcalendario form = "fagtproceso"name="Fechaa" value="#(rsEntradaSalida.Fecha)#" tabindex="1">
                                            <cfelseif isdefined("form.Fechaa")>
                                                <cf_sifcalendario name="Fechaa"  form = "fagtproceso" value="#LSDateFormat(form.Fechaa,'dd/mm/yyyy')#"        tabindex="1">
                                            <cfelse>
                                                <cf_sifcalendario name="Fechaa" form = "fagtproceso" value="#LSDateFormat(rsFechaHoy.Fecha,'dd/mm/yyyy')#"          tabindex="1">
                                            </cfif>

            							</td>
									</tr>


                                     <tr id = "div13">
                                        <td valign="top" id="div14">&nbsp;</td>
										<td id = "div15"><strong>Destino:&nbsp;</strong></td>
											<td id = "div16">
                                                <select name="Destino" tabindex="1">
                                                <option value="">--Seleccionar Destino--</option>
                                                <cfloop query="rsDestino">
                                                      <option value="#AFDSid#">#AFDdescripcion#</option>
                                                </cfloop>
                                                 </select>
											</td>
									</tr>

                                    <tr id = "div17">
                                        <td valign="top" id = "div18">&nbsp;</td>
										<td id = "div19"><strong>Fecha Regreso:&nbsp;</strong></td>
										<td id = "div20">
											<cfif  modocambio>
                                                <cf_sifcalendario name="FechaRegreso" form = "fagtproceso" value="#LSDateFormat(rsEntradaSalida.FechaRegreso,'dd/mm/yyyy')#" tabindex="1">
                                            <cfelseif isdefined("form.FechaRegreso")>
                                                <cf_sifcalendario name="FechaRegreso" form = "fagtproceso" value="#LSDateFormat(form.FechaRegreso,'dd/mm/yyyy')#"        tabindex="1">
                                            <cfelse>
                                                <cf_sifcalendario name="FechaRegreso" form = "fagtproceso" value="#LSDateFormat(rsFechaHoy.Fecha,'dd/mm/yyyy')#"          tabindex="1">
                                            </cfif>
            							</td>
									</tr>

                                    <tr id = "div21">
                                        <td valign="top" id = "div22">&nbsp;</td>
										<td id = "div23"><strong>Autoriza:&nbsp;</strong></td>
										<td id = "div24">
											<input name="Autoriza" type="text" size="50" maxlength="50">
										</td>
									</tr>

									<tr id = "divCont">
                                        <td valign="top" id = "divCont2">&nbsp;</td>
										<td id = "divCont3"><strong>Contrato:&nbsp;</strong></td>
										<td id = "divCont4">
											<input name="contrato" type="text" size="12" maxlength="12">
										</td>
									</tr>

                                     <tr id = "div25">
                                        <td valign="top" id = "div26">&nbsp;</td>
                                        <td valign="top" id = "div27"><strong><cf_translate key="LB_Observaciones">Observaciones</cf_translate>:</strong></td>
                                        <td valign="top" id = "div28">&nbsp;</td>
                                        <td valign="top" id = "div29">&nbsp;</td>
                                     </tr>

                                     <tr id = "div30">
                                        <td valign="top" id = "div31">&nbsp;</td>
                                        <td colspan="2" valign="top" id = "div32"><textarea cols="120" rows="5" style="font-family:Arial, Helvetica, sans-serif;font-size:12px" name="Observaciones" id="Observaciones" tabindex="1"></textarea></td>
                                        <td id = "div33" valign="top">&nbsp;</td>
                                     </tr>

								</table>
							</fieldset>
						<cfelse>
							<fieldset><legend>Información Requerida</legend>
								<table width="120%" align="center"  border="0" cellspacing="0" cellpadding="0">
                                <tr>
										<td width="8%"><strong>Tipo Movimiento:</strong></td>
										<td width="20%">
                                       			 <input name="Movimiento"  readonly="readonly" style="border-width: 0px;" type="text" value = "#rsEntradaSalida.TipoMovimiento#"size="45" maxlength="255">
                                        </td>
										<cfif modocambio and rsEntradaSalida.TipoMovimiento NEQ 'Entrada' and rsEntradaSalida.TipoMovimiento NEQ 'Comodato Devuelto'>
                                         <td width="2%"align="left"><strong>Destino:</strong></td>
                                            <td width="5" align="left">
                                                 <select name="Destino" tabindex="1">
                                                <cfif modocambio and rsEntradaSalida.TipoMovimiento NEQ 'Entrada' and rsEntradaSalida.TipoMovimiento NEQ 'Comodato Devuelto'>
                                                    <option selected value= #rsEntradaSalida.AFDSid#>#rsEntradaSalida.AFDdescripcion#</option>
                                                </cfif>
                                                    <cfquery name="rsDestinoCambio" datasource="#Session.DSN#">
                                                          select
                                                            a.Ecodigo,
                                                            a.AFDSid,
                                                            a.AFDcodigo,
                                                            a.AFDdescripcion
                                                        from AFDestinosSalida a
                                                            inner join AFEntradaSalidaE b
                                                                        on a.Ecodigo = b.Ecodigo
                                                            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
                                                             and b.AFESid = #form.AFESid#
                                                             and b.AFDSid <> a.AFDSid
                                                            order by a.AFDSid
                                       				</cfquery>
                                                       <cfloop query="rsDestinoCambio">
                                                          <option value="#AFDSid#">#AFDdescripcion#</option>
                                                    </cfloop>
                                                 </select>
                                            </td>
                                        </cfif>

                                        <td width="7%" align="left"><strong>Fecha:</strong></td>
										<td width="17%" align="left">
                                         	<cfif modocambio>
                                                <cf_sifcalendario name="Fechaa" form = "fagtproceso" value="#LSDateFormat(rsEntradaSalida.Fecha,'dd/mm/yyyy')#" tabindex="1">
                                            <cfelseif isdefined("form.Fechaa")>
                                                <cf_sifcalendario name="Fechaa" form = "fagtproceso" value="#LSDateFormat(form.Fechaa,'dd/mm/yyyy')#"        tabindex="1">
                                            <cfelse>
                                                <cf_sifcalendario name="Fechaa" form = "fagtproceso"value="#LSDateFormat(rsFechaHoy.Fecha,'dd/mm/yyyy')#"          tabindex="1">
                                            </cfif>
                                         </td>
								</tr>

                                    <tr>
                                    	<td>
                                            <p>

                                            </p>

                                   		</td>
                                    </tr>

                               <cfif modocambio and rsEntradaSalida.TipoMovimiento NEQ 'Entrada' and rsEntradaSalida.TipoMovimiento NEQ 'Comodato Devuelto'>
									<tr>
										<td  width="8%"><strong>Descripci&oacute;n&nbsp;:</strong></td>
										<td width="20%">
											<input name="Descripcion" type="text" size="80" maxlength="50" <cfif modocambio>value="#rsEntradaSalida.Descripcion#"</cfif>>
										</td>

							<cfif modocambio and rsEntradaSalida.TipoMovimiento EQ 'Comodato'>
												<td width="2%" align="left">&nbsp;</td>
												<td width="5%" align="left">&nbsp;</td></cfif>

							<cfif modocambio and rsEntradaSalida.TipoMovimiento EQ 'Salida'>
										<td width="2%" align="left"><strong>Motivo:</strong></td>
										<td width="5%" align="left">

									    	<select name="Motivo" tabindex="1">
                                             <option selected value= "#rsEntradaSalida.AFMSid#">#rsEntradaSalida.AFMSdescripcion#</option>

                                                     <cfquery name="rsMotivoCambio" datasource="#Session.DSN#">
                                                                    select
                                                                        a.Ecodigo,
                                                                        a.AFMSid,
                                                                        a.AFMScodigo,
                                                                        a.AFMSdescripcion
                                                                    from AFMotivosSalida a
                                                                    	inner join AFEntradaSalidaE b
                                                                            on a.Ecodigo = b.Ecodigo
                                                                        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
                                                                        and b.AFESid = #form.AFESid#
                                                                        and b.AFMSid <> a.AFMSid
                                                                        order by a.AFMSid
                                                      </cfquery>
												<cfloop query="rsMotivoCambio">
                                                      <option value="#AFMSid#">#AFMSdescripcion#</option>
                                                </cfloop>
                                         	</select>
                                         </td>
							</cfif>
                                        <td width="7%" align="left"><strong>Fecha Regreso:</strong></td>
										<td width="17%" align="left">
                                         	<cfif modocambio >
                                                <cf_sifcalendario name="FechaRegreso" form = "fagtproceso" value="#LSDateFormat(rsEntradaSalida.FechaRegreso,'dd/mm/yyyy')#" tabindex="1">
                                            <cfelseif isdefined("form.FechaRegreso")>
                                                <cf_sifcalendario name="FechaRegreso" form = "fagtproceso" value="#LSDateFormat(form.FechaRegreso,'dd/mm/yyyy')#"        tabindex="1">
                                            <cfelse>
                                                <cf_sifcalendario name="FechaRegreso" form = "fagtproceso" value="#LSDateFormat(rsFechaHoy.Fecha,'dd/mm/yyyy')#"          tabindex="1">
                                            </cfif>
                                          </td>
									</tr>
                                  </cfif>

								    <cfif modocambio and rsEntradaSalida.TipoMovimiento EQ 'Comodato'>
										<tr><cfoutput>
											<td width="7%" align="left"><strong>Contrato:</strong></td>
                                            <td><input type="text" name ="contrato" value="#rsEntradaSalida.contrato#" size="20" maxlength="12"></td>
											</cfoutput>
    									</tr>
									</cfif>

                                     <tr>
                                    	<td>
                                            <p>
                                            </p>

                                   		</td>
                                    </tr>
                             	<table>
                                     <tr>
                                        <td valign="top"><strong>Observaciones:</strong></td>
                                        <td valign="top">&nbsp;</td>
                                        <td valign="top">&nbsp;</t>
                                     </tr>
                                     <tr>
                                        <td colspan="2" valign="top"  width="30%"><textarea  cols="152" rows="4"
                                        	style="font-family:Arial, Helvetica, sans-serif;font-size:12px"
                                        	name="Observaciones" id="Observaciones">#rsEntradaSalida.Observaciones#</textarea>
                                        </td>
                                        <td valign="top">&nbsp;</td>
                                     </tr>
                                     <tr>
                                        <td>
                                            <p>
                                            </p>

                                        </td>
                                    </tr>
                           <cfif modocambio and rsEntradaSalida.TipoMovimiento NEQ 'Entrada' and rsEntradaSalida.TipoMovimiento NEQ 'Comodato Devuelto'>
                                  	 <tr>
                                        <td width="1%"valign="top"><strong>Autoriza:</strong></td>

                                           <td colspan="2" valign="top"  width="50%">
											<cfoutput>
												<input name="Autoriza" id="Autoriza" type="text" size="50" maxlength="50" value=<cfif modocambio>"#rsEntradaSalida.Autoriza#"</cfif>>
	                                       	</cfoutput>
										</td>
                                    </tr>
                             </cfif>
								</table>
							</table>
							</fieldset>
							<cfset params = params& '&AFESid=#form.AFESid#'>
						</cfif>

						<cfif modocambio>

							<br>
							<fieldset><legend>Asociar Activos a Relaci&oacute;n</legend>
								<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
                                <input name="AFESid" type="hidden" value="#form.AFESid#">
									<tr>
										<td><strong>Activo&nbsp;:&nbsp;</strong></td>
										<td>&nbsp;&nbsp;</td>
										<td>
												<cf_sifactivo form="fagtproceso">
										</td>
										<cfif not mododetcambio>
										<td rowspan="2" valign="middle">
                                            	<cf_botones values="Asociar"  onClick="javascript: return funcAsociar();">
										</td>
										</cfif>
									</tr>
								</table>
							</fieldset>
							<br>

							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<cfif modocambio>
											<cfset Aplicar = "Aplicar">
										<cfelse>
											<cfset Aplicar = "">
										</cfif>


                                                <td rowspan="0">
													<cfset Imprimir = "Imprimir">
                                                    <td rowspan="0" colspan="0"><cf_botones modocambio="#modocambio#" form="fagtproceso" include="#Imprimir#,#Aplicar#"
                                                    						regresar="agtProceso_#botonAccion[IDtrans][1]#.cfm?#params#" >
                                                    </td>

                                                </td>
                                           <input type="hidden" name = "ts_rversion" value ="#ts#">

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
											AFEntradaSalidaD a
                                            	inner join AFEntradaSalidaE c
                                                	on a.AFESid = c.AFESid
												inner join Activos b on
													a.Aid = b.Aid"
										columnas="
											Aplaca as Placa, Adescripcion as Descripcion, Aserie as Serie, a.AFESDid"
										desplegar="Placa, Descripcion, Serie"
										etiquetas="Placa, Descripci&oacute;n, Serie"
										formatos="S, S, S"
                                        formname="fagtproceso"
										incluyeform="false"
										filtro="
											c.Ecodigo = #session.ecodigo#
											and a.AFESid = #form.AFESid#"
										align="left, left, right"
										ajustar="N, N, N"
                                        showlink = "false"
                                        checkBoxes="S"
                                        keys="AFESDid"
										MaxRows="8"
										filtrar_automatico="true"
										mostrar_filtro="true"
										filtrar_por="Aplaca,Adescripcion,Serie"
										navegacion="#navegacion#">
								</fieldset>
                                	<tr>
									    <td rowspan="0" colspan="0"><cf_botones values="Eliminar" name = "BajaDet" tabindex="1" ></td>
									</tr>
							</cfif>
                            <table width="100%"  border="0" cellspacing="0" cellpadding="0">

							</table>
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

	divCont.style.display = 'none';
	divCont2.style.display = 'none';
	divCont3.style.display = 'none';
	divCont4.style.display = 'none';

	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
	qFormAPI.errorColor = "#FFFFCC";
	qffagtproceso = new qForm("fagtproceso");


function mostrar(sel) {

      if (sel==1 || sel==4){
	  div1.style.display = 'none';
      div2.style.display = 'none';
      div3.style.display = 'none';
	  div4.style.display = 'none';
      div5.style.display = 'none';
	  div6.style.display = 'none';
	  div7.style.display = 'none';
	  div8.style.display = 'none';
	  div9.style.display = 'block';
      div10.style.display = 'block';
      div11.style.display = 'block';
	  div12.style.display = 'block';
      div13.style.display = 'none';
	  div14.style.display = 'none';
	  div15.style.display = 'none';
	  div16.style.display = 'none';
	  div17.style.display = 'none';
      div18.style.display = 'none';
      div19.style.display = 'none';
	  div20.style.display = 'none';
      div21.style.display = 'none';
	  div22.style.display = 'none';
	  div23.style.display = 'none';
	  div24.style.display = 'none';
	  div25.style.display = 'block';
      div26.style.display = 'block';
      div27.style.display = 'block';
	  div28.style.display = 'block';
      div29.style.display = 'block';
	  div30.style.display = 'block';
	  div31.style.display = 'block';
	  div32.style.display = 'block';
	  div33.style.display = 'block';
	   div34.style.display = 'block';
	  div35.style.display = 'block';
	  div36.style.display = 'block';
	  div37.style.display = 'block';

      }

      if (sel==2){
	  div1.style.display = 'block';
      div2.style.display = 'block';
      div3.style.display = 'block';
	  div4.style.display = 'block';
      div5.style.display = 'block';
	  div6.style.display = 'block';
	  div7.style.display = 'block';
	  div8.style.display = 'block';
	  div9.style.display = 'block';
      div10.style.display = 'block';
      div11.style.display = 'block';
	  div12.style.display = 'block';
      div13.style.display = 'block';
	  div14.style.display = 'block';
	  div15.style.display = 'block';
	  div16.style.display = 'block';
	  div17.style.display = 'block';
      div18.style.display = 'block';
      div19.style.display = 'block';
	  div20.style.display = 'block';
      div21.style.display = 'block';
	  div22.style.display = 'block';
	  div23.style.display = 'block';
	  div24.style.display = 'block';
	  div25.style.display = 'block';
      div26.style.display = 'block';
      div27.style.display = 'block';
	  div28.style.display = 'block';
      div29.style.display = 'block';
	  div30.style.display = 'block';
	  div31.style.display = 'block';
	  div32.style.display = 'block';
	  div33.style.display = 'block';
	  div34.style.display = 'block';
	  div35.style.display = 'block';
	  div36.style.display = 'block';
	  div37.style.display = 'block';
      }

    if(sel==3){
      divCont.style.display = 'block';
      divCont2.style.display = 'block';
	  divCont3.style.display = 'block';
	  divCont4.style.display = 'block';
      div5.style.display = 'none';
      div1.style.display = 'block';
      div2.style.display = 'block';
      div3.style.display = 'block';
	  div4.style.display = 'block';
	  div6.style.display = 'block';
	  div7.style.display = 'block';
	  div8.style.display = 'block';
	  div9.style.display = 'block';
      div10.style.display = 'block';
      div11.style.display = 'block';
	  div12.style.display = 'block';
      div13.style.display = 'block';
	  div14.style.display = 'block';
	  div15.style.display = 'block';
	  div16.style.display = 'block';
	  div17.style.display = 'block';
      div18.style.display = 'block';
      div19.style.display = 'block';
	  div20.style.display = 'block';
      div21.style.display = 'block';
	  div22.style.display = 'block';
	  div23.style.display = 'block';
	  div24.style.display = 'block';
	  div25.style.display = 'block';
      div26.style.display = 'block';
      div27.style.display = 'block';
	  div28.style.display = 'block';
      div29.style.display = 'block';
	  div30.style.display = 'block';
	  div31.style.display = 'block';
	  div32.style.display = 'block';
	  div33.style.display = 'block';
	  div34.style.display = 'block';
	  div35.style.display = 'block';
	  div36.style.display = 'block';
	  div37.style.display = 'block';
    }else{
    	divCont.style.display = 'none';
    	divCont2.style.display = 'none';
	    divCont3.style.display = 'none';
	    divCont4.style.display = 'none';
    }
}

	function habilitarValidacion(){
		Movimiento = qffagtproceso.Movimiento.obj.value;
		if (Movimiento == 2){
			qffagtproceso.Autoriza.required = true;
			qffagtproceso.Observaciones.required = true;
			qffagtproceso.Descripcion.required = true;
			qffagtproceso.Motivo.required = true;
			qffagtproceso.Destino.required = true;
			qffagtproceso.Fechaa.required = true;
			qffagtproceso.FechaRegreso.required = true;
			qffagtproceso.contrato.required = false;

		}
		if (Movimiento == 1 || Movimiento == 4) {
			qffagtproceso.Autoriza.required = false;
			qffagtproceso.Observaciones.required = true;
			qffagtproceso.Descripcion.required = false;
			qffagtproceso.Motivo.required = false;
			qffagtproceso.Destino.required = false;
			qffagtproceso.Fechaa.required = true;
			qffagtproceso.FechaRegreso.required = false;
			qffagtproceso.contrato.required = false;

		}

		if(Movimiento == 3){
		qffagtproceso.contrato.required = true;
		qffagtproceso.Autoriza.required = true;
		qffagtproceso.Motivo.required = false;
		qffagtproceso.Observaciones.required = true;
		qffagtproceso.Descripcion.required = true;
		qffagtproceso.Destino.required = true;
		qffagtproceso.Fechaa.required = true;
		qffagtproceso.contrato.required = false;
		}

	}
<!---	function deshabilitarValidacion(){
		qffagtproceso.Descripcion.required = false;
		<cfif modocambio>
			qffagtproceso.Aid.required = false;
		</cfif>
	}
--->
	<cfif modocambio>
	<cfoutput>


	function funcAsociar(){
		Aid = qffagtproceso.Aid.obj.value;
		if (Aid==""){
			alert("Debe seleccionar un Activo para asociar");
			return false;
		}
	}
	function habilitarValidacion(){
		Movimiento = qffagtproceso.Movimiento.obj.value;
		if (Movimiento == 'Salida'){
			qffagtproceso.Autoriza.required = true;
			qffagtproceso.Observaciones.required = true;
			qffagtproceso.Descripcion.required = true;
			qffagtproceso.Motivo.required = true;
			qffagtproceso.Destino.required = true;
			qffagtproceso.Fechaa.required = true;
			qffagtproceso.FechaRegreso.required = true;

		}else{
			qffagtproceso.Observaciones.required = true;
			qffagtproceso.Fechaa.required = true;


		}


}
	</cfoutput>
	</cfif>

//-->
</script>