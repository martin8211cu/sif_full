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

/* Elimina los espacios blancos cuando en el objeto no se ha digitado nada  */
function validaBlancos(obj){	
		obj.value = obj.value.replace(/^\s*/g,"");
}

/* Elimina los espacios blancos intermedios de un objeto textbox  */
function quitaBlancos(obj){
	obj.value = strReplace(obj.value,' ','');
}

