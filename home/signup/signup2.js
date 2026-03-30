function validar(f)
{
	if (f.logintext.value == '') {
		alert("Escriba el nombre de usuario que desea utilizar");
		f.logintext.focus();
		f.logintext.select();
		return false;
	}
	if (f.logintext.value.indexOf(" ") != -1)
    {
        alert("El usuario no puede contener espacios");
        f.logintext.select();
        f.logintext.focus();
        return false;
    }
    return true;
}