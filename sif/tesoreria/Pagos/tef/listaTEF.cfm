<script language="javascript" src="/cfmx/sif/js/utilesMonto.js">
</script>

<cfset navegacion = "">
<cf_navegacion name="TESTDreferencia_F">

<cf_navegacion name="TESOPnumero_F"			session>
<cf_navegacion name="TESTDestado_F"		session>
<cf_navegacion name="TESOPbeneficiarioId_F" session>
<cf_navegacion name="TESOPbeneficiario_F"	session>
<cf_navegacion name="EcodigoPago_F"			session>
<cf_navegacion name="Miso4217Pago_F"		session>
<cf_navegacion name="CBidPago_F"			session>
<cf_navegacion name="TESOPfechaEmision_F"	session>
<cf_navegacion name="TESOPfechaPago_F"		session>
<cf_navegacion name="TESOPtotalPago_F"		session>
<cf_navegacion name="OrderBy_F"				session default="C">
<cf_navegacion name="LOTE_F"				session>
<cf_navegacion name="TIPO_F"				session>

<cf_web_portlet_start _start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="top">
				<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
					<cfparam name="irA_filtro" default="#irA#">
					<form name="formFiltro" method="post" action="<cfoutput>#irA_filtro#</cfoutput>" style="margin: '0' ">
						<tr>
							<td nowrap align="right"><strong>Tesorer&iacute;a:</strong>&nbsp;</td>
							<td><cf_cboTESid onchange="this.form.submit();" tabindex="1"></td>
							<td width="23%" align="right" nowrap><strong>Empresa Pago:&nbsp;</strong></td>
							<td width="23%">
								<cf_cboTESEcodigo name="EcodigoPago_F" tabindex="1">
							</td>
							<td width="23%" align="right" nowrap>
								<strong>Moneda Pago:&nbsp;</strong>
							</td>
							<td width="23%">
								<cfquery name="rsMonedas" datasource="#session.DSN#">
									select distinct Miso4217, (select min(Mnombre) from Monedas m2 where m.Miso4217=m2.Miso4217) as Mnombre
									from Monedas m 
										inner join TESempresas e
											 on e.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
											and e.Ecodigo = m.Ecodigo
								</cfquery>
								
								<select name="Miso4217Pago_F" tabindex="1">
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
								<input name="TESOPbeneficiarioId_F" type="text" tabindex="1"
								value="<cfif isdefined('form.TESOPbeneficiarioId_F')>#form.TESOPbeneficiarioId_F#</cfif>" 
								size="22">
							</td>

							<td align="right" nowrap>
								<strong>Cuenta Pago:&nbsp;</strong>
							</td>					
							<td nowrap>
								<cf_cboTESCBid name="CBidPago_F" Ccompuesto="yes" all="yes" onChange="javascript: cambioCB(this);" tabindex="1">
							</td>			

							<td width="9%" nowrap align="right" valign="middle">
								<strong>Pago Hasta:&nbsp;&nbsp;</strong>
							</td>
							<td width="15%" nowrap valign="middle">
								<cfset fechadoc = ''>
								<cfif isdefined('form.TESOPfechaPago_F') and len(trim(form.TESOPfechaPago_F))>
									<cfset fechadoc = LSDateFormat(form.TESOPfechaPago_F,'dd/mm/yyyy') >
								</cfif>
								<cf_sifcalendario form="formFiltro" value="#fechadoc#" name="TESOPfechaPago_F" tabindex="1">												
							</td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>Beneficiario:</strong>&nbsp;</td>
							<td>
								<input name="TESOPbeneficiario_F" type="text" tabindex="1"
								value="<cfif isdefined('form.TESOPbeneficiario_F')>#form.TESOPbeneficiario_F#</cfif>" 
								size="40">
							</td>

							<td align="right" nowrap>
								<strong>Lote:&nbsp;</strong>
							</td>					
							<td nowrap>
								<select name="TIPO_F" 
										onchange="
											if (this.value == 2 || this.value == 3)
											{
												this.form.LOTE_F.style.display = '';
											}
											else
											{
												this.form.LOTE_F.style.value = '';
												this.form.LOTE_F.style.display = 'none';
											}
										"
								>
									<option value=""></option>
									<option value="2" <cfif form.TIPO_F EQ 2> selected</cfif>>TRI</option>
									<option value="3" <cfif form.TIPO_F EQ 3> selected</cfif>>TRE</option>
									<option value="4" <cfif form.TIPO_F EQ 4> selected</cfif>>TRM</option>
									<option value="5" <cfif form.TIPO_F EQ 4> selected</cfif>>TCE</option>
								</select>
								<cf_inputNumber name="LOTE_F" value="#form.LOTE_F#" enteros="18"  codigoNumerico="yes">
							</td>			
							
							<td width="9%" nowrap align="right" valign="middle">
								<strong>Emitido:&nbsp;</strong>
							</td>
							<td width="15%" nowrap valign="middle">
							<cfif isdefined('reimpresion')>
								<strong>#DateFormat(Now(),'DD/MM/YYYY')#</strong>
							<cfelse>
								<cfset fechadoc = ''>
								<cfif isdefined('form.TESTDfechaEmision_F') and len(trim(form.TESTDfechaEmision_F))>
									<cfset fechadoc = LSDateFormat(form.TESTDfechaEmision_F,'dd/mm/yyyy') >
								</cfif>
								<cf_sifcalendario form="formFiltro" value="#fechadoc#" name="TESTDfechaEmision_F" tabindex="1">												
							</cfif>
							</td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>Estado:</strong>&nbsp;</td>
							<td>
								<select name="TESTDestado_F" tabindex="1">
									<option value="1" <cfif form.TESTDestado_F EQ "1"> selected</cfif>>Generado</option>
								</select>
							</td>

							<td align="right" nowrap><strong>Orden Pago:</strong>&nbsp;</td>
							<td>
								<input name="TESOPnumero_F" type="text" tabindex="1"
								value="<cfif isdefined('form.TESOPnumero_F') and LEN(form.TESOPnumero_F) GT 0>#form.TESOPnumero_F#</cfif>" 
								size="22">
							</td>

							<td nowrap align="right"><strong>Monto Pago:</strong>&nbsp;</td>
							<td>
								<input name="TESOPtotalPago_F" type="text" tabindex="1"
									value="<cfif isdefined('form.TESOPtotalPago_F') and LEN(form.TESOPtotalPago_F) GT 0 AND form.TESOPtotalPago_F NEQ "0.00">#numberFormat(replace(form.TESOPtotalPago_F,",","","ALL"),",9.99")#</cfif>" 
									size="20"
									maxlength="20"
									onFocus	= "this.value=qf(this); this.select();" 
									onBlur	= "fm(this,2);" 
									onKeyUp	= "if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
								>
							</td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>Ordenado por:</strong>&nbsp;</td>
							<td>
								<cfparam name="url.OrderBy_F" default="C">
								<cfparam name="form.OrderBy_F" default="#url.OrderBy_F#">
								<select name="OrderBy_F" tabindex="1">
									<option value="C" <cfif form.OrderBy_F EQ "C"> selected</cfif>>Referencia</option>
									<option value="P" <cfif form.OrderBy_F EQ "P"> selected</cfif>>Fecha Pago</option>
									<option value="E" <cfif form.OrderBy_F EQ "E"> selected</cfif>>Fecha Emisión</option>
									<option value="B" <cfif form.OrderBy_F EQ "B"> selected</cfif>>Beneficiario</option>
								</select>
							</td>
							
							<td nowrap align="right"><strong>Referencia:</strong>&nbsp;</td>
							<td>
								<input name="TESTDreferencia_F" type="text" tabindex="1" 
								size="15">
							</td>

							<td align="left" valign="middle" colspan="2">
								<cf_botones tabindex="1" 
									include="Filtrar" 
									includevalues="Filtrar"
									exclude="Cambio,Baja,Nuevo,Alta,Limpiar">
							</td>
						</tr>
					</form>
				</table>
			</td>
		</tr>
		<tr>
			<td>
            	<cfinclude template="../../../Utiles/sifConcat.cfm">
				<cfquery datasource="#session.dsn#" name="lista">
					select  tef.TESid,tef.CBid,tef.TESMPcodigo,tef.TESOPid, 
							tef.TESTDreferencia, 
						   	op.TESOPnumero, 
							op.TESOPfechaPago, tef.TESTDfechaGeneracion, tef.TESTDfechaEmision, op.TESOPfechaEmision, 
							op.TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(op.TESOPbeneficiarioSuf,'') as TESOPbeneficiario, op.TESOPbeneficiarioId, 
							op.TESOPtotalPago, Miso4217 as Moneda,
						   
							case mp.TESTMPtipo
								when 1 then 'CHK'
								when 2 then 'TRI'
								when 3 then 'TRE'
								when 4 then 'TRM'
								when 5 then 'TCE'
							end #_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="tef.TESTLid" isNumeric="XX"> as Lote,
							
   							cb.CBcodigo, b.Bdescripcion,
							
							case mp.TESTMPtipo
								when 5 then 'TARJETA DE CRÉDITO: '
								else 'CUENTA PAGO: ' 
							end #_Cat# m.Miso4217 #_Cat# ' - ' #_Cat# b.Bdescripcion #_Cat# ' - ' #_Cat# cb.CBcodigo as Cuenta,
						<cfif isdefined('reimpresion')>
						   1 as btnCrear,
						</cfif>
						   case TESTDestado
								when 0 then 'En preparacion'
								when 1 then 'Generado'
								when 2 then 'Entregado'
								when 3 then 'Anulado'
							end as Estado
					from TEStransferenciasD tef
	
					inner join CuentasBancos cb 
						inner join Monedas m 
						  on m.Mcodigo = cb.Mcodigo and 
							 m.Ecodigo = cb.Ecodigo 
						inner join Bancos b 
						  on b.Ecodigo	= cb.Ecodigo and 
							 b.Bid 		= cb.Bid 
						inner join Empresas e 
						  on e.Ecodigo 	= cb.Ecodigo
					  on cb.CBid = tef.CBid
					inner join TESmedioPago mp
					  on mp.TESid 		= tef.TESid and
						 mp.CBid 		= tef.CBid and 
						 mp.TESMPcodigo = tef.TESMPcodigo

					left outer join TESordenPago op 
					  on tef.TESOPid = op.TESOPid 
					 
					where tef.TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
				<!--- TIPO DE Transferencia O ESTADOS --->
					  and TESTDestado #estadoTEF#

				<!--- REIMPRESION O FILTRO POR FECHA --->
					<cfif isdefined('reimpresion')>
						and <cf_dbfunction name="Date_Format" args="TESTDfechaEmision,YYYYMMDD"> = '#DateFormat(Now(),'YYYYMMDD')#'
					<cfelseif isdefined('form.TESTDfechaEmision_F') and len(trim(form.TESTDfechaEmision_F))>
						and <cf_dbfunction name="Date_Format" args="TESTDfechaEmision,YYYYMMDD"> = '#DateFormat(LSParseDateTime(form.TESTDfechaEmision_F),'YYYYMMDD')#'
					</cfif>

					<cfif isdefined('form.TESTDreferencia_F') and len(trim(form.TESTDreferencia_F))>
						and tef.TESTDreferencia=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESTDreferencia_F#">
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
					<cfif isdefined('form.TESTDestado_F') and len(trim(form.TESTDestado_F))>
						and TESTDestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESTDestado_F#">
					</cfif>	
					<cfif isdefined('form.TESOPtotalPago_F') and len(trim(form.TESOPtotalPago_F)) AND form.TESOPtotalPago_F NEQ "0.00">
						and TESOPtotalPago = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.TESOPtotalPago_F,",","","ALL")#">
					</cfif>	
					<cfif isdefined('form.TESOPfechaPago_F') and len(trim(form.TESOPfechaPago_F))>
						and TESOPfechaPago <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.TESOPfechaPago_F)#">
					<cfelseif isdefined('entrega')>
						and TESOPfechaPago <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
					</cfif>

					<cfif isdefined('form.TIPO_F') and len(trim(form.TIPO_F))>
						and mp.TESTMPtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TIPO_F#">
					</cfif>	
					<cfif isdefined('form.LOTE_F') and len(trim(form.LOTE_F))>
						and tef.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LOTE_F#">
					</cfif>	

					<cfif isdefined('form.CBidPago_F') and len(trim(form.CBidPago_F)) and form.CBidPago_F NEQ '-1'>
						and tef.CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBidPago_F#">
					<cfelse>
						<cfif isdefined('form.EcodigoPago_F') and len(trim(form.EcodigoPago_F)) and form.EcodigoPago_F NEQ '-1'>
							and cb.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoPago_F#">
						</cfif>						
						<cfif isdefined('form.Miso4217Pago_F') and len(trim(form.Miso4217Pago_F)) and form.Miso4217Pago_F NEQ '-1'>
							and m.Miso4217=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Miso4217Pago_F#">
						</cfif>							
					</cfif>
					<cfif isdefined("GvarAnulacionEspecial")>
							and (
								select count(1)
								  from TESdetallePago
								 where TESOPid = op.TESOPid
								   and TESDPtipoDocumento NOT IN (0,5)
								) = 0
					</cfif>

					order by 
					<cfif form.OrderBy_F eq "C">
						Bdescripcion, CBcodigo, tef.TESTDreferencia
					<cfelseif form.OrderBy_F eq "E">
						TESTDfechaEmision
					<cfelseif form.OrderBy_F eq "P">
						op.TESOPfechaPago
					<cfelseif form.OrderBy_F eq "B">
						TESOPbeneficiario
					</cfif>
				</cfquery>
	
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#lista#"
					cortes="Cuenta"
					desplegar=" Lote ,TESTDreferencia, Estado, TESOPnumero, TESOPfechaPago, TESTDfechaEmision, TESOPbeneficiarioId, TESOPbeneficiario,Moneda,TESOPtotalPago"
					etiquetas="Lote,Referencia, Estado,Num.<BR>Orden,Fecha Pago,Fecha Emisión, Id. Beneficiario, Beneficiario,Moneda<br>Pago,Monto<br>Pago"
					formatos="S,S,S,S,D,D,S,S,S,M"
					align="left, left,left,right,left,left,left,left,right,right"
					form_method="post"
					showEmptyListMsg="yes"
					irA="#irA#"
					keys="TESTDreferencia"
					navegacion="#navegacion#"
				/>		
			</td>
	  	</tr>
	  </cfoutput>
	</table>
<cf_web_portlet_start _end>


<script language="javascript">
	function funcLimpiar(){
		document.formFiltro.TESTDreferencia_F.value = '';
		document.formFiltro.TESOPnumero_F.value = '';
		document.formFiltro.TESOPbeneficiarioId_F.value = '';
		document.formFiltro.TESOPbeneficiario_F.value = '';
	}
	
	function cambioCB(cb){
		if (cb){
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
	}
	cambioCB(document.formFiltro.CBidPago_F);
	document.formFiltro.TESid.focus();
</script>

