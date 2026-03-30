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
<cfif isdefined('form.rangoid') and form.rangoid NEQ ''>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select *
		from  ISBrangoValoracion
		where rangoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.rangoid#" null="#Len(form.rangoid) Is 0#">
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
			if (formulario.rangodes.value == "") {
				error_msg += "\n - Nombre no puede quedar en blanco.";
				error_input = formulario.rangodes;
			}
			// Columna: rangodes int
			if (parseInt(formulario.rangotope.value) > 100 || parseInt(formulario.rangodes.value) < 0) {
				error_msg += "\n - Porcentaje mínimo no válido.";
				error_input = formulario.rangotope;
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
	<form action="ISBrangoValoracion-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
		<cfinclude template="ISBrangoValoracion-hiddens.cfm">
		
		<table summary="Tabla de entrada" width="100%" cellpadding="0" cellspacing="2">
			<tr>
				<td colspan="2" class="subTitulo">
					Rangos de Calificación
				</td>
			</tr>
			<tr>
				<td width="25%" align="right" valign="top">
					<label for="rangodes">
						Descripción:
					</label>	
				</td>
				<td width="75%" valign="top">&nbsp;&nbsp;
					<input name="rangodes" 
						type="text" 
						id="rangodes"
						onfocus="this.select()" 
						onblur="javascript: validaBlancos(this);"
						value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.rangodes)#</cfif>" 
						size="50" 
						maxlength="100" 
						<cfif mayus>
							onblur="this.value = this.value.toUpperCase()"
						</cfif>
						
						>
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="rangotope">
						 °Porcentaje Mínimo >= %
					</label>					
				</td>
				<td valign="top">&nbsp;&nbsp;				
				<cfif modo NEQ 'ALTA' and isdefined('data')>
					<cf_inputNumber 
					readonly="false" 
					name="rangotope" 
					decimales="0" 
					enteros="3"
					value="#HTMLEditFormat(data.rangotope)#"
					comas="false"
					>
				<cfelse>
					<cf_inputNumber 
					readonly="false" 
					name="rangotope" 
					decimales="0" 
					enteros="3"
					value=""
					comas="false"
					>						
				</cfif>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="formButtons">
					<cf_botones modo="#modo#" include="Regresar" tabindex="1">	
				</td>
			</tr>
			<tr>
			<td colspan="2" valign="top" align="left">&nbsp;&nbsp;		
					<label for="porcentajeminimo">
						 °Se refiere al porcentaje mínimo de calificación que debe obtener un Agente para obtener la nota.
					</label>					
			</td>
			</tr
		></table>
		<cfif modo NEQ 'ALTA' and isdefined('data')>
			<input type="hidden" name="rangoid" value="#HTMLEditFormat(data.rangoid)#">
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