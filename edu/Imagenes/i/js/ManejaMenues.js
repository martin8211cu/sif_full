function sobre(src,Color) {
    src.bgColor = Color;
}

function fuera(src,Color2) {
    src.bgColor = Color2;
}

function mouseabajo(src,clase) {
    src.className = clase;
}

function mousearriba(src,clase) {
    src.className = clase;
}

function hundir1(src) {
    src.className = "bordeHundidoMasInterno";
}

function levantar1(src) {
    src.className = "bordeInterno";
}

function hundir2(src) {
    src.className = "bordeHundidoInterno";
}

function levantar2(src) {
    src.className = "bordeMasInterno";
}

function sobre1(src,Color) {
    if (src.contains(event.fromElement)) {
        src.background= Color;}
}

function fuera1(src,Color2) {
    if (!src.contains(event.toElement)) {
        src.background= Color2;}
}

