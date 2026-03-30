<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="right" nowrap><strong>Cuenta Contable:</strong>&nbsp;</td>
		<td nowrap>
			<input 	tabindex="2" type="textbox" name="CGM1IM"    ID="CGM1IM"  size="4" maxlength="4"  value=""
	 			onKeyUp = "javascript: doKey(event)"  
				onchange  = "javascript: ValidaCuenta(this.value)"> 
	
			<input 	tabindex="2" type="textbox" name="CG13ID_1"  ID="CG13ID_1"  size="1" maxlength="4"	style="visibility:hidden;" >
		<!--- 			onKeyUp = "doKey(event,document.form1.CGM1IM.value,1)"  
					onBlur="javascript: TraeDescripcion(document.form1.CG13ID_1.value,document.form1.CGM1IM.value,1)"> --->
			
			<input 	tabindex="2" type="textbox" name="CG13ID_2"  ID="CG13ID_2"  size="1" maxlength="4"	style="visibility:hidden;" >
		<!--- 			onKeyUp = "doKey(event,document.form1.CGM1IM.value,2)" 
					onBlur="javascript: TraeDescripcion(document.form1.CG13ID_2.value,document.form1.CGM1IM.value,2)">
		 --->	
			<input 	tabindex="2" type="textbox" name="CG13ID_3"  ID="CG13ID_3"  size="1" maxlength="4"	style="visibility:hidden;" >
		<!--- 			onKeyUp = "doKey(event,document.form1.CGM1IM.value,3)" 
					onBlur="javascript: TraeDescripcion(document.form1.CG13ID_3.value,document.form1.CGM1IM.value,3)">
		 --->	
			<input 	tabindex="2" type="textbox" name="CG13ID_4"  ID="CG13ID_4"  size="1" maxlength="4"	style="visibility:hidden;" >
		<!--- 			onKeyUp = "doKey(event,document.form1.CGM1IM.value,4)" 
					onBlur="javascript: TraeDescripcion(document.form1.CG13ID_4.value,document.form1.CGM1IM.value,4)">
		 --->	
			<input 	tabindex="2" type="textbox" name="CG13ID_5"  ID="CG13ID_5"  size="1" maxlength="4"	style="visibility:hidden;">
		<!--- 			onKeyUp = "doKey(event,document.form1.CGM1IM.value,5)" 
					onBlur="javascript: TraeDescripcion(document.form1.CG13ID_5.value,document.form1.CGM1IM.value,5)">
		 --->	
			<input 	tabindex="2" type="textbox" name="CG13ID_6"  ID="CG13ID_6"  size="1" maxlength="4"	style="visibility:hidden;" >
		<!--- 			onKeyUp = "doKey(event,document.form1.CGM1IM.value,6)"  
					onBlur="javascript: TraeDescripcion(document.form1.CG13ID_6.value,document.form1.CGM1IM.value,6)">
		 --->	
			<input 	tabindex="2" type="textbox" name="CG13ID_7"  ID="CG13ID_7"  size="1" maxlength="4"	style="visibility:hidden;" >
		<!--- 			onKeyUp = "doKey(event,document.form1.CGM1IM.value,7)" 
					onBlur="javascript: TraeDescripcion(document.form1.CG13ID_7.value,document.form1.CGM1IM.value,7)">
		 --->	
			<input 	tabindex="2" type="textbox" name="CG13ID_8"  ID="CG13ID_8"  size="1" maxlength="4"	style="visibility:hidden;"> 
		<!--- 			onKeyUp = "doKey(event,document.form1.CGM1IM.value,8)" 
					onBlur="javascript: TraeDescripcion(document.form1.CG13ID_8.value,document.form1.CGM1IM.value,8)">
		 --->	
			<input 	tabindex="2" type="textbox" name="CG13ID_9"  ID="CG13ID_9"  size="1" maxlength="4"	style="visibility:hidden;" >
		<!--- 			onKeyUp = "doKey(event,document.form1.CGM1IM.value,9)"  
					onBlur="javascript: TraeDescripcion(document.form1.CG13ID_9.value,document.form1.CGM1IM.value,9)">
		 --->	
			<input 	tabindex="2" type="textbox" name="CG13ID_10" ID="CG13ID_10"  size="1" maxlength="4"	style="visibility:hidden;" >
		<!--- 			onKeyUp = "doKey(event,document.form1.CGM1IM.value,10)" 
				onBlur="javascript: TraeDescripcion(document.form1.CG13ID_10.value,document.form1.CGM1IM.value,10)">
		 --->
			<input type="hidden" style="visibility:hidden" name="NIVELES" value="0">
			<INPUT type="hidden" style="visibility:hidden" name="CGM1CD" value="">

       <iframe id="FRAMECJNEGRA" name="FRAMECJNEGRA" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" style="visibility:hidden"></iframe>
		</td>
	</tr>
</table>

<script language="javascript" type="text/javascript">
	var MAXIMO_CELDAS = 10;
	var TECLA_CONLIS = 113;

	function PintaCajas(mayor,detalle) {
		var CGM1IM = mayor;
		var CUENTA = detalle;
		var PARAMS = "?CGM1IM="+CGM1IM+"&CUENTA="+CUENTA
		var frame  = document.getElementById("FRAMECJNEGRA");
		frame.src 	= "/cfmx/sif/ConsContV5/Consultas/CajaNegra/PintaCajas.cfm" + PARAMS;
	}

	function ValidaCuenta(mayor) {
		var CGM1IM = mayor;
		var PARAMS = "?CGM1IM="+CGM1IM
		var frame  = document.getElementById("FRAMECJNEGRA");
		frame.src 	= "/cfmx/sif/ConsContV5/Consultas/CajaNegra/ValidaCuenta.cfm" + PARAMS;
	}

	function Key(evento) {
		var version4 = window.Event ? true : false;
		if (version4) { // Navigator 4.0x 
			var whichCode = evento.which	
		} else {// Internet Explorer 4.0x
			if (evento.type == "keyup") { // the user entered a character
				var whichCode = evento.keyCode
			} else {
				var whichCode = evento.button;
			}
		}
		return (whichCode)
	}

	function doKey(EVENTO) { 
		var k=Key(EVENTO) 
		if (k==TECLA_CONLIS) {
			popUpWindow("/cfmx/sif/ConsContV5/Consultas/CajaNegra/ConlisCuentaMayor.cfm",250,200,650,400);
		}
	}
	
	function popUpWindow(URLStr, left, top, width, height) {
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=yes,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

</script>
