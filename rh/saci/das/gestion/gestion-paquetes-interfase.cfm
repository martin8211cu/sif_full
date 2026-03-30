<!-------------------------------------PINTADO DE CAMBIO DE PAQUETE --------------------------------------->
<cfquery name="rsAllContratos" datasource="#session.DSN#">
	select a.Contratoid, b.*, 
		   (select sum(SVcantidad) from ISBservicio x where x.PQcodigo = b.PQcodigo and x.TScodigo = 'MAIL' and x.Habilitado = 1) as CantidadCorreos
	from ISBproducto a
		inner join ISBpaquete b
			on b.PQcodigo = a.PQcodigo
			and b.Habilitado=1
		inner join ISBcuenta c
			on c.CTid = a.CTid
			and c.Habilitado=1
			and c.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente#">
	where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
		and a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
		and a.CTcondicion = '1'
	order by a.Contratoid
</cfquery>




<cfoutput>


	<cfparam name="url.recargaok" default="">
	<cfif url.recargaok is 1>
		<cf_message text="El cambio ha sido aplicado" type="information">
	<cfelseif url.recargaok is 0>
		<cf_message text="La transacción ha sido rechazada" type="error">
	</cfif>
	
	<form name="form1" method="post" style="margin: 0;" action="gestion-paquetes-apply.cfm" onsubmit="javascript: return validar(this);">
		<cfinclude template="gestion-hiddens.cfm">
		<input type="hidden" name="PQcodigo1" id="PQcodigo1" value="#rsAllContratos.PQcodigo#"/>
		<table width="100%" border="0" cellspacing="0" cellpadding="1">	  	
				
				
				<!-------------------------------------Pintado del XSL de PAQUETE si existe la Tarea Programada--------------------------------------->
				<cfquery name="rsExisteTarea" datasource="#session.DSN#">
					select TPid,TPxml,TPfecha
					from ISBtareaProgramada 
					where 	Contratoid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
							and CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
							and TPestado = 'P'
							and TPtipo = 'CP'
				</cfquery>

				<tr valign="top"><td class="tituloAlterno" align="center" colspan="4"> Tarea Programada</td></tr>	
				<cfif isdefined("rsExisteTarea.TPid") and len(trim(rsExisteTarea.TPid))>
					
					<tr><td colspan="4" align="center"><label>Fecha</label>
							&nbsp;#LSDateFormat(rsExisteTarea.TPfecha,'dd-mm-yyyy')#</td>
					</tr>
					<tr><td colspan="4">
						<cfsavecontent variable="Lvarxsl"><cfinclude template="/saci/xsd/cambioPaquete.xsl"></cfsavecontent><!--- Paquete XSL--->
						<cfoutput>#XmlTransform(rsExisteTarea.TPxml, Lvarxsl)#</cfoutput>
					</td></tr>
					<cfif not isdefined("session.saci.cambioPQ.estado") or session.saci.cambioPQ.estado NEQ 1>	
						<tr><td colspan="4" align="center">
								<cf_botones names="Eliminar" values="Eliminar">
						</td></tr>
					</cfif>
					<tr><td colspan="4"><hr /></td></tr>
				<cfelse>
					<tr><td colspan="4" align="center"><strong>--- No Existe Tarea Programada ---</strong></td></tr>	
				</cfif>
				
				<!-------------------------------------Pintado para modificar el PAQUETE actual--------------------------------------->
				<cfif not isdefined("session.saci.cambioPQ.estado") or session.saci.cambioPQ.estado EQ 0>	
					<tr valign="top"><td class="tituloAlterno" align="center" colspan="4"> Nuevo Paquete</td></tr>	
					<tr>
						<td align="right" valign="middle">Paquete</td>
						<td colspan="3" valign="top">
							<cfif isdefined("session.saci.cambioPQ.PQnuevo")and len(trim(session.saci.cambioPQ.PQnuevo)) and session.saci.cambioPQ.estado EQ 1><!---para saber si esta en el estado de terminar---> 
								<cfset PQnuevo=session.saci.cambioPQ.PQnuevo>
								<cfset read="true">
								&nbsp;
							<cfelse>
								<cfset PQnuevo ="">
								<cfset read="false">				
							</cfif>
							<cf_paquete 
								id = "#PQNuevo#"
								sufijo = "2"
								agente = ""
								form = "form1"
								funcion = "solicitarCampos2"
								idCambioPaquete="#rsAllContratos.PQcodigo#"
								filtroPaqInterfaz = "0"
								readOnly ="#read#"
								Ecodigo = "#session.Ecodigo#"
								Conexion = "#session.DSN#"
								showCodigo="false"
							>
						</td>
					</tr>
				
					<tr>
						<td align="right" >Tarifa B&aacute;sica</td>
						<td>
							<input type="text" name="PQtarifaBasica2" class="cajasinbordeb" style="text-align: right;"  value="<cfif isdefined("rsPQnuevo.PQtarifaBasica") and len(trim(rsPQnuevo.PQtarifaBasica))><cfoutput>#LSNumberFormat(rsPQnuevo.PQtarifaBasica,',9.00')#</cfoutput></cfif>" width="20" readonly  tabindex="1"/>
						</td>
						<td align="right" >Horas Mensuales</td>
						<td>
							<input type="text" name="PQhorasBasica2" class="cajasinbordeb" style="text-align: right;"  value="<cfif isdefined("rsPQnuevo.PQhorasBasica") and len(trim(rsPQnuevo.PQhorasBasica))><cfoutput>#LSNumberFormat(rsPQnuevo.PQhorasBasica,',9.00')# </cfoutput></cfif>"width="20" readonly  tabindex="1"/>
						</td>
					</tr>
					
					<tr>
						<td align="right" >Costo Hora Adicional</td>
						<td>
							<input type="text" name="PQprecioExc2" class="cajasinbordeb" style="text-align: right;"  value="<cfif isdefined("rsPQnuevo.PQprecioExc") and len(trim(rsPQnuevo.PQprecioExc))><cfoutput> #LSNumberFormat(rsPQnuevo.PQprecioExc,',9.00')#</cfoutput></cfif>"width="20" readonly  tabindex="1"/>
						</td>
						<td align="right" >Cantidad Correos</td>
						<td>
							<input type="text" name="CantidadCorreos2" class="cajasinbordeb" style="text-align: right;"  value="<cfif isdefined("rsPQnuevo.CantidadCorreos") and len(trim(rsPQnuevo.CantidadCorreos))><cfoutput>#LSNumberFormat(rsPQnuevo.CantidadCorreos,',9.00')# </cfoutput></cfif>"width="20" readonly  tabindex="1"/>
						</td>
					</tr>
					
					<tr>
						<td align="right" nowrap>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right">Cuota Mail</td>
						<td>
							<input type="text" name="PQmailQuota2" class="cajasinbordeb" style="text-align: right;" width="20"  value="<cfif isdefined("rsPQnuevo.PQmailQuota") and len(trim(rsPQnuevo.PQmailQuota))><cfoutput>#LSNumberFormat(rsPQnuevo.PQmailQuota,'9')# </cfoutput></cfif>" readonly  tabindex="1"/> KB
							<script language="javascript" type="text/javascript">
								function solicitarCampos2() {																<!---Determina que tipos de servicio va a tener cada login --->
									for (var i=1; i<=3; i++) {
										var x = eval('document.form1.Login_Tipo_'+i);
										x.value = "0";
									}
									for (var i=1; i<=3 && i<=parseInt(document.form1.vCantidad_CABM2.value); i++) {
										var x = eval('document.form1.Login_Tipo_'+i);
										x.value = "" + (parseInt(x.value) + 1);
									}
									
									for (var i=1; i<=3 && i<=parseInt(document.form1.vCantidad_ACCS2.value); i++) {
										var x = eval('document.form1.Login_Tipo_'+i);
										x.value = "" + (parseInt(x.value) + 2);
									}
									for (var i=1; i<=3 && i<=parseInt(document.form1.vCantidad_MAIL2.value); i++) {
										var x = eval('document.form1.Login_Tipo_'+i);
										x.value = "" + (parseInt(x.value) + 4);
									}
									
									document.form1.PQtarifaBasica2.value = document.form1.vPQtarifaBasica2.value;
									document.form1.PQhorasBasica2.value = document.form1.vPQhorasBasica2.value;
									document.form1.PQprecioExc2.value = document.form1.vPQprecioExc2.value;
									document.form1.PQmailQuota2.value = document.form1.vPQmailQuota2.value;
									document.form1.CantidadCorreos2.value = document.form1.vCantidadCorreos2.value;
									for (var i=1; i<=3; i++) {
										var x = eval('document.form1.Login_Tipo_'+i);
										var y = eval('document.form1.Login_'+i);
										var z = eval('document.form1.Snumero_'+i);
										if (x.value == '0') {
											y.disabled = true;
											<!--- z.disabled = true; --->
										} else {
											y.disabled = false;
											<!--- z.disabled = false; --->
										}
									}
								}
							</script>
						</td>
					</tr>
					
					<tr id="log1">
						<td align="right">Login 1 (Principal)</td>
						<td>
							<input type="text" name="Login_1" size="35" maxlength="30" class="cajasinbordeb" style="text-align: right;"   tabindex="1"/>
							<input type="hidden" name="Login_Tipo_1" value="0"/>
						</td>
					</tr>
					<tr id="log2">
						<td align="right">Login 2</td>
						<td>
							<input type="text" name="Login_2" size="35" maxlength="30" class="cajasinbordeb" style="text-align: right;"  tabindex="1"/>
							<input type="hidden" name="Login_Tipo_2" value="0" />
						</td>
					</tr>
					<tr id="log3">
						<td align="right">Login 3</td>
						<td>
							<input type="text" name="Login_3" size="35" maxlength="30" class="cajasinbordeb" style="text-align: right;"  tabindex="1"/>
							<input type="hidden" name="Login_Tipo_3" value="0" />
						</td>		
					</tr>
				</cfif>
				
				<!-------------------------------------Pintado del XML del PAQUETE Actual en proceso--------------------------------------->
				<cfif isdefined("session.saci.cambioPQ.estado") and session.saci.cambioPQ.estado EQ 1>	
					<tr><td colspan="4">			 	<cfinclude template="/saci/das/gestion/gestion-paquetes-cambio-tarea.cfm">					  <!---Pinta el xml del paquete actual en proceso, ademas toma en cuenta los logines por conservar que no fueron tomadoas en un inicio por que no eraan incosistentes, ademas usa la lista "loginMasBorrar" para que no se tomen en cuenta los logines que se dividen en las diferentes listas---> 
					</td>
					</tr>					
					<tr><td colspan="4">&nbsp;</td></tr>					
					<tr>
						<td align="right"><input name="radio" type="radio" value="1" checked/></td>
						<td><table border="0" cellpadding="0" cellspacing="0"><tr>
							<td align="right"><label>Cambiar en la fecha</label></td>
							<td><cf_sifcalendario  name="fretiro" value="#LSDateFormat(now(),'dd/mm/yyyy')#"></td>
							</tr></table>
						</td>
						<td align="right"><input name="radio" type="radio" value="2" /></td>
						<td><label>Cambiar en este momento</label></td>
					</tr>
				</cfif>
				<tr><td colspan="4">&nbsp;</td></tr>
				<!------------------------------------------------Pintado de Botones------------------------------------------------------->
				<tr><td align="right" colspan="4">
					 <cfif isdefined("session.saci.cambioPQ.estado") and session.saci.cambioPQ.estado EQ 1>	
						<cfset etiqueta = "Aceptar,Cancelar">
					 <cfelse>
						<cfif isdefined("Session.saci.cambioPQ")>										<!---Borra la session en caso de que exista--->
							<cfset StructDelete(Session.saci, "cambioPQ")>
						</cfif>
						<cfset etiqueta = "Verificar"> 
					 </cfif>
					<cf_botones names="#etiqueta#" values="#etiqueta#" tabindex="1">
				</td></tr>
			</table>
		
			<cfif isdefined("session.saci.cambioPQ.estado") and session.saci.cambioPQ.estado EQ 1>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td align="center">						
							<cfset session.saci.depositoGaranOK = true>
							<cf_depoGaran
								CTid="#form.CTid#"
								sufijo="_#session.saci.cambioPQ.PQnuevo#"
								idpersona="#form.Cli#"
								idcontrato="#form.contratoid#"
								PQcodigo_cambio="#session.saci.cambioPQ.PQnuevo#">						
	
							<cfif isdefined('arrPqPA') and ArrayLen(arrPqPA) GT 0>
								<cfloop index="contSufijos" from = "1" to = "#ArrayLen(arrPqPA)#">	
									<cf_depoGaran
										CTid="#form.CTid#"
										sufijo="_#arrPqPA[contSufijos]#"
										idpersona="#form.Cli#"
										idcontrato="#form.contratoid#"
										PQcodigo_cambio="#arrPqPA[contSufijos]#">							
								</cfloop>	
							</cfif>
						</td>
					</tr>
				</table>									
			</cfif>
	</form>
	
	<script type="text/javascript" language="javascript">
		<cfif not isdefined("session.saci.cambioPQ.estado") or session.saci.cambioPQ.estado EQ 0>	
			document.getElementById("log1").style.display="none";
			document.getElementById("log2").style.display="none";
			document.getElementById("log3").style.display="none";
		</cfif>
		
		function funcVerificar(){	
			document.form1.action="gestion.cfm";
		}	
		
		function funcEliminar(){	
			if (confirm("¿Desea Eliminar la Tarea Programada?")){
				document.form1.botonSel.value="Eliminar";
				return true;
			}
			else return false;
		}			
		
		//<!--- Validación de los paquetes--->
		function validar(formulario)
		{
			var listaSuf = "";
			var error_input;
			var error_msg = '';
			
			
			<cfif isdefined('listaSufijos') and len(trim(listaSufijos))>
				listaSuf = "#listaSufijos#";
			</cfif>
				
			<cfif isdefined("session.saci.cambioPQ.estado") and session.saci.cambioPQ.estado EQ 1>
				var varDepoG=true;
				var varDepoG_session=#session.saci.depositoGaranOK#;
			</cfif>
						
			if(document.form1.botonSel.value=="Aceptar"){				
				if (formulario.radio == false) {
					error_msg += "\n - Debe seleccionar una fecha de retiro, ó Retirar en este momento el paquete.";
					error_input = formulario.radio;
				}
				
				if (validarSupcriptor(formulario)==false){//funcion que se encuentra en gestion-paquetes-cambio-tarea.cfm
					error_msg += "\n - Debe digitar el Nombre del Subscritor y el No Subscriptor";
					error_input = formulario.CNsuscriptor;
				}
				
				var mens = validarTelefono(formulario);
				if (mens!=""){//funcion que se encuentra en gestion-paquetes-cambio-tarea.cfm
					error_msg += mens;
				}
				<cfif isdefined("session.saci.cambioPQ.estado") and session.saci.cambioPQ.estado EQ 1>
					if(!varDepoG_session)
						error_msg  +="\n - No se encuentra disponible la Interfaz 'Depósito de Garantía', no se permite el cambio de paquete.";															
				</cfif>
			}
			<cfif not isdefined("session.saci.cambioPQ.estado") or session.saci.cambioPQ.estado EQ 0>	
				if(document.form1.botonSel.value != "Eliminar"){
					if (formulario.PQcodigo2.value == "") {
						error_msg += "\n - El código de Paquete no puede quedar en blanco.";
						error_input = formulario.PQcodigo2;
					}
				}
			</cfif>
			
			// Validacion terminada
			if (error_msg != '') {
				alert("Por favor revise los siguiente datos:"+error_msg);
				return false;
			}else{
				if(document.form1.botonSel.value=="Aceptar"){
					if(listaSuf != ""){
						var arrSufijos = listaSuf.split(',');
						for(var i=0; i < arrSufijos.length; i++){
							if(eval("window.validarDepoGaran" + arrSufijos[i])){		// Funcion de validacion para cada paquete con el tag depoGaran
								varDepoG = eval("validarDepoGaran" + arrSufijos[i] + "();");
								if(!varDepoG)
									break;
							}
						}
					}							
	
					if(varDepoG){
						if(confirm("¿Esta seguro que desea realizar el cambio de paquete ?"))
							return true;				
						else 
							return false;							
					}else{
						return false;
					}			
				}else{
					return true;	
				}
			}
		}
	
	</script>
</cfoutput>
