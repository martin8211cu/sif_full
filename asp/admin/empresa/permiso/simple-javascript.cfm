<cfinvoke component="home.Componentes.ValidarPassword" method="javascript" data="#dataPoliticas#"/>

<cfoutput>
<script type="text/javascript">
function $(x){return document.all?document.all[x]:document.getElementById(x);}

function om1(td){
	if (document.dandole) return;
	td.className = 'listaNonSel';
	$(td.id.match(/r\d+/)).className = 'listaParSel';
	$(td.id.match(/c\d+/)).className = 'listaParSel';
}
function om2(td){
	td.className = 'listaNon';
	$(td.id.match(/r\d+/)).className = 'listaPar';
	$(td.id.match(/c\d+/)).className = 'listaPar';
}
document.dandole = false;
function oc(td,u,s,r){
	if (document.dandole) {
		// otro está dándole, espere por favor
		return;
	}
	var myimg = $('img_'+td.id), st = 0;
	if (myimg.src.match(/simple-hourglass.gif$/)) {
		// ya está dándole, espere por favor
		return;
	}
	if (!myimg.src.match(/simple-check.gif$/)) {
		st = 1;
	}
	document.dandole = true;
	om2(td);
	myimg.src = '/cfmx/asp/admin/empresa/permiso/simple-hourglass.gif';
	window.open('simple-go.cfm?action=pset&i='+escape(td.id)+'&u='+escape(u)+'&s='+escape(s)+'&r='+escape(r)+'&st='+escape(st), 'myframe');
}
function resp(tdid,st){
	$('img_'+tdid).src = '/cfmx/asp/admin/empresa/permiso/' + (st ? 'simple-check.gif' : 'blank.gif');
	//window.open('about:blank', 'myframe');
	document.dandole = false;
}
function usubmit(f){
	var msgs  = validar_form(f);
	if (msgs.length) {
		alert('Por favor valide lo siguiente:\n - ' + msgs.join('\n - '));
		return false;
	} else {
		return true;
	}
}
function bsubmit(f,msg){
	if (f.buscar.value != msg) {
		window.open('simple.cfm?reload&buscar='+escape(f.buscar.value), 'myframe');
	}
	return false;
}
function ufocus(u,msg){
	if(u.value == msg){
		u.value = '';
		u.style.color = '';
	} else {
		u.select();
	}
}
function ublur(u,msg){
	if(u.value == ''){
		u.value = msg;
		u.style.color = 'gray';
	}
}
function du(ul,uc){
	if(confirm('¿Desea eliminar el usuario ' + ul + '?')) {
		window.open('simple-go.cfm?action=udel&uc='+escape(uc), 'myframe');
	}
}

<!--- para Formulario de Usuarios --->
	
	function loginquery(f){
		<!--- La unicidad del login solamente se captura en alta --->
		var datos = f.username.value + '/' + f.password.value;
		if(document.datosloginquery && document.datosloginquery == datos) return;
		document.datosloginquery = datos;
		if (f.usucodigo.value == '' && f.username.value != ''){
			$('myframe').src = 'simple-go.cfm?action=loginok&username=' + escape(f.username.value) 
				+ '&password=' + escape(f.password.value);
		}
	}
	function validar_form(f) {
		var errores = new Array();
		var valida = validarPassword(f.username.value, f.password.value);
		
		if(f.nombre.value.length == 0)
			errores.push('Especifique el nombre del usuario');
		if(f.apellido1.value.length == 0)
			errores.push('Especifique el apellido del usuario');
		if(f.username.value.length == 0 && f.email1.value.length == 0)
			errores.push('Especifique el usuario o el email');
		if(f.usucodigo.value.length && f.username.value.length && !f.password.value.length)
			errores.push('Si cambia el usuario, debe cambiar la contrase\u00f1a');
		
		if (f.username.value.length == 0) valida.erruser = new Array();
		if (f.password.value.length == 0) valida.errpass = new Array();
		if(f.password.value != f.password2.value) {
			if (f.password2.value.length == 0)
				valida.errpass.push("Por favor confirme la contrase\u00f1a.");
			else
				valida.errpass.push("La contrase\u00f1a debe coincidir en ambas casillas.");
		}
		errores = errores.concat(valida.erruser).concat(valida.errpass);
		
		$('img_user_ok').style.display = !valida.erruser.length ? '' : 'none';
		$('img_user_mal').style.display = valida.erruser.length ? '' : 'none';

		$('img_pass_ok').style.display = !valida.errpass.length ? '' : 'none';
		$('img_pass_mal').style.display = valida.errpass.length ? '' : 'none';
		$('img_pass2_ok').style.display = !(valida.errpass.length) ? '' : 'none';
		$('img_pass2_mal').style.display = (valida.errpass.length) ? '' : 'none';
		return errores;
	}
	function valid_password(f) {
		var div = $('div_test_msg');
		if (!document.origMsg) {
			document.origMsg = div.innerHTML;
		}
		var errores = validar_form(f);
		if ( errores.length == 0 )
			div.innerHTML = 'Datos aceptados:<ul><li>Usuario y contrase\u00f1a v\u00e1lidos</li></ul>';
		else
			div.innerHTML = 'Se detectaron los siguientes errores:<ul style="color:red"><li>' + errores.join('<li>') + '</li></ul>';
	}	
	function hideUser(){
		$('divuserform').style.display = 'none';
		document.combos.nuevoUsuario.style.visibility = 'visible';
	}
	function showUser(){
		document.frmUsuarios.usucodigo.value='';
		document.frmUsuarios.username.value='';
		document.frmUsuarios.nombre.value='';
		document.frmUsuarios.password.value='';
		document.frmUsuarios.password2.value='';
		document.frmUsuarios.apellido1.value='';
		//document.frmUsuarios.apellido2='';
		document.frmUsuarios.email1.value='';
		$('divuserform').style.display = 'block';
		document.combos.nuevoUsuario.style.visibility = 'hidden';
		document.frmUsuarios.nombre.focus();
	}
	function editUser(u){
		$('myframe').src = 'simple.cfm?loaduser&u=' + u;
		return true;
	}
	function loadUser(usucodigo,login,nombre,ap1,ap2,email){
		document.frmUsuarios.usucodigo.value=usucodigo;
		document.frmUsuarios.username.value=login;
		document.frmUsuarios.nombre.value=nombre;
		document.frmUsuarios.password.value='';
		document.frmUsuarios.password2.value='';
		document.frmUsuarios.apellido1.value=ap1;
		//document.frmUsuarios.apellido2=ap2;
		document.frmUsuarios.email1.value=email;
		$('divuserform').style.display = 'block';
	}
</script>
</cfoutput>
<iframe id="myframe" name="myframe" src="about:blank" width="660" height="160" frameborder="0" 
style="display:none;border-style:none"></iframe>
