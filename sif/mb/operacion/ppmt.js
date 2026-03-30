/////////////////////////////////////////////
// FUNCION PARA PROBAR EL CALCULO DEL PPMT //
/////////////////////////////////////////////
function tst(){
  var rate = 5.42/12/100;
  var tpmt=PMT(rate,120,39000000);
  var tipmt=IPMT(39000000,tpmt,rate,1)
  var tppmt=PPMT(rate,2,120,39000000,0,0)
  alert(tppmt);
}

/////////////////////////////////////
// FUNCIONES PARA CALCULAR EL PPMT //
/////////////////////////////////////
function PMT(rate,nper,pv){
  var pvif = Math.pow(1 + rate, nper);
  var pmt = Math.round(rate / (pvif - 1) * (pv * pvif)*100)/100;
return pmt;
}

function IPMT(pv, nper, rate, per) {
  var tmp = Math.pow(1 + rate, (per-1));
return  Math.round(((pv * (tmp-1) / rate + pv * tmp )*rate)*100)/100;
}
 
function PPMT(rate, per, nper, pv) {
  var pmt = PMT(rate, nper, pv);
  var ipmt = IPMT(pv, nper, rate, per);
return pmt - ipmt;
}