<cfquery name="rsTiposIdent" datasource="#Session.DSN#">
	select a.Ppersoneria
	from ISBtipoPersona a
	where a.Pfisica = 1
</cfquery>
<cfset personerias = ValueList(rsTiposIdent.Ppersoneria, ',')>

<cfoutput>
	<form method="post" name="form1" action="gestion-contacto-apply.cfm" onsubmit="return validar(this);" style="margin:0">
		
		<cfif form.Pcontacto EQ "nuevo">
			<cfset form.pqc="">
			<cfset form.Pcontacto="">
		</cfif>
		
		<cfinclude template="gestion-hiddens.cfm">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td class="tituloAlterno" align="center">Datos del Contacto</td></tr>
			<tr>
				<td>
					<!--- Datos de la persona --->
					<cf_contacto
						id_cuenta = "#form.CTid#"
						id_contacto = "#form.Pcontacto#"
						form="form1"
						filtrarPersoneria = "#Trim(personerias)#"
						porFila = "true"
						sufijo = "_CT"
					>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr><td align="center" width="100%">
				<cfif Len(Trim(form.Pcontacto))>
					<cfset names = "Guardar,Eliminar,Nuevo">
					<cfset values = "Guardar,Eliminar,Nuevo">
				<cfelse>
					<cfset names = "Guardar,Limpiar">
					<cfset values = "Guardar,Limpiar">
				</cfif>
				<cf_botones names="#names#" values="#values#" tabindex="1">
			</td></tr>
		</table>
	</form>


<script type="text/javascript" language="javascript">
<!--
	function funcNuevo() {
		goPage(document.formArbolGest,'#form.cue#', '','nuevo');
		return false;
	}
	
	function validar(formulario) {
		var error_input;
		var error_msg = '';
		
		if (document.form1.botonSel.value == 'Guardar') {
			// Validando tabla: ISBatributo - Atributo Extendido
			if (formulario.Ppersoneria_CT.value == "") {
				error_msg += "\n - Personería no puede quedar en blanco.";
				error_input = formulario.Ppersoneria_CT;
			}
	
			if (formulario.Pid_CT.value == "") {
				error_msg += "\n - Identificación no puede quedar en blanco.";
				error_input = formulario.Pid_CT;
			} else if (!validar_identificacion_CT()) {
				error_msg += "\n - La Identificación no cumple con la máscara permitida.";
				error_input = formulario.Pid_CT;
			}
			
			if (formulario.Ppersoneria_CT.value != "") {
				if (formulario.Ppersoneria_CT.value == 'J') {
					if (formulario.PrazonSocial_CT.value == "") {
						error_msg += "\n - La razón social no puede quedar en blanco.";
						error_input = formulario.PrazonSocial_CT;
					}
				} else {
					if (formulario.Pnombre_CT.value == "") {
						error_msg += "\n - Nombre no puede quedar en blanco.";
						error_input = formulario.Pnombre_CT;
					}
	
					if (formulario.Papellido_CT.value == "") {
						error_msg += "\n - 1er Apellido no puede quedar en blanco.";
						error_input = formulario.Papellido_CT;
					}
				}
			}
			
			if (formulario.Ppais_CT.value == "") {
				error_msg += "\n - País no puede quedar en blanco.";
				error_input = formulario.Ppais_CT;
			}
	
			if (formulario.AEactividad_CT.value == "") {
				error_msg += "\n - Actividad Económica no puede quedar en blanco.";
				error_input = formulario.AEactividad_CT;
			}
			
			if (formulario.Ptelefono1_CT.value == "") {
				error_msg += "\n - Teléfono no puede quedar en blanco.";
				error_input = formulario.Ptelefono1_CT;
			}
	
			<cfquery name="rsNiveles" datasource="#session.dsn#">
				select coalesce(min(DPnivel), 0) as minNivel, coalesce(max(DPnivel), 0) as maxNivel
				from DivisionPolitica
				where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#session.saci.pais#">
			</cfquery>
			<cfset minnivel = rsNiveles.minNivel>
			<cfset maxnivel = rsNiveles.maxNivel>
			<cfoutput><cfloop condition="maxnivel GTE minnivel">
				if (formulario.LCcod_#minnivel#_CT.value == "") {
					error_msg += "\n - " + formulario.LCcod_#minnivel#_CT.alt + " no puede quedar en blanco.";
					error_input = formulario.LCcod_#minnivel#_CT;
				}
				<cfset minnivel = minnivel + 1>
			</cfloop></cfoutput>
		}
		
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}
		else{ 
			eliminaMascara_CT(); //esta funcion se encuentra dentro del tag de identificacion, y quita los '-','[' y ']' de la identificacion.
			return true;
		} 
	}
//-->
</script>
</cfoutput>