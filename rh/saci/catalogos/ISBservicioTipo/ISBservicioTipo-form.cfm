<cfquery datasource="#session.dsn#" name="param">
	select Pvalor from ISBparametros 
    where Ecodigo = 235
      and Pcodigo = 777
</cfquery>

<cfset mayus = false>
<cfif param.recordCount gt 0 and param.Pvalor eq "TRUE">
	<cfset mayus = true>
</cfif>

<cfset modo = "ALTA">
<cfif isdefined('form.TScodigo') and form.TScodigo NEQ ''>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select *
		from ISBservicioTipo
		where TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TScodigo#" null="#Len(form.TScodigo) Is 0#">
	</cfquery>
</cfif>

<cfoutput>
	<script type="text/javascript">
	<!--
		function validar(formulario){
			var error_input;
			var error_msg = '';
			// Validando tabla: ISBservicioTipo - Tipos de Servicio
			if(!btnSelected('Regresar', formulario) && !btnSelected('Baja', formulario) && !btnSelected('Nuevo', formulario)){			
				// Columna: TScodigo Tipo de servicio char(4)
				if (formulario.TScodigo.value == "") {
					error_msg += "\n - Tipo de servicio no puede quedar en blanco.";
					error_input = formulario.TScodigo;
				}
				// Columna: TSnombre Nombre varchar(80)
				if (formulario.TSnombre.value == "") {
					error_msg += "\n - Nombre no puede quedar en blanco.";
					error_input = formulario.TSnombre;
				}
				// Columna: Habilitado Habilitado smallint
				if (formulario.Habilitado.value == "") {
					error_msg += "\n - Habilitado no puede quedar en blanco.";
					error_input = formulario.Habilitado;
				}
				// Columna: Observacion
				if (formulario.TSobservacion.value == "") {
					error_msg += "\n - Observación no puede quedar en blanco.";
					error_input = formulario.TSobservacion;
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
	<script language="javascript" type="text/javascript" src="../../js/saci.js">//</script>
	<form action="ISBservicioTipo-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
		<cfinclude template="ISBservicioTipo-hiddens.cfm">
		
		<table summary="Tabla de entrada" width="100%" cellpadding="0" cellspacing="2">
		<tr>
			<td colspan="2" class="subTitulo">Tipos de Servicio:</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>			
		<tr>
			<td width="26%" align="right" valign="top">
				<label for="TScodigo">Tipo de servicio:</label>
			</td>
			<td width="74%" valign="top">&nbsp;&nbsp;
				<input name="TScodigo" id="TScodigo" type="text" 
				onblur="javascript: validaBlancos(this);"
				value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.TScodigo)#</cfif>" 
				size="6"
				<cfif modo NEQ 'ALTA'>
					readonly="true"
				</cfif>
				maxlength="4" tabindex="1"
				onfocus="this.select()"  >
			</td>
		</tr>
		<tr>
			<td valign="top" align="right">
				<label for="TSnombre">Nombre:</label>
			</td>
			<td valign="top">&nbsp;&nbsp;
				<input name="TSnombre" id="TSnombre" type="text" 
					onblur="javascript: validaBlancos(this);"
					value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.TSnombre)#</cfif>" 
					size="80"
					maxlength="80" tabindex="1"
					onfocus="this.select()" 
					<cfif mayus>
						onblur="this.value = this.value.toUpperCase()"
					</cfif>
					>
			</td>
		</tr>
		<tr>
			<td valign="top" align="right">
				<label for="Habilitado">Habilitado:</label>
			</td>
			<td valign="top">&nbsp;&nbsp;
				<select name="Habilitado" id="Habilitado" tabindex="1">
					<option value="0" <cfif modo NEQ 'ALTA' and data.Habilitado is '0'>selected</cfif> >
						Inactivo temporal
					</option>
					<option value="1" <cfif modo NEQ 'ALTA' and data.Habilitado is '1'>selected</cfif> >
						Activo
					</option>
					<option value="2" <cfif modo NEQ 'ALTA' and data.Habilitado is '2'>selected</cfif> >
						Borrado lógico
					</option>
					<option value="3" <cfif modo NEQ 'ALTA' and data.Habilitado is '3'>selected</cfif> >
						En creación
					</option>
				</select>
			</td>
		</tr>		
		<tr>
			
			<td valign="top" align="right">
			<label for="Grupo de datos para Configuración">Grupo de datos para Configuración:</label>
			</td>
			<td valign="top">&nbsp;&nbsp;
					<select name="TStipo" id="TStipo" tabindex="2">
					
						<option value="A" <cfif modo NEQ 'ALTA' and data.TStipo is 'A'>selected</cfif> >
							Grupo Acceso Conmutado						</option>
					
						<option value="C" <cfif  modo NEQ 'ALTA' and data.TStipo is 'C'>selected</cfif> >
							Grupo de Correo						</option>
				
						<option value="N" <cfif  modo NEQ 'ALTA' and data.TStipo is 'N'>selected</cfif> >
							Grupo de Cablemodem						</option>
				</select>
			</td>
		

<!---
			<td valign="top" align="right">
				<label for="TSdescripcion">Descripción:</label>
			</td>
			<td valign="top">&nbsp;&nbsp;
				<textarea 
					name="TSdescripcion" 
					cols="75" rows="3" 
					onKeyUp="javascript: validaBlancos(this);"
					id="TSdescripcion" tabindex="1" 
					onFocus="this.select()"><cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.TSdescripcion)#</cfif></textarea>
			</td>
--->
		</tr>

		<tr>
			<td valign="top" align="right">
				<label for="TSobservacion">Observaciones:</label>
			</td>
			<td valign="top">&nbsp;&nbsp;
				<textarea name="TSobservacion" 
					cols="75" rows="3" 
					id="TSobservacion" 
					onblur="javascript: validaBlancos(this);"
					tabindex="1" 
					onFocus="this.select()"><cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.TSobservacion)#</cfif></textarea>
			</td>
		</tr>
	

		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>		
		<tr>
			<td colspan="2" class="formButtons">
				<cf_botones modo="#modo#" include="Regresar" tabindex="1">
			</td>
		</tr>
	</table>
		<cfif modo NEQ 'ALTA' and isdefined('data')>
			<input type="hidden" name="Ecodigo" value="#HTMLEditFormat(data.Ecodigo)#">
			<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
			<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		</cfif>
	</form>
</cfoutput>