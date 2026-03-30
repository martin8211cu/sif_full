var Lvargrafica;
function MovDestinoFunc(){ 	// Toma el valor seleccionado del Select de origen y lo pasa al Select destino
	 if ($('.ColReporteOrigen option').length != 1)	
	{
		$('.ColReporteOrigen option:selected').remove().appendTo('.ColReporteDestino');	//elimina el option seleccionado y despues lo agrega a la columna destino	
		$('.ColReporteDestino').attr('size', $('.ColReporteDestino option').length+2);	//captura el tañamo del Select de Destino y agrega y elimina uno a los Select relacionados como Destiono Origen
		//$('.ColReporteOrigen').attr('size', $('.ColReporteOrigen option').length-0);
	}else{
		alert("Es necesario dejar en la columna de origen al menos un campo");
	}
}

function MovOrigenFunc(){ 
		$('.ColReporteDestino option:selected').remove().appendTo('.ColReporteOrigen'); //elimina el option seleccionado y despues lo agrega a la columna origen
		$('.ColReporteOrigen').attr('size', $('.ColReporteOrigen option').length+2);
		//$('.ColReporteDestino').attr('size', $('.ColReporteDestino option').length-0);
}

function creaNuevo(){
	var LvarID = 0;
	$.ajax({
	    url : "../../commons/Componentes/PrintWizard.cfc?method=creaVersion",
	    type: "POST",
	    success: function(result){
	    	LvarID = result;
	    	loadPage(1,LvarID);
	    },
	    error: function (request, error) {
	        alert("Error Inesperado");
	    }
	});
}

function loadPage(LvarPage,lvarIdV){
	$.ajax({
	    url : "../../commons/Componentes/PrintWizard.cfc?method=getPage",
	    type: "POST",
	    data : {
	    	page: LvarPage,
	    	versionId: lvarIdV

	    },
	    success: function(result){
	    	$(".wizContent").html(result);
	    },
	    error: function (request, error) {
	        alert("Error Inesperado");
	    }
	});
}

function editar(varIdV){
	loadPage(1,varIdV);
}

function compartir(varIdV){
	$.ajax({
		type: "GET",
		url: "../../commons/Componentes/PrintWizard.cfc?method=showUsers&idVer="+varIdV,
		success: function(result){
	        $("#popupUsuarios").html(result);
	    }
	});

	$("#popupUsuarios").dialog({
        width: 520,
        modal:true,
        title:"Compartir",
        height: 400,
        resizable: "false",
    });
}

function copiarVersion(varIdV){	
	$.ajax({
	    url : "../../commons/Componentes/PrintWizard.cfc?method=copiaVersion",
	    type: "POST",
	    data: {
	    	versionid: varIdV
	    },
	    success: function(result){
	    	loadPage(0,varIdV);
	    },
	    error: function (request, error) {
	        alert("Error Inesperado");
	    }
	});
}

function eliminar(varIdV){	
	$.ajax({
	    url : "../../commons/Componentes/PrintWizard.cfc?method=eliminaVersion",
	    type: "POST",
	    data: {
	    	rtp_vid: varIdV
	    },
	    success: function(result){
	    	loadPage(0,varIdV);
	    },
	    error: function (request, error) {
	        alert("Error Inesperado");
	    }
	});
	
}


function regresar(page,varIdV){
	if(page == 4 && Lvargrafica =='ND'){	//valida que el retorno a la ventana campos de la grafica solo aparecezca cuando se configuró con grafica
		    loadPage(page-1,varIdV);	    			
		}else{
		    loadPage(page,varIdV);	
	}
}

function imprimir(vid){
	var lvarDesc  = $('.txtDesc').val();
	
	$.ajax({
	    url : "../../commons/Componentes/PrintWizard.cfc?method=actualizaVersion",
	    type: "POST",
	    data: {
	    	descripcion: lvarDesc
	    },
	    success: function(result){
	    	var url = '../../commons/GeneraReportes/Imprimir.cfm?idver=' + vid;
			window.open(url, '_blank');
			//location.reload(true);
	    },
	    error: function (request, error) {
	        alert("Error Inesperado");
	    }
	});
}

function doCompartir(lvarIdV){
    var datos = $( "form" ).serialize();
	$.ajax({
	    url : "../../commons/Componentes/PrintWizard.cfc?method=doCompartir",
	    type: "POST",
	    data : {
	    		versionid: lvarIdV,
	    		datosform: datos
	    },
	    success: function(result){
	    	$('#popupUsuarios').dialog('close');
	    },
	    error: function (request, error) {
	        alert("Error Inesperado");
	    }
	});
	
}

function toogleUsers(obj) {
	var a = $( "#chkAllUser" ).prop( "checked");
	var checkboxes = $('.chkUser');
	if(a){
		checkboxes.prop('checked', true);
    } else {
        checkboxes.prop('checked', false);
    }
}

//Actualizamos el campo MostrarTotal
function UpdateMostrarTotal(LvarPage,lvarIdV){
	var LvarMT = -1;
	
	if (document.getElementById( "MostrarTotal")) {
		var LvarMT =document.getElementById("MostrarTotal").checked;
	}
	
	$.ajax({
	    url : "../../commons/Componentes/PrintWizard.cfc?method=UpMosTotal",
	    type: "POST",
	    data : {
	    	IdV: lvarIdV,
	    	LvarMT: LvarMT
	    },
	    success: function(result){
	    	loadPage(LvarPage,lvarIdV);
	    	//$(".wizContent").html(result);
	    },
	    error: function (request, error) {
	        alert("Error Inesperado");
	    }
	});
	
}

function saveVar(LvarPage,lvarIdV){
	$.ajax({
	   	type: 'POST',
	   	url : "../../commons/Componentes/PrintWizard.cfc?method=saveVariables",
		data: $("#FormSaveVar").serialize(),
		success: function(results) {
			//$(".wizContent").html(results);
			loadPage(LvarPage,lvarIdV);
		},
	    error: function(results) {
	    	//console.log(results);
	    }
	});
	
}

function eliminaCampo(idD,vid){
	$.ajax({
	    url : "../../commons/Componentes/PrintWizard.cfc?method=eliminaCampo",
	    type: "POST",
	    data : {
	    	idcampo: idD
	    },
	    success: function(result){
	    	loadPage(4,vid);
	    },
	    error: function (request, error) {
	        alert("Error Inesperado");
	    }
	});
}

function agregaCampo(campo,tipo,vid,Tgrafica){
	$.ajax({
	    url : "../../commons/Componentes/PrintWizard.cfc?method=agregaCampo",
	    type: "POST",
	    data : {
	    	campo: campo,
	    	tipo: tipo,
	    	LvarGrafica:Tgrafica

	    },
	    success: function(result){
	    	loadPage(4,vid);
	    },
	    error: function (request, error) {
	        alert("Error Inesperado");
	    }
	});
}


function salvaGrafica(vid,vpage,vimprime){
	if (vpage === undefined) {
		vpage = 2;
	} 
	if (vimprime === undefined) {
		vimprime = false;
	} 
	Lvargrafica  = $('input[name="optionsRadios"]:checked').val();
	var varpage = 2;
	if(vpage != 2)
		varpage = vpage
	if(Lvargrafica){
		if(Lvargrafica == "" || Lvargrafica == "ND"){
			Lvargrafica = 'ND';
			//varpage = 3;
		}
	}else{
		Lvargrafica = 'ND';
			//varpage = 3;
	}

	$.ajax({
	    url : "../../commons/Componentes/PrintWizard.cfc?method=actualizaVersion",
	    type: "POST",
	    data: {
	    	grafica: Lvargrafica
	    },
	    success: function(result){
	    	if(vimprime){
	    		fastimprimir(vid,false);
	    	}
	    },
	    error: function (request, error) {
	        alert("Error Inesperado");
	    }
	});

	loadPage(varpage,vid);
}


function fastimprimir(vid,vreload){
	if (vreload === undefined) {
		vreload = true;
	}
	var url = '../../commons/GeneraReportes/Imprimir.cfm?idver=' + vid;
	window.open(url, '_blank');
	if(vreload){
		location.reload(true);
	}
}



function saveColReporte(LvarPage,varIdV){	//Captura y envia los elementos de la columna destino y los checks hacia la funcion saveColReporte
	var optionValues = [];	
	var arrayOption;

		if(optionValues.length !== null){

			$('#ColReporteDestino option').each(function() {	//Por cada option en el elemento itera y agrega el valor en un arreglo	
    			optionValues.push($(this).text());
			});

				for (var i = 0; i < optionValues.length; i++) {		//Itera en el arreglo y genera un string seperado por coma
					var value=optionValues[i];

					if (arrayOption == null){
						arrayOption = value;
					}
						else
							{
								arrayOption = arrayOption+ "," + value;

							}
					}
			}
		else
			{
				arrayOption = "0";
			}

			var chkTotal = ($('.chkTotal:checked').val() === undefined) ? 0 : 1;	//Optiene el valor del checkbox Total
			var chkSubtotal = ($('.chkSubtotal:checked').val() === undefined) ? 0 : 1;

		$.ajax({
			   	type: 'POST',
			   	url : "../../commons/Componentes/PrintWizard.cfc?method=saveColReporte",
					data : {	    	
				    	optionValue: arrayOption,
				    	chkTotalValue: chkTotal,
				    	chkSubtotalValue: chkSubtotal
				    },
		    success: function(result){
		    	loadPage(LvarPage,varIdV);
		    },
		    error: function(results) {
		    	alert("Error Inesperado");
		    }
		});	
}