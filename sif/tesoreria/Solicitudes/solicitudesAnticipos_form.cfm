<cfparam name="form.TESSPid" default="">

<cfif isdefined('form.TESSPid') and len(trim(form.TESSPid))>
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset modo = 'ALTA'>
</cfif>

<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="rsForm">
		Select 
			a.TESSPid, 
			a.TESSPfechaSolicitud,
			a.TESSPnumero,
			a.CDCcodigo, a.SNcodigoOri,
			a.TESSPfechaPagar,
			a.McodigoOri,
			a.TESSPtipoCambioOriManual,
			m.Mnombre, a.TESSPtotalPagarOri,
			a.TESSPmsgRechazo,
			a.CFid,
			CFdescripcion as CFdescripcionresp,
			a.BMUsucodigo,
			a.ts_rversion

			,TESOPobservaciones
			,TESOPinstruccion
			,TESOPbeneficiarioSuf

		from TESsolicitudPago a
			inner join Monedas m
				 on m.Ecodigo = a.EcodigoOri
				and m.Mcodigo = a.McodigoOri
			left outer join CFuncional b
					on b.CFid = a.CFid
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		where a.EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.TESSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
	</cfquery>
</cfif>

<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select <cf_dbfunction name="to_char" args="Mcodigo"> as Mcodigo  
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
</cfquery>

<cfoutput>
	<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
	
	<cfoutput>
	<form action="solicitudesAnt#LvarTipoAnticipo#_sql.cfm" onSubmit="return validar(this);" method="post" name="form1" id="form1">
			<table align="center" summary="Tabla de entrada" border="0">
				<tr>
					<td valign="top" align="right">
						<strong>Núm. Solicitud:&nbsp;</strong>
					</td>
					<td valign="top">						
						<cfif modo NEQ 'ALTA'>
							<strong>#rsForm.TESSPnumero#</strong>
							<input type="hidden" name="TESSPnumero" value="#rsForm.TESSPnumero#">
						<cfelse>
							&nbsp;&nbsp; -- Nueva Solicitud de Pago --
						</cfif>
					</td>
					<td valign="top" align="right">
						<strong>Fecha Solicitud:&nbsp;</strong>
					</td>
					<td valign="top">
						<cfif modo NEQ 'ALTA'>
						<strong>#LSDateFormat(rsForm.TESSPfechaSolicitud,"DD/MM/YYYY")#</strong>
						<cfelse>
							&nbsp;&nbsp; <strong>#LSDateFormat(now(),"DD/MM/YYYY")#</strong>
						</cfif>
					</td>
				</tr>

				<tr><td>&nbsp;</td></tr>

				<tr>
					<td align="right">
						<strong>Centro&nbsp;Funcional:&nbsp;</strong>
					</td>
					<td colspan="3">
					  <cfif modo neq 'ALTA'>
						<cf_cboCFid query="#rsForm#" cambiarSP="yes" tabindex="1">
					  <cfelse>
						<cf_cboCFid tabindex="1">
					  </cfif>
					</td>
				</tr>									

			<cfif LvarTipoAnticipo EQ "POS">
				<tr>
					<td valign="top" nowrap align="right"><strong>Cliente Detallista:</strong></td>
					<td valign="top" colspan="3">
						<table>
							<tr>
								<td>
									<input type="hidden" name="SNcodigoOri" value="-1">
									<cfif modo NEQ 'ALTA'>
										<cf_sifClienteDetCorp CDCidentificacion="CDCidentificacion" CDCcodigo="CDCcodigo" 
											form="form1" idquery="#rsForm.CDCcodigo#" tabindex="1">
									<cfelse>
										<cf_sifClienteDetCorp CDCidentificacion="CDCidentificacion" CDCcodigo="CDCcodigo" form="form1" tabindex="1">
									</cfif>
								</td>
								<td>
									<input type="text"
										name="TESOPbeneficiarioSuf" 
										id="TESOPbeneficiarioSuf"
										onfocus="this.select();"
										tabindex="1" 
										size="40"
										maxlength="255"
										value="<cfif  modo NEQ 'ALTA'>#rsForm.TESOPbeneficiarioSuf#</cfif>"
									>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			<cfelse>
				<tr>
					<td valign="top" nowrap align="right"><strong>Socio de Negocios:</strong></td>
					<td valign="top" colspan="3">
						<table>
							<tr>
								<td>
									<input type="hidden" name="CDCcodigo" value="-1">
									<cfif modo NEQ 'ALTA'>
										<cfif rsForm.TESSPtotalPagarOri GT 0>
											<cf_sifsociosnegocios2 form="form1" SNcodigo='SNcodigoOri' idquery="#rsForm.SNcodigoOri#" tabindex="1" modificable="no">
										<cfelse>					  
											<cf_sifsociosnegocios2 form="form1" SNcodigo='SNcodigoOri' idquery="#rsForm.SNcodigoOri#" tabindex="1">
										</cfif>					
									<cfelse>					  
										<cf_sifsociosnegocios2 form="form1" SNcodigo='SNcodigoOri'  tabindex="1">
									</cfif>					
								</td>
								<td>
									<input type="text"
										name="TESOPbeneficiarioSuf" 
										id="TESOPbeneficiarioSuf"
										onfocus="this.select();"
										tabindex="1" 
										size="40"
										maxlength="255"
										value="<cfif  modo NEQ 'ALTA'>#rsForm.TESOPbeneficiarioSuf#</cfif>"
									>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</cfif>

				<tr>
					<td valign="top" align="right">
						<strong>Moneda:&nbsp;</strong>
					</td>
					<td valign="top">
						<cfif  modo NEQ 'ALTA'>
							<cfquery name="rsMoneda" datasource="#session.DSN#">
								select Mcodigo, Mnombre
								from Monedas
								where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.McodigoOri#">
									and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							</cfquery>
							<cfset LvarMnombreSP = rsMoneda.Mnombre>
							<cfif rsForm.TESSPtotalPagarOri GT 0>
								<cf_sifmonedas onChange="asignaTC();" valueTC="#rsForm.TESSPtipoCambioOriManual#" 	
									form="form1" Mcodigo="McodigoOri" query="#rsMoneda#" 
									FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="1" habilita="N">
							<cfelse>
								<cf_sifmonedas onChange="asignaTC();" valueTC="#rsForm.TESSPtipoCambioOriManual#" 
									form="form1" Mcodigo="McodigoOri" query="#rsMoneda#" 
									FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="1">
							</cfif>
						<cfelse>
							<cf_sifmonedas onChange="asignaTC();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" 
								form="form1" Mcodigo="McodigoOri"  tabindex="1">
						</cfif>							
					</td>

					<td rowspan="3" valign="top" align="right" nowrap>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<strong>Observaciones para OP:</strong>
					</td>
					<td rowspan="3" valign="top" valign="top">
						<textarea name="TESOPobservaciones" cols="50" rows="4" tabindex="1" id="TESOPobservaciones"><cfif modo NEQ 'ALTA'>#trim(rsForm.TESOPobservaciones)#</cfif></textarea>
					</td>
				</tr>
				
				<tr>
					<td valign="top" align="right">
						<strong>Tipo de Cambio:&nbsp;</strong>
					</td>
					<td valign="top">
						<input name="TESSPtipoCambioOriManual" 
							id="TESSPtipoCambioOriManual"
							value="<cfif  modo NEQ 'ALTA'>#NumberFormat(rsForm.TESSPtipoCambioOriManual,",0.00")#</cfif>"
							style="text-align:right;"
							onFocus="this.value=qf(this); this.select();" 
							onBlur="javascript: fm(this,4);" 
							onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							tabindex="1"
						>
					</td>
				</tr>

				<tr>
					<td valign="top" align="right" nowrap><strong>Total Pago Solicitado:&nbsp;</strong></td>
					<td valign="top">
						<input type="text" name="TESSPtotalPagarOri"
							readonly="yes"
							value="<cfif  modo NEQ 'ALTA'>#numberFormat(rsForm.TESSPtotalPagarOri,",0.00")#<cfelse>0.00</cfif>"
							style="text-align:right; border:solid 1px ##CCCCCC;"
							tabindex="-1" 
						>
					</td>
				</tr>

				<tr>
					<td valign="top" nowrap align="right">
						<strong>Fecha Pago Solicitado:&nbsp;</strong>
					</td>
					<td valign="top">
						<cfset fechaSol = LSDateFormat(Now(),'dd/mm/yyyy') >
						<cfif modo NEQ 'ALTA'>
							<cfset fechaSol = LSDateFormat(rsForm.TESSPfechaPagar,'dd/mm/yyyy') >
						</cfif>
						<cf_sifcalendario form="form1" value="#fechaSol#" name="TESSPfechaPagar" tabindex="1">
					</td>

					<td valign="top" nowrap align="right">
						<strong>Instrucción al Banco:&nbsp;</strong>
					</td>
					<td>
						<input type="text"
							name="TESOPinstruccion" 
							id="TESOPinstruccion"
							onfocus="this.select();"
							tabindex="1" 
							size="50"
							maxlength="40"
							value="<cfif  modo NEQ 'ALTA'>#rsForm.TESOPinstruccion#</cfif>"
						>
					</td>
				</tr>			

				<tr>
					<td valign="top" nowrap align="right">
						<cfif isdefined("form.chkCancelados")>
							<strong>Motivo Cancelacion:</strong>
						<cfelse>
							<strong>Motivo Rechazo Anterior:&nbsp;</strong>
						</cfif>
					</td>
					<td valign="top">
						<font style="color:##FF0000; font-weight:bold;">
						<cfif modo NEQ "ALTA" and isdefined('rsForm')>
							#rsForm.TESSPmsgRechazo#	
						</cfif>
						</font>
					</td>
				</tr>									

				<tr><td>&nbsp;</td></tr>									
												
				<tr>
					<td colspan="5" class="formButtons" align="center">
						<cfinclude template="TESbtn_Aprobar.cfm">
					</td>
				</tr>
			</table>
			<cfif modo NEQ 'ALTA'>
				<input type="hidden" name="TESSPid" value="#HTMLEditFormat(rsForm.TESSPid)#">
				<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(rsForm.BMUsucodigo)#">
				
				<cfset ts = "">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
					artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#">
			</cfif>
	</form>
	</cfoutput>

	<script type="text/javascript">
	<!--
		function validar(formulario)	{
			if (!btnSelected('Nuevo',document.form1)){
				var error_input;
				var error_msg = '';
	
				if (formulario.cboCFid.value == "") {
					error_msg += "\n - El Centro Funcional no puede quedar en blanco.";
					error_input = formulario.cboCFid;
				}
				
			<cfif LvarTipoAnticipo EQ "POS">
				if (formulario.CDCcodigo.value == "") {
					error_msg += "\n - El Cliente Detallista no puede quedar en blanco.";
						error_input = formulario.CDCcodigo;
				}
			<cfelse>
				if (formulario.SNcodigoOri.value == "") {
					error_msg += "\n - El Socio de Negocios no puede quedar en blanco.";
						error_input = formulario.SNcodigoOri;
				}
			</cfif>

				if (formulario.TESSPfechaPagar.value == "") {
					error_msg += "\n - La Fecha a Pagar no puede quedar en blanco.";
					error_input = formulario.TESSPfechaPagar;
				}

				
				
				if (formulario.McodigoOri.value == "") {
					error_msg += "\n - La Moneda no puede quedar en blanco.";
					error_input = formulario.McodigoOri;
				}				
				
				if (formulario.TESSPtotalPagarOri.value == "") {
					error_msg += "\n - El Monto Total a Pagar no puede quedar en blanco.";
					error_input = formulario.TESSPtotalPagarOri;
				}				

				// Validacion terminada
				if (error_msg.length != "") {
					alert("Por favor revise los siguiente datos:"+error_msg);

					return false;
				}
				
			}
			
			formulario.TESSPtipoCambioOriManual.value = qf(formulario.TESSPtipoCambioOriManual);
			formulario.TESSPtotalPagarOri.value = qf(formulario.TESSPtotalPagarOri);
			
			if(formulario.TESSPtipoCambioOriManual.disabled)
				formulario.TESSPtipoCambioOriManual.disabled = false;
			return true;
	}
		
	/* aquí asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
	function asignaTC() {	
		if (document.form1.McodigoOri.value == "#rsMonedaLocal.Mcodigo#") {		
			formatCurrency(document.form1.TC,2);
			document.form1.TESSPtipoCambioOriManual.disabled = true;			
		}
		else
			document.form1.TESSPtipoCambioOriManual.disabled = false;							
		var estado = document.form1.TESSPtipoCambioOriManual.disabled;
		document.form1.TESSPtipoCambioOriManual.disabled = false;
		document.form1.TESSPtipoCambioOriManual.value = fm(document.form1.TC.value,2);
		document.form1.TESSPtipoCambioOriManual.disabled = estado;
	}
						
	asignaTC();
	
	//-->
	</script>
</cfoutput>


<cfif isdefined('form.TESSPid') and len(trim(form.TESSPid))>
	<table width="100%"  border="0">
	  <tr>
		<td colspan="2"><hr>
		</td>						
	  </tr>
	  <tr>
		<td valign="top" width="50%">
			<cfset LvarIncluyeForm=true>
			<cfinclude template="solicitudesAnticiposDet_lista.cfm">
		</td>
		<td valign="top" width="50%">
	<cfif isdefined('form.TESDPid') and len(trim(form.TESDPid))>
			<cfinclude template="solicitudesAnticiposDet_form.cfm">
	</cfif>
		</td>
	  </tr>
	</table>
</cfif>

<script language="javascript" type="text/javascript">
	<cfif LvarTipoAnticipo EQ "POS">
		document.form1.CDCidentificacion.focus();
	<cfelse>
		document.form1.SNnumero.focus();
	</cfif>
	<cfif isdefined('form.TESDPid') and len(trim(form.TESDPid)) and modo NEQ 'ALTA'>
		document.formDet.TESDPdescripcion.focus();
	</cfif>
</script>
