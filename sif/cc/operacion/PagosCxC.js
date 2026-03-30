botonActual = "";

function setBtn(boton) {
    botonActual = boton.name;
}

function btnSelected(name) {
    return (botonActual == name)
}

// Funciones para el lost focus del contrato
function getTipoCambio(formulario) {
	var frameE = document.getElementById("frameExec");
	frameE.src = "obtenerTipocambio.cfm?form=" + formulario.name + "&EPfecha=" + formulario.Pfecha.value + "&Mcodigo=" + formulario.Mcodigo.value;
}

function setTipoCambio(formulario, valor) {
	formulario.Ptipocambio.value = fm(valor, 4);
}

function validatc(f) {
	if (f.Mcodigo.value == f.monedalocal.value) {
		f.Ptipocambio.value = "1.0000";
		f.Ptipocambio.disabled = true;
	}
	else{
		if (new Number(qf(f.Ptipocambio.value)) == 0)
			f.Ptipocambio.value = "1.0000";
	   	f.Ptipocambio.disabled = false;
	}
}   

function validatcLOAD(f) {
	if (f.haydetalle.value == "SI") {
		f.Ptipocambio.disabled = true
	} else {
		if (f.Mcodigo != null && f.Mcodigo.value == f.monedalocal.value) {
			f.Ptipocambio.value = "1.0000"
			f.Ptipocambio.disabled = true
		}
	}
	f.Ptipocambio.value = fm(f.Ptipocambio.value, 4);
}   

function obtieneValores(f, valor) {
	f.DPtotal.disabled = false;
	if (valor != "") {
		var p = valor.split("|");
		f.Mcodigod.value = p[0];
		f.CCTcodigod.value = p[1];
		f.Ddocumento.value = p[2];
		f.Ccuentad.value = p[3];
		//f.DPtipocambio.value = p[4];
		f.DPmontodoc.value="0.00"
		f.DPtotal.value="0.00"
		if(parseFloat(qf(p[9],2)) < parseFloat(qf(p[5],2))){//si (9)saldo < (5)cuota pinte saldo si no pinte cuota. Si (5)cuota < (9)saldo pero cuota = 0 pinte saldo
			f.Dsaldo.value = fm(p[9],2);
			}
		else {
				if (parseFloat(qf(p[5],2)) < parseFloat(qf(p[9],2)) && parseFloat(qf(p[5],2)) == 0){
						f.Dsaldo.value = fm(p[9],2);
					}
				else{
					f.Dsaldo.value = fm(p[5],2);
				}
			}
		f.DsaldoLabel.value = fm(p[9],2);
		f.CcuentadLabel.value = p[6];
		f.PPnumero.value = p[8];

		if (p[7] == "%") f.DPmontoretdoc.disabled = true;
		else f.DPmontoretdoc.disabled = false;
		
		if (f.Mcodigod.value == f.Mcodigo.value) {
			// LA MONEDA DEL DOCUMENTO ES IGUAL A LA DEL ENCABEZADO
			f.DPmontodoc.disabled = true;
			f.FC.value = "iguales";
		} else {
			if (f.monedalocal.value != f.Mcodigod.value) {
				// LA MONEDA LOCAL ES DIFERENTE A LA DEL DOCUMENTO
				f.DPmontodoc.disabled = false;
				f.FC.value = "calculado";
        //29082018 - MEGS: Unicamente se mostrará el TC si las monedas son diferentes.
				document.getElementById("idTrTC").style.display = "";
				document.getElementById("TipoCambioMonExt").value = parseFloat(p[10]).toFixed(4);
			} else {
				// LA MONEDA LOCAL ES IGUAL A LA DEL DOCUMENTO
				f.DPmontodoc.disabled = true;
				f.FC.value = "encabezado";                                
			}
		}
		sugerirMonto(f);
	}
	else {
		//alert('No tiene Documentos para Pagar!');
		// Deshabilitar Botones
	}
}   

function sugerirMonto(f) {
	f.DPmontodoc.value = fm(f.Dsaldo.value, 2);
	var lVarTCExt =  document.getElementById("TipoCambioMonExt").value;
	var lVarmontoMonExt =  document.getElementById("DPmontodoc").value.replace(",", "");
	document.getElementById("DPtotal").value = parseFloat(parseFloat(lVarmontoMonExt) * lVarTCExt).toFixed(4);
	if (f.FC.value == "encabezado") {
		if ((new Number(qf(f.DisponibleLabel.value)) * new Number(qf(f.Ptipocambio.value))) <= new Number(qf(f.Dsaldo.value))) {
			f.DPtotal.value = fm(f.DisponibleLabel.value, 2);
		} else {
			f.DPtotal.value = fm(new Number(qf(f.Dsaldo.value)) / new Number(qf(f.Ptipocambio.value)), 2);
		}
	} else if (f.FC.value == "iguales") {
		if (new Number(qf(f.DisponibleLabel.value)) <= new Number(qf(f.Dsaldo.value))) {
			f.DPtotal.value = fm(f.DisponibleLabel.value, 2);
		} else {
			f.DPtotal.value = fm(f.Dsaldo.value, 2);
		}
	} 
	validaSaldo(f);
}

function validaSaldo(f) {
	if (f.FC.value == "encabezado") {
		f.DPmontodoc.value = parseFloat(qf(f.DPtotal.value))*100 * parseFloat(qf(f.Ptipocambio.value))*100 / 10000;
		fm (f.DPmontodoc, 2);
	} else if (f.FC.value == "iguales")
		f.DPmontodoc.value = f.DPtotal.value;
}

// f es un objeto de QForms 

//Modificado por: Ana Villavicencio
//Fecha: 23 de febrero del 2006
//Motivo: se abrego la validacion del boton CambiarE, cambio de encabezado
function validaForm(f) {
	if (btnSelected("Generar")) {
		Generar(f);
		return false;
	}
	if (btnSelected("Aplicar")) {
		if (f.Balance.obj.value != "1") {
			alert(MSG_DoctoNoBal);
			return false;
		}
		return confirm(MSG_DeseaAplDocCobr);
	}
if (btnSelected("AgregarE") || btnSelected("AgregarD") || btnSelected("CambiarD") ||  btnSelected("CambiarE")) {
		f.CCTcodigo.obj.disabled = false;
		f.Ptipocambio.obj.disabled = false;
		f.Ptipocambio.obj.value = qf(f.Ptipocambio.obj.value);
		f.Ptotal.obj.value = qf(f.Ptotal.obj.value);
	}

if (btnSelected("AgregarD") || btnSelected("CambiarD") || btnSelected("CambiarE")) {
		f.Ptipocambio.obj.disabled = false;
		f.Ptipocambio.obj.value = qf(f.Ptipocambio.obj.value);
		f.DPmontoretdoc.obj.value = qf(f.DPmontoretdoc.obj.value);
		f.DPmontodoc.obj.value = qf(f.DPmontodoc.obj.value);
		f.DPtotal.obj.value = qf(f.DPtotal.obj.value);
		f.montoret.obj.value = qf(f.DPmontoretdoc.obj.value);
		f.DPmontodoc.obj.disabled = false;
		if (f.DPmontoretdoc.obj.disabled) {
			f.montoret.obj.value = "0.00";
		}
		f.DPmontoretdoc.obj.disabled = false;
	}
	return true;
}

function Generar(f) {
	 window.open("Anticipo.cfm?Pcodigo="+f.Pcodigo.obj.value+"&CCTcodigo="+f.CCTcodigo.obj.value, "genAnticipo", "left=200,top=200,scrollbars=no,resizable=no,width=700,height=450");
}

function obtenerTC(f) {
	if (!f){
		var f = document.form1;
		}
	if (f.Mcodigo.value == f.monedalocal.value) {
		f.Ptipocambio.value = "1.0000";
		f.Ptipocambio.disabled = true;
	} else if (f.haydetalle.value == "NO") {
		getTipoCambio(f);
		validatc(f);
	}
}

function obtenerDisponible(f) {
	f.DisponibleLabel.value = fm((parseFloat(qf(f.Ptotal_anterior.value)*100) - (parseFloat(qf(f.ta.value)*100) + parseFloat(qf(f.DetalleLabel.value)*100)))/100,2);
}
function calcularMontoAPagar(monto){
	var lVarmontoMonExt =  document.getElementById("DPmontodoc").value.replace(",", "");
	var lVarTCExt =  document.getElementById("TipoCambioMonExt").value;
	document.getElementById("DPtotal").value = parseFloat(parseFloat(lVarmontoMonExt) * lVarTCExt).toFixed(4);
}