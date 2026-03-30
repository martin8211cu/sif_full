
function o(s){
	return document.all ? document.all[s] : document.getElementById(s);
}
function valid_password(u, p, p2) {
	var div = o('div_test_msg');
	if (!document.origMsg) {
		document.origMsg = div.innerHTML;
	}
	var valida = validarPassword(u, p);
	o('img_pass_ok').style.display = !valida.errpass.length ? '' : 'none';
	o('img_pass_mal').style.display = valida.errpass.length ? '' : 'none';
	if(p != p2) valida.errpass.push("La contrase\u00f1a debe coincidir en ambas casillas.");
	
	o('img_pass2_ok').style.display = !(valida.errpass.length  || p!=p2) ? '' : 'none';
	o('img_pass2_mal').style.display = (valida.errpass.length || p!=p2) ? '' : 'none';
	
	if ( valida.errpass.length == 0)
		div.innerHTML = 'Datos aceptados:<ul><li>Contrase\u00f1a v\u00e1lida</li></ul>';
	else
		div.innerHTML = 'Su contrase\u00f1a es d\u00e9bil.  Se detectaron los siguientes errores:<ul style="color:red"><li>' + valida.errpass.join('<li>') + '</li></ul>';
}

function valida(f, lusername){
	if (f.oldpass) { // porque tambien se usa en signup3
		if (f.oldpass.value == '') {
			alert("Captura la contrase\u00f1a anterior");
			f.oldpass.focus();
			return false;
		}
	}
	if (f.newpass.value == '') {
		alert("Captura la contrase\u00f1a nueva");
		f.newpass.focus();
		return false;
	}
	if (f.newpass.value != f.newpass2.value) {
        alert("La contrase\u00f1a debe coincidir en ambas casillas.");
		f.newpass.value = "";
		f.newpass2.value = "";
		f.newpass.focus();
		return false
	}
	var valida = validarPassword(lusername, f.newpass.value);
	if (valida.errpass.length) {
		alert ('Su contrase\u00f1a es d\u00e9bil.\nSe detectaron los siguientes errores: \n - ' + valida.errpass.join('\n - '));
		f.newpass.focus();
		return false;
	}
	if (f.pregsi && f.respuesta) { // porque tambien se usa en signup3
		if (f.pregsi.checked && f.respuesta.value == '') {
			alert("Capture la respuesta a la pregunta");
			f.respuesta.focus();
			return false;
		}
	}
	return true;
}