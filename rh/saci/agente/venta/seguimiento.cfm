<cfif Len(session.saci.agente.id) is 0 or session.saci.agente.id is 0>
  <cfthrow message="Usted no está registrado como agente autorizado, por favor verifíquelo.">
</cfif>

<cfinclude template="seguimiento-params.cfm">
<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>

	<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
		<br />
		<cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td valign="top" style="padding-right: 5px;">
					<form name="form1" method="post" style="margin: 0;" action="seguimiento-apply.cfm" onsubmit="javascript: return validar(this);">
						<input type="hidden" name="Pquien" value="<cfif isdefined("form.Pquien") and Len(Trim(form.Pquien))>#form.Pquien#</cfif>" />
						<input type="hidden" name="AGid" value="#session.saci.agente.id#" />
						
						<cfinclude template="seguimiento-hiddens.cfm">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td align="center">
								<cf_botones names="Lista,imprimeForm,verAnotaciones" values="Lista de Ventas,Imprimir Formulario,Ver Anotaciones" tabindex="1">
							</td>
						  </tr>						
						  <tr>
							<td>
								<cf_cuenta 
									id = "#Form.CTid#"
									idpersona = "#Form.Pquien#"
									idcontrato= "#Form.Contratoid#"
									filtroAgente = "AGid"
									form = "form1"
									Ecodigo = "#Session.Ecodigo#"
									Conexion = "#Session.DSN#"
									paso = "5"
									vista = "2">								
							</td>
						  </tr>
						  <tr>
							<td align="center">
								<cf_botones names="Lista,imprimeForm,verAnotaciones" values="Lista de Ventas,Imprimir Formulario,Ver Anotaciones" tabindex="1">
							</td>
						  </tr>						  
						</table>
					</form>
			  </tr>
			</table>
			
			<script language="javascript" type="text/javascript">
				var popUpWin=0; 
				function popUpWindow(URLStr, left, top, width, height){
				  if(popUpWin){
					if(!popUpWin.closed) popUpWin.close();
				  }
				  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=yes,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}
				function validar(formulario) {
					var error_input;
					var error_msg = '';
			
					// Validacion terminada
					if (error_msg.length != "") {
						alert("Por favor revise los siguiente datos:"+error_msg);
						if (error_input && error_input.focus) error_input.focus();
						return false;
					}
					return true;
				}
				function funcimprimeForm(){
					popUpWindow("seguimiento-formContrato.cfm?CTid=#form.CTid#",160,90,700,500);
					return false;
				}
				function funcLista(){
					document.form1.action = "seguimiento_lista.cfm";
					document.form1.CTid.value = "";
					document.form1.submit();
				}
				function funcverAnotaciones(){
					popUpWindow("incidencias.cfm?CTid=#form.CTid#&Contratoid=#form.Contratoid#",200,100,700,500);
					return false;
				}
			</script>
		
		</cfoutput>
	<cf_web_portlet_end>

<cf_templatefooter>
