<!DOCTYPE html>
<html lang="en">
	<head>
		<title>
			Bootstrap Example
		</title>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="/cfmx/home/public/assets/css/bootstrap.min.css">
		<script src="/cfmx/home/public/assets/js/jquery-2.1.4.min.js"></script>
		<script src="/cfmx/home/public/assets/js/bootstrap.min.js"></script>
		<script src="/cfmx/home/public/assets/js/jquery-ui.min.js"></script>
	</head>
	<body role="document">
		<div class="container theme-showcase" role="main">
			<div class="page-header">
				<h1>Tiendita</h1>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="panel panel-default">
						<div class="panel-heading">
							Comprar
						</div>
						<div class="panel-body">
								<div class="form-group">
									<label for="nombre">
										Nombre:
									</label>
									<input type="text" class="form-control" id="nombre" name="nombre">
								</div>
								<div class="form-group">
									<label for="cant">
										Cantidad:
									</label>
									<input type="text" class="form-control" id="cant" name="cant">
								</div>
								<button id="btn-save" name="btn-save" type="buttton" class="btn btn-success">
									Comprar
								</button>
								<button id="btn-refresh" name="btn-refresh" type="button" class="btn btn-info">
									Refrescar
								</button>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="panel panel-default">
						<div class="panel-heading">
							Lista de Compras
						</div>
						<div class="panel-body">
							<table class="table">
								<thead>
									<th>Producto</th>
									<th>Cantidad</th>
								</thead>
								<tbody id="listItems">
									<cfoutput>
										<cfloop array="#session.listaCarrito#" index="item">
											<tr>
										    	<td>#item.nombre#</td>
												<td>#item.cantidad#</td>
										    </tr>
										</cfloop>
									</cfoutput>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>

<script type="text/javascript">
	$(document).ready(function() {
	    $("#cant").keydown(function (e) {
	        if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
	            (e.keyCode == 65 && ( e.ctrlKey === true || e.metaKey === true ) ) ||
	            (e.keyCode >= 35 && e.keyCode <= 40)) {
	                 return;
	        }
	        if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
	            e.preventDefault();
	        }
	    });

	    $("#btn-save").click(function(){
			var vNombre = $("#nombre").val();
			var vCant = $("#cant").val();
			$.ajax({
			    url : "Carrito.cfc?method=set",
			    type: "POST",
			    data : {
			    	nombre: vNombre,
			    	cantidad: vCant
			    },
			    beforeSend: function () {
			    	var flag = true;
              		if($("#nombre").val().trim()==''){
              			$("#nombre").effect( "shake" );
              			flag = false;
              		}
              		if($("#cant").val().trim()==''){
              			$("#cant").effect( "shake" );
              			flag = false;
              		}
              		return flag
                },
			    success: function(result){
					$("input[type=text], textarea").val("");
					refresca();
			    },
			    error: function (request, error) {
			        alert("No se pudo agregar");
			    }
			});
		});

		$("#btn-refresh").click(refresca);
	});

	function refresca(){
		$.ajax({
              url:   'Carrito.cfc?method=getList',
              type:  'post',
              beforeSend: function () {
              		$("#listItems").html("Procesando...");
              },
              success:  function (response) {
              		$("#listItems").html(response);
              },
              error: function(error){
              		$("#listItems").html(error);
              },
              async:false
       	});
	}
</script>



	</body>
</html>
