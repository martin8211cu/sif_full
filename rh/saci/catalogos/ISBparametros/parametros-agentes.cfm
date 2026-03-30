<cfif not isdefined("Request.utilesMonto")>

	<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>

	<cfset Request.utilesMonto = true>

</cfif>



<cfquery datasource="#session.dsn#" name="motivosBloqueo">
	select MBmotivo, MBdescripcion
	from ISBmotivoBloqueo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Habilitado!=2
</cfquery>

<cfquery datasource="#session.dsn#" name="vendedores199">

	select Vid, Pnombre || ' ' || Papellido || ' ' || Papellido2 as nombre

	from ISBvendedor v

		join ISBpersona p

			on p.Pquien = v.Pquien

	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	  and v.AGid = 199

</cfquery>



<cfoutput>

	<script language="javascript" type="text/javascript" src="../../js/saci.js">//</script>

	<form name="form1" method="post" action="parametros-apply.cfm" style="margin: 0;" onSubmit="javascript: return validaParams(this);">

		<cfinclude template="parametros-ag-hiddens.cfm">

		<table width="100%" border="0" cellspacing="0" cellpadding="2">

			<tr>

				<td colspan="4">&nbsp;</td>

			</tr>

			<tr>

				<td>&nbsp;</td>

				<td colspan="2">

					<cf_web_portlet_start tipo="box">

					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">

					  <tr>

						<td width="50%" nowrap><label>#parametrosDesc['10']#:</label></td>

						<td>

							<cf_campoNumerico name="param_10" decimales="-1" size="30" maxlength="18" value="#HtmlEditFormat(Trim(paramValues['10']))#" tabindex="1">

						</td>

					  </tr>

					</table>

					<cf_web_portlet_end>

				</td>

				<td>&nbsp;</td>

			</tr>

			<tr>

				<td>&nbsp;</td>

				<td colspan="2" style="text-align:justify">

					Plazo máximo en días para la entrega de la documentación que ampara 

					los registros efectuados. Este es el valor por omisión para la relación 

					del agente comercializador con la empresa, sin embargo por análisis 

					particular de cada relación este puede ser variado, es decir se sugiere 

					este y en la entidad Agente Autorizado se establece el que se utiliza 

					particularmente.

				</td>

				<td>&nbsp;</td>

			</tr>

			<tr>

				<td colspan="4"><hr></td>

			</tr>

			<tr>

				<td>&nbsp;</td>

				<td colspan="2">

					<cf_web_portlet_start tipo="box">

					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">

					  <tr>

						<td width="50%" nowrap><label>#parametrosDesc['20']#:</label></td>

						<td>

							<cf_campoNumerico name="param_20" decimales="-1" size="30" maxlength="18" value="#HtmlEditFormat(Trim(paramValues['20']))#" tabindex="1">

						</td>

					  </tr>

					</table>

					<cf_web_portlet_end>

				</td>

				<td>&nbsp;</td>

			</tr>

			<tr>

				<td>&nbsp;</td>

				<td colspan="2" style="text-align:justify">

					Días de historia para la realización del análisis de calidad en el servicio 

					de los agentes.  este indicador se refiere a días naturales. En el proceso 

					de Asignación de Prospectos, se seleccionan los posibles agentes autorizados 

					de la empresa que posean el area de cobertura que atiende la ubicación 

					proporcionada del prospecto, de esta lista se selecciona aquellos que tengan mejor 

					calificación en los últimos N días.A partir de este parámetro y la fecha actual 

					se determina a partir de cual fecha histórica (se restan los días al día de 

					hoy).
				</td>

				<td>&nbsp;</td>

			</tr>

<!---****************************************************************************************************************************************** --->
			<tr>

				<td>&nbsp;</td>

				<td colspan="2">

					<cf_web_portlet_start tipo="box">

					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">

					  <tr>

						<td width="50%" nowrap><label>#parametrosDesc['21']#:</label></td>

						<td>

							<cf_campoNumerico name="param_21" decimales="-1" size="30" maxlength="18" value="#HtmlEditFormat(Trim(paramValues['21']))#" tabindex="1">

						</td>

					  </tr>

					</table>

					<cf_web_portlet_end>

				</td>

				<td>&nbsp;</td>

			</tr>

			<tr>

				<td>&nbsp;</td>

				<td colspan="2" style="text-align:justify">

					Días de historia para la realización del análisis de calidad a corto plazo en el 
					servicio de los agentes.  este indicador se refiere a días naturales.

				</td>

				<td>&nbsp;</td>

			</tr>
<!---***************************************Motivos de bloqueo por Inhabilitación de Agentes***************************************************--->			
				<td>&nbsp;</td>

				<td colspan="2">

					<cf_web_portlet_start tipo="box">

					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">

					  <tr>
						<td width="50%" nowrap><label>#parametrosDesc['228']#:</label></td>
						<td>
							<select name="param_228" tabindex="1">
								<option value=""></option>
							<cfloop query="motivosBloqueo">
								<option value="#HTMLEditFormat( motivosBloqueo.MBmotivo )#"<cfif Trim(paramValues['228']) EQ Trim(motivosBloqueo.MBmotivo)> selected</cfif>>#HTMLEditFormat( motivosBloqueo.MBdescripcion )#</option>
								</cfloop>
							</select>
						</td>
					  </tr>		  

					</table>

					<cf_web_portlet_end>

				</td>

				<tr>
				<td>&nbsp;</td>

				<td colspan="2" style="text-align:justify">
					Se refiere al motivo de bloqueo que se realiza en las Inhabilitaciones automáticas
					del agente, al vencimiento del período de entrega de la documentación. 
				</td>

				<td>&nbsp;</td>
				</tr>
<!---***************************************************************************************************************************************** --->

			<tr>

				<td colspan="4"><hr></td>

			</tr>

			<tr>

				<td>&nbsp;</td>

				<td colspan="2">

					<cf_web_portlet_start tipo="box">

					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">

					  <tr>

						<td width="50%" nowrap><label>#parametrosDesc['30']#:</label></td>

						<td>

							<cf_campoNumerico name="param_30" decimales="-1" size="30" maxlength="18" value="#HtmlEditFormat(Trim(paramValues['30']))#" tabindex="1">

						</td>

					  </tr>

					</table>

					<cf_web_portlet_end>

				</td>

				<td>&nbsp;</td>

			</tr>

			<tr>

				<td>&nbsp;</td>

				<td colspan="2" style="text-align:justify">

					Días naturales en que el agente debe visitar a un propecto después de 

					su asignación.  El proceso de reasignación de propectos revisa cuando no se ha 

					atendido una asignación previa, la elimina, escribe la  valoración negativa en 

					la bitácora y vuelve a asignar el prospecto a un agente al que no se haya 

					asignado previamente.

				</td>

				<td>&nbsp;</td>

			</tr>

			<tr>

				<td colspan="4"><hr></td>

			</tr>

			<tr>

				<td>&nbsp;</td>

				<td colspan="2">

					<cf_web_portlet_start tipo="box">

					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">

					  <tr>

						<td width="50%" nowrap><label>#parametrosDesc['100']#:</label></td>

						<td>

							<cf_paquete

								id = "#HtmlEditFormat(Trim(paramValues['100']))#"

								form = "form1"

								sufijo = ""

								filtroPaqInterfaz = "0"
								
								PQutilizadoagente = "true"

								funcion = "updParam100"

								showCodigo="false"

							>

							<input type="hidden" name="param_100" value="#HtmlEditFormat(Trim(paramValues['100']))#">

						</td>

					  </tr>

					  <tr>

						<td width="50%" nowrap><label>#parametrosDesc['222']#:</label></td>

						<td>

							<select name="param_222" id="param_222">

							<cfif Not Len(Trim(paramValues['222']))>

								<option value="">Sin definir</option>

							</cfif>

								<cfloop query="vendedores199">

									<option value="#vendedores199.Vid#" <cfif vendedores199.Vid is paramValues['222']>selected</cfif>>#HTMLEditFormat(vendedores199.nombre)#</option>

								</cfloop>

							</select>

						</td>

					  </tr>

					</table>

					<cf_web_portlet_end>

				</td>

				<td>&nbsp;</td>

			</tr>

			<tr>

				<td>&nbsp;</td>

				<td colspan="2" style="text-align:justify">

					Paquete para asignar al agente para acceder y realizar sus ventas.

				</td>

				<td>&nbsp;</td>

			</tr>

			<tr>

				<td colspan="4"><hr></td>

			</tr>						

			<tr>

				<td>&nbsp;</td>

				<td colspan="2" style="text-align:justify">&nbsp;

					

				</td>

				<td>&nbsp;</td>

			</tr>

			<tr>

				<td colspan="4">&nbsp;</td>

			</tr>

			<tr>

				<td colspan="4" align="center">

					<cf_botones names="Guardar" values="Guardar" tabindex="1">

				</td>

			</tr>

			<tr>

				<td colspan="4">&nbsp;</td>

			</tr>

		</table>

	</form>

	

	<script language="javascript" type="text/javascript">

		function updParam100() {

			document.form1.param_100.value = document.form1.PQcodigo.value;

		}



		function updParam220() {

			document.form1.param_220.value = document.form1.Usucodigo.value;

		}

		function getTecla(e){

			var tecla=null;

			

			e = (e) ? e : event

			tecla = (e.which) ? e.which : e.keyCode



			return tecla;

		}		

		function filtraCarac(e,obj){

			var cl = getTecla(e);



			if((cl != 51)&&(cl != 16)&&(cl != 17)&&(cl != 56)&&(cl != 57)&&(cl != 36)&&(cl != 37)&&(cl != 39)){

				if((cl == 32) || (cl == 8))

					obj.value=obj.value.substring(0,obj.value.length);

				else

					obj.value=obj.value.substring(0,obj.value.length-1);

			}

				

		}

		function validaParams(f){

			var error_input;

			var error_msg = '';

		

		if(parseInt(f.param_10.value,10) > 365){

			error_msg += "\n - El Plazo Mximo para Entrega de Documentacin del Agente no debe ser mayor a 365";

			error_input = f.param_10;

		}else{

			if(parseInt(f.param_20.value,10) > 365){

				error_msg += "\n - Plazo para Anlisis de Calidad de Servicio del Agente no debe ser mayor a 365";

				error_input = f.param_20;

			}else{

				if(parseInt(f.param_30.value,10) > 365){

					error_msg += "\n - Plazo para Reasignacin de Prospectos no debe ser mayor a 365";

					error_input = f.param_30;

				}	

				else{

						if (f.param_80.value == "") {

						error_msg += "\n - El Inicio de Perodo de Restriccin para Cambios en Forma de Cobro no puede quedar en blanco.";

						error_input = f.param_80;

					}else{

						if (f.param_90.value == "") {

							error_msg += "\n - El Fn de Perodo de Restriccin para Cambios en Forma de Cobro no puede quedar en blanco.";

							error_input = f.param_90;

						}else{

							if(parseInt(f.param_80.value,10) == 0){

								error_msg += "\n - El Inicio de Perodo de Restriccin para Cambios en Forma de Cobro no puede ser igual a cero.";

								error_input = f.param_80;					

							}else{

								if(parseInt(f.param_90.value,10) == 0){

									error_msg += "\n - El Fn de Perodo de Restriccin para Cambios en Forma de Cobro no puede ser igual a cero.";

									error_input = f.param_90;					

								}else{					

									if(parseInt(f.param_80.value,10) > parseInt(f.param_90.value,10)){

										error_msg += "\n - El Inicio de Perodo de Restriccin para Cambios en Forma de Cobro no puede ser mayor que el \nFn de Perodo de Restriccin para Cambios en Forma de Cobro.";

										error_input = f.param_80;					

									}else{					

									

									}						

								}

							}

						}

					}

				}

			}

		}

			

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

