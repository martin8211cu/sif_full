var arregloGRcodigo = new Array();
var arregloCcodigo = new Array();
var arregloDescripcion = new Array();

var arregloNcodigo = new Array();
var arregloPEcodigo = new Array();
var arregloPEdescripcion = new Array();


// Esta función únicamente debe ejecutarse una vez
function ObtenerCodigosCursos(Combo) {
    var pos, ppz;
    for(var i=0; i<Combo.length; i++) {
        // Códigos de los detalles
        arregloCcodigo[i] = Combo.options[i].value;
        // Texto que incluye el Código del Grupo, separador y el texto del Curso
        ppz=Combo.options[i].text;
        pos=ppz.indexOf('$');
        if (pos!=0) {
            arregloGRcodigo[i]=ppz.substring(0,pos);
        } else {
            arregloGRcodigo[i]="";
        }
        arregloDescripcion[i]=ppz.substring(pos+1,ppz.length);
    }
    // Se limpia el Combo y se vuelve a llenar con solamente el Texto
    for (var i=arregloDescripcion.length-1 ; i>=0; i--) {
        Combo.options[i]=null;
    }
    for (var i=0 ; i < arregloDescripcion.length ; i++) {
        var nuevaOpcion = new Option(arregloDescripcion[i],arregloCcodigo[i]);
        Combo.options[i]=nuevaOpcion;
    }
}

// Esta función es para rellenar el combo hijo a partir del valor seleccionado en el combopadre
function RellenarComboHijo(combopadre,combohijo, sel) {
    var temp = combopadre.value.split('$');
    var padre = temp[1];
    var nivelpadre = temp[0];
    
    // Se limpia el combo hijo
    for (var i=combohijo.length ; i >= 0; i--) {
        combohijo.options[i]=null;
    }
    
    // Se cargan únicamente los hijos que corresponden al padre seleccionado
    //combohijo.options[0] = new Option("(Ninguno)", "0");
    var j=0;
    for (var i=0; i < arregloGRcodigo.length; i++) {
        // Si el padre corresponde al valor del padre seleccionado en el combo entonces se agrega la opcion en el combo hijo
        var temp = arregloCcodigo[i].split('$');
        var hijo = temp[1];
        var nivelhijo = temp[0];
        if ((padre == arregloGRcodigo[i]) && (nivelpadre == nivelhijo)) {
            var nuevaOpcion = new Option(arregloDescripcion[i],hijo);
            combohijo.options[j]=nuevaOpcion;
            // Si el valor del hijo creado corresponde al valor buscado
            if (hijo == sel) {
                combohijo.selectedIndex=j;
            }
            j++;
        }
    }
}


// Esta función únicamente debe ejecutarse una vez
function ObtenerCodigosPeriodos(Combo) {
    var pos, ppz;
    for(var i=0; i<Combo.length; i++) {
        // Códigos de los detalles
        arregloPEcodigo[i]=Combo.options[i].value;
        // Texto que incluye el Código del Grupo, separador y el texto del Curso
        ppz=Combo.options[i].text;
        pos=ppz.indexOf('$');
        if (pos!=0) {
            arregloNcodigo[i]=ppz.substring(0,pos);
        } else {
            arregloNcodigo[i]="";
        }
        arregloPEdescripcion[i]=ppz.substring(pos+1,ppz.length);
    }
    // Se limpia el Combo y se vuelve a llenar con solamente el Texto
    for (var i=arregloPEdescripcion.length-1 ; i>=0; i--) {
        Combo.options[i]=null;
    }
    for (var i=0 ; i < arregloPEdescripcion.length ; i++) {
        var nuevaOpcion = new Option(arregloPEdescripcion[i],arregloPEcodigo[i]);
        Combo.options[i]=nuevaOpcion;
    }
}

// Esta función es para rellenar el combo hijo a partir del valor seleccionado en el combopadre
function RellenarComboPeriodos(combopadre,combohijo, sel) {
    var temp = combopadre.value.split('$');
    var padre = temp[0];
    
    // Se limpia el combo hijo
    for (var i=combohijo.length ; i >= 0; i--) {
        combohijo.options[i]=null;
    }
    
    // Se cargan únicamente los hijos que corresponden al padre seleccionado
    //combohijo.options[0] = new Option("(Ninguno)", "0");
    var j=0;
    for (var i=0; i < arregloNcodigo.length; i++) {
        // Si el padre corresponde al valor del padre seleccionado en el combo entonces se agrega la opcion en el combo hijo
        if (padre == arregloNcodigo[i]) {
            var nuevaOpcion = new Option(arregloPEdescripcion[i],arregloPEcodigo[i]);
            combohijo.options[j]=nuevaOpcion;
            // Si el valor del hijo creado corresponde al valor buscado
            if (arregloPEcodigo[i] == sel) {
                combohijo.selectedIndex=j;
            }
            j++;
        }
    }
}

