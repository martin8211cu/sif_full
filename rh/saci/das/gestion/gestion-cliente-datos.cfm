<cfoutput>
	<form method="post" name="form1" action="gestion-cliente-datos-apply.cfm" onsubmit="return validar(this);" style="margin:0">
		<cfinclude template="gestion-hiddens.cfm">

		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<!--- Datos del cliente --->					
					<cf_persona
						id = "#Form.Cliente#"
						form="form1"
						incluyeTabla="true"
						porFila="true"
						columnas="2"
						readOnly_Pid="true"
					>

				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr><td align="center" width="100%">
				<cf_botones names="Guardar" values="Guardar" tabindex="1">
			</td></tr>
		</table>
	</form>
</cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario) {
		var error_input;
		var error_msg = '';

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
			} else {
				if (formulario.Pnombre.value == "") {
					error_msg += "\n - Nombre no puede quedar en blanco.";
					error_input = formulario.Pnombre;
				}

				if (formulario.Papellido.value == "") {
					error_msg += "\n - 1er Apellido no puede quedar en blanco.";
					error_input = formulario.Papellido;
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
			error_input = formulario.Ptelefono1;
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
