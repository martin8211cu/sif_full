<cf_navegacion name="CBid">
<cf_navegacion name="TESMPcodigo">
<cf_navegacion name="TESCFTnumInicial">

<script src="/cfmx/sif/js/utilesMonto.js"></script>

<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined("form.CBid") and isdefined("form.TESMPcodigo")
		AND form.CBid NEQ "" AND form.TESMPcodigo NEQ "" >
	<cfset MODO = "CAMBIO">
<cfelse>
	<cfset MODO = "ALTA">
</cfif>

<cfif modo NEQ 'ALTA'>
	<cfif isdefined("form.CBid") and isdefined("form.TESMPcodigo") and isdefined("form.TESCFTnumInicial")
			AND form.CBid NEQ "" AND form.TESMPcodigo NEQ "" AND form.TESCFTnumInicial NEQ "">
		<cfset MODODET = "CAMBIO">
	<cfelse>
		<cfset MODODET = "ALTA">
	</cfif>
	<cfquery datasource="#session.dsn#" name="rsEncab">
		select 	cb.CBcodigo,
				b.Bdescripcion,
				m.Miso4217,
				mp.TESMPcodigo,
				mp.TESMPdescripcion,
				mp.FMT01COD,
				tmp.TESTMPdescripcion,
				e.Edescripcion

		 from TESmedioPago mp
		 	inner join CuentasBancos cb
				inner join Monedas m
					on m.Mcodigo = cb.Mcodigo
				inner join Empresas e
					on e.Ecodigo = cb.Ecodigo
				inner join Bancos b
					on b.Bid = cb.Bid
				on cb.CBid = mp.CBid
			inner join TEStipoMedioPago tmp
				on tmp.TESTMPtipo = mp.TESTMPtipo
		where mp.TESid = #session.Tesoreria.TESid#
		  and mp.CBid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
		  and mp.TESMPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
          and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
	</cfquery>
	
	<table>
		<tr>
			<td>
				<strong>Empresa de Pago:</strong>
			</td>
			<td>
				<cfoutput>
				#rsEncab.Edescripcion#
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td>
				<strong>Banco:</strong>
			</td>
			<td>
				<cfoutput>
				#rsEncab.Bdescripcion#
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td>
				<strong>Moneda:</strong>
			</td>
			<td>
				<cfoutput>
				#rsEncab.Miso4217#
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td>
				<strong>Cuenta de Pago:</strong>
			</td>
			<td>
				<cfoutput>
				#rsEncab.CBcodigo#
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td><strong>Medio de Pago:</strong>
			</td>
			<td>
				<cfoutput>
				#rsEncab.TESMPcodigo# - #rsEncab.TESMPdescripcion#
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td><strong>Tipo Medio de Pago:</strong>
			</td>
			<td>
				<cfoutput>
				#rsEncab.TESTMPdescripcion#
				</cfoutput>
			</td>
		</tr>
	</table>
	<BR>

	<cfquery datasource="#session.dsn#" name="listadet">
		select 	CBid, TESMPcodigo, TESCFTnumInicial, TESCFTnumFinal, TESCFTultimo
		 from TEScontrolFormulariosT
		where TESid = #session.Tesoreria.TESid#
		  and CBid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
		  and TESMPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
	</cfquery>

	

	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#listadet#"
		desplegar="TESCFTnumInicial, TESCFTnumFinal, TESCFTultimo"
		etiquetas="Consecutivo Inicial,Consecutivo Final,Ultimo Consecutivo"
		formatos="I,I,I"
		align="right,right,right"
		ajustar="S"
		formname="formDet"
		pageindex="32"
		ira="controlFormulariosT.cfm?CBid=#form.CBid#&TESMPcodigo=#form.TESMPcodigo#"
		navegacion="#navegacion#"
		keys="CBid, TESMPcodigo, TESCFTnumInicial"
		showEmptyListMsg="yes"
		MaxRows="20"
		EmptyListMsg="--- No se existen Bloques de Formularios definidos ---"
	/>		

	<cfif ModoDet NEQ "ALTA">
		<cfquery datasource="#session.dsn#" name="rsForm">
			select 	TESCFTnumInicial, TESCFTnumFinal, TESCFTultimo, ts_rversion
			 from TEScontrolFormulariosT
			where TESid = #session.Tesoreria.TESid#
			  and CBid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			  and TESMPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
			  and TESCFTnumInicial = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFTnumInicial#">
		</cfquery>
	</cfif>

	<script language="javascript">
		function fnValidar(f)
		{
			var LvarValidar = (f.botonSel.value == 'Alta' || f.botonSel.value == 'Cambio');
	
			if (LvarValidar)
			{
				if (f.TESCFTnumInicial.value == "" || parseInt(f.TESCFTnumInicial.value) == 0)
				{
					alert('El Número de consecutivo Inicial no puede quedar en blanco o en cero');
					f.TESCFTnumInicial.focus();
					return false;
				}
				if (f.TESCFTnumFinal.value == "" || parseInt(f.TESCFTnumFinal.value) == 0)
				{
					alert('El Número de consecutivo Final no puede quedar en blanco o en cero');
					f.TESCFTnumFinal.focus();
					return false;
				}
				if (f.TESCFTultimo.value == "")
				{
					alert('El Último consecutivo Utilizado no puede quedar en blanco');
					f.TESCFTnumFinal.focus();
					return false;
				}
				if (parseFloat(f.TESCFTnumFinal.value) < parseFloat(f.TESCFTnumInicial.value))
				{
					alert('El Número de consecutivo Final no puede ser menor que el Inicial');
					f.TESCFTnumFinal.focus();
					return false;
				}
				if (parseFloat(f.TESCFTultimo.value) != 0 && (parseFloat(f.TESCFTultimo.value) < parseFloat(f.TESCFTnumInicial.value) || parseFloat(f.TESCFTultimo.value) > parseFloat(f.TESCFTnumFinal.value)))
				{
					alert('El Último consecutivo Utilizado debe estar entre el Consecutivo Inicial y Final');
					f.TESCFTultimo.focus();
					return false;
				}
				if (parseFloat(f.TESCFTultimo.value) > 0)
				{
					return (confirm("Si indica un Último consecutivo utilizado el bloque quedará en Control Activo y no podrá modificarlo después, ¿desea continuar?"));
				}
			}
			return true;
		}
		document.frmTES.TESid.focus();

	</script>
	<form name="form1" action="controlFormulariosT_sql.cfm" method="post" onSubmit="return fnValidar(this);">
	<cfoutput>
	<input type="hidden" name="CBid" value="#Form.CBid#">
	<input type="hidden" name="TESMPcodigo" value="#Form.TESMPcodigo#">
	</cfoutput>
	<table>
			<tr>
				<td width="50%">
					<strong>Número Consecutivo Inicial:</strong>
				</td>
				<td width="50%">
					<cfoutput>
					<input 	name="TESCFTnumInicial" id="TESCFTnumInicial" size="10" 
						<cfif modoDet EQ 'ALTA' OR rsForm.TESCFTultimo EQ 0>
							style="text-align:right;" tabindex="1"
						<cfelse>
							style="text-align:right;border:solid 1px ##CCCCCC" tabindex="-1" readonly
						</cfif>
						<cfif modoDet NEQ "ALTA">value="#rsForm.TESCFTnumInicial#"</cfif>
							onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);" onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
					>
					</cfoutput>
				</td>
			</tr>
			<tr>
				<td>
					<strong>Número Consecutivo Final:</strong>
				</td>
				<td>
					<cfoutput>
					<input name="TESCFTnumFinal" id="TESCFTnumFinal" size="10" 
						<cfif modoDet EQ 'ALTA' OR rsForm.TESCFTultimo EQ 0>
							style="text-align:right;" tabindex="1"
						<cfelse>
							style="text-align:right;border:solid 1px ##CCCCCC" tabindex="-1" readonly
						</cfif>
						<cfif modoDet NEQ "ALTA">value="#rsForm.TESCFTnumFinal#"</cfif>
							onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);" onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
					>
					</cfoutput>
				</td>
			</tr>
			<tr>
				<td>
					<strong>Último Consecutivo Utilizado:</strong>
				</td>
				<td nowrap="nowrap">
					<cfoutput>
					<input name="TESCFTultimo" id="TESCFTultimo" size="10" 
						<cfif modoDet EQ 'ALTA' OR rsForm.TESCFTultimo EQ 0>
							style="text-align:right;" tabindex="1"
						<cfelse>
							style="text-align:right;border:solid 1px ##CCCCCC" tabindex="-1" readonly
						</cfif>
						<cfif modoDet NEQ "ALTA">value="#rsForm.TESCFTultimo#"<cfelse>value="0"</cfif>
							onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);" onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
					>
					</cfoutput>
					(CERO = Ninguno utilizado)
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<cfif modoDet NEQ 'ALTA'>
						<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
							artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
						</cfinvoke>
						<cfoutput>
						<input type="hidden" name="ts_rversion" value="#ts#">
						</cfoutput>
						<cfif rsForm.TESCFTultimo EQ 0>
							<cf_botones modo="#ModoDet#" tabindex="1">
						<cfelseif rsForm.TESCFTultimo LT rsForm.TESCFTnumFinal>
							<cfoutput>
							<input type="submit" value="Dividir" name="btnDividir"
									onClick="return fnDividir();"
							>
							Del <span style="border:solid 1px ##CCCCCC">&nbsp;#rsForm.TESCFTnumInicial#</span> hasta 
							<input name="TESCFThastaNuevo" id="TESCFThastaNuevo" size="10" 
									style="text-align:right;" tabindex="1"
									onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);" onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}} ; fnDividiendo();"
							>, 
							y del 
							<input name="TESCFTdesdeNuevo" id="TESCFTdesdeNuevo" size="10" 
								style="text-align:right;border:solid 1px ##CCCCCC" tabindex="-1" readonly
							>
							hasta el <span style="border:solid 1px ##CCCCCC">&nbsp;#rsForm.TESCFTnumFinal#</span>
							<script language="javascript">
								function fnDividir()
								{
									var LvarHastaN = new Number(document.getElementById("TESCFThastaNuevo").value);
									var LvarDesdeN = new Number(document.getElementById("TESCFTdesdeNuevo").value);
									
									LvarDesdeN.value = "";
									
									if (LvarHastaN == 0)
									{
										alert ("Debe digitar el Número Consecutivo Final del PRIMER bloque");
										return false;
									}
									else if (LvarHastaN <= #rsForm.TESCFTultimo#)
									{
										alert ("El Número Consecutivo Final del PRIMER bloque debe ser mayor que #rsForm.TESCFTultimo#");
										return false;
									}
									else if (LvarHastaN >= #rsForm.TESCFTnumFinal#)
									{
										alert ("El Número Consecutivo Final del PRIMER bloque debe ser menor que #rsForm.TESCFTnumFinal#");
										return false;
									}

									return confirm ("¿Desea dividir el bloque en 2:\n\t#rsForm.TESCFTnumInicial# - " + LvarHastaN + "\n\t" + LvarDesdeN + " - #rsForm.TESCFTnumFinal#?");
								}
								function fnDividiendo()
								{
									var LvarHastaN = new Number(document.getElementById("TESCFThastaNuevo").value);
									var LvarDesdeN = document.getElementById("TESCFTdesdeNuevo");
									
									LvarDesdeN.value = "";
									
									if (LvarHastaN > #rsForm.TESCFTultimo# && LvarHastaN < #rsForm.TESCFTnumFinal#)
									{
										LvarDesdeN.value = (LvarHastaN+1);
									}
									return;
								}
							</script>
							</cfoutput>
						</cfif>
					<cfelse>
						<cf_botones modo="#ModoDet#" tabindex="1">
					</cfif>
					<BR>
				</td>
			</tr>
			<tr>
				<td colspan="3" align="center">
					<cfif modo NEQ 'ALTA'>
						<cfoutput>
						<img src="/cfmx/sif/ad/catalogos/formatos/flash-FMT01imgfpre.cfm?FMT01COD=#rsEncab.FMT01COD#" width="400">
						</cfoutput>
					</cfif>
				</td>
			</tr>
	
		</table>
	</form>
	<BR>
</cfif>
