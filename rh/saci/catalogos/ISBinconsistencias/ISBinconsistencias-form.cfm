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
<cfif isdefined('form.Iid') and form.Iid NEQ ''>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select *
		from  ISBinconsistencias
		where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Iid#" null="#Len(form.Iid) Is 0#">
	</cfquery>
</cfif>

<script type="text/javascript">
<!--
	function validar(formulario){
		var error_input;
		var error_msg = '';
		// Validando tabla: ISBinconsistencias - Inconsistencias
		if(!btnSelected('Regresar', formulario) && !btnSelected('Baja', formulario) && !btnSelected('Nuevo', formulario)){
			// Columna: Inombre Nombre varchar(80)
			if (formulario.Inombre.value == "") {
				error_msg += "\n - Nombre no puede quedar en blanco.";
				error_input = formulario.Inombre;
			}
			// Columna: Idescripcion Descripción varchar(1024)
			if (formulario.Idescripcion.value == "") {
				error_msg += "\n - Descripción no puede quedar en blanco.";
				error_input = formulario.Idescripcion;
			}
			// Columna: Iseveridad Severidad char(1)
			if (formulario.Iseveridad.value == "") {
				error_msg += "\n - Severidad no puede quedar en blanco.";
				error_input = formulario.Iseveridad;
			}
			// Columna: Ipenalizada Penalizada bit
			if (formulario.Ipenalizada.value == "") {
				error_msg += "\n - Penalizada no puede quedar en blanco.";
				error_input = formulario.Ipenalizada;
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
	<script language="javascript" type="text/javascript" src="../../js/saci.js">//</script>
	<form action="ISBinconsistencias-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
		<cfinclude template="ISBinconsistencias-hiddens.cfm">
		
		<table summary="Tabla de entrada" width="100%" cellpadding="0" cellspacing="2">
			<tr>
				<td colspan="2" class="subTitulo">
					Inconsistencias
				</td>
			</tr>
			<tr>
				<td width="25%" align="right" valign="top">
					<label for="Inombre">
						Nombre:
					</label>	
				</td>
				<td width="75%" valign="top">&nbsp;&nbsp;
					<input name="Inombre" 
						type="text" 
						id="Inombre"
						onfocus="this.select()" 
						onblur="javascript: validaBlancos(this);"
						value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.Inombre)#</cfif>" 
						size="80" 
						maxlength="80" 
						<cfif mayus>
							onblur="this.value = this.value.toUpperCase()"
						</cfif>
						
						>
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="Inombre">
						Descripci&oacute;n:
					</label>					
				</td>
				<td valign="top">&nbsp;&nbsp;
					<textarea name="Idescripcion" 
						cols="77" rows="3" 
						id="Idescripcion"
						onFocus="this.select()"
						onblur="javascript: validaBlancos(this);"><cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.Idescripcion)#</cfif></textarea>
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="Iseveridad">
						Severidad:
					</label>					
				</td>
				<td valign="top">&nbsp;&nbsp;
					<select name="Iseveridad" id="Iseveridad" tabindex="1">
						<option value="0" <cfif modo NEQ 'ALTA' and isdefined('data') and data.Iseveridad is '0'>selected</cfif> >
							Advertencia
						</option>
						<option value="1" <cfif modo NEQ 'ALTA' and isdefined('data') and data.Iseveridad is '1'>selected</cfif> >
							Leve
						</option>
						<option value="2" <cfif modo NEQ 'ALTA' and isdefined('data') and data.Iseveridad is '2'>selected</cfif> >
							Grave
						</option>
						<option value="3" <cfif modo NEQ 'ALTA' and isdefined('data') and data.Iseveridad is '3'>selected</cfif> >
							Improcedente
						</option>
					</select>
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="Ipenalizada">
						Penalizada:
					</label>					
				</td>
				<td valign="top">&nbsp;
					<input name="Ipenalizada" id="Ipenalizada" type="checkbox" value="1" <cfif  modo NEQ 'ALTA' and isdefined('data') and Len(data.Ipenalizada) And data.Ipenalizada> checked</cfif> tabindex="1">
				</td>
			</tr>
			<tr>
				<td colspan="2" class="formButtons">
					<cf_botones modo="#modo#" include="Regresar" tabindex="1">	
				</td>
			</tr>
		</table>
		<cfif modo NEQ 'ALTA' and isdefined('data')>
			<input type="hidden" name="Iid" value="#HTMLEditFormat(data.Iid)#">
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