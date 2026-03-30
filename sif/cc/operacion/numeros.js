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
	   } else {
		 campo.value=qf(nc)
		}
   } else {
     return nc
   }
}

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
   
