$(document).ready(function(){$("#NavLeftAddFavorite").click(function(){window.favoritos.addFavorites()}),window.favoritos=function(){var o=[],a="";return{getMisFavoritos:function(){return o},setMisFavoritos:function(a){o=a},setCurrentURL:function(o){a=o.toUpperCase()},addFavorites:function(){var r=!1;for(i=0;i<o.length;i++)if(o[i]==a){r=!0;break}r||o.push(a),window.favoritos.actualizarFavorites()},delFavorites:function(o){var a=[],r=window.favoritos.getMisFavoritos();for(i=0;i<r.length;i++)r[i]!=o&&a.push(r[i]);window.favoritos.setMisFavoritos(a),window.favoritos.actualizarFavorites()},actualizarFavorites:function(){var a=o.toString(),r={method:"setFavorites",datos:a};try{$.ajax({type:"get",url:"/cfmx/asp/Componentes/PreferenciasUsuario.cfc",data:r,dataType:"json",success:function(o){if("OK"!=o.MSG){var a="Error al intentar agregar el registro: "+o.MSG;alert(a),console.log(a),console.log(o)}else window.favoritos.loadFavorites()},error:function(o,a){var r="Error al intentar agregar el registro: "+a;alert(r),console.log(o),console.log(a)}})}catch(t){var i="Error Inesperado: "+t;alert(i),console.log(i)}},loadFavorites:function(){var o={method:"getFavorites"};
try{
	$.ajax({
		type:"get",
		url:"/cfmx/asp/Componentes/PreferenciasUsuario.cfc",
		data:o,
		dataType:"json",
		success:
			function(o){
				if("OK"!=o.MSG){
					var a="Error al intentar cargar la configuracion: "+o.MSG;alert(a),console.log(a),console.log(o)
				}
				else 
					favoritos.pintaFavoritos(o)
			},
		error:
			function(o,a){
				var r="Error al intentar cargar la configuracion.: "+a;
				/*alert(r);
				console.log(o);
				console.log(a);*/
			}
	})
}
catch(a){
	var r="Error Inesperado: "+a;alert(r),console.log(r)
}
},pintaFavoritos:function(o){if(0==o.DATA)return void $("#listaFavoritos").html("");$("#listaFavoritos").html(""),$tabla="";var a=[];for(i=0;i<o.DATA.length;i++){a.push(o.DATA[i].CODE);var r='<li class="list-group-item"><a href="'+o.DATA[i].URI+'">'+o.DATA[i].DESCR+'</a>&nbsp;&nbsp;<i style="color:black" class="fa fa-trash-o" onclick=window.favoritos.delFavorites(\''+o.DATA[i].CODE+"')></i></li>";$tabla+=r}window.favoritos.setMisFavoritos(a),$("#listaFavoritos").html($tabla)}}}()});