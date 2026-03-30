<cfset modoLA = "ALTA">

<cfif isdefined('form.MDref') and form.MDref NEQ ''>
	<cfset modoLA = "CAMBIO">
</cfif>

<cfquery datasource="#session.dsn#" name="rsCias">
	select EMid
		, EMnombre
	from ISBmedioCia
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by EMnombre 
</cfquery>

<cfif modoLA NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		Select
			a.MDref
			, a.EMid
			, c.EMnombre
			, coalesce(a.MDlimite,0) as MDlimite
			, coalesce(b.MCacumulado,0) as MCacumulado
			, coalesce(((b.MCacumulado * 100) / a.MDlimite),0) as Uso
		from ISBmedio a
			left outer join ISBmedioConsumo b
				on b.MDref=a.MDref
			inner join ISBmedioCia c
				on c.EMid=a.EMid
					and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		where a.MDref= <cfqueryparam cfsqltype="cf_sql_char" value="#form.MDref#" null="#Len(form.MDref) Is 0#">
	</cfquery>
</cfif>

<form name="form_LimAcceso" method="post" action="u900-aply.cfm" onsubmit="return validar(this);">
	<cfinclude template="u900-hiddens.cfm">
	<cfoutput>
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td width="19%">&nbsp;</td>
				<td width="19%">&nbsp;</td>
				<td width="30%">&nbsp;</td>
				<td width="32%">&nbsp;</td>
			</tr>
			<tr>
				<td align="right"><label>Tel&eacute;fono:</label></td>
				<td>
					<cfif modoLA NEQ 'ALTA'>
						&nbsp;&nbsp;
						#HTMLEditFormat(data.MDref)#
						<input type="hidden" name="MDref" value="#HTMLEditFormat(data.MDref)#">
					<cfelse>
						<!---<input name="MDref" type="text" value="" size="30" maxlength="30">--->
						<cf_campoNumerico nullable="true" name="MDref" decimales="-1" size="15" 
						     maxlength="7" value="" tabindex="1">						
					</cfif>
				</td>
				<td align="right"><label>Saldo:</label></td>
				<td>&nbsp;&nbsp;
					<cfif modoLA NEQ 'ALTA'>
						#LsCurrencyFormat(data.MCacumulado,'none')#
					<cfelse>
						0.00
					</cfif>
					<input type="hidden" name="MCacumulado" value="<cfif modoLA NEQ 'ALTA'>#LsCurrencyFormat(data.MCacumulado,'none')#</cfif>">
				</td>
			</tr>
			<tr>
				<td align="right" nowrap><label>L&iacute;mite de Conexi&oacute;n:</label></td>
				<td>
					<cfset valLimite = 36>
					<cfif modoLA NEQ 'ALTA'>
						<cfset valLimite = HTMLEditFormat(data.MDlimite)>
					</cfif>		
					<select name="MDlimite">
						<cfloop from="1" to= "745" index="i">	
							<cfif #i# EQ #valLimite#>
								<option value="#i#" selected>#i#</option>
							<cfelse>
								<option value="#i#" >#i#</option>
							</cfif>
						</cfloop>
					</select>						
<!---					<cf_campoNumerico 
						readonly="false" 
						name="MDlimite" 
						decimales="-1" 
						size="10" 
						maxlength="8" 
						value="#valLimite#" 
						tabindex="1">			--->
						<label>(Horas)</label>	
				</td>
				<td align="right"><label>% Uso:</label></td>
				<td>&nbsp;&nbsp;
					<cfif modoLA NEQ 'ALTA'>
						#LsCurrencyFormat(data.Uso,'none')#
					<cfelse>
						0.00						
					</cfif>
					<input type="hidden" name="uso" value="<cfif modoLA NEQ 'ALTA'>#LsCurrencyFormat(data.Uso,'none')#</cfif>">				
				</td>
			</tr>
			<tr>
				<td align="right" nowrap><label>Compa&ntilde;&iacute;a:</label></td>
				<td>
					<select name="EMid">
						<cfif isdefined('rsCias') and rsCias.recordCount GT 0>
							<cfloop query="rsCias">
								<option value="#EMid#" <cfif modoLA NEQ 'ALTA' and rsCias.EMid EQ data.EMid> selected</cfif>>#EMnombre#</option>
							</cfloop>
						</cfif>
						
					</select>	
				</td>
				<td align="right">&nbsp;</td>
				<td>&nbsp;</td>
			</tr>			
			<tr>
				<td colspan="4" align="center">
					<cf_botones modo="#modoLA#">
				</td>
			</tr>
		</table>
	</cfoutput>
</form>

<script language="javascript" type="text/javascript">
	function validar(formulario){
		var error_input;
		var error_msg = '';
	
		if (formulario.MDref.value == "" || formulario.MDref.value == "0" || formulario.MDref.value.length < 7) {
			error_msg += "\n - El Telefono no puede quedar en blanco y debe contener siete dígitos.";
			error_input = formulario.MDref;
		}
		if (formulario.MDlimite.value == "") {
			error_msg += "\n - El límite de conexión no puede quedar en blanco.";
			error_input = formulario.MDlimite;
		}else{
			var num = new Number(formulario.MDlimite.value);
			if (num == 0) {
				error_msg += "\n - El límite de conexión no puede quedar en cero.";
				error_input = formulario.MDlimite;
				
			}		
		}
		if (formulario.EMid.value == "") {
			error_msg += "\n - La Compañía no puede quedar en blanco.";
			error_input = formulario.EMid;
		}	
				
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguientes datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}
		return true;
	}
</script>
