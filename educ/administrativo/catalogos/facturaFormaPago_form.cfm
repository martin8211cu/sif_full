<!--- Establecimiento del modoP --->
<cfif isdefined('form.FACcodigo') and form.FACcodigo NEQ '' and isdefined("form.FAPsecuencia") and form.FAPsecuencia NEQ ''>
	<cfset modoP="CAMBIO">
<cfelse>
	<cfset modoP="ALTA">
</cfif>

<!---       Consultas      --->
<!--- Informacion de la factura --->
<cfquery name="rsForm" datasource="#session.DSN#">
	select ((FACmonto + FACimpuesto)-FACdescuento) as montoFact, FACestado
	from FacturaEdu
		where FACcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FACcodigo#">
</cfquery>

<cfquery name="rsSumaPago" datasource="#session.DSN#">
	set rowcount 1
		select sum(FAPmonto) as sumaMonto
		from FacturaEduFormaPago ffp
			 , FacturaEdu fe 
		where ffp.FACcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FACcodigo#">
			and ffp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and ffp.FACcodigo=fe.FACcodigo 
			and ffp.Ecodigo=fe.Ecodigo 
	set rowcount 0
</cfquery>

<cfif modoP NEQ 'ALTA'>
	<cfquery name="rsFormPago" datasource="#session.DSN#">
		select 
			convert(varchar,FAPsecuencia) as FAPsecuencia
			, FAPtipo
			, FAPorigen
			, FAPmonto
		from FacturaEduFormaPago ffp
			, FacturaEdu fe
		where ffp.FACcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FACcodigo#">
			and FAPsecuencia=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAPsecuencia#">
			and ffp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and ffp.FACcodigo=fe.FACcodigo
			and ffp.Ecodigo=fe.Ecodigo
	</cfquery>
</cfif>

<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>
<script language="JavaScript" src="../../js/utilesMonto.js">//</script>
<form action="facturaFormaPago_SQL.cfm" method="post" name="formFactFormaPago" style="margin: 0">
<cfoutput>
	<cfif modoP neq 'ALTA'>
		<input type="hidden" name="FAPsecuencia"  value="<cfif isdefined('rsFormPago') and rsFormPago.recordCount GT 0>#rsFormPago.FAPsecuencia#</cfif>">			
	</cfif>
	<input type="hidden" name="codApersona" value="#form.codApersona#">
	<input type="hidden" name="FACcodigo" value="#form.FACcodigo#">
	<cfif isdefined('rsForm') and rsForm.recordCount GT 0 and rsForm.montoFact NEQ ''>
		<input type="hidden" name="montoFactura" value="#rsForm.montoFact#">
	</cfif>	
	<cfif isdefined('rsSumaPago') and rsSumaPago.recordCount GT 0 and rsSumaPago.sumaMonto NEQ ''>
		<input type="hidden" name="sumaPagos" value="#rsSumaPago.sumaMonto#">
	</cfif>
	
	  <table width="100%" border="0" cellpadding="1" cellspacing="1">
		<tr> 
		  <td class="tituloMantenimiento" colspan="2" align="center" nowrap> <font size="3"> 
			<cfif modoP eq "ALTA">
			  Nueva 
			<cfelse>
			  Modificar 
			</cfif>
				Forma de Pago
			</font></td>
		</tr>
		<tr id="idOrigen"> 
		  <td width="20%" align="right" valign="baseline"><strong>Origen</strong>:</td>
		  <td width="80%" valign="baseline"><input name="FAPorigen" type="text" id="FAPorigen" onfocus="javascript:this.select();" value="<cfif modoP neq 'ALTA'>#rsFormPago.FAPorigen#</cfif>" size="40" maxlength="255"></td>
	    </tr>
		<tr> 
		  <td width="20%" align="right" valign="baseline"><strong>Tipo</strong>:</td>
		  <td valign="baseline">
			  <select name="FAPtipo" id="FAPtipo" onChange="javascript: cambioTipo(this)">
				<option value="1" <cfif modoP NEQ 'ALTA' and rsFormPago.FAPtipo EQ 1> selected</cfif>>Efectivo</option>
				<option value="2" <cfif modoP NEQ 'ALTA' and rsFormPago.FAPtipo EQ 2> selected</cfif>>Tarjeta</option>
				<option value="3" <cfif modoP NEQ 'ALTA' and rsFormPago.FAPtipo EQ 3> selected</cfif>>Cheque</option>						
			  </select>
		  </td>
		</tr>
		<tr> 
		  <td width="20%" align="right" nowrap valign="baseline"><strong>Monto</strong>:</td>
		  <td valign="baseline">
			<input name="FAPmonto" type="text" id="FAPmonto" value="<cfif modoP neq 'ALTA'>#LSCurrencyFormat(rsFormPago.FAPmonto,'none')#</cfif>" size="10" maxlength="10" 
				style="text-align: right;"
				onfocus="javascript:this.value=qf(this); this.select();" 
				onblur="javascript:fm(this,2);"
				onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
				
				<cfif isdefined('rsForm') 
					and rsForm.recordCount GT 0
					and rsForm.montoFact NEQ ''
					and rsForm.montoFact GT 0>
						<cfif isdefined('rsSumaPago') 
							and rsSumaPago.recordCount GT 0
							and rsSumaPago.sumaMonto NEQ ''
							and rsForm.montoFact GT rsSumaPago.sumaMonto
							and rsForm.FACestado NEQ 2>
		
							<input type="button" name="PagarTodo" onSelect="javascript: alert(select);" onClick="javascript: this.form.botonSelPagos.value = this.name; if (window.deshabilitarValidacionPagos) deshabilitarValidacionPagos(); validaPagoTodo();" value="Pagar Todo">
						<cfelseif rsForm.montoFact GT 0 and rsSumaPago.sumaMonto EQ ''>
							<input type="button" name="PagarTodo" onSelect="javascript: alert(select);" onClick="javascript: this.form.botonSelPagos.value = this.name; if (window.deshabilitarValidacionPagos) deshabilitarValidacionPagos(); validaPagoTodo();" value="Pagar Todo">						
						</cfif>						
				</cfif>
		  </td>
		</tr>					
		<tr> 
		  <td width="20%" align="right" nowrap valign="baseline">&nbsp;</td>
		  <td valign="baseline">&nbsp;</td>
		</tr>					
		<tr> 
		  <td align="center" colspan="2"> 
			  <cfif isdefined('rsForm') and rsForm.recordCount GT 0 and rsForm.FACestado NEQ 2>
					<cfif not isdefined('modoP')>
						<cfset modoP = "ALTA">
					</cfif>
					
					<cfset mensajeDelete = "¿Desea Eliminar esta Forma de Pago ?">
					<input type="hidden" name="botonSelPagos" value="">
					
					<cfif modoP EQ "ALTA">
						<cfif isdefined('rsSumaPago') 
							and rsSumaPago.recordCount GT 0
							and rsForm.montoFact NEQ ''
							and rsSumaPago.sumaMonto NEQ ''
							and rsForm.montoFact GT 0
							and rsSumaPago.sumaMonto GTE 0							
							and rsForm.montoFact GT rsSumaPago.sumaMonto>
							
								<input type="submit" name="AltaP" value="Agregar" onClick="javascript: this.form.botonSelPagos.value = this.name; if (window.habilitarValidacionPagos) habilitarValidacionPagos();">					
						<cfelseif rsForm.montoFact GT 0 and rsSumaPago.sumaMonto EQ ''>
							<input type="submit" name="AltaP" value="Agregar" onClick="javascript: this.form.botonSelPagos.value = this.name; if (window.habilitarValidacionPagos) habilitarValidacionPagos();">											
						</cfif>
		
						<input type="reset" name="LimpiarP" value="Limpiar" onClick="javascript: this.form.botonSelPagos.value = this.name">
					<cfelse>	
						<input type="submit" name="CambioP" onSelect="javascript: alert(select);" onClick="javascript: this.form.botonSelPagos.value = this.name; if (window.habilitarValidacionPagos) habilitarValidacionPagos(); " value="Modificar">								
						<cfif isdefined('rsSumaPago') 
							and rsSumaPago.recordCount GT 0
							and rsForm.montoFact GT rsSumaPago.sumaMonto>
								<input type="submit" name="NuevoP" value="Nuevo" onClick="javascript: this.form.botonSelPagos.value = this.name; if (window.deshabilitarValidacionPagos) deshabilitarValidacionPagos(); ">											
						</cfif>				
		
						<input type="submit" name="BajaP" value="Eliminar" onclick="javascript: this.form.botonSelPagos.value = this.name; if ( confirm('<cfoutput>#mensajeDelete#</cfoutput>') ){ if (window.deshabilitarValidacionPagos) deshabilitarValidacionPagos(); return true; }else{ return false;}">
						<cfif isdefined('rsSumaPago') 
							and rsSumaPago.recordCount GT 0
							and rsForm.montoFact LTE rsSumaPago.sumaMonto>
								<input type="submit" name="PagarP" onSelect="javascript: alert(select);" onClick="javascript: this.form.botonSelPagos.value = this.name; if (window.deshabilitarValidacionPagos) deshabilitarValidacionPagos(); " value="Pagar">					
						</cfif>
					</cfif>
			  </cfif>
		  </td>
		</tr>
	  </table>
</cfoutput>  
</form>	  

<script language="JavaScript">
	function validaPagoTodo(){
		<cfif isdefined('rsForm') 
			and isdefined('rsSumaPago') 
			and rsForm.recordCount GT 0
			and rsSumaPago.recordCount GT 0
			and rsForm.montoFact NEQ ''
			and rsSumaPago.sumaMonto NEQ ''
			and rsForm.montoFact GTE 0
			and rsSumaPago.sumaMonto GTE 0>
				if(confirm('Desea pagar el monto de  ' + <cfoutput>#rsForm.montoFact - rsSumaPago.sumaMonto#</cfoutput> + '   para cancelar la factura ?'))
					document.formFactFormaPago.submit();
				else
					document.formFactFormaPago.botonSelPagos.value = '';			
		<cfelse>
				if(confirm('Desea cancelar el monto faltante de la factura ?'))
					document.formFactFormaPago.submit();
				else
					document.formFactFormaPago.botonSelPagos.value = '';
		</cfif>
	}
//---------------------------------------------------------------------------------------			
	function cambioTipo(obj){
		var varOrigen = document.getElementById('idOrigen');

		if(obj.value != 1)	//	Efectivo
			varOrigen.style.display = '';		
		else
			varOrigen.style.display = 'none';
	}
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacionPagos() {
		objFormPagos.FAPorigen.required = false;
		objFormPagos.FAPtipo.required = false;
		objFormPagos.FAPmonto.required = false;		
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacionPagos() {
		if(document.formFactFormaPago.FAPtipo.value != 1)
			objFormPagos.FAPorigen.required = true;
		else
			objFormPagos.FAPorigen.required = false;
		objFormPagos.FAPtipo.required = true;
		objFormPagos.FAPmonto.required = true;				
	}
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objFormPagos = new qForm("formFactFormaPago");
//---------------------------------------------------------------------------------------
	objFormPagos.FAPorigen.required = true;
	objFormPagos.FAPorigen.description = "Origen";
	objFormPagos.FAPtipo.required = true;
	objFormPagos.FAPtipo.description = "Tipo";
	objFormPagos.FAPmonto.required = true;
	objFormPagos.FAPmonto.description = "Monto";

	cambioTipo(document.formFactFormaPago.FAPtipo);
</script>
