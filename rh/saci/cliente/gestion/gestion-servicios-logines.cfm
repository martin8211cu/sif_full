<cfoutput>
	<cfset alignEtiquetas = "right">
	<cfset MODO = "ALTA">
	<form method="post" name="form1" action="gestion.cfm" onsubmit="return valida_continuar();" style="margin:0">
		<input name="PQcodigo_n" type="hidden" value="<cfif isdefined("form.PQcodigo_n") and len(trim(form.PQcodigo_n))>#form.PQcodigo_n#</cfif>"/>
		<cfinclude template="gestion-hiddens.cfm">
		
		<table cellpadding="4" cellspacing="4" width="100%" border="0">
			<tr>
				<td valign="top">
					<cfinclude template="opcionesSel.cfm">
				</td>
				<td rowspan="3" align="center" valign="top">
				<cf_web_portlet_start tipo="box">
				<table border="0" cellspacing="0" cellpadding="0">
				<tr><td  class="cfmenu_menu">
					<b>Indicaciones:</b><br>
					digite el login o nombre de usuario en el ó los campos requeridos.<br>
					En la parte inferior de cada login puede encontrar las opciones q posee cada uno, 
					si lo desea, puede agregar o descartar mas opciones. 
				</td></tr>
				</table>				<cf_web_portlet_end>			</td>
			</tr>
			<tr>
				<td valign="top" align="center">
					<strong>Digite los logines, para el nuevo servicio.</strong>
				</td>
			</tr>			
			
			<tr><td align="center" width="60%">
					<table border="0"cellspacing="2" cellpadding="2">
						
						<cfloop from="1" to="#maxServicios.cantidad#" index="iLog">
							<tr>
								<td align="#alignEtiquetas#"><label>Login #iLog#</label></td>
								<td>
									<cfset lo = "">
									<cfif isdefined("form.login_#iLog#") and len(trim(form["login_#iLog#"]))>
										<cfset lo = form["login_#iLog#"]>
										<cfset MODO = "CAMBIO">
									</cfif>
									<cf_login
										idpersona = "#form.cli#"
										value = "#lo#"
										form = "form1"
										sufijo = "_#iLog#"
										Ecodigo = "#session.Ecodigo#"
										Conexion = "#session.DSN#"
										size="14"
									>
								</td>
								<cfif rsPaquete.PQtelefono EQ 1>
									<td>
										&nbsp;&nbsp;<label>Tel&eacute;fono</label>&nbsp;&nbsp;
									</td>
									<td>
										<cfset te = "">
										<cfif isdefined("form.LGtelefono_#iLog#") and len(trim(form["LGtelefono_#iLog#"]))>
											<cfset te = form["LGtelefono_#iLog#"]>
										</cfif>
										<cf_campoNumerico 
												name="LGtelefono_#iLog#" 
												decimales="-1" 
												size="10" 
												maxlength="15" 
												value="#te#" 
												nullable="true"
												tabindex="1">
									</td>
								</cfif>
							  </tr>
							 <tr><td <cfif rsPaquete.PQtelefono EQ 1>colspan="4"<cfelse>colspan="2"</cfif>>
								<table border="0" cellspacing="2" cellpadding="2" width="100%">
									<tr><td align="center"></td></tr>
									<cfloop query="rsServiciosDisponibles">
										<cfif iLog LTE rsServiciosDisponibles.SVcantidad>
											<tr>
											<td align="right">&nbsp;&nbsp;
												<input type="checkbox" 
													name="chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#" 
													value="#Trim(rsServiciosDisponibles.TScodigo)#" 
													tabindex="1" 
													<cfif isdefined("form.chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#") and len(trim(form["chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#"]))>checked</cfif>/>
											</td>
											<td>#HTMLEditFormat(rsServiciosDisponibles.descripcion)#</td>
											</tr>
										</cfif>
									</cfloop>
								</table>
							  </td></tr>
						  </cfloop>  
					</table>
					<br><cf_botones values="Cancelar,Volver,Continuar" names="Cancelar,Regresar,Siguiente">
			</td>
			</tr>
			
		</table>
	</form>
	
	
	<script language="javascript" type="text/javascript">
		var maxVal = "";
		var maxValnum = 0;		
		var minVal = "";
		var minValnum = 0;			
		<cfloop query="rsServiciosDisponibles">//chequea los checkbox segun la cantidad maxima de servicios permitidos por el paquete, y deshabilita los servicios indispensables para el paquete
			maxVal = "<cfoutput>#rsServiciosDisponibles.SVcantidad#</cfoutput>";
			maxValnum = new Number(maxVal);
			minVal = "<cfoutput>#rsServiciosDisponibles.SVminimo#</cfoutput>";
			minValnum = new Number(minVal);
			
			for (var i=1; i<=#maxServicios.cantidad#; i++) {
				if(i <= maxValnum){
					var x = eval('document.form1.chk_#Trim(rsServiciosDisponibles.TScodigo)#_'+i);
					
					<cfif MODO EQ "ALTA"> //marca automaticamente los logines si es la primera vez q pasa por este paso
						x.checked = (i <= maxValnum);
					</cfif>
					x.disabled = (i <= minValnum);
				}
			}
		</cfloop>
		
		function valida_continuar(){
			var error_msg = '';
			var ninguno = true;
			var sinCheck = true;
			var opciones = new Array(10);
			var cont = 0 ;
			maxVal = "";
			maxValnum = 0;		
			minVal = "";
			minValnum = 0;						
			
			if(document.form1.botonSel.value == 'Siguiente'){
				
				for (var i=1; i<=#maxServicios.cantidad#; i++) { //valida que al menos se digite un login y que se tomen los servicios minimos
					var y = eval('document.form1.Login_'+i);
					
					<cfloop query="rsServiciosDisponibles">	
						maxVal = "<cfoutput>#rsServiciosDisponibles.SVcantidad#</cfoutput>";
						maxValnum = new Number(maxVal);
						minVal = "<cfoutput>#rsServiciosDisponibles.SVminimo#</cfoutput>";
						minValnum = new Number(minVal);						
						if(i <= maxValnum)
							var x = eval('document.form1.chk_#Trim(rsServiciosDisponibles.TScodigo)#_'+i);
						
						if(y.value != ""){
							ninguno = false;	//Valida que se digite almenos un login
							if(i <= maxValnum){
								if(x.checked == true){
									 sinCheck = false;	
									 
									 opciones[cont] = '#Trim(rsServiciosDisponibles.TScodigo)#'; //genera un arreglo con todos las opciones(sevicios) elejidas que sera usado mas adelante								 
									 cont++;
								}
							}
							//Valida que el login que posee una opcion(servicio) obligatorio no este en blanco
							if( x.disabled){
								if(y.value == ""){	
									error_msg = error_msg + '\n El login'+i+ ' no puede quedar en blanco.';
								}
							}	
						}
					</cfloop>
					
					if(y.value != "" && sinCheck){	//Valida que se seleccione almenos una opcion (servicio) por cada login dejitado
						error_msg = error_msg + '\n El login' + i + ' debe poseer al menos una opción activa ó ser descartado.';
					}else sinCheck = true;
					
					<cfif rsPaquete.PQtelefono EQ 1>//valida que los telefonos que poseen logines no esten en blanco, en caso de q se necesiten telefonos
					var w = eval('document.form1.LGtelefono_'+i);
					if(y.value != ""){				
						if(w.value == ""){
							error_msg = error_msg + '\n El teléfono del login'+i+ ' no puede quedar en blanco.';
						}else{
							if(w.value.length < 7){
								error_msg = error_msg + '\n El teléfono del login'+i+ ' es inválido, mínimo son 7 dígitos.';
							}
						}
					}
					</cfif>	
					
				}
				if(ninguno)	error_msg = error_msg + '\n Debe digitar al menos un login ó nombre de usuario.';
								
				//valida que se cumpla con el minimo y maximo de los servicios requeridos
				<cfloop query="rsServiciosDisponibles"> 
					var cantidad=0;
					var i=0;
					for (i=0; i < 10; i++){	
						if (opciones[i] == '#rsServiciosDisponibles.TScodigo#'){	
							cantidad++;
						}
					}

					if( #rsServiciosDisponibles.SVcantidad# < cantidad)	
						error_msg += "\n - Debe descartar opciones de tipo #Trim(rsServiciosDisponibles.descripcion)#.";
					else 
					if (#rsServiciosDisponibles.SVminimo# > cantidad)	
						error_msg += "\n Debe agregar opciones de tipo #Trim(rsServiciosDisponibles.descripcion)#.";
				</cfloop>
				
			}
			
			if( error_msg != ''){
				alert("Por favor revise los siguiente datos:"+error_msg);
				 return false;
			}
			else{
				//deschequea los checkbox que no poseen login, y habilita los checks desabilitados
				maxVal = "";
				maxValnum = 0;		
				minVal = "";
				minValnum = 0;							
				<cfloop query="rsServiciosDisponibles">		
					maxVal = "<cfoutput>#rsServiciosDisponibles.SVcantidad#</cfoutput>";
					maxValnum = new Number(maxVal);
					minVal = "<cfoutput>#rsServiciosDisponibles.SVminimo#</cfoutput>";
					minValnum = new Number(minVal);				
					for (var i=1; i<=#maxServicios.cantidad#; i++) {
						if(i <= maxValnum){
							var x = eval('document.form1.chk_#Trim(rsServiciosDisponibles.TScodigo)#_'+i);
							x.disabled = false;
						}
						var y = eval('document.form1.Login_'+i);//marca automaticamente los logines si es la primera vez q pasa por este paso
						
						if (y.value ==""){
							if(i <= maxValnum)
								x.checked = false;
						}
					}
				</cfloop>
				
				if(document.form1.botonSel.value == 'Regresar')
					document.form1.adser.value = 1;//indica que el siguiente paso es la eleccion de los logines
				
				else if(document.form1.botonSel.value == 'Cancelar'){
					document.form1.adser.value = 1;
					document.form1.PQcodigo_n.value = "";
				}else if(document.form1.botonSel.value == 'Siguiente'){
					document.form1.adser.value = 3;//indica que el siguiente paso es la eleccion de los logines
					document.form1.action="gestion-servicios-revLogines.cfm";
				}
				
				return true;
			}
		}
	</script>
	
	
</cfoutput>