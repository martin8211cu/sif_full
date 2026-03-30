
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
<cfif isdefined('form.AEactividad') and form.AEactividad NEQ ''>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select *
		from ISBactividadEconomica
		where AEactividad = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AEactividad#" null="#Len(form.AEactividad) Is 0#">
	</cfquery>
</cfif>

<cfoutput>
	<script type="text/javascript">
	<!--
		function validar(formulario){
			var error_input;
			var error_msg = '';
			
			// Validando tabla: ISBactividadEconomica - Actividad Económica		
			if(!btnSelected('Regresar', formulario) && !btnSelected('Baja', formulario) && !btnSelected('Nuevo', formulario)){
				// Columna: AEactividad Código actividad int
				
				if (formulario.AEactividad.value == ""){
					error_msg += "\n - Código actividad no puede quedar en blanco.";
					error_input = formulario.AEactividad;
				}
				// Columna: AEnombre Nombre actividad varchar(100)
				if (formulario.AEnombre.value == "")   {
					error_msg += "\n - Nombre actividad no puede quedar en blanco.";
					error_input = formulario.AEnombre;
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
	<form action="ISBactividadEconomica-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
		<cfinclude template="ISBactividadEconomica-hiddens.cfm">
		
		<table summary="Tabla de entrada" width="100%" cellpadding="0" cellspacing="2">
			<tr>
				<td colspan="2" class="subTitulo">
					Actividad Económica
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>			
			<tr>
				<td width="29%" align="right" valign="top">
					<label for="AEactividad">
						C&oacute;digo actividad:
					</label>
				</td>
				<td width="71%" valign="top">&nbsp;&nbsp;
					<cfset inhabil = "false">
					<cfset valEactiv = "">
					<cfif modo NEQ 'ALTA'>
						<cfset inhabil = "true">
						<cfset valEactiv = "#HTMLEditFormat(Trim(data.AEactividad))#">
					</cfif>					
					
					<cf_campoNumerico 
						readonly="#inhabil#"
						name="AEactividad" 
						decimales="-1" 
						size="10" 
						maxlength="8" 
						value="#valEactiv#" 
						tabindex="1">											
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="AEnombre">
						Nombre actividad:
					</label>
				</td>
				<td valign="top">&nbsp;&nbsp;
					<input name="AEnombre" type="text" 
						id="AEnombre" tabindex="1"
						onfocus="this.select()" 
						onblur="javascript: validaBlancos(this);"
						value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.AEnombre)#</cfif>" 
						size="80" 
						maxlength="100"
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
