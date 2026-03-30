
<!--- Establecimiento del modoD --->
<cfif isdefined("form.FPcodigo") and form.FPcodigo NEQ '' and isdefined('form.FPDcodigo') and form.FPDcodigo NEQ ''>
	<cfset modoD="CAMBIO">
<cfelse>
	<cfset modoD="ALTA">
</cfif>

<!---       Consultas      --->
<cfif modoD NEQ 'ALTA'>
	<cfquery name="rsFormD" datasource="#session.DSN#">
		Select convert(varchar,FPDcodigo) as FPDcodigo
			, rtrim(ltrim(FPDnombre)) as FPDnombre
			, FPDtipoDato
			, FPDlongitud
			, FPDdecimales
			, FPDobligatorio
			, FPDorden
		from FormaPagoDatos
		where FPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPcodigo#">
			and FPDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPDcodigo#">
	</cfquery>
</cfif>

<cfquery name="qryOrden" datasource="#Session.DSN#">
	Select convert(varchar,FPDorden) as FPDorden
	from FormaPagoDatos
	where FPcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPcodigo#">
</cfquery>



<script language="JavaScript" type="text/javascript" src="../js/utilesMonto.js">//</script>
<script language="JavaScript" type="text/javascript" src="../js/qForms/qforms.js">//</script>
<form action="formaPagoDatos_SQL.cfm" method="post" name="formFormaPagoDatos">
	<cfoutput>
		<input type="hidden" name="FPcodigo" value="#form.FPcodigo#">
		
		<cfif modoD NEQ 'ALTA' and isdefined('rsFormD') and rsFormD.recordCount GT 0>
			<input type="hidden" name="FPDcodigo" value="#rsFormD.FPDcodigo#">
		</cfif>
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td colspan="3" class="tituloMantenimiento" align="center">
				<cfif modoD eq "ALTA">
					Nuevo Dato
				<cfelse>
					Modificar Dato
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td colspan="2"><strong>Nombre</strong></td>
			<td><strong>Tipo de dato</strong></td>
		  </tr>
		  <tr>
			<td colspan="2"><input name="FPDnombre" type="text" id="FPDnombre" value="<cfif modoD NEQ "ALTA">#rsFormD.FPDnombre#</cfif>" size="40" maxlength="60"></td>
			<td><select name="FPDtipoDato" id="FPDtipoDato">
			<option value="F" <cfif modoD NEQ 'ALTA' and rsFormD.FPDtipoDato EQ 'F'> selected</cfif>>Fecha</option>
			<option value="N" <cfif modoD NEQ 'ALTA' and rsFormD.FPDtipoDato EQ 'N'> selected</cfif>>Num&eacute;rico</option>
			<option value="C" <cfif modoD NEQ 'ALTA' and rsFormD.FPDtipoDato EQ 'C'> selected</cfif>>Caracter</option>
			<option value="P" <cfif modoD NEQ 'ALTA' and rsFormD.FPDtipoDato EQ 'P'> selected</cfif>>Password</option>
			</select></td>
		  </tr>
		  <tr>
			<td height="21"><strong>Longitud</strong></td>
			<td><strong>Orden</strong></td>
			<td><strong>Decimales</strong></td>
		  </tr>
		  <tr>
			<td><cfoutput>
			  <input name="FPDlongitud" tabindex="11" style="text-align: right;" type="text" id="FPDlongitud" size="10" maxlength="8" value="<cfif modoD NEQ "ALTA">#rsFormD.FPDlongitud#<cfelse>0</cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
			</cfoutput></td>
			<td><cfoutput>
			  <input name="FPDorden" tabindex="11" style="text-align: right;" type="text" id="FPDorden2" size="10" maxlength="8" value="<cfif modoD NEQ "ALTA">#rsFormD.FPDorden#</cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
			</cfoutput></td>
			<td><cfoutput>
			  <input name="FPDdecimales" tabindex="11" style="text-align: right;" type="text" id="FPDdecimales" size="10" maxlength="8" value="<cfif modoD NEQ "ALTA">#rsFormD.FPDdecimales#<cfelse>0</cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
			</cfoutput></td>
		  </tr>
		  <tr>
			<td>
				<strong>
					<input type="checkbox" <cfif modoD NEQ "ALTA" and rsFormD.FPDobligatorio EQ 1> checked</cfif> name="FPDobligatorio" id="FPDobligatorio" value="1">
					Obligatorio	  
				</strong>		</td>
			<td colspan="2">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="3" align="center">			
				<cfif not isdefined('modoD')>
					<cfset modoD = "ALTA">
				</cfif>
				
				<input type="hidden" name="botonSel" value="">
				
				<cfif modoD EQ "ALTA">
					<input type="submit" name="Alta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
					<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
				<cfelse>	
					<input type="submit" name="Cambio" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacionD) habilitarValidacionD(); ">
					<input type="submit" name="Baja" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea Eliminar el Registro?') ){ if (window.deshabilitarValidacionD) deshabilitarValidacionD(); return true; }else{ return false;}">
					<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacionD) deshabilitarValidacionD(); ">
				</cfif>		
			</td>
		  </tr>	    
		</table>
	</cfoutput>		
</form>

<script language="JavaScript">
//---------------------------------------------------------------------------------------			
	function deshabilitarValidacionD() {
		objFormDet.FPDnombre.required = false;		
		objFormDet.FPDtipoDato.required = false;
		objFormDet.FPDlongitud.required = false;
		objFormDet.FPDorden.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacionD() {
		objFormDet.FPDnombre.required = true;		
		objFormDet.FPDtipoDato.required = true;
		objFormDet.FPDlongitud.required = true;
		objFormDet.FPDorden.required = true;		
	}	
//---------------------------------------------------------------------------------------
	// Se aplica al codigo del idioma 
	function __isValidaOrden() {
		if(btnSelected("Alta", this.obj.form) || btnSelected("Cambio", this.obj.form)) {
			if(this.value != '') {
				<cfif isdefined('qryOrden') and qryOrden.recordCount GT 0>
					var existeFPDorden = false;
		
					var ordenList = "<cfoutput>#ValueList(qryOrden.FPDorden,'~')#</cfoutput>"
					var ordenArray = ordenList.split("~");
					for (var i=0; i<ordenArray.length; i++) {
						<cfif modoD NEQ "ALTA">
							if ((this.value == ordenArray[i]) && (ordenArray[i] != '<cfoutput>#rsFormD.FPDorden#</cfoutput>')) {
						<cfelse>
							if (ordenArray[i] == this.value) {
						</cfif>
							existeFPDorden = true;
							break;
						}
					}
					
					if (existeFPDorden){
						this.error = "El orden del dato ya existe, favor digitar uno diferente";				
						this.focus();
					}
				</cfif>
			}else{
				if(btnSelected("Cambio",this.obj.form)){
					this.value = "<cfif isdefined('rsFormD')><cfoutput>#rsFormD.FPDorden#</cfoutput></cfif>";
				}
			}		
		}
	}
//---------------------------------------------------------------------------------------		
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isValidaOrden", __isValidaOrden);
	objFormDet = new qForm("formFormaPagoDatos");
//---------------------------------------------------------------------------------------
	objFormDet.FPDnombre.required = true;
	objFormDet.FPDnombre.description = "Nombre";		
	objFormDet.FPDtipoDato.required = true;
	objFormDet.FPDtipoDato.description = "Tipo del dato";			
	objFormDet.FPDlongitud.required = true;
	objFormDet.FPDlongitud.description = "Longitud";			
	objFormDet.FPDorden.required = true;
	objFormDet.FPDorden.description = "Orden";			
	objFormDet.FPDorden.validateValidaOrden();
</script>