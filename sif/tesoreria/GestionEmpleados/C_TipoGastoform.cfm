<!--- 
	
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
<cfif not isdefined("Form.GETtipo") and isdefined("url.GETtipo")>
	<cfset Form.GETtipo=url.GETtipo>
</cfif>

<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfif modo EQ "CAMBIO" >

<cfquery datasource="#Session.DSN#" name="rsID_tipo_gasto">
 	select 
		GETid,
		GETtipo, 
		GETdescripcion,
		ts_rversion
	from GEtipoGasto
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("form.GETid") and form.GETid NEQ "">
		and GETid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.GETid#">
	</cfif>
</cfquery> 
</cfif>
<form method="post" name="form1" action="C_TipoGastoSQL.cfm" onSubmit="return validar(this);">
  <table align="center">
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="left">C&oacute;digo de Tipo: </td>
		  <td>
			<cfif modo NEQ 'ALTA'>
				<cfoutput>
					#rsID_tipo_gasto.GETtipo#				</cfoutput>
					<input type="hidden" name="GETtipo" id="GETtipo" value="#rsID_tipo_gasto.GETtipo#">
			<cfelse>
			
					<input type="text" name="GETtipo" id="GETtipo" value="" size="32" tabindex="1" 
					onfocus="javascript: this.select();" 
					maxlength="10" alt="El campo Codigo" />
				
					
			</cfif>	
		  </td>
		</tr>		
		<tr valign="baseline"> 
			<td nowrap align="left">Descripcion:</td>
			<td><input type="text" name="GETdescripcion" id='GETdescripcion' maxlength="25" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsID_tipo_gasto.GETdescripcion#</cfoutput></cfif>" size="32" tabindex="1" onfocus="javascript: this.select();" alt="El campo Descripcion"></td>
		</tr><tr> 
			<td colspan="2" align="center" nowrap>
				<input type="hidden" name="botonSel" value="" tabindex="-1">
				<input name="txtEnterSI" type="text" size="1" tabindex="-1" maxlength="1" readonly="true" class="cajasinbordeb">
				<cfif modo EQ "ALTA">
					<input type="submit" name="Alta" value="Agregar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name">
					<input type="reset" name="Limpiar" value="Limpiar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name">
				<cfelse>
					<input type="submit" name="Cambio" value="Modificar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name; <!---if (window.habilitarValidacion) habilitarValidacion(); --->">
					<input type="submit" name="Baja" value="Eliminar" tabindex="1" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Está seguro(a) de que desea eliminar el registro?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
					<input type="submit" name="Nuevo" value="Nuevo" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
				</cfif>			</td>
		</tr>
  </table>
	
	<cfset ts = "">	
	<cfif modo neq "ALTA">
		<cfinvoke 
			component="sif.Componentes.DButils"
		 	method="toTimeStamp"
		 	returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsID_tipo_gasto.ts_rversion#"/>
		</cfinvoke>
	</cfif>
    <input type="hidden" name="GETid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsID_tipo_gasto.GETid#</cfoutput></cfif>" />
    <input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>" />
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
function validar(formulario)	{
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) ){
		var error_input;
		var error_msg = '';
		if (formulario.GETtipo.value == "") {
			error_msg += "\n - El codigo del concepto no puede quedar en blanco.";
			error_input = formulario.GETtipo;
		}	
		if (formulario.GETdescripcion.value == "") {
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.GETdescripcion;
		}		
				
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>
		
		


