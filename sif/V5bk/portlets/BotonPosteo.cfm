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

<input type="hidden" name="botonSel" value="">
<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
<input type="submit" name="Posteo" value="Aplicar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea aplicar la relación?') ){ return true; }else{ return false;}">	
