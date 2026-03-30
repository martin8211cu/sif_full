<cfset modo = "ALTA">
<cfif isdefined('form.interfaz') and form.interfaz NEQ ''>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select *
		from  ISBinterfaz 
		where interfaz = <cfqueryparam cfsqltype="cf_sql_char" value="#form.interfaz#" null="#Len(form.interfaz) Is 0#">
	</cfquery>
</cfif>

<script type="text/javascript">
<!--
	function validar(formulario){
		var error_input;
		var error_msg = '';
		// Validando tabla: ISBinterfaz - ISBinterfazCatalogo 
		if(!btnSelected('Regresar', formulario) && !btnSelected('Baja', formulario) && !btnSelected('Nuevo', formulario)){
			// Columna: interfaz Codigo char(5)
			if (formulario.interfaz.value == "") {
				error_msg += "\n - El código no puede quedar en blanco.";
				error_input = formulario.interfaz;
			}
			if(!/^[A-Z][0-9]{3,4}.?$/.test(formulario.interfaz.value)){
				error_msg += "\n - El código debe tener el formato X999 o X9999.";
				error_input = formulario.interfaz;
			}
		
			// Columna: nombreInterfaz Nombre de interfaz varchar(255)
			if (formulario.nombreInterfaz.value == "") {
				error_msg += "\n -El nombre de la interfaz no puede quedar en blanco.";
				error_input = formulario.nombreInterfaz;
			}
		
			// Columna: componente Componente CFC varchar(255)
			if (formulario.componente.value == "") {
				error_msg += "\n - El componente CFC no puede quedar en blanco.";
				error_input = formulario.componente;
			}
		
			// Columna: metodo Metodo varchar(255)
			if (formulario.metodo.value == "") {
				error_msg += "\n - El método no puede quedar en blanco.";
				error_input = formulario.metodo;
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
	<form action="ISBinterfaz-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
		<cfinclude template="ISBinterfaz-hiddens.cfm">
		
		<table summary="Tabla de entrada" width="100%" cellpadding="0" cellspacing="2">
			<tr>
				<td colspan="2" class="subTitulo">
					Detalle de la interfaz				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td width="280" align="right" valign="top">
					<label for="interfaz">
						Código:					</label>				</td>
				<td width="715" valign="top">&nbsp;&nbsp;
					<input name="interfaz" id="interfaz" type="text"  size="6" <cfif modo NEQ 'ALTA'> readonly="true"</cfif>
						value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.interfaz)#</cfif>" 
						maxlength="5" tabindex="1"
						onfocus="this.select()"  >				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="nombreInterfaz">
						Nombre:					</label>				</td>
				<td valign="top">&nbsp;&nbsp;
					<input name="nombreInterfaz" id="nombreInterfaz" type="text" value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.nombreInterfaz)#</cfif>" 
						maxlength="255" tabindex="1" size="80"
						onfocus="this.select()"  >				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="componente">
						Componente (CFC):					</label>				</td>
				<td valign="top">&nbsp;&nbsp;
					<input name="componente" id="componente" type="text" value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.componente)#</cfif>" 
						maxlength="255" tabindex="1" size="80"
						onfocus="this.select()"  >				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="metodo">
						Componente (Método):					</label>				</td>
				<td valign="top">&nbsp;&nbsp;
					<input name="metodo" id="metodo" type="text" value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.metodo)#</cfif>" 
						maxlength="255" tabindex="1" size="80"
						onfocus="this.select()"  >				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="S02ACC">
						Letra (S02ACC)					</label>				</td>
				<td valign="top">&nbsp;&nbsp;
					<input name="S02ACC" id="S02ACC" type="text" value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.S02ACC)#</cfif>" 
						maxlength="1" tabindex="1" size="2"
						onfocus="this.select()"  >				</td>
			</tr>
			<tr>
			  <td valign="top" colspan="2">&nbsp;</td>
		  </tr>
			<tr>
			  <td valign="top" class="subTitulo" align="right">Severidad mínima requerida para </td>
			  <td valign="top" class="subTitulo" align="right">&nbsp;</td>
		  </tr>
			<tr>
				<td valign="top" align="right">
					<label for="severidad_reenvio">
				Permitir reenviar la operación</label>				</td>
				<td valign="top">&nbsp;&nbsp;
					<select name="severidad_reenvio" id="severidad_reenvio" tabindex="1">
						<option value="-10" <cfif modo NEQ 'ALTA' and isdefined('data') and data.severidad_reenvio is '-10'>selected</cfif> >
							Debug						</option>
						<option value="0" <cfif modo NEQ 'ALTA' and isdefined('data') and data.severidad_reenvio is '0'>selected</cfif> >
							Info						</option>
						<option value="10" <cfif modo NEQ 'ALTA' and isdefined('data') and data.severidad_reenvio is '10'>selected</cfif> >
							Warning						</option>
						<option value="20" <cfif modo NEQ 'ALTA' and isdefined('data') and data.severidad_reenvio is '20'>selected</cfif> >
							Error						</option>
					</select>				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="severidad_log">
				Guardar en bitácora 					</label>				</td>
				<td valign="top">&nbsp;&nbsp;
					<select name="severidad_log" id="severidad_log" tabindex="1">
						<option value="-10" <cfif modo NEQ 'ALTA' and isdefined('data') and data.severidad_log is '-10'>selected</cfif> >
							Debug						</option>
						<option value="0" <cfif modo NEQ 'ALTA' and isdefined('data') and data.severidad_log is '0'>selected</cfif> >
							Info						</option>
						<option value="10" <cfif modo NEQ 'ALTA' and isdefined('data') and data.severidad_log is '10'>selected</cfif> >
							Warning						</option>
						<option value="20" <cfif modo NEQ 'ALTA' and isdefined('data') and data.severidad_log is '20'>selected</cfif> >
							Error						</option>
					</select>				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td colspan="2" class="formButtons">
					<cf_botones modo="#modo#" include="Regresar" tabindex="1">				</td>
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

