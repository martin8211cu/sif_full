<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 16 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Consulta de cheques
			Reimpresion cheques 
			Retencion cheques
			Entrega cheques
	
	Modificado por: Ana Villavicencio
	Fecha de modificación: 04 de julio del 2005
	Motivo:	En los datos de la lista se agregó el banco al q pertenece el cheque
----------->
<script language="javascript" src="/cfmx/sif/js/utilesMonto.js">
</script>

<cfset navegacion = "">
<cf_navegacion name="TESCFDnumFormulario_F">
<cf_navegacion name="TESOPnumero_F"			session>
<cf_navegacion name="TESCFDestado_F"		session>
<cf_navegacion name="TESOPbeneficiarioId_F" session>
<cf_navegacion name="TESOPbeneficiario_F"	session>
<cf_navegacion name="EcodigoPago_F"			session>
<cf_navegacion name="Miso4217Pago_F"		session>
<cf_navegacion name="CBidPago_F"			session>
<cf_navegacion name="TESOPfechaEmision_F"	session>
<cf_navegacion name="TESOPfechaPago_F"		session>
<cf_navegacion name="TESOPtotalPago_F"		session>
<cf_navegacion name="OrderBy_F"				session default="C">
<cf_navegacion name="TESCFLUid"				session>

<!---1.Verificacion de la tesoreria, cargando la variable--->

<cfquery name="rsTES" datasource="#session.dsn#">
	Select e.TESid, t.EcodigoAdm
	  from TESempresas e
	  	inner join Tesoreria t
			on t.TESid = e.TESid
	 where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif rsTES.recordCount EQ 0>
	<cfset Request.Error.Backs = 1>
	<cf_errorCode	code = "50798" msg = "ESTA EMPRESA NO HA SIDO INCLUIDA EN NINGUNA TESORERÍA">
</cfif>
<cfset session.Tesoreria.TESid = rsTES.TESid>
<cfset session.Tesoreria.EcodigoAdm = rsTES.EcodigoAdm>

<!---►►Valor del Combo del Filtro para Custodiado por◄◄--->
<cfquery name="rsLugares" datasource="#session.DSN#">
	select TESid, TESCFLUid, TESCFLUdescripcion
	from TESCFlugares
		where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
</cfquery>

<!---►►Valor del Combo del Filtro para Razón◄◄--->
<cfquery name="rsEstados" datasource="#session.DSN#">
	select TESid, TESCFEid, TESCFEdescripcion, BMUsucodigo, ts_rversion, TESCFEimpreso, TESCFEentregado, TESCFEanulado
	from TESCFestados
	where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		and TESCFEimpreso = 0 
		and TESCFEentregado = 0 
		and TESCFEanulado = 0
</cfquery>

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

							<td colspan="2"></td>
							
							<td width="9%" nowrap align="right" valign="middle">
								<strong>Emitido:&nbsp;</strong>
							</td>
							<td width="15%" nowrap valign="middle">
							<cfif isdefined('reimpresion')>
								<strong>#DateFormat(Now(),'DD/MM/YYYY')#</strong>
							<cfelse>
								<cfset fechadoc = ''>
								<cfif isdefined('form.TESCFDfechaEmision_F') and len(trim(form.TESCFDfechaEmision_F))>
									<cfset fechadoc = LSDateFormat(form.TESCFDfechaEmision_F,'dd/mm/yyyy') >
								</cfif>
								<cf_sifcalendario form="formFiltro" value="#fechadoc#" name="TESCFDfechaEmision_F" tabindex="1">												
							</cfif>
							</td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>Estado:</strong>&nbsp;</td>
							<td>
								<select name="TESCFDestado_F" tabindex="1">
									<option value="">(Cualquier estado)</option>
									<option value="0" <cfif form.TESCFDestado_F EQ "0"> selected</cfif>>En preparacion</option>
									<option value="1" <cfif form.TESCFDestado_F EQ "1"> selected</cfif>>Impreso</option>
									<option value="2" <cfif form.TESCFDestado_F EQ "2"> selected</cfif>>Entregado</option>
									<option value="3" <cfif form.TESCFDestado_F EQ "3"> selected</cfif>>Anulado</option>
								</select>
							</td>

							<td align="right" nowrap><strong>Orden Pago:</strong>&nbsp;</td>
							<td>
								<input name="TESOPnumero_F" type="text" tabindex="1"
								value="<cfif isdefined('form.TESOPnumero_F') and LEN(form.TESOPnumero_F) GT 0>#form.TESOPnumero_F#</cfif>" 
								size="22">
							</td>

							<td nowrap align="right"><strong>Monto Cheque:</strong>&nbsp;</td>
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
									<option value="C" <cfif form.OrderBy_F EQ "C"> selected</cfif>>Numero Cheque</option>
									<option value="P" <cfif form.OrderBy_F EQ "P"> selected</cfif>>Fecha Pago</option>
									<option value="E" <cfif form.OrderBy_F EQ "E"> selected</cfif>>Fecha Emisión</option>
									<option value="B" <cfif form.OrderBy_F EQ "B"> selected</cfif>>Beneficiario</option>
								</select>
							</td>
							
							<td nowrap align="right"><strong>N° de Cheque:</strong>&nbsp;</td>
							<td>
								<input name="TESCFDnumFormulario_F" type="text" tabindex="1" 
								size="15">
							</td>

							<td align="left" valign="middle" colspan="2" rowspan="2">
								<cf_botones tabindex="1" 
									include="Filtrar,Imprimir" 
									includevalues="Filtrar,Imprimir"
									exclude="Cambio,Baja,Nuevo,Alta,Limpiar">
							</td>
						</tr>
                         <tr>
                            <td align="right" nowrap><strong>Custodiado en:</strong></td>
                            <td>
                            	<select name="TESCFLUid" tabindex="1">
                                    <option value="">(Todos)</option>
                                    <cfloop query="rsLugares">
                                        <option value="#TESCFLUid#" <cfif isdefined('form.TESCFLUid') and form.TESCFLUid EQ rsLugares.TESCFLUid>selected</cfif>>#rsLugares.TESCFLUdescripcion#</option>
                                    </cfloop>
                                </select>
                            </td>
                            <td align="right" nowrap><strong>Razón:</strong></td>
                            <td>
                            	<select name="TESCFEid" tabindex="1">
                                    <option value="">(Todas)</option>
                                    <cfloop query="rsEstados">
                                        <option value="#TESCFEid#" <cfif isdefined('form.TESCFEid') and form.TESCFEid EQ rsEstados.TESCFEid>selected</cfif>>#rsEstados.TESCFEdescripcion#</option>
                                    </cfloop>
                                </select>
                            </td>
                        <tr>
					</form>
				</table>
			</td>
		</tr>
		<tr>
			<td>
            	<cfinclude template="../../../Utiles/sifConcat.cfm">
				<cfquery datasource="#session.dsn#" name="lista" maxrows="5000">
					select cf.TESid,cf.CBid,cf.TESMPcodigo,cf.TESOPid, 
							cf.TESCFDnumFormulario, 
						   	op.TESOPnumero, 
							op.TESOPfechaPago, cf.TESCFDfechaGeneracion, cf.TESCFDfechaEmision, op.TESOPfechaEmision, 
							op.TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(op.TESOPbeneficiarioSuf,'') as TESOPbeneficiario, op.TESOPbeneficiarioId, 
							op.TESOPtotalPago, Miso4217 as Moneda,
						     
   							cb.CBcodigo, b.Bdescripcion,
							'CUENTA PAGO: ' #_Cat# cb.CBcodigo #_Cat# ' - ' #_Cat# b.Bdescripcion as Cuenta,
						<cfif isdefined('reimpresion')>
						   1 as btnCrear,
						</cfif>
						   case TESCFDestado
								when 0 then 'En preparacion'
								when 1 then 'Impreso'
								when 2 then 'Entregado'
								when 3 then 
									case when TESCFLidReimpresion is null 
										then 'Anulado'
										else 'Anul.Reimpr.'
									end
							end as Estado
					from TEScontrolFormulariosD cf 
	
					inner join CuentasBancos cb 
						inner join Monedas m 
						  on m.Mcodigo = cb.Mcodigo and 
							 m.Ecodigo = cb.Ecodigo 
						inner join Bancos b 
						  on b.Ecodigo	= cb.Ecodigo and 
							 b.Bid 		= cb.Bid 
						inner join Empresas e 
						  on e.Ecodigo 	= cb.Ecodigo
					  on cb.CBid = cf.CBid
					inner join TESmedioPago mp
					  on mp.TESid 		= cf.TESid and
						 mp.CBid 		= cf.CBid and 
						 mp.TESMPcodigo = cf.TESMPcodigo

					left outer join TESordenPago op 
					  on cf.TESOPid = op.TESOPid 
					 
				<!--- POR USUARIO QUE TIENE LA ULTIMA CUSTODIA --->
					<cfif isdefined('custodia')>
					inner join TEScontrolFormulariosB cfb
						 on cfb.TESid				= cf.TESid 
						and cfb.CBid				= cf.CBid
						and cfb.TESMPcodigo			= cf.TESMPcodigo
						and cfb.TESCFDnumFormulario	= cf.TESCFDnumFormulario
						and cfb.TESCFBultimo		= 1
						and cfb.UsucodigoCustodio	= #session.Usucodigo#
					</cfif>
						
					where cf.TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
				<!--- TIPO DE CHEQUE O ESTADOS --->
					  and TESCFDestado #tipoCheque#
                      and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		

				<!--- REIMPRESION O FILTRO POR FECHA --->
					<cfif isdefined('reimpresion')>
						and <cf_dbfunction name="Date_Format" args="TESCFDfechaEmision,YYYYMMDD"> = '#DateFormat(Now(),'YYYYMMDD')#'
					<cfelseif isdefined('form.TESCFDfechaEmision_F') and len(trim(form.TESCFDfechaEmision_F))>
						and <cf_dbfunction name="Date_Format" args="TESCFDfechaEmision,YYYYMMDD"> = '#DateFormat(LSParseDateTime(form.TESCFDfechaEmision_F),'YYYYMMDD')#'
					</cfif>

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
					<cfif isdefined('form.TESCFDestado_F') and len(trim(form.TESCFDestado_F))>
						and TESCFDestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESCFDestado_F#">
					</cfif>	
					<cfif isdefined('form.TESOPtotalPago_F') and len(trim(form.TESOPtotalPago_F)) AND form.TESOPtotalPago_F NEQ "0.00">
						and TESOPtotalPago = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.TESOPtotalPago_F,",","","ALL")#">
					</cfif>	
					<cfif isdefined('form.TESOPfechaPago_F') and len(trim(form.TESOPfechaPago_F))>
						and TESOPfechaPago <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.TESOPfechaPago_F)#">
					<cfelseif isdefined('entrega')>
						and TESOPfechaPago <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
					</cfif>

					<cfif isdefined('form.CBidPago_F') and len(trim(form.CBidPago_F)) and form.CBidPago_F NEQ '-1'>
						and cf.CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBidPago_F#">
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
								   and TESDPtipoDocumento NOT IN (0,5,1)
								) = 0
					</cfif>
                    <!---►►Filtro de Custodiado por◄◄--->
                    <cfif isdefined('form.TESCFLUid') and LEN(TRIM(form.TESCFLUid))>
                    		and (select count(1)
                            		from TEScontrolFormulariosB bitacC
                                    where bitacC.TESid					= cf.TESid 
                                      and bitacC.CBid					= cf.CBid
                                      and bitacC.TESMPcodigo			= cf.TESMPcodigo
                                      and bitacC.TESCFDnumFormulario	= cf.TESCFDnumFormulario
                                      and bitacC.TESCFBultimo			= 1
                                      and bitacC.TESCFLUid 			    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLUid#">) > 0
					</cfif>
                    <!---►►Filtro de Razon◄◄--->
                     <cfif isdefined('form.TESCFEid') and LEN(TRIM(form.TESCFEid))>
                    		and (select count(1)
                            		from TEScontrolFormulariosB bitacR
                                    where bitacR.TESid					= cf.TESid 
                                      and bitacR.CBid					= cf.CBid
                                      and bitacR.TESMPcodigo			= cf.TESMPcodigo
                                      and bitacR.TESCFDnumFormulario	= cf.TESCFDnumFormulario
                                      and bitacR.TESCFBultimo			= 1
                                      and bitacR.TESCFEid 			    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFEid#">) > 0
					</cfif>
					
					order by 
					<cfif form.OrderBy_F eq "C">
						Bdescripcion,CBcodigo, cf.TESCFDnumFormulario
					<cfelseif form.OrderBy_F eq "E">
						TESCFDfechaEmision
					<cfelseif form.OrderBy_F eq "P">
						op.TESOPfechaPago
					<cfelseif form.OrderBy_F eq "B">
						TESOPbeneficiario
					</cfif>
				</cfquery>
	
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#lista#"
					cortes="Cuenta"
					desplegar=" TESCFDnumFormulario, Estado, TESOPnumero, TESOPfechaPago, TESCFDfechaEmision, TESOPbeneficiarioId, TESOPbeneficiario,Moneda,TESOPtotalPago"
					etiquetas="Cheque, Estado,Num.<BR>Orden,Fecha Pago,Fecha Emisión, Id. Beneficiario, Beneficiario,Moneda<br>Pago,Monto<br>Pago"
					formatos="S,S,S,D,D,S,S,S,M"
					align="right,left,right,left,left,left,left,right,right"
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
<cf_web_portlet_start _end>


<script language="javascript">
	function funcLimpiar(){
		document.formFiltro.TESCFDnumFormulario_F.value = '';
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
	
	function funcImprimir()
	{//imprimir-listaCheques.cfm
		document.formFiltro.action="imprimir-listaCheques.cfm";
		document.formFiltro.submit();
		return false;
	}
</script>

