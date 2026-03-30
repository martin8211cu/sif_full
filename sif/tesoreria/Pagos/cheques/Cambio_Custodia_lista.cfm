<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 16 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Consulta de cheques
			Reimpresion cheques 
			Retencion cheques
			Entrega cheques
----------->
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="top">
				<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
					<form name="formFiltro" method="post" action="#irA#" style="margin: '0' ">
						<tr>
							<td nowrap align="right"><strong>Trabajar con Tesorer&iacute;a:</strong>&nbsp;</td>
							<td><cf_cboTESid onchange="this.form.submit();"></td>
							<td width="23%" align="right"><strong>Empresa Pago:</strong></td>
							<td width="23%">
								<cf_cboTESEcodigo name="EcodigoPago_F">
							</td>
							<td width="23%" align="right" nowrap>
								<strong>Moneda Pago:</strong>
							</td>
							<td width="23%">
								<cfquery name="rsMonedas" datasource="#session.DSN#">
									select distinct Miso4217, (select min(Mnombre) from Monedas m2 where m.Miso4217=m2.Miso4217) as Mnombre
									from Monedas m 
										inner join TESempresas e
											 on e.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
											and e.Ecodigo = m.Ecodigo
								</cfquery>
								
								<select name="Miso4217Pago_F">
									<option value="">(Todas las monedas)</option>
									<cfoutput query="rsMonedas">
										<option value="#Miso4217#" <cfif isdefined('form.Miso4217Pago_F') and len(trim(form.Miso4217Pago_F)) and form.Miso4217Pago_F EQ Miso4217>selected</cfif>>#Mnombre#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<cfoutput>
						<tr>
								<td align="right" nowrap><strong>Id. Beneficiario:</strong>&nbsp;</td>
								<td>
									<input name="TESOPbeneficiarioId_F" type="text" 
									value="<cfif isdefined('form.TESOPbeneficiarioId_F')>#form.TESOPbeneficiarioId_F#</cfif>" 
									size="22">
								</td>
								<td align="right" nowrap>
								<strong>Cuenta Pago:</strong>
							</td>					
							<td>
								<cf_cboTESCBid name="CBidPago_F" Ccompuesto="yes" all="yes" onChange="javascript: cambioCB(this);">
							</td>			
							<td width="9%" nowrap align="right" valign="middle">
								<strong>Fecha Pago:</strong>
							</td>
							<td width="15%" nowrap valign="middle">
								<cfset fechadoc = ''>
								<cfif isdefined('form.TESOPfechaPago_F') and len(trim(form.TESOPfechaPago_F))>
									<cfset fechadoc = LSDateFormat(form.TESOPfechaPago_F,'dd/mm/yyyy') >
								</cfif>
								<cf_sifcalendario form="formFiltro" value="#fechadoc#" name="TESOPfechaPago_F">												
							</td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>Beneficiario:</strong>&nbsp;</td>
							<td>
								<input name="TESOPbeneficiario_F" type="text" 
								value="<cfif isdefined('form.TESOPbeneficiario_F')>#form.TESOPbeneficiario_F#</cfif>" 
								size="50">
							</td>
							<td align="right" nowrap><strong>N° Orden de Pago:</strong>&nbsp;</td>
							<td>
								<input name="TESOPnumero_F" type="text" 
								value="<cfif isdefined('form.TESOPnumero_F') and LEN(form.TESOPnumero_F) GT 0>#form.TESOPnumero_F#</cfif>" 
								size="22">
							</td>
							<td nowrap align="right"><strong>N° de Cheque:</strong>&nbsp;</td>
							<td>
								<input name="TESCFDnumFormulario_F" type="text" 
								value="<cfif isdefined('form.TESCFDnumFormulario_F') and LEN(form.TESCFDnumFormulario_F) GT 0>#form.TESCFDnumFormulario_F#</cfif>" 
								size="15">
							</td>
							<td align="center" valign="middle">
								<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
								<!--- <input name="btnLimpiar" type="button" value="Limpiar" onClick="javascript: funcLimpiar();"> --->
							</td>
						</tr>
					</form>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<cfset navegacion = "">
				<cfif isdefined("Form.TESCFDnumFormulario_F") and Len(Trim(Form.TESCFDnumFormulario_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "TESCFDnumFormulario_F=" & Form.TESCFDnumFormulario_F>
				</cfif>		
				<cfif isdefined("Form.TESOPnumero_F") and Len(Trim(Form.TESOPnumero_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "TESOPnumero_F=" & Form.TESOPnumero_F>
				</cfif>						
				<cfif isdefined("Form.TESOPbeneficiarioId_F") and Len(Trim(Form.TESOPbeneficiarioId_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "TESOPbeneficiarioId_F=" & Form.TESOPbeneficiarioId_F>
				</cfif>						
				<cfif isdefined("Form.TESOPbeneficiario_F") and Len(Trim(Form.TESOPbeneficiario_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "TESOPbeneficiario_F=" & Form.TESOPbeneficiario_F>
				</cfif>					
				<cfif isdefined("Form.EcodigoPago_F") and Len(Trim(Form.EcodigoPago_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EcodigoPago_F=" & Form.EcodigoPago_F>
				</cfif>					
				<cfif isdefined("Form.Miso4217Pago_F") and Len(Trim(Form.Miso4217Pago_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Miso4217Pago_F=" & Form.Miso4217Pago_F>
				</cfif>					
				<cfif isdefined("Form.CBidPago_F") and Len(Trim(Form.CBidPago_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CBidPago_F=" & Form.CBidPago_F>
				</cfif>
				<cfquery datasource="#session.dsn#" name="lista">
					select cf.TESid,cf.CBid,cf.TESMPcodigo,cf.TESOPid, cf.TESCFDnumFormulario, cf.TESCFDfechaEmision,
						   op.TESOPnumero, op.TESOPbeneficiario,op.TESOPbeneficiarioId, op.TESOPtotalPago, cb.CBcodigo, Mnombre,
						   op.TESOPfechaPago, 
						   case TESCFDestado
								when 0 then 'En preparacion'
								when 1 then 'Impreso'
								when 2 then 'Entregado'
								when 3 then 'Anulado'
							end as Estado
					from TEScontrolFormulariosD cf 
					
						inner join TEScontrolFormulariosB cfb
							 on cfb.TESid          = cf.TESid 
							and cfb.CBid           = cf.CBid
							and cfb.TESMPcodigo    = cf.TESMPcodigo
							and cfb.TESCFDnumFormulario = cf.TESCFDnumFormulario
							and cfb.TESCFBultimo = 1
							 and cfb.UsucodigoCustodio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"><!--- --->
	
						left join TEScuentasBancos tcb 
						  on cf.TESid = tcb.TESid and
							 cf.CBid = tcb.CBid
						left join CuentasBancos cb 
						  on tcb.CBid = cb.CBid
						left join Monedas m 
						  on m.Mcodigo = cb.Mcodigo and 
							 m.Ecodigo = cb.Ecodigo 
						left join Bancos b 
						  on b.Ecodigo = cb.Ecodigo and 
							 b.Bid = cb.Bid 
						left outer join TESordenPago op 
						  on cf.TESOPid = op.TESOPid 
						left join Empresas e 
						  on op.EcodigoPago = e.Ecodigo 
						 
						left join TESmedioPago mp
						  on mp.TESid = cf.TESid and
							 mp.CBid = cf.CBid and 
							 mp.TESMPcodigo = cf.TESMPcodigo
							
					where cf.TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
                      and coalesce(cb.CBesTCE,0) = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		
					  and TESCFDestado #tipoCheque#
					<cfif isdefined('form.TESCFDnumFormulario_F') and len(trim(form.TESCFDnumFormulario_F))>
						and cf.TESCFDnumFormulario=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDnumFormulario_F#">
					</cfif>
					<cfif isdefined('form.TESOPnumero_F') and len(trim(form.TESOPnumero_F))>
						and op.TESOPnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPnumero_F#">
					</cfif>				
					<cfif isdefined('form.TESOPbeneficiarioId_F') and len(trim(form.TESOPbeneficiarioId_F))>
						and upper(TESOPbeneficiarioId) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(form.TESOPbeneficiarioId_F))#%">
					</cfif>	
					<cfif isdefined('form.TESOPbeneficiario_F') and len(trim(form.TESOPbeneficiario_F))>
						and upper(TESOPbeneficiario) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(form.TESOPbeneficiario_F))#%">
					</cfif>	
					<cfif isdefined('form.TESOPfechaPago_F') and len(trim(form.TESOPfechaPago_F))>
						and TESOPfechaPago >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.TESOPfechaPago_F)#">
					<cfelseif isdefined('entrega')>
						and TESOPfechaPago <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					</cfif>

					<cfif isdefined('form.CBidPago_F') and len(trim(form.CBidPago_F)) and form.CBidPago_F NEQ '-1'>
						and CBidPago=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBidPago_F#">
					<cfelse>
						<cfif isdefined('form.EcodigoPago_F') and len(trim(form.EcodigoPago_F)) and form.EcodigoPago_F NEQ '-1'>
							and op.EcodigoPago=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoPago_F#">
						</cfif>						
						<cfif isdefined('form.Miso4217Pago_F') and len(trim(form.Miso4217Pago_F)) and form.Miso4217Pago_F NEQ '-1'>
							and m.Miso4217=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Miso4217Pago_F#">
						</cfif>							
					</cfif>				
					<cfif isdefined('reimpresion')>
						and TESCFDfechaEmision  = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Now(),'mm/dd/yyyy')#">
					</cfif>
					order by op.TESOPfechaPago
				</cfquery>
	
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#lista#"
					desplegar=" CBcodigo,TESCFDnumFormulario, Estado, TESOPnumero, TESOPfechaPago, TESOPbeneficiarioId, TESOPbeneficiario,  TESOPtotalPago, Mnombre"
					etiquetas=" Cuenta Pago, N° Cheque, Estado, N° Orden, Fecha Pago, Id. Beneficiario, Beneficiario,  Monto a Pagar,Moneda Pago"
					formatos="S,S,S,S,D,S,S,M,S"
					align="left,center,left,center,left,left,left,right,center"
					form_method="post"
					showEmptyListMsg="yes"
					irA="#irA#"
					keys="TESCFDnumFormulario"
					navegacion="#navegacion#"
				/>		
			</td>
	  	</tr>
	  </cfoutput>
	</table>
	<cf_web_portlet_end>


<script language="javascript">
	function funcLimpiar(){
		document.formFiltro.TESCFDnumFormulario_F.value = '';
		document.formFiltro.TESOPnumero_F.value = '';
		document.formFiltro.TESOPbeneficiarioId_F.value = '';
		document.formFiltro.TESOPbeneficiario_F.value = '';
	}
	
	function cambioCB(cb){
		if(cb.value != ""){
			var LvarCodigos = "";
			var LvarCbo = null;
			
			//document.formFiltro.EcodigoPago_F.disabled = true;
			//document.formFiltro.Miso4217Pago_F.disabled = true;
			LvarCodigos = cb.value.split(",");
			
			LvarCbo = document.formFiltro.EcodigoPago_F;
			LvarCbo.disabled = true;
			for (var i=0; i<LvarCbo.options.length; i++)
			{
				if (LvarCbo.options[i].value == LvarCodigos[1])
				{
				  LvarCbo.selectedIndex = i;
				  break;
				}
			}

			LvarCbo = document.formFiltro.Miso4217Pago_F;
			LvarCbo.disabled = true;
			for (var i=0; i<LvarCbo.options.length; i++)
			{
				if (LvarCbo.options[i].value == LvarCodigos[2])
				{
				  LvarCbo.selectedIndex = i;
				  break;
				}
			}
		}else{
			document.formFiltro.EcodigoPago_F.disabled = false;
			document.formFiltro.Miso4217Pago_F.disabled = false;
		}
	}
	cambioCB(document.formFiltro.CBidPago_F);
</script>
