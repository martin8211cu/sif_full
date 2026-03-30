<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfif not isdefined("Form.modo") and isdefined("url.modo")>
	<cfset modo=url.modo>
</cfif>

<cfquery datasource = "#Session.DSN#" name = "addendas_query">
 	select
		ADDcodigo,
		ADDNombre
	from Addendas
	where ADDid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ADDid#">
</cfquery> 

<cfif modo EQ "CAMBIO">
	<cfquery datasource = "#Session.DSN#" name = "addendas_detalle_query">
		select
			CODIGO,
			VALOR,
			TIPO
		from AddendasDetalle
		where ADDDetalleid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ADDDetalleid#">
		and ADDid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ADDid#">
	</cfquery> 
</cfif>

<cfquery datasource = "#Session.DSN#" name = "addendas_detalle_list">
	select CODIGO from AddendasDetalle
		where ADDid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ADDid#">
</cfquery> 

<form method="post" name="form1" action="AgregarAddendasDetalle-sql.cfm" onSubmit="return validar(this);">
    <table align="center">
	    <tr><td><br/></td></tr>
		<tr valign="baseline"> 
			<td nowrap align="left">C&oacute;digo de Addenda: </td>
		    <td>
			    <cfoutput>#addendas_query.ADDcodigo#</cfoutput>
		    </td>
		</tr>	
		<tr><td><br/></td></tr>
		<tr valign="baseline"> 
			<td nowrap align="left">Nombre de Addenda: </td>
		    <td>
			    <cfoutput>#addendas_query.ADDNombre#</cfoutput>
		    </td>
		</tr>	
		<tr><td><br/></td></tr>
		<tr valign="baseline"> 
			<td nowrap align="left">Codigo :</td>
			<td><input type="text" name="CodigoDetalle" id='CodigoDetalle' maxlength="25" 
			    value="<cfif modo NEQ 'ALTA'><cfoutput>#addendas_detalle_query.CODIGO#</cfoutput></cfif>" 
				size="32" tabindex="1" onfocus="javascript: this.select();" alt="Codigo de detalle de Addenda"
				onkeypress = "return evitWhiteSpace(event);"/></td>
		</tr>
		<tr><td><br/></td></tr>
		<tr valign="baseline"> 
			<td nowrap align="left">Valor :</td>
			<td><input type="text" name="ValorDetalle" id='ValorDetalle' maxlength="25" 
			    value="<cfif modo NEQ 'ALTA'><cfoutput>#addendas_detalle_query.VALOR#</cfoutput></cfif>" 
				size="32" tabindex="1" alt="Valor de detalle de Addenda"></td>
		</tr>
		<tr><td><br/></td></tr>
		<tr>
		    <td nowrap align="left">Tipo Detalle :</td>
		    <td>
				<cfset tiposDetalleAddenda = ArrayNew(1)>
				<cfset ArrayAppend(tiposDetalleAddenda, "FIJO")>
				<cfset ArrayAppend(tiposDetalleAddenda, "PROMPT")>
				<select name = "TipoDetalle" id = "TipoDetalle">
					<cfloop from = "1" to = "#ArrayLen(tiposDetalleAddenda)#" index = "i">
					    <cfset tipo = #tiposDetalleAddenda[i]#>
						<option value="<cfoutput>#tipo#</cfoutput>" 
						    <cfif modo NEQ 'ALTA'>
							    <cfif tipo EQ addendas_detalle_query.TIPO>
								    <cfoutput>selected</cfoutput>
								</cfif>
							</cfif>
							>
						    <cfoutput>#tipo#</cfoutput>
						</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr><td><br/></td></tr>
		<tr> 
			<td colspan="2" align="center" nowrap>
				<input type="hidden" name="botonSel" value="" tabindex="-1">
				<input name="txtEnterSI" type="text" size="1" tabindex="-1" maxlength="1" readonly="true" class="cajasinbordeb">
				<cfif modo EQ "ALTA">
					<input type="submit" class = "btnNuevo" name="Alta" value="Agregar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name">
					<input type="reset" class = "btnLimpiar" name="Limpiar" value="Limpiar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name">
				<cfelse>
					<input type="submit" class = "btnGuardar" name="Cambio" value="Modificar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name;">
					<input type="submit" class = "btnEliminar" name="Baja" value="Eliminar" tabindex="1" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Está seguro(a) de que desea eliminar el registro?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
					<input type="submit" class = "btnNuevo" name="Nuevo" value="Nuevo" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
				</cfif>			
			</td>
		</tr>
    </table>
	
    <input type="hidden" name="ADDid" value="<cfoutput>#form.ADDid#</cfoutput>" />
    <input type="hidden" name="ADDDetalleid" 
	    value="<cfif isdefined("Form.ADDDetalleid")><cfoutput>#form.ADDDetalleid#</cfoutput></cfif>" />
</form>

<script language="JavaScript" type="text/javascript">
	// Funciones para Manejo de Botones
	botonActual = "";
	function setBtn(obj) {
		botonActual = obj.name;
	}

	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
	
</script>

<!---ValidacionesFormulario--->
<script type="text/javascript">
    var codigosDetalleAddenda = [];
    <cfscript>
	    for (i = 1; i <= addendas_detalle_list.RecordCount; i++) {
			codeValue = addendas_detalle_list.CODIGO[i];
			writeOutput("codigosDetalleAddenda.push('" & codeValue & "');"); 
		}
	</cfscript>

	function validar(formulario)	{
		if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) ){
			var error_input;
			var error_msg = '';
			if (formulario.CodigoDetalle.value === "") {
				error_msg += "\n - El codigo del concepto no puede quedar en blanco.";
				error_input = formulario.CodigoDetalle;
			}	
			if(formulario.TipoDetalle.value === "FIJO"){
				if (formulario.ValorDetalle.value === "") {
					error_msg += "\n - El valor no puede quedar en blanco.";
					error_input = formulario.ValorDetalle;
				}	
			}
			//Validar que el codigo de detalle no se repita
			if(!btnSelected('Cambio',document.form1)){
				if (formulario.CodigoDetalle.value !== "") {
					for(var i = 0; i < codigosDetalleAddenda.length; i++){
						var codeL = codigosDetalleAddenda[i];
						var codeC = formulario.CodigoDetalle.value;
						if(codeL === codeC){
							error_msg += "\n - El codigo que esta ingresando ya existe.";
							error_input = formulario.CodigoDetalle;
							break;
						}
					}
				}
			}
					
			// Validacion terminada
			if (error_msg !== "") {
				alert("Por favor revise los siguiente datos:" + error_msg);
				return false;
			}
		}
	}

	function evitWhiteSpace(event){
		var chCode = ('charCode' in event) ? event.charCode : event.keyCode;
        if(chCode === 32){
			return false;
		}
		return true;
	}
</script>
