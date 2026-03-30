<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
</cfquery>

<!--- Consultas --->
<cfquery name="rsTipos" datasource="#session.DSN#">
	select TDRcodigo, TDRdescripcion
	from TipoDocumentoR
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	  and TDRtipo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#"> 
</cfquery>

<cfquery name="rsTiposTransaccion" datasource="#session.DSN#">
	select CPTcodigo, CPTdescripcion 
	from CPTransacciones 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
</cfquery>

<!--- Temporal mientras se hace el conlis --->
<cfquery name="rsOrden" datasource="#session.DSN#">
	select EOidorden, SNcodigo, Observaciones 
	from EOrdenCM 
	where EOestado in (5,10)
	and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="60">
</cfquery>

<cfquery name="rsPeriodoAuxiliar" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="50">
</cfquery>

<!--- Maximos digitos para el numero del doc de recepcion --->
<cfquery name="rsMaxDig" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="720">
</cfquery>

<cfif modo neq 'ALTA'>
	<cfquery datasource="#session.DSN#" name="rsForm">
		select a.EDRid, a.TDRcodigo, a.Mcodigo, a.EDRtc, a.Aid, a.CFid, a.CPTcodigo, EOidorden, 
		       a.EDRnumero, a.EDRfechadoc, a.EDRfecharec, a.EOidorden, a.SNcodigo, a.EPDid, 
			   a.EDRreferencia, a.EDRdescpro, a.EDRimppro, a.EDRobs, a.ts_rversion, a.EDRestado
		from EDocumentosRecepcion a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
 	      and a.EDRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
	</cfquery>
	<cfquery name="rsDets" datasource="#session.DSN#">
		Select count(*) as cantDetalles
		from DDocumentosRecepcion
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and EDRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
	</cfquery>
	<cfquery name="rsMoneda" datasource="#session.DSN#">
		select Mcodigo, Mnombre
		from Monedas
		where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Mcodigo#">
		and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif len(trim(rsForm.CFid))>
		<cfquery datasource="#session.DSN#" name="rsCFuncional">
			select CFid, CFcodigo, CFdescripcion
			from CFuncional
			where CFid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFid#">
			and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>
</cfif>

<script language="JavaScript" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function asignaTC() {	
		document.form1.EDRtc.disabled = false;
		document.form1.TC.value = "1.0000";
		document.form1.EDRtc.value = "1.0000";
		//Si la Moneda seleccionada no es la moneda local busca el tipo cambio		
		if (document.form1.Mcodigo.value != "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {		
			document.getElementById('fr').src = 'getTipoCambio.cfm?Mcodigo='+document.form1.Mcodigo.value+'&Fecha='+document.form1.EDRfechadoc.value;
		}
		else{
			document.form1.EDRtc.disabled = true;
		}
	}

	function doConlisOC() {
	<cfif isdefined("Request.Devoluciones") and Len(Trim(Request.Devoluciones)) NEQ 0>
		popUpWindow("/cfmx/sif/cm/operacion/ConlisOrdenCompra.cfm?Devoluciones=1",200,200,800,700);
	<cfelse>
		popUpWindow("/cfmx/sif/cm/operacion/ConlisOrdenCompra.cfm",80,50,900,550);
	</cfif>
	}
</script>

<cfoutput>
<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" >
	<tr>
		<td>
			<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" >
				<tr>
					<td align="right" nowrap><strong>Socio de Negocios:</strong>&nbsp;</td>
					<td>
						<input type="hidden" name="EOidorden" value="<cfif modo neq 'ALTA'>#rsForm.EOidorden#<cfelse>1</cfif>">
						<cfset valSNcod = ''>
						<cfset valConlis = 'true'>						
						<cfif modo neq 'ALTA'>
						  <cfset valSNcod = rsForm.SNcodigo>
							<cfset valConlis = 'false'>
						</cfif>

						<cf_sifsociosnegocios2 conlis="#valConlis#" form="form1" idquery="#valSNcod#" sntiposocio="P" sncodigo="SNcodigo" snnumero="SNnumero" frame="frame1">
					</td>
				    <td><strong>Observaciones:</strong>&nbsp;</td>
				    <td><a href="javascript:info();"><img border="0" src="../../imagenes/iedit.gif" alt="<cfif modo eq 'ALTA'>Definir<cfelse>Ver/Modificar</cfif> Observaciones"></a></td>
				    <td>&nbsp;</td>
				    <td>&nbsp;</td>
			      <td align="right" nowrap>&nbsp;</td>
				<td></td>
					
				</tr>

				<tr>
					<td align="right"><strong>N&uacute;mero:</strong>&nbsp;</td>
					<td>
						<input name="EDRnumero"
							<cfif isdefined('rsMaxDig') and rsMaxDig.recordCount GT 0 and rsMaxDig.Pvalor NEQ ''>
								 size="25" maxlength="#rsMaxDig.Pvalor#" 
							<cfelse>
								 size="25" maxlength="16" 
							</cfif>
							value="<cfif modo neq 'ALTA'>#trim(rsForm.EDRnumero)#</cfif>" 
							onfocus="javascript: this.select();" tabindex="1" >
					</td>
					<td align="right"><strong>Tipo:</strong>&nbsp;</td>
					<td>
						<select name="TDRcodigo" tabindex="1">
							<cfloop query="rsTipos">
								<option value="#rsTipos.TDRcodigo#" <cfif modo neq 'ALTA' and trim(rsForm.TDRcodigo) eq trim(rsTipos.TDRcodigo) >selected</cfif> >#rsTipos.TDRdescripcion#</option>
							</cfloop>
						</select>
					</td>
					<td align="right" nowrap width="1%"><strong>Fecha:</strong>&nbsp;</td>
					<td nowrap >
						<cfset fechadoc = LSDateFormat(Now(),'dd/mm/yyyy') >
						<cfif modo neq 'ALTA'>
							<cfset fechadoc = LSDateFormat(rsForm.EDRfechadoc,'dd/mm/yyyy') >
						</cfif>
						<cf_sifcalendario onChange="asignaTC" value="#fechadoc#" tabindex="1" name="EDRfechadoc">
					</td>

					<td align="right" nowrap width="1%"><strong>Recepci&oacute;n:</strong>&nbsp;</td>
					<td nowrap >
						<cfset fecharec = LSDateFormat(Now(),'dd/mm/yyyy') >
						<cfif modo neq 'ALTA'>
							<cfset fecharec = LSDateFormat(rsForm.EDRfecharec,'dd/mm/yyyy') >
						</cfif>
						<cf_sifcalendario value="#fecharec#" tabindex="1" name="EDRfecharec">
					</td>
				</tr>

				<tr>
					<td align="right"><strong>Referencia:</strong>&nbsp;</td>
					<td>
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td width="1%"><input name="EDRreferencia" size="25" maxlength="25" value="<cfif modo neq 'ALTA'>#trim(rsForm.EDRreferencia)#</cfif>" onfocus="javascript: this.select();" tabindex="1" ></td>
								<td>
									<input type="hidden" name="EDRobs" value="<cfif modo neq 'ALTA'>#trim(rsForm.EDRobs)#</cfif>">
								</td>
							</tr>
						</table>
					</td>
					
					<td align="right" nowrap><strong>Tran. CxP:</strong>&nbsp;</td>
					<td>
						<select name="CPTcodigo" tabindex="1">
							<cfloop query="rsTiposTransaccion">
								<option value="#rsTiposTransaccion.CPTcodigo#" <cfif modo neq 'ALTA' and trim(rsForm.CPTcodigo) eq trim(rsTiposTransaccion.CPTcodigo) >selected</cfif> >#rsTiposTransaccion.CPTdescripcion#</option>
							</cfloop>
						</select>
					</td>

					<td align="right" nowrap><strong>Moneda:</strong>&nbsp;</td>
					<td>
						<cfif modo NEQ "ALTA">
<!--- 							 <cf_sifmonedas tabindex="1" query="#rsMoneda#" valueTC="" onChange="asignaTC();" FechaSugTC="#LSDateFormat(rsForm.EDRfechadoc,'DD/MM/YYYY')#">  --->
							 <input type="hidden" name="TC" value="#rsForm.EDRtc#">
							 <input type="hidden" name="Mcodigo" value="#rsMoneda.Mcodigo#">
							 #rsMoneda.Mnombre#
						 <cfelse>
							 <cf_sifmonedas onChange="asignaTC();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1">
						</cfif> 
					</td>
					<td align="right" nowrap><strong>Tipo de Cambio:</strong>&nbsp;</td>
					<td>
						<input tabindex="1" type="text" name="EDRtc" style="text-align:right"size="15" maxlength="10" 
								onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								onFocus="javascript:this.select();" 
								onChange="javascript: fm(this,2);"
								<cfif modo NEQ 'ALTA' and isdefined('rsDets') and rsDets.recordCount GT 0 and rsDets.cantDetalles GT 0>
									readonly="true"
								</cfif>
								value="<cfif modo NEQ 'CAMBIO'>0.00<cfelse><cfoutput>#LSNumberFormat(rsForm.EDRtc,',9.0000')#</cfoutput></cfif>"> 
					</td>
				</tr>
				
				<tr>
					<td align="right" nowrap><strong>C. Funcional:</strong>&nbsp;</td>
					<td>
						<!----<cfif modo neq 'ALTA' and isdefined("rsCFuncional")>---->
						<cfif modo NEQ 'ALTA' and isdefined("rsCFuncional") and len(trim(rsForm.EPDid)) EQ 0>
							<cf_rhcfuncional query="#rsCFuncional#" size="20" tabindex="1">
						<cfelseif modo NEQ 'ALTA' and len(trim(rsForm.EPDid))>
							 <cfif isdefined("rsCFuncional")>
							 	<input name="CFid" type="hidden" value="#rsCFuncional.CFid#">
								 #trim(rsCFuncional.CFcodigo)# - #trim(rsCFuncional.CFdescripcion)#
							 <cfelse>
							 	---
							 </cfif>
						<cfelse>
							<cf_rhcfuncional  size="20" tabindex="1">
						</cfif>
					</td>

					<td align="right"><strong>Almac&eacute;n:</strong>&nbsp;</td>
					<td>
						<cfif modo neq 'ALTA' and len(trim(rsForm.EPDid)) EQ 0>
							<cf_sifalmacen id='#rsForm.Aid#'>
						<cfelseif modo neq 'ALTA' and len(trim(rsForm.EPDid))>
							<cfif len(trim(rsForm.Aid))>
								<cfquery name="rsAlmacen" datasource="#session.DSN#">
									select Almcodigo, Bdescripcion
									from Almacen where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Aid#">
								</cfquery>
								<input name="Aid" type="hidden" value="#rsForm.Aid#">
								#rsAlmacen.Almcodigo# - #rsAlmacen.Bdescripcion#
							</cfif>
						<cfelse>
							<cf_sifalmacen>
						</cfif>
					</td>

					<td align="right" nowrap><strong>Descuento:</strong>&nbsp;</td>
					<td>
						<input tabindex="1" type="text" name="EDRdescpro" style="text-align:right"size="15" maxlength="10" 
							   onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
							   onFocus="javascript:this.select();" 
							   onChange="javascript: fm(this,2);"
							   readonly="true"
							   value="<cfif modo NEQ 'CAMBIO'>0.00<cfelse><cfoutput>#LSNumberFormat(rsForm.EDRdescpro,',9.0000')#</cfoutput></cfif>"
							   <cfif modo NEQ 'ALTA' and len(rsForm.EPDid) GT 0>readonly</cfif>>
					</td>									
					<td align="right" nowrap><strong>Impuesto:</strong>&nbsp;</td>
					<td>						
						<input tabindex="1" type="text" name="EDRimppro" style="text-align:right" size="15" maxlength="10" 
							   onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
							   onFocus="javascript:this.select();" 
							   onChange="javascript: fm(this,3);"
							   readonly="true"
							   value="<cfif modo NEQ 'CAMBIO'>0.00<cfelse><cfoutput>#LSNumberFormat(rsForm.EDRimppro,',9.00')#<!-----#LSNumberFormat(rsForm.EDRimppro,',9.0000')#-----></cfoutput></cfif>"
							   <cfif modo NEQ 'ALTA' and len(rsForm.EPDid) GT 0>readonly</cfif>> 
					</td>
				</tr>
				
				<input type="hidden" name="EDRmes" value="#rsMesAuxiliar.Pvalor#">
				<input type="hidden" name="EDRperiodo" value="#rsPeriodoAuxiliar.Pvalor#">
				<input type="hidden" name="tipo" value="#form.tipo#">
				<cfif modo neq 'ALTA'>
					<cfset ts = "">	
					<cfinvoke 
						component="sif.Componentes.DButils"
						method="toTimeStamp"
						returnvariable="ts">
						<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
					</cfinvoke>
					<input type="hidden" name="ts_rversion" value="#ts#">
					<input type="hidden" name="EDRid" value="#form.EDRid#">
				</cfif>
			</table>	
		</td>	
	</tr>	
</table>
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>

</cfoutput>

<script language="javascript1.2" type="text/javascript">
	function info(){
		open('documentos-info.cfm', 'documentos', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
	}

	function funcAlmcodigo(){
		document.form1.CFid.value = '';
		document.form1.CFcodigo.value = '';
		document.form1.CFdescripcion.value = '';
	}

	function funcCFcodigo(){
		document.form1.Aid.value = '';
		document.form1.Almcodigo.value = '';
		document.form1.Bdescripcion.value = '';
	}
	<cfif modo EQ 'ALTA'>
		asignaTC();
	</cfif>
	
</script>