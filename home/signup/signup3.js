
function validarSignup(f){
	var error="";
    if (f.logintext.value == "")
    {
       rror= error+"Digite el nombre solicitado para su usuario. \n";
        f.logintext.select();
        f.logintext.focus();
    }
    if (f.logintext.value.indexOf(" ") != -1)
    {
        rror= error+"El usuario no puede contener espacios. \n";
        f.logintext.select();
        f.logintext.focus();
    }

    if (f.oldpass.value == "")
    {
        error= error+"Digite la contrase\u00f1a temporal. \n";
        f.oldpass.focus();
    }
    if (f.newpass.value == "")
    {
         error= error+"Seleccione la nueva contrase\u00f1a.\n";
        f.newpass.focus();
    }
    if (f.newpass2.value == "")
    {
         error= error+"Confirme la nueva contrase\u00f1a.\n";
        f.newpass2.focus();
    }
    if (f.newpass.value != f.newpass2.value)
    {
         error= error+"La contrase\u00f1a debe coincidir en ambos valores. \n";
        f.newpass.focus();
        f.newpass.value = "";
        f.newpass2.value = "";
    }
    if (f.respuesta.value == "")
    {
         error= error+"Debe especificar la respuesta de identificaci\u00f3n personal.";
        f.respuesta.focus();
    }

	if(error!=""){
		alert(error);
		return false;	
	}

	if (f.recordar.checked) {
        var expdate = new Date ();
        expdate.setTime (expdate.getTime() + (24 * 60 * 60 * 1000 * 31));
        SetCookie("sdcuser", (f.logintext.value + ":" + f.aliaslogin.value), expdate)
    } else {
        SetCookie("sdcuser", ":")
    }
    return true;
}