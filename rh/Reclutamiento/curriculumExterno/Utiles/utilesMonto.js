var nav4 = window.Event ? true : false;
//Valida solo números enteros. Llamar en evento onKeyPress Ejem. onKeyPress="return acceptNum(event)"
function acceptNum(evt){	
	// NOTE: Backspace = 8, Enter = 13, '0' = 48, '9' = 57	
	if (!evt) evt = window.Event;
	var LvarCharCode = Key(evt);	
	return (LvarCharCode < 32 || (LvarCharCode >= 48 && LvarCharCode <= 57));
}

function trim(dato) {
	return dato.replace(/^\s*|\s*$/g,"");
}

//Valida la fechas para un campo de captura de fechas
function onblurdatetime(elemento) {
    var f = elemento.value;
	if (f != "") {
		var partes = f.split ("/");
		var ano = 0, mes = 0; dia = 0;
		if (partes.length == 3) {
			ano = parseInt(partes[2], 10);
			mes = parseInt(partes[1], 10);
			dia = parseInt(partes[0], 10);
		} else if (partes.length == 2) {
			var hoy = new Date;
			ano = hoy.getFullYear();
			mes = parseInt(partes[1], 10);
			dia = parseInt(partes[0], 10); 
		} else {
			alert("La fecha indicada es inválida. Utilice el formato (dd/mm/yyyy)");
			elemento.value = "";
			elemento.focus();
			return false;
		}
		if (ano < 100) {
			ano += (ano < 50 ? 2000 : 1900);
		} else if (ano >= 100 && ano < 1900) {
			alert("El año debe ser mayor o igual a 1900");
			elemento.value = "";
			elemento.focus();
			return false;
		}
		var d = new Date(ano, mes - 1, dia);
		if ((d.getFullYear() == ano) && 
			(d.getMonth()    == mes-1) && 
			(d.getDate()     == dia))
		{   // ok
			elemento.value 
				= (d.getDate()  < 10 ? "0" : "") + d.getDate() + "/" 
				+ (d.getMonth() < 9 ? "0" : "") + (d.getMonth()+1) + "/" + d.getFullYear();
		} else {
			alert("La fecha indicada es inválida. Utilice el formato (dd/mm/yyyy)");
			elemento.value = ""; 
			elemento.focus();
			return false;
		}
	} else {
		// La fecha está en blanco
	}
	return true;
}

//Redondea un monto a los decimales especificados (Recibe un valor)
function redondear(monto, decimales){
	var cantdec=1;
	for (var i=0;i<decimales;i++)
	{
		cantdec*=10;
	}
	return Math.round(monto*cantdec)/cantdec
}

//Autor: Ing. Óscar Enrique Bonilla Calderón, 28/JUL/2006
//Devuelve el KeyCode de una tecla en el evento keyUp y keyDown
//Devuelve el CharCode de una tecla en el evento keyPress
//Devuelve el Botón presionado del Mouse en los eventos del Mouse 
function Key(evt)
 {
	if (!evt) evt = window.Event;
	if ("keyup,keydown".indexOf(evt.type) != -1)
		// Eventos del Teclado: keyup,keydown
	 	return evt.which ? evt.which : evt.keyCode;	
	else if (evt.type == "keypress")
	{
		// Eventos del Teclado: keypress
		if (window.Event) return (evt.charCode == 0 && evt.keyCode < 32) ? evt.keyCode : evt.charCode;
	 	return evt.charCode ? evt.charCode : evt.keyCode;	
	}
	else if ("click,mousedown,mouseup,mouseover,mousemove,mouseup".indexOf(evt.type) != -1)
		// Eventos del Mouse: 1=left, 2=center, 3=right
	 	return evt.button;
	else
		return -1;
}

//Autor: Ing. Óscar Enrique Bonilla Calderón, 28/JUL/2006
//Permite digitar únicamente los caracteres numericos
function _CFinputText_onKeyPress(obj,evt,ents,decs,negs,comas)
{
	if (!evt) evt = window.Event;
	var LvarCharCode = Key(evt);

	if (LvarCharCode < 32 || (LvarCharCode >= 48 && LvarCharCode <= 57))
		return true; 
	else if ((decs == true || decs > 0) && LvarCharCode == 46)
		return true;
	else if (negs == true && LvarCharCode == 45)
		return true;
	else
		return false;
}

//Autor: Ing. Óscar Enrique Bonilla Calderón, 28/JUL/2006
//Verfica la digitación de números en Input-Text
//Permite definir cantidad de decimales, negativos y comas
//Verifica teclas digitadas, cantidad de enteros, cantidad de decimales, punto decimal y signo negativo (las comas se ponen en el onblur).
//La cantidad de Enteros es el tamaño del campo menos los decimales+punto menos la cantidad de comas
//		Entero = coalesce(MaxLength, Size, 10) - if(decimales>0 then decimales+1) - if (comas then int(Enteros/4))
function _CFinputText_onKeyUp(obj,evt,ents,decs,negs,comas)
{
	if (!evt) evt = window.Event;
	var LvarKeyCode = Key(evt);
	var LvarKeyCodeType = keyCodeType(evt, decs, negs);

	if(!(window.Event) && "historyKey,cursorKey,tabKey,enterKey,functionKey,symbolKey,letterKey".indexOf(LvarKeyCodeType) != -1) return true;

	return snumber(obj,evt,decs,negs,comas,ents);
}

//Permite solamente digitar numeros (se usa en el evento onKeyUp)
function snumber(obj,evt,decs,negs,comas,ents)
{
	if (!evt) evt = window.Event;
	var LvarKeyCode = Key(evt);
	var LvarKeyCodeType = keyCodeType(evt, decs, negs);

	if("historyKey,cursorKey,tabKey,enterKey,functionKey".indexOf(LvarKeyCodeType) != -1) return true;

	var argsN = snumber.arguments.length;
	if (argsN < 3)	decs 	= 2; 
	if (argsN < 4)	negs 	= false;
	if (argsN < 5)	comas 	= (decs>0);
	if (argsN < 6)	ents 	= 0;
	
	str= new String("");
	str= obj.value;

	var ok = LvarKeyCodeType=="numberKey" || LvarKeyCodeType=="deleteKey";
	 
	// Elimina negativo si no se permite o si no es el primer caracter
	if (LvarKeyCode==109 || LvarKeyCode==189)
	{
		ok = true;
		if (!negs)
		{
			str = strReplace(str,"-","");
		}
		else
		{
			var LvarPto1 = str.indexOf('-');
			var LvarPto2 = str.indexOf('-',1);
			if (LvarPto2 != -1)
			{
				if (LvarPto1 > 0)
					str = "-" + strReplace(str,"-","");
				else
					str = strReplace(str,"-","");
			}
		}
	}

	// Elimina punto decimal si no se permite o si se pone más de uno
	var LvarPunto = str.indexOf('.');
	if (LvarKeyCode==110 || LvarKeyCode==190)
	{
		ok = true;
		if (decs == 0)
		{
			str = strReplace(str,".","");
		}
		else
		{
			var LvarPto2 = str.indexOf('.',LvarPunto+1);
			if (LvarPto2 != -1)
			{
				str = str.substr(0,LvarPunto+1) + strReplace(str.substr(LvarPunto+1),".","");
			}
		}
	}

	if(ok) 
	{
		// determina cantidad de enteros:
		//	i. 	Para CF_inputNumber viene como parámetro
		//	ii.	Para compatibilidad con código viejo: 
		//			LvarEnteros = coalesce(maxLength, size, 10) - (decs+punto_dec) - (signo_neg+cant_comas)
		//			OJO: - (signo_neg+cant_comas) es nuevo, pero si no se toma en cuenta da datos incongruentes
		var tam = 0;
		var LvarEnteros = ents;

		if (ents == 0)
		{
			if (obj.maxLength && obj.maxLength > 0)  tam = obj.maxLength;
			if (tam == 0 && obj.size && obj.size >0) tam = obj.size;
			if (tam == 0) 							 tam = 10;
	
			// verifica cantidad de enteros, sino ajusta
			LvarEnteros = tam;
			if (decs > 0) 	LvarEnteros -= decs+1;
			if (negs)		LvarEnteros--;
			if (comas)		LvarEnteros -= Math.floor(LvarEnteros/4);
		}
		
		if(!ints(str,LvarEnteros))
		{
			if (str.substr(0,1) == "-")	LvarEnteros++;
			if (LvarPunto == -1)
			{
				str = str.substr(0,LvarEnteros) + (decs>0 ? "." + str.substr(LvarEnteros): "");
			}
			else
			{
				str = str.substr(0,LvarEnteros) + str.substr(LvarPunto);
			}
		}
	
		// verifica cantidad de decimales, sino ajusta
		if(!decimals(str,decs))
		{
			str=str.substr(0,LvarPunto+decs+1);
		}
	}
	else
	{    
		str=fm(str,decs,false,(decs==0 && !negs && !comas));
	}

	if (str == ".")
		obj.value = "0.";
	else if (str == "-.")
		obj.value = "-0.";
	else if (obj.value != str) obj.value = str;

	return true;
}
//Autor: Ing. Óscar Enrique Bonilla Calderón, 28/JUL/2006
//Verfica que el valor contenga únicamente la cantidad de enteros indicada
function ints(str,ints)
{
	var punto=str.indexOf('.');
	if(punto!=-1)	str=str.substring(0,punto);
	str=strReplace(str,',','');
	str=strReplace(str,'-','');

	return (str.length <= ints);
}

//Autor: Ing. Óscar Enrique Bonilla Calderón, 28/JUL/2006
//Verfica que el valor contenga únicamente la cantidad de decimales indicada
function decimals(str,decs)
{
	var largo=str.length;
	var punto=str.indexOf('.');

	return(punto==-1 || largo-punto-1 <= decs);
}

//Formato por Randall Vargas
//Formatea como float un valor de un campo
//Recibe como parametro el campo y la cantidad de decimales a mostrar
//Si se deben incluir las comas y si se mantienen ceros a la izquierda
//Por default comas = true, cerosIzq = false
function fm(campo,ndec,comas,dejarCerosIzq,defaultOnBlank) {
	var argsN = fm.arguments.length;
	if (argsN < 3)	comas 	 = (ndec>0);;
	if (argsN < 4)	dejarCerosIzq = false;
	if (argsN < 5)	defaultOnBlank = "0";

	var s = "";
	if (campo.name)
		s=campo.value;
	else
		s=campo+"";
	
	if (trim(s) == "")
		if (trim(defaultOnBlank) == "")
		{
			if(campo.name)
			{
				campo.value="";
				return;
			}
			else 
				return "";
		}
		else
			s = defaultOnBlank;

	var signo = "";
	if (s.substring(0,1) == "-") signo = "-";
	 
	if (ndec >0)
	{
		if(s == "")
			s='0';
		else if (s.substr(0,1) == ".")
			s = "0" + s;
		else if (s.substr(0,2) == "-.")
			s = "-0" + s.substr(1);
	}

	var nc="";
	var s1=""
	var s2=""
	if (s != '') 
	{
		var str = new String("")
		var str_temp = new String(s)
		var t1 = str_temp.length
		var LvarIncluirCeros = dejarCerosIzq;
		if (t1 > 0) 
		{
			for(i=0;i<t1;i++) 
			{
				var c=str_temp.charAt(i)
				if ((c!="0") || (c=="0" && ((i<t1-1 && str_temp.charAt(i+1)==".")) || i==t1-1) || (c=="0" && LvarIncluirCeros)) 
				{
				   LvarIncluirCeros=true
				   str+=c
				}
			}
		}
		t1 = str.length;
		var p1 = str.indexOf(".")
		var p2 = str.lastIndexOf(".")
		if ((p1 == p2) && t1 > 0) 
		{
			if (p1>0)
				str+="00000000"
			else
				str+=".0000000"
			p1 = str.indexOf(".")
			s1=str.substring(0,p1)
			s2=str.substring(p1+1,p1+1+ndec)
			t1 = s1.length
			n=0
			for(i=t1-1;i>=0;i--) 
			{
				var c=s1.charAt(i);
				if (c == ".") 
				{
					flag=0;
					nc="."+nc;
					n=0
				}
				if (c>="0" && c<="9") {
					if (n < 2) 
					{
						nc=c+nc;
						n++;
					}
					else 
					{
						n=0
						nc=c+nc
						if (i > 0 && comas != false) nc=","+nc;
					}
				}
			}
			if (nc != "" && ndec > 0) nc+="."+s2;
		}
		else {ok=1}
	}
	
	if ( strReplace(strReplace(nc,"0",""),".","") != "" )
		nc = (signo + nc).replace("-,","-");
	
	if(campo.name) 
		campo.value=nc;
	else 
		return nc;
}

//reemplaza un string por otro dentro de una hilera, devuelve la hilera reemplazada
function strReplace(str,oldc,newc) 
{
   var HILERA="";
   var CARACTER="";
   for (var i=0; i<str.length; i++) 
   {
	  CARACTER=str.substr(i,1);
	  if (CARACTER==oldc)  CARACTER=newc;
	  HILERA=HILERA+CARACTER;
   }
   return HILERA;
}

//Formatea un objeto tipo texto a los decimales indicados, 
// poniendo comas para agrupación de dígitos
function formatCurrency(obj, decimal ) {
	obj.value = qf(obj);
	var valor = 1
	for (var i=0; i<decimal; i++) {
		valor *= 10 
	}

	num = obj.value
	num = num.toString().replace(/\$|\,/g,'');
	if(isNaN(num))
	num = "0";
	sign = (num == (num = Math.abs(num)));
	num = Math.floor(num*valor+0.50000000001);
	cents = num%valor;
	num = Math.floor(num/valor).toString();
	if(cents<10)
	cents = "0" + cents;
	for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
	num = num.substring(0,num.length-(4*i+3))+','+
	num.substring(num.length-(4*i+3));
	obj.value = (((sign)?'':'-') + num + '.' + cents);
	
}

//elimina el formato numerico de una hilera, retorna la hilera
// recibe un objeto
function qf(Obj)
{
		var VALOR=""
		var HILERA=""
		var CARACTER=""
		if(Obj.name)
		  VALOR=Obj.value
		else
		  VALOR=Obj
		
		for (var i=0; i<VALOR.length; i++) {	
		
			CARACTER =VALOR.substring(i,i+1);
			if (CARACTER=="," || CARACTER==" ") {
				CARACTER=""; //CAMBIA EL CARACTER POR BLANCO
			}  
			HILERA+=CARACTER;
		}
		return HILERA
}

//Verifica si un valor es numerico (soporta unn punto para los decimales unicamente)
function ESNUMERO(aVALOR)
{
	var NUMEROS="0123456789."
	var CARACTER=""
	var CONT=0
	var PUNTO="."
	var VALOR = aVALOR.toString();
	
	for (var i=0; i<VALOR.length; i++)
		{	
		CARACTER =VALOR.substring(i,i+1);
		if (NUMEROS.indexOf(CARACTER)<0) {
			return false;
			} 
		}
	for (var i=0; i<VALOR.length; i++)
		{	
		CARACTER =VALOR.substring(i,i+1);
		if (PUNTO.indexOf(CARACTER)>-1)
			{CONT=CONT+1;} 
		}
	
	if (CONT>1) {
		return false;
	}
	return true;
}

function validaNumero(dato,dec) {
	dato = qf(dato);
	if (dato.length > 0) {
		if (ESNUMERO(dato)) {
			return true;
		}		
		else {
			alert('El monto digitado debe ser numérico.');			
			return false;
		}
	}
	else
		alert('El monto digitado debe ser numérico.');
		return false;	
}

function convFecha(date){
// RESULTADO
// Toma una fecha en formato DD/MM/YYYY y devuelve
// un objeto Date con la fecha enviada.

    var tmp    = new String(date);
    var length = tmp.length;
    var i      = tmp.indexOf("/");
    var f      = tmp.lastIndexOf("/");
    
    var ano = tmp.substring(f+1,length)
    var mes = ( tmp.substring(i+1,f).charAt(0) != "0" ) ? tmp.substring(i+1,f) : tmp.substring(i+2,f)
    var dia = ( tmp.substring(0,i).charAt(0) != "0" ) ? tmp.substring(0,i) : tmp.substring(1,i)
    
    return new Date(ano,parseInt(mes)-1,dia)
}

function ESFECHA(FECHA) { 
	//Verifica si un valor dado en formato dd/mm/yyyy  corresponde a una fecha valida
	if (FECHA.length != 10) return false; 
	dia = FECHA.substring(0, 2);
	slash1 = FECHA.substring(2, 3);
	mes = FECHA.substring(3, 5);
	slash2 = FECHA.substring(5, 6);
	ano = FECHA.substring(6, 10);
	if(!Number(mes)) return false;
	if(!Number(dia)) return false;
	if(!Number(ano)) return false; 

	if (mes<1 || mes>12) return false; 
	if(slash1=='-') slash1='/';
	if (slash1!='/') return false; 
	if (dia<1 || dia>31) return false; 
	if(slash2=='-') slash2='/';
	if (slash2!='/') return false; 
	if (ano<0 || ano>3000) return false; 
	if (mes==4 || mes==6 || mes==9 || mes==11){
		if (dia==31) return false;
	} 
	if (mes==2){
		var bisiesto=parseInt(ano/4)
		if (isNaN(bisiesto)) return false; 
		if (dia>29) return false; 
		if (dia==29 && ((ano/4)!=parseInt(ano/4))) return false; 
	}
	
	return true;
}

function rangoFechas(ini,fin){
	if(ini != '' && fin != ''){
		if(ESFECHA(ini) && ESFECHA(fin)){
			var valorINICIO=0;
			var valorFIN=0;
			var INICIO = ini;
			var FIN = fin;		
			INICIO = INICIO.substring(6,10) + INICIO.substring(3,5) + INICIO.substring(0,2)
			FIN = FIN.substring(6,10) + FIN.substring(3,5) + FIN.substring(0,2)
			valorINICIO = parseInt(INICIO)
			valorFIN = parseInt(FIN)
		
			if (valorINICIO > valorFIN){
				alert("Error, la fecha de inicial (" + ini + ") no debe ser mayor que la fecha final (" + fin + ")");
				return false;																			  
			}
			return true;
		}else{
			alert("Error, la fecha de inicial (" + ini + ") o la fecha final (" + fin + ") es inválida.");
			return false;			
		}		
	}
}

//Autor: Ing. Óscar Enrique Bonilla Calderón, 28/JUL/2006
//Clasifica la tecla presionada en un keyDown o keyUp
function keyCodeType(evt, decimales, negativos)
{
	if (!evt) evt = window.Event;
	var LvarKeyCode = Key(evt);
	switch (LvarKeyCode)
	{
		case 13:		// enter
			return "enterKey";
			break;
		case 9:		// tab
			return "tabKey";
		case 36:		// home
		case 37:		// arrow left
		case 39:		// arrow right
			return evt.altKey ? "historyKey" : "cursorKey";
		case 33:		// page up
		case 34:		// page down
		case 35:		// end
		case 38:		// arrow up
		case 40:		// arrow down
			return "cursorKey";
		case 8:			// backspace
		case 46:		// del
			return (LvarKeyCode == 46 && evt.altKey) ? "functionKey" : "deleteKey";
		case 16:		// shift
		case 17:		// ctrl
		case 18:		// alt
		case 19:		// pause/break
		case 20:		// caps lock
		case 27:		// escape
		case 91:		// left window key
		case 92:		// right window key
		case 93:		// select key
		case 112:	// f1
		case 113:	// f2
		case 114:	// f3
		case 115:	// f4
		case 116:	// f5
		case 117:	// f6
		case 118:	// f7
		case 119:	// f8
		case 120:	// f9
		case 121:	// f10
		case 122:	// f11
		case 123:	// f12
		case 144:	// num lock
		case 145:	// scroll lock
			return "functionKey";
		case 45:		// ins
			return evt.shiftKey ? "pasteKey" : "functionKey";
		case 86:		// v
		case 88:		// x
			return evt.ctrlKey ? "pasteKey" : "letterKey";
		case 65:		// a 97 - 32
		case 66:		// b
		case 67:		// c
		case 68:		// d
		case 69:		// e
		case 70:		// f
		case 71:		// g
		case 72:		// h
		case 73:		// i
		case 74:		// j
		case 75:		// k
		case 76:		// l
		case 77:		// m
		case 78:		// n
		case 79:		// o
		case 80:		// p
		case 81:		// q
		case 82:		// r
		case 83:		// s
		case 84:		// t
		case 85:		// u
		case 87:		// w
		case 89:		// y
		case 90:		// z 122 - 32
			return !(evt.ctrlKey || evt.altKey) ? "letterKey" : "symbolKey";
		case 48:		// 0
		case 49:		// 1
		case 50:		// 2
		case 51:		// 3
		case 52:		// 4
		case 53:		// 5
		case 54:		// 6
		case 55:		// 7
		case 56:		// 8
		case 57:		// 9
			return !(evt.shiftKey || evt.ctrlKey || evt.altKey) ? "numberKey" : "symbolKey";
		case 96:		// numpad 0
		case 97:		// numpad 1
		case 98:		// numpad 2
		case 99:		// numpad 3
		case 100:	// numpad 4
		case 101:	// numpad 5
		case 102:	// numpad 6
		case 103:	// numpad 7
		case 104:	// numpad 8
		case 105:	// numpad 9
			return "numberKey";
		case 110:	// numpad .
		case 190:	// .
			return (decimales == true || decimales>0) ? "numberKey" : "symbolKey";
		case 189:	// -
		case 109:	// numpad -
			return negativos == true ? "numberKey" : "symbolKey";
		case 106:	// numpad *
		case 107:	// numpad +
		case 111:	// numpad /
		case 186:	// EN ;	ES_LA ´
		case 187:	// EN =	ES_LA +
		case 188:	// EN ,	ES_LA ,
		case 191:	// EN /	ES_LA }
		case 192:	// EN `	ES_LA ñ
		case 219:	// EN [	ES_LA '
		case 220:	// EN \	ES_LA |
		case 221:	// EN ]	ES_LA ¿
		case 222:	// EN ''	ES_LA {
		case 226:	// EN \	ES_LA <
			return "symbolKey";
		default:
			return "";
	}
}
