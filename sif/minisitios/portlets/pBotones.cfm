<cf_templatecss>
<input name="txtEnterSI" type="text" size="1" readonly="true" class="cajasinbordeb">
<input type="hidden" name="botonSel" value="">
<cfif modo EQ "ALTA">
	<input type="submit" name="Alta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
	<!--- <input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name"> --->
<cfelse>	
	<input type="submit" name="Cambio" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); ">
	<input type="submit" name="Baja" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); return confirm('¿Desea Eliminar el Registro?');">
	<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
</cfif>
