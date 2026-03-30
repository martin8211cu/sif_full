// Elimina los espacios en blanco de la izquierda de un campo
function ltrim(tira)
{
		var CARACTER="",HILERA=""
		 if (tira.name){
		 			VALOR=tira.value}
		 else{
		 			VALOR=tira}
		 
		HILERA=VALOR
		INICIO = VALOR.lastIndexOf(" ")
		
		if(INICIO>-1){
		
				  for (var i=0; i<VALOR.length; i++){
				   
							 CARACTER=VALOR.substring(i,i+1);
							 if (CARACTER!=" "){
							 
								   HILERA = VALOR.substring(i,VALOR.length)
								   i = VALOR.length      
							 }
				  }
		}
		 return HILERA
}
//-----------------------------------------------------------------------------------------------------------

// Elimina los espacios en blanco de la derecha de un campo
function rtrim(tira){

			if (tira.name){
					VALOR=tira.value}
			 else{
			 		VALOR=tira}

			var CARACTER=""
			var HILERA=VALOR
			INICIO = VALOR.lastIndexOf(" ")
			
			if(INICIO>-1){
			
						 for(var i=VALOR.length; i>0; i--){  
						 
									 CARACTER= VALOR.substring(i,i-1)
									 if(CARACTER==" ")
												HILERA = VALOR.substring(0,i-1)
									 else
												i=-200
						  }
			   }
			  return HILERA
}
//-----------------------------------------------------------------------------------------------------------

// Elimina los espacios en blanco de la izquierda y de la derecha de un campo
function trim(tira) {

		return ltrim(rtrim(tira))
}
//-----------------------------------------------------------------------------------------------------------

//Convierte el valor de un objeto de minusculas a mayusculas
//Ejemplo: txt_campo.value="abc",	UpperCase(txt_campo) ==> "ABC"
function UpperCase(Obj){

			if(Obj.name){
			
			  if(Obj.value!=""){
			  			Obj.value=Obj.value.toUpperCase();}
			  			return;
			  }
			 else{
			 			return Obj.toUpperCase();
			 }
}
//-----------------------------------------------------------------------------------------------------------

// Limpia el valor de un objeto
// Soporta objetos tipo text,password,combo(de seleccion unica) , checkbox y textareas
function clean(obj) {

			var tipo = obj.type
			
			if (tipo=="text") {
				obj.value=''; 
				return false;
			} 
			else 
				if (tipo=="textbox") {
						obj.value=''; 
						return false;
				} 
				else 
						if (tipo=="password") {
								obj.value=''; 
								return false;
						} 
						else 
								if (tipo=="select-one") {
										obj.selectedIndex=-1; 
										return false;
								} 
								else 
										if (tipo=="checkbox") {
												obj.checked=false; 
												return false;
										} 
										else 
												if (tipo=="textarea") {
														obj.value=''; 
														return false;
											   }
}
//-----------------------------------------------------------------------------------------------------------

//Convierte el valor de un objeto que tiene una fecha en formato dd/mm/yyyy en el formato para Sybase (yyyymmdd) 
//recibe el objeto
function sd(FECHA){

		if(FECHA.value){
				FECHA=FECHA.value
		}
			dia = FECHA.substring(0, 2)
			mes = FECHA.substring(3, 5)
			ano = FECHA.substring(6, 10)
			return (ano+mes+dia)
}
//-----------------------------------------------------------------------------------------------------------

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
//-----------------------------------------------------------------------------------------------------------

//Recibe el objeto o hilera numerica
function sen(obj)
{
		  var tirax=""
		  tirax = trim(obj)
		  if (tirax.length == 0) {return "null"}
		  else {return tirax}
}
//-----------------------------------------------------------------------------------------------------------
 
//Recibe el objeto o hilera de caracteres (le pone comillas '')
function scm(obj)
{
		  var tirax=""
		  tirax = trim(obj)
		  if (tirax != "")
		  {return "'"+tirax+"'"}
		   else
		  {return "null"} 
}
//-----------------------------------------------------------------------------------------------------------

// Modificaciones
// Autor: José María Calvo Lon
// Fecha: 25 de abril 2001
// Motivo: Poder pasar tildes y caracteres especiales por un URL
function formatURL(aString) {
	var tempString = "";
	
	// Los % se reemplazan primero por un caracter de escape, ya que de lo contrario nos enciclamos
	
	while (tempString != aString) {
		tempString = aString;
		aString = tempString.replace("%","\\25");		
	}	

	// Reemplazamos el caracter especial por porcentaje
	// Además cambiar todos los +
	tempString = "";
	while (tempString != aString) {
		tempString = aString;
		aString = tempString.replace("\\","%");	
		aString = aString.replace("+","%2B");
	}	

	// Finalmente los restantes caracteres especiales
	tempString = "";
	while (tempString != aString) {		
		tempString = aString;
		aString = tempString.replace("Á","%C1");
		aString = aString.replace("á","%E1");
		aString = aString.replace("ä","%E4");
		aString = aString.replace("É","%C9");
		aString = aString.replace("é","%E9");
		aString = aString.replace("ë","%EB");
		aString = aString.replace("Í","%CD");
		aString = aString.replace("í","%ED");
		aString = aString.replace("ï","%EF");
		aString = aString.replace("Ó","%D3");
		aString = aString.replace("ó","%F3");
		aString = aString.replace("ö","%F6");
		aString = aString.replace("Ú","%DA");
		aString = aString.replace("ú","%FA");
		aString = aString.replace("ü","%FC");
		aString = aString.replace("Ñ","%D1");
		aString = aString.replace("ñ","%F1");
		aString = aString.replace("/","%2F");
		aString = aString.replace("'","%27");
		aString = aString.replace(" ","%20");
		aString = aString.replace("&","%26");		
		aString = aString.replace(",","%2C");
		aString = aString.replace(":","%3A");
		aString = aString.replace("?","%3F");
		aString = aString.replace("@","%40");
		aString = aString.replace(">","%3E");
		aString = aString.replace("<","%3C");
		aString = aString.replace("=","%3D");
		aString = aString.replace(".","%2E");
		aString = aString.replace("#","%23");
		// Agregar los que sean necesario!!!!
	}
	return aString;
}
//-----------------------------------------------------------------------------------------------------------

// Modificaciones
// Autor: José María Calvo Lon
// Fecha: 28 de junio 2001
// Motivo: la inversa de  foramtURL
function deformatURL(aString) {
	var tempString = "";
	
	// los caracteres especiales
	tempString = "";
	while (tempString != aString) {		
		tempString = aString;
		aString = tempString.replace("%C1","Á");
		aString = aString.replace("%E1","á");
		aString = aString.replace("%E4","ä");
		aString = aString.replace("%C9","É");
		aString = aString.replace("%E9","é");
		aString = aString.replace("%EB","ë");
		aString = aString.replace("%CD","Í");
		aString = aString.replace("%ED","í");
		aString = aString.replace("%EF","ï");
		aString = aString.replace("%D3","Ó");
		aString = aString.replace("%F3","ó");
		aString = aString.replace("%F6","ö");
		aString = aString.replace("%DA","Ú");
		aString = aString.replace("%FA","ú");
		aString = aString.replace("%FC","ü");
		aString = aString.replace("%D1","Ñ");
		aString = aString.replace("%F1","ñ");
		aString = aString.replace("%2F","/");
		aString = aString.replace("%27","'");
		aString = aString.replace("%20"," ");
		aString = aString.replace("+"," ");
		aString = aString.replace("%26","&");		
		aString = aString.replace("%2C",",");
		aString = aString.replace("%3A",":");		
		aString = aString.replace("%3F","?");
		aString = aString.replace("%40","@");		
		aString = aString.replace("%3E",">");
		aString = aString.replace("%3C","<");
		aString = aString.replace("%3D","=");
		aString = aString.replace("%2E",".");
		aString = aString.replace("%23","#");
		// Agregar los que sean necesario!!!!
	}

	// Reemplazamos el caracter especial por porcentaje
	// Además cambiar todos los +
	// Los % se reemplazan primero por un caracter de escape, ya que de lo contrario nos enciclamos
	tempString = "";
	while (tempString != aString) {
		tempString = aString;
		aString = aString.replace("%2B","+");
		aString = tempString.replace("\\25","%");		
	}
	return aString;
}

//------------------------------------------------------------------------------------------	