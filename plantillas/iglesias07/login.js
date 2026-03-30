function getCookieVal (offset) {
    var endstr = document.cookie.indexOf (";", offset);
    if (endstr == -1)
        endstr = document.cookie.length;
    return unescape(document.cookie.substring(offset, endstr));
}

function GetCookie (name) {
    var arg = name + "=";
    var alen = arg.length;
    var clen = document.cookie.length;
    var i = 0;
    while (i < clen) {
        var j = i + alen;
        if (document.cookie.substring(i, j) == arg)
            return getCookieVal (j);
        i = document.cookie.indexOf(" ", i) + 1;
        if (i == 0) break; 
    }
    return null;
}

function SetCookie (name, value) {
    var argv = SetCookie.arguments;
    var argc = SetCookie.arguments.length;
    var expires = (argc > 2) ? argv[2] : null;
    var path = (argc > 3) ? argv[3] : null;
    var domain = (argc > 4) ? argv[4] : null;
    var secure = (argc > 5) ? argv[5] : false;
    document.cookie = name + "=" + escape (value) +
        ((expires == null) ? "" : ("; expires=" + expires.toGMTString())) +
        ((path == null) ? "" : ("; path=" + path)) +
        ((domain == null) ? "" : ("; domain=" + domain)) +
        ((secure == true) ? "; secure" : "");
}

function llenarLogin(f) {
    var user = GetCookie("sdcuser")
	f.j_username.focus();
    if (user==null) return
    var uspass = user.split(":"); // compatibilidad con versiones anteriores
	f.j_username.select();
    if (uspass==null) return;
    if (uspass.length > 0) {
        f.j_username.value = uspass[0];
        if (uspass[0].length != "") {
            f.recordar.checked = true;
			f.j_password.focus();
        }
    }
}

function validarLogin(f) {
    // recuerda la contraseña por un mes
    
    if (f.j_username.value == "")
    {
        alert("Digite el usuario");
        f.j_username.focus();
        return false;
    }
    if (f.j_username.value.indexOf(" ") != -1)
    {
        alert("El usuario no puede contener espacios");
        f.j_username.select();
        f.j_username.focus();
        return false;
    }
    if (f.j_password.value == "")
    {
        alert("Digite su contraseña.");
        f.j_password.focus();
        return false;
    }
    
    if (f.recordar.checked) {
        var expdate = new Date ();
        expdate.setTime (expdate.getTime() + (24 * 60 * 60 * 1000 * 31));
	var the_cookie_path = document.location.pathname.match(/.*\//);
        SetCookie("sdcuser", ":");
        SetCookie("sdcuser", (f.j_username.value), expdate, the_cookie_path);
    } else {
        SetCookie("sdcuser", ":");
    }
    return true;
}

function validarNuevoUsuario() {
    // recuerda la contraseña por un mes
    
    if (document.login.nusu.value == "")
    {
        alert("Digite el nombre solicitado para su usuario");
        document.login.nusu.focus();
        return false;
    }
    if (document.login.nusu.value.indexOf(" ") != -1)
    {
        alert("El usuario no puede contener espacios");
        document.login.nusu.select();
        document.login.nusu.focus();
        return false;
    }
    if (document.login.npwd.value == "")
    {
        alert("Seleccione la nueva contraseña.");
        document.login.npwd.focus();
        return false;
    }
    if (document.login.npwd2.value == "")
    {
        alert("Confirme la nueva contraseña.");
        document.login.npwd2.focus();
        return false;
    }
    if (document.login.npwd.value != document.login.npwd2.value)
    {
        alert("La contraseña debe coincidir en ambos valores.");
        document.login.npwd.focus();
        document.login.npwd.value = "";
        document.login.npwd2.value = "";
        return false;
    }
    
    if (document.login.recordar.checked) {
        var expdate = new Date ();
        expdate.setTime (expdate.getTime() + (24 * 60 * 60 * 1000 * 31));
        SetCookie("sdcuser", (document.login.nusu.value + ":" + document.login.npwd.value), expdate)
    } else {
        SetCookie("sdcuser", ":")
    }
    return true;
}

function UsulistChange(c)
{
    document.login.nusu.value = document.login.usulist.value;
    document.login.usuck[0].checked = true;
}

function UsutextChange(c)
{
    document.login.usuck[1].checked = true;
    document.login.usulist.value = "";
}
