function validar(f)
{
	if (f.logintext.value == '') {
		alert("Escriba el nombre de usuario que desea utilizar");
		f.logintext.focus();
		f.select();
		return false;
	}
	return true;
}