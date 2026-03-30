function creaNuevoColumna(rtpid){
	$.ajax({
	    url : "/cfmx/commons/GeneraReportes/Componentes/ReporteColumna.cfc?method=seleccionarColumnas",
	    type: "POST",
	    data: {
	    	rtpid: rtpid
	    },
	    success: function(result){
	    	$("#Cols").html(result);
	    },
	    error: function (request, error) {
	        alert("Error Inesperado");
	    }
	});
}
// Nueva tabla de columnas
function creaNuevoColumnaVer(rtpvid){
	document.getElementById("IdBtn").style.visibility = "hidden";
	$.ajax({
	    url : "/cfmx/commons/GeneraReportes/Componentes/ReporteColumna.cfc?method=seleccionarColumnasVer",
	    type: "POST",
	    data: {
	    	rtpvid: rtpvid
	    },
	    success: function(result){
	    	$("#Cols").html(result);
	    },
	    error: function (request, error) {
	        alert("Error Inesperado");
	    }
	});
}

function eliminaColumna(rtpid,rptcId){
	$.ajax({
	    url : "/cfmx/commons/GeneraReportes/Componentes/ReporteColumna.cfc?method=eliminaColumna",
	    type: "POST",
	    data: {
	    	rtpid : 	rtpid,
	    	rtpcid: 	rptcId
	    },
	    success: function(result){
	    	$("#Cols").html(result);
	    },
	    error: function (request, error) {
	        alert('Error Inesperado');
	    }
	});
	
}

function eliminaColumnaVer(rtpvid,rptcId){
	$.ajax({
	    url : "/cfmx/commons/GeneraReportes/Componentes/ReporteColumna.cfc?method=eliminaColumnaVer",
	    type: "POST",
	    data: {
	    	rtpvid: 	rtpvid,
	    	rtpcid: 	rptcId
	    },
	    success: function(result){
	    	$("#Cols").html(result);
	    },
	    error: function (request, error) {
	        alert('Error Inesperado');
	    }
	});
	
}

function insertaColumna(rtpid, odid, campo){
	$.ajax({
	    url : "/cfmx/commons/GeneraReportes/Componentes/ReporteColumna.cfc?method=insertaColumna",
	    type: "POST",
	    data: {
	    	rtpid : 	rtpid,
	    	odid  : 	odid,
	    	campo : 	campo
	    },
	    success: function(result){
	    	$("#Cols").html(result);
	    },
	    error: function (request, error) {
	        alert('Error Inesperado');
	    }
	});
	
}

function insertaColumnaVer(rtpvid, odid, campo){
	$.ajax({
	    url : "/cfmx/commons/GeneraReportes/Componentes/ReporteColumna.cfc?method=insertaColumnaVer",
	    type: "POST",
	    data: {
	    	rtpvid : 	rtpvid,
	    	odid  : 	odid,
	    	campo : 	campo
	    },
	    success: function(result){
	    	$("#Cols").html(result);
	    },
	    error: function (request, error) {
	        alert('Error Inesperado');
	    }
	});
	
}

function regresarColumna(rtpid){
	$.ajax({
	    url : "/cfmx/commons/GeneraReportes/Componentes/ReporteColumna.cfc?method=getColumnas",
	    type: "POST",
	    data: {
	    	rtpid: rtpid
	    },
	    success: function(result){
	    	$("#Cols").html(result);
	    },
	    error: function (request, error) {
	        alert('Error Inesperado');
	    }
	});
	
}
function regresarColumnaVer(rtpvid){
	document.getElementById("IdBtn").style.visibility = "visible";
	$.ajax({
	    url : "/cfmx/commons/GeneraReportes/Componentes/ReporteColumna.cfc?method=getColumnasVer",
	    type: "POST",
	    data: {
	    	rtpvid: rtpvid
	    },
	    success: function(result){
	    	$("#Cols").html(result);
	    },
	    error: function (request, error) {
	        alert('Error Inesperado');
	    }
	});
	
}


function editarColumna(rtpid,rptcId){
	$.ajax({
	    url : "/cfmx/commons/GeneraReportes/Componentes/ReporteColumna.cfc?method=editarColumnas",
	    type: "POST",
	    data: {
	    	rtpid : 	rtpid,
	    	rtpcid: 	rptcId
	    },
	    success: function(result){
	    	$("#Cols").html(result);
	    },
	    error: function (request, error) {
	        alert('Error Inesperado');
	    }
	});
	
}

function editarColumnaVer(rtpvid,rptcId){
	$.ajax({
	    url : "/cfmx/commons/GeneraReportes/Componentes/ReporteColumna.cfc?method=editarColumnasVer",
	    type: "POST",
	    data: {
	    	rtpvid : 	rtpvid,
	    	rtpcid: 	rptcId
	    },
	    success: function(result){
	    	$("#Cols").html(result);
	    },
	    error: function (request, error) {
	        alert('Error Inesperado');
	    }
	});
	
}

function guardaColumna(rtpid,rptcId){

	var lvarAlias = $('#frmAlias').val();
	var lvarnumeroCol = $('#frmOrdenC').val();
	var lvarordenCol = $('#frmOrdenD').val();
	var lvarCalculo = $('#frmCalculo').val();

	$.ajax({
	    url : "/cfmx/commons/GeneraReportes/Componentes/ReporteColumna.cfc?method=actualizaColumna",
	    type: "POST",
	    data: {
	    	rtpid: 		rtpid,
		    rtpcid: 	rptcId,
			alias:		lvarAlias,
			numeroCol: 	lvarnumeroCol,
			ordenCol: 	lvarordenCol,
			calculo: lvarCalculo
	    },
	    success: function(result){
	    	$("#Cols").html(result);
	    },
	    error: function (request, error) {
	        alert('Error Inesperado');
	    }
	});
	
}

function guardaColumnaCondicion(rtpvid){

	var modoEdicion;
	var rdioModificadorNum = 1;
	var rdioModificador = $('input[name=RdioModificador]:checked').val();
	var rdioCampo = $('#resgetColReporteOrigenCondicion option:selected').text();
	var rdioCondicion = $('#resgetColCondicion option:selected').val();
	var rdioValor =	$('#resgetColValor').val();
	var rdioGrupo =	$('#resgetColGrupo').val();

	if((rdioCampo == "Seleccionar una opción") || (rdioCondicion == "0") || (rdioValor  == "") ){
		alert("Los elementos Campo, Condición o Valor no pueden estar vacios");
	}else{
		
		if ($('#rptvcidHidden').val() === undefined || $('#rptvcidHidden').val() == ""){
			modoEdicion = 0;
		}else{
			modoEdicion = $('#rptvcidHidden').val();
		}
			if(rdioModificador == "y"){
				rdioModificadorNum = 1;
			}else{
				rdioModificadorNum = 0;
			}


			$.ajax({
			    url : "/cfmx/commons/GeneraReportes/Componentes/ReporteColumna.cfc?method=saveColCondicion",
			    type: "POST",
			    data: {	    
				    Modificador: rdioModificadorNum, 
					Campo: rdioCampo,
					Condicion: rdioCondicion,
					Valor: rdioValor,
					rtpvid: rtpvid,
					Grupo: rdioGrupo,
					Edicion: modoEdicion
			    },
			    success: function(result){
			    	$("#Cols").html(result);
			    	$('#frmCondicion').trigger("reset");
			    	$('#rptvcidHidden').val("");	
			    },
			    error: function (request, error) {
			        alert('Error Inesperado');
			    }
			});		
	}
}

function resetPage(){
	$('#frmCondicion').trigger("reset");
	$('#btnGuardar').hide();
	$('#rptvcidHidden').val("");
}

function eliminaColumnaCondicion(rtpvid,rptcId){
	$.ajax({
	    url : "/cfmx/commons/GeneraReportes/Componentes/ReporteColumna.cfc?method=eliminaColumnaCondicion",
	    type: "POST",
	    data: {
	    	rptvid: 	rtpvid,
	    	rptcid: 	rptcId
	    },
	    success: function(result){
	    	$("#Cols").html(result);
	    },
	    error: function (request, error) {
	        alert('Error Inesperado');
	    }
	});	
	resetPage();
}

function editarColumnaCondicion(rptvcid, RPTVCCampo, RPTVCCondicion, RPTVCValor, RPTVCY_O, RPTVCGrupo){
	$('#btnGuardarColCondicion').prop('value', 'Guardar');
	$('#btnNuevo').show();

	if(RPTVCY_O == "1"){
		$('input[name=RdioModificador][value=y]').prop('checked', true); 
		$('input[name=RdioModificador][value=o]').prop('checked', false);
	}else{
		$('input[name=RdioModificador][value=y]').prop('checked', false); 
		$('input[name=RdioModificador][value=o]').prop('checked', true);
	}

	var rdioModificador = $('input[name=RdioModificador]:checked').val();
	$("#resgetColReporteOrigenCondicion option").prop('selected', false);
	$("#resgetColReporteOrigenCondicion option").each(function () {
	        if ($(this).html() == RPTVCCampo.substring(0, RPTVCCampo.indexOf(':'))) {
	            $(this).prop("selected", "selected");
		   		return;
	        }
	});

	switch(RPTVCCondicion) {
		     case '=':
		        RPTVCCondicion = 'Igual';
		        break;
		     case '>':
		        RPTVCCondicion = 'Mayor';
		        break;
		     case '<':
		        RPTVCCondicion = 'Menor';
		        break;
		     case '!=':
		        RPTVCCondicion = 'Diferente';
		        break;
		     case '>=':
		        RPTVCCondicion = 'Mayor igual';
		        break;
		     case '<=':
		        RPTVCCondicion = 'Menor igual';
		        break;
		     case 'LikeInicio':
		        RPTVCCondicion = 'Comienza por';
		        break;
		     case 'LikeFinal':
		        RPTVCCondicion = 'Termina en';
		        break;
		     case 'Like':
		        RPTVCCondicion = 'Contiene';
		        break;   
		     default:
		         RPTVCCondicion =  '=';
		 } 
	$("#resgetColCondicion option").prop('selected', false);
	$("#resgetColCondicion option").each(function () {
	        if ($(this).html() == RPTVCCondicion) {
	            $(this).prop("selected", "selected");
		   		return;
	        }
	});

	$('#resgetColValor').val(RPTVCValor);
	$('#resgetColGrupo').val(RPTVCGrupo);
	$('#rptvcidHidden').val(rptvcid);
}

function guardaColumnaVer(rtpvid,rptcId){

	var lvarAlias = $('#frmAlias').val();
	var lvarnumeroCol = $('#frmOrdenC').val();
	var lvarordenCol = $('#frmOrdenD').val();
	var lvarCalculo = $('#frmCalculo').val();

	$.ajax({
	    url : "/cfmx/commons/GeneraReportes/Componentes/ReporteColumna.cfc?method=actualizaColumnaVer",
	    type: "POST",
	    data: {
	    	rtpvid: 	rtpvid,
		    rtpcid: 	rptcId,
			alias:		lvarAlias,
			numeroCol: 	lvarnumeroCol,
			ordenCol: 	lvarordenCol,
			calculo: lvarCalculo
	    },
	    success: function(result){
	    	$("#Cols").html(result);
	    },
	    error: function (request, error) {
	        alert('Error Inesperado');
	    }
	});
	
}

