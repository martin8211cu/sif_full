function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function citaFocus(c){
	c.style.borderColor = 'black';
	c.select();
}

function citaBlur(c){
	c.style.borderColor = '';
}

function citaMove(c){
	if (c.style.borderColor == ''){
		c.style.borderColor = 'skyblue';
	}
}

function citaOut(c){
	var existe = c.style.borderColor.indexOf('skyblue');
	//if (c.style.borderColor == 'skyblue'){
	if (existe > -1 ){
		c.style.borderColor = '';
	}
}

function citaChange(c){
	window.status = "El texto de la cita ha sido modificado";
	var data = c.name.split('-');
	var f = window.document.guardaagenda;
	f.txt.value    = c.value;
	f.citaid.value = data[1]; 
	f.fecha.value  = c.form.fecha.value;
	f.hora.value   = data[2];
	f.indice.value = data [3];
	f.formulario.value=c.form.name;
	f.submit ( ) ;
}

function ajustarNombre(hora, cita, indice, modo){
	if (modo == 'ALTA'){
		var oldName = 'cita--'+trim(hora)+'-'+indice;
		var newName = 'cita-'+trim(cita)+'-'+trim(hora)+'-'+indice;
	}
	else{
		var oldName = 'cita-'+trim(cita)+'-'+trim(hora)+'-'+indice;
		var newName = 'cita--'+trim(hora)+'-'+indice;
	}

	var vForm = 'form'+indice;
	window.frames['agenda'].document.forms[vForm][oldName].name = newName;
}

/*
function guardado(CTcodigo) {
	if (guardarCtl && guardarCtl.name) {
		var data = guardarCtl.name.split('-');
		var oldCT = data[1], hora = data[2];
		window.status = '';
		guardarCtl.name = guardarCtl.id = 'cita-' + CTcodigo + '-' + hora;
		guardarCtl = null;
		var aName = 'hora-' + oldCT + '-' + hora;
		var a = document.all ? document.all[aName] : document.getElementById(aName);
		if (a && a.name) {
			a.name = a.id = 'hora-' + CTcodigo + '-' + hora;
			a.alt = CTcodigo == "" ? "Nueva cita" : "Editar cita";
			hr = hora;
			if (hr.substring(hr.length - 2 == ':')) {
				hr += '0';
			}
			a.title = (CTcodigo == "" ? "Nueva cita a " : "Editar cita de ")
				+ "las " + hr;
			a.href = (CTcodigo == "" ? ".?hora=" + hora : ".?CTcodigo=" + CTcodigo);
		} else {
			alert("old link not found");
		}
	} else {
		alert("mod ctl not found");
	}
	var ctlg = document.all ? document.all.guardar : document.getElementById("guardar");
	ctlg.src = '';
}
*/

/*
function validar(formulario)
{
	var thisinput;
	// Validando tabla: Cita [ Cita ]
	
	// Columna: CTtexto [ varchar(255) ]
	thisinput = formulario.CTtexto;
	if (thisinput.value == "") {
		alert("Capture el texto de la cita.");
		thisinput.focus();
		return false;
	}
	// Validacion terminada
	return true;
}
*/

/*
function calcHoraFinal()
{
	tInicial = parseInt(document.Mantenimiento.iniHora.value) * 60 
		+ parseInt(document.Mantenimiento.iniMinuto.value);
	duracion = parseInt(document.Mantenimiento.durHora.value) * 60 
		+ parseInt(document.Mantenimiento.durMinuto.value);
	tFinal = tInicial + duracion;
	iFinHora   = Math.floor(tFinal / 60) % 24;
	iFinMinuto = tFinal % 60;
	
	document.Mantenimiento.finHora.value = iFinHora
	document.Mantenimiento.finMinuto.value = iFinMinuto
}
*/

/*
function calcDuracion()
{
	tFinal = parseInt(document.Mantenimiento.finHora.value) * 60 
		+ parseInt(document.Mantenimiento.finMinuto.value);
	tInicial = parseInt(document.Mantenimiento.iniHora.value) * 60 
		+ parseInt(document.Mantenimiento.iniMinuto.value);
	duracion = tFinal - tInicial;
	iDurHora   = (Math.floor(duracion / 60) + 24) % 24;
	iDurMinuto = duracion % 60;
	
	document.Mantenimiento.durHora.value = iDurHora
	document.Mantenimiento.durMinuto.value = iDurMinuto
}*/