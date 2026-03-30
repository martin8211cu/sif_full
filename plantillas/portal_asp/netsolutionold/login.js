// cookie es usuario:empresa

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
    var user = GetCookie("sdcuser");
	if (f['j_empresa']) {
		f.j_empresa.focus();
	} else {
		f.j_username.focus();
	}
    if (user==null) return
    var uspass = user.split(":"); // usuario:empresa
	f.j_username.select();
    if (uspass==null) return;
    if (uspass.length > 0) {
        f.j_username.value = uspass[0];
		if (f['j_empresa']) {
	        f.j_empresa.value = uspass[1];
		}
        if (uspass[0].length != "") {
            f.recordar.checked = true;
			f.j_password.focus();
		}
    }
}

function validarLogin(f) {
    // recuerda la contrasena por un mes
    
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
        alert("Digite su contrase\u00f1a.");
        f.j_password.focus();
        return false;
    }
    
    if (f.recordar.checked) {
        var expdate = new Date ();
        expdate.setTime (expdate.getTime() + (24 * 60 * 60 * 1000 * 31));
	var the_cookie_path = document.location.pathname.match(/.*\//);
        SetCookie("sdcuser", ":");
        SetCookie("sdcuser", (f.j_username.value + ":" + (f['j_empresa'] ? f.j_empresa.value:"")), expdate, the_cookie_path);
    } else {
        SetCookie("sdcuser", ":");
    }
    return true;
}
