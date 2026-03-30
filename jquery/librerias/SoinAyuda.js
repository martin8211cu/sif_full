function toogleHelp() {
	var altura = screen.height*0.60;
	$.ajax({
		url: "/cfmx/commons/Componentes/Ayuda.cfc?method=getHelp",
		type: "POST",
		data: {
			altura:altura
		},
		success: function(result){
	        $("#sHelpPane").html(result);
	    }
	});

	$("#sHelpPane").dialog({
        width: screen.width*0.50,
        modal:true,
        title:"Ayuda",
        height: screen.height*0.80,
        resizable: "true"
    });
}

function showHelp(idAyuda) {
	var altura = screen.height*0.60;
	$.ajax({
		url: "/cfmx/commons/Componentes/Ayuda.cfc?method=getHelp",
		type: "POST",
		data: {
			idAyuda:idAyuda,
			altura:altura
		},
		success: function(result){
	        $("#sHelpPane").html(result);
	    }
	});
}

$("nav").find("li").on("click", "a", function () {
    $('.navbar-collapse.in').collapse('hide');
});
