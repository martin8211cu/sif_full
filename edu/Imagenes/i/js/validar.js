/**
 * validaciones genéricas comunes a los formularios generados
 */

function onblurdatetime(elemento)
{
    var f = elemento.value;
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
        dia = parseInt(partes[0], 10); // mama si inicia en 0
    } else {
        // no es fecha
    }
    if (ano < 100) {
        ano += (ano < 50 ? 2000 : 1900);
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
        elemento.value = "";
    }
}

function onblurnumeric(elemento, precision, scale)
{
    var floatValue = parseFloat(elemento.value);
    
    if (isNaN(floatValue) || !isFinite(floatValue)) {
        elemento.value = "";
    } else {
        if (precision == undefined) {
            precision = 18;
        } 
        if (scale == undefined) {
            scale = 0;
        }
    
        var comp = ("" + floatValue).split(".");
        // comp[0] es la parte entera y comp[1] es la parte decimal
        
        // check precision
        if (comp.length >= 1 && comp[0].length > (precision-scale)) {
            alert("Arithmetic overflow: max int part = " + (precision-scale) + " digits");
            elemento.focus();
            comp[0] = comp[0].substring(0, precision-scale);
        }
        
        // check scale
        var zeroes = "00000000000000000000000000000";
        if (scale == 0) {
            floatValue = parseFloat(comp[0]);
        } else if (comp.length == 1) {
            floatValue = comp[0] + "." + zeroes.substring(0, scale);
        } else if (comp.length >= 2) {
            if (comp[1].length > scale) {
                comp[1] = comp[1].substring(0, scale);
            } else if (comp[1].length < scale) {
                comp[1] += zeroes.substring(0, scale-comp[1].length);
            }
            floatValue = comp[0] + "." + comp[1];
        }
        elemento.value = floatValue;
    }
}
onblurdecimal  = onblurnumeric;

function onblurmoney (element)
{
    return onblurnumeric(element,16,2);
}

function onblurreal (element)
{
    return onblurnumeric(element,16,9);
}

function onblurfloat (element)
{
    return onblurnumeric(element,16,9);
}

function onblurdouble_precision (element)
{
    return onblurnumeric(element,16,9);
}

function onblurint(elemento)
{
    var intValue = parseInt(elemento.value);
    if (isNaN(intValue) || !isFinite(intValue)) {
        elemento.value = "";
    } else {
        elemento.value = intValue;
    }
}
onblursmallint = onblurint;
onblurtinyint  = onblurint;

function onblurchar(elemento)
{
}
onblurnchar = onblurchar;
onblurvarchar = onblurchar;
onblurnvarchar = onblurchar;

// falta definir estas
onblurbinary = onblurchar;
onblurvarbinary = onblurchar;
onblurtext      = onblurchar;
onblurbit       = onblurchar;
onblurimage     = onblurchar;
