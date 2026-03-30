// pLista1 POR EL MOMENTO GENERICO QUE PINTA LA LISTA
//PROCESA LA LISTA CUANDO SE TRATA DE LIGAS , ENVIA UN VALOR GLOBAL PARA CADA 
//UNA DE LAS COLUMNAS , ESTAS DEBEN SER CONOCIDAS EN LA  FORMA DE DESTINO
function Procesar(val,posA){
		//NUMERO DE COLUMNAS PASAN A UN ARREGLO
		var columnas = new String(document.lista.columnas.value);
		var arrColumnas = columnas.split(',');

		//PARA CADA UNA OBTENGO EL VALOR CORRESPONDIENTE
		for(var i=0; i < arrColumnas.length; i++){
				var colAsig =arrColumnas[i];
				eval('document.lista.'+arrColumnas[i].toUpperCase()+'.value=document.lista.'+arrColumnas[i].toUpperCase()+'_'+val+'.value');			
		} 
		document.lista.cambiarOrden.value = 0;
		document.lista.fila.value = 0;		
		document.lista.submit();
}
  
function subir(val,posA) {

		//NUMERO DE COLUMNAS PASAN A UN ARREGLO
		var columnas = new String(document.lista.columnas.value);
		var arrColumnas = columnas.split(',');
		

		//PARA CADA UNA OBTENGO EL VALOR CORRESPONDIENTE
		for(var i=0; i < arrColumnas.length; i++){
				var colAsig =arrColumnas[i];
				eval('document.lista.'+arrColumnas[i].toUpperCase()+'.value=document.lista.'+arrColumnas[i].toUpperCase()+'_'+val+'.value');		
				
		} 
		document.lista.fila.value = val;		
		document.lista.cambiarOrden.value = 1;
		document.lista.modo.value = "CAMBIO";
		document.lista.submit();
}

function bajar(val,posA) {
		//NUMERO DE COLUMNAS PASAN A UN ARREGLO
		var columnas = new String(document.lista.columnas.value);
		var arrColumnas = columnas.split(',');

		//PARA CADA UNA OBTENGO EL VALOR CORRESPONDIENTE
		for(var i=0; i < arrColumnas.length; i++){
				var colAsig =arrColumnas[i];
				eval('document.lista.'+arrColumnas[i].toUpperCase()+'.value=document.lista.'+arrColumnas[i].toUpperCase()+'_'+val+'.value');			
		} 
		document.lista.fila.value = val;			
		document.lista.cambiarOrden.value = 2;
		document.lista.modo.value = "ALTA";
		document.lista.submit();
}
function Terminar_Cambios(val,posA) {
		//NUMERO DE COLUMNAS PASAN A UN ARREGLO
		var columnas = new String(document.lista.columnas.value);
		var arrColumnas = columnas.split(',');

		//PARA CADA UNA OBTENGO EL VALOR CORRESPONDIENTE
		for(var i=0; i < arrColumnas.length; i++){
				var colAsig =arrColumnas[i];
				eval('document.lista.'+arrColumnas[i].toUpperCase()+'.value=document.lista.'+arrColumnas[i].toUpperCase()+'_'+val+'.value');			
		} 
		document.lista.cambiarOrden.value = 0;
		document.lista.fila.value = 0;
		document.lista.modo.value = "ALTA";
		document.lista.submit();
}