<style type="text/css">
	.Estilo1 {
		font-family: Geneva, Arial, Helvetica, sans-serif;
		font-size: 16px;
		font-style: oblique;
		font-weight: 200;
		color: #0066FF;
		text-decoration: underline;
		background-color: #999999;
		border: medium dotted;
	}
	.Estilo2 {
		font-family: Geneva, Arial, Helvetica, sans-serif;
		font-size: 16px;
		font-style: oblique;
		font-weight: 200;
		color: #0066FF;
		text-decoration: underline;
		background-color: #999999;
	}
</style>

<script language="javascript1.2" type="text/javascript">
	function fnDemeSigTabIndex(e,t) {
		if (e.keyCode==13) {
			//Copia el arreglo de objetos.
			var f = new Array();
			var y = new Array();
			var ele = eval(document.fForm.elements);
			for (i=0;i<=ele.length-1;i++) {
				f[i]=ele[i].tabIndex;
			}
			//Ordena el arreglo en base al tabIndex.
			for (i=0;i<=f.length-1;i++) {
				var menor = 999;
				for (j=0;j<=f.length-1;j++) {
					if (f[j] < menor) {
						menor = f[j];
						m=j;
					}
				}
				f[m]=999;
				y[i]=menor;
			}
			//Busca el siguiente elemento.
			for (i=0;i<=(y.length-1);i++) {
				if (y[i]==t.tabIndex) {
					if (i==(y.length-1)) {
						ni=y[0];
					} else {
						ni=y[i+1];
					}					
				}
			}
			//Pasa al siguiente elemento.
			for (i=0;i<=(ele.length-1);i++) {
				if (ele[i].tabIndex==ni) {
					ele[i].focus();
				}
			}
		}
	}
</script>

<form name="fForm" class="Estilo1">
	Nombre:
		<input name="txtNombre" type="text" value="Steve" class="Estilo2" tabindex="1"
		onFocus="select()" 
		onKeyPress="javascript:fnDemeSigTabIndex(event,this)">
	Apellidos: 
		<input name="txtApellido" type="text" value="Vado Rodriguez" class="Estilo2" tabindex="2"
		onFocus="select()"
		onKeyPress="javascript:fnDemeSigTabIndex(event,this)">
	Direcci&oacute;n: 
		<input name="txtDireccion" type="text" value="Alajuela, Costa Rica" class="Estilo2" tabindex="3"
		onFocus="select()"
		onKeyPress="javascript:fnDemeSigTabIndex(event,this)">
</form>
