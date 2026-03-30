<cfoutput>
<form method="post" name="form1" action="gestion.cfm" onsubmit="return valida_continuar();">
	<input name="PQcodigo_n" type="hidden" value="<cfif isdefined("form.PQcodigo_n") and len(trim(form.PQcodigo_n))>#form.PQcodigo_n#</cfif>"/>
	<cfloop from="1" to="#maxServicios.cantidad#" index="iLog">
		<input name="LGnumero_#iLog#" type="hidden" value="<cfif isdefined("form.LGnumero_#iLog#") and len(trim(form["LGnumero_#iLog#"]))>#form['LGnumero_#iLog#']#</cfif>"/>					
		<input name="login_#iLog#" type="hidden" value="<cfif isdefined("form.login_#iLog#") and len(trim(form["login_#iLog#"]))>#form['login_#iLog#']#</cfif>"/>					
		<cfif rsPaquete.PQtelefono EQ 1>
				<input name="LGtelefono_#iLog#" type="hidden" value="<cfif isdefined("form.LGtelefono_#iLog#") and len(trim(form["LGtelefono_#iLog#"]))>#form['LGtelefono_#iLog#']#</cfif>"/>					
		</cfif>
		<cfloop query="rsServiciosDisponibles">
			<input name="chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#" type="hidden" value="<cfif isdefined("form.chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#") and len(trim(form["chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#"]))>#form['chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLog#']#</cfif>"/>					
		</cfloop>
	</cfloop>	
	<!--- <input name="CTid_n" type="hidden" value="<cfif isdefined("form.CTid_n") and len(trim(form.CTid_n))>#form.CTid_n#</cfif>"/> --->
	
	<cfinclude template="gestion-hiddens.cfm">
	<table cellpadding="4" cellspacing="4" width="100%">
		<tr>
		  <td>
		  	<cfinclude template="opcionesSel.cfm">
		  </td>
		</tr>
		<tr>
		  <td>
 				<cf_depoGaran
						PQcodigo_cambio="#form.PQcodigo_n#"
						CTid="#form.CTid_n#"
						idpersona="#form.cliente#"
						LGlogin="#form.login_1#"
						codTipos="1,11"
						verOpciones="false"
						sufijo="_n">
		  </td>
		</tr>
		<tr>
		  <td align="center">
		  	<cf_botones values="Cancelar,Volver,Continuar" names="Cancelar,Regresar,Siguiente">
		  </td>
		</tr>
	</table>
	
</form>
	<script language="javascript" type="text/javascript">
		function valida_continuar(){
			var varDepoG=true;
			var varDepoG_session=#session.saci.depositoGaranOK#;		
			var error_msg = '';
			
			if(!varDepoG_session)
				error_msg  +="\n - No se encuentra disponible la Interfaz 'Depósito de Garantía'.";											
			
			if( error_msg != ''){
				alert("Por favor revise los siguiente datos:"+error_msg);
				 return false;
			}
			else{
				if(document.form1.botonSel.value == 'Regresar'){
					document.form1.adser.value = 3;//indica que el siguiente paso es la eleccion de los logines
					return true;
				}else if(document.form1.botonSel.value == 'Cancelar'){
					document.form1.adser.value = 1;
					document.form1.PQcodigo_n.value = "";
					return true;
				}else if(document.form1.botonSel.value == 'Siguiente'){
					if(window.validarDepoGaran)	// Funcion de validacion para el tag depoGaran
						varDepoG = validarDepoGaran();

					if(varDepoG){
						document.form1.adser.value = 5;
						return true;							
					}else{
						return false;
					}
				}
			}
		}
	</script>
</cfoutput>