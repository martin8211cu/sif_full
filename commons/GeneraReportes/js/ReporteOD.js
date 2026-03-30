/* Muestra listado de relaciones al cargar la pagina */
window.onload = funcGetOD();

/*Funcion Obtiene Origen De Datos*/
function funcGetOD(){
	var RPTId = document.getElementById("RPTId").value;
	var url = "/cfmx/commons/GeneraReportes/Componentes/ReporteOrigenDatos.cfc?method=getOrigenDatos&RPTId="+RPTId;
	 $.ajax({
			type: "GET",
			url: url,
			success: function(result){
				$("#GetODAjax").html(result);
		    }
	});
  	/*$.ajax({
	   	type: 'POST',
		url:'/cfmx/commons/GeneraReportes/Componentes/ReporteOrigenDatos.cfc?method=getOrigenDatos',
		data: $("#FormGR").serialize(),
		success: function(results) {
			$("#GetODAjax").html(results);
		},
	    error: function() {

	    }
	});*/
}

function eliminaOrigenDatos(RPTOId,RPTId,ODId){
	var LvarConfirm = confirm("Desea eliminar la relacion?");
	if(LvarConfirm){
		var url = "/cfmx/commons/GeneraReportes/Componentes/ReporteOrigenDatos.cfc?method=eliminaOrigenDatos&RPTOId="+RPTOId+"&RPTId="+RPTId+"&ODId="+ODId;
	    $.ajax({
			type: "GET",
			url: url,
			success: function(result){
				//$("#GetODAjax").html(result);
				funcGetOD();
		    }
		});
	}
	
}

//Ventana modal NewOD
function FunviewNewRel(){
	var RPTId = document.getElementById("RPTId").value;
	var url = "../FormNewOD.cfm?&RPTId="+RPTId;
    $.ajax({
		type: "GET",
		url: url,
		success: function(result){
	        $("#popupViewNew").html(result);
	    }
	});
	$("#popupViewNew").dialog({
        width: 670,
        modal:true,
        title:"Nuevo Origen de Datos",
        resizable: "false",
        position:['middle',70]
    });
}
function AgregarODGE(RPTId,ODId){
	var url = "/cfmx/commons/GeneraReportes/Componentes/ReporteOrigenDatos.cfc?method=insertaODRO&RPTId="+RPTId+"&ODId="+ODId;
    $.ajax({
		type: "GET",
		url: url,
		success: function(result){
			//$("#GetODAjax").html(result);
			funcGetOD();
			FunviewNewRel();
	    }
	});
}