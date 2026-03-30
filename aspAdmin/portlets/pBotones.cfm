<link href="/cfmx/sif/css/estilos.css" rel="stylesheet" type="text/css">

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

<cfif not isdefined("mensajeDelete") >
	<cfset mensajeDelete = "¿Desea Eliminar el Registro?">
</cfif>

<input type="hidden" name="botonSel" value="">
<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
<cfif modo EQ "ALTA">
	<input type="submit" name="Alta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion();">
	<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
<cfelse>	
	<input name="Cambio" type="submit" onSelect="javascript: alert(select);" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); " value="Modificar">
	<input type="submit" name="Baja" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('<cfoutput>#mensajeDelete#</cfoutput>') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
	<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
</cfif>

