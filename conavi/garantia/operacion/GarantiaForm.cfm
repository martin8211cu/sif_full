<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js"></script>

<cfif isdefined("url.COEGid") and not isdefined("form.COEGid") and len(trim(url.COEGid))>
	<cfset form.COEGid = url.COEGid>
</cfif>
<cfif isdefined("url.COEGid") and isdefined("form.COEGid") and len(trim(url.COEGid))>
	<cfset form.COEGid = url.COEGid>
</cfif>

<cfif isdefined("form.COEGid") and len(trim(form.COEGid)) and not isdefined("form.COEGReciboGarantia")>
	<cfquery name="rsGarVer" datasource="#session.DSN#">
    	select COEGReciboGarantia, COEGVersion
        from COEGarantia
        where COEGid = #form.COEGid#
    </cfquery>
    <cfset url.COEGReciboGarantia = rsGarVer.COEGReciboGarantia>
    <cfset url.COEGVersion = rsGarVer.COEGVersion>
</cfif>

<cfif isdefined("url.COEGReciboGarantia") and not isdefined("form.COEGReciboGarantia") and len(trim(url.COEGReciboGarantia))>
	<cfset form.COEGReciboGarantia = url.COEGReciboGarantia>
</cfif>


<cfif isdefined("url.CMPid") and not isdefined("form.CMPid") and len(trim(url.CMPid))>
	<cfset form.CMPid = url.CMPid>
</cfif>


<cfif isdefined("url.COEGVersion") and not isdefined("form.COEGVersion") and len(trim(url.COEGVersion))>
	<cfset form.COEGVersion = url.COEGVersion>
</cfif>

<cfif isdefined("url.CODGid") and not isdefined("form.CODGid") and len(trim(url.CODGid))>
	<cfset form.CODGid = url.CODGid>
</cfif>

<cfset modo  = 'Alta'>
<cfset modoD = 'Alta'>
<cfif isdefined("form.COEGReciboGarantia") and len(trim(form.COEGReciboGarantia)) and not isdefined("form.Nuevo")>
	<cfset modo = 'Cambio'>
</cfif>
<cfif isdefined("form.CODGid") and len(trim(form.CODGid)) and not isdefined("form.Nuevo")>
	<cfset modoD = 'Cambio'>
</cfif>



<cfset LvarProcesaEncabezado = fnProcesaE()>

<cf_templateheader title="Garantía">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Garantía'>
		<cfoutput>
            <form name="form1" action="GarantiaSql.cfm" method="post">
                <input name="COEGid" type="hidden" value="<cfif modo neq 'Alta'>#form.COEGid#</cfif>" tabindex="1"/>
               <!--- <input name="CMPid" type="hidden" value="<cfif modo neq 'Alta'>#rsGarantia.CMPid#</cfif>" tabindex="1"/>--->
				<input name="Modo" type="hidden" value="#modo#" tabindex="1"/>
                
            <cf_navegacion name="COEGid" default="" 	navegacion="navegacion">
                <table cellpadding="2" cellspacing="0" align="center" border="0" width="100%">
                	<tr>
                    	<td colspan="1" align="right">
                       	<strong>Proceso:&nbsp;</strong>
                      </td>
							<td align="left" colspan="1">
								<cfif modo NEQ 'cambio'>
									<cf_ProcesosGarantia name="CMPid" popup="true" ultimoNivel="true" funcionT="fnGarantia(CMPid,CMPProceso)">
								<cfelseif isdefined("rsGarantia") and rsGarantia.Estado eq 'Edición'>
									<cf_ProcesosGarantia name="CMPid" popup="true" ultimoNivel="true" funcionT="fnGarantia(CMPid,CMPProceso)">
								<cfelse>
									#rsGarantia.CMPProceso#
								</cfif>
							</td>								
                        <td align="left">
                        	&nbsp;
                        	<input name="CMPMontoProceso" id="CMPMontoProceso" value="<cfif modo NEQ 'Alta'>#numberformat(rsGarantia.CMPMontoProceso,',_.__')#</cfif>" type="hidden" tabindex="1"/>
                        </td>
                    </tr>
                    <tr>
						<td colspan="1" align="right"> <strong>Asociado a Contratación:&nbsp;</strong> </td>
						<td>
							<cfif Modo eq 'Alta' >
								<input type="checkbox" name="COEGContratoAsociado" id="COEGContratoAsociado" tabindex="1" checked="checked">
                            <cfelseif isdefined("rsGarantia") and rsGarantia.Estado eq 'Edición'>
                            	<input type="checkbox" name="COEGContratoAsociado" id="COEGContratoAsociado" tabindex="1"  <cfif #rsGarantia.COEGContratoAsociado# EQ 'SI'>checked="checked"</cfif>>
							<cfelse>
								 #rsGarantia.COEGContratoAsociado#
								<input type="hidden" name="COEGContratoAsociado" id="COEGContratoAsociado" tabindex="1" value="<cfif #rsGarantia.COEGContratoAsociado# EQ 'SI'>S<cfelse>N</cfif>">
							</cfif>
						</td>
                        
						<td align="right">
                     <strong>Moneda de Garantía:</strong>&nbsp;
                  </td>
					<td align="left" colspan="1">
				  	<cfquery name="rsMoneda" datasource="#session.DSN#">
						select Mcodigo, Miso4217, Mnombre
						from Monedas
						where Ecodigo = #session.Ecodigo#
						order by Mnombre
				  	</cfquery>                                
					<cfif Modo eq 'Alta'>  
						<select name="Mcodigo" tabindex="1">
							<cfloop query="rsMoneda">
								<option value="#rsMoneda.Mcodigo#">#rsMoneda.Mnombre#</option>
							</cfloop>
						</select>
					</cfif>
					<cfif Modo neq 'Alta'>  
						<input type="hidden" name="Miso4217" id="Miso4217" tabindex="1" value="#rsGarantia.Miso4217#" readonly="true"> #rsGarantia.Miso4217#
						<input type="hidden" name="Mcodigo" id="Mcodigo" tabindex="1" value="#rsGarantia.Mcodigo#" readonly="true">
					</cfif>  
					 </td>			                     
                    </tr>
                    <tr>
                        <td colspan="1" align="right">
                        	<strong>Proveedor:&nbsp;</strong>
                        </td>
                        <td align="left" colspan="1">
                        	<cfif modo eq 'Cambio'>
								<cf_sifsociosnegocios2 tabindex="1" SNtiposocio='P' SNid='SNid' idquery='#rsGarantia.SNcodigo#'>
                            <cfelse>
	                            <cf_sifsociosnegocios2 tabindex="1" SNtiposocio='P' SNid='SNid'>
                            </cfif>                        	
                        </td>
                        <td align="right">
                        	<strong>Total Garantía:</strong>&nbsp;
                        </td>
                        <td align="left">
                        	<cfif modo eq 'Alta'>
                            	0.00
                                <input name="COEGMontoTotal" id="COEGMontoTotal" tabindex="1" type="hidden" value="0.00"  />
                            <cfelse>
                            	#numberformat(rsGarantia.COEGMontoTotal, ',_.__')#
                                <input name="COEGMontoTotal" id="COEGMontoTotal" tabindex="1" type="hidden" value="#rsGarantia.COEGMontoTotal#"  />
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                    	<td align="right">
                        	<strong>Garantía:</strong>&nbsp;
                        </td>
                        <td align="left">
	                        <cfif modo neq 'Alta'>
                            	#rsGarantia.COEGReciboGarantia#
                            <cfelse>
	                        	Por Asignar
                            </cfif>
                        	<input name="COEGReciboGarantia" value="<cfif modo neq 'Alta'>#form.COEGReciboGarantia#<cfelse>#LvarConsecutivo#</cfif>" type="hidden" tabindex="1"/>
                        </td>
                    	<td align="right">
                        	<strong>Tipo Garantía:</strong>&nbsp;
                        </td>
                        <td align="left">
                        	<select name="COEGTipoGarantia" tabindex="1" id="COEGTipoGarantia">
                            	<option value="1" <cfif modo NEQ 'Alta' and rsGarantia.COEGTipoGarantia eq 1>selected="selected"</cfif> >Participación</option>
                              <option value="2" <cfif modo NEQ 'Alta' and rsGarantia.COEGTipoGarantia eq 2>selected="selected"</cfif> >Cumplimiento</option>
                           </select>
                        </td>
                    </tr>
                    <tr>
                    	<td align="right"> <strong>Versión:</strong>&nbsp; </td>
                        <td colspan="1">
	                        <cfset LvarHistoria = -1>
                        	<cfif modo neq 'Alta'>
	                        	<cfquery name="rsBuscaHistoria" datasource="#session.DSN#">
                                    select count(1) as cantidad
                                    from COHEGarantia
                                    where COEGid = #rsGarantia.COEGid#
                                    and COEGVersion = #rsGarantia.COEGVersion#
                                </cfquery>
                                <cfset LvarHistoria = rsBuscaHistoria.cantidad>
                            </cfif>                            
                            
                        	<cfif modo eq 'Alta'>
                            	<cfset LvarVersion = 1>
                            <cfelseif modo eq 'Cambio' and rsGarantia.Estado eq 'Vigente' or rsGarantia.Estado eq 'Devuelta'>
                            	<cfset LvarVersion = rsGarantia.COEGVersion>

                            <cfelseif modo eq 'Cambio' and rsGarantia.Estado eq 'Edición' and rsGarantia.COEGVersion eq 1 and LvarHistoria eq 0><!--- Solo la primera vez --->
                            	<cfset LvarVersion = 1>
                            <cfelseif modo eq 'Cambio' and rsGarantia.Estado eq 'Edición' and LvarHistoria gt 0>
                            	<cfset LvarVersion = rsGarantia.COEGVersion + 1>
                            <cfelseif modo eq 'Cambio' and rsGarantia.Estado eq 'Edición'>
                            	<cfset LvarVersion = rsGarantia.COEGVersion>
                            </cfif>
                            
                            #LvarVersion#
                            <input name="COEGVersion" id="COEGVersion" value="#LvarVersion#" type="hidden" />
                        </td>						
						<td align="right"> <strong>Estado:</strong>&nbsp; </td>
                        <td colspan="1"> 
                            <cfif Modo eq 'Alta'>
                            	Edición
                                <cfset LvarEstado = 2>
                            <cfelseif modo neq 'Alta'>
	                            #rsGarantia.Estado#
                                <cfset LvarEstado = #rsGarantia.COEGEstado#>
                            </cfif>
                       	
                            <input name="COEGEstado" id="COEGEstado" value="#LvarEstado#" type="hidden" /> <!--- 1: vigente, 2: Edicion, 3: En proceso de Ejecución, 4: En Ejecución, 5: Ejecutada, 6: En proceso Liberación, 7: Liberada,  8:Devuelta --->
                        </td>
						
                    </tr>
                    <tr>
                    	<td align="right"> <strong>Fecha Recepción:</strong>&nbsp; </td>
                        <td align="left" colspan="1">
                        	<cfif Modo eq 'Alta'>
                            	#LSdateformat(now(),'dd/mm/yyyy hh:mm:ss ')#
                                <input name="COEGFechaRecibe" id="COEGFechaRecibe" type="hidden" value="#now()#" tabindex="1"/>
                            <cfelse>
                            	#LSdateformat(rsGarantia.COEGFechaRecibe,'dd/mm/yyyy hh:mm:ss ')#
                                <input name="COEGFechaRecibe" id="COEGFechaRecibe" type="hidden" value="#rsGarantia.COEGFechaRecibe#" tabindex="1"/>
                            </cfif>		
                        </td>
						<td align="right"> <strong>Monto del Proceso:</strong>&nbsp; </td>
                        <td align="left" colspan="1">
                        	<cfif modo EQ 'cambio' and len(trim(#rsGarantia.CMPProceso#))>
                            	#rsGarantia.Msimbolo#  #rsGarantia.CMPMontoProceso#
                                <input name="CMPMontoProceso" id="CMPMontoProceso" type="hidden" value="#rsGarantia.CMPMontoProceso#" tabindex="1"/>
                            </cfif>		
                        </td>
                    </tr>
                    <tr>
                    	<td align="right">
                        	<strong>Persona entrega:</strong>&nbsp;
                        </td>
                    	<td>
                        	<input name="COEGPersonaEntrega" id="COEGPersonaEntrega" type="text" style="width:70%" maxlength="254" value="<cfif modo neq 'Alta'>#rsGarantia.COEGPersonaEntrega#</cfif>" tabindex="1"/>
                        </td>
                        <td align="right">
                        	<strong>Identificación:</strong>&nbsp;
                        </td>
                        <td align="left">
                        	<input name="COEGIdentificacion" id="COEGIdentificacion" type="text" width="22" maxlength="21" value="<cfif modo neq 'Alta'>#rsGarantia.COEGIdentificacion#</cfif>" tabindex="1"/>
                        </td>
                    </tr>
                </table>
               	
                <cfif modo neq 'Alta' and rsGarantia.Estado eq 'Vigente'>
                    <cf_botones modo=#modo# sufijo='E' exclude='CAMBIO,BAJA' include='Editar,Regresar' >
                <cfelseif modo neq 'Alta' and rsGarantia.Estado eq 'Edición' and rsGarantia.COEGVersion gt 1>
                	<cf_botones modo=#modo# sufijo='E' include='Regresar' exclude='BAJA' >
                <cfelseif modo neq 'Alta' and rsGarantia.Estado eq 'Edición' and rsGarantia.COEGVersion eq 1>
                	<cf_botones modo=#modo# sufijo='E' include='Regresar' >
                <cfelseif  modo eq 'Alta' >
	                <cf_botones modo=#modo# sufijo='E' include='Regresar'>	
                </cfif>
           	</form>
            <cf_qforms form='form1' objForm="objForm1">
                <cf_qformsRequiredField name="SNid" description="Proveedor">
                <cf_qformsRequiredField name="COEGPersonaEntrega" description="Persona que entrega">
                <cf_qformsRequiredField name="COEGIdentificacion" description="Identificación">
				<cfif modo eq 'Alta'>
				   <cf_qformsRequiredField name="CMPid" description="Proceso">
				</cfif>
            </cf_qforms>
        </cfoutput>

<!--- ****************************************************************************** Detalle ***************************************************************************** --->
        <cfif isdefined("form.COEGid") and len(trim(form.COEGid))>
            <cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
                select Mcodigo from Empresas
                where Ecodigo =  #Session.Ecodigo#  	
            </cfquery>
        	<cfif modoD eq 'Cambio'>
            	<cfset LvarProcesaDetalle = fnProcesaD()>
                <cfif rsMonedaLocal.Mcodigo neq rsGarantiaD.CODGMcodigo>
	                <cfset TCsug = BuscaTC(rsGarantiaD.CODGMcodigo, rsGarantiaD.CODGFecha,'V')>
                <cfelse>
                	<cfset TCsug = 1.0000>
                </cfif>
            <cfelse>
				<cfset TCsug = 1.0000>
            </cfif>
            <!---
				Si en el catalogo de "Tipos de Rendicion", se activa el check "Modificable"
            	los campos del detalle para el tipo de rendicion se pueden modificar.
			--->
            <cfset disabled = false>
        	<cfif modoD EQ 'Cambio' and isdefined("rsGarantiaD.COTRmodificar") and rsGarantiaD.COTRmodificar eq 0>
				<cfset disabled = true>
            </cfif>

        	<cfoutput>
            	<form name="form2" method="post" action="GarantiaSql.cfm" onsubmit="funcSummit();" >
                	<input name="COEGid" id="COEGid" type="hidden" value="#form.COEGid#" />
                     <input name="COEGReciboGarantia" type="hidden" value="#form.COEGReciboGarantia#" tabindex="1"/>
	                 <input name="COEGVersion" type="hidden" value="#form.COEGVersion#" tabindex="1"/>
                    <input name="CODGid" id="CODGid" type="hidden" value="<cfif modoD neq 'Alta'>#form.CODGid#</cfif>" />
                    <input name="COEGEstado" id="COEGEstado" value="#rsGarantia.COEGEstado#" type="hidden" />
                    <input type="hidden" name="monedalocal" value="#rsMonedaLocal.Mcodigo#">
                    <input type="hidden" name="TCsug" id="TCsug" value="#numberFormat(TCsug,',9.0000')#">
                    <table cellpadding="2" cellspacing="0" align="center" border="0" width="100%">
                        <tr>
                            <td align="center" colspan="5" style="border-top:ridge">
                                <strong>Detalle Garantía</strong>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                <strong>Número de Garantía:</strong>&nbsp;
                            </td>
                            <td align="left">
                                <input tabindex="1" name="CODGNumeroGarantia" id="CODGNumeroGarantia" type="text" value="<cfif modoD eq 'Cambio' and isdefined('rsGarantiaD')>#rsGarantiaD.CODGNumeroGarantia#</cfif>" <cfif disabled>disabled</cfif>/>
                            </td>
                            <td align="right">
                                <strong>Fecha Registro Detalle:</strong>
                            </td>
                            <td align="left" colspan="2">
                                <cfif ModoD eq 'Alta'>
                                    #dateformat(now(),'dd/mm/yyyy hh:mm:ss ')#
                                    <input name="CODGFecha" id="CODGFecha" type="hidden" value="#now()#" tabindex="1"/>
                                <cfelse>
                                    #LSdateformat(rsGarantiaD.CODGFecha,'dd/mm/yyyy hh:mm:ss ')#
                                    <input name="CODGFecha" id="CODGFecha" type="hidden" value="#rsGarantiaD.CODGFecha#" tabindex="1"/>
                                </cfif>		
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                            	<strong>Tipo de Rendición:</strong>&nbsp;
                            </td>
                            <td align="left" colspan="4">
                            	<cfset checked    = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>">
								<cfset unchecked  = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>">

                            	<cfset valuesArray2 = ArrayNew(1)>
								<cfif modoD NEQ 'Alta'>
                                	<cfset ArrayAppend(valuesArray2, rsGarantiaD.COTRid)>
                                    <cfset ArrayAppend(valuesArray2, rsGarantiaD.COTRCodigo)>
                                    <cfset ArrayAppend(valuesArray2, rsGarantiaD.COTRDescripcion)>
                                    <cfset ArrayAppend(valuesArray2, rsGarantiaD.CcuentaRecibida)>
                                    <cfset ArrayAppend(valuesArray2, rsGarantiaD.CcuentaGarxPagar)>
                                </cfif>
                            	<cf_conlis
                                    Campos="COTRid, COTRCodigo, COTRDescripcion, CcuentaRecibida, CcuentaGarxPagar, COTRGenDepositoBit"
                                    Desplegables="N,S,S,N,N,N"
                                    Modificables="N,S,N,N,N,N"
                                    Size="0,10,20,0,0,0"
                                    tabindex="1"
                                    valuesarray="#valuesArray2#" 
                                    Title="Lista Tipo de Rendición"
                                    Tabla=" COTipoRendicion "
                                    Columnas="  COTRid,
                                                COTRCodigo,
                                                COTRDescripcion,
                                                COTRGenDeposito as COTRGenDepositoBit,
                                                case COTRGenDeposito 
                                                	when 1 then '#checked#'
	                                                when 0 then '#unchecked#'
                                                end as  COTRGenDeposito,
                                                CcuentaGarantiaRecibida as CcuentaRecibida,
                                                CcuentaGarantiaPagar as CcuentaGarxPagar "
                                    Filtro=" Ecodigo = #session.Ecodigo# "
                                    Desplegar="COTRCodigo, COTRDescripcion, COTRGenDeposito"
                                    Etiquetas="Código, Descripción, Genera Depósito"
                                    filtrar_por="COTRCodigo, COTRDescripcion, COTRGenDeposito"
                                    Formatos="S,S,U"
                                    Align="left,left,left"
                                    form="form2"
                                    Asignar="COTRid, COTRCodigo, COTRDescripcion, COTRGenDeposito, CcuentaRecibida, CcuentaGarxPagar, COTRGenDepositoBit"
                                    Asignarformatos="S,S,S,S,S,S,I"
                                    readonly = "#disabled#"
                                    width="800"
                                    Funcion="funcionDeposito()"
                                />
                                
                                <iframe name="ifrMonedaTodas" id="ifrMonedaTodas" width="0" height="0" frameborder="0">
								</iframe>
                               
							   <!--- <script language="javascript" type="application/javascript">
									function funcPoneMonedaTodas()
										{
											document.getElementById('ifrMonedaTodas').src = "GarantiaMoneda.cfm?Todas";
										}
								</script>--->
                            </td>
                            
                        </tr>
                        <tr>
                        	<td align="right">
                            	<strong>Banco:</strong>&nbsp;
                            </td>
								<cfset valuesArray3 = ArrayNew(1)>
								<cfif modoD NEQ 'Alta'>
                                	<cfset ArrayAppend(valuesArray3, rsGarantiaD.Bid)>
                                    <cfset ArrayAppend(valuesArray3, rsGarantiaD.Bdescripcion)>
                                </cfif>
                            <td align="left">
                            	<cf_conlis
                                    Campos="Bid, Bdescripcion"
                                    Desplegables="N,S"
                                    Modificables="N,N"
                                    Size="0,35"
                                    tabindex="1"
                                    valuesarray="#valuesArray3#" 
                                    Title="Lista de Bancos"
                                    Tabla=" Bancos "
                                    Columnas="  Bid, Bdescripcion "
                                    Filtro=" Ecodigo = #session.Ecodigo# order by Bdescripcion"
                                    Desplegar="Bdescripcion"
                                    Etiquetas="Banco"
                                    filtrar_por="Bdescripcion"
                                    Formatos="S"
                                    Align="left"
                                    form="form2"
                                    Asignar="Bid,Bdescripcion"
                                    Asignarformatos="S,S"
                                    readonly = "#disabled#"
                                    width="800"
                                />
                            </td>
                            <td align="right" valign="middle">
                            	<strong id="CBidEtiqueta">Cuenta Bancaria:</strong>&nbsp;
                            </td>   
                            <cfset valuesArray4 = ArrayNew(1)>
								<cfif modoD NEQ 'Alta'>
                                	<cfset ArrayAppend(valuesArray4, rsGarantiaD.CBid)>
                                    <cfset ArrayAppend(valuesArray4, rsGarantiaD.CBcodigo)>
                                    <cfset ArrayAppend(valuesArray4, rsGarantiaD.CBdescripcion)>
                                </cfif>
                            <td align="left" valign="middle" style="vertical-align:bottom">
                                <div id="CBidCampo">
                                    <cf_conlis
                                        Campos="CBid, CBcodigo, CBdescripcion"
                                        Desplegables="N,S,S"
                                        Modificables="N,S,N"
                                        Size="0,20,0"
                                        tabindex="1"
                                        valuesarray="#valuesArray4#" 
                                        Title="Lista Cuentas Bancarias"
                                        Tabla=" CuentasBancos "
                                        Columnas="  CBid, CBcodigo, CBdescripcion "
                                        Filtro=" Bid = $Bid,numeric$ and CBesTCE = 0 and  Ecodigo = #session.Ecodigo# "
                                        Desplegar="CBcodigo, CBdescripcion"
                                        Etiquetas="Código, Descripción"
                                        filtrar_por="CBcodigo, CBdescripcion"
                                        Formatos="S,S"
                                        Align="left,left"
                                        form="form2"
                                        Asignar="CBid, CBcodigo, CBdescripcion"
                                        Asignarformatos="S,S,S"
                                        width="800"
                                        readonly = "#disabled#"
                                        funcion="funcPoneMoneda"
                                        fparams="CBid"
                                    />
                                </div>
                                <iframe name="ifrMoneda" id="ifrMoneda" width="0" height="0" frameborder="0">
								</iframe>
                                <script language="javascript">
									function funcPoneMoneda(LvarCBid)
										{
											document.getElementById('ifrMoneda').src = "GarantiaMoneda.cfm?CBid=" + LvarCBid;
										}
								</script>
                            </td>
                        </tr>
                        <tr>
                        	<td align="right" valign="middle" id="CODGNumDepositoEtiqueta">
                            	<strong>Número depósito:</strong>&nbsp;
                            </td>
                            <td align="left" valign="middle"  id="CODGNumDepositoCampo" colspan="4">
                            	
                            	 <input 
                                	name="CODGNumDeposito" 
                                    id="CODGNumDeposito" 
                                    type="text"
                                    value="<cfif modoD eq 'Cambio'>#rsGarantiaD.CODGNumDeposito#</cfif>" 
                                	tabindex="1"
                                    size="22" 
                                    maxlength="20"  <cfif disabled>disabled</cfif>/>
                            </td>
                        </tr>
                        <tr>
                        	<td align="right">
                                <strong>Moneda:</strong>&nbsp;
                            </td>
                            <cfquery name="rsMoneda" datasource="#session.DSN#">
                                select Mcodigo, Miso4217, Mnombre
                                from Monedas
                                where Ecodigo = #session.Ecodigo#
                                order by Mnombre
                            </cfquery>
                            <td align="left" colspan="1">
                            	<span id='Contenedor_Moneda'>
                                    <select name="CODGMcodigo" tabindex="1" onchange="validatc(true)" <cfif disabled>disabled</cfif>>
                                        <cfloop query="rsMoneda">
                                            <option value="#rsMoneda.Mcodigo#" <cfif modoD eq 'Cambio' and rsGarantiaD.CODGMcodigo eq rsMoneda.Mcodigo>selected="selected"</cfif>>#rsMoneda.Mnombre#</option>
                                        </cfloop>
                                    </select>
                                </span>
	                        </td>
                            <iframe name="ifrTC" id="ifrTC" width="0" height="0"></iframe>
                            <td align="right">
                            	<strong>Tipo de Cambio:</strong>&nbsp;
                            </td>
                            <td align="left">
                            	<input 
                                	name="CODGTipoCambio" 
                                    id="CODGTipoCambio" 
                                    type="text"
                                	value="<cfif modoD eq 'Cambio'>#rsGarantiaD.CODGTipoCambio#</cfif>" 
                                	onFocus="javascript:this.value = qf(this.value); this.select();" 
                                    tabindex="1"
                                    style="text-align:right" 
                                    onChange="javascript:fm(this,4);" 
                               		onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
                               		size="22" 
                                    maxlength="20" <cfif disabled>disabled</cfif>/>
                            </td>
                        </tr>
                        <tr>
                        
                            <td align="right">
                                <strong>Monto Detalle:</strong>&nbsp;
                            </td>
                            <td align="left" colspan="1">
                                <input 
                                	name="CODGMonto" 
                                    id="CODGMonto" 
                                    type="text"
                                    value="<cfif modoD eq 'Cambio'>#numberformat(rsGarantiaD.CODGMonto,',_.__')#</cfif>" 
                                	onFocus="javascript:this.value = qf(this.value); this.select();" 
                                    tabindex="1"
                                    style="text-align:right" 
                                    onChange="javascript:fm(this,2);" 
                               		onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
                               		size="22" 
                                    maxlength="20"  <cfif disabled>disabled</cfif>/>
                            </td>
                            
                            <td align="right">
                                <cfif modoD eq 'Cambio'>
                                	<strong>Monto en Moneda Encabezado:</strong>&nbsp;
                                <cfelse>
                                	&nbsp;
                                </cfif>
                            </td>
                            <td align="left" colspan="1">
                               <cfif modoD eq 'Cambio'>
                                	<cfset LvarTCventaE = BuscaTC(rsGarantia.Mcodigo, rsGarantia.COEGFechaRecibe,'V')>
                                    <cfset LvarTCventaD = rsGarantiaD.CODGTipoCambio>
									
									<cfif rsGarantia.Mcodigo eq rsGarantiaD.CODGMcodigo>
									  <cfset LvarCalculo = (rsGarantiaD.CODGMonto)>
									<cfelse>
                                	  <cfset LvarCalculo = (rsGarantiaD.CODGMonto * LvarTCventaD) / LvarTCventaE>
									</cfif>
									 
                                    <cfoutput>#numberformat(LvarCalculo,',_.__')#</cfoutput>
                                <cfelse>
                                	&nbsp;
                                </cfif>
                            </td>
                            
                        </tr>
                        <tr>
                        	<td align="right">
                            	<strong>Fecha incial:</strong>&nbsp;
                            </td>
                            <td align="left">
                            	<cfif modoD EQ 'Cambio'>
									<cfset fechaini = LSDateFormat(rsGarantiaD.CODGFechaIni,'dd/mm/yyyy')>
                                <cfelse>
                                    <cfset fechaini = ''>
                                </cfif>
                                <cf_sifcalendario name="CODGFechaIni" tabindex='1' form="form2" value="#fechaini#">
                            </td>
                            <td align="right">
                            	<strong>Fecha final:</strong>&nbsp;
                            </td>
                            <td align="left">
                            	<cfif modoD EQ 'Cambio'>
									<cfset fechafin = LSDateFormat(rsGarantiaD.CODGFechaFin,'dd/mm/yyyy')>
                                <cfelse>
                                    <cfset fechafin = ''>
                                </cfif>
                                <cf_sifcalendario name="CODGFechaFin" tabindex='1' form="form2" value="#fechafin#">
                            </td>
                        </tr>
                        <tr>
                        	<td align="right">
                            	<strong>Observaciones:</strong>&nbsp;
                            </td>
                            <td align="left" colspan="4">
                            	<input name="CODGObservacion" id="CODGObservacion" tabindex="1" value="<cfif modoD EQ 'Cambio'>#rsGarantiaD.CODGObservacion#</cfif>" type="text" size="110"  maxlength="254" <cfif disabled>disabled</cfif>/>
                            </td>
                        </tr>
                        <tr>
                        	<td colspan="5">
								
                            	<cfif isdefined("rsGarantia") and rsGarantia.Estado eq 'Edición'>
									<cfset exclude = "Limpiar">
									<cfif modoD EQ 'Cambio' and rsGarantiaD.COTRGenDeposito eq '1' and rsGarantiaD.existeEnHD neq '0'>
										<cfset exclude = exclude & ",CAMBIO,BAJA">
									</cfif>
                                    <cfif disabled>
                                    	<cfset exclude = exclude & ",CAMBIO">
                                    </cfif>
                                	<cf_botones modo=#modoD# sufijo='D' exclude='#exclude#' tabindex='1'>
                                </cfif>
                            </td>
                        </tr>
                    </table>
                </form>   
					 
					<script language="javascript">
						<cfif isdefined("rsGarantia") and rsGarantia.Estado eq 'Edición'>
							<cfoutput>
								document.form1.CMPid_descripcion.value='#rsGarantia.CMPProceso#';
								document.form1.CMPid.value='#rsGarantia.CMPid#';
							</cfoutput>
						</cfif>	
						function validatc(CambioMoneda)
						{
							document.form2.CODGTipoCambio.disabled = false;		
							if (document.form2.CODGMcodigo.value == document.form2.monedalocal.value)
							{
								document.form2.CODGTipoCambio.value = "1.0000";
								document.form2.CODGTipoCambio.disabled = true;          			
							}
							else
							{
								if (! CambioMoneda && document.form2.CODGTipoCambio.value != document.form2.TCsug.value)
								{
									if (!confirm('El tipo de cambio ha sido cambiado. ¿Desea obtener el tipo de cambio histórico?'))
										return;
								}
								document.form2.CODGTipoCambio.value = "";
								if (document.form2.CODGMcodigo.value == document.form1.Mcodigo.value)
								{
									document.form2.CODGTipoCambio.disabled = true;          			
								}
								document.getElementById('ifrTC').src = "GarantiaTC.cfm?TCsug&CODGFecha=" + escape(document.form2.CODGFecha.value) + "&CODGMcodigo=" + document.form2.CODGMcodigo.value;
							}
						}
				
						function validatcLOAD()
						{                      		  
							  <cfif modo EQ "ALTA">
									if (document.form2.CODGMcodigo.value==document.form2.monedalocal.value)	{
										document.form2.CODGTipoCambio.value = "1.0000";                                
										document.form2.CODGTipoCambio.disabled = true;
									}  
									else {
										document.form2.CODGMcodigo.value=document.form2.monedalocal.value;
										document.form2.CODGTipoCambio.value = "1.0000";
										document.form2.CODGTipoCambio.disabled = true;                    
									} 
								<cfelse>
									if (document.form2.CODGMcodigo.value==document.form2.monedalocal.value)
									{
										document.form2.CODGTipoCambio.value = "1.0000";
										document.form2.CODGTipoCambio.disabled = true;
									}
									else if(document.form2.CODGMcodigo.value==document.form1.Mcodigo.value)
									{
										document.form2.CODGTipoCambio.disabled = true;
									}
									else
									{
										document.form2.CODGTipoCambio.disabled = false;
									}
								</cfif>   
					
							} 
						
							function funcSummit()
							{
								document.form2.CODGTipoCambio.disabled = false;
							}
							
							function fnGarantia(CMPid,CMPProceso){
								document.form1.CMPid.value=CMPid;
								document.form1.CMPid_codigo.value=CMPid;
								document.form1.CMPid_descripcion.value=CMPProceso;
							}
						
						validatcLOAD();
					</script> 

                <cfflush interval="16">
        
                <!--- Mantener los filtros al navegar --->
                <cf_navegacion name="CODGNumeroGarantia" 	  default="" 	navegacion="navegacion">
                <cf_navegacion name="Bdescripcion"   		  default="" 	navegacion="navegacion">
                <cf_navegacion name="CODGMonto" 			  default="" 	navegacion="navegacion">
               
                <cfset LvarBotones = ''>
                <cfif rsGarantia.Estado eq 'Edición' and rsGarantia.COEGMontoTotal GT 0 and rsGarantia.COEGVersion eq 1>
                    <cfset LvarBotones = 'Activar'>
                <cfelseif rsGarantia.Estado eq 'Edición' and rsGarantia.COEGMontoTotal GT 0 and rsGarantia.COEGVersion gt 1>
                    <cfset LvarBotones = 'Activar, Descartar'>
                <cfelseif rsGarantia.Estado eq 'Edición' and rsGarantia.COEGMontoTotal eq 0 and rsGarantia.COEGVersion gt 1>
                    <cfset LvarBotones = 'Descartar'>
                </cfif>
                <!--- No se permite borrar una garantía, si se equiboca tiene que liberarla y poner en descripción que se libera por error en el registro. --->

				<cfset LvarirA = "GarantiaForm.cfm?COEGReciboGarantia="&form.COEGReciboGarantia&"&COEGVersion="&form.COEGVersion>

                <cfinvoke component="sif.Componentes.pListas" method="pListaRH"
                 returnvariable="pLista">
                    <cfinvokeargument name="columnas" 				value=" COEGid,
                                                                            CODGid ,
                                                                            CODGFecha,
                                                                            CODGMonto,
                                                                            d.Miso4217,                                                                            
                                                                            CODGTipoCambio,
                                                                            CODGNumeroGarantia,
                                                                            CODGNumDeposito, 
                                                                            a.Bid,
                                                                            b.Bdescripcion,
                                                                            CBid,
                                                                            a.COTRid,
                                                                            c.COTRCodigo"/>
                    <cfinvokeargument name="tabla" 				value=" CODGarantia a
                                                                        inner join Bancos b
                                                                        on b.Bid = a.Bid
                                                                        inner join COTipoRendicion c
                                                                        on c.COTRid = a.COTRid 
                                                                        inner join Monedas d
                                                                        on d.Mcodigo = a.CODGMcodigo"/>
                    <cfinvokeargument name="filtro" 			value="a.COEGid = #form.COEGid# "/>
                    <cfinvokeargument name="desplegar" 			value="CODGNumeroGarantia, COTRCodigo, Bdescripcion, CODGMonto, Miso4217"/>
                    <cfinvokeargument name="etiquetas" 			value="Número de Garantía, Tipo Rendición, Banco, Monto, Moneda"/>
                    <cfinvokeargument name="formatos" 			value="S,S,S,M,U"/>
                    <cfinvokeargument name="align" 				value="left,left,left,right,right"/>
                    <cfinvokeargument name="usaAJAX" 			value="no"/>
                    <cfinvokeargument name="conexion" 			value="#session.DSN#"/>
                    <cfinvokeargument name="ajustar" 			value="S"/>
                    <cfinvokeargument name="navegacion" 		value="#navegacion#"/>
                    <cfinvokeargument name="irA" 				value="#LvarirA#"/>
                    <cfinvokeargument name="showLink" 			value="true"/>
                    <cfinvokeargument name="debug" 				value="N"/>
                    <cfinvokeargument name="Keys" 				value="CODGid,COEGid"/>
                    <cfinvokeargument name="mostrar_filtro" 	value="True"/>
                    <cfinvokeargument name="filtrar_automatico" value="false"/>
                    <cfinvokeargument name="filtrar_por" 		value="CODGNumeroGarantia, COTRCodigo, Bdescripcion, ' ', ' '"/>
                    <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
                    <cfinvokeargument name="MaxRows" 			value="0"/>
                    <cfinvokeargument name="incluyeform" 		value="TRUE"/>
                    <cfinvokeargument name="formname" 			value="form3"/>
                    <cfinvokeargument name="botones" 			value="#LvarBotones#"/>
                    <cfinvokeargument name="PageIndex" 			value="2"/>
                </cfinvoke>	
			</cfoutput>
        </cfif>
    <cf_web_portlet_end>
<cf_templatefooter>
 
<cfif isdefined("form.COEGid") and len(trim(form.COEGid))>
    <cf_qforms form='form2' objForm="objForm2">
        <cf_qformsRequiredField name="CODGNumeroGarantia" description="Número de Garantía" form="form2">
        <cf_qformsRequiredField name="COTRid" description="Tipo de Retención" form="form2">
        <cf_qformsRequiredField name="Bid" description="Banco" form="form2">
<!---        <cf_qformsRequiredField name="CODGMcodigo" description="Moneda" form="form2">
--->        <cf_qformsRequiredField name="CODGMonto" description="Monto" form="form2">
        <cf_qformsRequiredField name="CODGTipoCambio" description="Tipo de Cambio" form="form2">
        <cf_qformsRequiredField name="CODGFechaIni" description="Fecha incial" form="form2">
        <cf_qformsRequiredField name="CODGFechaFin" description="Fecha final" form="form2">
        <cf_qformsRequiredField name="CODGObservacion" description="Observaciones" form="form2">
    </cf_qforms>
</cfif>

<script language="javascript">
	<cfif isdefined("form.COEGid") and len(trim(form.COEGid))>
		<cfif isdefined("rsGarantiaD") and rsGarantiaD.COTRGenDeposito eq 1>
			document.getElementById("CODGNumDepositoCampo").style.display 	= '';
			document.getElementById("CODGNumDepositoEtiqueta").style.display 	= '';
			document.getElementById("CBidCampo").style.display 	= '';
			document.getElementById("CBidEtiqueta").style.display 	= '';
		<cfelse>
			document.getElementById("CODGNumDepositoCampo").style.display 	= 'none';
			document.getElementById("CODGNumDepositoEtiqueta").style.display 	= 'none';
			document.getElementById("CBidCampo").style.display 	= 'none';
			document.getElementById("CBidEtiqueta").style.display 	= 'none';
		</cfif>
	</cfif>
	
	function funcAltaE() {
		if (confirm('¿Está seguro que los datos de la garantía son correctos y que desea continuar?'))
		{
			if (document.form1.botonSelE.value == 'AltaE') 
				{
				document.form1.CMPMontoProceso.value = qf(document.form1.CMPMontoProceso.value);
				}
				 if(document.form1.Modo.value == 'Alta') 
			     objForm1.CMPid.required= document.form1.COEGContratoAsociado.checked;
				
			else
				objForm1.CMPid.required=false;
			return true;
		} else {
			return false;
		}	
	}
	function funcRegresarE(){
		deshabilitarValidacion_form1();
		document.form1.action = 'Garantia.cfm';
		document.form1.submit();
	}
		
	function funcAltaD() {
			if (confirm('¿Está seguro que los datos del detalle de la garantía son correctos y que desea continuar?'))
			{
				if (document.form2.botonSelD.value == 'AltaD') 
					{
					document.form2.CODGMonto.value = qf(document.form2.CODGMonto.value);
					}
				return true;
			} else {
				return false;
			}	
	}
	
	function funcCambioD() { 
		if (document.form2.botonSelD.value == 'CambioD') 
		{
		document.form2.CODGMonto.value = qf(document.form2.CODGMonto.value);
		}
	}
	<cfif modo neq 'Alta'>
		<cfoutput>
			function funcActivar(){
				deshabilitarValidacion_form1();
				document.form3.action = 'GarantiaSql.cfm?COEGid=#form.COEGid#&COEGEstado=#rsGarantia.COEGEstado#&COEGReciboGarantia=#form.COEGReciboGarantia#&COEGVersion=#form.COEGVersion#';
				document.form3.submit();
			}
			
			function funcDescartar(){
				deshabilitarValidacion_form1();
				document.form3.action = 'GarantiaSql.cfm?COEGid=#rsGarantia.COEGid#&COEGEstado=#rsGarantia.COEGEstado#&COEGReciboGarantia=#rsGarantia..COEGReciboGarantia#&COEGVersion=#rsGarantia.COEGVersion#';
				document.form3.submit();
			}
			function funcEditarE(){
				if (document.form1.COEGContratoAsociado.value == "S")
					objForm1.CMPid.required=true;
				else
					objForm1.CMPid.required=false;
			}
		</cfoutput>
		function funcFiltrar(){
			<cfset LvarirAFiltro = "GarantiaForm.cfm?COEGReciboGarantia="&form.COEGReciboGarantia&"&COEGVersion="&form.COEGVersion&"&COEGid="&form.COEGid>
			document.form3.action = '<cfoutput>#LvarirAFiltro#</cfoutput>';
			document.form3.submit();
		}
	</cfif>
	
	function funcionDeposito(){
		if (document.form2.COTRGenDepositoBit.value == 1)
		{
			document.getElementById("CODGNumDepositoCampo").style.display 	= '';
			document.getElementById("CODGNumDepositoEtiqueta").style.display 	= '';
			document.getElementById("CBidCampo").style.display 	= '';
			document.getElementById("CBidEtiqueta").style.display 	= '';
		}
		else{
			document.getElementById("CODGNumDepositoCampo").style.display 	= 'none';
			document.getElementById("CODGNumDepositoEtiqueta").style.display 	= 'none';
			document.getElementById("CBidCampo").style.display 	= 'none';
			document.getElementById("CBidEtiqueta").style.display 	= 'none';
		}
			document.getElementById('ifrMonedaTodas').src = "GarantiaMoneda.cfm?Todas";
	}
	

</script>

<cffunction name="fnProcesaE" output="yes" returntype="any">
	<cfset LvarConsecutivo = -1>
    <cfif modo neq 'Alta'>
        <cfquery name="rsGarantia" datasource="#session.DSN#">
            select 
                a.CMPid,
                b.COEGid,
                a.CMPProceso, 
				a.CMPMontoProceso,
                c.SNcodigo,
                c.SNnumero,
                c.SNnombre,
                b.COEGReciboGarantia,
                case b.COEGTipoGarantia
                when 1 then 'Participación'
                when 2 then 'Cumplimiento'
                end as TipoGarantia,
                d.Miso4217,
				d.Msimbolo,
                b.Mcodigo,
                b.COEGMontoTotal,
                a.CMPMontoProceso,
                a.CMPMontoProceso as CMPMontoProcesoVisual,
                case b.COEGEstado
                when 1 then 'Vigente'
                when 2 then 'Edición'
                when 3 then 'En proceso de Ejecución'
                when 4 then 'En Ejecución'
                when 5 then 'Ejecutada'
                when 6 then 'En proceso Liberación'
                when 7 then 'Liberada'
                when 8 then 'Devuelta'
                end as Estado,
                a.CMPLinea,
                b.COEGFechaRecibe,
                b.COEGPersonaEntrega,
                b.COEGIdentificacion,
                b.COEGVersion,
                b.COEGTipoGarantia,
                b.COEGEstado,
				case when b.COEGContratoAsociado = 'N' then 'NO' else 'SI' end as COEGContratoAsociado
            from COEGarantia b
                left join CMProceso a
                on a.CMPid = b.CMPid
                
                left join SNegocios c<!---Consultar si usar left en ves de inner--->
                on c.SNid = b.SNid
                
                inner join Monedas d
                on d.Mcodigo = b.Mcodigo
            where b.COEGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COEGid#">
        </cfquery>
    </cfif>
</cffunction>

<cffunction name="fnProcesaD" output="no" returntype="any">
	<cfquery name="rsGarantiaD" datasource="#session.DSN#">
    	select 
	        COEGid,
            CODGid ,
            CODGFecha,
            CODGMonto,
            CODGMcodigo,
            CODGTipoCambio,
            CODGNumeroGarantia,
            a.COTRid, 
            CODGFechaIni,
            CODGFechaFin,
            CODGObservacion, 
            CcuentaRecibida, 
            CcuentaGarxPagar,
            CODGNumDeposito, 
            a.Bid,
            b.Bdescripcion,
            a.CBid,
            d.CBcodigo,
            d.CBdescripcion,
            a.BTid,
            bt.BTcodigo, 
            bt.BTdescripcion, 
            bt.BTtipo,
            c.COTRCodigo,
            c.COTRDescripcion,
            c.COTRGenDeposito,
            c.COTRmodificar,
            a.CcuentaRecibida,
            a.CcuentaGarxPagar,
            a.Ccuenta, 
            cc.Cformato, 
            cc.Cdescripcion,
			(select count(1) from COHDGarantia hgd where hgd.CODGid = a.CODGid and hgd.COEGid = a.COEGid and hgd.COEGVersion = #LvarVersion - 1#) existeEnHD
		from CODGarantia a

            inner join Bancos b
            on b.Bid = a.Bid

			inner join COTipoRendicion c
            on c.COTRid = a.COTRid

            left outer join BTransacciones bt
            on bt.BTid = a.BTid

            left outer join CContables cc
			on cc.Ccuenta = a.Ccuenta
           
            left outer join CuentasBancos d
            	on d.CBid = a.CBid
				and d.CBesTCE = 0
			
        where CODGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CODGid#">
        and COEGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COEGid#">
        <!--- Se busca por la garantía y la version no por los ids --->
    </cfquery>
</cffunction>

<cffunction name="BuscaTC" access="public" output="no" returntype="any">
	<cfargument name="Mcodigo" type="numeric" required="yes">
    <cfargument name="Fecha"   type="date" 	  required="yes">
    <cfargument name="TCxUsar" type="string"  required="yes" default="V" hint="V para venta y C para compra"> 
    
    <cfquery name="rsLocal" datasource="#session.dsn#">
        select Mcodigo 
        from Empresas 
        where Ecodigo = #session.Ecodigo#
    </cfquery>
    
    <cfif rsLocal.Mcodigo eq arguments.Mcodigo>
		<cfset LvarTC = 1.00>
	<cfelse>
    	<cfquery name="rsTC" datasource="#session.DSN#">
            select TCventa, TCcompra
            from Htipocambio
            where Mcodigo = #arguments.Mcodigo#
              and Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.Fecha#">
              and Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.Fecha#">
        </cfquery>
    	<cfif rsTC.recordcount eq 0>
            <cfquery name="rsMiso" datasource="#session.dsn#">
                select Miso4217
                from Monedas 
                where Mcodigo = #arguments.Mcodigo#
            </cfquery>
            <cfthrow message="No se ha incluido un tipo de cambio para la moneda '#rsMiso.Miso4217#' en la fecha #arguments.Fecha#">
        </cfif>
        
        <cfif arguments.TCxUsar eq 'V'>
            <cfset LvarTC = rsTC.TCventa>
        <cfelse>
            <cfset LvarTC = rsTC.TCcompra>
        </cfif>
    </cfif>

	<cfreturn LvarTC>
</cffunction>
