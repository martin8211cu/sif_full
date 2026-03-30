<cfif isdefined('form.RHPid') and len(trim(form.RHPid)) gt 0>
	<cfset modo = 'Cambio'>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select  RHPid,
				RHPfecha,
				RHPporc,
				RHPcodigo,
				RHMid,
				RHPjustificacion,
				RHPfunciones,
				RHPestado
		from RHPedimentos where RHPid=#form.RHPid#
		and Ecodigo=#session.Ecodigo#
	</cfquery>
<cfelse>
	<cfset modo='Alta'>
</cfif>

<script type="text/javascript" src="/cfmx/sif/js/FCKeditor/fckeditor.js"></script>

<form name="pedimento" action="pedimento-sql.cfm" method="post" onSubmit="return validacion(this);">
<cfoutput>
<cfif isdefined ('form.RHPid') and len(trim(form.RHPid)) gt 0>
	<input type="hidden" name="RHPid" value="#form.RHPid#" />
</cfif>
	<table border="0">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
				<table border="0">
					<tr>				
						<td>
							<strong><cf_translate key="LB_Fecha_Solicitud">Fecha de Solicitud:</cf_translate></strong>
						</td>
						<td >
							<cfif modo eq 'Alta'>
								<cfset fechahasta=DateFormat(Now(),'DD/MM/YYYY')>
							<cfelse>
								<cfset fechahasta=DateFormat(#rsSQL.RHPfecha#,'DD/MM/YYYY')>
							</cfif>
							<cf_sifcalendario form="pedimento" value="#fechahasta#" name="fecha" tabindex="1">
						</td>
						<td align="right" nowrap="nowrap">
							<strong><cf_translate key="LB_Puesto_Solicitado">Puesto Solicitado:</cf_translate></strong>
						</td>
						<td>
	
							<cfif modo eq 'Alta'>
								<cf_rhpuesto form="pedimento">
							<cfelse>
								<cfquery name="rsPuestos" datasource="#session.dsn#">
									select RHPcodigo,RHPdescpuesto,RHPcodigoext from RHPuestos where RHPcodigo='#rsSQL.RHPcodigo#'
								</cfquery>
								<cf_rhpuesto form="pedimento" query="#rsPuestos#">
							</cfif>
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap">
							<strong><cf_translate key="LB_Porcentaje_ocupacion">Porcentaje de ocupación:</cf_translate></strong>
						</td>
						<td>
							<cfif modo eq 'Alta'>
								<cfset valor=''>
							<cfelse>
								<cfset valor=#rsSQL.RHPporc#>
							</cfif>
							<cf_inputNumber name="montoPor" value="#valor#" size="5" enteros="13" decimales="2" >
						</td>
						<td>
							<strong><cf_translate key="LB_Motivo_Pedimento">Motivo de pedimento:</cf_translate></strong>
						</td>
						<td>
							<cfquery name="rsMot" datasource="#session.dsn#">
								select RHMid,RHMcodigo, RHMdescripcion from RHMotivos
								where Ecodigo=#session.Ecodigo#
							</cfquery>
							<select name="mot" id="mot">  
									<cfloop query="rsMot">
										<option value="#rsMot.RHMid#" <cfif modo neq "ALTA" and rsMot.RHMid  eq rsSQL.RHMid>selected="selected"</cfif>>#rsMot.RHMcodigo#-#rsMot.RHMdescripcion#</option>
									</cfloop>
							</select>
						</td>
					</tr>
					<tr>						
						<td>
							<strong>Justificación:</strong>
						</td>
						<td>
							<input type="text" size="40" maxlength="255" name="txtJust" value="<cfif modo neq 'Alta'>#rsSQL.RHPjustificacion#</cfif>" />
						</td>
						<!---<td align="right">
							<strong>Tipo de Acción:</strong>
						</td>
						<cfquery name="rsTA" datasource="#session.dsn#">
							select RHTid, RHTcodigo,RHTdesc from RHTipoAccion
							where RHTcomportam = 1
							and Ecodigo=#session.Ecodigo#
						</cfquery>
						<td>
							<select name="tipoA" id="mot">  
									<cfloop query="rsTA">
										<option value="#rsTA.RHTid#" <cfif modo neq "ALTA" and rsTA.RHTid  eq rsSQL.RHTid>selected="selected"</cfif>>#rsTA.RHTcodigo#-#rsTA.RHTdesc#</option>
									</cfloop>
							</select>
						</td>--->
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<strong>Funciones básicas, requisitos adicionales y otros: </strong>
			</td>
		</tr>
		<tr>

			<td><!---value="<cfif modo eq 'Cambio'>#trim(rsSQL.RHPfunciones)#</cfif>"--->
			<cfif modo neq 'ALTA'>
				<cf_rheditorhtml name="txtfunciones" value="#trim(rsSQL.RHPfunciones)#">
			<cfelse>
				<cf_rheditorhtml name="txtfunciones" height="150" >
			</cfif>
				
			</td>
		</tr>
		<tr>
			<td>
				<cfif modo eq 'Alta'>
					<cf_botones modo="Alta" include="Regresar">
				<cfelse>
					<cf_botones modo="Cambio" include="Aplicar,Regresar">
				</cfif>
			</td>
		</tr>
	</table>
</cfoutput>
</form>

<script language="JavaScript1.2" type="text/javascript">
	
function validacion(form){
		var mensaje = 'Se presentaron los siguientes problemas:\n';
		var error = false;
		
		if (!btnSelected('Nuevo',form) && !btnSelected('Baja',form) && !btnSelected('Regresar',form) && !btnSelected('Aplicar',form)){		

			if ( trim(form.fecha.value) == '' ){
				mensaje = mensaje + ' - El campo Fecha es requerido\n' 
				form.fecha.style.backgroundColor = '#FFFFCC';
				error = true;
			}
	
			if ( form.RHPcodigo.value == '' ){
				mensaje = mensaje + ' - El campo Puesto es requerido\n' 
				form.RHPcodigo.style.backgroundColor = '#FFFFCC';
				error = true;
			}
			
			if ( trim(form.montoPor.value) == '' ){
				mensaje = mensaje + ' - El campo Porcentaje es requerido\n' 
				form.montoPor.style.backgroundColor = '#FFFFCC';
				error = true;
			}
			
			if (form.montoPor.value == 0){
				mensaje = mensaje + ' - El campo Porcentaje debe ser mayor que cero\n' 
				form.montoPor.style.backgroundColor = '#FFFFCC';
				error = true;
			}
			
			if (form.montoPor.value < 0){
				mensaje = mensaje + ' - El campo Porcentaje debe ser mayor que cero\n' 
				form.montoPor.style.backgroundColor = '#FFFFCC';
				error = true;
			}
			if (form.montoPor.value > 100){
				mensaje = mensaje + ' - El campo Porcentaje debe ser menor que cien\n' 
				form.montoPor.style.backgroundColor = '#FFFFCC';
				error = true;
			}

			if ( trim(form.txtJust.value) == '' ){
				mensaje = mensaje + ' - El campo Justificación es requerido\n' 
				form.txtJust.style.backgroundColor = '#FFFFCC';
				error = true;
			}
			
		}
		if (error){
			alert(mensaje);
			return false;
		}

		return true;
	
		}
		
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
	
	function restaurar_color(obj){
		obj.style.backgroundColor = '#FFFFFF';
	}

	function limpiar() {
		objForm.reset();
	}
	


</script> 