<cfoutput>
	<form name="form1" method="post" action="prepagos-aply.cfm" style="margin: 0;" onsubmit="return validar(this);">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">	
		  	<tr><td>&nbsp;</td></tr>		
		  	<tr id="idIndiv">
				<td>
					<cfset includ = "Regresar">
					<cfset includValues = "Regresar">
					<cfquery name="rsEstado" datasource="#session.dsn#">
						select TJestado
						from ISBprepago 
						where TJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TJid#" null="#Len(form.TJid) Is 0#">					
					</cfquery>
									
					<cfset idTar = "">
					<cfif isdefined('form.TJid') and form.TJid NEQ ''>
						<cfset idTar = Form.TJid>
					</cfif>			
					<cfset roAgente = "true">
					<cfif isdefined('rsEstado') and rsEstado.TJestado EQ '0'>
						<cfset roAgente = "false">
					</cfif>
					<cf_prepagoInf
						form = "form1"
						readOnlyAgente="#roAgente#"
						id = "#idTar#"
						readOnly="true"
						Ecodigo = "#Session.Ecodigo#"
						Conexion = "#Session.DSN#">
				</td>
		  	</tr>
		  	<tr>
				<td>
					<cfif isdefined('rsEstado') and rsEstado.recordCount GT 0>					
						<cfset form.TJestado=rsEstado.TJestado>
						<cfif rsEstado.TJestado EQ '0' or rsEstado.TJestado EQ '5'>	<!--- Generada o Desactivada--->
							<cfset includ = "Regresar,Activar,Asignar">
							<cfset includValues = "Regresar,Activar,Asignar Agente">						
						<cfelseif rsEstado.TJestado EQ '1'>	<!--- Activa --->													
							<cfset includ = "Regresar,Bloquear,Anular">
							<cfset includValues = "Regresar,,Desactivar,Anular">								
						<cfelseif rsEstado.TJestado EQ '2'>	<!--- Utilizada --->
							<cfset includ = "Regresar,Anular">
							<cfset includValues = "Regresar,Anular">		
						<!---<cfelseif rsEstado.TJestado EQ '5'>	 Desactivada 
							<cfset includ = "Regresar,Activar">
							<cfset includValues = "Regresar,Activar">						--->
						</cfif>
					<cfelse>
						<cfthrow message="No se encontro la tarjeta en la base de datos, por favor seleccionela de nuevo de la lista inicial">
					</cfif>
		
					<cf_botones tabindex="1" exclude="Alta,Limpiar" include="#includ#" includeValues="#includValues#">
				</td>
			</tr>
		</table>
		<cfinclude template="prepagos-hiddens.cfm">		
	</form>
	
	<script type="text/javascript">
	<!--		
		function validar(formulario){
			var error_input;
			var error_msg = '';
			var num_ok = true;
			
			if(!btnSelected('Regresar', formulario)){
				//Asignacion Individual
				if(btnSelected('Asignar', formulario)){
					if (formulario.AGidp.value == "") {
						error_msg += "\n - El Agente no puede quedar en blanco.";
						error_input = formulario.Pid;
					}
				}
				
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
						
			//Confirmaciones
			if(btnSelected('Activar', formulario)){
				if (!confirm('Realmente desea activar esta Tarjeta de Prepago ?'))
					return false;
			}	
			if(btnSelected('Bloquear', formulario)){
				if (!confirm('Realmente desea Bloquear esta Tarjeta de Prepago ?'))
					return false;
			}	
			if(btnSelected('Anular', formulario)){
				if (!confirm('Realmente desea Anular esta Tarjeta de Prepago ?'))
					return false;
			}			
			if(btnSelected('Asignar', formulario)){
				if (!confirm('Realmente desea Asignar este Agente a esta Tarjeta de Prepago ?'))
					return false;
			}						

			return true;
		}
	//-->
	</script>		
</cfoutput>


