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
	<input type="submit" name="Agregar" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
	<input type="submit" name="Continuar" value="Continuar" onClick="javascript: this.form.botonSel.value = this.name" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
	<input type="submit" name="Finalizar" value="Finalizar" onClick="javascript: this.form.botonSel.value = this.name" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
	<input type="submit" name="Cancelar" value="Cancelar" onClick="javascript: this.form.botonSel.value = this.name" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>


<!---
<cfif modo EQ "ALTA">
	<input type="submit" name="Continuar" value="Continuar" onClick="javascript: this.form.botonSel.value = this.name" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
	<input type="submit" name="Finalizar" value="Finalizar" onClick="javascript: this.form.botonSel.value = this.name" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
	<input type="submit" name="Cancelar" value="Cancelar" onClick="javascript: this.form.botonSel.value = this.name" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>

	<input type="button" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name; if (window.limpiar){limpiar()};" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
<cfelse>	
	<input type="submit" name="Cambio" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); " <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
	<input type="submit" name="Baja" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); return confirm('¿Desea Eliminar el Registro?');" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
	<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); " <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
</cfif>
--->
