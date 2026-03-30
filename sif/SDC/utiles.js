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

// Detecta el nombre y la version del browser, retorna
 // NS6 si es Netscape 6, 
 // NS4 si es Netscape4.x, 
 // MSIE5 si es Microsoft Internet Explorer 5.x, 
 // MSIE4 si es Microsoft Internet Explorer 4.x y 
 // OTHER si es otro
function detectBrowser() {
	var browserVersion = "";
  
	if (navigator.appName == "Netscape") {
		if (parseInt(navigator.appVersion) >= 5) {
			browserVersion = "NS6";
		} else if (parseInt(navigator.appVersion) >= 4) {
			browserVersion = "NS4";
		} else {    
			browserVersion = "OTHER";   
		}
	} else if (navigator.appName == "Microsoft Internet Explorer") {
		if (navigator.appVersion.indexOf["MSIE 5"] != -1) {
			browserVersion = "MSIE5";
		} else if (parseInt(navigator.appVersion) >= 4) {
			browserVersion = "MSIE4";
		} else {
		    browserVersion = "OTHER";
		}
	} else {
		browserVersion = "OTHER";
	}
	return browserVersion;
 }

function ltrim(tira) {
    var CARACTER="", HILERA="";
    if (tira.name) {
        VALOR=tira.value;
    } else {
        VALOR=tira;
    }
 
    HILERA = VALOR;
    INICIO = VALOR.lastIndexOf(" ");
    if (INICIO>-1) {
        for (var i=0; i<VALOR.length; i++) { 
            CARACTER=VALOR.substring(i,i+1);
            if (CARACTER!=" ") {
                HILERA = VALOR.substring(i,VALOR.length);
                i = VALOR.length;
            }
        }
    }
    return HILERA
}

function trim(tira)
 {return ltrim(rtrim(tira))}

//ELIMINA LOS ESPACIOS EN BLANCO DE LA DERECHA DE UN CAMPO 
function rtrim(tira) {
    if (tira.name) {
        VALOR=tira.value;
    }
    else {
        VALOR=tira;
    }
    var CARACTER = "";
    var HILERA = VALOR;
    INICIO = VALOR.lastIndexOf(" ");
    if(INICIO>-1) {
        for(var i=VALOR.length; i>0; i--) {
            CARACTER= VALOR.substring(i,i-1);
            if(CARACTER==" ")
                HILERA = VALOR.substring(0,i-1);
            else
                i=-200;
        }
    }
    return HILERA
}

//***********************************************************************************************************
//                                FUNCIONES DESPUES DE SIF EN EL PORTAL
//***********************************************************************************************************
//***********************************************************************************************************



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

//---------------------------------------------------------------------------------------------------------

//Le entra un string y un separador (un caracter) y devuelve un arreglo con todos los tokens

function tokens(s,sep){
   var str=new String(s)
   var v=new Array
   var tam=str.length
   var p1=0
   var temp=""
   var pos=0
   var n=0
   if (tam>0)   {
      pos=str.indexOf(sep)
      while (pos>=0)    {
         temp=str.substring(0,pos)
         tam=str.length
         str=str.substring(pos+1,tam)
         pos=str.indexOf(sep)
         v[n]=temp
         n++
      }
      if (pos>0 || (pos<0 && str!=''))
         v[n]=str
   }
   return v
}

//---------------------------------------------------------------------------------------------------------

function ValidaPorcentaje(Obj) {
	alert('ValidaPorcentaje');
  if  (parseInt(Obj.value) > 100 || parseInt(Obj.value) < 0) {
    alert("Porcentaje debe estar entre 0 y 100");
    return false;
  }
  
  return true;
}

//---------------------------------------------------------------------------------------------------------



<!--- esto es lo que estaba en ~/general/js/utiles.js ----->



botonActual="";

//Devuelve el codigo ASCII de una tecla en el evento keyUp
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

// Oprime el botón tipo submit que se corresponda
function defaultBtn(formulario) {
	var version4 = window.Event ? true : false;
	if (version4) {         // Netscape
        //formulario[formulario.btnDefaultbtn.value].click();
        if (formulario.name=='Mantenimiento') {
            formulario.btnCambiar.click();
        } else if (formulario.name=='Insercion') {
            formulario.btnAgregar.click();
        }
    } else {                // Internet Explorer
        //formulario[formulario.btnDefaultbtn.value].focus();
        if (formulario.name=='Mantenimiento') {
            formulario.btnCambiar.focus();
        } else if (formulario.name=='Insercion') {
            formulario.btnAgregar.focus();
        }
    }
}

// Selecciona el botón
function setBtn(boton) {
    botonActual = boton.name;
}

// Verificar si existe un boton
function btnSelected(name) {
    return (botonActual == name)
}

// Eliminar los espacios de la izquierda
function ltrim(tira) {
    var CARACTER="", HILERA="";
    if (tira.name) {
        VALOR=tira.value;
    } else {
        VALOR=tira;
    }
 
    HILERA = VALOR;
    INICIO = VALOR.lastIndexOf(" ");
    if (INICIO>-1) {
        for (var i=0; i<VALOR.length; i++) { 
            CARACTER=VALOR.substring(i,i+1);
            if (CARACTER!=" ") {
                HILERA = VALOR.substring(i,VALOR.length);
                i = VALOR.length;
            }
        }
    }
    return HILERA
}

// Eliminar los espacios de la derecha
function rtrim(tira) {
    if (tira.name) {
        VALOR=tira.value;
    }
    else {
        VALOR=tira;
    }
    var CARACTER = "";
    var HILERA = VALOR;
    INICIO = VALOR.lastIndexOf(" ");
    if(INICIO>-1) {
        for(var i=VALOR.length; i>0; i--) {
            CARACTER= VALOR.substring(i,i-1);
            if(CARACTER==" ")
                HILERA = VALOR.substring(0,i-1);
            else
                i=-200;
        }
    }
    return HILERA
}

// Función para los checks en 
function setCheck(checkbox, hidden) {
    if (checkbox.checked) {
        hidden.value='S'
    } else {
        hidden.value='N'
    }
}

// Hace falta validar la existencia de un único punto decimal, un único menos y comas en buena posición
function validaNumero(control) {
  var numero = control.value;
  var digito = numero.charAt(numero.length-1);
  var resto = numero.substr(0,numero.length-1);
  /*
  if ((digito==".") && (resto.indexOf(".")!=-1)) {
      control.value = resto;
  } else if ((digito=="-") && (resto.length!=0)) {
      control.value = resto;
  } else 
  */
  if ((digito<"0" || digito>"9") && digito!="." && digito!="-"){
      control.value = resto;
  }
}

function quiteCaracter(str,caracter){
    if (str.indexOf(caracter)!=-1) {
        str = str.substring(0,str.indexOf(caracter)) + quiteCaracter(str.substring(str.indexOf(caracter)+1,str.length),caracter);
    }
    return str;
}

// Formatea un número con comas y punto decimal
function formatNum(num) {
    myNum = quiteCaracter(""+num,",");
    negativo=false;
    pos = myNum.indexOf("-");
    if (pos!=-1) {
        myNum=myNum.substring(pos+1,myNum.length);
        negativo=true;
    }
    pos = myNum.indexOf(".");
    if (pos!=-1) {
        myNum = myNum.substring(0,pos+3);
        for (s=myNum.length; s<pos+3; s++)
            myNum+="0";
    } else {
        myNum+=".00";
    }
    pos = myNum.indexOf(".");
    while ((Math.floor(pos/3)>0) && (pos!=3)){
        myNum=myNum.substring(0,pos-3)+","+myNum.substring(pos-3,myNum.length);
        pos = myNum.indexOf(",");
    }
    if (negativo) return "-"+myNum
    else return myNum;
}





/************************************************** 
* FUNCIONCITAS DE VALIDACION DE CAPTURA DE NUMEROS *
* QUE NOS MANDARON DEL SIF PARA QUE QUEDE BONITO   *
 ***************************************************/


/*
EL OBJETO SE PINTA DE LA SIGUIENTE FORMA
	<INPUT TYPE="text" NAME="CJM03DIA" VALUE="" SIZE="6" MAXLENGTH="6" 
	ONBLUR="fm(this,-1); " 
	ONFOCUS="this.value=qf(this); this.select(); " 
	ONKEYUP="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
	style=" text-align:left;">

	A CONTINUACION LAS FUNCIONES fm(), qf() y snumber()
	EL VALOR -1 SIGNIFICA QUE EL CAMPO NO TIENE DECIMALES 
	DE LO CONTRARIO SE COLOCA EL NUMERO DE DECIMALES QUE SE QUIERAN

*/

//Funcion para validar los numeros, Autor: Ricardo Soto

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

////////////////////
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
 
////////////////////
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


//elimina el formato numerico de una hilera, retorna la hilera
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




//Formato por Randall Vargas
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
	   } 
	   else {
		 campo.value=qf(nc)
		}
   } 
   else {
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
   
/************************************************** 
*               FIN DE                             *
* FUNCIONCITAS DE VALIDACION DE CAPTURA DE NUMEROS *
* QUE NOS MANDARON DEL SIF PARA QUE QUEDE BONITO   *
 ***************************************************/

/**
 * Esta funcion se debe llamar en el evento onsubmit
 * de los formularios que tienen una imagen asociada
 * Esto es especialmente importante cuando hay dos
 * puertos distintos para el Upload y PowerDynamo
 */
function preparaImagen(formulario)
{
	if (formulario.url) {
		if (formulario.url.value.substring(0,1) == "/") {
			formulario.url.value = document.location.protocol
				+ "//" + document.location.host	// host incluye hostname:port
				+ formulario.url.value;
		};
		/*
		** esto va a servir cuando el action tenga el pgSQL por separado.
		** probado con IE6.0, falta IE5.0,5.5 y NS
		var coll = formulario.elements, i, hasImages = false;
		for (i = 0; i < coll.length; i++) {
			var item = coll.item(i);
			var isFile = (item.tagName == "INPUT" || item.tagName == "input")
			          && (item.type == "FILE" || item.type == "file");
			if (isFile && item.value != "") {
				hasImages = true;
				break;
			}
		}
		if (!hasImages) {
			formulario.action = formulario.url.value;
		}
		*/
	}
	
	return true;
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