<cfparam name="aprobado" default=false>
<cfparam name="form.ECid" default="0">
<!--- Querys para construir combos --->
<cfquery name="rsTipoOrden" datasource="#Session.DSN#">
	select rtrim(ltrim(CMTOcodigo)) as CMTOcodigo, CMTOdescripcion, CMTOimportacion
	from CMTipoOrden
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by CMTOcodigo
</cfquery>
<cftry>
	<cfquery name="rsAprobado" datasource="#Session.DSN#">
		SELECT ECestado from EcontratosCM
		WHERE Ecodigo = #session.Ecodigo#
		and ECid = #form.ECid#
	</cfquery>
	<cfif rsAprobado.ECestado EQ 2>
		<cfset aprobado = True>
	</cfif>
<cfcatch>
	<cfset aprobado = false>
</cfcatch>
</cftry>

<cfquery name="rsIncoterm" datasource="#Session.DSN#">
	select  CMIid, rtrim(CMIcodigo) as CMIcodigo, CMIdescripcion
	from CMIncoterm
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by CMIcodigo
</cfquery>

<cfquery name="rsRetenciones" datasource="#Session.DSN#">
	select rtrim(Rcodigo) as Rcodigo, Rdescripcion
	from Retenciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Rcodigo
</cfquery>

<!--- Formas de Pago --->
<cfquery name="rsCMFormasPago" datasource="#session.dsn#">
	select CMFPid, CMFPcodigo, CMFPdescripcion, CMFPplazo
	from CMFormasPago
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by CMFPcodigo
</cfquery>
<!--- Parametros Adicionales --->
<cfquery name="verifica_Parametro" datasource="#session.dsn#">
	select 1 from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 730
	and Pvalor = '1'
</cfquery>
<!---Tramites--->
<cfinvoke component="sif.Componentes.Workflow.plantillas" method="CrearPkg" returnvariable="WfPackage">
	<cfinvokeargument name="PackageBaseName" value="CN"/>
</cfinvoke>

<cfquery name="rsProcesos" datasource="#Session.DSN#">
	select ProcessId, Name, upper(Name) as upper_name, PublicationStatus
	from WfProcess
	where WfProcess.Ecodigo = #session.Ecodigo#
		and (PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#WfPackage.PackageId#">
		and PublicationStatus = 'RELEASED'
		)
	order by upper_name
</cfquery>

<cfif modo neq 'ALTA'>
	<cfquery datasource="#session.DSN#" name="rsForm">
		select a.ECid,
			   a.SNcodigo,
			   a.ECaviso,
			   a.CMIid,
			   a.ECtiempoentrega,
               a.Consecutivo,
			   <!----
			   coalesce(sum(c.DCcantcontrato * DCpreciou), 0.00) as TotalContrato,
			   (coalesce(sum(c.DCcantcontrato * c.DCpreciou), 0.00) - coalesce(sum(c.DCcantsurtida * c.DCpreciou), 0.00)) as SaldoContrato,
			   ------>
			   a.Usucodigo,
			   b.SNnumero,
			   b.SNnombre,
			   a.ECdesc,
			   a.ECfechaini,
			   a.ECfechafin,
			   ltrim(rtrim(a.CMTOcodigo)) as CMTOcodigo,
			   a.Rcodigo,
			   a.ECplazocredito,
			   a.ECporcanticipo,
			   a.CMFPid,
			   a.ts_rversion,
               a.ECestado,
               a.Tramite
		from EContratosCM a
			inner join SNegocios b
				on a.Ecodigo = b.Ecodigo
  		   		and a.SNcodigo = b.SNcodigo
			left outer join DContratosCM c
				on a.ECid = c.ECid
					and a.Ecodigo = c.Ecodigo

		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
  		  and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
		<!----group by a.ECid, a.SNcodigo, b.SNnumero, b.SNnombre, a.ECdesc, a.ECfechaini, a.ECfechafin----->
	</cfquery>
	<!--- <cfdump var=#rsForm#> --->
	<cfquery name="rsTotalContrato" datasource="#session.DSN#">
		select round(coalesce(sum(a.DCpreciou + (a.DCpreciou * b.Iporcentaje) / 100.00), 0.00),2) as TotalContrato
		from DContratosCM a
			inner join Impuestos b
				on a.Icodigo  = b.Icodigo
				and a.Ecodigo = b.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
  			and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
			and a.DCcantcontrato > 0
	</cfquery>
	<cfquery name="rsSaldoContrato" datasource="#session.DSN#">
		select round(coalesce(sum(((a.DCcantcontrato - coalesce(a.DCcantsurtida, 0.00)) * (a.DCpreciou / a.DCcantcontrato)) + (((a.DCcantcontrato - coalesce(a.DCcantsurtida, 0.00)) * (a.DCpreciou / a.DCcantcontrato)) * b.Iporcentaje / 100.00)), 0.00),2) as SaldoContrato
		from DContratosCM a
			inner join Impuestos b
				on a.Icodigo = b.Icodigo
				and a.Ecodigo = b.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
  			and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
			and a.DCcantcontrato > 0
	</cfquery>
</cfif>
<cfif modo NEQ "ALTA">
	<cfquery name="rsSNFormaPagoDias" datasource="#session.dsn#">
		select coalesce(SNvencompras, -1) as Dias
		from SNegocios
		where Ecodigo = #session.Ecodigo#
			and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsForm.SNcodigo#">
	</cfquery>
	<cfquery name="rsFormaPagoSocio" datasource="#session.DSN#" maxrows="1">
		select min(CMFPid) as CMFPid
		from CMFormasPago
		where Ecodigo = #session.ecodigo#
			and CMFPplazo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSNFormaPagoDias.Dias#">
	</cfquery>
</cfif>
<!----a.ECid, a.SNcodigo, b.SNnumero, b.SNnombre, a.ECdesc, a.ECfechaini, a.ECfechafin  ---->

<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	<!--- Objectos para el manejo de plazos de crédito según la forma de pago --->
	var fp = new Object();
	<cfoutput query="rsCMFormasPago">
		fp['#CMFPid#'] = #CMFPplazo#;
	</cfoutput>
	<!--- Forma pago Socio de Negocio--->
	<cfif modo NEQ "ALTA">
		<cfoutput>
			#ToScript(rsSNFormaPagoDias.Dias,"PlazoSocio")#;
			#ToScript(rsFormaPagoSocio.CMFPid,"idPlazo")#;
		</cfoutput>
	</cfif>

	function getPlazo(displayCtl, id) {
		if (fp[id] != null && id != -1) {
			displayCtl.value = fp[id];
		}else if(id == -1){
			<cfif modo EQ "ALTA">
				displayCtl.value = 'N/A';
				document.form1.CMFPid.value = -1;
			<cfelse>
				displayCtl.value = PlazoSocio;
				if(idPlazo != ""){
					document.form1.CMFPid.value = idPlazo;
				}else{document.form1.CMFPid.value = -1;}
			</cfif>
		}
	}

</script>

<cfoutput>
	<cfset ts = "">
	<cfif modo neq "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="ECid" value="#rsForm.ECid#">
		<input type="hidden" name="Usucodigo" value="#rsForm.Usucodigo#">

	</cfif>

	<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" >
		<tr>
        	<td align="left"><strong>No. Contrato:</strong></td>
            <td>
			<cfset ConsecutivoContrato = 0>
			<cfif modo NEQ "ALTA">
				#rsForm.Consecutivo#
                <cfset ConsecutivoContrato = #rsForm.Consecutivo#>
            <cfelse>
                <cfquery name="rs" datasource="#session.DSN#">
                    select max(Consecutivo) as Next
                    from EContratosCM
                    where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                </cfquery>
                <cfset consecutivo = 1>
                <cfif rs.RecordCount gt 0 and len(trim(rs.Next))>
	                <cfset consecutivo = rs.Next + 1>
                </cfif>
            	#consecutivo#
                <cfset ConsecutivoContrato = #consecutivo#>
            </cfif>
            <input type="hidden" name="ConsecutivoContrato" value="<cfoutput>#ConsecutivoContrato#</cfoutput>" />
            </td>
           <!---  <td align="left">
                <strong>Estado:</strong>
                <input type="checkbox" name="ECestado"  value="1" <cfif modo neq 'ALTA' and rsForm.ECestado eq 1>checked="checked"</cfif>>Activo
            </td> --->
        </tr>
        <tr>
			<td width="5%" rowspan="2" align="left" nowrap><strong>Proveedor:</strong>&nbsp;</td>
            <td width="24%" rowspan="2" nowrap>
         		<cfif modo NEQ "ALTA">
					<cfquery name="rsSocio" datasource="#session.DSN#">
						select SNnumero, SNnombre
						from SNegocios
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsForm.SNcodigo#">
           			</cfquery>
					#trim(rsSocio.SNnumero)# - #trim(rsSocio.SNnombre)#
					<input type="hidden" name="SNcodigo" value="#rsForm.SNcodigo#">

        		<cfelse>
					<cf_sifsociosnegocios2 tabindex="1" sntiposocio="P" size="30">
       			</cfif>
			</td>
            <td width="10%" rowspan="2" align="right" nowrap><strong>Descripci&oacute;n:</strong></td>
            <td width="22%" rowspan="2" nowrap><input  tabindex="1" type="text" name="ECdesc" value="<cfif modo neq 'ALTA'>#rsForm.ECdesc#</cfif>" size="60" maxlength="100"></td>
            <cfif verifica_Parametro.recordcount GT 0 >
				<cfif modo neq 'ALTA'>
					<td width="6%" align="right" nowrap><strong>Total Contrato</strong></td>
					<td width="7%" align="right" nowrap>#LSNumberFormat(rsTotalContrato.TotalContrato,',9.00')#</td>
				</cfif>
			</cfif>
			<td width="7%" align="right" nowrap>&nbsp;</td>
			<td width="19%">&nbsp;</td>
			<td width="0%" rowspan="2">
			</td>
			<td width="0%" rowspan="2">

			</td>
            <td width="0%" rowspan="2" nowrap>&nbsp;</td>
            <td width="0%" rowspan="2" nowrap>&nbsp;</td>
		</tr>
		<tr>
		  <cfif verifica_Parametro.recordcount GT 0 >
			  <cfif modo neq 'ALTA'>
				  <td align="right" nowrap><strong>Saldo Contrato</strong></td>
				  <td align="right" nowrap>#LSNumberFormat(rsSaldoContrato.SaldoContrato,',9.00')#</td>
			  </cfif>
		   </cfif>
	 	  <td align="right" nowrap>&nbsp;</td>
	 	  <td>&nbsp;</td>
	  	</tr>
		<tr>
			<td align="right" nowrap>
				<strong>Fecha de Inicio:&nbsp;</strong>
			</td>
			<cfif isdefined("rsForm.ECfechaini") and len(trim(rsForm.ECfechaini))>
				<cfset vfechadesde = LSDateFormat(rsForm.ECfechaini,'dd/mm/yyyy')>
			<cfelse>
				<cfset vfechadesde = ''>
			</cfif>
            <td>
				<cf_sifcalendario  tabindex="1" form="form1" name="ECfechaini" value="#vfechadesde#">
			</td>
			<cfif isdefined("rsForm.ECfechafin") and len(trim(rsForm.ECfechafin))>
				<cfset vfechahasta = LSDateFormat(rsForm.ECfechafin,'dd/mm/yyyy')>
			<cfelse>
				<cfset vfechahasta = ''>
			</cfif>
            <td align="right" nowrap><strong>Fecha de Vencimiento:</strong></td>
			<td colspan="4" align="left">
				<table cellpadding="0" cellspacing="0">
				<tr align="left">
					<td>
						<cf_sifcalendario  tabindex="1"  form="form1" name="ECfechafin" value="#vfechahasta#">
					</td>
					<td>&nbsp;</td>
					<cfif verifica_Parametro.recordcount GT 0 >
						<td nowrap><strong>Aviso Vencimiento</strong></td>
						<td><input  tabindex="1" type="text" name="ECaviso" value="<cfif modo neq 'ALTA'>#rsForm.ECaviso#</cfif>" size="10" maxlength="4" onblur="javascript:fm(this,0);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"  ></td>
					 </cfif>
					<td>&nbsp;</td>
					<cfif modo NEQ 'ALTA'>
						<td>
						  <input name="AlmObjecto" type="button" value="Almacenar Objetos" onClick="javascript:AlmacenarObjetos('#rsForm.ECid#');" >
						</td>
						<td>&nbsp;</td>
					 	<cfif verifica_Parametro.recordcount GT 0 >
							<td>
								<input name="UsuariosAsoc" type="button" value="Usuarios Asociados" onClick="javascript:NotificarUsuarios();" >
							</td>
					 	</cfif>
					</cfif>
				  </tr>
			 </table>
			</td>
            <td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
		</tr>
		<tr><td><strong>Trámite:</strong></td>
			<td>
				<select name="id_tramite">
					<option value="">(Ninguno)</option>
					<cfloop query="rsProcesos">
						<option value="#rsProcesos.ProcessId#"
						<!--- <cfif MODOCAMBIO and rsProcesos.ProcessId eq data.id_tramite> --->
							<cfif MODO eq 'CAMBIO'>
								<cfif isdefined("vnTramite") and rsProcesos.ProcessId eq vnTramite>
									selected
								<cfelseif  rsProcesos.ProcessId eq rsForm.Tramite>
									selected
								</cfif>
						</cfif>>#rsProcesos.upper_name#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="9" align="center"class="tituloListas">Datos para generaci&oacute;n de Orden de Compra</td>
		</tr>
		<tr>
        	<td colspan="9">
				<table width="100%"  border="0" cellspacing="0" cellpadding="2">
              		<tr>
              		  <td align="right" class="fileLabel">Tipo Orden:</td>
<!----
Tipo_Contrato:<cfdump var="#rsForm.CMTOcodigo#"><br>
<cfloop query="rsTipoOrden">
	Tipo:<cfdump var="#rsTipoOrden.CMTOcodigo#"><br>
</cfloop>------>
					  <td>
						  <select name="CMTOcodigo" onchange="javascript: funcCambiaIncoterm();">
							<cfloop query="rsTipoOrden">
							  <option  value="#rsTipoOrden.CMTOcodigo#" <cfif modo EQ 'CAMBIO' and trim(rsTipoOrden.CMTOcodigo) EQ trim(rsForm.CMTOcodigo)> selected</cfif>>#rsTipoOrden.CMTOdescripcion#</option>
							</cfloop>
						  </select>
					  </td>
              		  <td align="right" class="fileLabel">Retenci&oacute;n:</td>
              		  <td><select name="Rcodigo">
                        <option value="">(Ninguna)</option>
                        <cfloop query="rsRetenciones">
                          <option value="#rsRetenciones.Rcodigo#"<cfif modo EQ 'CAMBIO' and rsRetenciones.Rcodigo EQ rsForm.Rcodigo> selected</cfif>>#rsRetenciones.Rdescripcion#</option>
                        </cfloop>
                      </select></td>
              		  <td align="right" nowrap class="fileLabel">Forma de Pago:</td>
              		  <td>
						  <select name="CMFPid" onChange="javascript: getPlazo(this.form.ECplazocredito, this.value,this);">
								<option value="-1">Definida por Proveedor</option>
								<cfloop query="rsCMFormasPago">
								<option value="#CMFPid#"<cfif modo EQ 'CAMBIO' and rsForm.CMFPid EQ rsCMFormasPago.CMFPid> selected</cfif>>#CMFPcodigo# - #CMFPdescripcion#</option>
								</cfloop>
						  </select>
					  </td>
              		  <td align="right" class="fileLabel">Plazo Cr&eacute;dito:</td>
              		  <td nowrap><input name="ECplazocredito" type="text" size="8" maxlength="8" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);" onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ 'CAMBIO'>#rsForm.ECplazocredito#</cfif>" readonly>
           		      d&iacute;as </td>
           		  </tr>
              		<tr>
						<cfif verifica_Parametro.recordcount GT 0 >
							<td align="right" class="fileLabel">Tiempo de Entrega:</td>
							<td>
							<input tabindex="1" type="text" name="ECtiempoentrega" value="<cfif modo neq 'ALTA'>#rsForm.ECtiempoentrega#</cfif>" size="10" maxlength="4">
							</td>

							<td align="right" class="fileLabel">Incoterm:</td>
							<td>
								<select name="CMIid" <cfif modo EQ 'ALTA'>disabled</cfif>>
									<option value="" id="Ninguno">-- Ninguno --</option>
									<cfloop query="rsIncoterm">
									  <option value="#rsIncoterm.CMIid#"<cfif modo EQ 'CAMBIO' and rsIncoterm.CMIid EQ rsForm.CMIid> selected</cfif>>#rsIncoterm.CMIcodigo# - #rsIncoterm.CMIdescripcion#</option>
									</cfloop>
								</select>
							</td>
						</cfif>
						<td align="right" class="fileLabel" nowrap>% Anticipo:</td>
						<td nowrap><input name="ECporcanticipo" type="text" size="10" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ 'CAMBIO'>#LSNumberFormat(rsForm.ECporcanticipo, ',9.00')#<cfelse>0.00</cfif>"></td>
						<td align="right" class="fileLabel" nowrap>&nbsp;</td>
            			<td nowrap>&nbsp;
						</td>
           			</tr>
            	</table>
			</td>
		</tr>
	</table>
</cfoutput>

<script type="text/javascript" language="JavaScript1.2" >

	<cfif verifica_Parametro.recordcount GT 0 >
		var ar_tipoOrden = new Array(1); //Arreglo
		<cfloop query="rsTipoOrden">
			var vn_codigoTipo = '<cfoutput>#rsTipoOrden.CMTOcodigo#</cfoutput>';
			ar_tipoOrden[vn_codigoTipo] = '<cfoutput>#rsTipoOrden.CMTOimportacion#</cfoutput>';
		</cfloop>
	</cfif>


	<cfif modo NEQ 'ALTA' and verifica_Parametro.recordcount GT 0 >
		var vn_codigo = '<cfoutput>#rsForm.CMTOcodigo#</cfoutput>';
		if (vn_codigo != ''){
			if (ar_tipoOrden[vn_codigo] == 0){
				document.form1.CMIid.disabled = true;
			}
			else{
				document.form1.CMIid.disabled = false;
			}
		}
	</cfif>

	function AlmacenarObjetos(valor){
		if (valor != "") {
			document.form1.action = 'ObjetosContratos.cfm';
			document.form1.submit();
		}
		return false;
	}
	<cfif modo EQ 'ALTA'>
	getPlazo(document.form1.ECplazocredito, document.form1.CMFPid.value);
	</cfif>
	function NotificarUsuarios(){
		document.form1.action = 'UsuariosAsocContratos.cfm';
		document.form1.submit();
	}

	function funcCambiaIncoterm(){
		var vn_importacion = ar_tipoOrden[document.form1.CMTOcodigo.value];
		if (vn_importacion == 0){
			document.form1.CMIid.value = '';
			document.form1.CMIid.disabled = true;
		}
		else{
			document.form1.CMIid.disabled = false;
		}
	}
</script>

