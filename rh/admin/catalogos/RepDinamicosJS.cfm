<script>

	var timehide = 0;
	var timeFadeIn = 200;
	
	$body = $("body");

	$(document).on({
	    ajaxStart: function() { $body.addClass("loading"); },
	    ajaxComplete: function() { setTimeout( function(){$body.removeClass("loading");}, 500)  }    
	});

		<!----- *******************************************************************************************************************
		TIPOS DE ACCION
		**********************************************************************************************************************---->	

		
		function SelectUnselectMe(miElemento) {              
			$(miElemento).click(function(){
		        if($(miElemento).attr("class") == 'fila'){
		            $(miElemento).removeClass('fila');
		            $(miElemento).addClass('seleccionado');  
		        }else{
		            $(miElemento).removeClass('seleccionado');
		            $(miElemento).addClass('fila');
		        }  
	        })	
		}
		
		function pasarToTable(tipoActualizar, tablaInicial, tablaDestino){
			var selectedRows = $(tablaInicial+" tr.seleccionado");
			// llamar funcion que ingresara todos los rows, la funcion debera regresar el id con un estado (0: no se ingreso, 1 se ingreso),
			// se itera para analizar si se ingreso y se cambia de lado si el estado es 1. 
			ActualizarConfig(tipoActualizar, selectedRows, tablaDestino);
			
		}

		// al finalizar la peticion ajax se pasa cada row a la tabla destino
		function pasarRows (rowsresult, rowsselected, tablaDestino) {
			if(rowsresult != null && rowsresult.length > 0){
				rowsselected.each(function(){
					var actualrow = $(this);
					if(rowsresult.find(function(ele){return ele == $(actualrow).attr("id")})) {
						$(this).removeClass('seleccionado');
						$(this).addClass('fila');
						$(this).hide(timehide);
						$(tablaDestino).append($(this));
						$(this).fadeIn(timeFadeIn);
						<cfif rsInfoColumna.Ctipo eq 1>	
							EnableDisableCarga(this);
						<cfelseif rsInfoColumna.Ctipo eq 2>	
							EnableDisableEmpleado(this);
						<cfelseif rsInfoColumna.Ctipo eq 3>	
							EnableDisableNomina(this);
						</cfif>
					} else{
						alert("No se pudo incluir este elemento: <br>" + $(actualrow).find("td:eq(1)").html());
					}
				})
				<cfif rsInfoColumna.Ctipo eq 4>	
					habilitarDeshabilitar();
				</cfif>
			} else {
				alert("No se agrego ningun elemento");
			}
		}
		
		function passAll(tablaRecorrer,AccionClick){
			var ListaElmentoAdd = $(tablaRecorrer).filter(function () {
									    return $(this).css("display") != "none";
								  });

            $(ListaElmentoAdd).each(function(){
				$(this).removeClass('fila'); 
				$(this).addClass('seleccionado');
			})
            $(AccionClick).click();
		}
		
		
		<!------ script para busqueda de caracteres---->
		jQuery.expr[':'].Contains = function(a, i, m) {
		  return jQuery(a).text().toUpperCase()
			  .indexOf(m[3].toUpperCase()) >= 0;
		};
		
		// OVERWRITES old selecor
		jQuery.expr[':'].contains = function(a, i, m) {
		  return jQuery(a).text().toUpperCase()
			  .indexOf(m[3].toUpperCase()) >= 0;
		};
			   
			   
		function filtradoTexto(elemento,valor){
			if(valor.length >0){ 
				if(typeof elemento=='object'){
					if($(elemento).is(":contains(" + valor+ ")")){
						$(elemento).show("slow");
					}
					else{
						$(elemento).hide("slow");
					}	
				}else{
					if($("#"+elemento.id+":contains(" + valor+ ")").length > 0){
						$(elemento).show("slow");
					}
					else{
						$(elemento).hide("slow");
					}
				}
			}	
			else{
				$(elemento).show("slow");
			}	
		}
		
		
	<cfif rsInfoColumna.Ctipo eq 1>	
		function ActualizarConfig(tipo,rwselected,tdestino){
			//tipo 1= acciones
			// var idElemento =$(elemento).attr('id');
			// var subtipo=0;
			// if(tipo==4){ // si es una carga debe de indicar el subtipo
			// 	subtipo = $('#TipoCarga'+idElemento).val();
			// }

			var elementos = [];
			var rwresult = [];
			rwselected.each(function(){
				idElemento = $(this).attr('id');
				elementos.push({referencia: idElemento, subtipo: (tipo == 4 ? $('#TipoCarga'+idElemento).val() : 0 ) });
			});

			$.ajax({
				url: "RepDinamicos.cfc"
			  , type: "post"
			  , dataType: "json"
			  , async: true
			  , data: 	{
				  			method: "ActualizarConfigSUM"
				  			,idColumna: <cfoutput>#form.Cid#</cfoutput>
							,tipo: tipo
							,elementos: JSON.stringify(elementos)
			  			}
			  
			  , success: function (data){
					$.each(data, function(i, item) {
						rwresult.push(item);						
					})
					pasarRows(rwresult, rwselected, tdestino);
			  }

			});		
		}	
		
		
		function EnableDisableCarga(miElemento){
			var idElemento =$(miElemento).attr('id');
			ele = '#TipoCarga'+idElemento;
			if($(ele).is(":disabled")){
				$(ele).removeAttr('disabled');
				$(ele).attr('class', 'selectorCargas');
			}	
			else{	
				$(ele).attr('disabled', 'disabled');
				$(ele).removeClass();
			}
		}
		
		function changeAllTipoCargas(miElemento){
			$("select.selectorCargas").each(
				function(){ 
					if($(this).is(":disabled")==false){
						$(this).val($(miElemento).val());
					}
				}
			)
		}
		
        $(function(){    
		        
			 <!----- SELECTOR DE CAMPOS DE LAS TABLAS------>
			
			 <!--- ACCIONES----->
             $("table.ListaAcciones tr").each(function(){SelectUnselectMe($(this))});
             $("table.ListaAccionesIncluir tr").each(function(){SelectUnselectMe($(this))});
             $("#incluirAccion").click(function(){
                pasarToTable(1,"table.ListaAcciones","#ListaAccionesIncluir");
             });
             $("#excluirAccion").click(function(){
                pasarToTable(1,"table.ListaAccionesIncluir","#ListaAcciones");
             });
             $("#incluirAccionTodos").click(function(){   
			 	passAll("table.ListaAcciones tr","#incluirAccion");
             });
             $("#excluirAccionTodos").click(function(){
				passAll("table.ListaAccionesIncluir tr","#excluirAccion");
             });
			  
             $("#filtroAccionesA").keyup(function(){
                $("table.ListaAcciones tr").each(function(){ 
					filtradoTexto(this,$("#filtroAccionesA").val());
                })
             });
             $("#filtroAccionesB").keyup(function(){
                $("table.ListaAccionesIncluir tr").each(function(){ 
					filtradoTexto(this,$("#filtroAccionesB").val());
                })
             });
			 <!--- Componentes Salariales----->
             $("table.ListaComponentes tr").each(function(){SelectUnselectMe($(this))});
             $("table.ListaComponentesIncluir tr").each(function(){SelectUnselectMe($(this))});
			 
             $("#incluirComponentes").click(function(){
                pasarToTable(6,"table.ListaComponentes","#ListaComponentesIncluir")
             });
			 
             $("#excluirComponentes").click(function(){
                pasarToTable(6,"table.ListaComponentesIncluir","#ListaComponentes")
             });
			 
             $("#incluirComponentesTodos").click(function(){   
			 	passAll("table.ListaComponentes tr","#incluirComponentes");
             });
             $("#excluirComponentesTodos").click(function(){
				passAll("table.ListaComponentesIncluir tr","#excluirComponentes");
             });
			  
             $("#filtroComponentesA").keyup(function(){
                $("table.ListaComponentes tr").each(function(){ 
					filtradoTexto(this,$("#filtroComponentesA").val());
                })
             });
             $("#filtroComponentesB").keyup(function(){
                $("table.ListaComponentesIncluir tr").each(function(){ 
					filtradoTexto(this,$("#filtroComponentesB").val());
                })
             });
			 <!--- CONCEPTOS----->
             $("table.ListaConceptos tr").each(function(){SelectUnselectMe($(this))});
             $("table.ListaConceptosIncluir tr").each(function(){SelectUnselectMe($(this))});
             $("#incluirConcepto").click(function(){
                pasarToTable(2,"table.ListaConceptos","#ListaConceptosIncluir")
             });
             $("#excluirConcepto").click(function(){
                pasarToTable(2,"table.ListaConceptosIncluir","#ListaConceptos")
             });
             $("#incluirConceptoTodos").click(function(){   
			 	passAll("table.ListaConceptos tr","#incluirConcepto");
             });
             $("#excluirConceptoTodos").click(function(){
				passAll("table.ListaConceptosIncluir tr","#excluirConcepto");
             });
			  
             $("#filtroConceptosPagoA").keyup(function(){
                $("table.ListaConceptos tr").each(function(){ 
					filtradoTexto(this,$("#filtroConceptosPagoA").val());
                })
             });
             $("#filtroConceptosPagoB").keyup(function(){
                $("table.ListaConceptosIncluir tr").each(function(){ 
					filtradoTexto(this,$("#filtroConceptosPagoB").val());
                })
             });
		  	 <!--- DEDUCCION----->
             $("table.ListaDeducciones tr").each(function(){SelectUnselectMe($(this))});
             $("table.ListaDeduccionesIncluir tr").each(function(){SelectUnselectMe($(this))});
             $("#incluirDeduccion").click(function(){
                pasarToTable(3,"table.ListaDeducciones","#ListaDeduccionesIncluir")
             });
             $("#excluirDeduccion").click(function(){
                pasarToTable(3,"table.ListaDeduccionesIncluir","#ListaDeducciones")
             });
             $("#incluirDeduccionTodos").click(function(){   
			 	passAll("table.ListaDeducciones tr","#incluirDeduccion");
             });
             $("#excluirDeduccionTodos").click(function(){
				passAll("table.ListaDeduccionesIncluir tr","#excluirDeduccion");
             });
			 
             $("#filtroDeduccionesA").keyup(function(){
                $("table.ListaDeducciones tr").each(function(){ 
					filtradoTexto(this,$("#filtroDeduccionesA").val());
                })
             });
             $("#filtroDeduccionesB").keyup(function(){
                $("table.ListaDeduccionesIncluir tr").each(function(){ 
					filtradoTexto(this,$("#filtroDeduccionesB").val());
                })
             });
		     <!--- CARGAS----->
             $("table.ListaCargas tr").each(function(){SelectUnselectMe($(this))});
             $("table.ListaCargasIncluir tr").each(function(){SelectUnselectMe($(this))});
             $("#incluirCarga").click(function(){
                pasarToTable(4,"table.ListaCargas","#ListaCargasIncluir");
				
             });
             $("#excluirCarga").click(function(){
                pasarToTable(4,"table.ListaCargasIncluir","#ListaCargas");
             });
             $("#incluirCargaTodos").click(function(){   
			 	passAll("table.ListaCargas tr","#incluirCarga");
             });
             $("#excluirCargaTodos").click(function(){
				passAll("table.ListaCargasIncluir tr","#excluirCarga");
             });
				$("#cambiarAllTiposCargas").change(
						function () {
				 			changeAllTipoCargas($(this));
						}
				);
			 
             $("#filtroCargasA").keyup(function(){
                $("table.ListaCargas tr").each(function(){ 
					filtradoTexto(this,$("#filtroCargasA").val());
                })
             });
             $("#filtroCargasB").keyup(function(){
                $("table.ListaCargasIncluir tr").each(function(){ 
					filtradoTexto(this,$("#filtroCargasB").val());
                })
             });
			 <!--- ESPECIALES----->
             $("table.ListaEspeciales tr").each(function(){SelectUnselectMe($(this))});
             $("table.ListaEspecialesIncluir tr").each(function(){SelectUnselectMe($(this))});
             $("#incluirEspeciales").click(function(){
                pasarToTable(5,"table.ListaEspeciales","#ListaEspecialesIncluir");
				
             });
             $("#excluirEspeciales").click(function(){
                pasarToTable(5,"table.ListaEspecialesIncluir","#ListaEspeciales");
             });
             $("#incluirEspecialesTodos").click(function(){   
			 	passAll("table.ListaEspeciales tr","#incluirEspeciales");
             });
             $("#excluirEspecialesTodos").click(function(){
				passAll("table.ListaEspecialesIncluir tr","#excluirEspeciales");
             });
			 
                           
        })
		  
		  
	<cfelseif rsInfoColumna.Ctipo eq 2> 	<!--- Empleado --->
	
		function ActualizarConfig(tipo,rwselected,tdestino){
			<!----- tipo 1 = Empleado ----->
			var elementos = [];
			var rwresult = [];
			rwselected.each(function(){
				idElemento = $(this).attr('id');
				var agrega = $('#agregado'+idElemento).val();
				if(agrega){
					<!--- encontro componente --->
				} else {
					agrega = 0;
				}
				elementos.push({columna: idElemento, order: $('#order'+idElemento).val(), agregado: agrega});
			});
	
			$.ajax({
				url: "RepDinamicos.cfc"
			  , type: "post"
			  , dataType: "json"
			  , async :true
			  , data: 	{
				  			method: "actualizarConfigCTE"
				  			,Cid: <cfoutput>#form.Cid#</cfoutput>
							,tipo: tipo
							,elementos: JSON.stringify(elementos)
			  			}
			  
			  , success: function (data){
					$.each(data, function(i, item) {
						rwresult.push(item);
					});
					pasarRows(rwresult, rwselected, tdestino);
			  }

			});
					
		}	
		
		function YaAgregado(tipo){
			var valido = false;
			var ListaElemento=''
			
			if(tipo==1){//puesto
				ListaElemento ="'RHPcodigo','RHPdescpuesto'" ;
			}
			else{//Centro funcional
				ListaElemento ="'CFcodigo','CFdescripcion'" ;
			}
			
			$.ajax({
				url: "RepDinamicos.cfc"
			  , type: "get"
			  , dataType: "json"
			  ,async :false
			  , data: 	{
				  			method: "ValidaAgregada"
				  			,Cid: <cfoutput>#form.Cid#</cfoutput>
							,listaBuscar: ListaElemento
			  			}
			  
			  , success: function (data){
					$.each(data, function(i, item) {
						if (item.resultado == 1){
							valido = true;
						}	
						else{
							valido = false;
						}
					})
					
			  }

			});
			
			return valido;
		}	
		
		function EnableDisableEmpleado(miElemento){
			var idElemento =$(miElemento).attr('id');
			ele = '#order'+idElemento;

			
			<!---- en el caso que sea puesto, los checks deben de trabajan dependientes---->
			if(idElemento == 'RHPcodigo' || idElemento == 'RHPdescpuesto'){
				if(YaAgregado(1)){// si existe un puesto ya agregado se deshabilitan los 2, en el caso contrario se habilitan
					habilitaPuesto(1);
				}else{
					habilitaPuesto(0);
				}		
			}
			else{
				<!---- en el caso que sea puesto, los checks deben de trabajan dependientes---->
				if(idElemento == 'CFcodigo' || idElemento == 'CFdescripcion'){
					if(YaAgregado(2)){// si existe un centro funcional ya agregado se deshabilitan los 2, en el caso contrario se habilitan
						habilitaCentroFuncional(1);
					}else{
						habilitaCentroFuncional(0);
					}
				}
				else{
					if($(ele).is(":disabled")){//// lo habilita
						$(ele).removeAttr('disabled');
						$(ele).attr('class', 'selectorEmpleado');
					}	
					else{	// lo deshabilita
						$(ele).attr('disabled', 'disabled');
						$(ele).removeClass();
					}
				}		
			}

			
			
		}
		
		function habilitaPuesto(option){
			if(option ==1){/// habilita
				$('#orderRHPdescpuesto').attr('disabled', 'disabled');		$('#orderRHPdescpuesto').removeClass();
				$('#agregadoRHPdescpuesto').attr('disabled', 'disabled'); 	$('#agregadoRHPdescpuesto').removeClass();
				$('#orderRHPcodigo').attr('disabled', 'disabled'); 			$('#orderRHPcodigo').removeClass();
				$('#agregadoRHPcodigo').attr('disabled', 'disabled');		$('#agregadoRHPcodigo').removeClass();
			}
			else{
				$('#orderRHPdescpuesto').removeAttr('disabled');		$('#orderRHPdescpuesto').attr('class', 'selectorEmpleado');
				$('#agregadoRHPdescpuesto').removeAttr('disabled'); 	$('#agregadoRHPdescpuesto').attr('class', 'selectorEmpleado');
				$('#orderRHPcodigo').removeAttr('disabled'); 			$('#orderRHPcodigo').attr('class', 'selectorEmpleado');
				$('#agregadoRHPcodigo').removeAttr('disabled');			$('#agregadoRHPcodigo').attr('class', 'selectorEmpleado');
			}
		}
		
		function habilitaCentroFuncional(option){
			if(option ==1){/// habilita
				$('#orderCFdescripcion').attr('disabled', 'disabled');		$('#orderCFdescripcion').removeClass();
				$('#agregadoCFdescripcion').attr('disabled', 'disabled'); 	$('#agregadoCFdescripcion').removeClass();
				$('#orderCFcodigo').attr('disabled', 'disabled'); 			$('#orderCFcodigo').removeClass();
				$('#agregadoCFcodigo').attr('disabled', 'disabled');		$('#agregadoCFcodigo').removeClass();
			}
			else{
				$('#orderCFdescripcion').removeAttr('disabled');		$('#orderCFdescripcion').attr('class', 'selectorEmpleado');
				$('#agregadoCFdescripcion').removeAttr('disabled'); 	$('#agregadoCFdescripcion').attr('class', 'selectorEmpleado');
				$('#orderCFcodigo').removeAttr('disabled'); 			$('#orderCFcodigo').attr('class', 'selectorEmpleado');
				$('#agregadoCFcodigo').removeAttr('disabled');			$('#agregadoCFcodigo').attr('class', 'selectorEmpleado');
			}
		}
		
		function changeAllOrderEmpleado(miElemento){
			$("select.selectorEmpleado").each(
				function(){ 
					if($(this).is(":disabled")==false){
						$(this).val($(miElemento).val());
					}
				}
			)
		}
			
				   
        $(function(){    
		        
			<!-----  DATOS DEL EMPLEADO ------>

             $("table.ListEmpleado tr").each(function(){SelectUnselectMe($(this))});
             $("table.ListEmpleadoIncluir tr").each(function(){SelectUnselectMe($(this))});
             $("#incluirEmpleado").click(function(){
                // $("table.ListEmpleado tr").each(function(){ pasarToTable(1,$(this),"#ListEmpleadoIncluir");<!---- tipo 1= empleado----->
                // })
				pasarToTable(1,"table.ListEmpleado","#ListEmpleadoIncluir")
             });
             $("#excluirEmpleado").click(function(){
                // $("table.ListEmpleadoIncluir tr").each(function(){ pasarToTable(1,$(this),"#ListEmpleado");
                // })
                pasarToTable(1,"table.ListEmpleadoIncluir","#ListEmpleado")
             });
             $("#incluirEmpleadoTodos").click(function(){   
			 	passAll("table.ListEmpleado tr","#incluirEmpleado");
             });
             $("#excluirEmpleadoTodos").click(function(){
				passAll("table.ListEmpleadoIncluir tr","#excluirEmpleado");
             });
			 
			$("#cambiarAllordenEmpleado").change(
					function () {
						changeAllOrderEmpleado($(this));
					}
			);
			
			
			<!------- validacion de combos del puesto--------------->
			$("#agregadoRHPdescpuesto").change(
					function () {
							$("#agregadoRHPcodigo").val($(this).val());	
					}
			);
			$("#agregadoRHPcodigo").change(
					function () {
							$("#agregadoRHPdescpuesto").val($(this).val());
					}
			);
			$("#orderRHPdescpuesto").change(
					function () {
							$("#orderRHPcodigo").val($(this).val());
					}
			);
			$("#orderRHPcodigo").change(
					function () {
							$("#orderRHPdescpuesto").val($(this).val());
					}
			);
			
			<!--------- fin function javascript----->
			
                           
          })
		  
		  
	<cfelseif rsInfoColumna.Ctipo eq 3> <!---- tipo nomina----->
	
		function ActualizarConfig(tipo,rwselected,tdestino){
			<!----- tipo 3 = Nomina ----->
			var elementos = [];
			var rwresult = [];
			rwselected.each(function(){
				idElemento = $(this).attr('id');
				elementos.push({columna: idElemento, order: $('#order'+idElemento).val(), agregado: 0});
			});
	
			$.ajax({
				url: "RepDinamicos.cfc"
			  , type: "post"
			  , dataType: "json"
			  , async :true
			  , data: 	{
				  			method: "actualizarConfigCTE"
				  			,Cid: <cfoutput>#form.Cid#</cfoutput>
							,tipo: tipo
							,elementos: JSON.stringify(elementos)
			  			}
			  
			  , success: function (data){
					$.each(data, function(i, item) {
						rwresult.push(item);
					})
					pasarRows(rwresult, rwselected, tdestino)
			  }
			});
		}	
		
		function EnableDisableNomina(miElemento){
			var idElemento =$(miElemento).attr('id');
			ele = '#order'+idElemento;
			if($(ele).is(":disabled")){
				$(ele).removeAttr('disabled');
				$(ele).attr('class', 'selectorNomina');
			}	
			else{	
				$(ele).attr('disabled', 'disabled');
				$(ele).removeClass();
			}
		}
		
		function changeAllOrderNomina(miElemento){
			$("select.selectorNomina").each(
				function(){ 
					if($(this).is(":disabled")==false){
						$(this).val($(miElemento).val());
					}
				}
			)
		}	
					
				   
        $(function(){    
		        

			$("table.ListNomina tr").each(function(){SelectUnselectMe($(this))});
			$("table.ListNominaIncluir tr").each(function(){SelectUnselectMe($(this))});

			$("#incluirNomina").click(function(){
				// $("table.ListNomina tr").each(function(){ pasarToTable(3,$(this),"#ListNominaIncluir");<!---- tipo 3= Nomina----->
				// })
			    pasarToTable(3,"table.ListNomina","#ListNominaIncluir")
			});

			$("#excluirNomina").click(function(){
				// $("table.ListNominaIncluir tr").each(function(){ pasarToTable(3,$(this),"#ListNomina");
				// })
			    pasarToTable(3,"table.ListNominaIncluir","#ListNomina")
			});

			$("#incluirNominaTodos").click(function(){   
				passAll("table.ListNomina tr","#incluirNomina");
			});
			$("#excluirNominaTodos").click(function(){
				passAll("table.ListNominaIncluir tr","#excluirNomina");
			});
			 
			$("#cambiarAllordenNomina").change(
					function () {
						changeAllOrderNomina($(this));
					}
			);
			
			<!--------- fin function javascript----->
			
                           
          })
	
	<cfelseif rsInfoColumna.Ctipo eq 4> <!---- tipo informacion salarial----->
		function ActualizarConfig(tipo,rwselected,tdestino){
			//tipo 6= Componentes Salariales
			var elementos = [];
			var rwresult = [];
			rwselected.each(function(){
				idElemento = $(this).attr('id');
				elementos.push({referencia: idElemento, subtipo: $('#agregado'+idElemento).val(), subvalor: $("#tsuma"+idElemento).val()});
			});
			
			$.ajax({
				url: "RepDinamicos.cfc"
			  , type: "post"
			  , dataType: "json"
			  ,async :true
			  , data: 	{
				  			method: "ActualizarConfigSUM"
				  			,idColumna: <cfoutput>#form.Cid#</cfoutput>
							,tipo: tipo
							,elementos: JSON.stringify(elementos)
			  			}
			  , success: function (data){
					$.each(data, function(i, item) {
						rwresult.push(item);						
					})
					pasarRows(rwresult, rwselected, tdestino);
			  }
			});		
		}	
		
		
		function YaAgregado(){
			var valido = -1;
			
			$.ajax({
				url: "RepDinamicos.cfc"
			  , type: "get"
			  , dataType: "json"
			  ,async :false
			  , data: 	{
				  			method: "ValidaAgregadaInfoSalarial"
				  			,Cid: <cfoutput>#form.Cid#</cfoutput>
			  			}
			  , success: function (data){
					$.each(data, function(i, item) {
						valido = item.resultado;
					})
					
			  }

			});
			
			return valido;
		}	
		
		function habilitarDeshabilitar(){
			var gresult = YaAgregado();
			if(gresult > 9){
				var tsuma = Math.floor(gresult/10);
				var agrupado = gresult%10;
			} else {
				var agrupado = -1;
			}

			if(agrupado > -1){
				$("#agregado").val(agrupado);
				changeAll($("#agregado"));
				$("#tsuma").val(tsuma);
				changeAllSuma($("#tsuma"));
				$("select.selectorCS, select.sumaCS").each(
					function(){ 
						if($(this).is(":disabled")==false){
							$(this).attr('disabled', 'disabled');
						}
					}
				)	
			}else{
				$("select.selectorCS, select.sumaCS").each(
					function(){
						if($(this).is(":disabled")){
							$(this).removeAttr('disabled');
						}	
					}
				)
			}
			$("#ListaComponentes select.selectorCS").each(
				function(){
					$(this).parent().hide();
				}
			);
			$("#ListaComponentesIncluir select.selectorCS").each(
				function(){
					$(this).parent().show();
				}
			);
		}
		function changeAll(miElemento){
			$("select.selectorCS").each(
				function(){ 
					$(this).val($(miElemento).val());
				}
			)
		}

		function changeAllSuma(miElemento){
			$("select.sumaCS").each(
				function(){ 
					$(this).val($(miElemento).val());
				}
			)
		}
				
		
        $(function(){    
		        
			<!----- SELECTOR DE CAMPOS DE LAS TABLAS------>
			
			 <!--- Componentes Salariales----->
             $("table.ListaComponentes tr").each(function(){SelectUnselectMe($(this))});
             $("table.ListaComponentesIncluir tr").each(function(){SelectUnselectMe($(this))});
			 
             $("#incluirComponentes").click(function(){
                pasarToTable(6,"table.ListaComponentes","#ListaComponentesIncluir")
             });
			 
             $("#excluirComponentes").click(function(){
                pasarToTable(6,"table.ListaComponentesIncluir","#ListaComponentes")
             });
			 
             $("#incluirComponentesTodos").click(function(){   
			 	passAll("table.ListaComponentes tr","#incluirComponentes");
             });
             $("#excluirComponentesTodos").click(function(){
				passAll("table.ListaComponentesIncluir tr","#excluirComponentes");
             });
			  
             $("#filtroComponentesA").keyup(function(){
                $("table.ListaComponentes tr").each(function(){ 
					filtradoTexto(this,$("#filtroComponentesA").val());
                })
             });
             $("#filtroComponentesB").keyup(function(){
                $("table.ListaComponentesIncluir tr").each(function(){ 
					filtradoTexto(this,$("#filtroComponentesB").val());
                })
             });
                           
          })
	
	<cfelseif rsInfoColumna.Ctipo eq 10> <!---- tipo formular----->


		function ActualizarConfig(tipo,elemento,tablaDestino){
			var varColumnaA=$("#cmbColumnaA").val();
			var varColumnaB=$("#cmbColumnaB").val();
			var varValorA=$("#inpValorA").val();
			var varValorB=$("#inpValorB").val();
			var varTipo=$("#cmbTipoOperador").val();
			
			var varOrder=$("#orderColumnaFormulada").val();
			
			if($("#cmbTipoA").val() == 1){// si 1, Columna 
				varValorA = '';
			}
			else{//si 2, valor
				varColumnaA = '';
			}
			
			if($("#cmbTipoB").val() == 1){// si 1, Columna
				varValorB = '';
			}
			else{//si 2, valor
				varColumnaB = '';
			}

			var valido=false;

			$.ajax({
				url: "RepDinamicos.cfc"
			  , type: "post"
			  , dataType: "json"
			  , async : true
			  , data: 	{
				  			method: "actualizarConfigCFOR"
				  			,Cid: <cfoutput>#form.Cid#</cfoutput>
							,columnaA: varColumnaA
							,columnaB: varColumnaB
							,ValorA: varValorA
							,ValorB: varValorB
							,tipo: varTipo
							,order: varOrder
			  			}
			  
			  , success: function (data){
					$.each(data, function(i, item) {
						if (item.resultado == 1){
							valido = true;
						}	
						else{
							alert("No se puede incluir este elemento");
							valido = false;
						}
					})
					if(valido){
						pasarRowsFormuladas(elemento, tablaDestino)
					}
			  }

			});
		}	
		
		
		function EnableDisableFormulada(){
			if($('#cmbTipoA').is(":disabled")){
			
				$('#cmbTipoA').removeAttr('disabled');
				$('#cmbTipoB').removeAttr('disabled');
				$('#cmbColumnaA').removeAttr('disabled');
				$('#cmbColumnaB').removeAttr('disabled');
				$('#inpValorA').removeAttr('disabled');
				$('#inpValorB').removeAttr('disabled');
				$('#cmbTipoOperador').removeAttr('disabled');	
				$('#orderColumnaFormulada').removeAttr('disabled');					
			}	
			else{	
				$('#cmbTipoA').attr('disabled', 'disabled');
				$('#inpValorB').attr('disabled', 'disabled');
				$('#cmbColumnaA').attr('disabled', 'disabled');
				$('#cmbColumnaB').attr('disabled', 'disabled');
				$('#inpValorA').attr('disabled', 'disabled');
				$('#cmbTipoB').attr('disabled', 'disabled');
				$('#cmbTipoOperador').attr('disabled', 'disabled');
				$('#orderColumnaFormulada').attr('disabled', 'disabled');
			}
		}
		
		function pasarRowsFormuladas (bloque, tablaDestino) {
			$(bloque).removeClass('seleccionado');
			$(bloque).addClass('fila');
			$(bloque).hide(timehide);
			$(tablaDestino).append($(bloque));
			$(bloque).fadeIn(timeFadeIn);
			EnableDisableFormulada();
		}
		

		$(function(){ 
		 		
			$("#incluirFormulada").click(function(){
				$("#ListFormular tbody")
					.removeClass("fila")
					.each(function(){$(this).addClass('seleccionado');ActualizarConfig(10,$(this),"#ListFormularincluir")});
			});

			$("#excluirFormulada").click(function(){
				$("#ListFormularincluir tbody")
					.removeClass("fila")
					.each(function(){$(this).addClass('seleccionado');ActualizarConfig(10,$(this),"#ListFormular")});
			});
			 
			 
			$("#cmbTipoA").change(
					function () {
						visibleColumnaA();
					}
			);
			
			$("#cmbTipoB").change(
					function () {
						visibleColumnaB();
					}
			);

			function visibleColumnaA(){
				if($('#cmbTipoA').val()==1){
					$('#VerColumnasA').show();
					$('#VerValorA').hide();
				}
				else{
					$('#VerColumnasA').hide();
					$('#VerValorA').show();
				}
			}
			
			function visibleColumnaB(){
				if($('#cmbTipoB').val()==1){
					$('#VerColumnasB').show();
					$('#VerValorB').hide();
				}
				else{
					$('#VerColumnasB').hide();
					$('#VerValorB').show();
				}
			}
			 
			visibleColumnaA();
			visibleColumnaB();			
		})	
		
	<cfelseif rsInfoColumna.Ctipo eq 20><!---- columnas totalizadas----->
		
		function ActualizarConfig(tipo,rwselected,tdestino){
			//tipo 20= totalizadas
			var elementos = [];
			var rwresult = [];
			rwselected.each(function(){
				idElemento = $(this).attr('id');
				elementos.push({referencia: idElemento, subtipo: 0, subvalor: null});
			});

			$.ajax({
				url: "RepDinamicos.cfc"
			  , type: "post"
			  , dataType: "json"
			  , async: true
			  , data: 	{
				  			method: "ActualizarConfigSUM"
				  			,idColumna: <cfoutput>#form.Cid#</cfoutput>
							,tipo: tipo <!--- tipo totalizado---->
							,elementos: JSON.stringify(elementos)
			  			}
			  , success: function (data){
					$.each(data, function(i, item) {
						rwresult.push(item);						
					})
					pasarRows(rwresult, rwselected, tdestino);
			  }
			});
		}	
		     $(function(){    
				 $("table.ListaTotal tr").each(function(){SelectUnselectMe($(this))});
				 $("table.ListaTotalIncluir tr").each(function(){SelectUnselectMe($(this))});
				 $("#incluirTotal").click(function(){
					// $("table.ListaTotal tr").each(function(){ pasarToTable(20,$(this),"#ListaTotalIncluir")
					// })
				    pasarToTable(20,"table.ListaTotal","#ListaTotalIncluir")
				 });
				 $("#excluirTotal").click(function(){
					// $("table.ListaTotalIncluir tr").each(function(){ pasarToTable(20,$(this),"#ListaTotal")
					// })
				    pasarToTable(20,"table.ListaTotalIncluir","#ListaTotal")
				 });
				 $("#incluirTotalTodos").click(function(){   
					passAll("table.ListaTotal tr","#incluirTotal");
				 });
				 $("#excluirTotalTodos").click(function(){
					passAll("table.ListaTotalIncluir tr","#excluirTotal");
				 });
				  
				 $("#filtroTotalA").keyup(function(){
					$("table.ListaTotal tr").each(function(){ 
						filtradoTexto(this,$("#filtroTotalA").val());
					})
				 });
				 $("#filtroTotalB").keyup(function(){
					$("table.ListaTotalIncluir tr").each(function(){ 
						filtradoTexto(this,$("#filtroTotalB").val());
					})
				 });
			 })	
			 

	</cfif>  

	
</script>