// Usada para saber cuando es la primera vez que entran
// a la pantalla
var tr1 = null;

// Usada para referenciar al objeto que se quita y pone
var parentObj = null;
var parentRef = null;
var parentTmp = null;

// **************************************************************

function quitaPone(form,Ref,id,bandera){
	var tabla = null;
// RESULTADO
// Quita y pone los objetos de acuerdo a la bandera
// REQUIERE
// formulario
// id:  nombre del tag para los objetos a quitar o poner

// ***************************************************************************
// La primera vez que ingresa a la pantalla recupera las referencias
// de todos los objetos que serán quitados y pintados segun la bandera
// La primera vez estan pintados todos los objetos
// La variable parentXXXX son globales para no perder las referencias
// Los while's son para recuperar el nodo Fila que es el padre del 
// nodo al que se le definio el span. Se manejan filas pues se van a insertar
// y borrar filas enteras (contienen inputs, labels)
// **********************************************************

    var spanRef = document.getElementById(Ref);
    parentRef    = spanRef.parentNode;

    if(tr1 == null ) {
        var spanObj   = document.getElementById(id);
        parentObj     = spanObj.parentNode;    // columna padre del objeto	
					
        while (parentObj.nodeName.toUpperCase() != "TR"){
            parentObj = parentObj.parentNode;		// fila padre del Objeto
        } 				
    } 
	   
	while (parentRef.nodeName.toUpperCase() != "TR")
		parentRef = parentRef.parentNode;				// fila padre del Objeto

	var tablaRef = parentRef.parentNode;
	
	
// ***************************************************************************
    
// ***************************************************************************
// Aqui se recupera el nodo que contiene a todos los inputs
// En realidad como se estan insertando y borrando filas, aqui se recupera
// el nodo tabla, que es el padre de todas las filas y es a quien se le 
// borran e insertan las filas
// Igual que el anterior codigo, se recupera el input, luego la fila padre
// y a la fila padre del input, se le obtiene la tabla padre.
// ***************************************************************************
    if(tr1 == null ) {
		var spanTmp   = document.getElementById(id);
		parentTmp = spanTmp.parentNode;
	
		while (parentTmp.nodeName.toUpperCase() != "TR"){
			parentTmp = parentTmp.parentNode;
		}
		
		tabla = parentTmp.parentNode;
	}
// ***************************************************************************    
    
// ***************************************************************************
// Aqui se insertan y borran los objetos fila que contienen los respectivos
// inputs, de acuerdo al banco seleccionado.
// Primero crea las filas correspondientes al banco seleccionado. 
// Es necesario hacer esto primero pues la sentencia insertBefore va a
// insertar antes de un nodo especifico. Este nodo especifico es la fila 
// asociada al banco anterior al actual y que debe ser borrada luego, por
// eso debe existir ese nodo.
// Luego de la insercion de filas, borra la fila que estaba antes.
// Esto lo hace de acuerdo al banco seleccionado.
// ***************************************************************************
    
    // recupera el objeto contra el cual va a comparar
//	var objeto = eval(form+"."+obj)

	if (bandera){
		var NodoObj = parentObj.parentNode;

        if(NodoObj != null)
            tr1 = NodoObj.removeChild(parentObj);		
	}else{
		tr1 = tablaRef.insertBefore(parentObj,parentRef);	
	}

// ***************************************************************************    
}