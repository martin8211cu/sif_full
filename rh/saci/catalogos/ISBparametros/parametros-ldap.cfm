<style type="text/css">
	.flatinp { border:1px solid gray; width:100%;}
	div.data {overflow:hidden; white-space:nowrap; }
</style>
<table border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td>Parámetros para creación de usuarios LDAP </td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><form name="form1" action="javascript:void(0)" onsubmit="send_data(); return false;">
	<cfinclude template="parametros-ldap-data.cfm">
    </form></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><em>[1] Es importante solamente en el servidor de pruebas</em> </td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table><iframe src="about:blank" id="myframe" name="myframe" style="display:none;"></iframe>
<script type="text/javascript">
function funcAgregar() {
	var f = document.form1;
	if (!funcValidar(f.atributo, f.valor)) return false;
	window.open('parametros-apply.cfm?ldap=1&action=add'
		+ '&atributo=' + escape(f.atributo.value)
		+ '&valor=' + escape(f.valor.value)
		+ '&correo=' + escape(f.correo.value), 'myframe');
	f.btnAgregar.disabled = true;
}
function funcModificar(linea) {
	var f = document.form1;
	var atributo = f['atributo'+linea],
		valor = f['valor'+linea],
		correo = f['correo'+linea],
		btn = f['btnUpdate'+linea];
	if (!funcValidar(atributo,valor)) return false;
	window.open('parametros-apply.cfm?ldap=1&action=upd'
		+ '&linea=' + escape(linea)
		+ '&atributo=' + escape(atributo.value)
		+ '&valor=' + escape(valor.value)
		+ '&correo=' + escape(correo.value), 'myframe');
	btn.disabled = true;
	return false;
}
function funcValidar(atributo, valor){
	if (atributo.value.match(/^\s*$/)) {
		alert('Indique el atributo');
		atributo.focus();
		return 0;
	}
	if (valor.value.match(/^\s*$/)) {
		alert('Indique el valor');
		valor.focus();
		return 0;
	}
	return 1;
}
document.linea = 0;
function chow(id,vis){
	var obj = document.all?document.all[id]:document.getElementById(id);
	if (obj) obj.style.display = vis?'':'none';
}
function setLinea(n,ctl){
	if (document.linea && document.linea == n) return;
	if (document.linea) {
		chow('linea'+document.linea+'a',true);
		chow('linea'+document.linea+'b',false);
	}
	document.linea = n;
	chow('linea'+document.linea+'a',false);
	chow('linea'+document.linea+'b',true);
	if(ctl && ctl == 1) document.form1['atributo'	+document.linea].focus();
	if(ctl && ctl == 2) document.form1['valor'		+document.linea].focus();
	if(ctl && ctl == 3) document.form1['correo'	+document.linea].focus();
	document.form1.btnAgregar.style.display = n?'none':'';
}
function send_data(){
	if (document.linea){
		funcModificar(document.linea);
		setLinea(0);
	} else {
		funcAgregar();
	}
	return false;// evitar  submit
}
function listo(){
	document.form1.btnAgregar.disabled = false;
	document.form1.atributo.focus();
}
</script>