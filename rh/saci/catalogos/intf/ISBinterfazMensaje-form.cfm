<cfset modo = "ALTA">
<cfif isdefined('form.codMensaje') and form.codMensaje NEQ ''>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select *
			from  ISBinterfazMensaje 
		where codMensaje = <cfqueryparam cfsqltype="cf_sql_char" value="#form.codMensaje#" null="#Len(form.codMensaje) Is 0#">
	</cfquery>
</cfif>

<script type="text/javascript">
<!--
	function validar(formulario){
		var error_input;
		var error_msg = '';
		// Validando tabla: ISBinterfazMensaje - ISBinterfazMensaje 
		if(!btnSelected('Regresar', formulario) && !btnSelected('Baja', formulario) && !btnSelected('Nuevo', formulario)){
			// Columna: codMensaje Número msg XXX-9999 char(8)
			if (formulario.codMensaje.value == "") {
				error_msg += "\n - El número de mensaje es requerido.";
				error_input = formulario.codMensaje;
			}
			formulario.codMensaje.value = formulario.codMensaje.value.toUpperCase();
			if(!/^[A-Z]{3}-[0-9]{4}$/.test(formulario.codMensaje.value)){
				error_msg += "\n - El número de mensaje debe tener el formato XXX-9999.";
				error_input = formulario.codMensaje;
			}
			// Columna: mensaje Descripcion mensaje varchar(255)
			if (formulario.mensaje.value == "") {
				error_msg += "\n - La descripcion es requerida.";
				error_input = formulario.mensaje;
			}
			// Columna: severidad (Error/Incons/Ok) char(1)
			if (formulario.severidad.value == "") {
				error_msg += "\n - La severidad es requerido.";
				error_input = formulario.severidad;
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
//-->
</script>
<cfoutput>
	<form action="ISBinterfazMensaje-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
		<cfinclude template="ISBinterfazMensaje-hiddens.cfm">
		
		<table summary="Tabla de entrada" width="100%" cellpadding="0" cellspacing="2">
			<tr>
		  		<td colspan="2" class="subTitulo">
					Definición del mensaje
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>			
			<tr>
				<td valign="top" align="right">
					<label for="codMensaje">N&uacute;mero:&nbsp;</label>
				</td>
				<td valign="top">
					<input name="codMensaje" id="codMensaje" type="text" 
						value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.codMensaje)#</cfif>" 
						maxlength="8" tabindex="1"
						onfocus="this.select()"  >
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="mensaje">Descripción:&nbsp;</label>
				</td>
				<td valign="top">
					<input name="mensaje" id="mensaje" type="text" size="50"
						value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.mensaje)#</cfif>" 
						maxlength="255" tabindex="1"
						onfocus="this.select()"  >
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="severidad">
						Severidad:&nbsp;
					</label>
				</td>
				<td valign="top">
					<select name="severidad" id="severidad" tabindex="1">
						<option value="-10" <cfif modo NEQ 'ALTA' and isdefined('data') and data.severidad is '-10'>selected</cfif> >
							Debug
						</option>
						<option value="0" <cfif modo NEQ 'ALTA' and isdefined('data') and data.severidad is '0'>selected</cfif> >
							Info
						</option>
						<option value="10" <cfif modo NEQ 'ALTA' and isdefined('data') and data.severidad is '10'>selected</cfif> >
							Warning
						</option>
						<option value="20" <cfif modo NEQ 'ALTA' and isdefined('data') and data.severidad is '20'>selected</cfif> >
							Error
						</option>
					</select>
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="mensaje">Código en Interfaz:&nbsp;</label>
				</td>
				<td valign="top">
					<cfset v ="">
					<cfif modo NEQ 'ALTA' and isdefined('data')>
						<cfset v = trim(data.codmensajeinterfaz)>
					</cfif>
					<cf_campoNumerico name="codmensajeinterfaz" decimales="-1" size="15" maxlength="12" value="#v#">
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>						
			<tr>
				<td colspan="2" class="formButtons">
					<cf_botones modo="#modo#" include="Regresar" tabindex="1">
				</td>
			</tr>
		</table>
		<cfif modo NEQ 'ALTA' and isdefined('data')>
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
			<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
		</cfif>			
	</form>
</cfoutput>