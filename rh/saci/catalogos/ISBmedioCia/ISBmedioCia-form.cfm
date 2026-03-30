<cfset modo = "ALTA">
<cfif isdefined('form.EMid') and form.EMid NEQ ''>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select EMid, Ecodigo, TAtarifa, EMnombre, EMlogo, 
			EMcorreoReciboFacturas,
			EMcorreoEnvioFacturas,
			BMUsucodigo, ts_rversion
		from  ISBmedioCia
		where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EMid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<cfquery datasource="#session.dsn#" name="ISBtarifas">
	select TAtarifa, TAnombreTarifa
	from ISBtarifa
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<script type="text/javascript">
<!--
	function validar(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: ISBmedioCia - Empresa de Medio 
		if(!btnSelected('Regresar', formulario) && !btnSelected('Baja', formulario) && !btnSelected('Nuevo', formulario))
		{
			// Columna: EMnombre Nombre Empresa varchar(100)
			if (formulario.EMnombre.value == "") 
			{
				error_msg += "\n - Nombre Empresa no puede quedar en blanco.";
				error_input = formulario.EMnombre;
			}
		}
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}
		if(!emailCheck(formulario.EMcorreoEnvioFacturas.value))
			return false;		
		
		return true;
	}
//-->
</script>
<cfoutput>

	<script language="javascript" type="text/javascript" src="../../js/checkEmail.js">//</script>
	<script language="javascript" type="text/javascript" src="../../js/saci.js">//</script>
	<form action="ISBmedioCia-apply.cfm" onsubmit="return validar(this);" enctype="multipart/form-data" method="post" name="form1" id="form1">
		<cfinclude template="ISBmedioCia-hiddens.cfm">
		
		<table summary="Tabla de entrada" width="100%" cellpadding="0" cellspacing="2">
			<tr>
				<td colspan="2" class="subTitulo">
					Empresa de Medio
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>			
			<tr>
				<td width="35%" align="right" valign="top">
					<label for="EMnombre">
						Nombre Empresa:
					</label>	
				</td>
				<td width="65%" valign="top">
					<input style="text-transform:uppercase" 
					name="EMnombre" 
					id="EMnombre" 
					type="text" 
					onfocus="this.select()" 
					onblur="javascript: validaBlancos(this);"
					value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.EMnombre)#</cfif>" 
					maxlength="100" size="80"
					>
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="TAtarifa">
						Tarifa:
					</label>
				</td>
				<td valign="top">
					<select name="TAtarifa" id="TAtarifa">
					<option value="-1">-No aplicar-</option>
						<cfloop query="ISBtarifas">
							<option value="#ISBtarifas.TAtarifa#" <cfif modo NEQ 'ALTA' and isdefined('data') and ISBtarifas.TAtarifa is data.TAtarifa>selected</cfif>>#HTMLEditFormat(ISBtarifas.TAnombreTarifa)#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="EMcorreoEnvioFacturas">
						Correo para enviar facturación de medios:
					</label>				
				</td>
				<td valign="top">
					<input name="EMcorreoEnvioFacturas" 
						id="EMcorreoEnvioFacturas" 
						type="text" 
						onBlur="javascript: emailCheck(this.value);"
						value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.EMcorreoEnvioFacturas)#</cfif>" 
						maxlength="100" 
						size="80"
						onfocus="this.select()">
				</td>
			</tr>
			<tr>
				<td valign="top" align="right" nowrap>
					<label for="EMcorreoReciboFacturas">
						Correo para recibir respuesta a la facturación de medios:
					</label>							
				</td>
				<td valign="top">
					<input name="EMcorreoReciboFacturas" id="EMcorreoReciboFacturas" type="text" value="<cfif modo NEQ 'ALTA' and isdefined('data')>#HTMLEditFormat(data.EMcorreoReciboFacturas)#</cfif>" 
						maxlength="100" size="80"
						onfocus="this.select()">
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">
					<label for="EMcorreoReciboFacturas">
						Logotipo Empresa:
					</label>							
				</td>
				<td valign="top">
			<!---
					Nota: El onchange funciona en Internet Explorer 6.0 o anteriores, pero no funciona en Mozilla Firefox
					Ms detalles en http://kb.mozillazine.org/Firefox_:_Issues_:_Links_to_Local_Pages_Don%27t_Work
				--->
					<input name="EMlogo" id="EMlogo" type="file" value="" 
						maxlength="20"
						onfocus="this.select()" onchange="document.getElementById('img_EMlogo').src=this.value"><br />
						<cfif modo NEQ 'ALTA' and isdefined('data') and Len(data.EMlogo)>
							<img width="120" id="img_EMlogo" src="ISBmedioCia-download.cfm?f=EMlogo&amp;EMid=#URLEncodedFormat(data.EMid)#">		
						</cfif>
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
			<input type="hidden" name="EMid" value="#HTMLEditFormat(data.EMid)#">
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