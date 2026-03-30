function blur_cedula(ctl){
	var value = ctl.value;
	value = value.replace(/^([0-9])-([0-9]{3})-([0-9]{4})$/,'$1-0$2-$3');
	value = value.replace(/^([0-9])-([0-9]{4})-([0-9]{3})$/,'$1-$2-0$3');
	value = value.replace(/^([0-9])-([0-9]{3})-([0-9]{3})$/,'$1-0$2-0$3');
	value = value.replace(/^([0-9])([0-9]{3})([0-9]{3})$/,'$1-0$2-0$3');
	value = value.replace(/^([0-9])([0-9]{4})([0-9]{4})$/,'$1-$2-$3');
	ctl.value = value;
	buscar_persona(ctl.form);
}

function buscar_persona(f) {
	var cedula = f.Pid ? f.Pid.value : "";
	var nombre = f.Pnombre ? f.Pnombre.value : "";
	var apellido1 = f.Papellido1 ? f.Papellido1.value : "";
	var apellido2 = f.Papellido2 ? f.Papellido2.value : "";
	var el_frame = document.all ? document.all.frame_buscar_persona : document.getElementById('frame_buscar_persona');
	var search_args = '?cedula=' + escape(cedula) + '&nombre=' + escape(nombre) +
		'&apellido1=' + escape(apellido1) + '&apellido2=' + escape(apellido2);
	if (f.pariente.value) return;
	if (!cedula && !(nombre && apellido1)) return;
	if (document.estoy_buscando) return;
	if (f.search_args && f.search_args == search_args) return;
	/*if (f.buscar_status) {
		f.buscar_status.value = "Buscando persona ...";
	}*/
	if (el_frame) {
		// relativo porque se usa en personas/ y en programas/
		el_frame.src = '../personas/buscar_persona.cfm' + search_args;
		f.search_args = search_args;
		document.form_para_busqueda = f;
		document.estoy_buscando = true;
		f.pariente.value = '';
	} else {
		alert("No encuentro el iframe !");
	}
}

function blur_nombre(f){
	buscar_persona(f);
}

function reset_persona_nueva(f){
	f.pariente.value = '';
	f.search_args = '';
	//f.buscar_status.value = '';
}

function persona_encontrada(id_persona,nombre,apellido1,apellido2,cedula) {
	var f = document.form_para_busqueda;
	if (!f) return;
	
	if (confirm ("Ya existe en nuestra base de datos un registro para " + nombre +
		" " + apellido1 +
		" " + apellido2 +
		" (c\u00e9dula " + cedula + 
		"). \n \u00bfEs \u00e9sta la persona que est\u00e1 buscando?"))
	{
		/*if (f.buscar_status){
			f.buscar_status.value = "Persona encontrada ";
			setTimeout('limpiar_status_buscar',2000);
		}*/
		f.pariente.value = id_persona;
		f.Pnombre.value = nombre;
		f.Papellido1.value = apellido1;
		f.Papellido2.value = apellido2;
		f.Pid.value = cedula;
	} else {
		f.pariente.value = '';
		f.Pid.value = '';
		f.search_args = '';
	}
	document.estoy_buscando = false;
}

function persona_no_encontrada () {
	var f = document.form_para_busqueda;
	if (f) {
		/*if (f.buscar_status) {
			f.buscar_status.value = "Persona no encontrada";
			setTimeout('limpiar_status_buscar',2000);
		}*/
		f.pariente.value = '';
	}
	document.estoy_buscando = false;
}

function limpiar_status_buscar(){
	var f = document.form_para_busqueda;
	/*if (f && f.buscar_status){
		f.buscar_status.value = "";
	}*/
}