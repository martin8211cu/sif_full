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
<cfif isdefined('form.MRid') and form.MRid NEQ ''>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select *
		from  ISBmotivoRetiro
		where MRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MRid#" null="#Len(form.MRid) Is 0#">
	</cfquery>
</cfif>

<script type="text/javascript">
<!--
	function validar(formulario){
		var error_input;
		var error_msg = '';
		// Validando tabla: ISBmotivoRetiro - ISBmotivoRetiro
		if(!btnSelected('Regresar', formulario) && !btnSelected('Baja', formulario) && !btnSelected('Nuevo', formulario)){
			// Columna: MRcodigo Código motivo varchar(10)
			if (formulario.MRcodigo.value == "") {
				error_msg += "\n - Código motivo no puede quedar en blanco.";
				error_input = formulario.MRcodigo;
			}			
			
			// Columna: MRnombre Nombre Motivo varchar(60)
			if (formulario.MRnombre.value == "") {
				error_msg += "\n - Nombre Motivo no puede quedar en blanco.";
				error_input = formulario.MRnombre;
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
	<form action="ISBmotivoRetiro-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
		<cfinclude template="ISBmotivoRetiro-hiddens.cfm">
		
		<table summary="Tabla de entrada" width="100%" cellpadding="0" cellspacing="2">
			<tr>
				<td colspan="2" class="subTitulo">
					ISBmotivoRetiro
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td width="28%" align="right" valign="top">
					<label for="MRcodigo">Código motivo:</label>
				</td>
				<td width="72%" valign="top">
					<input name="MRcodigo" type="text" id="MRcodigo" tabindex="1"
					    onblur="javascript: validaBlancos(this);"
						onfocus="this.select()" value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.MRcodigo)#</cfif>" size="12" 
						maxlength="10"  >
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="MRnombre">Nombre motivo:</label>
				</td>
				<td valign="top">
					<input name="MRnombre" type="text" 
						id="MRnombre" tabindex="1"
						onfocus="this.select()" 
						onblur="javascript: validaBlancos(this);"
						value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.MRnombre)#</cfif>" size="62" 
						maxlength="60"  
						<cfif mayus>
							onblur="this.value = this.value.toUpperCase();javascript: validaBlancos(this);"
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
			<input type="hidden" name="MRid" value="#HTMLEditFormat(data.MRid)#">
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