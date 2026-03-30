<cfif Len(session.saci.agente.id) is 0 or session.saci.agente.id is 0>
  <cfthrow message="Usted no está registrado como agente autorizado, por favor verifíquelo.">
</cfif>

<cfif isdefined('url.TJid') and not isdefined('form.TJid')>
	<cfset form.TJid = url.TJid>
</cfif>

<cfoutput>
	<form name="form1" method="post" action="ventaPrepagos-aply.cfm" style="margin: 0;" onsubmit="return validar(this);">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td>				
				<cfset idTar = "">
				<cfif isdefined('form.TJid') and form.TJid NEQ ''>
					<cfset idTar = Form.TJid>
				</cfif>			
				<!--- Solo va a seleccionar las tarjetas del agente en session y las de estado 0. Generada --->
				<cf_prepagoInf
					form = "form1"
					agente="#session.saci.agente.id#"
					id = "#idTar#"
					Ecodigo = "#Session.Ecodigo#"
					Conexion = "#Session.DSN#"
					readOnlyAgente="true"
					pintaPidAgente="false"
					readonly="true">
			</td>
		  </tr>
		  
			<tr>
				<td align="center">
					<cfif isdefined('form.TJestado') and form.TJestado EQ 'Generada'>
						<cf_botones modo="ALTA" exclude="Alta,Limpiar" include="Regresar,Vender" tabindex="1">
					<cfelse>
						<cf_botones modo="ALTA" exclude="Alta,Limpiar" include="Regresar" tabindex="1">
					</cfif>
				</td>
			</tr>					
		</table>
	</form>
	
	<script type="text/javascript">
	<!--
		function validar(formulario){
			var error_input;
			var error_msg = '';
			if(!btnSelected('Regresar', formulario)){
				if (formulario.TJlogin.value == "") {
					error_msg += "\n - El Prepago no puede quedar en blanco.";
					error_input = formulario.TJlogin;
				}
			}

			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguientes datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;
			}
			
			if(btnSelected('Vender', formulario)){
				if(!confirm('Desea vender esta tarjeta prepago ?'))
					return false;
			}
			return true;
		}
	//-->
	</script>	
</cfoutput>