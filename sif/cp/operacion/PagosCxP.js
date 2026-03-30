

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
	
	frameE.src = "obtenerTipocambio.cfm?form=" + formulario.name + "&EPfecha=" + formulario.EPfecha.value + "&Mcodigo=" + formulario.Mcodigo.value;
}

function setTipoCambio(formulario, valor) {
	formulario.EPtipocambio.value = fm(valor, 4);
}

function validatc(f) {
	if (f.Mcodigo.value == f.monedalocal.value) {
		f.EPtipocambio.value = "1.0000";
		f.EPtipocambio.disabled = true;
	}
	else{
		if (new Number(qf(f.EPtipocambio.value)) == 1)
			f.EPtipocambio.value = "0.0000";
		f.EPtipocambio.disabled = false;
	}
}   

function validatcLOAD(f) {
	if (f.haydetalle.value == "SI") {
		f.EPtipocambio.disabled = true
	} else {
		if (f.Mcodigo != null && f.Mcodigo.value == f.monedalocal.value) {
			f.EPtipocambio.value = "1.0000"
			f.EPtipocambio.disabled = true
		}
	}
	f.EPtipocambio.value = fm(f.EPtipocambio.value, 4);
}   

function sugerirMonto(f) {
	f.DPmontodoc.value = fm(f.Dsaldo.value, 2);
	if (f.FC.value == "encabezado") {
		if ((new Number(qf(f.DisponibleLabel.value)) * new Number(qf(f.EPtipocambio.value))) <= new Number(qf(f.Dsaldo.value))) {
			f.DPtotal.value = fm(f.DisponibleLabel.value, 2);
		} else {
			f.DPtotal.value = fm(new Number(qf(f.Dsaldo.value)) / new Number(qf(f.EPtipocambio.value)), 2);
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

function obtieneValores(f, valor) {
	f.DPtotal.disabled = false;
	if (valor != "") {
		var p = valor.split("|");
		f.Mcodigod.value = p[0];
		f.IDdocumento.value = p[2];
		f.Ccuentad.value = p[3];
		//f.Ptipocambio.value = p[4];
		f.DPmontodoc.value="0.00";
		f.DPtotal.value="0.00";
		f.Dsaldo.value = fm(p[5],2);
		f.DsaldoLabel.value = fm(p[5],2);
		f.CcuentadLabel.value = p[6];

		if (p[7] == "") f.DPmontoretdoc.disabled = true;
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
// Modif: Ana villavicencio Fecha: 27 de setiembre del 2005
// Se agrego la funcion de redondear para corregir error en la aplicacion del documento
function validaSaldo(f) {
	if (f.FC.value == "encabezado") {
		f.DPmontodoc.value = redondear(parseFloat(qf(f.DPtotal.value))*100 * parseFloat(qf(f.EPtipocambio.value))*100 / 10000,2);
		fm (f.DPmontodoc, 2);
	} else if (f.FC.value == "iguales") {
		f.DPmontodoc.value = f.DPtotal.value;
	}
}

// f es un objeto de QForms 
function validaForm(f) {
	if (btnSelected("Generar")) {
		Generar(f);
		return false;
	}
	if (btnSelected("Aplicar")) {
		if (f.Balance.obj.value != "1") {
			alert("El documento todavía no puede aplicarse porque no está balanceado!");
			return false;
		}
		return confirm("¿Está seguro de que desea aplicar el documento de pago?");
	}
	if (btnSelected("AgregarE") || btnSelected("AgregarD") || btnSelected("CambiarD")) {
		f.EPtipocambio.obj.disabled = false;
		f.EPtipocambio.obj.value = qf(f.EPtipocambio.obj.value);
		f.EPtotal.obj.value = qf(f.EPtotal.obj.value);
	}
	if (btnSelected("AgregarD") || btnSelected("CambiarD") || btnSelected("CambiarE")  ) {
		f.EPtipocambio.obj.disabled = false;
		f.EPtipocambio.obj.value = qf(f.EPtipocambio.obj.value);
		f.EPtotal.obj.value = qf(f.EPtotal.obj.value);
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

function cambioCuenta(f) {
	if (f.CuentaBanco.length > 0) {
		var t = f.CuentaBanco.value.split("|");
		f.CBid.value = t[0];
		f.Ccuenta.value = t[1];
		f.Cformato.value = t[2];
		f.Cdescripcion.value = t[3];
		f.Ocodigo.value = t[4];
		f.OcodigoLabel.value = t[5];
		f.Mcodigo.value = t[6];
		f.McodigoLabel.value = t[7];
	}
}

function Generar(f) {
	//Modificado por:Ana Villavicencio se agregó un parametro mas al URl, elSNcodigo para tomarlo en cuenta para 
	//la asignacion de la cuenta para el documento del anticipo.
	//30/08/2005 se agregó un nuevo campo en EPagosCxP(id_direccion) para el registro del anticipo.
	 window.open("Anticipo.cfm?IDpago="+f.IDpago.obj.value, "genAnticipo", "left=200,top=200,scrollbars=no,resizable=no,width=700,height=450");
}

function obtenerTC(f) {
	if (f.Mcodigo.value == f.monedalocal.value) {
		f.EPtipocambio.value = "1.0000";
		f.EPtipocambio.disabled = true;
	} else if (f.haydetalle.value == "NO") {
		getTipoCambio(f);
		validatc(f);
	}
}

function obtenerTransacciones(f) {
	var a = f.Transaccion.value.split("|");
	f.CPTcodigo.value = a[0];
	f.BTid.value = a[1];
	f.EPtipopago.value = a[3];
	f.EPtipopagoLabel.value = a[4];
}

function obtenerDisponible(f) {
	alert(qf(f.EPtotal_anterior.value));
	alert(qf(f.ta.value));
	alert(qf(f.DetalleLabel.value));
	f.DisponibleLabel.value = fm(new Number(qf(f.EPtotal_anterior.value)) - (new Number(qf(f.ta.value)) + new Number(qf(f.DetalleLabel.value))),2);
	alert(f.DisponibleLabel.value);
}