function ValidaBuscar(formulario){
    if (formulario.busqueda.value=="") {
        alert("Debe proporcionar algún criterio para la Búsqueda");
        formulario.busqueda.focus();
        return false;
    }
    return true
}