<cf_templatecss>

<cfparam name="botones.excluir" default="">

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

<input type="hidden" name="botonSel" value="" tabindex="-1" >

<input name="txtEnterSI" tabindex="-1" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb"  style="visibility:hidden;">
<cfoutput>

<cfif not isdefined("tabindex")>
	<cfset tabindex="-1">
</cfif>

<cfif modo EQ "ALTA">
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Limpiar"/>
	<input tabindex="#tabindex#" type="submit" name="Alta" value="#BTN_Agregar#" class="btnGuardar" onClick="javascript: this.form.botonSel.value = this.name">
	<input tabindex="#tabindex#" type="reset" name="Limpiar" value="#BTN_Limpiar#" class="btnLimpiar" onClick="javascript: this.form.botonSel.value = this.name">
<cfelse>
<!---	<cfif not isdefined("request.pBotones.NoCambio")>--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Modificar"
	Default="Modificar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Modificar"/>

	<input tabindex="#tabindex#" type="submit" name="Cambio" value="#BTN_Modificar#" class="btnGuardar" onClick="javascript: this.form.botonSel.value = this.name; <!---if (window.habilitarValidacion) habilitarValidacion(); --->">
<!---	</cfif>--->
	<!---<input type="submit" name="Baja" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); return confirm('¿Desea Eliminar el Registro?');">--->
<!---	<cfif not isdefined("request.pBotones.NoBaja")>--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Eliminar"
	Default="Eliminar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Eliminar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEliminarElRegistro"
	Default="Desea eliminar el registro?"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_DeseaEliminarElRegistro"/>
	
	<cfif not listfindNoCase(ucase(botones.excluir),'BAJA',',')> 
		<input tabindex="#tabindex#" type="submit" name="Baja" value="#BTN_Eliminar#" class="btnEliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('#MSG_DeseaEliminarElRegistro#') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
	</cfif>
	
<!---	</cfif>--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Nuevo"
	Default="Nuevo"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Nuevo"/>
	<input tabindex="#tabindex#" type="submit" name="Nuevo" value="#BTN_Nuevo#" class="btnNuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
</cfif>
</cfoutput>