//------------------------------------------------------------------------------------------
/* Esta funcion toma 2 fechas en formato dia/mes/año y compara la fecha1(primer parametro) con la fecha2(segundo parametro)
		de cinco formas diferentes, en donde el tercer parametro (opc) va a tener 5 valores diferentes 
		si opc = 1
			verifica si la fecha1 es = a la fecha2
		si opc = 2
			verifica si la fecha1 es > a la fecha2
		si opc = 3
			verifica si la fecha1 es < a la fecha2
		si opc = 4
			verifica si la fecha1 es >= a la fecha2
		si opc = 5
			verifica si la fecha1 es <= a la fecha2		*/
		
	function comparaFechas(fecha1,fecha2,opc){
		var res = false;
		var tempFecha1 = fecha1.split('/');
		var tempFecha2 = fecha2.split('/');		
		//Validando que las fechas sean correctas
		if(validaFecha(fecha1) && validaFecha(fecha2)){
			if(opc == 1 || opc == 2 || opc == 3 || opc == 4 || opc == 5){
				tempFecha1[1] = new Number(tempFecha1[1]);
    				tempFecha2[1] = new Number(tempFecha2[1]);
				tempFecha1[1] = (tempFecha1[1] != 0 ) ? tempFecha1[1]-1 : 0 ;
    				tempFecha2[1] = (tempFecha2[1] != 0 ) ? tempFecha2[1]-1 : 0 ;
				var vFecha1 = new Date(tempFecha1[2],tempFecha1[1],tempFecha1[0]);
				var vFecha2 = new Date(tempFecha2[2],tempFecha2[1],tempFecha2[0]);		

				var anio1 = vFecha1.getFullYear();
				var mes1 = vFecha1.getMonth();
				var dia1 = vFecha1.getDate();
				var anio2 = vFecha2.getFullYear();
				var mes2 = vFecha2.getMonth();
				var dia2 = vFecha2.getDate();
										
				switch(opc){
					case 1: {	//compara las fechas (fecha1 = fecha2)
						if(eval(anio1 == anio2) &&	eval(mes1 == mes2) &&  (dia1 == dia2)){
							res = true;
						}else{
							res = false;
						}
					}
					break;
					case 2: {	//compara las fechas (fecha1 > fecha2) -- if(vFecha1 > vFecha2){
						if(anio1 > anio2){
							res = true;
						}else{
							if(anio1 == anio2){
								if(mes1 > mes2){
									res = true;
								}else{
									if(mes1 == mes2){
										if(dia1 > dia2){
											res = true
										}else{
											res = false;
										}
									}else{
										res = false;
									}
								}
							}else{
								res = false;
							}
						}					
					}
					break;					
					case 3: {	//compara las fechas (fecha1 < fecha2)
						if(anio1 < anio2){
							res = true;
						}else{
							if(anio1 == anio2){
								if(mes1 < mes2){
									res = true;
								}else{
									if(mes1 == mes2){
										if(dia1 < dia2){
											res = true
										}else{
											res = false;
										}
									}else{
										res = false;
									}
								}
							}else{
								res = false;
							}
						}					
					}
					break;					
					case 4: {	//compara las fechas (fecha1 >= fecha2)
						if(anio1 >= anio2){
							if(mes1 >= mes2){
								if(dia1 >= dia2){
									res = true
								}else{
									res = false;
								}
							}else{
								res = false;							
							}
						}else{
							res = false;
						}					
					}
					break;
					case 5: {	//compara las fechas (fecha1 <= fecha2)
						if(anio1 <= anio2){
							if(mes1 <= mes2){
								if(dia1 <= dia2){
									res = true
								}else{
									res = false;
								}
							}else{
								res = false;							
							}
						}else{
							res = false;
						}					
					}
					break;										
				}
			}else{
				alert('el tercer parametro de comparaFechas es inválido (rango válido de 1 - 5)');
			}
		}
			
		return res;
	}	

//------------------------------------------------------------------------------------------
	
	function validaFecha(f){
		if (f != "") {
			var partes = f.split ("/");
			var ano = 0, mes = 0; dia = 0;
			if (partes.length == 3) {
				ano = parseInt(partes[2], 10);
				mes = parseInt(partes[1], 10);
				dia = parseInt(partes[0], 10);
			} else if (partes.length == 2) {
				var hoy = new Date;
				ano = hoy.getFullYear();
				mes = parseInt(partes[1], 10);
				dia = parseInt(partes[0], 10); 
			} else {
				alert("La fecha indicada es inválida. Utilice el formato (dd/mm/yyyy)");
				return false;
			}
			if (ano < 100) {
				ano += (ano < 50 ? 2000 : 1900);
			} else if (ano >= 100 && ano < 1900) {
				alert("El año debe ser mayor o igual a 1900");
				return false;
			}
			var d = new Date(ano, mes - 1, dia);
			if (!(d.getFullYear() == ano) && (d.getMonth()    == mes-1) && (d.getDate()     == dia)){
				alert("La fecha indicada es inválida. Utilice el formato (dd/mm/yyyy)");
				return false;
			}
		}
		return true;	
	}	

//------------------------------------------------------------------------------------------