<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 8-3-2006.
		Motivo: Se utiliza la función snumber del utilesmonto.js para validar el campo Concepto de que sea un número.
 --->

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
<cfif not isdefined("Form.CBTTid") and isdefined("url.CBTTid")>
	<cfset Form.CBTTid=url.CBTTid>
</cfif>

</script>

<cfquery datasource="#Session.DSN#" name="rsTipoTarjetas">
 	select * from CBTipoTarjetaCredito
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("form.CBTTid") and form.CBTTid NEQ "">
		and CBTTid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBTTid#">
	</cfif>
</cfquery>

<form method="post" name="form1" onSubmit="if (document.form1.botonSel.value !='Baja' && document.form1.botonSel.value !='Nuevo'){ MM_validateForm('CBTTDescripcion','','R');return document.MM_returnValue }else{ return true; }" action="TCESQLTipoTarjetas.cfm">
	<table align="center">
		
		<tr valign="baseline"> 
			<td nowrap align="left">C&oacute;digo:&nbsp;</td>
			<td><input type="text" name="CBTTcodigo" id="CBTTcodigo" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsTipoTarjetas.CBTTcodigo#</cfoutput></cfif>" size="32" tabindex="1" onfocus="javascript: this.select();" alt="El campo Código"></td>
		</tr>
        <tr valign="baseline"> 
			<td nowrap align="left">Descripci&oacute;n:&nbsp;</td>
			<td><input type="text" name="CBTTDescripcion" id="CBTTDescripcion" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsTipoTarjetas.CBTTDescripcion#</cfoutput></cfif>" size="32" tabindex="1" onfocus="javascript: this.select();" alt="El campo Descripción"></td>
		</tr>
        
		<tr> 
			<td colspan="2" align="center" nowrap>
				<input type="hidden" name="botonSel" value="" tabindex="-1">
				<input name="txtEnterSI" type="text" size="1" tabindex="-1" maxlength="1" readonly="true" class="cajasinbordeb">
				<cfif modo EQ "ALTA">
					<input type="submit" name="Alta" value="Agregar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name">
					<input type="reset" name="Limpiar" value="Limpiar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name">
				<cfelse>
					<input type="submit" name="Cambio" value="Modificar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name; validaMon();">
					<input type="submit" name="Baja" value="Eliminar" tabindex="1" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('Est\u00e1 seguro(a) de que desea eliminar el registro ?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;} validaMon();">
					<input type="submit" name="Nuevo" value="Nuevo" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); validaMon();">
				</cfif>
			</td>
		</tr>
	</table>
	
	<input type="hidden" name="CBTTid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsTipoTarjetas.CBTTid#</cfoutput></cfif>">
	
	<cfset ts = "">	
	<cfif modo neq "ALTA">
		<cfinvoke 
			component="sif.Componentes.DButils"
		 	method="toTimeStamp"
		 	returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsTipoTarjetas.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
</form>


<cf_qforms>
<script language="javascript" type="text/javascript">
<!--//
objForm.CBTTDescripcion.description = "Descripci\u00f3n";
objForm.CBTTcodigo.description = "C\u00f3digo";

function validaMon(){
return true;
}

function habilitarValidacion(){
objForm.CBTTDescripcion.required = true;
objForm.CBTTcodigo.required = true;
}
function deshabilitarValidacion(){
objForm.CBTTDescripcion.required = false;
objForm.CBTTcodigo.required = false;
}
habilitarValidacion();
//-->
</script>

<script language="JavaScript" type="text/javascript">
	// Funciones para Manejo de Botones
	botonActual = "";

	function setBtn(obj) {
		botonActual = obj.name;
	}
	function btnSelected(name, f) {
		alert(document.getElementById('CBTTDescripcion').value);
		if (f != null) {
				return (f["botonSel"].value == name);
		} else {
				return (botonActual == name);
		}
	}

</script>
