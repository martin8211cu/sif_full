// pLista1 POR EL MOMENTO GENERICO QUE PINTA LA LISTA
//PROCESA LA LISTA CUANDO SE TRATA DE LIGAS , ENVIA UN VALOR GLOBAL PARA CADA 
//UNA DE LAS COLUMNAS , ESTAS DEBEN SER CONOCIDAS EN LA  FORMA DE DESTINO
function Procesar(val,posA, fname, irA){
		//NUMERO DE COLUMNAS PASAN A UN ARREGLO
		var columnas = new String(document.forms[fname].columnas.value);
		var arrColumnas = columnas.split(',');

		//PARA CADA UNA OBTENGO EL VALOR CORRESPONDIENTE
		for(var i=0; i < arrColumnas.length; i++){
				var colAsig =arrColumnas[i];
				eval('document.forms[fname].'+arrColumnas[i].toUpperCase()+'.value=document.forms[fname].'+arrColumnas[i].toUpperCase()+'_'+val+'.value');
		}
		document.forms[fname].modo.value="CAMBIO";
		if (irA != null) {
			document.forms[fname].action = irA;
		}
		document.forms[fname].submit();
}
  