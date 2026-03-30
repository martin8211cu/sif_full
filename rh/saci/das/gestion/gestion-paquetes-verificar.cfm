
<!---selecciona los servicios inconsistentes(que no son aceptados por el nuevo paquete que se desea cambiar)--->
<cfquery name="rsServiciosIncons" datasource="#session.DSN#">
	select b.LGnumero, b.LGlogin, e.TScodigo
	from ISBproducto a
		inner join ISBlogin b
			on b.Contratoid=a.Contratoid
			and b.Habilitado=1
		inner join ISBserviciosLogin c
			on c.LGnumero=b.LGnumero
			and c.PQcodigo=a.PQcodigo
			and c.TScodigo in(select x.TScodigo from ISBservicioTipo x where x.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
			and c.TScodigo in (<cfqueryparam list="yes" cfsqltype="cf_sql_varchar" value="#ListVerificar#">)
			and c.Habilitado=1
		inner join ISBservicio e
			on e.PQcodigo=c.PQcodigo
			and e.TScodigo=c.TScodigo
			and e.Habilitado =1		
	where a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
	and a.Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
	and a.CTcondicion = '1'
	order by b.LGnumero  	
</cfquery>

<cfquery name="rsPQanterior" datasource="#session.DSN#">
	select PQnombre
	from ISBpaquete 
	where PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.PQanterior#">
	and Habilitado=1
</cfquery>
<cfquery name="rsPQnuevo" datasource="#session.DSN#">
	select PQnombre
	from ISBpaquete 
	where PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.cambioPQ.PQnuevo#">
	and Habilitado=1
</cfquery>

<cfoutput>
<table  width="100%"border="0" cellpadding="0" cellspacing="0">
	<tr><td align="center"><cfinclude template="/saci/das/gestion/gestion-paquetes-cambio-seguimiento.cfm"></td></tr>
	<tr><td>
		<form name="form1" method="post" style="margin: 0;" action="gestion.cfm" onsubmit="javascript: return validar(this);">
			<cfinclude template="gestion-hiddens.cfm">
			<input type="hidden" name="CTid" value="#form.CTid#" />
			<input type="hidden" name="Contratoid" value="#session.saci.cambioPQ.contrato#" />
			<input type="hidden" name="PQcodigo2" value="#session.saci.cambioPQ.PQnuevo#" />
			<input type="hidden" name="ListVerificar" value="#ListVerificar#" />
			<input type="hidden" name="verificar2" value="1" />

			<table  width="100%"border="0" cellpadding="2" cellspacing="0">
				<!---<tr class="tituloAlterno" align="center"><td colspan="6">Cambio de #session.saci.cambioPQ.PQanterior#-#rsPQanterior.PQnombre# a #session.saci.cambioPQ.PQnuevo#-#rsPQnuevo.PQnombre#</td></tr>--->
				<tr class="tituloAlterno" align="center"><td colspan="6">Lista de servicios por login en conflicto con el nuevo paquete</td></tr>
				<tr class="subTitulo">
					<td>Login</td>
					<td>Servicio</td>
					<td>Mantener</td>
					<td>Descartar</td>
					<td colspan="2">Paquete Nuevo</td>
					<!--- <td>&nbsp;</td>  --->
				</tr>
				<cfif rsServiciosIncons.recordCount GT 0>
					<cfloop query="rsServiciosIncons">
					<cfset nom = "_"&rsServiciosIncons.LGnumero&"_"&rsServiciosIncons.TScodigo>
					<tr><td>#rsServiciosIncons.LGlogin#</td>
						<td>#rsServiciosIncons.TScodigo#</td>
						<td align="center"><input  name="r#nom#" id="r#nom#" type="radio" value="1" checked/><!--- <label for="r1#nom#">Mantener</label> ---></td>
						<td align="center"><input name="r#nom#" id="r#nom#" type="radio" value="2"/><!--- <label for="r2#nom#">Descartar</label> ---></td>
						<td align="right"><input name="r#nom#" id="r#nom#" type="radio" value="3"/><!--- <label for="r3#nom#">PaqueteNuevo</label> ---></td>
						<td>
							<table width="100%"border="0" cellpadding="1" cellspacing="0"><tr id="PAQ"><td>
								<cf_paquete 
									sufijo = "#nom#"
									agente = ""
									form = "form1"
									sizeCod = "5"
									sizeDes = "20"
									idCambioPaquete="#session.saci.cambioPQ.PQanterior#"
									filtroPaqInterfaz = "0"
									Ecodigo = "#session.Ecodigo#"
									Conexion = "#session.DSN#"
									showCodigo="false"
								>
							</td></tr></table>
						</td>
					</tr>
					</cfloop>
				</cfif>
				<tr><td align="right" colspan="6">
					<cf_botones names="Verificar,Cancelar" values="Verificar,Cancelar">
				</td></tr>
				
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr><td colspan="6" align="center">
					<cf_web_portlet_start tipo="Box">
					<table class="cfmenu_menu"  width="100%"border="0" cellpadding="1" cellspacing="0">
						<tr><td>
							<strong>Mantener:</strong> Mantener en el nuevo paquete &nbsp;#session.saci.cambioPQ.PQnuevo#-#rsPQnuevo.PQnombre#&nbsp;el servicio inconsistente.
						</td></tr>
						<tr><td>
							<strong>Descartar:</strong> No incluir en el nuevo &nbsp;#session.saci.cambioPQ.PQnuevo#-#rsPQnuevo.PQnombre#&nbsp; paquete el servicio inconsistente.
						</td></tr>
						<tr><td>
							<strong>Paquete Nuevo:</strong> Generar un nuevo paquete además de &nbsp;#session.saci.cambioPQ.PQnuevo#-#rsPQnuevo.PQnombre#&nbsp; para colocar el servicio inconsistente.
						</td></tr>
					</table>
					<cf_web_portlet_end> 
				</td></tr>
				<cfif isdefined("mensajeError") and len(trim(mensajeError))>
				<tr align="center"><td colspan="6">	
					<table  width="95%"border="0" cellpadding="2" cellspacing="0">
						<tr><td>
						<strong><font color="##FF0000">
							Error:#mensajeError#
						</font></strong>
						</td></tr>
					</table>
				</td></tr>
				<cfelseif isdefined("form.verificar2")>
				<tr align="center"><td colspan="6">
					<table  width="95%"border="0" cellpadding="2" cellspacing="0">
						<tr><td>
						<strong><font color="##FF0000">
							Los servicios en la parte superior causan conflicto con el nuevo paquete, 
							puede elegir mantener uno de los servicios que se repiten, pero 
							debe descartar o reubicar en otro paquete el otro servicio.
						</font></strong>
						</td></tr>
					</table>
				</td></tr>
				</cfif>		
			</table>
		</form>
	</td></tr>
</table>
<script type="text/javascript">

	function funcCancelar(){
		document.form1.action="gestion-paquetes-apply.cfm";
		document.form1.submit();
	}
	
	<!-- Validación de los paquetes--->
	function validar(formulario){
		var error_input;
		var error_msg = '';

		<cfif rsServiciosIncons.recordCount GT 0>
			if(document.form1.botonSel.value != 'Cancelar'){	
				var rCoservar = false;
				<cfloop query="rsServiciosIncons">
					<cfset nom = "_"&rsServiciosIncons.LGnumero&"_"&rsServiciosIncons.TScodigo>
					if (formulario.r#nom#[2].checked){			<!---validacion para paquetes adicionales--->
						checkPaqLimpio = false;
						if (formulario.PQcodigo#nom#.value == "") {
							error_msg += "\n - El codigo de Paquete para el Login #rsServiciosIncons.LGlogin# no puede quedar en blanco.";
							error_input = formulario.PQcodigo#nom#;
						}else{
							if(formulario.PQcodigo2.value == formulario.PQcodigo#nom#.value){
								error_msg += "\n - El Paquete seleccionado para el Login #rsServiciosIncons.LGlogin# no puede ser igual a #session.saci.cambioPQ.PQnuevo#-#rsPQnuevo.PQnombre#.";
								error_input = formulario.PQcodigo#nom#;							
							}
						}	
					}
					if (formulario.r#nom#[0].checked){			<!---validacion para que se elija al menos un servicio a conservar en caso de que no exista ningun servio por conservar--->
						rCoservar = true;	
					}
				</cfloop>
	
				if(rCoservar == false){
					if("#servConservar#" == ""){  				<!---"servConservar" son los servicios por conservar que no poseen inconsistencias--->
						if("#len(trim(session.saci.cambioPQ.logConservar.login))#"== "0")
						error_msg += "\n - Debe elejir conservar al menos un servicio que sea válido para el nuevo paquete.";
					
					}
				}
			}
		</cfif>
		
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}
		
		return true;			
	}
</script>
</cfoutput>
	 