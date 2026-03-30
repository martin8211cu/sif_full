<!-- Establecimiento del modo -->
<script src="/cfmx/sif/js/utilesMonto.js"></script>
<cfif LvarTESTILestado EQ "0">
	<cfset LvarAction = "Transferencias.cfm">
<cfelse>
	<cfset LvarAction = "Pagos.cfm">
</cfif>
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif isdefined('Form.NuevoL')>
		<cfset modo="ALTA">
</cfif>

<!-- modo para el detalle -->
<cfif isdefined("Form.TESTIDid")>
	<cfset dmodo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.dmodo")>
		<cfset dmodo="ALTA">
	<cfelseif form.dmodo EQ "CAMBIO">
		<cfset dmodo="CAMBIO">
	<cfelse>
		<cfset dmodo="ALTA">
	</cfif>
</cfif>

<!-- Consultas -->

<cfquery datasource="#Session.DSN#" name="rsEmpresa">
	select Miso4217
	  from Empresas e
	  	inner join Monedas m
			on m.Mcodigo = e.Mcodigo
	 where e.Ecodigo = #session.Ecodigo#
</cfquery>
<cfset LvarMiso4217LOC = rsEmpresa.Miso4217>

<cfif isdefined("Form.TESTILid") and Form.TESTILid NEQ "" >	
	<!-- 1. Lote -->
	<cfquery datasource="#Session.DSN#" name="rsForm">
		select TESTILid, TESid, TESTILtipo, TESTILestado, TESTILdescripcion, TESTILfecha, ts_rversion
		  from TEStransfIntercomL 
		 where TESid=#session.Tesoreria.TESid#
		   and TESTILid=<cfqueryparam value="#form.TESTILid#" cfsqltype="cf_sql_numeric" >
	</cfquery>

	<!--- 3. Cantidad Transferencias --->	
	<cfquery name="rsFormLineas" datasource="#session.DSN#">
		select min(TESTIDid) as TESTIDid, min(CBidOri) as CBid, count(1) as cantidad 
		  from TEStransfIntercomD 
		 where TESid=#session.Tesoreria.TESid#
		   and TESTILid=<cfqueryparam value="#form.TESTILid#" cfsqltype="cf_sql_numeric" >
	</cfquery>
	<cfif LvarTESTILestado EQ "10" AND rsFormLineas.cantidad GT 0>
		<cfset dmodo="CAMBIO">
		<cfset form.TESTIDid = rsFormLineas.TESTIDid>
	</cfif>
	<cfif isdefined("Form.TESTIDid") and Form.TESTIDid NEQ "" >	
		<!--- 1. Form detalle --->
		<cfquery name="rsDForm" datasource="#session.DSN#">
			select TESTILid, TESTIDid, TESTIDdocumento, TESTIDreferencia, TESTIDdescripcion,
					CBidOri, Miso4217Ori, EcodigoOri, TESTIDmontoOri, TESTIDcomisionOri, TESTIDtipoCambioOri,
					TESMPcodigo, 
					CBidDst, Miso4217Dst, EcodigoDst, TESTIDmontoDst, TESTIDtipoCambioDst,
				   	ts_rversion, TESTIDdocumentoDst, TESTIDdescripcionDst, TESTIDreferenciaDst
			  from TEStransfIntercomD 
			 where TESid=#session.Tesoreria.TESid#
			   and TESTILid=<cfqueryparam value="#form.TESTILid#" cfsqltype="cf_sql_numeric" >
			   and TESTIDid=<cfqueryparam value="#form.TESTIDid#" cfsqltype="cf_sql_numeric" >
		</cfquery>
	</cfif> 
</cfif> 


<style>
.Bloqueado {border:none; background-color:#FFFFFF; text-align:right;}
</style>

<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">	


<form 	action   = "Transferencias_sql.cfm" 
        method   = "post" 
        name     = "transferencia"
>
	<cfoutput>
	<input type="hidden" name="TESTILestado" value="#LvarTESTILestado#" />
	</cfoutput>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">

		<!--- ============================================================================================================ --->
		<!---  											Seccion Encabezado   									           --->
		<!--- ============================================================================================================ --->		

	<cfoutput>
		<cfif LvarTESTILestado EQ 0>
			<cfset LvarProceso = "Lote de Registro">
		<cfelse>
			<cfset LvarProceso = "Solicitud de Pago">
		</cfif>
		<cfif MODO EQ "ALTA">
		<tr>
			<td class="tituloAlterno" colspan="8">#LvarProceso# de Transferencias Bancarias</td>
		</tr>
		<cfelseif rsForm.TESTILtipo EQ 0>
		<tr>
			<td class="tituloAlterno" colspan="8">#LvarProceso# de Transferencias Bancarias Internas</td>
		</tr>
		<tr>
			<td class="tituloAlterno" style="font-size:11px" colspan="8">(Únicamente Cuentas de una misma Empresa)</td>
		</tr>
		<cfelseif rsForm.TESTILtipo EQ 1>
		<tr>
			<td class="tituloAlterno" colspan="8">#LvarProceso# de Transferencias Bancarias Intercompañía</td>
		</tr>
		<tr>
			<td class="tituloAlterno" style="font-size:11px" colspan="8">(Aumenta las CxP y CxC Intercompañía)</td>
		</tr>
		<cfelseif rsForm.TESTILtipo EQ 2>
		<tr>
			<td class="tituloAlterno" colspan="8">#LvarProceso# de Transferencias Bancarias Intercompañía para Devolución</td>
		</tr>
		<tr>
			<td class="tituloAlterno" style="font-size:11px" colspan="8">(Disminuye las CxP y CxC Intercompañía)</td>
		</tr>
		</cfif>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</cfoutput>
		<tr>
			<td align="right">Tipo:&nbsp;</td>
			<cfoutput>
	<cfif modo eq 'ALTA'>
		<cfset fecha = LSDateFormat(Now(),'DD/MM/YYYY')>
			<td>
				<select name="TESTILtipo">
					<option value="0">Transferencias internas (Cuentas Bancarias de una misma empresa)</option>
					<option value="1">Transferencias intercompañías (Aumentan las CxC y CxP intercompañías)</option>
					<option value="2">Transferencias intercompañías para devolución (Disminuyen las CxC y CxP)</option>
				</select>
			</td>	
	<cfelse>
		<cfset fecha = LSDateFormat(rsForm.TESTILfecha,'DD/MM/YYYY')>
			<td>
				<input type="hidden" name="TESTILtipo" value="#rsForm.TESTILtipo#">
				<cfif rsForm.TESTILtipo EQ 0>
					<strong>Transferencias internas</strong>
				<cfelseif rsForm.TESTILtipo EQ 1>
					<strong>Transferencias intercompañías</strong>
				<cfelseif rsForm.TESTILtipo EQ 2>
					<strong>Transferencias intercompañías para devolución</strong>
				</cfif>
			</td>	
	</cfif>
			</cfoutput>
			<cfif LvarTESTILestado EQ 10>
				<td align="right">Fecha Solicitada:&nbsp;</td>
			<cfelse>
				<td align="right">Fecha:&nbsp;</td>
			</cfif>
			<cfoutput>
			<cfif modo neq 'ALTA'><cfset fecha = LSDateFormat(rsForm.TESTILfecha,'DD/MM/YYYY')><cfelse><cfset fecha = LSDateFormat(Now(),'DD/MM/YYYY')></cfif>
			<td>
				<cf_sifcalendario form="transferencia" name="TESTILfecha" value="#fecha#" tabindex="1">
			</td>	
			</cfoutput>
		</tr>
		<tr>	
			<td align="right">Descripci&oacute;n:&nbsp;</td>
			<td>
				<input name="TESTILdescripcion" id="TESTILdescripcion" type="text"  size="60" maxlength="255" tabindex="1"
					value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsForm.TESTILdescripcion#</cfoutput></cfif>" alt="La Descripci&oacute;n" 
					onfocus="javascript:this.select();">
			</td>
		</tr>

		<tr>
			<td>
			<cfset ts = "">	
			<cfif modo neq "ALTA">
				<cfinvoke 
					component="sif.Componentes.DButils"
					method="toTimeStamp"
					returnvariable="ts">
					<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
				</cfinvoke>
			</cfif>
				<input type="hidden" name="ts_rversion" value="<cfif modo  NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
			<cfif modo neq 'ALTA'>
				<input type="hidden" name="TESTILid" value="<cfoutput>#rsForm.TESTILid#</cfoutput>">
			</cfif>
			</td>
		</tr>

		
		<!--- ============================================================================================================ --->
		<!---   											Seccion Detalle   									           --->
		<!--- ============================================================================================================ --->		

		<cfif modo neq 'ALTA' >
			<tr>
				<td>&nbsp;</td>
			</tr>
			<cfoutput>
			<cfif LvarTESTILestado EQ 0>
				<tr>
					<td class="tituloAlterno" colspan="8">Detalle Documentos de Transferencia Bancaria</td>
				</tr>
				<tr>
					<td colspan="8">
						<table width="100%" border="0" cellpadding="1" cellspacing="0">
							<tr><td colspan="8">&nbsp;</td></tr>
							<tr>
								<td align="right">Documento:&nbsp;</td>
								<td>
									<input name="TESTIDdocumento" type="text" size="20" maxlength="20" tabindex="1" id="TESTIDdocumento"
										 value="<cfif dmodo neq 'ALTA'>#trim(rsDForm.TESTIDdocumento)#</cfif>"  alt="Numero de Documento" onfocus="javascript:this.select(); LvarTempV = this.value;" onblur="fnVerificarValor('TESTIDdocumentoDst',this.value);">
								</td>
								
								<td nowrap align="left">
									<!--- <input 	type="text"
											size="3" class="Bloqueado" readonly="yes" tabindex="-1"> --->
									Referencia:&nbsp;
									<input name="TESTIDreferencia" type="text" size="25" maxlength="25" tabindex="1"
										value="<cfif dmodo neq 'ALTA'>#rsDForm.TESTIDreferencia#</cfif>"  alt="Referencia del Documento" onfocus="javascript:this.select(); LvarTempV = this.value;" onblur="fnVerificarValor('TESTIDreferenciaDst',this.value);" >
								</td>
								<td align="right">Descripción:&nbsp;</td>
								<td align="left" colspan="4">
									<!--- <input 	type="text"	size="3" class="Bloqueado" readonly="yes" tabindex="-1"> --->
									<input name="TESTIDdescripcion" type="text" size="50" maxlength="50"  tabindex="1"
										value="<cfif dmodo neq 'ALTA'>#rsDForm.TESTIDdescripcion#</cfif>"  alt="Descripcion del Documento" onfocus="javascript:this.select(); LvarTempV = this.value;" onblur="fnVerificarValor('TESTIDdescripcionDst',this.value);" >
								</td>
							</tr>
						<tr>
							<cfif dmodo neq 'ALTA'><cfset cuentaorigen = rsDForm.CBidOri><cfelse><cfset cuentaorigen = "-1"></cfif>
							<td nowrap align="right">Cuenta Origen:&nbsp;</td>
			<cfelse>
				<tr>
					<td class="tituloAlterno" colspan="8">Cuenta Bancaria Origen</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td colspan="8">
						<input type="hidden" name="TESTIDdocumento"		id="TESTIDdocumento" 	value="SP" />
						<input type="hidden" name="TESTIDreferencia"	id="TESTIDreferencia" 	value="OP" />
						<input type="hidden" name="TESTIDdescripcion"	id="TESTIDdescripcion" 	value="Proceso de Pagos: #rsForm.TESTILdescripcion#" />
						<table width="100%" border="0" cellpadding="1" cellspacing="0">
						<tr>
							<cfif dmodo neq 'ALTA'><cfset cuentaorigen = rsDForm.CBidOri><cfelse><cfset cuentaorigen = "-1"></cfif>
							<td nowrap align="right">Cuenta de Pago:&nbsp;</td>
			</cfif>
							<td colspan="7">
								<cf_cboTESCBid name="CBidOri" value="#cuentaorigen#" Dcompuesto="yes" Ccompuesto="yes" none="yes" tabindex="1"
									onchange="sbCBid('Ori');">
							</td>
						</tr>
			<cfif LvarTESTILestado EQ 10>
						<tr>
							<td nowrap align="right">Medio de Pago:&nbsp;</td>
							<td colspan="7">
							<cfset session.tesoreria.TESMPcodigo = "">
							<cfif cuentaorigen EQ "-1">
								<input type="hidden" name="TESMPcodigo" tabindex="-1">
							<cfelse>
								<cf_cboTESMPcodigo name="TESMPcodigo" value="#rsDForm.TESMPcodigo#" CBid="CBidOri" CBidValue="#cuentaorigen#" onChange="GvarCambiado=true; sbTESMPcodigoChange(this);" NoChks="true">
							</cfif>
							<input type="text" id="T_CTAS" style="width:500px;border:none;">
							</td>
							<td>&nbsp;</td>
						</tr>	
			</cfif>
						<tr>
							<td>&nbsp;</td>
							<td align="right">Monto Origen:&nbsp;</td>
							<td>
								<input 	type="text" name="Miso4217Ori" id="Miso4217Ori"
										value="<cfif dmodo neq 'ALTA'>#rsDForm.Miso4217Ori#</cfif>" 
										size="3" class="Bloqueado" readonly="yes" tabindex="-1">
								<input 	type="text" name="TESTIDmontoOri" id="TESTIDmontoOri" tabindex="1"
										value="<cfif dmodo neq 'ALTA'>#LSCurrencyFormat(rsDForm.TESTIDmontoOri, 'none')#<cfelse>0.00</cfif>"
										size="18" maxlength="18" style="text-align: right;" 
										onFocus="this.value=qf(this); this.select();" 
										onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
										onBlur="javascript: sbCambioMontos(); fm(this,2);" 
								>
							</td>
							<td nowrap align="right">Tipo de Cambio:&nbsp;</td>
							<td>
								<!--- <input 	type="text"
										size="3" class="Bloqueado" readonly="yes" tabindex="-1"> --->
								<input 	type="text" name="TESTIDtipoCambioOri" id="TESTIDtipoCambioOri" tabindex="1"
										value="<cfif dmodo neq 'ALTA'>#LSNumberFormat(rsDForm.TESTIDtipoCambioOri, '9.9999')#<cfelse>0.0000</cfif>" 
										size="18" maxlength="18" style="text-align:right;" 
										onFocus="this.value=qf(this); this.select();" 
										onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
										onBlur="javascript: sbCambioMontos(); fm(this,4);" 
								>
							</td>
							<td nowrap align="right">Local Origen:&nbsp;</td>
							<td>
								<input 	type="text" name="Miso4217Loc1" id="Miso4217Loc1" 
										value="#LvarMiso4217LOC#" 
										size="3" class="Bloqueado" readonly="yes" tabindex="-1">
							</td>
							<td>
								<input 	type="text" name="LocalOri" id="LocalOri" 
										value="<cfif dmodo neq 'ALTA'>#LSCurrencyFormat(rsDForm.TESTIDmontoOri*rsDForm.TESTIDtipoCambioOri, 'none')#<cfelse>0.00</cfif>" 
										size="18" maxlength="18" class="Bloqueado" readonly="yes" tabindex="-1"
								>
							</td>
						</tr>
			<cfif LvarTESTILestado EQ 0>
						<tr>
							<td>&nbsp;</td>
							<td align="right">Comisi&oacute;n Origen:&nbsp;</td>
							<td colspan="6">
								<input 	type="text" name="Miso4217Ori2" id="Miso4217Ori2"
										value="<cfif dmodo neq 'ALTA'>#rsDForm.Miso4217Ori#</cfif>" 
										size="3" class="Bloqueado" readonly="yes" tabindex="-1">
								<input 	type="text" name="TESTIDcomisionOri" id="TESTIDcomisionOri" tabindex="1"
										value="<cfif dmodo neq 'ALTA'>#LSCurrencyFormat(rsDForm.TESTIDcomisionOri, 'none')#<cfelse>0.00</cfif>" 
										size="18" maxlength="18" style="text-align: right;" 
										onFocus="this.value=qf(this); this.select();" 
										onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
										onBlur="javascript: sbCambioMontos(); fm(this,2);" 
								>
							</td>
						</tr>
			<cfelse>
						<tr>
							<td>
								<input 	type="hidden" name="Miso4217Ori2" id="Miso4217Ori2"
										value="<cfif dmodo neq 'ALTA'>#rsDForm.Miso4217Ori#</cfif>"  />
								<input 	type="hidden" name="TESTIDcomisionOri" id="TESTIDcomisionOri" value="0" />
							</td>
						</tr>
			</cfif>
						<tr>
							<td>&nbsp;</td>
							<td align="right">Total Debitado:&nbsp;</td>
							<td colspan="6">
								<input 	type="text" name="Miso4217Ori3" id="Miso4217Ori3" 
										value="<cfif dmodo neq 'ALTA'>#rsDForm.Miso4217Ori#</cfif>" 
										size="3" class="Bloqueado" readonly="yes" tabindex="-1">
								<input 	type="text" name="Tdebitar" id="Tdebitar" 
										value="<cfif dmodo neq 'ALTA'>#LSCurrencyFormat(rsDForm.TESTIDmontoOri+rsDForm.TESTIDcomisionOri, 'none')#<cfelse>0.00</cfif>" 
										size="18" maxlength="18" class="Bloqueado" readonly="yes" tabindex="-1"
								>
							</td>
						</tr>
						<tr><td colspan="8">&nbsp;</td></tr>
			<cfif LvarTESTILestado EQ 10>
			<tr>
				<td class="tituloAlterno" colspan="8">Cuenta Bancaria Destino</td>
			</tr>
			</cfif>
						<tr><td colspan="8">&nbsp;</td></tr>
                        <tr>
								<td align="right" nowrap>Documento Destino:&nbsp;</td>
								<td>
									<input name="TESTIDdocumentoDst" type="text" size="20" maxlength="20" tabindex="1" id="TESTIDdocumentoDst" value="<cfif dmodo neq 'ALTA'>#trim(rsDForm.TESTIDdocumentoDst)#</cfif>"  alt="Numero de Documento" onfocus="javascript:this.select();">
								</td>
								
								<td nowrap align="left">Referencia Destino:&nbsp;
									<input name="TESTIDreferenciaDst" type="text" size="25" maxlength="25" tabindex="1" id="TESTIDreferenciaDst" value="<cfif dmodo neq 'ALTA'>#rsDForm.TESTIDreferenciaDst#</cfif>"  alt="Referencia del Documento" onfocus="javascript:this.select();" >
								</td>
								<td align="right" nowrap>Descripción Destino:&nbsp;</td>
								<td align="left" colspan="4">
									<input name="TESTIDdescripcionDst" type="text" size="50" maxlength="50"  tabindex="1" id="TESTIDdescripcionDst" value="<cfif dmodo neq 'ALTA'>#rsDForm.TESTIDdescripcionDst#</cfif>"  alt="Descripcion del Documento" onfocus="javascript:this.select();" >
								</td>
							</tr>
						<tr>
							<cfif dmodo neq 'ALTA' ><cfset cuentadestino = rsDForm.CBidDst><cfelse><cfset cuentadestino = "-1"></cfif>
							<td nowrap  valign="baseline" align="right">Cuenta Destino:&nbsp;</td>						
							<td colspan="7">
								<cf_cboTESCBid name="CBidDst" value="#cuentadestino#" Dcompuesto="yes" Ccompuesto="yes" none="yes" 
									tabindex="1"
									onchange="sbCBid('Dst');" destino="true">
							</td>
						</tr>

						<tr>
							<td>&nbsp;</td>
							<td align="right">Monto Destino:&nbsp;</td>
							<td>
								<input 	type="text" name="Miso4217Dst" id="Miso4217Dst" 
										value="<cfif dmodo neq 'ALTA'>#rsDForm.Miso4217Dst#</cfif>" 
										size="3" class="Bloqueado" readonly="yes" tabindex="-1">
								<input 	type="text" name="TESTIDmontoDst" id="TESTIDmontoDst"  tabindex="1"
										value="<cfif dmodo neq 'ALTA'>#LSCurrencyFormat(rsDForm.TESTIDmontoDst, 'none')#<cfelse>0.00</cfif>"
										size="18" maxlength="18" style="text-align: right;" 
										onFocus="this.value=qf(this); this.select();" 
										onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
										onBlur="javascript: sbCambioMontos(); fm(this,2);" 
								>
							</td>
							<td nowrap align="right">Tipo de Cambio:&nbsp;</td>
							<td>
								<!--- <input 	type="text" 
										size="3" class="Bloqueado" readonly="yes" tabindex="-1"
								> --->
								<input 	type="text" name="TESTIDtipoCambioDst" id="TESTIDtipoCambioDst" 
										value="<cfif dmodo neq 'ALTA'>#LSNumberFormat(rsDForm.TESTIDtipoCambioDst, '9.99999999')#<cfelse>0.00000000</cfif>" 
										size="18" class="Bloqueado" readonly="yes" tabindex="-1"
								>
							</td>
							<td nowrap align="right">Local Destino:&nbsp;</td>
							<td>
								<input 	type="text" name="Miso4217Loc2" id="Miso4217Loc2" 
										value="#LvarMiso4217LOC#" 
										size="3" class="Bloqueado" readonly="yes" tabindex="-1">
							</td>
							<td>
								<input 	type="text" name="LocalDst" id="LocalDst" 
										value="<cfif dmodo neq 'ALTA'>#LSCurrencyFormat(rsDForm.TESTIDmontoDst * rsDForm.TESTIDtipoCambioDst, 'none')#<cfelse>0.00</cfif>" 
										size="18" class="Bloqueado" readonly="yes" tabindex="-1"
								>
							</td>
						</tr>

						<cfset dts = "">	
						<cfif dmodo neq "ALTA">
							<cfinvoke 
								component="sif.Componentes.DButils"
								method="toTimeStamp"
								returnvariable="dts">
								<cfinvokeargument name="arTimeStamp" value="#rsDForm.ts_rversion#"/>
							</cfinvoke>
						</cfif>
					</table>
					<input type="hidden" name="dtimestamp" value="<cfif dmodo NEQ 'ALTA'><cfoutput>#dts#</cfoutput></cfif>">
					<input type="hidden" name="TESTIDid"       value="<cfif dmodo NEQ 'ALTA'><cfoutput>#rsDForm.TESTIDid#</cfoutput></cfif>">
					<input type="hidden" name="DTmontolocal" value="">
					<input type="hidden" name="DTmontocomloc" value="">
					<input type="hidden" name="TESTIDtipoCambioDst" value="">
					</cfoutput>
				</td>
			</tr>
		</cfif>			
		<!--- ============================================================================================================ --->
		<!---  											Botones													           --->
		<!--- ============================================================================================================ --->		

		<tr><td>&nbsp;</td></tr>
		<!-- Caso 1: Alta de Encabezados -->
		<cfif modo EQ 'ALTA'>
			<tr>
				<td align="center" valign="baseline" colspan="8">
					<input type="submit" name="btnAgregarE" value="Agregar" onClick="return fnValidar('E');" tabindex="1">
					<input type="reset"  name="btnLimpiar"  value="Limpiar" tabindex="1">
					<input type="button" value="Ir a Lista" onClick="location.href='<cfoutput>#LvarAction#</cfoutput>'" tabindex="1">
				</td>	
			</tr>
		</cfif>
		
		<!-- Caso 2: Cambio de Encabezados / Alta de detalles -->		
		<cfif modo NEQ 'ALTA' and dmodo EQ 'ALTA' >
			<tr>
				<td align="center" valign="baseline" colspan="8">
				<cfoutput>
				<cfif LvarTESTILestado EQ 0>
					<input type="submit" name="btnAgregarD"  value="Agregar" onClick="return fnValidar('D');" tabindex="1">
					<input type="submit" name="btnBorrarE"   value="Borrar Lote" tabindex="1">
					<cfif rsFormLineas.Cantidad GT 0>
						<input type="submit" name="btnAplicar"  value="Aplicar"              tabindex="1">					
					</cfif>
				<cfelseif LvarTESTILestado EQ 10>
					<input type="submit" name="btnAgregarD"  value="Cambiar" onClick="return fnValidar('D');" tabindex="1">
					<input type="submit" name="btnBorrarE"   value="Borrar" tabindex="1">
					<cfif rsFormLineas.Cantidad EQ 1 AND rsDForm.TESMPcodigo NEQ "">
						<input type="submit" name="btnGenerarOP"  id="generarOP" value="Generar OP"              tabindex="1"
							onclick="if (document.getElementById('TESMPcodigo').value == '') {alert('Debe escoger un Medio de Pago'); return false;}"
					</cfif>
				</cfif>
				</cfoutput>
					<input type="reset"  name="btnLimpiar"   value="Limpiar" tabindex="1">
					<input type="button" value="Ir a Lista" onClick="location.href='<cfoutput>#LvarAction#</cfoutput>'" tabindex="1">
                    <input type="button" value="Imprimir" 	onClick="funcImprime()" tabindex="1">
				</td>	
			</tr>
		</cfif>
		
		<!-- Caso 3: Cambio de Encabezados / Cambio de detalle -->		
		<cfif modo NEQ 'ALTA' and dmodo NEQ 'ALTA' >
			<tr>
				<td align="center" valign="baseline" colspan="8">
					<input type="submit" name="btnCambiarD" value="Cambiar" onClick="return fnValidar('D');" tabindex="1">
				<cfif LvarTESTILestado EQ 0>
					<input type="submit" name="btnBorrarD"  value="Borrar L&iacute;nea"   tabindex="1">
					<input type="submit" name="btnBorrarE"  value="Borrar Lote"  tabindex="1">
					<input type="submit" name="btnNuevoD"   value="Nueva L&iacute;nea"    tabindex="1">
					<input type="submit" name="btnAplicar"  value="Aplicar"              tabindex="1">					
				<cfelseif LvarTESTILestado EQ 10 AND rsDForm.TESMPcodigo NEQ "">
					<input type="submit" name="btnGenerarOP"  id="generarOP" value="Generar OP"              tabindex="1"
						onclick="if (document.getElementById('TESMPcodigo').value == '') {alert('Debe escoger un Medio de Pago'); return false;}"
					>
				</cfif>
					<input type="reset"  name="btnLimpiar"  value="Limpiar"  tabindex="1">				
					<input type="button" value="Ir a Lista" onClick="location.href='<cfoutput>#LvarAction#</cfoutput>'" tabindex="1">
					<input type="button" value="Imprimir" 	onClick="funcImprime()" tabindex="1">
				</td>	
			</tr>
		</cfif>
		<!-- ============================================================================================================ -->
		<!-- ============================================================================================================ -->		
		<tr><td><input type="hidden" name="botonSel" value=""></td></tr>
	</table>
</form>

<cfif LvarTESTILestado EQ 0>
	<table width="100%">
		<tr> 
			<td align="center" colspan="8">
			<div align="center"> 
			<cfif isdefined('Form.TESTILid') and Form.TESTILid NEQ "">
				<cfquery name="rsListaDet" datasource="#session.DSN#">
					select t.TESid, t.TESTILid, t.TESTIDid, t.TESTIDdocumento as doc
							, eo.Edescripcion as EmpOri, co.CBcodigo as CtaOri, t.Miso4217Ori as MonOri, t.TESTIDmontoOri as MntOri
							, ed.Edescripcion as EmpDst, cd.CBcodigo as CtaDst, t.Miso4217Dst as MonDst, t.TESTIDmontoDst as MntDst
                            ,TESTIDcomisionOri
					  from TEStransfIntercomD t
						inner join Empresas eo
							 on eo.Ecodigo = t.EcodigoOri
					  	inner join CuentasBancos co
							 on co.CBid = t.CBidOri
						inner join Empresas ed
							 on ed.Ecodigo = t.EcodigoDst
					  	inner join CuentasBancos cd
							 on cd.CBid = t.CBidDst
					 where TESid 	  = #session.Tesoreria.TESid#
					   and TESTILid	  = <cfqueryparam value="#form.TESTILid#" cfsqltype="cf_sql_numeric" >
                       and co.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit" >
                       and cd.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit" >
				</cfquery>

				<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsListaDet#"/>
					<cfinvokeargument name="desplegar" value="doc, EmpOri, CtaOri, MntOri, MonOri,TESTIDcomisionOri, EmpDst, CtaDst, MntDst, MonDst"/>
					<cfinvokeargument name="etiquetas" value="Documento, Empresa Origen, Cuenta Ori, Monto Origen, ,Comision Origen , Empresa Destino, Cuenta Dst, Monto Destino,"/>
					<cfinvokeargument name="formatos" value="S, S, S, M, S, M, S, S, M, S"/>
					<cfinvokeargument name="align" value="right, left, left, right, left, right, left, left, right, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="n"/>
					<cfinvokeargument name="irA" value="#LvarAction#"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys" value="TESid,TESTILid,TESTIDid"/>
				</cfinvoke>
			</cfif>
			</div>
			</td>
		</tr>
	</table>
</cfif>
	<iframe name="ifTipoCambio" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>
		<cf_web_portlet_end>
<script language="JavaScript" type="text/JavaScript">
	var GvarFocus;
	var LvarTempV;
	function fnValidar (pTipo)
	{
		var LvarMSG = "";
		GvarFocus = true;

		LvarMSG += fnValida ("TESTILfecha", "Fecha del Lote");
		LvarMSG += fnValida ("TESTILdescripcion", "Descripcion del Lote");

		if (pTipo == "D")
		{
			LvarMSG += fnValida ("TESTIDdocumento", "El Numero de Documento");
			LvarMSG += fnValida ("TESTIDdocumentoDst", "El Numero de Documento Destino");
	
			LvarMSG += fnValida ("CBidOri", "La Cuenta Bancaria Origen");
			LvarMSG += fnValida ("TESTIDmontoOri", "El Monto Origen", true);
			LvarMSG += fnValida ("TESTIDcomisionOri", "La Comision Origen");
			LvarMSG += fnValida ("TESTIDtipoCambioOri", "El Tipo de Cambio Origen", true);
	
			LvarMSG += fnValida ("CBidDst", "La Cuenta Bancaria Destino");
			LvarMSG += fnValida ("TESTIDmontoDst", "El Monto Destino", true);
			
			var LvarOri = document.getElementById("CBidOri").value.split(",");
			var LvarDst = document.getElementById("CBidDst").value.split(",");
			if (LvarOri[0] == LvarDst[0])
			{
				if (GvarFocus)
					document.getElementById("CBidDst").focus();
				LvarMSG += "\n\t- Las Cuentas Origen y Destino no pueden ser iguales";
			}
		<cfif modo neq "ALTA" AND rsForm.TESTILtipo EQ "0">
			if (LvarOri[1] != LvarDst[1])
			{
				if (GvarFocus)
					document.getElementById("CBidDst").focus();
				LvarMSG += "\n\t- Las Cuentas Origen y Destino deben pertenecer a la misma empresa";
			}
		</cfif>
		<cfif LvarTESTILestado EQ 10>
			if (LvarOri[2] != LvarDst[2])
			{
				if (GvarFocus)
					document.getElementById("CBidDst").focus();
				LvarMSG += "\n\t- Las Cuentas Origen y Destino deben estar en la misma moneda";
			}
		</cfif>
		}
				
		if (LvarMSG == "")
			return true;
		
		alert("Se encontraron los siguientes Errores: " + LvarMSG);
		return false;
	}

	function fnValida (pID, pDescripcion, pRechazarCero)
	{
		var LvarObj = document.getElementById(pID);
		var LvarVal = LvarObj.value;
		var LvarMSG2 = "";
		
		if (LvarVal == "")
			LvarMSG2 = pDescripcion + " no puede quedar en Blanco";
		else if (pRechazarCero)
			if (parseFloat(LvarVal) == 0)
				LvarMSG2 = pDescripcion + " no puede quedar en Cero";
		
		if (LvarMSG2 != "")
		{
			if (GvarFocus)
				LvarObj.focus();
			GvarFocus = false;
			return "\n\t- " + LvarMSG2;
		}
		else
			return "";
	}

	function sbCBid (Tipo)
	{
		var LvarValue = document.getElementById("CBid" + Tipo).value;
		var LvarCBid = "";
		var LvarISO = "";
		if (LvarValue != "")
		{
			LvarCBid= LvarValue.split(",")[0];
			LvarISO	= LvarValue.split(",")[2];
		}
		document.getElementById("Miso4217" + Tipo).value = LvarISO;
		if (document.getElementById("Miso4217" + Tipo + "2"))
			document.getElementById("Miso4217" + Tipo + "2").value = LvarISO;
		if (document.getElementById("Miso4217" + Tipo + "3"))
			document.getElementById("Miso4217" + Tipo + "3").value = LvarISO;

	<cfif modo neq "ALTA" AND LvarTESTILestado EQ 10>
		if (Tipo == 'Ori')
		{
			if (document.getElementById("TESMPcodigo"))
				document.getElementById("TESMPcodigo").style.display = (LvarCBid == "<cfoutput>#cuentaorigen#</cfoutput>")?'':'none';
			if (document.getElementById("generarOP"))
				document.getElementById("generarOP").style.display = (LvarCBid == "<cfoutput>#cuentaorigen#</cfoutput>")?'':'none';
		}
	</cfif>
		sbCambioMontos();
	}

	function sbTESMPcodigoChange(o)
	{
	<cfif modo neq "ALTA" AND LvarTESTILestado EQ 10>
		if (document.getElementById("generarOP"))
			document.getElementById("generarOP").style.display = 'none';
	</cfif>
	}

	function sbCambioMontos ()
	{
		if (document.getElementById("Miso4217Ori").value == '<cfoutput>#LvarMiso4217LOC#</cfoutput>')
			document.getElementById("TESTIDtipoCambioOri").value = '1.0000';
		if (document.getElementById("Miso4217Ori").value != "" && document.getElementById("Miso4217Ori").value == document.getElementById("Miso4217Dst").value)
		{
			document.getElementById("TESTIDtipoCambioDst").value = fm(document.getElementById("TESTIDtipoCambioOri").value,4);
			document.getElementById("TESTIDmontoDst").value = fm(document.getElementById("TESTIDmontoOri").value,2);
		}
			
		var LvarMontoOri = document.getElementById("TESTIDmontoOri").value;
		var LvarComisionOri = document.getElementById("TESTIDcomisionOri").value;
		var LvarTipoCambioOri = document.getElementById("TESTIDtipoCambioOri").value;

		if (LvarMontoOri == "")
			LvarMontoOri = 0;
		else
			LvarMontoOri = parseFloat(qf(LvarMontoOri));

		if (LvarComisionOri == "")
			LvarComisionOri = 0;
		else
			LvarComisionOri = parseFloat(qf(LvarComisionOri));
			
		if (LvarTipoCambioOri == "")
			LvarTipoCambioOri = 0;
		else
			LvarTipoCambioOri = parseFloat(qf(LvarTipoCambioOri));

		document.getElementById("LocalOri").value = fm((LvarMontoOri*LvarTipoCambioOri),2);
		document.getElementById("Tdebitar").value = fm((LvarMontoOri + LvarComisionOri),2);

		if (document.getElementById("Miso4217Dst").value == '<cfoutput>#LvarMiso4217LOC#</cfoutput>')
			document.getElementById("TESTIDmontoDst").value = fm((LvarMontoOri*LvarTipoCambioOri),2);

		var LvarMontoDst = document.getElementById("TESTIDmontoDst").value;
		var LvarTipoCambioDst = document.getElementById("TESTIDtipoCambioDst").value;

		if (LvarMontoDst == "")
			LvarMontoDst = 0;
		else
			LvarMontoDst = parseFloat(qf(LvarMontoDst));

		var LvarTipoCambioDst = 0;
		if (LvarMontoDst != 0)
			LvarTipoCambioDst = (LvarMontoOri * LvarTipoCambioOri) / LvarMontoDst;
		document.getElementById("TESTIDtipoCambioDst").value = fm((LvarTipoCambioDst),8);
<!---alert(LvarMontoDst*LvarTipoCambioDst);--->
		document.getElementById("LocalDst").value = fm(LvarMontoDst*LvarTipoCambioDst,2);
		<!---alert(document.getElementById("LocalDst").value);--->
	}
	
	function tcambio(obj){
		if ( fmd(obj) ){
			<cfif modo neq 'ALTA'>
				if (obj.value != ""){
					document.all['ifTipoCambio'].src="/cfmx/sif/mb/operacion/tipocambio.cfm?eMcodigo=" + document.transferencia.eMcodigo.value +
																					  "&oMcodigo=" + document.transferencia.oMcodigo.value +
																					  "&fecha=" + obj.value;
				}
			</cfif>
		}
		return;	
	}
	
	function fnVerificarValor(E,vO){
		vD = document.getElementById(E).value;
		if(vD == LvarTempV)
			document.getElementById(E).value = vO;
	}
	function funcImprime(){
		<cfoutput>
		var PARAM  = "TransferenciasImprime.cfm?TESTILid=#form.TESTILid#"
		</cfoutput>
		window.open(PARAM,'','left=250,top=250,scrollbars=yes,resizable=yes,width=800,height=600')
		return false;
	}
// ============================================================================		
	document.transferencia.TESTILfecha.focus();		
</script>