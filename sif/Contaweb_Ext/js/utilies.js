function llenar_string(obj,cantidad,caracter){
	var str  = obj.value
	var resultado = str
	var cant = new Number(cantidad)
	for (i = 0;(cant-str.length) > i ; i ++){
		resultado = caracter + resultado
	}
	obj.value = resultado
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

//Devuelve el codigo ASCII de una tecla en el evento keyUp
function Key(evento)
 {
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

//Permite solamente digitar numeros (se usa en el evento onKeyUp)
function snumber(obj,e,d)
{
	str= new String("")
	str= obj.value
	var tam=obj.size
	var t=Key(e)
	var ok=false
	 
	if(tam>d) {tam=tam-d}
	if(tam>1) {tam=tam-1}
	 
	if(t==9 || t==8 || t==13 || t==20 || t==27 || t==45 || t==46)  return true;
	if(t>=16 && t<=20) return false;
	if(t>=33 && t<=40) return false;
	if(t>=112 && t<=123) return false;
	if(!ints(str,tam)) obj.value=str.substring(0,str.length-1)
	if(!decimals(str,d)) obj.value=str.substring(0,str.length-1)
	 
	if(t>=48 && t<=57)  ok=true
	if(t>=96 && t<=105) ok=true
	//if(d>=0) {if(t==188) ok=true} //LA COMA
	 
	if(d>0)
	{
	if(t==110) ok=true
	if(t==190) ok=true
	}
	 
	if(!ok) 
	{    
		str=fm(str,d)
		obj.value=str
	}
	return true
}

function decimals(str,d)
{
	var largo=str.length      
	var punto=-1
	for(var i=0;i<str.length;i++)
	  {punto=str.indexOf('.')}
	punto++
	if(punto>0 && largo-punto>d)
	  return false
	else
	  return true 
}

function ints(str,ints)
{
	 var largo=str.length      
	 var punto=-1
	 for(var i=0;i<str.length;i++)
	   {punto=str.indexOf('.')}
	 punto++
	 if(punto>0)
	   {str=str.substring(0,punto-1)}
	 str=strReplace(str,',','');
	 if(str.length>ints) {
	   return false;
	 } else {
	   return true;
	 }
}
//Formatea como float un valor de un campo
//Recibe como parametro el campo y la cantidad de decimales a mostrar
function fm(campo,ndec) {
   var s = "";
   if (campo.name)
	 s=campo.value
   else
	 s=campo
 
   if(s=='' && ndec>0) 
  s='0'
 
   var nc=""
   var s1=""
   var s2=""
   if (s != '') {
	  str = new String("")
	  str_temp = new String(s)
	  t1 = str_temp.length
	  cero_izq=true
	  if (t1 > 0) {
		 for(i=0;i<t1;i++) {
			c=str_temp.charAt(i)
			if ((c!="0") || (c=="0" && ((i<t1-1 && str_temp.charAt(i+1)==".")) || i==t1-1) || (c=="0" && cero_izq==false)) {
			   cero_izq=false
			   str+=c
			}
		 }
	  }
	  t1 = str.length
	  p1 = str.indexOf(".")
	  p2 = str.lastIndexOf(".")
	  if ((p1 == p2) && t1 > 0) {
		 if (p1>0)
			str+="00000000"
		 else
			str+=".0000000"
		 p1 = str.indexOf(".")
		 s1=str.substring(0,p1)
		 s2=str.substring(p1+1,p1+1+ndec)
		 t1 = s1.length
		 n=0
		 for(i=t1-1;i>=0;i--) {
			 c=s1.charAt(i)
			 if (c == ".") {flag=0;nc="."+nc;n=0}
			 if (c>="0" && c<="9") {
				if (n < 2) {
				   nc=c+nc
				   n++
				}
				else {
				   n=0
				   nc=c+nc
				   if (i > 0)
					  nc=","+nc
				}
			 }
		 }
		 if (nc != "" && ndec > 0)
			nc+="."+s2
	  }
	  else {ok=1}
   }
   
   if(campo.name) {
	if(ndec>0) {
   campo.value=nc
	} else {
   campo.value=qf(nc)
  }
   } else {
	 return nc
   }
}
//reemplaza un string por otro dentro de una hilera, devuelve la hilera reemplazada
function strReplace(str,oldc,newc) 
{
   var HILERA=""
   var CARACTER=""
   for (var i=0; i<str.length; i++) 
   {
	  CARACTER=str.substring(i,i+1)
	  if (CARACTER==oldc)  
		{CARACTER=newc}
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


