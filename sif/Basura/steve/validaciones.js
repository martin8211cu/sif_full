//Verifica que un teléfono sea válido con el formato 999-99-99.
function fnTelefonoValido(s) {
	 rePhoneNumber = new RegExp(/^\d{3}\-\d{2}\-\d{2}$/);		
	 if (!rePhoneNumber.test(s)) {
		  return false;
	 }
	return true;
}

//Validaciones /Steve/basura2.cfm.
function fnDefineObjetos(f) {
	f.txtNombre.alerta = 'Debe de digitar el nombre';
	f.txtNombre.telefono=false;
	f.txtApellidos.alerta = 'Debe de digitar los apellidos';
	f.txtApellidos.telefono=false;
	f.txtDireccion.alerta = 'Debe de digitar una direccion';
	f.txtDireccion.telefono=false;
	f.txtTelefono.alerta = 'Debe de digitar un numero de telefono válido (999-99-99)';
	f.txtTelefono.telefono=true;
}

function fnValido(f) {
	var valido=true;
	fnDefineObjetos(f);
	for (i=0;i<=(f.length-1);i++) {
		if (f[i].type == "text") {
			if (f[i].value == "" && f[i].alerta != "") {
				valido=false;
				alert(f[i].alerta);
				f[i].focus();
				break; 
			} else {
				if (f[i].telefono) {
					if (!fnTelefonoValido(f[i].value)) {
						valido=false;
						alert(f[i].alerta);
						f[i].focus();
						break; 
					}
				}
			}
		}
	}
	return valido;
}
