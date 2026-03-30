<link href="/cfmx/sif/V5/css/estilos.css" rel="stylesheet" type="text/css">

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
<cfif not isdefined('modo')>
	<cfset modo = "ALTA">
</cfif>

<input type="hidden" name="botonSel" value="">
<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
<cfif modo EQ "ALTA">
	<input type="submit" name="Alta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
	<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
	<cfif Form.CJX19REL neq "0">
		<input type="submit" name="BajaR" value="Eliminar Relación" onclick="javascript: novalidar() ;this.form.botonSel.value = this.name; if ( confirm('¿Desea Eliminar la relación?') ){return true; }else{ return false;}">
	</cfif>
	<input type="submit" name="Posteo" value="Aplicar" onclick="javascript: novalidar() ; this.form.botonSel.value = this.name; if ( confirm('¿Desea aplicar la relación?') ){ return true; }else{ return false;}">	
<cfelse>	
	<input type="submit" name="Cambio" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); ">
	<input type="submit" name="Baja" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea Eliminar el Registro?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
	<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
	<input type="submit" name="Posteo" value="Aplicar" onclick="javascript: novalidar() ; this.form.botonSel.value = this.name; if ( confirm('¿Desea aplicar la relación?') ){ return true; }else{ return false;}">	
</cfif>
