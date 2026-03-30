<td><strong>Cuenta:</strong></td>
<td colspan="4">
	<input 	tabindex="2" type="textbox" name="CGM1IMC"    ID="CGM1IMC"  size="4" maxlength="4"  disabled VALUE="<cfif mododet neq "ALTA"><cfoutput>#TraeSqlDet.CGM1IM#</cfoutput></cfif>">
	
	<input 	tabindex="2" type="textbox" name="CG13ID_1"  ID="CG13ID_1"  size="1" maxlength="4"	style="visibility:hidden;" 
			onKeyUp = "doKey(event,document.form1.CGM1IM.value,1)"  
			onBlur="javascript: TraeDescripcion(document.form1.CG13ID_1.value,document.form1.CGM1IM.value,1)">
	
	<input 	tabindex="2" type="textbox" name="CG13ID_2"  ID="CG13ID_2"  size="1" maxlength="4"	style="visibility:hidden;" 
			onKeyUp = "doKey(event,document.form1.CGM1IM.value,2)" 
			onBlur="javascript: TraeDescripcion(document.form1.CG13ID_2.value,document.form1.CGM1IM.value,2)">
	
	<input 	tabindex="2" type="textbox" name="CG13ID_3"  ID="CG13ID_3"  size="1" maxlength="4"	style="visibility:hidden;" 
			onKeyUp = "doKey(event,document.form1.CGM1IM.value,3)" 
			onBlur="javascript: TraeDescripcion(document.form1.CG13ID_3.value,document.form1.CGM1IM.value,3)">
	
	<input 	tabindex="2" type="textbox" name="CG13ID_4"  ID="CG13ID_4"  size="1" maxlength="4"	style="visibility:hidden;" 
			onKeyUp = "doKey(event,document.form1.CGM1IM.value,4)" 
			onBlur="javascript: TraeDescripcion(document.form1.CG13ID_4.value,document.form1.CGM1IM.value,4)">
	
	<input 	tabindex="2" type="textbox" name="CG13ID_5"  ID="CG13ID_5"  size="1" maxlength="4"	style="visibility:hidden;" 
			onKeyUp = "doKey(event,document.form1.CGM1IM.value,5)" 
			onBlur="javascript: TraeDescripcion(document.form1.CG13ID_5.value,document.form1.CGM1IM.value,5)">
	
	<input 	tabindex="2" type="textbox" name="CG13ID_6"  ID="CG13ID_6"  size="1" maxlength="4"	style="visibility:hidden;" 
			onKeyUp = "doKey(event,document.form1.CGM1IM.value,6)"  
			onBlur="javascript: TraeDescripcion(document.form1.CG13ID_6.value,document.form1.CGM1IM.value,6)">
	
	<input 	tabindex="2" type="textbox" name="CG13ID_7"  ID="CG13ID_7"  size="1" maxlength="4"	style="visibility:hidden;" 
			onKeyUp = "doKey(event,document.form1.CGM1IM.value,7)" 
			onBlur="javascript: TraeDescripcion(document.form1.CG13ID_7.value,document.form1.CGM1IM.value,7)">
	
	<input 	tabindex="2" type="textbox" name="CG13ID_8"  ID="CG13ID_8"  size="1" maxlength="4"	style="visibility:hidden;" 
			onKeyUp = "doKey(event,document.form1.CGM1IM.value,8)" 
			onBlur="javascript: TraeDescripcion(document.form1.CG13ID_8.value,document.form1.CGM1IM.value,8)">
	
	<input 	tabindex="2" type="textbox" name="CG13ID_9"  ID="CG13ID_9"  size="1" maxlength="4"	style="visibility:hidden;" 
			onKeyUp = "doKey(event,document.form1.CGM1IM.value,9)"  
			onBlur="javascript: TraeDescripcion(document.form1.CG13ID_9.value,document.form1.CGM1IM.value,9)">
	
	<input 	tabindex="2" type="textbox" name="CG13ID_10" ID="CG13ID_10"  size="1" maxlength="4"	style="visibility:hidden;" 
			onKeyUp = "doKey(event,document.form1.CGM1IM.value,10)" 
		onBlur="javascript: TraeDescripcion(document.form1.CG13ID_10.value,document.form1.CGM1IM.value,10)">
<INPUT TYPE="HIDDEN" style="visibility:hidden" NAME="NIVELES" VALUE="0">

<iframe id="FRAMECJNEGRA" name="FRAMECJNEGRA" marginheight="0" marginwidth="0" frameborder="100" height="100" width="100" src="" style="visibility:hiddenl"></iframe>
</td>

<script language="JavaScript">
document.cajaNegra=true;
var MAXIMO_CELDAS = 10;
var TECLA_CONLIS=113;
llenacaja();
function llenacaja() {
	document.form1.CGM1IMC.value = document.form1.CGM1IM.value
	var CUENTA		= document.form1.CGM1CD.value;
	var CGM1IMC		= document.form1.CGM1IMC.value;
	var PR1COD		= document.form1.PR1COD.value;
	params = "?CUENTA="+CUENTA+"&CGM1IMC="+CGM1IMC+"&PR1COD="+PR1COD;
	var frame = document.getElementById("FRAMECJNEGRA");

	frame.src = "/cfmx/sif/fondos/operacion/cajanegra/Pintacajas.cfm"+params;
}
<cfif mododet eq "CAMBIO">
	function llenacajaCambio() {
		var CUENTA2  = "<cfoutput>#TraeSqlDet.CGM1CD#</cfoutput>";
		var CGM1IMC	 = "<cfoutput>#TraeSqlDet.CGM1IM#</cfoutput>";
		var CGM1ID	 = "<cfoutput>#TraeSqlDet.CGM1ID#</cfoutput>";
		var CUENTA   = document.form1.CGM1CD.value;
		params = "?CUENTA="+CUENTA+"&CUENTA2="+CUENTA2+"&CGM1IMC="+CGM1IMC+"&CGM1ID="+CGM1ID;
		var frame = document.getElementById("FRAMECJNEGRA");
		frame.src = "/cfmx/sif/fondos/operacion/cajanegra/PintacajasCambio.cfm"+params;
	}

	function DesCuenta(CGM1ID) {
			params = "?CGM1ID="+CGM1ID;
			var frame = document.getElementById("FRAMECJNEGRA");
			frame.src = "/cfmx/sif/fondos/operacion/cajanegra/TraeDes.cfm"+params;
	}
</cfif>	

function USACOMBO(aVALOR){
	var CARACTER=""
	var PUNTO="."
	var VALOR = aVALOR.toString();
	
	for (var i=0; i<VALOR.length; i++)
		{	
		CARACTER =VALOR.substring(i,i+1);
		if (CARACTER =="@") {
			return true;
			} 
		}
	return false;
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

function doKey(EVENTO,CGM1IM,NIVEL){ 
	var StringNivel="";
	var k=Key(EVENTO) 
	if (k==TECLA_CONLIS) {
		StringNivel = StrNivel(NIVEL);
		eval("document.form1.CG13ID_"+NIVEL+".value=''")
		var params ="";
		params = "?CGM1IM="+CGM1IM+"&NIVEL="+NIVEL+"&StringNivel="+StringNivel;
		popUpWindow("/cfmx/sif/fondos/operacion/cajanegra/ConlisCJNegra.cfm"+params,250,200,650,400);
	}
}

function popUpWindow(URLStr, left, top, width, height){
	if(popUpWin){
		if(!popUpWin.closed) popUpWin.close();
	}
	popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=yes,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}

function validaceldas(nivel) {
	var llenas = true;
	var MAXIMO = document.form1.NIVELES.value;
	for (var CELDA=1; CELDA<MAXIMO; CELDA++){
		if(eval("document.form1.CG13ID_"+CELDA+".value")=="") {
			llenas = false;
		}	
	}
	if (llenas){
		var StringNivel = StrNivel(MAXIMO);
		var CGM1IM		= document.form1.CGM1IM.value;
		var CGE5COD		= document.form1.CGE5COD.value;
		params = "?CGM1IM="+CGM1IM+"&CGE5COD="+CGE5COD+"&StringNivel="+StringNivel+"&nivel="+nivel;

		var frame = document.getElementById("FRAMECJNEGRA");
		frame.src = "/cfmx/sif/fondos/operacion/cajanegra/CreaCuenta.cfm"+params;
	}
}

function validacampos() {
	if (!objform1.CGM1CD.required) return;
	var llenas = true;
	var MAXIMO = document.form1.NIVELES.value;

	for (var CELDA=1; CELDA<MAXIMO; CELDA++){
		if(eval("document.form1.CG13ID_"+CELDA+".value")=="") {
			llenas = false;
		}	
	}
	if (!llenas){
		document.form1.error.value = "Se presentaron los siguientes errores:\n- Todos los campos de Cuenta son requeridos";
		document.form1.errorFlag.value = '3';
		return;
	}	

	var StringNivel = StrNivel(MAXIMO);
	var CGM1IM		= document.form1.CGM1IM.value;
	var CGE5COD		= document.form1.CGE5COD.value;
	params = "?CGM1IM="+CGM1IM+"&CGE5COD="+CGE5COD+"&StringNivel="+StringNivel+"&nivel="+MAXIMO;
	var frame = document.getElementById("FRAMECJNEGRA");
	frame.src = "/cfmx/sif/fondos/operacion/cajanegra/CreaCuenta.cfm"+params;
}


function StrNivel(NIVEL) {
	var StringNivel = "";
	for (var CELDA=1; CELDA<NIVEL; CELDA++){
		StringNivel = StringNivel + eval("document.form1.CG13ID_"+CELDA+".value")
	}
	return StringNivel;
}

function TraeDescripcion(DATO,CGM1IM,NIVEL) {
	if (DATO != "") {
		var StringNivel="";
		StringNivel = StrNivel(NIVEL);
		StringNivel = StrNivel(NIVEL);
		var frame = document.getElementById("FRAMECJNEGRA");
		frame.src = "/cfmx/sif/fondos/operacion/cajanegra/CJNegraquery.cfm?DATO="+DATO+"&CGM1IM="+CGM1IM+"&NIVEL="+NIVEL+"&StringNivel="+StringNivel;
	}
	else{
		eval("document.form1.CG13ID_"+NIVEL+".value=''")
		document.form1.DESCUENTA.value = ""
	}
}
</script>	



