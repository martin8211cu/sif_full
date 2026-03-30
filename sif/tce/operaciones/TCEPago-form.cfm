<!---===========Pantalla para generar pago de Tarjetas de Credito ===========--->
<!---<cf_dump var = "#session.tesoreria#">--->
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfset MisoOrigen = "">
<cfset cambioMP = "">
<cfset cuentaorigen = -1>
<cfif isdefined("form.cambioMP")>
	<cfset cambioMP = form.cambioMP>
    <cfif isdefined("form.CBPTCid")>
    	<cfset Form.modo=form.cambioMP>
    </cfif>
</cfif>
<cfif isdefined("Form.CBidOri")>
	<cfset cuentaorigen = Form.CBidOri>
    
    <!--- Obtiene Moneda Pago del Combo --->
    <cfset tmpArray="#cuentaorigen.split(',')#"/>
	<cfset MisoOrigen = #tmpArray[3]#>  
    
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
</cfif> <!--- modo cambio --->

<cfif isdefined('Form.NuevoL')>
	<cfset modo="ALTA">
</cfif>

<!---QRY´S--->

<cfinvoke 	component="sif.tesoreria.Componentes.TESaplicacion"
			method="sbEmisoresTCE_init">
            <cfinvokeargument name="forzar" value="true">
            </cfinvoke>


<cfquery name="rsTCambio" datasource="#Session.DSN#">
	select m.Miso4217, tc.Mcodigo, tc.TCcompra, tc.TCventa
	from Monedas m
    inner join Htipocambio tc
    on tc.Mcodigo = m.Mcodigo
    and tc.Ecodigo = m.Ecodigo
	where m.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	  and tc.Hfecha <= '#LSdateformat(Now(),'yyyymmdd')#'
      and tc.Hfechah > '#LSdateformat(Now(),'yyyymmdd')#'
</cfquery>

<cfif modo EQ "CAMBIO"  >
	<cfif isdefined("Form.CBPTCid")>	        
		<cfquery name="rsForm" datasource="#Session.DSN#">
			select
             p.TESid 	
			,p.CBPTCdescripcion
			,p.CBPTCfecha 
			,p.CBid
			,p.TESMPcodigo
            ,p.TESBid
            ,p.TESTPid
            ,p.CBPTCtipocambio
            ,p.CBPTCestatus
            ,CBPTCorden
			from CBEPagoTCE p
				inner join CuentasBancos cb
					on cb.CBid = p.CBid
				inner join Bancos b
					on b.Bid = cb.Bid
			where p.CBPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBPTCid#">
		</cfquery>

        <cfquery name="rsDetalle" datasource="#Session.DSN#">
            select count (1) as totalD
            from CBDPagoTCEdetalle cbd
                inner join CuentasBancos cb
                on cb.CBid = cbd.CBid
                inner join Monedas m
                on m.Mcodigo = cb.Mcodigo
            where CBPTCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBPTCid#">
        </cfquery>
        
        <cfquery name="rsBancos" datasource="#Session.DSN#">
            select
            b.Bid
            from TESbeneficiario bb
                inner join Bancos b
                    on b.Bid = bb.Bid
            where bb.TESBid = #rsForm.TESBid#
        </cfquery>
    </cfif>
    
    <cfif isdefined("rsForm.CBPTCestatus") and #rsForm.CBPTCestatus# gt 10 and rsForm.CBPTCorden neq "">
    
        <cfquery name="rsGetTESOPid" datasource="#Session.DSN#">
            select Max(TESOPid) as TESOPid
			from TESordenPago
            where TESid = #rsForm.TESid#
              and TESOPnumero = #rsForm.CBPTCorden#
        </cfquery>    	
        
        <cfset LvarTESOPid = 0>
        <cfif rsGetTESOPid.recordcount gt 0>
    		<cfset LvarTESOPid = rsGetTESOPid.TESOPid>    
        </cfif>
        
    </cfif>
</cfif>	

<cfquery name="rsCDestino" datasource="#Session.DSN#">
	select 	TESTPid,
			TESid,
			TESTPcuenta as TESTPcuentab, 
			Mnombre,
            a.TESBid, 
			coalesce(a.Bid,0) as Bid,
			a.Miso4217
	from TEStransferenciaP a
		left join Pais p
			on p.Ppais = a.Ppais
		inner join Monedas m
			on m.Miso4217 = a.Miso4217
			and m.Ecodigo = #session.Ecodigo#
	where TESTPestado < 2
    and coalesce(TESBid,0) <> 0  
    <cfif modo EQ "CAMBIO">
    	and a.TESBid = #rsForm.TESBid# 
    	and a.Miso4217 = (Select Miso4217
    					from TEStransferenciaP
                        where TESTPid = #rsForm.TESTPid#
    					)
    </cfif>    
</cfquery>	

<cfquery name="rsEmisoresTCE" datasource="#session.DSN#">
	select b.Bid, bb.TESBid, b.Bdescripcion
	  from TESbeneficiario bb
		inner join Bancos b 
			on b.Bid = bb.Bid
	  where b.Ecodigo = #session.Ecodigo#
		and (
			select count(1)
			  from CuentasBancos
			 where Bid = b.Bid
			   and CBesTCE = 1
			) > 0
      <cfif modo EQ "CAMBIO" and #rsDetalle.totalD# gt 0>
      	and bb.TESBid = #rsForm.TESBid#
      </cfif>
</cfquery>
<cfset LvarImprimir = 0>
<cfif modo neq "ALTA">
	<cfif isdefined("rsForm.CBPTCestatus") and #rsForm.CBPTCestatus# gt 10>
        <cf_htmlReportsHeaders 
            title="Impresion del pago generado " 
            filename="PagosTCE.xls"
            irA="TCEPago-list.cfm?regresar=1"
            download="yes"
            preview="yes"
        >
        <cfset LvarImprimir = 1>
     </cfif>
</cfif>   
<form action="TCEPago-SQL.cfm" name="form1" style="margin:0" method="post" onsubmit="javascript: asignar_CBid()"	>	
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td height="33%" colspan="8" class="tituloAlterno">Pago de Tarjetas de Credito</td>
		</tr>
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
		
		<!---==============================--->
		<!---TB DESCRIPCION & FECHA--->
		<!---==============================--->
		
		<tr>
			<td>
				<table width="100%" cellpadding="2" cellspacing="0" border="0">                
					<cfif isdefined("rsForm.CBPTCestatus") and #rsForm.CBPTCestatus# gt 10 and isdefined("LvarTESOPid") and LvarTESOPid gt 0>
                        <tr>
                            <td colspan="4" align="right">
                            	<b>Pago realizado con Num. SP:&nbsp;&nbsp;</b> 
								<cfoutput>
                                <a href="/cfmx/sif/tesoreria/Solicitudes/imprSolicitPagoTCE_form.cfm?TESOPid=#LvarTESOPid#&RegresarA=#URLencodedFormat("/cfmx/sif/tce/operaciones/TCEPago-list.cfm")#">
                                	#rsForm.CBPTCorden# 
                                </a>
                                <img src="/cfmx/sif/imagenes/find.small.png" style="cursor:pointer; margin-top: 0px; position: relative; bottom: -4px;" onclick="location.href='/cfmx/sif/tesoreria/Solicitudes/imprSolicitPagoTCE_form.cfm?TESOPid=#LvarTESOPid#&RegresarA=#URLencodedFormat("/cfmx/sif/tce/operaciones/TCEPago-list.cfm")#';"/>
                            	</cfoutput>&nbsp;&nbsp;
                            <br/><br/>
                            </td>
                        </tr>
                    </cfif>
					<tr>
						<!---Descripción--->
                        <td><b>Descripci&oacute;n:</b></td>
						<td width="60%">
                        	<cfset descrip = "">
							<cfif modo NEQ "ALTA">
								<cfset descrip = #Trim(rsForm.CBPTCdescripcion)#>
                            <cfelseif isdefined("Form.Descripcion")>
                            	<cfset descrip = #Trim(Form.Descripcion)#>
                            </cfif>
                            <cfif LvarImprimir neq 1>
                                <input type="text" name="Descripcion" id="Descripcion" size="60" maxlength="50" tabindex="-1"
                                    value="<cfoutput>#descrip#</cfoutput>" alt="La Descripci&oacute;n" 
                                            <cfif isdefined("rsForm.CBPTCestatus") and #rsForm.CBPTCestatus# gt 10>readonly</cfif>
                                            >
							<cfelse>
                            	<cfdump var="#descrip#">                                            
							</cfif>
						</td>
						<!---Fecha--->
						<td width="15%"><b>Fecha Solicitada:</b></td>
						<td>
							<cfoutput>
								<cfif modo EQ "CAMBIO">
									<cfset fechaSolicitada = "#LSDateFormat(rsForm.CBPTCfecha,'DD/MM/YYYY')#">
								<cfelseif isdefined("form.FechaSolicitada")>
									<cfset fechaSolicitada = "#LSDateFormat(Form.FechaSolicitada,'DD/MM/YYYY')#">
                                <cfelse>
                                	<cfset fechaSolicitada = "#LSDateFormat(Now(),'DD/MM/YYYY')#">
								</cfif>
                                <cfif isdefined("rsForm.CBPTCestatus") and #rsForm.CBPTCestatus# gt 10>
                                	<cfif LvarImprimir neq 1>
                                		<input 	type="text" name="fechaSolicitada" value="#fechaSolicitada#" readonly/>
                                     <cfelse>
                                     	<cfdump var="#fechaSolicitada#"> 
                                     </cfif>   
                                <cfelse>
                                	<cf_sifcalendario tabindex="1" Conexion="#session.DSN#" form="form1" name="FechaSolicitada" value="#fechaSolicitada#">
                                </cfif>
								
							</cfoutput>
						</td>	
					</tr>
					<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
				</table>
			</td>
		</tr>
		
		<!---==============================--->
		<!---TB CUENTA BANCARIA ORIGEN--->
		<!---==============================--->
		
		<tr>
			<td height="33%" colspan="8" class="tituloAlterno">Cuenta Bancaria Origen</td>
		</tr>
		<tr>
			<td>
				<table width="100%" cellpadding="2" cellspacing="0">
					 
					<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
					<tr>
						<!---<cfif modo neq 'ALTA'><cfset cuentaorigen = rsForm.CBidOri><cfelse><cfset cuentaorigen = "-1"></cfif>--->
						<td><b>Cuenta de Pago:</b></td>
						<td width="85%">
                        	<cfset disabled=false>
                        	<cfif isdefined("rsForm.CBPTCestatus") and #rsForm.CBPTCestatus# gt 10>
                            	<cfset disabled=true>
                            </cfif>
                        	<cfif modo eq 'CAMBIO' and not isdefined("form.cambioMP")><cfset cuentaorigen = #rsForm.CBid#></cfif>
                            <cfif isdefined("rsForm.CBPTCestatus") and #rsForm.CBPTCestatus# lt 11>
								<cf_cboTESCBid name="CBidOri" value="#cuentaorigen#" Dcompuesto="yes" Ccompuesto="yes" none="yes" tabindex="1" soloBcos="true" onchange="cambiar_medioPago(this.value); cambiar_TCambio(this.value);" disabled="#disabled#">
                            <cfelse>
								<cf_cboTESCBid name="CBidOri" value="#cuentaorigen#" Dcompuesto="yes" Ccompuesto="yes" none="yes" tabindex="1" soloBcos="true" onchange="cambiar_medioPago(this.value); cambiar_TCambio(this.value);" disabled="#disabled#">
                            </cfif>
                            <input type="hidden" name="cambioMP"/>
                            <input type="hidden" name="CBidc" id="CBidc">
						</td>
					</tr>
					
					<tr>
						<td><b>Medio de Pago:</b></td>
					    <td>
						<!---====Medio de Pago===--->						
							<input type="hidden" name="LvarCBidValue"/>
							<cfset session.tesoreria.TESMPcodigo = "">		
                            <cfset disabled=false>
                        	<cfif isdefined("rsForm.CBPTCestatus") and #rsForm.CBPTCestatus# gt 10>
                            	<cfset disabled=true>
                            </cfif>
                            <cfif modo eq 'CAMBIO'>
                            	<cf_cboTESMPcodigo name="TESMPcodigo"  value="#rsForm.TESMPcodigo#" CBidValue="#listFirst(cuentaorigen)#" onChange="GvarCambiado=true; " NoChks="true" disabled="#disabled#">
                            <cfelse>					
                            	<cf_cboTESMPcodigo name="TESMPcodigo"  CBidValue="#listFirst(cuentaorigen)#" onChange="GvarCambiado=true; " NoChks="true">
							</cfif>
						</td>
					</tr>
					<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
				</table>
			</td>
		</tr>
		
		<!---==============================--->
		<!---2.TB CUENTA BANCARIA DESTINO--->
		<!---==============================--->
		
		<tr>
        	<td height="33%" colspan="8" class="tituloAlterno">Cuenta Bancaria Destino</td>
		</tr>
		<tr>
			<td>
				<table width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="4">&nbsp;</td></tr>
						<tr>
							<!---====Emisor===--->
							<td><b>Emisor:</b></td>
							<td width="50%">
								<cfif LvarImprimir neq 1>
                                    <select name="Emisor" tabindex="1" onchange="cambiar_Banco();" <cfif isdefined("rsForm.CBPTCestatus") and #rsForm.CBPTCestatus# gt 10>disabled="disabled"</cfif>>
                                        <option value="">--- Seleccione un Banco---</option>
                                        <cfoutput query="rsEmisoresTCE">
                                            <option value="#rsEmisoresTCE.TESBid#" <cfif modo NEQ "ALTA" and (rsEmisoresTCE.TESBid EQ rsForm.TESBid)>selected</cfif>>#rsEmisoresTCE.Bdescripcion#</option>
                                        </cfoutput>
                                    </select>
                                <cfelse>
                                	<cfdump var="#rsEmisoresTCE.Bdescripcion#"> 
                                </cfif> 
								
								
							</td>
							<!---====Tipo de Cambio===--->
							<td><b>Tipo de Cambio:</b></td>
							<td>
                            	<cfif LvarImprimir neq 1>
                                    <input 	type="text" name="TESTIDtipoCambioDst" id="TESTIDtipoCambioDst" 
                                        value="<cfoutput><cfif modo neq 'ALTA'>#LSNumberFormat(rsForm.CBPTCtipocambio, '9.9999')#<cfelse>1.0000</cfif></cfoutput>" 
                                        size="18" class="Bloqueado" readonly="yes" tabindex="-1"
                                    >
                                 <cfelse>
                                 	<cfdump var="#LSNumberFormat(rsForm.CBPTCtipocambio, '9.9999')#"> 
                                </cfif>    
							</td>
						</tr>
						<tr>
							<!---====Cuenta Destino===--->
							<td><b>Cuenta Destino:</b></td>
	                        <td >
                            	<cfif LvarImprimir neq 1>		             
                                    <select name="CtaDestino" tabindex="1" <cfif isdefined("rsForm.CBPTCestatus") and #rsForm.CBPTCestatus# gt 10>disabled="disabled"</cfif>>
                                        <cfif modo EQ "CAMBIO">
                                            <cfoutput query="rsCDestino">
                                                <option  value="#rsCDestino.TESTPid#" <cfif modo NEQ "ALTA" and (rsCDestino.TESTPid EQ rsForm.TESTPid)>selected</cfif>>#rsCDestino.Mnombre# - #rsCDestino.TESTPcuentab#</option>
                                            </cfoutput>  
                                        <cfelse>
                                            <option value="">---Seleccione un Emisor---</option>
                                        </cfif>
                                    </select>
                                 <cfelse>
                                 	<cfdump var="#rsCDestino.Mnombre# - #rsCDestino.TESTPcuentab#"> 
                                 </cfif>   
							</td>                            
                            <td><b>Total a Pagar:</b></td>
							<td>
                            	<cfif modo neq 'ALTA'>
	                            <cfquery name="rsTCEsuma" datasource="#Session.DSN#">
                                    select coalesce(sum(CBDPTCmonto),0) as total
                                    from CBDPagoTCEdetalle cbd
                                    inner join CuentasBancos cb
                                    on cb.CBid = cbd.CBid
                                    inner join Monedas m
                                    on m.Mcodigo = cb.Mcodigo
                                    where CBPTCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBPTCid#">
                                </cfquery> 
                                <cfset totalPag = LSNumberFormat(rsTCEsuma.total, '9.99')>
                                </cfif>
                                <cfif LvarImprimir neq 1>	 
                                    <input 	type="text" name="montot" id="montot" 
                                        value="<cfif modo neq 'ALTA'><cfoutput>#totalPag#</cfoutput><cfelse>0</cfif>" 
                                        size="18" class="Bloqueado" readonly="yes" tabindex="-1">
                                <cfelse>
                                	<cfdump var="#totalPag#">
                                </cfif>
							</td>
						</tr>
						<tr><td colspan="4">&nbsp;</td></tr>				
				</table>
			</td>
		</tr>
		
		<!---==============================--->
		<!---3.BOTONES--->
		<!---==============================--->
		
		<tr>
			<td>
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr>
                        <td align="center">
                        	<cfif modo neq "ALTA">
                            	<cfif isdefined("rsForm.CBPTCestatus") and #rsForm.CBPTCestatus# lt 11>
                                    <cfinclude template="../../portlets/pBotones.cfm">
                                    <input type="submit" value="Pagar" name="btnGenerarOPTCE" onClick="javascript: this.form1.btnGenerarOPTCE.value = this.name" tabindex="1">
                                </cfif>
                            <cfelse>
                            	<cfinclude template="../../portlets/pBotones.cfm">
                                <input type="submit" value="Pagar" name="btnGenerarOPTCE" onClick="javascript: this.form1.btnGenerarOPTCE.value = this.name" tabindex="1">
                            </cfif>
                            <cfif LvarImprimir neq 1>	
                            	<input type="button" value="Ir a Lista" onClick="location.href='TCEPago-list.cfm'" tabindex="1">
                            </cfif>
                        </td>	
                    </tr>
				</table>
                
			</td>
		</tr>
		<tr><td>&nbsp;</td>

        <cfif modo eq "CAMBIO">
        <tr>
				<!---==============================--->
                <!---3.DETALLE DEL DOCUMENTO--->
                <!---==============================--->
			<td height="33%" colspan="8" class="tituloAlterno">Detalle Del Documento</td>
		</tr>
		<tr>
        	
			<td>
            	<!---Agregar Estados de Cuenta--->
				<table width="100%" cellpadding="2" cellspacing="0">
					<input type="hidden" name="Bid" id="Bid" value="">
					<input type="hidden" name="BTEtipo" id="BTEtipo" value="">
					<cfif isdefined("rsForm.CBPTCestatus") and #rsForm.CBPTCestatus# lt 11>
                        <tr>&nbsp;</tr>
                        <tr>
                            <td align="center">
                                <input type="button" class="btnNormal"  tabindex="1" name="Estados" value="Ingresar Estados de Cuenta" onClick="javascript:VentanaEstadosCuenta(<cfoutput><cfif isdefined('rsBancos.Bid') and len(trim(#rsBancos.Bid#))>#rsBancos.Bid#</cfif>,<cfif isdefined('Form.CBPTCid') and len(trim(#Form.CBPTCid#))>#Form.CBPTCid#</cfif>,<cfif isdefined('rsCDestino.Miso4217') and len(trim(rsCDestino.Miso4217))>'#rsCDestino.Miso4217#'<cfelse>'NO'</cfif>,<cfif isdefined('rsForm.CBPTCfecha') and len(trim(rsForm.CBPTCfecha))>'#rsForm.CBPTCfecha#'<cfelse>#now()#</cfif>,<cfif isdefined('form.TESTIDtipoCambioDst') and form.TESTIDtipoCambioDst gt 0>#form.TESTIDtipoCambioDst#<cfelse>1</cfif></cfoutput>);">
                            </td>
                        </tr>
                    </cfif>
				</table>
                <!---TB DETALLE--->
                <cfquery name="rsTCEdetalle" datasource="#Session.DSN#">
                    select cbd.CBDPTCid, cb.CBdescripcion, cb.CBid, m.Mnombre, 
                    case '#rsCDestino.Miso4217#' when m.Miso4217 then (CBDPTCmonto) else (CBDPTCmonto/CBDPTCtipocambio) end as monto,
                    CBDPTCmonto, CBDPTCtipocambio
                    from CBDPagoTCEdetalle cbd
                    inner join CuentasBancos cb
                    on cb.CBid = cbd.CBid
                    inner join Monedas m
                    on m.Mcodigo = cb.Mcodigo
                    where 
                    CBPTCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBPTCid#">
                </cfquery>  
        
           		<cfset totalDet = 0>            
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>&nbsp;</tr>
                    <tr class="subTitulo">
                        <td >&nbsp;</td> 
                        <td bgcolor="E2E2E2" ><strong>&nbsp;Estado Cuenta&nbsp;</strong></td> 
                        <td bgcolor="E2E2E2" ><strong>Moneda&nbsp;</strong></td>
                        <td bgcolor="E2E2E2" align="center"><strong>Monto&nbsp;</strong></td>
                        <td bgcolor="E2E2E2" align="center"><strong>Tipo Cambio&nbsp;</strong></td>
                        <td bgcolor="E2E2E2" align="center"><strong>Monto Moneda de Pago&nbsp;</strong></td>
                        <td bgcolor="E2E2E2" >&nbsp;</td>
                        <td >&nbsp;</td>
                    </tr>
                    <cfif rsTCEdetalle.RecordCount gt 0>							
                        <cfoutput query="rsTCEdetalle"> 
                            <tr style="cursor: pointer;"
                                onMouseOver="javascript: style.color = 'red'" 
                                onMouseOut="javascript: style.color = 'black'"
                                <cfif rsTCEdetalle.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
                                <td bgcolor="F7F9FA">&nbsp;</td> 
                                <td>#rsTCEdetalle.CBdescripcion#</td>
                                <td >#rsTCEdetalle.Mnombre#</td>
                                <td align="center">#LSCurrencyFormat(rsTCEdetalle.monto,'none')#</td>
                                <td align="center">#rsTCEdetalle.CBDPTCtipocambio#</td>
                                <td align="center">#LSCurrencyFormat(rsTCEdetalle.CBDPTCmonto,'none')#</td>
                                <td >
                                	<cfif isdefined("rsForm.CBPTCestatus") and #rsForm.CBPTCestatus# lt 11>
                                        <a href="javascript:borrar('#rsTCEdetalle.CBDPTCid#');">
                                            <img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif" alt="Eliminar Cuenta">
                                        </a>
                                    </cfif>
                                </td>
                                <td bgcolor="F7F9FA">&nbsp;</td>
                            </tr>
                            <cfset totalDet = totalDet + #rsTCEdetalle.CBDPTCmonto# >
                      </cfoutput>
                        <tr>
                        	<td>&nbsp;</td> 
                        	<td>&nbsp;</td> 
                        	<td>&nbsp;</td> 
                        	<td>&nbsp;</td> 
                        	<td align="center"><strong>TOTAL:&nbsp;</strong></td>
                        	<td align="center"><cfoutput>#LSCurrencyFormat(totalDet,'none')#</cfoutput></td>
                        </tr>
                    <cfelse>
                        <tr>
                            <td align="center" colspan="8">--- No se encontraron datos ----</td>
                        </tr>
                    </cfif>
                    
                    <!--- Para Borrado desde la lista --->
                    
                    <input type="hidden" name="BorrarD" value="">
                    <input type="hidden" name="CBPTCid" value="<cfoutput>#Form.CBPTCid#</cfoutput>">
                    <input type="hidden" name="CBDPTCid" value="">
                    
                    <!--- --------------------------- --->
                </table>
			</td>
		</tr>
	</cfif>
	<iframe name="cuentas" id="cuentas" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>			
	</table>
</form>	
<script language="JavaScript1.2" type="text/javascript">
    qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	//Validaciones de los campos requeridos	

	objForm.Descripcion.required = true;
	objForm.Descripcion.description="Descripci\u00f3n";
	
	objForm.FechaSolicitada.required = true;
	objForm.FechaSolicitada.description="Fecha Solicitada";
	
	objForm.Emisor.required = true;
	objForm.Emisor.description="Emisor";
	
	objForm.TESTIDtipoCambioDst.required = true;
	objForm.TESTIDtipoCambioDst.description="Tipo de Cambio";
	
	objForm.CtaDestino.required = true;
	objForm.CtaDestino.description="Cuenta Destino";

	objForm.CBidOri.required = true;
	objForm.CBidOri.description="Cuenta de Pago";
	
	objForm.TESMPcodigo.required = true;
	objForm.TESMPcodigo.description="Medio de Pago";
									
	function deshabilitarValidacion(){
		objForm.CPDCcodigo.required = false;
		objForm.CPDCdescripcion.required = false;
	}
	cambiar_TCambio('<cfoutput>#cuentaorigen#</cfoutput>');
	
	function asignar_CBid ()
	{
		var LvarValue = '<cfoutput>#cuentaorigen#</cfoutput>';
		LvarCBid1= LvarValue.split(",")[0];
		document.form1.CBidc.value = LvarCBid1;
	}
	function cambiar_medioPago (Tipo)
	{
		var LvarValue = Tipo;
		if (LvarValue != "")
		{
			LvarCBid= LvarValue.split(",")[0];
			document.form1.cambioMP.value = 'CAMBIO';
			document.form1.action = '';
			document.form1.submit();
		}
		
	<cfif modo neq "ALTA">
			if (document.getElementById("TESMPcodigo"))
				document.getElementById("TESMPcodigo").style.display = (LvarCBid == "<cfoutput>#cuentaorigen#</cfoutput>")?'':'none';
	</cfif>
	}
	
	function cambiar_Banco() {
		valor2 = document.form1.Emisor.value
		var moneda2;
		var CtaDestino = '';
		var Error = 0;
		<cfif isdefined("rsForm.TESTPid")>
			CtaDestino = '<cfoutput>#rsForm.TESTPid#</cfoutput>';
		</cfif>
		
		<cfoutput>
		<cfif not isdefined("rsDetalle.totalD")>
			moneda2 = '#MisoOrigen#';
		<cfelse>
				
			<cfif isdefined("MisoOrigen") and #MisoOrigen# neq "" and #rsDetalle.totalD# eq 0>
				moneda2 = '#MisoOrigen#';
			<cfelseif isdefined("MisoOrigen") and #MisoOrigen# neq "" and #rsDetalle.totalD# gt 0 and #MisoOrigen# neq #rsCDestino.Miso4217#>		
				i=0;
				moneda2 = '#MisoOrigen#';
				Error = 1;
			<cfelse>
				moneda2 = moneda();
			</cfif>
			
		</cfif>
		document.getElementById('cuentas').src = 'TCEPago-Cuentas.cfm?Bid='+valor2+'&moneda='+moneda2+'&TESTPid='+CtaDestino+'&Error='+Error;
		</cfoutput>	
	}
	
	function moneda(){
	var coma = ",";
		var contador = 0;
		var letra3 = "";
		valor = document.form1.CBidOri.value;
		for (var i=0; i < valor.length; i++) {
			letra = valor.substring(i, i + 1)
			if (letra == coma) {
				if(contador < 2){
					letra2 = i;
				}
				contador++
				if(contador == 3){
					letra3 = valor.substring(letra2+1, i)
				}
			} 
  		}
		return letra3;
	}
	function cambiar_TCambio(valor) {
		if ( valor!= "" ) {
			<cfoutput query="rsTCambio">
				if ('#Trim(rsTCambio.Miso4217)#' == moneda() ){
					document.form1.TESTIDtipoCambioDst.value = '#rsTCambio.TCventa#';
					return true;
				}
				else{
					document.form1.TESTIDtipoCambioDst.value = '1.000';
				}
			</cfoutput>
		}
		return;
	}
	
	function borrar(detalle){
		if ( confirm('¿Desea borrar el Estado de Cuenta de la lista?') ) {
		document.form1.action = "TCEPago-SQL.cfm";	
		document.form1.CBDPTCid.value = detalle;
		document.form1.BorrarD.value = 'BorrarD';
		document.form1.submit();
		}
	}
	
	function AlertaCuentas()
	{
		document.form1.CtaDestino.style.color = "red";
	}
	<cfif isdefined("LvarAlerta")>
		AlertaCuentas();
	</cfif>
	cambiar_Banco();
	
	//Llama el conlis
	function VentanaEstadosCuenta(Bid, CBPTCid, Miso4217, Fecha, TCambio) {
		<!---var params ="";
		params = "&form=form"+--->
		popUpWindowIns("/cfmx/sif/tce/operaciones/popUp-ECuentas.cfm?Bid="+Bid+"&CBPTCid="+CBPTCid+"&Miso4217="+Miso4217+"&Fecha="+Fecha+"&TCambio="+TCambio,window.screen.width*0.20 ,window.screen.height*0.20,window.screen.width*0.60 ,window.screen.height*0.60);
	}
	
	var popUpWinIns = 0;
	function popUpWindowIns(URLStr, left, top, width, height){
		if(popUpWinIns){
			if(!popUpWinIns.closed) popUpWinIns.close();
		}
		popUpWinIns = open(URLStr, 'popUpWinIns', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,scrolling=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
</script>
