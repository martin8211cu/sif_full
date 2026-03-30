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
<cfif isdefined('form.CCclaseCuenta') and form.CCclaseCuenta NEQ ''>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select *
		from ISBclaseCuenta
		where CCclaseCuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CCclaseCuenta#" null="#Len(form.CCclaseCuenta) Is 0#">
	</cfquery>
</cfif>

<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario){
		var error_input;
		var error_msg = '';
		// Validando tabla: ISBclaseCuenta - Clase de cuenta
		if(!btnSelected('Regresar', formulario) && !btnSelected('Baja', formulario) && !btnSelected('Nuevo', formulario)){
			// Columna: CCclaseCuenta Código clase de cuenta int
			if (formulario.CCclaseCuenta.value == "") {
				error_msg += "\n - Código clase de cuenta no puede quedar en blanco.";
				error_input = formulario.CCclaseCuenta;
			}
		
			// Columna: CCnombre Nombre clase de cuenta varchar(100)
			if (formulario.CCnombre.value == "") {
				error_msg += "\n - Nombre clase de cuenta no puede quedar en blanco.";
				error_input = formulario.CCnombre;
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
<form action="ISBclaseCuenta-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
	<cfinclude template="ISBclaseCuenta-hiddens.cfm">
	
	<table summary="Tabla de entrada" width="100%" cellpadding="0" cellspacing="2">
		<tr>
			<td colspan="2" class="subTitulo">
				Clase de cuenta
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>		
		<tr>
			<td width="23%" align="right" valign="top">
				<label for="CCclaseCuenta">
					C&oacute;digo clase de cuenta:
				</label>
			</td>
			<td width="77%" valign="top">&nbsp;&nbsp;
				<cfset inhabil = "false">
				<cfset valClaseC = "">
				<cfif modo NEQ 'ALTA'>
					<cfset inhabil = "true">
					<cfset valClaseC = "#HTMLEditFormat(Trim(data.CCclaseCuenta))#">
				</cfif>					
				
				<cf_campoNumerico 
					readonly="#inhabil#"
					name="CCclaseCuenta" 
					decimales="-1" 
					size="10" 
					maxlength="8" 
					value="#valClaseC#" 
					tabindex="1">		
			</td>
		</tr>
		<tr>
			<td valign="top" align="right">
				<label for="CCnombre">
					Nombre clase de cuenta:
				</label>	
			</td>
			<td valign="top">&nbsp;&nbsp;
				<input name="CCnombre" 
					type="text" 
					id="CCnombre" 
					onFocus="this.select()" 
					onKeyUp="javascript: validaBlancos(this);"
					value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.CCnombre)#</cfif>" 
					size="80" maxlength="100"
					<cfif mayus>
							onblur="this.value = this.value.toUpperCase()"
						</cfif>
					>
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
