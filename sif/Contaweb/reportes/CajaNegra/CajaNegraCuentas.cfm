<!--- <table width="100%" border="0"  id="tblcajanegra">
	<tr> --->
		<td width="17%" align="left" nowrap><strong>Cuenta Contable:</strong>&nbsp;</td>
		<td width="83%"  colspan="3" nowrap>
			<input 	tabindex="1" type="textbox" name="CGM1IM"    ID="CGM1IM"  size="4" maxlength="4"  value=""
				onKeyUp = "javascript: doKey(event)"  
				onfocus = "javascript: limpiaframe()"
				onchange = "javascript: ValidaCuenta(this.value)"> 
		
			<input 	tabindex="1" type="textbox" name="CG13ID_1"  ID="CG13ID_1"  size="1" maxlength="4"	style="visibility:hidden;" onfocus= "javascript: limpiaframe()"  onKeyUp = "javascript: escuenta(this,event,1)"  >
			<input 	tabindex="1" type="textbox" name="CG13ID_2"  ID="CG13ID_2"  size="1" maxlength="4"	style="visibility:hidden;" onfocus= "javascript: limpiaframe()"  onKeyUp = "javascript: escuenta(this,event,2)"  >
			<input 	tabindex="1" type="textbox" name="CG13ID_3"  ID="CG13ID_3"  size="1" maxlength="4"	style="visibility:hidden;" onfocus= "javascript: limpiaframe()"  onKeyUp = "javascript: escuenta(this,event,3)"  >
			<input 	tabindex="1" type="textbox" name="CG13ID_4"  ID="CG13ID_4"  size="1" maxlength="4"	style="visibility:hidden;" onfocus= "javascript: limpiaframe()"  onKeyUp = "javascript: escuenta(this,event,4)"  >
			<input 	tabindex="1" type="textbox" name="CG13ID_5"  ID="CG13ID_5"  size="1" maxlength="4"	style="visibility:hidden;" onfocus= "javascript: limpiaframe()"  onKeyUp = "javascript: escuenta(this,event,5)"  >
			<input 	tabindex="1" type="textbox" name="CG13ID_6"  ID="CG13ID_6"  size="1" maxlength="4"	style="visibility:hidden;" onfocus= "javascript: limpiaframe()"  onKeyUp = "javascript: escuenta(this,event,6)"  >
			<input 	tabindex="1" type="textbox" name="CG13ID_7"  ID="CG13ID_7"  size="1" maxlength="4"	style="visibility:hidden;" onfocus= "javascript: limpiaframe()"  onKeyUp = "javascript: escuenta(this,event,7)"  >
			<input 	tabindex="1" type="textbox" name="CG13ID_8"  ID="CG13ID_8"  size="1" maxlength="4"	style="visibility:hidden;" onfocus= "javascript: limpiaframe()"  onKeyUp = "javascript: escuenta(this,event,8)"  > 
			<input 	tabindex="1" type="textbox" name="CG13ID_9"  ID="CG13ID_9"  size="1" maxlength="4"	style="visibility:hidden;" onfocus= "javascript: limpiaframe()"  onKeyUp = "javascript: escuenta(this,event,9)"  >
			<input 	tabindex="1" type="textbox" name="CG13ID_10" ID="CG13ID_10"  size="1" maxlength="4"	style="visibility:hidden;" onfocus= "javascript: limpiaframe()"  onKeyUp = "javascript: escuenta(this,event,10)"  >
			<input type="hidden" style="visibility:hidden" name="NIVELES" value="0">
			<INPUT type="hidden" style="visibility:hidden" name="CGM1CD" value="">
			<INPUT type="hidden" style="visibility:hidden" name="PRIMERNIVEL" value="">
			<INPUT type="hidden" style="visibility:hidden" name="VALORPRIMERNIVEL" value="">
		<iframe id="FRAMECJNEGRA" name="FRAMECJNEGRA" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" style="visibility:hidden"></iframe>
		</td>
<!--- 	</tr>
</table> --->
<script language="javascript" type="text/javascript">
var MAXIMO_CELDAS = 10;
var TECLA_CONLIS = 113;
function limpiaframe() {
	if (document.form1.ORIGEN.value=='C') {		
		var frame  = document.getElementById("FRAMECJNEGRA2");
		frame.src 	= "";
	}
}
/***************************************************************************************************/
function PintaCajas(mayor,detalle) {
	var CGM1IM = mayor;
	var CUENTA = detalle;
	var PARAMS = "?CGM1IM="+CGM1IM+"&CUENTA="+CUENTA
	var frame  = document.getElementById("FRAMECJNEGRA");
	frame.src 	= "/cfmx/sif/Contaweb/reportes/CajaNegra/PintaCajas.cfm" + PARAMS;
}
/***************************************************************************************************/
function ValidaCuenta(mayor) {
		var CGM1IM = mayor;
		var PARAMS = "?CGM1IM="+CGM1IM
		var frame  = document.getElementById("FRAMECJNEGRA");
		frame.src 	= "/cfmx/sif/Contaweb/reportes/CajaNegra/ValidaCuenta.cfm" + PARAMS;
}
/***************************************************************************************************/
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
/***************************************************************************************************/
function doKey(EVENTO) { 
	var k=Key(EVENTO) 
	if (k==TECLA_CONLIS) {
		var ORIGEN = document.form1.ORIGEN.value;		
		var  params = "?ORIGEN="+ORIGEN;
		if (document.form1.ORIGEN.value=='R') {		
			var formato   =  "left=250,top=200,scrollbars=yes,resizable=yes,width=650,height=400"
			open("/cfmx/sif/Contaweb/reportes/CajaNegra/ConlisCuentaMayor.cfm"+params,"",formato);
		}
		else{
			var frame  = document.getElementById("FRAMECJNEGRA2");
			frame.src 	= "/cfmx/sif/Contaweb/reportes/CajaNegra/ConlisCuentaMayor.cfm"+params;
		}
	}
}
/***************************************************************************************************/
function escuenta(obj,e,NIVEL)
{
    str= new String("")
	str= obj.value
	var t=Key(e)
	var ok=false
	var MAXIMO = new Number(document.form1.NIVELES.value);

    if(t==TECLA_CONLIS){
		StringNivel = StrNivel(NIVEL);
		if((StringNivel.indexOf('_') == -1 && StringNivel.length >0)|| NIVEL == 1 ){
			eval("document.form1.CG13ID_"+NIVEL+".value=''")
			var params ="";
			var CGM1IM = document.form1.CGM1IM.value;
			var ORIGEN = document.form1.ORIGEN.value;
			params = "?CGM1IM="+CGM1IM+"&NIVEL="+NIVEL+"&StringNivel="+StringNivel+"&ORIGEN="+ORIGEN;
			if (document.form1.ORIGEN.value=='R') {			
				var formato   =  "left=250,top=200,scrollbars=yes,resizable=yes,width=650,height=400"
				open("/cfmx/sif/Contaweb/reportes/CajaNegra/ConlisCuentaDetalle.cfm"+params,"",formato);
			}
			else{
				var frame  = document.getElementById("FRAMECJNEGRA2");
				frame.src 	= "/cfmx/sif/Contaweb/reportes/CajaNegra/ConlisCuentaDetalle.cfm"+params;
			}
		}
		else{
			alert("Error existen niveles invalidos")
		}
	}
  	else{
		if(t==105 || t==189 || t==48 || t==49  || t==50  || t==51  || t==52  ||
		   t==53  || t==54  || t==55 || t==56  || t==57  || t==16  || t==96  ||
		   t==97  || t==98  || t==99 || t==100 || t==101 || t==102 || t==103 ||
		   t==104 )  ok= true ;
		if(!ok) 
		{    
			
			if(t==32){
				obj.value=str.substring(0,str.length-1)
				obj.value = obj.value + "_"
			}
			else
				obj.value=str.substring(0,str.length-2)
		}
		 if(str.length > obj.size){
			var nextnivel = new Number(NIVEL)+ 1
			if (nextnivel >= MAXIMO){
				nextnivel = MAXIMO;
			}
			ultimodig = str.substring(str.length,str.length-1)
			obj.value=str.substring(0,str.length-1)			
			if (eval("document.form1.CG13ID_"+(NIVEL+1)+".style.visibility") == 'visible')			 			
			{	
				eval("document.form1.CG13ID_"+(NIVEL+1)+".focus()")	
				eval("document.form1.CG13ID_"+(NIVEL+1)+".value = " + ultimodig)
			}
			//obj.value=str.substring(0,str.length-1) 
		}
	}	
	return true
}
/***************************************************************************************************/
function validaceldas() {
	var llenas = true;
    var mascara = "";
	var calcula = "";
	mascara = mascara + document.form1.CGM1IM.value;
	var MAXIMO = document.form1.NIVELES.value;
	MAXIMO --;
	var MAX_NIV = 0;
	var dif = 0;
	for (var CELDA=MAXIMO; CELDA>=1; CELDA--){
		if(eval("document.form1.CG13ID_"+CELDA+".value")!="") {
			MAX_NIV = CELDA;
			break;
		}	
	}
	for (var CELDA=1; CELDA<=MAX_NIV; CELDA++){
		dif =0;		
		if(eval("document.form1.CG13ID_"+CELDA+".value")!="") {
			calcula  =eval("document.form1.CG13ID_"+CELDA+".value");
			if(calcula.length == eval("document.form1.CG13ID_"+CELDA+".size")){
				mascara = 	mascara + calcula;
			}
			else{
				dif = new Number(eval("document.form1.CG13ID_"+CELDA+".size")) - new Number(calcula.length)
			    mascara = 	mascara + calcula;
				for (var caracter=1; caracter <= dif; caracter++){
					mascara = 	mascara + '_';
				}
			}			
		}
		else{
			dif = new Number(eval("document.form1.CG13ID_"+CELDA+".size"))	
			for (var caracter=1; caracter <= dif; caracter++){
					mascara = 	mascara + '_';
			}
		}	
	}
    BuscaNivel();
	document.form1.CUENTASLIST.value = mascara+"¶" + document.form1.PRIMERNIVEL.value +"¶" + document.form1.VALORPRIMERNIVEL.value +"¶" + document.form1.NivelDetalle.value +"¶" + document.form1.NivelTotal.value; 
}
/***************************************************************************************************/
function cargadetalle() {
	if(document.form1.CGM1IM.value != ""){	
		var llenas = true;
			var mascara = "";
			var calcula = "";
			var MAXIMO = document.form1.NIVELES.value;
			MAXIMO --;
			var MAX_NIV = 0;
			var dif = 0;
			for (var CELDA=MAXIMO; CELDA>=1; CELDA--){
				if(eval("document.form1.CG13ID_"+CELDA+".value")!="") {
					MAX_NIV = CELDA;
					break;
				}	
			}
			for (var CELDA=1; CELDA<=MAX_NIV; CELDA++){
				dif =0;		
				if(eval("document.form1.CG13ID_"+CELDA+".value")!="") {
					calcula  =eval("document.form1.CG13ID_"+CELDA+".value");
					if(calcula.length == eval("document.form1.CG13ID_"+CELDA+".size")){
						mascara = 	mascara + calcula;
					}
					else{
						dif = new Number(eval("document.form1.CG13ID_"+CELDA+".size")) - new Number(calcula.length)
						mascara = 	mascara + calcula;
						for (var caracter=1; caracter <= dif; caracter++){
							mascara = 	mascara + '_';
						}
					}			
				}
				else{
					dif = new Number(eval("document.form1.CG13ID_"+CELDA+".size"))	
					for (var caracter=1; caracter <= dif; caracter++){
							mascara = 	mascara + '_';
					}
				}	
			}
			if(mascara.indexOf('_') >= 0){
				mascara ="";
				alert("debe selecionar una cuenta valida")
				limpiarCeldas()
				
			}	
			else {
				document.form1.CGM1CD.value = mascara; 
			}		
	}	
	else{
		document.form1.CGM1CD.value = '';
		alert("debe selecionar una cuenta mayor")
		document.form1.CGM1IM.focus()
	}
}

/***************************************************************************************************/
function agregaRango(origen) {
	if(document.form1.CGM1IM.value != ""){	
		var llenas = true;
			var mascara = "";
			var calcula = "";
			mascara = mascara + document.form1.CGM1IM.value;
			var MAXIMO = document.form1.NIVELES.value;
			MAXIMO --;
			var MAX_NIV = 0;
			var dif = 0;
			for (var CELDA=MAXIMO; CELDA>=1; CELDA--){
				if(eval("document.form1.CG13ID_"+CELDA+".value")!="") {
					MAX_NIV = CELDA;
					break;
				}	
			}
			for (var CELDA=1; CELDA<=MAX_NIV; CELDA++){
				dif =0;		
				if(eval("document.form1.CG13ID_"+CELDA+".value")!="") {
					calcula  =eval("document.form1.CG13ID_"+CELDA+".value");
					if(calcula.length == eval("document.form1.CG13ID_"+CELDA+".size")){
						mascara = 	mascara + calcula;
					}
					else{
						dif = new Number(eval("document.form1.CG13ID_"+CELDA+".size")) - new Number(calcula.length)
						mascara = 	mascara + calcula;
						for (var caracter=1; caracter <= dif; caracter++){
							mascara = 	mascara + '_';
						}
					}			
				}
				else{
					dif = new Number(eval("document.form1.CG13ID_"+CELDA+".size"))	
					for (var caracter=1; caracter <= dif; caracter++){
							mascara = 	mascara + '_';
					}
				}	
			}
			if(mascara.indexOf('_') >= 0){
				mascara ="";
				alert("debe selecionar una cuenta valida")
				limpiarCeldas()
				
			}	
			else {
				validaDatos(mascara,origen) 
			}		
	}	
	else{
			if(origen == 1)
				document.form1.DESDE.value = '';
			else
				document.form1.HASTA.value = '';

		alert("debe selecionar una cuenta")
		document.form1.CGM1IM.focus()
	}
	OcultarCeldas()
}
/***************************************************************************************************/
function concatenaCuenta() 
{
var mascara = "";	
	if(document.form1.CGM1IM.value != ""){
		var llenas = true;
		var calcula = "";
		mascara = mascara + document.form1.CGM1IM.value;
		
		var MAXIMO = document.form1.NIVELES.value;
		MAXIMO --;
		var MAX_NIV = 0;
		var dif = 0;
		
		for (var CELDA = MAXIMO; CELDA >= 1; CELDA --){
			if(eval("document.form1.CG13ID_"+CELDA+".value") != "") {
				MAX_NIV = CELDA;
				break;
			}	
		}
		for (var CELDA = 1; CELDA <= MAX_NIV; CELDA ++){
			dif = 0;
			if(eval("document.form1.CG13ID_"+CELDA+".value") != "") {
				calcula = eval("document.form1.CG13ID_"+CELDA+".value");
				
				if(calcula.length == eval("document.form1.CG13ID_"+CELDA+".size")){
					mascara = mascara + calcula;
				}
				else{
					dif = new Number(eval("document.form1.CG13ID_"+CELDA+".size")) - new Number(calcula.length)
					mascara = 	mascara + calcula;
					for (var caracter=1; caracter <= dif; caracter++){
						mascara = mascara + '_';
					}
				}
			}
			else {
				dif = new Number(eval("document.form1.CG13ID_"+CELDA+".size"))	
				for (var caracter=1; caracter <= dif; caracter++){
					mascara = mascara + '_';
				}
			}
		}
		BuscaNivel();
		return mascara;
	}	
	else{
		alert("Debe de Selecionar una Cuenta Contable")
		document.form1.CGM1IM.focus()
		return mascara;
	}
}
/***************************************************************************************************/
function limpiarCeldas() {
	var CG13ID_1 = document.getElementById("CG13ID_1")
	var CG13ID_2 = document.getElementById("CG13ID_2")
	var CG13ID_3 = document.getElementById("CG13ID_3")
	var CG13ID_4 = document.getElementById("CG13ID_4")
	var CG13ID_5 = document.getElementById("CG13ID_5")
	var CG13ID_6 = document.getElementById("CG13ID_6")
	var CG13ID_7 = document.getElementById("CG13ID_7")
	var CG13ID_8 = document.getElementById("CG13ID_8")
	var CG13ID_9 = document.getElementById("CG13ID_9")
	var CG13ID_10= document.getElementById("CG13ID_10")
	var MAXIMO = document.form1.NIVELES.value;
	for (var CELDA=1; CELDA< MAXIMO; CELDA++){
		eval("CG13ID_"+CELDA+".style.visibility='hidden'")
		eval("CG13ID_"+CELDA+".value=''")
	}
	document.form1.CGM1IM.value = '';
	document.form1.CGM1IM.focus()
}
/***************************************************************************************************/
function StrNivel(NIVEL) {
	var StringNivel = "";
	for (var CELDA=1; CELDA<NIVEL; CELDA++){
		StringNivel = StringNivel + eval("document.form1.CG13ID_"+CELDA+".value")
	}
	return StringNivel;
}
/***************************************************************************************************/
function validaDatos(detalle,origen) {
	var CUENTA = detalle;
	var PARAMS = "?CUENTA="+CUENTA+"&ORIGEN="+origen
	var frame  = document.getElementById("FRAMECJNEGRA");
	frame.src 	= "/cfmx/sif/Contaweb/reportes/CajaNegra/validainfo.cfm" + PARAMS;
}
/***************************************************************************************************/
function BuscaNivel() {
				document.form1.PRIMERNIVEL.value = "0";
				document.form1.VALORPRIMERNIVEL.value = "-";
	
	var CG13ID_1 = document.getElementById("CG13ID_1")
	var CG13ID_2 = document.getElementById("CG13ID_2")
	var CG13ID_3 = document.getElementById("CG13ID_3")
	var CG13ID_4 = document.getElementById("CG13ID_4")
	var CG13ID_5 = document.getElementById("CG13ID_5")
	var CG13ID_6 = document.getElementById("CG13ID_6")
	var CG13ID_7 = document.getElementById("CG13ID_7")
	var CG13ID_8 = document.getElementById("CG13ID_8")
	var CG13ID_9 = document.getElementById("CG13ID_9")
	var CG13ID_10= document.getElementById("CG13ID_10")
	var MAXIMO = document.form1.NIVELES.value;
	var TAM_CAMPO = 0;
	var TAM_VALOR = 0;
	var valor = ""
	var Nivel = 0;
	var guiones = "_____________"
	for (var CELDA=MAXIMO; CELDA > 0; CELDA--){
		valor     = eval("document.form1.CG13ID_"+CELDA+".value");
		TAM_VALOR = valor.length 
		TAM_CAMPO = eval("document.form1.CG13ID_"+CELDA+".size")
		//alert(TAM_VALOR +'<-- valor  campo-->'+ TAM_CAMPO +' nivel -->'+CELDA)
		var guionescontrol = guiones.substring(1, TAM_VALOR)

		if (TAM_VALOR > 0) {
			if (valor != guionescontrol) {
				document.form1.PRIMERNIVEL.value = CELDA;
				document.form1.VALORPRIMERNIVEL.value = valor;
				break;
			}
		} 
	}
}
</script>
