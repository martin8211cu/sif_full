<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Untitled Document</title>
</head>

<body>
	<form method="POST" name="Userpasshidden" onsubmit='return true' action="http://10.7.7.13/apps/scripts/login/login.jsp" >
	<input type=hidden name=UTCOffset value="">
	<input type=hidden name=user value="">
	<input type=hidden name=pass value="">

	</form>
	<SCRIPT language="javascript">
<!--
function window_onload() {
calcUTCOffset();
document.Userpass.duser.focus();
}

function calcUTCOffset() {
	var d = new Date();
	document.Userpasshidden.UTCOffset.value = 0-d.getTimezoneOffset();
	}

function eventGetKey(e) {
	return document.all?event.keyCode:e.which
}

function doSubmit(e) {
	if (eventGetKey(e) == 13) {
		doLogin();
		//document.forms.Userpass.submit()
		return false;
		}
	else return true;
}

function doLogin() {
	document.forms.Userpasshidden.user.value = doEncode('user');
	document.forms.Userpasshidden.pass.value = doEncode('pass');
	if (document.all) document.all["bok"].disabled = true;
	else document.getElementById("bok").disabled = true;
	document.forms.Userpasshidden.submit();
}

function doEncode(val) {
	var thex = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F");
	var encStr = "";
	for (var i = 0 ; i < val.length ; i++) {
		var unicodeval = val.charCodeAt(i);
		encStr += thex[unicodeval >> 12] + thex[(unicodeval >> 8) & 15] + thex[(unicodeval >> 4) & 15] + thex[unicodeval & 15];
		}
	return encStr;
}

function goLang(lang) {
	document.location = "language.jsp?lang=" + lang;
}
-->
</SCRIPT>

<A href="javascript:doLogin()" id="bok">ENTRAR</A>
</body>
</html>
