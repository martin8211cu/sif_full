<!--- UTILES JS --->
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<!--- /UTILESJS --->
<!--- QFORMS --->
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language='javascript' type='text/JavaScript' >
<!--//
	qFormAPI.setLibraryPath('/cfmx/sif/js/qForms/');
	qFormAPI.include('*');
//-->
</script>

<!--- /QFORMS --->
<form action="polizaDesalmacenaje-sql.cfm" method="post" name="form1" onSubmit="javascript: return _endform();">
	<input type="hidden" id="Pagina2" name="Pagina2" value="<cfif (isdefined("form.Pagina2") and len(form.Pagina2))><cfoutput>#form.Pagina2#</cfoutput><cfelse>1</cfif>">
	<input type="hidden" id="Pagina3" name="Pagina3" value="<cfif (isdefined("form.Pagina3") and len(form.Pagina3))><cfoutput>#form.Pagina3#</cfoutput><cfelse>1</cfif>">
	<input type="hidden" id="Pagina4" name="Pagina4" value="<cfif (isdefined("form.Pagina4") and len(form.Pagina4))><cfoutput>#form.Pagina4#</cfoutput><cfelse>1</cfif>">
	<cfoutput>
		<!--- Encabezado de la póliza --->
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="SubTitulo" align="center" style="text-transform:uppercase ">Encabezado de la P&oacute;liza</td>
			</tr>
		</table>
		<table width="100%"  border="0" cellspacing="2" cellpadding="2">
			<tr>
				<!--- Número de la póliza --->
				<td width="1%" nowrap><strong>P&oacute;liza&nbsp;:&nbsp;</strong></td>
                <td><input name='EPDnumero' tabindex="1"
						type='text' 
						size='20' 
						maxlength='18' 
						onFocus='this.select();' 
						value='<cfif (lcase(modo) eq 'cambio')>#HTMLEditFormat(rsEPD.EPDnumero)#</cfif>'>
				</td>
				<!--- Descripción de la póliza y observaciones --->
				<td width="1%" nowrap>
					<strong>Descripci&oacute;n&nbsp;:&nbsp;</strong>
				</td>
				<td>
					<table>
					  <tr>
						<td><input type="text" size="40" name="EPDdescripcion" value="<cfif (lcase(modo) eq 'cambio')>#rsEPD.EPDdescripcion#</cfif>" tabindex ="1"></td>
						<td>
							<cfif (lcase(modo) eq 'cambio')>
								<cf_sifinfo name="EPDobservaciones" titulo="#JSStringFormat('Observaciones de la Póliza')#" height="290" value="#JSStringFormat(rsEPD.EPDobservaciones)#">
							<cfelse>
								<cf_sifinfo name="EPDobservaciones" titulo="#JSStringFormat('Observaciones de la Póliza')#" height="290">
							</cfif>
						</td>
					  </tr>
					</table>
				</td>
				<!--- Número de embarque de la póliza --->
				<td width="1%" nowrap><strong>Embarque&nbsp;:&nbsp;</strong></td>
				<td>
					<input type="hidden" name="ETidtracking_move" value="<cfif isdefined("rsEPD.ETidtracking_move")>#rsEPD.ETidtracking_move#</cfif>">
					<input type="text" readonly="" size="10" name="ETconsecutivo_move" value="<cfif isdefined("rsEPD.ETconsecutivo_move")>#rsEPD.ETconsecutivo_move#</cfif>">
					<input type="hidden" name="ETnumtracking_move" value="<cfif isdefined("rsEPD.ETnumtracking_move")>#rsEPD.ETnumtracking_move#</cfif>">
					<cfif (lcase(modo) neq 'cambio')>
						<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Trackings de Embarque" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisTrackings();'></a>
					</cfif>
				</td>
			</tr>
			<!---Validacion de Campos Obligatorios, para el seguimiento de tracking seleccionado
                     en caso de que no se suministren no se permite cerrar la poliza--->
			<cfquery name="rsValidarSeguimiento" datasource="#session.DSN#">
				  Select Coalesce(Pvalor,'N') as Pvalor
					from Parametros 
				   where Pcodigo = 15652
					 and Mcodigo = 'CM'
					 and Ecodigo = #session.Ecodigo# 
			</cfquery> 
			
			<cfif (lcase(modo) eq 'cambio') and rsValidarSeguimiento.Pvalor eq 'S' and isdefined("rsEPD.ETidtracking_move") and len(trim(rsEPD.ETidtracking_move))>
				<!---Campos requeridos segun catalogo de actividad de Tracking--->
				<cfquery name="rsCamposAvalidar" datasource="sifpublica">
					select 	(select count(1) from CMActividadTracking where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and ETA_R = 1) as ETA_R,
								(select count(1) from CMActividadTracking where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and ETA_A = 1) as ETA_A,
								(select count(1) from CMActividadTracking where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and ETS = 1) as ETS,
								(select count(1) from CMActividadTracking where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and CMATFDO = 1) as CMATFDO
				</cfquery>
				<cfset varETA_R = 0><cfset varETA_A 	= 0>
				<cfset varETS  	 =	0><cfset varCMATFDO  	=	0>
				<!---Asignacion de Campos obligatorios--->
				<cfloop query="rsCamposAvalidar">
					<cfif rsCamposAvalidar.ETA_R gt 0><cfset varETA_R	= 1></cfif>
					<cfif rsCamposAvalidar.ETA_A gt 0><cfset varETA_A = 1></cfif>
					<cfif rsCamposAvalidar.ETS gt 0><cfset varETS =	1></cfif>
					<cfif rsCamposAvalidar.CMATFDO gt 0><cfset varCMATFDO =	1></cfif>
				</cfloop>
				
				<cf_dbdatabase name ="database" table="DTracking" datasource="sifpublica" returnvariable="DtrackingTable">
				<cf_dbdatabase name ="database" table="CMActividadTracking" datasource="sifpublica" returnvariable="ActividadTrackingTable">
				<cfquery name="rsValidaSeguimiento" datasource="#session.dsn#">
					select  	atk.ETA_R,
									atk.ETA_A,
									atk.CMATFDO,
									atk.ETS
					from #DtrackingTable# a
						inner join ETracking et
							on et.ETidtracking = a.ETidtracking
						left join #ActividadTrackingTable# atk
							on atk.CMATid      	= a.CMATid
							and atk.Ecodigo  	= a.Ecodigo
					where a.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEPD.ETidtracking_move#">
				</cfquery>
				
				<cfset act1 = 0><!---ETA_R--->
				<cfset act2 = 0><!---ETA_A--->
				<cfset act3 = 0><!---ETS--->
				<cfset act4 = 0><!---CMATFDO--->
				<cfloop query="rsValidaSeguimiento">
					<cfif varETA_R eq 1 and rsValidaSeguimiento.ETA_R gt 0><cfset act1 = act1+1></cfif>
					<cfif varETA_A eq 1 and rsValidaSeguimiento.ETA_A gt 0><cfset act2 = act2+1></cfif>
					<cfif varETS eq 1 and rsValidaSeguimiento.ETS gt 0><cfset act3 = act3+1></cfif>
					<cfif varCMATFDO eq 1 and rsValidaSeguimiento.CMATFDO gt 0><cfset act4= act4+1></cfif>
				</cfloop>
				<!---Campos necesarios a mostrar--->
				<cfset CamposRequeridos = "">
				<cfif varETA_R eq 1 and act1 lt 1>
						<cfif CamposRequeridos eq ""><cfset CamposRequeridos = CamposRequeridos &"ETA Real"><cfelse><cfset CamposRequeridos = CamposRequeridos &", ETA Real"></cfif>
					</cfif>
					<cfif varETA_A eq 1 and act2 lt 1>
						<cfif CamposRequeridos eq ""><cfset CamposRequeridos = CamposRequeridos& "ETA Actualizado"><cfelse><cfset CamposRequeridos = CamposRequeridos &", ETA Actualizado"></cfif>
					</cfif>
					<cfif varETS eq 1 and act3 lt 1>
						<cfif CamposRequeridos eq ""><cfset CamposRequeridos = CamposRequeridos& "Salida del puerto Origen"><cfelse><cfset CamposRequeridos = CamposRequeridos &", Salida del puerto origen"></cfif>
					</cfif>
					<cfif varCMATFDO eq 1 and act4 lt 1>
						<cfif CamposRequeridos eq ""><cfset CamposRequeridos = CamposRequeridos& "Envío de los Documentos a la aduana"><cfelse><cfset CamposRequeridos = CamposRequeridos &", Envío de los documentos a la aduana"></cfif>
					</cfif>
				<!---Mensaje para el usuario sobre los campos requeridos--->
				<tr style="display:<cfif CamposRequeridos neq "">line<cfelse>none</cfif>;">
				<td colspan="4" align="right">&nbsp;</td>
				<td colspan="2" align="left">
						El tracking de la p&oacute;liza, no tiene la(s)  siguiente(s) actividad(es) de seguimiento requerida(s):<br>
					<font color="red" ><i><cfoutput>#CamposRequeridos#</cfoutput></i></font>
				</td>
			</tr>
			</cfif>
				
				<!--- Agencia Aduanal de la póliza --->
				<td width="1%" nowrap><strong>Agencia Aduanal&nbsp;:&nbsp;</strong></td>
				<td>
					<select name="CMAAid" tabindex="1">
						<cfloop query="rsCMAgenciaAduanal">
							<option value="#CMAAid#" <cfif (lcase(modo) eq 'cambio' and CMAAid eq rsEPD.CMAAid)>selected</cfif>>
								#HTMLEditFormat(CMAAdescripcion)#
							</option>
						</cfloop>
					</select>
				</td>
				<!--- Aduana de la póliza --->
				<td width="1%" nowrap><strong>Aduana&nbsp;:&nbsp;</strong></td>
				<td>
					<select name="CMAid" tabindex="1">
						<cfloop query="rsCMAduanas">
							<option value="#CMAid#" <cfif (lcase(modo) eq 'cambio' and CMAid eq rsEPD.CMAid)>selected</cfif>>
								#HTMLEditFormat(CMAdescripcion)#
							</option>
						</cfloop>
					</select>
				</td>
				<!--- Exportador (TAGSOCIOS) --->
				<td width="1%" nowrap><strong>Exportador&nbsp;:&nbsp;</strong></td>
				<td>
					<cfif (lcase(modo) eq 'cambio')>
						<cf_sifsociosnegocios2 sntiposocio="P" tabindex="1" idquery="#rsEPD.SNcodigo#">
					<cfelse>
						<cf_sifsociosnegocios2 sntiposocio="P" tabindex="1">
					</cfif>
				</td>
			</tr>
			<tr>
				<!--- Fecha --->
				<td width="1%" nowrap><strong>Fecha&nbsp;:&nbsp;</strong></td>
				<td>
					<cfif (lcase(modo) eq 'cambio')>
						<cf_sifcalendario value="#LSDateFormat(rsEPD.EPDfecha,'dd/mm/yyyy')#" tabindex="1" name="EPDfecha">
					<cfelse>
						<cf_sifcalendario value="#LSDateFormat(Now(),'dd/mm/yyyy')#"tabindex="1" name="EPDfecha">
					</cfif>
				</td>
				<!--- País de origen --->
				<td width="1%" nowrap><strong>Pa&iacute;s de Origen&nbsp;:&nbsp;</strong></td>
				<td>
                 <!--- Asiganacion de las variables en caso de ser modo cambio --->
                    <cfset ArrayDatosOrigen=ArrayNew(1)>
					<cfif (lcase(modo) eq 'cambio')>
                    	<cfquery name="rsPaisOri" datasource="#session.dsn#">
                        	select po.Ppais as EPDpaisori, po.Pnombre as PnombreOri 
                            from Pais as po
                            where po.Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEPD.EPDpaisori#">
                        </cfquery>
						<cfset ArrayAppend(ArrayDatosOrigen,rsPaisOri.EPDpaisori)>
						<cfset ArrayAppend(ArrayDatosOrigen,rsPaisOri.PnombreOri)>
					</cfif>
					<cf_conlis 
                                    title		   				="Pais de Origen"
                                    campos 				= "EPDpaisori,PnombreOri" 
                                    ValuesArray		="#ArrayDatosOrigen#" 
                                    desplegables 	= "N,S" 
                                    modificables 		= "N,S"
                                    size 					= "0,0"
                                    tabla					="Pais as po" 
                                    columnas			="po.Ppais as EPDpaisori, po.Pnombre as PnombreOri"
                                    filtrar_por				="po.Ppais,po.Pnombre"
                                    desplegar			="EPDpaisori, PnombreOri"
                                    etiquetas			="Abreviatura, Nombre"
                                    formatos				="V,V"
                                    align						="left,left"
                                    tabindex				= "7"
                                    form						= "form1"
                                    asignar				="EPDpaisori, PnombreOri"
                                    asignarformatos	="S,S">                                    
				</td>
				<!--- País de procedencia --->
				<td width="1%" nowrap><strong>Pa&iacute;s de Procedencia&nbsp;:&nbsp;</strong></td>
				<td>
                    <!--- Asiganacion de las variables en caso de ser modo cambio --->
                    <cfset ArrayDatosProc=ArrayNew(1)>
					<cfif (lcase(modo) eq 'cambio')>
                    	<cfquery name="rsPaisProc" datasource="#session.dsn#">
                        	select pc.Ppais as EPDpaisproc, pc.Pnombre as PnombreProc
                            from Pais as pc 
                            where pc.Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEPD.EPDpaisproc#">
                        </cfquery>
						<cfset ArrayAppend(ArrayDatosProc,rsPaisProc.EPDpaisproc)>
						<cfset ArrayAppend(ArrayDatosProc,rsPaisProc.PnombreProc)>
					</cfif>
                    <cf_conlis 
                                    title		   				="Pais de Procedencia"
                                    campos 				= "EPDpaisproc,PnombreProc" 
                                    ValuesArray		="#ArrayDatosProc#" 
                                    desplegables 	= "N,S" 
                                    modificables 		= "N,S"
                                    size 					= "0,0"
                                    tabla					="Pais as pc" 
                                    columnas			="pc.Ppais as EPDpaisproc, pc.Pnombre as PnombreProc"
                                    filtrar_por				="pc.Ppais,pc.Pnombre"
                                    desplegar			="EPDpaisproc, PnombreProc"
                                    etiquetas			="Abreviatura, Nombre"
                                    formatos				="V,V"
                                    align						="left,left"
                                    tabindex				= "7"
                                    form						= "form1"
                                    asignar				="EPDpaisproc, PnombreProc"
                                    asignarformatos	="S,S">
				</td>
			</tr>
			<tr>
				<!--- Cantidad de bultos --->
				<td width="1%" nowrap><strong>Cantidad de Bultos&nbsp;:&nbsp;</strong></td>
				<td>
					<input name='EPDtotbultos' tabindex="1"
						type='text' 
						size='20' 
						maxlength='18' 
						style='text-align: right'  
						onFocus='this.value=qf(this); this.select();' 
						onBlur='javascript: fm(this,0);' 
						onKeyUp='javascript: if(snumber(this,event,0)){ if(Key(event)==&quot;13&quot;) {this.blur();}}' value='<cfif (lcase(modo) eq 'cambio')>#rsEPD.EPDtotbultos#<cfelse>0</cfif>'>
				</td>
				<!--- Peso bruto --->
				<td width="1%" nowrap><strong>Peso Bruto (kg)&nbsp;:&nbsp;</strong></td>
				<td>
					<input name='EPDpesobruto' tabindex="1"
						type='text' 
						size='20' 
						maxlength='18' 
						style='text-align: right'  
						onFocus='this.value=qf(this); this.select();' 
						onBlur='javascript: fm(this,2);' 
						onKeyUp='javascript: if(snumber(this,event,2)){ if(Key(event)==&quot;13&quot;) {this.blur();}}' value="<cfif (lcase(modo) eq 'cambio')>#LSCurrencyFormat(rsEPD.EPDpesobruto,'none')#<cfelse>0.00</cfif>">
				</td>
				<!--- Peso neto --->
				<td width="1%" nowrap><strong>Peso Neto (kg)&nbsp;:&nbsp;</strong></td>
				<td>
					<input name='EPDpesoneto' tabindex="1"
						type='text' 
						size='20' 
						maxlength='18' 
						style='text-align: right'  
						onFocus='this.value=qf(this); this.select();' 
						onBlur='javascript: fm(this,2);' 
						onKeyUp='javascript: if(snumber(this,event,2)){ if(Key(event)==&quot;13&quot;) {this.blur();}}' value="<cfif (lcase(modo) eq 'cambio')>#LSCurrencyFormat(rsEPD.EPDpesoneto,'none')#<cfelse>0.00</cfif>">
				</td>
			</tr>
			<tr>
				<td><strong>Moneda:</strong></td>
				<cfquery name="rsMonedas" datasource="#session.DSN#">
					select b.Mnombre
					from Empresas a 
						inner join Monedas b
							on a.Mcodigo = b.Mcodigo
							and a.Ecodigo = b.Ecodigo
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">					
				</cfquery>
				<td>#rsMonedas.Mnombre#</td>
                <td colspan="2">
                	<input type="checkbox" name="PermiteDesParcial" id="PermiteDesParcial" value="1" <cfif (lcase(modo)) eq 'cambio' and rsEPD.PermiteDesParcial eq 1>checked="checked"</cfif>/><label for="PermiteDesParcial"> Permite Desalmacenajes parciales</label>
                </td>
                <td>
                </td>
			</tr>
			<tr><td colspan="6">&nbsp;</td></tr>
		</table>
		<fieldset><legend>Valores declarados de la póliza</legend>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="1%" nowrap><strong>FOB&nbsp;:&nbsp;</strong></td>
			<td>
				<input name='EPDFOBDecAduana' tabindex="1"
						type='text' 
						size='20' 
						maxlength='18' 
						style='text-align: right'  
						onFocus='this.value=qf(this); this.select();' 
						onBlur='javascript: fm(this,2); funcCalculaMtoDeclarado();' 
						onKeyUp='javascript: if(snumber(this,event,2)){ if(Key(event)==&quot;13&quot;) {this.blur();}}'
						value="<cfif (lcase(modo) eq 'cambio')>#LSCurrencyFormat(rsEPD.EPDFOBDecAduana,'none')#<cfelse>0.00</cfif>">
			</td>
			<td width="1%" nowrap><strong>Fletes&nbsp;:&nbsp;</strong></td>
			<td>
				<input name='EPDFletesDecAduana' tabindex="1"
						type='text' 
						size='20' 
						maxlength='18' 
						style='text-align: right'  
						onFocus='this.value=qf(this); this.select();' 
						onBlur='javascript: fm(this,2); funcCalculaMtoDeclarado();' 
						onKeyUp='javascript: if(snumber(this,event,2)){ if(Key(event)==&quot;13&quot;) {this.blur();}}'
						value="<cfif (lcase(modo) eq 'cambio')>#LSCurrencyFormat(rsEPD.EPDFletesDecAduana,'none')#<cfelse>0.00</cfif>">
			</td>
			<td width="1%" nowrap><strong>Seguros&nbsp;:&nbsp;</strong></td>
			<td>
				<input name='EPDSegurosDecAduana' tabindex="1"
						type='text' 
						size='20' 
						maxlength='18' 
						style='text-align: right'  
						onFocus='this.value=qf(this); this.select();' 
						onBlur='javascript: fm(this,2); funcCalculaMtoDeclarado();' 
						onKeyUp='javascript: if(snumber(this,event,2)){ if(Key(event)==&quot;13&quot;) {this.blur();}}'
						value="<cfif (lcase(modo) eq 'cambio')>#LSCurrencyFormat(rsEPD.EPDSegurosDecAduana,'none')#<cfelse>0.00</cfif>">
			</td>
			<td width="1%" nowrap><strong>Gastos&nbsp;:&nbsp;</strong></td>
			<td>
				<input name='EPDGastosDecAduana' tabindex="1"
						type='text' 
						size='20' 
						maxlength='18' 
						style='text-align: right'  
						onFocus='this.value=qf(this); this.select();' 
						onBlur='javascript: fm(this,2); funcCalculaMtoDeclarado();' 
						onKeyUp='javascript: if(snumber(this,event,2)){ if(Key(event)==&quot;13&quot;) {this.blur();}}'
						value="<cfif (lcase(modo) eq 'cambio')>#LSCurrencyFormat(rsEPD.EPDGastosDecAduana,'none')#<cfelse>0.00</cfif>">
			</td>
			<td width="1%" nowrap><strong>Total declarado&nbsp;:&nbsp;</strong></td>
			<td>
				<input name='Total_Declarado' tabindex="1" readonly=""				
						type='text' 
						size='20' 
						maxlength='18' 
						style='text-align: right'  
						onFocus='this.value=qf(this); this.select();' 
						onBlur='javascript: fm(this,2);' 
						onKeyUp='javascript: if(snumber(this,event,2)){ if(Key(event)==&quot;13&quot;) {this.blur();}}'
						value="<cfif (lcase(modo) eq 'cambio')>#LSCurrencyFormat(rsEPD.total_declarado,'none')#<cfelse>0.00</cfif>">
			</td>
		  </tr>
		</table>
	  </fieldset>
	  <table><tr><td>&nbsp;</td></tr></table>
		<fieldset><legend>Calcular Seguro Propio</legend>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="1%" nowrap><strong>Moneda&nbsp;:&nbsp;</strong></td>
			<td>
				<cfif (lcase(modo) eq 'cambio') and len(trim(rsEPD.Mcodigoref)) and rsEPD.Mcodigoref>
					<cf_sifmonedas Mcodigo="Mcodigoref" tabindex="1" value="#rsEPD.Mcodigoref#" onChange="asignaTC();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" >
				<cfelse>
					<cf_sifmonedas Mcodigo="Mcodigoref" tabindex="1" onChange="asignaTC();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" >
				</cfif>
			</td>
			<td width="1%" nowrap><strong>Tipo de Cambio&nbsp;:&nbsp;</strong></td>
			<td>
				<input name='EPDtcref' tabindex="1"
						type='text' 
						size='20' 
						maxlength='18' 
						style='text-align: right'  
						onFocus='this.value=qf(this); this.select();' 
						onBlur='javascript: fm(this,2);' 
						onKeyUp='javascript: if(snumber(this,event,2)){ if(Key(event)==&quot;13&quot;) {this.blur();}}'
						value="<cfif (lcase(modo) eq 'cambio')>#LSCurrencyFormat(rsEPD.EPDtcref,'none')#<cfelse>0.00</cfif>">
			</td>
			<td width="1%" nowrap><strong>Tipo de Seguro&nbsp;:&nbsp;</strong></td>
			<td>
				<select name="CMSid" tabindex="1" onChange="javascript:cambiarTS();">
					<option value="">--Ninguno--</option>
					<cfloop query="rsCMSeguros">
						<option value="#CMSid#" <cfif (lcase(modo) eq 'cambio') and rsEPD.CMSid eq CMSid>selected</cfif>>#CMSdescripcion#</option>
					</cfloop>
				</select>
			</td>
		  </tr>
		</table>
		</fieldset>
	</cfoutput>
	
	<cfif (isdefined("modo") and lcase(modo) eq "cambio")>
	
		<input type="hidden" id="EPDid" name="EPDid" value="<cfoutput>#rsEPD.EPDid#</cfoutput>">
		<input type="hidden" id="ts_rversion" name="ts_rversion" value="<cfoutput>#rsEPD.ts#</cfoutput>">
		
		<cfif (isdefined("mododet") and lcase(mododet) eq "cambio")>
			<cfif (isdefined("form.DPDlinea") and len(form.DPDlinea) and form.DPDlinea)>
				<input type="hidden" id="DPDlinea" name="DPDlinea" value="<cfoutput>#rsDPD.DPDlinea#</cfoutput>">
			</cfif>
			<input type="hidden" id="ts_rversiondet" name="ts_rversiondet" value="<cfoutput>#rsDPD.ts#</cfoutput>">
		</cfif>
		
		<!--- Detalles de la Póliza --->
		<br>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="SubTitulo" align="center" style="text-transform:uppercase ">Detalles de la P&oacute;liza</td>
			</tr>
		</table>
		<cfinclude template="polizaDesalmacenaje-formdet.cfm"><br>
	</cfif>
    <cfif (isdefined("modo") and lcase(modo) eq "cambio")>
        <cfquery name="rsVerificaHijos" datasource="#session.DSN#">
            select count(1) as cantidad
            from EPolizaDesalmacenaje b
            where b.EPDidpadre = #rsEPD.EPDid#
        </cfquery>
    </cfif>
    <cfif (isdefined("modo") and lcase(modo) eq "cambio") and len(trim(rsEPD.EPDidpadre)) gt 0><!--- Es hijo si viene un valor en EPDidpadre --->
    	<cfif rsEPD.TieneHermanos>
        	<cfset include 		 = 'btnRevertir,'>
        	<cfset includevalues = 'Revertir desalmacenaje Parcial,'>
        <cfelse>
        	<cfset include 		 = ''>
        	<cfset includevalues = ''>
        </cfif>
		<cfset include 		 = include       & 'DocsPoliza,CalcularParcial' >
        <cfset includevalues = includevalues & 'Documentos de la Poliza,Calcular Parcial'>
        <cfset exclude       = 'AltaDet,CambioDet,BajaDet,NuevoDet,Cambio,Baja'>
    <cfelseif (isdefined("modo") and lcase(modo) eq "cambio") and rsVerificaHijos.cantidad gt 0> <!--- es Padre  --->
    	<cfset include       ='MostrarCalculo' >
        <cfset includevalues = 'Mostrar Calculo Padre'>
        <cfset exclude       = 'AltaDet,CambioDet,BajaDet,NuevoDet,Cambio,Baja'>
    </cfif>
	<br>
	<cf_botones modo="#modo#" mododet="#mododet#" include="#include#" includevalues="#includevalues#" exclude="#exclude#" nameenc="Poliza" generoenc="F" tabindex="3">
	<br>
</form>
<cfoutput>

<script language='javascript' type='text/JavaScript'>
<!--//
	//Qforms
	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("form1");
	function _Field_isRango(low, high){var low=_param(arguments[0], 0, "number");
	var high=_param(arguments[1], 9999999, "number");
	var iValue=parseInt(qf(this.value));
	if(isNaN(iValue))iValue=0;
	if((low>iValue)||(high<iValue)){this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
	}}
	_addValidator("isRango", _Field_isRango);
	objForm.EPDdescripcion.description = "#JSStringFormat('Descripción')#";	
	objForm.EPDnumero.description = "#JSStringFormat('Póliza')#";
	objForm.ETconsecutivo_move.description = "#JSStringFormat('Embarque')#";
	objForm.CMAAid.description = "#JSStringFormat('Agencia Aduanal')#";
	objForm.CMAid.description = "#JSStringFormat('Aduana')#";
	objForm.SNcodigo.description = "#JSStringFormat('Exportador')#";
	objForm.EPDfecha.description = "#JSStringFormat('Fecha de Póliza')#";
 	objForm.EPDpaisori.description = "#JSStringFormat('País de Origen')#"; 
 	objForm.EPDpaisproc.description = "#JSStringFormat('País de Procedencia')#"; 
	objForm.EPDtotbultos.description = "#JSStringFormat('Cantidad de Bultos')#";
	objForm.EPDpesobruto.description = "#JSStringFormat('Peso Bruto')#";
	objForm.EPDpesoneto.description = "#JSStringFormat('Peso Neto')#";	
	<cfif (isdefined("modo") and lcase(modo) eq "cambio")>
		objForm.ETIiditem.description = "#JSStringFormat('Item del Tracking')#";
		objForm.DPDcantidad.description  = "#JSStringFormat('Cantidad')#";
		objForm.DPDmontofobreal.description  = "#JSStringFormat('Monto')#";
		objForm.CAid.description  = "#JSStringFormat('Código Aduanal')#";
		objForm.DPDpaisori.description  = "#JSStringFormat('País')#";
		objForm.Icodigo.description  = "#JSStringFormat('Impuesto')#";
		objForm.DPDpeso.description  = "#JSStringFormat('Peso')#";
	</cfif>
	<cfif (isdefined("mododet") and lcase(mododet) eq "cambio")>
		<cfif isdefined("form.DPDlinea")>
			objForm.DPDcantidad.obj.focus();
			objForm.DPDcantidad.obj.select();
		<cfelseif isdefined("form.FPid")>
			objForm.DPDmontofobreal.obj.focus();
			objForm.DPDmontofobreal.obj.select();
		</cfif>
	<cfelseif (isdefined("modo") and lcase(modo) eq "cambio")>
		objForm.DPDdescripcion.obj.focus();
	<cfelse>
		objForm.EPDnumero.obj.focus();
	</cfif>
	
	//Habilitar validación encabezado
	function habilitarValidacion(){
		objForm.required("EPDdescripcion,EPDnumero,ETconsecutivo_move,CMAAid,CMAid,SNcodigo,EPDfecha,EPDpaisori,EPDpaisproc,EPDtotbultos,EPDpesobruto,EPDpesoneto");
		if (window.funcHabilitarValidacion) funcHabilitarValidacion();
		<cfif (isdefined("modo") and lcase(modo) eq "cambio")>
		if (window.funcDesHabilitarValidacionDet) funcDesHabilitarValidacionDet();
		</cfif>
	}
	//Deshabilitar validación encabezado
	function deshabilitarValidacion(){
		objForm.required("EPDdescripcion,EPDnumero,ETconsecutivo_move,CMAAid,CMAid,SNcodigo,EPDfecha,EPDpaisori,EPDpaisproc,EPDtotbultos,EPDpesobruto,EPDpesoneto",false);
		if (window.funcDesHabilitarValidacion) funcDesHabilitarValidacion();
		<cfif (isdefined("modo") and lcase(modo) eq "cambio")>
		if (window.funcDesHabilitarValidacionDet) funcDesHabilitarValidacionDet();
		</cfif>		
	}
	
	function ConfirmaSeguro(){
		if(document.form1.CMSid.value == "")
		{
			if(!confirm("No ha seleccionado un seguro, ¿desea crear el registro?"))
				return false;
		}
		return true;
	}
	
	//Función que se ejecuta cuando ya el form se va a ir
	function _endform(){
	
		<cfif isdefined("modo") and lcase(modo) neq "cambio">
		if(!ConfirmaSeguro())
			return false;
		</cfif>

		objForm.EPDtotbultos.obj.value = qf(objForm.EPDtotbultos.obj);
		objForm.EPDpesobruto.obj.value = qf(objForm.EPDpesobruto.obj);
		objForm.EPDpesoneto.obj.value = qf(objForm.EPDpesoneto.obj);
		objForm.EPDtcref.obj.value = qf(objForm.EPDtcref.obj);
		objForm.EPDtcref.obj.disabled = false;
		<cfif (isdefined("modo") and lcase(modo) eq "cambio")>
			objForm.ETIiditem.obj.disabled = false;
			objForm.DPDdescripcion.obj.disabled = false;
			objForm.DPDcantidad.obj.disabled = false;
			objForm.DPDmontofobreal.obj.disabled = false;
			objForm.CAid.obj.disabled = false;
			objForm.DPDpaisori.obj.disabled = false;
			objForm.DPDpeso.obj.disabled = false;
			objForm.DPDcantidad.obj.value = qf(objForm.DPDcantidad.obj);
			objForm.DPDcantreclamo.obj.value = qf(objForm.DPDcantreclamo.obj);
			objForm.DPDmontofobreal.obj.value = qf(objForm.DPDmontofobreal.obj);
			objForm.DPDpeso.obj.value = qf(objForm.DPDpeso.obj);
			objForm.DPcostodec.obj.value = qf(objForm.DPcostodec.obj);
			objForm.DPfletedec.obj.value = qf(objForm.DPfletedec.obj);
			objForm.DPsegurodec.obj.value = qf(objForm.DPsegurodec.obj);
			objForm.DPcostodec.obj.disabled = false;
			objForm.DPfletedec.obj.disabled = false;
			objForm.DPsegurodec.obj.disabled = false;
			objForm.DPDcantreclamo.obj.disabled = false;
		</cfif>
	}
	<cfif (isdefined("modo") and lcase(modo) eq "cambio")>
	//Habilitar validacion detalle
	function funcHabilitarValidacionDet(){
		funcDesHabilitarValidacionDet();
		objForm.required("ETIiditem, DPDcantidad, CAid, DPDpaisori, Icodigo, DPDpeso");
		/*objForm.DPDcantidad.validateRango(1,document.form1.hcr.value);
		objForm.DPDmontofobreal.validateRango(1,document.form1.mcr.value);*/
	}
	//Deshabilitar validacion detalle
	function funcDesHabilitarValidacionDet(){
		objForm.required("ETIiditem, DPDcantidad, DPDmontofobreal, CAid, DPDpaisori, Icodigo, DPDpeso",false);
	}
	//Botón de Alta Detalle
	function funcAltaDet(){
		funcHabilitarValidacionDet();
	}
	//Botón de Cambio Detalle
	function funcCambioDet(){
		funcHabilitarValidacionDet();
	}
	</cfif>
	//Asignar Tipo de Cambio en el Cambio de Moneda
	function asignaTC() {	
		if (document.form1.Mcodigoref.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {		
			formatCurrency(document.form1.TC,2);
			document.form1.EPDtcref.disabled = true;
		}
		else{
			document.form1.EPDtcref.disabled = false;
		}
		var estado = document.form1.EPDtcref.disabled;
		document.form1.EPDtcref.disabled = false;
		document.form1.EPDtcref.value = fm(document.form1.TC.value,2);
		document.form1.EPDtcref.disabled = estado;
	}
	//Cambiar Tipo de Seguro
	function cambiarTS() {
		<cfif (lcase(modo) eq 'cambio')>
		ts = document.form1.CMSid.value;
		if (ts=='') {
			<!--- document.form1.GenSeguroPropio.disabled = true; --->
		} else {
			<!--- document.form1.GenSeguroPropio.disabled = false; --->
		}
		</cfif>
	}
	/*Conlis de Trackings*/
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisTrackings() {
		popUpWindow("/cfmx/sif/cm/proveedor/ConlisTrackings.cfm?validaFacturado=1&validaPoliza=1",30,100,950,500);
	}

	function funcDocsPoliza(){
		<cfif modo neq "ALTA">
			location.href = "EDocumentos-lista.cfm?EPDid=#form.EPDid#";
		</cfif>
		return false;
	}
	
	function funcCalcular(){
		<cfif isdefined("rsLineasSinSeguro") and rsLineasSinSeguro.RecordCount gt 0>
		if(!confirm("Existen líneas sin seguro asociado, ¿desea continuar con el cálculo?"))
			return false;
		</cfif>
		
		return true;
	}
	
	function funcCalcularParcial(){
		<cfif isdefined("rsLineasSinSeguro") and rsLineasSinSeguro.RecordCount gt 0>
		if(!confirm("Existen líneas sin seguro asociado, ¿desea continuar con el cálculo?"))
			return false;
		</cfif>
		
		return true;
	}
	function funcbtnRevertir(){
		return confirm('Esta seguro que desea revertir el desalamcenaje parcial?');
	}
	
	<cfif (lcase(modo) neq "cambio")>
	asignaTC();
	</cfif>
	cambiarTS();
	
	function funcCalculaMtoDeclarado(){
		var vo_form = document.form1; //Variable con el objeto form
		var vn_MtoDeclarado = 0;	
		vn_MtoDeclarado = (parseFloat(qf(vo_form.EPDFOBDecAduana.value))) + (parseFloat(qf(vo_form.EPDFletesDecAduana.value)))
						  +  (parseFloat(qf(vo_form.EPDSegurosDecAduana.value))) + (parseFloat(qf(vo_form.EPDGastosDecAduana.value)))
		vo_form.Total_Declarado.value = vn_MtoDeclarado;		
		fm(parseFloat(document.form1.Total_Declarado.value),2);
	}
	<!--- Si es Póliza Hija ya no se permite desalmacenajes parciales --->
	<cfif isdefined ("rsEPD") and len(trim(rsEPD.EPDidpadre)) gt 0>
		document.form1.PermiteDesParcial.disabled = true;
	</cfif>
	
	<!--- Si ya es Padre por que tiene una póliza hija entonces no se puede desmarcar el check de permite pólizas parciales --->
	<cfif (isdefined("modo") and lcase(modo) eq "cambio") and rsVerificaHijos.cantidad gt 0>
		document.form1.PermiteDesParcial.disabled = true;
	</cfif>
	
	//-->
</script>
</cfoutput>
<cfif (isdefined("modo") and lcase(modo) eq "cambio")>
	<!--- Lista de detalles de la Póliza --->
	<br>
	<cfinclude template="polizaDesalmacenaje-listadet.cfm"><br>
</cfif>