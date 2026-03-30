<!--- Definicion del parametro para cuando se llama a la pagina de facturas desde
		el mantenimiento de Polizas de desalmacenaje. Si existe el url.EPDid es porque se llamo
		a la pagina de Facturas desde el mantenimiento de Polizas de desalmacenaje --->

<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
</cfquery>

<!--- Consultas --->
<cfquery name="rsTiposTransaccion" datasource="#session.DSN#">
	select CPcodigo, CPdescripcion
	from TTransaccionI
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
</cfquery>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Odescripcion from Oficinas 
	where Ecodigo = #Session.Ecodigo#
	order by Ocodigo                      
</cfquery>

<cfif modo neq 'ALTA'>
	<cfquery datasource="#session.DSN#" name="rsForm">
		Select 	ed.EDIid, 
				Ddocumento, 
				EDItipo, 
				ed.Mcodigo, 
				EDItc, 
				ed.SNcodigo,
				ed.EOidorden, 
				ed.CPcodigo, 
				EDIfecha, 
				EDobservaciones, 
				EDIimportacion, 
				ed.Usucodigo,
			 	ed.fechaalta, 
				EDIestado, 
                EDIfechaarribo,
				EOnumero, 
				ed.ts_rversion,
				ed.EPDid,
				ed.EDIidRef,
                ed.Ocodigo,
                ed.CPTcodigo
		From EDocumentosI ed
			inner join SNegocios sn
				on ed.Ecodigo=sn.Ecodigo
					and ed.SNcodigo=sn.SNcodigo
			inner join Monedas m
				on ed.Ecodigo=m.Ecodigo
					and ed.Mcodigo=m.Mcodigo
			inner join TTransaccionI ti
				on ed.Ecodigo=ti.Ecodigo
					and ed.CPcodigo=ti.CPcodigo
			left outer join EOrdenCM eo
				on ed.Ecodigo=eo.Ecodigo
					and ed.EOidorden=eo.EOidorden
		where ed.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#">
	</cfquery>
	
	<cfif isdefined('rsForm') and rsForm.recordCount GT 0 and rsForm.EOidorden NEQ ''>
		<cfquery datasource="#session.DSN#" name="rsOrdenCompra">
			select a.EOidorden, a.EOnumero,a.Observaciones
			from EOrdenCM a
		
				inner join SNegocios b
					on a.SNcodigo=b.SNcodigo
					and a.Ecodigo=b.Ecodigo
				
				inner join CMTipoOrden c
					on a.Ecodigo=c.Ecodigo
					and a.CMTOcodigo=c.CMTOcodigo
				
			where a.EOestado = 10
			  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a.EOidorden=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.EOidorden#">
			  and EOidorden in (  select distinct EOidorden 
							from DOrdenCM
							where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and DOcantidad > DOcantsurtida )		
		</cfquery>	
	</cfif>

	<cfquery name="rsMoneda" datasource="#session.DSN#">
		select Mcodigo, Mnombre
		from Monedas
		where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Mcodigo#">
		and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

</cfif>

<!--- Maximos digitos para el numero del doc de recepcion --->
<cfquery name="rsMaxDig" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="720">
</cfquery>

<script language="JavaScript" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function asignaTC() {	
		if (document.form1.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {					
			formatCurrency(document.form1.TC,2);
			document.form1.EDItc.disabled = true;			
		}
		else{
			document.form1.EDItc.disabled = false;
		}		
		var estado = document.form1.EDItc.disabled;
		document.form1.EDItc.disabled = false;
		document.form1.EDItc.value = fm(document.form1.TC.value,2);
		document.form1.EDItc.disabled = estado;
	}

	function doConlisOC() {
		popUpWindow("/cfmx/sif/cm/operacion/ConlisOrdenCompra2.cfm",200,200,800,500);
	}
	
	function traeOrden(value){
		if (value!=''){
			document.getElementById("fr").src = 'traerOrden.cfm?socioNoFijo=1&EOnumero='+value;
		}
		else{
			document.form1.EOidorden.value = '';
			document.form1.Observaciones.value = '';
		}
	}

</script>

<cfoutput>
	<input type="hidden" name="EOidorden" value="<cfif modo neq 'ALTA'>#rsForm.EOidorden#</cfif>">
	<input type="hidden" name="EDRreferencia" value="">				
	<input type="hidden" name="EDobservaciones" value="<cfif modo neq 'ALTA'>#trim(rsForm.EDobservaciones)#</cfif>">
	<cfif modo neq 'ALTA'>
		<cfset ts = "">	
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="EDIid" value="#form.EDIid#">
	</cfif>
	
	<cfif isdefined("rsForm") and len(trim(rsForm.EPDid)) gt 0>
		<cfset Form.EPDid_DP = rsForm.EPDid>
	</cfif>
	<cfif isdefined('form.EPDid_DP') and len(trim(form.EPDid_DP))>
		<input type="hidden" name="EPDid_DP" value="#Form.EPDid_DP#">
		<cfinclude template="encPoliza.cfm">
	</cfif>

	<table width="100%" border="0" align="center">
	  <tr>
		<td width="125" align="right" nowrap><strong>Num. Documento </strong> :</td>
		<td width="207">
			<!--- Tiene que ser 17 en maxlength porque en el sql se hacen 
				operaciones con 19 y 17 caracteres de este 
				campo, para anular y copiar (mas info, ver 
				anulaEDocumentosI.cfm) ---> 
			<input name="Ddocumento" 
						<cfif isdefined('rsMaxDig') and rsMaxDig.recordCount GT 0 and rsMaxDig.Pvalor NEQ ''>
							 size="20" maxlength="#(rsMaxDig.Pvalor)#" 
						<cfelse>
							 size="20" maxlength="16" 
						</cfif>			
						value="<cfif modo neq 'ALTA'>#trim(rsForm.Ddocumento)#</cfif>" 
						onFocus="javascript: this.select();" 
						tabindex="1">
		</td>
		<td width="24">&nbsp;</td>

		<td width="170" align="right">
			<strong>Tipo</strong>:
		</td>

		<td nowrap>
			<table width="200" border="0">
			  <tr>
				<td>
					<cfif modo NEQ 'CAMBIO'>
						<select name="EDItipo" tabindex="3" onChange="javascript:funcPintaFactura(this)">
							<option value="N" <cfif modo neq 'ALTA' and trim(rsForm.EDItipo) EQ 'N' >selected</cfif> >Nota de Crédito</option>								
							<option value="D" <cfif modo neq 'ALTA' and trim(rsForm.EDItipo) EQ 'D' >selected</cfif> >Nota Débito</option>					
							<option value="F" <cfif modo neq 'ALTA' and trim(rsForm.EDItipo) EQ 'F' >selected</cfif> >Factura</option>	
						</select>
					<cfelse>
						<input type="hidden" name="EDItipo" value="<cfif trim(rsForm.EDItipo) EQ 'N'>N<cfelseif trim(rsForm.EDItipo) EQ 'F'>F<cfelse>D</cfif>">
						<cfif trim(rsForm.EDItipo) EQ 'N'>								
							Nota de Crédito									
						<cfelseif trim(rsForm.EDItipo) EQ 'F'>
							Factura
						<cfelseif trim(rsForm.EDItipo) EQ 'D'>
							Nota Débito
						</cfif>
					</cfif>
				</td>
			  </tr>
			</table>
		</td>
	  </tr>
	  <tr>
		<td align="right"><strong>Socio de Negocio</strong> :</td>
		<td>
		<!--- <input type="hidden" name="socio" id="socio" value=""> --->
			<cfif modo NEQ "ALTA">				
				<cf_sifsociosnegocios2 tabindex="8" SNtiposocio="P" size="30" idquery="#rsForm.SNcodigo#" conlis="false">				
			<cfelse>
				<cf_sifsociosnegocios2 tabindex="8" SNtiposocio="P" size="30">
			</cfif>					
		</td>
		
		<td>&nbsp;</td>
		<td align="right" nowrap><strong>Tipo de Transacci&oacute;n</strong> :</td>
		<td>
			<select name="CPcodigo" tabindex="4">
				<cfloop query="rsTiposTransaccion">
					<option value="#rsTiposTransaccion.CPcodigo#" <cfif modo neq 'ALTA' and trim(rsForm.CPcodigo) eq trim(rsTiposTransaccion.CPcodigo) >selected</cfif> >#rsTiposTransaccion.CPdescripcion#</option>
				</cfloop>
			</select>
		
		</td>
	  </tr>
	  <tr>
		<td align="right"><strong>Moneda</strong> :</td>
		<td>
			<cfif modo NEQ "ALTA">
					<input type="hidden" name="TC" value="#rsForm.EDItc#">
					<input type="hidden" name="Mcodigo" value="#rsMoneda.Mcodigo#">
					#rsMoneda.Mnombre#
					<!--- <cf_sifmonedas tabindex="1" query="#rsMoneda#" valueTC="#rsForm.EDItc#" onChange="asignaTC();" FechaSugTC="#LSDateFormat(rsForm.EDIfecha,'DD/MM/YYYY')#">  --->
			 <cfelse>
				 <cf_sifmonedas onChange="asignaTC();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="5">
			</cfif> 		
            </td>
            <td>&nbsp;</td>
            <td align="right"><strong>Fecha</strong> :</td>
            <td>
                <cfset fechadoc = LSDateFormat(Now(),'dd/mm/yyyy') >
                <cfif modo neq 'ALTA'>
                    <cfset fechadoc = LSDateFormat(rsForm.EDIfecha,'dd/mm/yyyy') >
                </cfif>
                <cf_sifcalendario 
                    value="#fechadoc#" 
                    tabindex="6" 
                    name="EDIfecha"
                    onBlur="cambiaFecha(this);">
            </td>
        </tr>
        <tr>
            <td align="right"><strong>Tipo de Cambio</strong> :</td>
            <td>
                <input tabindex="7" type="text" name="EDItc" style="text-align:right"size="15" maxlength="10" 
                            onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}" 
                            onFocus="javascript:this.select();" 
                            onChange="javascript: fm(this,2);"
                            value="<cfif modo NEQ 'CAMBIO'>0.00<cfelse><cfoutput>#LSNumberFormat(rsForm.EDItc,',9.00')#</cfoutput></cfif>"> 
            </td>
	        <!---►►Fecha de Arribo◄◄--->
            <td colspan="2"><div align="right"><strong>Fecha&nbsp;Arribo:&nbsp;</strong></div></td>
            <td>
            	<cfset fechaArribo = LSDateFormat(Now(),'dd/mm/yyyy') >
                <cfif modo neq 'ALTA'>
                    <cfset fechaArribo = LSDateFormat(rsForm.EDIfechaarribo,'dd/mm/yyyy') >
                </cfif>
                <cf_sifcalendario 
                    value="#fechaArribo#" 
                    tabindex="6" 
                    name="EDIfechaarribo"
                    onBlur="cambiaFecha(this);">
		  </td>
	  </tr>
	  <tr>
      	<td colspan="1" align="right"><strong>Oficina</strong>:</td>
        <td colspan="2"><select name="Ocodigo" tabindex="1">
			<cfloop query="rsOficinas">
              <option value="#rsOficinas.Ocodigo#" 
					<cfif modo NEQ "ALTA" and rsOficinas.Ocodigo EQ rsForm.Ocodigo>selected
                    <cfelseif modo EQ 'ALTA' and isdefined('form.Ocodigo') and rsOficinas.Ocodigo EQ form.Ocodigo>selected</cfif>> #rsOficinas.Odescripcion# </option>
            </cfloop>
          </select>
        </td>
		<td align="right"><strong>Observaciones</strong> :</td>
		<td><a href="javascript:info();"><img border="0" src="../../imagenes/iedit.gif" alt="<cfif modo eq 'ALTA'>Definir<cfelse>Ver/Modificar</cfif> Observaciones"></a></td>
      </tr>
	  <tr>
		
		<cfif modo NEQ 'CAMBIO' or trim(rsForm.EDItipo) EQ 'N'>
		<td align="right" nowrap="nowrap">
			<div id="diLabelFact" style="display:'';" >
				<strong>Factura</strong> :
			</div>
		</td>
		<td nowrap="nowrap">
			<div id="divInputsFact" style="display: '';" >
				<cfif modo EQ "CAMBIO" and rsForm.EDIidref NEQ ''>										
					<cfquery name="rsDctoRef" datasource="#session.DSN#">
						select Ddocumento, EDIidRef
						from EDocumentosI
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and EDIid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.EDIidRef#">
					</cfquery>					
				</cfif>	
				<input type="hidden" name="EDIidref" value="<cfif isdefined("rsDctoRef") and len(trim(rsDctoRef.EDIidref))>#rsDctoRef.EDIidref#</cfif>">
				<input type="text" size="25" name="DdocumentoRef" value="<cfif isdefined("rsDctoRef") and len(trim(rsDctoRef.Ddocumento))>#rsDctoRef.Ddocumento#</cfif>"  onblur="javascript:fm(this,-1)" readonly disabled>
				<cfif modo NEQ 'CAMBIO'>
					<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Trackins" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisFacturas(1);'></a>				
				</cfif>
			</div>
		</td>	
		</cfif>	
      </tr>
      <tr>
      	<td nowrap="nowrap">
        	<strong>Transacción de CxP</strong>:
        </td>
        <td colspan="4">
        	<cfquery name="rsTransacciones" datasource="#Session.DSN#">
                select 	CPTcodigo, CPTdescripcion
                  from CPTransacciones
                 where Ecodigo = #Session.Ecodigo#
                   and CPTtipo = 'C'
                   and coalesce(CPTpago,0) != 1
                   and NOT CPTdescripcion like '%Tesorer_a%'
                    order by  1
        	</cfquery>
            <select name="CPTcodigo" tabindex="1"  onchange="sbCPTcodigoOnChange(this.value);">
			  <cfloop query="rsTransacciones">
                <option value="#rsTransacciones.CPTcodigo#" 
                            <cfif modo NEQ "ALTA" and rsTransacciones.CPTcodigo EQ rsForm.CPTcodigo or isdefined("form.CPTcodigo") and modo EQ "ALTA" and rsTransacciones.CPTcodigo eq form.CPTcodigo>selected
                            <cfelseif modo EQ 'ALTA' and isdefined('form.CPTcodigo') and rsTransacciones.CPTcodigo EQ "--">
                                selected
                            </cfif>> #rsTransacciones.CPTcodigo# - #rsTransacciones.CPTdescripcion# </option>
              </cfloop>
            </select>
        </td>
      </tr>
  </table>
  
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
<!------------------------------ Sentencia Iframe para averiguar el tipo de cambio ---------------------------------->
<iframe id="frTipoCambio" name="frTipoCambio" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>

</cfoutput>
<!----not isdefined('form.EPDid_DP') or len(trim(form.EPDid_DP)) EQ 0) and (---->
<script language="javascript1.2" type="text/javascript">
	function cambiaFecha(obj){
		if(obj.value != ''){
			<cfoutput>
				var fr = document.getElementById("frTipoCambio");
				
				fr.src = "/cfmx/sif/cm/operacion/queryTipoCambio.cfm?fechaSug=" + obj.value + 
						"&Mcodigo=" + document.form1.Mcodigo.value  +
						"&form_name=form1&conexion=#session.dsn#";
			</cfoutput>
		}		
	}
	
	function info(){
		open('EDocumentosI-info.cfm', 'documentos', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
	}

	function cambiaAlmacen(){
		document.form1.CFid.value = '';
		document.form1.CFcodigo.value = '';
		document.form1.CFdescripcion.value = '';
	}

	function funcCFcodigo(){
		document.form1.Aid.value = '';
	}

	asignaTC();
	<cfif modo EQ 'ALTA'>
		document.form1.Ddocumento.focus();
	</cfif>	
	
	function doConlisFacturas(valor) {
		var params ='';
		<cfif isdefined("form.EPDid_DP") and len(trim(form.EPDid_DP))>
			params="&EPDid="+<cfoutput>#form.EPDid_DP#</cfoutput>;
		<cfelse>
			params = '';
		</cfif>
		if (document.form1.EDItipo.value == 'N'){
			if (document.form1.SNcodigo.value ==''){
				alert("Debe seleccionar el proveedor");
			}
			else{
				params = params + "&SNcodigoDcto="+ document.form1.SNcodigo.value;
				popUpWindow("/cfmx/sif/cm/operacion/ConlisFacturas.cfm?formulario=form1"+params,30,100,950,500);
			}
		}
	}

	function funcPintaFactura(voCombo){
		var div_label_fact   	= document.getElementById("diLabelFact");		
		var div_inputs_fact		= document.getElementById("divInputsFact");
		if (voCombo.value == 'F' || voCombo.value == 'D'){
			document.form1.EDIidref.value = '';
			document.form1.DdocumentoRef.value = '';
			div_label_fact.style.display = 'none';
			div_inputs_fact.style.display = 'none';
		}
		else{
			div_label_fact.style.display = '';
			div_inputs_fact.style.display = '';
		}		
	 }
	 
</script>