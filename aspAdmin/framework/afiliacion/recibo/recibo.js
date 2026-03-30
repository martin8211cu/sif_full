function valida(form){

	if ( existe(form, "sel") ){
		if ( form.sel.type == "checkbox" ){
			if (!form.sel.checked){
				alert("No se han seleccionado registros para procesar")
				return false
			}	
		}
		// Arreglo de checkbox
		else{
			if (form.sel.length > 0){
				if ( !checkeados(form.sel) ){
					alert("No se han seleccionado registros para procesar")
					return false
				}
			}
			else{
				alert("No existen registros para procesar")
				return false	
			}
		}	
		
		return true;
	}
	else{
	    return false
	}
}

function checkeados(obj){

    for (i=0; i<obj.length; i++){
	    if (obj[i].checked){
		    return true;
		}
	} 
	return false
}

function validarSeleccion(obj){
}

function checkAll(obj){
    var form = obj.form;
	
	if (existe(form, "sel")){
		if (obj.checked){
			for (var i=0; i<form.sel.length; i++){
				form.sel[i].checked = "checked";
			}
		}
	}
}

function verifycheckAll(obj){
    var form = obj.form
	
	// si se marcaron todos los checks a pata, marca el check de todos
	if (!form.todos.checked){
	    var checkeados = true;
		for (var i=0; i<form.sel.length; i++){
		    if (!form.sel[i].checked){
			    checkeados = 'false'
				return;				
			}
		}
		if (checkeados){
		    form.todos.checked = "checked"	
		}
	}
	// si el chek de todos esta marcado y se desmarco uno del detalle, desmarca el de todos
	else{
		if (!obj.checked){
			form.todos.checked = ""
		}
	}	
}

function lineBlur(){

	var form = document.contratos;
	var maxrow = 1;
	for (n = maxrow; n <= 15; n++) {
		var c1 = "contrato_" + n;
		var c2 = "email_"    + n;
		var c3 = "login_"    + n;
		if (form[c1].value != "" || form[c2].value != "" || form[c3].value != "") {
			maxrow = n;
		}
	}

	for (n = 0; n <= 15; n++) {
		var c1 = "contrato_" + n;
		var c2 = "email_"    + n;
		var c3 = "login_"    + n;
		if (n <= maxrow + 1) {
			var rowobj = document.all ? document.all["row_" + n] : document.getElementById("row" + n);
			if (rowobj) {
				rowobj.style.display = "inline";
			}
		}
	}
}

function isValidEmail(obj)
{
	var s = obj.value;
    if (s == "") {
        return true; // no se va a usar
    }

    var atsign = s.indexOf ("@");
    if (atsign == -1) {
		alert ("Correo inválido: " + s);
		obj.value = "";		
		obj.focus();
        return false;
    }

    if (s.indexOf (".", atsign) == -1) {
		alert ("Correo inválido: " + s);	
		obj.value = "";
		obj.focus();		
        return false;
    }
    return true;
}

function confirmar(obj){
	for(i=0; i<15; i++){
	    if( !(obj["contrato_" + i].value == "" ) ){
			return true
		}
	}
	alert("No existen contratos para procesar")
	return false;
}

function existe(form, name){
// RESULTADO
// Valida la existencia de un objecto en el form

	if (typeof form[name] != "undefined") {
		return true
   	}
	else{
		return false
	}
}
