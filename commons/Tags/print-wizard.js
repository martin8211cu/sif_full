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

function salvaGrafica(vid){
	var Lvargrafica  = $('input[name="optionsRadios"]:checked').val();
	var varpage = 2;
	if(Lvargrafica == ""){
		Lvargrafica = 'ND';
		varpage = 3;
	}
	$.ajax({
	    url : "../../commons/Componentes/PrintWizard.cfc?method=actualizaVersion",
	    type: "POST",
	    data: {
	    	grafica: Lvargrafica
	    },
	    success: function(result){
	    
	    },
	    error: function (request, error) {
	        alert("Error Inesperado");
	    }
	});

	loadPage(varpage,vid);
}

function editar(varIdV){
	loadPage(1,varIdV);
}

function regresar(page,varIdV){
	loadPage(page,varIdV);
}

function fastimprimir(vid){
	var url = '../../sif/ad/GeneraReportes/Imprimir.cfm?idver=' + vid;
	window.open(url, '_blank');
	location.reload(true);
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
	    	var url = '../../sif/ad/GeneraReportes/Imprimir.cfm?idver=' + vid;
			window.open(url, '_blank');
			location.reload(true);
	    },
	    error: function (request, error) {
	        alert("Error Inesperado");
	    }
	});
}

function agregaCampo(campo,tipo,vid){
	$.ajax({
	    url : "../../commons/Componentes/PrintWizard.cfc?method=agregaCampo",
	    type: "POST",
	    data : {
	    	campo: campo,
	    	tipo: tipo

	    },
	    success: function(result){
	    	loadPage(2,vid);
	    },
	    error: function (request, error) {
	        alert("Error Inesperado");
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
	    	loadPage(2,vid);
	    },
	    error: function (request, error) {
	        alert("Error Inesperado");
	    }
	});
}

