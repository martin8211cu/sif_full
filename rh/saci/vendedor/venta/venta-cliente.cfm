<cfoutput>
	<form method="post" name="form1" action="venta-cliente-apply.cfm" onsubmit="return validar(this);" style="margin:0">
		<input type="hidden" name="CTid" value="<cfif isdefined("form.CTid") and Len(Trim(form.CTid))>#form.CTid#<cfelseif isdefined("form.cue") and Len(Trim(form.cue))>#form.cue#</cfif>" />
		<cfinclude template="venta-hiddens.cfm">

		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<!--- Datos del prospecto --->					
					<cf_persona
						keyProspecto = "#isdefined('url.prospecto') and Len(Trim(url.prospecto))#"
						id = "#Form.Pquien#"
					>

				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr><td align="center" width="100%">
				<cf_botones names="Guardar,Eliminar" values="Guardar,Eliminar" tabindex="1">
			</td></tr>
		</table>
	</form>
</cfoutput>

<script type="text/javascript">
<!--
	function funcEliminar(){
		if (document.form1.Pquien.value == "") {
			alert("Error, primero seleccione una persona en el campo de identificación.");
			return false;
		}
		
		return true;
	}
	
	function validar(formulario) {
		var error_input;
		var error_msg = '';
		
		if(formulario.botonSel.value != 'Eliminar'){
			if (formulario.Ppersoneria.value == "") {
				error_msg += "\n - Personería no puede quedar en blanco.";
				error_input = formulario.Ppersoneria;
			}
	
			if (formulario.Pid.value == "") {
				error_msg += "\n - Identificación no puede quedar en blanco.";
				error_input = formulario.Pid;
			} else if (!validar_identificacion()) {
				error_msg += "\n - La Identificación no cumple con la máscara permitida.";
				error_input = formulario.Pid;
			}
			
			if (formulario.Ppersoneria.value != "") {
				if (formulario.Ppersoneria.value == 'J') {
					if (formulario.PrazonSocial.value == "") {
						error_msg += "\n - La razón social no puede quedar en blanco.";
						error_input = formulario.PrazonSocial;
					}
						
					if (! (/^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]*$/.test(formulario.PrazonSocial.value))) 
					{
						error_msg += "\n - El campo razón social sólo se permite el ingreso de letras.";
						error_input = formulario.PrazonSocial;
					}
				
				
				} else {
					if (formulario.Pnombre.value == "") {
						error_msg += "\n - Nombre no puede quedar en blanco.";
						error_input = formulario.Pnombre;
					}
	
					if (! (/^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]*$/.test(formulario.Pnombre.value))) 
					{
						error_msg += "\n - El campo Nombre sólo se permite el ingreso de letras.";
						error_input = formulario.Pnombre;
					}

					if (formulario.Papellido.value == "") {
						error_msg += "\n - 1er Apellido no puede quedar en blanco.";
						error_input = formulario.Papellido;
					}
					
					if (! (/^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]*$/.test(formulario.Papellido.value))) 
					
					{
						error_msg += "\n - El campo Apellido sólo se permite el ingreso de letras.";
						error_input = formulario.Papellido;
					}

					if (! (/^[A-Za-zÁÉÍÓÚáéíóúÑñ]*$/.test(formulario.Papellido2.value))) 
					
					{
						error_msg += "\n - El campo 2do Apellido sólo se permite el ingreso de letras.";
						error_input = formulario.Papellido2;
					}

				
				}
			}
			
			if (formulario.Ppais.value == "") {
				error_msg += "\n - País no puede quedar en blanco.";
				error_input = formulario.Ppais;
			}
	
			if (formulario.AEactividad.value == "") {
				error_msg += "\n - Actividad Económica no puede quedar en blanco.";
				error_input = formulario.AEactividad;
			}
			
			if (formulario.Ptelefono1.value == "") {
				error_msg += "\n - Teléfono no puede quedar en blanco.";
				error_input = formulario._Ptelefono1;
			}

			/*if (formulario.CPid.value == "") {
				error_msg += "\n - El Código Postal es requerido.";
				error_input = formulario.CPid;
			}
			*/
			if (formulario.Pdireccion.value == "") {
				error_msg += "\n - La Dirección no puede quedar en blanco.";
				error_input = formulario.CPid;
			}

			if (! (/^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]*$/.test(formulario.Pbarrio.value))) 
			
			{
				error_msg += "\n - El campo Barrio sólo se permite el ingreso de letras.";
				error_input = formulario.Pbarrio;
			}

			if (! (/^[A-Za-z0-9ÁÉÍÓÚáéíóúÑñ.\s]*$/.test(formulario.Pdireccion.value))) 
			
			{
				error_msg += "\n - El campo Dirección Exacta tiene caracteres no válidos.";
				error_input = formulario.Pdireccion;
			}

			if (! (/^[A-Za-z0-9ÁÉÍÓÚáéíóúÑñ\s]*$/.test(formulario.Pobservacion.value))) 
			
			{
				error_msg += "\n - El campo Observaciones tiene caracteres no válidos.";
				error_input = formulario.Pobservacion;
			}

			<cfquery name="rsNiveles" datasource="#session.dsn#">
				select coalesce(min(DPnivel), 0) as minNivel, coalesce(max(DPnivel), 0) as maxNivel
				from DivisionPolitica
				where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.pais#">
			</cfquery>
			<cfset minnivel = rsNiveles.minNivel>
			<cfset maxnivel = rsNiveles.maxNivel>
			<cfoutput><cfloop condition="maxnivel GTE minnivel">
				if (formulario.LCcod_#minnivel#.value == "") {
					error_msg += "\n - " + formulario.LCcod_#minnivel#.alt + " no puede quedar en blanco.";
					error_input = formulario.LCcod_#minnivel#;
				}
				<cfset minnivel = minnivel + 1>
			</cfloop></cfoutput>
		}else{
			if(!confirm('Desea eliminar esta persona ?')){
				return false;
			}
		}
		<!--- Validacion terminada --->
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}else{  
			eliminaMascara(); //esta funcion se encuentra dentro del tag de identificacion, y quita los '-','[' y ']' de la identificacion.
		}
		if(!emailCheck(formulario.Pemail.value))
			return false;			
		return true;
	}
//-->
</script>
