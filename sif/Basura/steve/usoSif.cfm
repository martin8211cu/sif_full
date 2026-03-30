<script language="javascript1.2" type="text/javascript">	
	function fnExiste(i) {
		var steve = window.document.form1.campo;
		var steve2 = window.document.form1.campo2;
		var chequeado = window.document.form1.ck;
		chequeado.checked = true;
		steve.value = 'Hello World';		
		res = confirm('pregunta');
	}
</script>

<form name="form1" action="" method="post">
	<input name="campo" type="text">
	<input name="campo2" type="text"> <br>
	<input name="ck" type="checkbox" title="11" value="sfds"> 
	<br>
	<input name="btnAceptar" type="button" value="Aceptar" 
		onClick="javascript:fnExiste(10)">
</form>
