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
<cfif isdefined('form.GCcodigo') and form.GCcodigo NEQ ''>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select *
		from ISBgrupoCobro
		where GCcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.GCcodigo#" null="#Len(form.GCcodigo) Is 0#">
	</cfquery>
</cfif>

<cfoutput>

<script type="text/javascript">
<!--
	function validar(formulario){
		var error_input;
		var error_msg = '';
		// Validando tabla: ISBgrupoCobro - Grupo de cobro
		if(!btnSelected('Regresar', formulario) && !btnSelected('Baja', formulario) && !btnSelected('Nuevo', formulario)){
			// Columna: GCcodigo Código Grupo de cobro int
			if (formulario.GCcodigo.value == "") {
				error_msg += "\n - Código Grupo de cobro no puede quedar en blanco.";
				error_input = formulario.GCcodigo;
			}
		
			// Columna: GCnombre Nombre grupo de cobro varchar(100)
			if (formulario.GCnombre.value == "") {
				error_msg += "\n - Nombre grupo de cobro no puede quedar en blanco.";
				error_input = formulario.GCnombre;
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
<form action="ISBgrupoCobro-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
	<cfinclude template="ISBgrupoCobro-hiddens.cfm">
	
	<table summary="Tabla de entrada" width="100%" cellpadding="0" cellspacing="2">
		<tr>
			<td colspan="2" class="subTitulo">
				Grupo de cobro
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>		
		<tr>
			<td valign="top" align="right">
				<label for="GCcodigo">
					Código Grupo de cobro:
				</label>	
			</td>
			<td valign="top">&nbsp;&nbsp;
				<cfset inhabil = "false">
				<cfset valGCcodigo = "">
				<cfif modo NEQ 'ALTA'>
					<cfset inhabil = "true">
					<cfset valGCcodigo = "#HTMLEditFormat(Trim(data.GCcodigo))#">
				</cfif>					
				<cf_campoNumerico 
					readonly="#inhabil#"
					name="GCcodigo" 
					decimales="-1" 
					size="10" 
					maxlength="8" 
					value="#valGCcodigo#" 
					tabindex="1">		
			</td>
		</tr>
		<tr>
			<td valign="top" align="right">	
				<label for="GCnombre">
					Nombre grupo de cobro
				</label>		
			</td>
			<td valign="top">&nbsp;&nbsp;
				<input name="GCnombre" id="GCnombre" 
					type="text" 
					onKeyUp="javascript: validaBlancos(this);"
					value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.GCnombre)#</cfif>" 
					size="80" 
					maxlength="100" tabindex="1"
					onfocus="this.select()"
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
