<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">

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
<cfif not isdefined('mododet')>
	<cfset mododet = "ALTA">
</cfif>

<input type="hidden" name="botonSel" value="">

<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
<cfif mododet EQ "ALTA">
	<input type="submit" name="Altadet" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
	<input type="reset" name="Limpiardet" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
<cfelse>	
	<input type="submit" name="Cambiodet" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); ">
	<input type="submit" name="Bajadet" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea Eliminar el Registro?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
	<input type="submit" name="Nuevodet" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
</cfif>

