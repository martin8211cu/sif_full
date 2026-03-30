<cfoutput>
<cfif not ExisteLog>
	<cfthrow message="Error: el id del Login esta indefinido.">
</cfif>

<!---asigna el nombre del archivo apply segun el paso--->
<cfif isdefined("form.paso") and form.paso EQ 1>
	<cfset action = "gestion-login-apply.cfm">
	<cfset validar = "return validarLogin(this);">
	<cfset Titulo = "Cambio de Login">
	
<cfelseif isdefined("form.paso") and form.paso EQ 2>
	<cfset action = "gestion-Telefono-apply.cfm">
	<cfset validar = "return validarTel(this);">
	<cfset Titulo = "Cambio de Telefono">

<cfelseif isdefined("form.paso") and form.paso EQ 3>
	<cfset action = "gestion-RealName-apply.cfm">
	<cfset validar = "return validarRealName(this);">
	<cfset Titulo = "Cambio de Real Name">

<cfelseif isdefined("form.paso") and form.paso EQ 4>
	<cfset action = "gestion-Password-apply.cfm">
	<cfset validar = "return validarPass(this);">
	<cfset Titulo = "Cambio de Password">

<cfelseif isdefined("form.paso") and form.paso EQ 5>
	<cfset action = "gestion-PasswordGlobal-apply.cfm">
	<cfset validar = "return validarPassGlobal(this);">
	<cfset Titulo = "Cambio de Password Global">

<cfelseif isdefined("form.paso") and form.paso EQ 6>
	<cfset action = "gestion-login-forwarding-apply.cfm">
	<cfset validar = "">
	<!---<cfset validar = "return validarLogin(this);">--->
	<cfset Titulo = "Cambio de Forwarding">
</cfif>

<table width="100%" cellpadding="2" cellspacing="0" border="0">
	<tr><td  valign="top" width="75%">
		<cf_web_portlet_start titulo="#Titulo#">
			<form name="form1" action="#action#" method="post" style="margin:0" onsubmit="#validar#">
				
				<cfinclude template="gestion-hiddens.cfm">
				
				<!---cuando vienen mensajes de error o de exito del apply de password y password Global--->
				<cfset mens = "">
				<cfif isdefined("url.mensCod") and len(trim(url.mensCod))>
					<cfset mens = url.mensCod>
				</cfif>
				
				<cf_gestion-login
					idcuenta="#form.CTid#"
					idcontrato="#form.Contratoid#"
					idlogin="#form.LGnumero#"
					idpersona="#form.cliente#"
					paso="#form.paso#"
					rol="#form.rol#"
					mens="#mens#"
					forwardIra="gestion-login-forwarding-apply.cfm"
				>
				<cfif isdefined("form.paso") and form.paso NEQ 6>
				<cf_botones names="Cambiar" values="Cambiar" tabindex="1">
				</cfif>	
			</form>
		<cf_web_portlet_end>
	
	</td>
	<td  valign="top" width="25%">
		<cfinclude template="gestion-menu.cfm">
	</td>
	</tr>
</table>

<script type="text/javascript">
	<!--
		function validarLogin(formulario) {
			var error_input;
			var error_msg = '';
			if (document.form1.Login2.value =="") {
			<!---if (validarLogines() == false) {--->
				error_msg += "\n - Debe validar todos los logines antes de continuar.";
			}
			
			<!--- Validacion terminada --->
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;
			}
			
			return true;
		}
		
		function validarLogines() {
			var iok = true;
			var iok2 = false;
			if (document.form1.chk2.checked) {
				 iok2 = true; 
			}
			if (!iok2) {
				document.form1.Login2.value = ''; 
			}
			if (document.form1.Login2.value != '' && document.getElementById("img_login_ok2").style.display == 'none') { iok = false; }
			if (document.form1.Login2.value != '' && document.getElementById("img_login_ok2").style.display == 'none') { iok = false; }
			
			return iok;
		}
		
		
		function validarTel(formulario) {
			var error_input;
			var error_msg = '';
			if (document.form1.nuevoLGtelefono.value =="") {
				error_msg += "\n - Debe digitar un nuevo número de teléfono.";
			}
			<!--- Validacion terminada --->
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;
			}
			return true;
		}
		
		
		function validarRealName(formulario) {
			var error_input;
			var error_msg = '';
			if (document.form1.nuevoLGrealName.value =="") {
				error_msg += "\n - Debe digitar un nuevo Real Name.";
			}
			<!--- Validacion terminada --->
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;
			}
			return true;
		}
		
		
		function validarPass(formulario) {
			var valido = true;
			if (document.form1.TScodigo != undefined){
				var TScodigo=document.form1.TScodigo.value;
				<!---var pass=eval('document.form1.pass_'+TScodigo+'.value');
				alert(TScodigo);--->
				valido=eval('validarPasswordpass_'+TScodigo+'()');		<!---funcion que se encuentra en el tag de password--->
				valido=eval('validarPasswordpass2_'+TScodigo+'()');		<!---funcion que se encuentra en el tag de password--->
				
				if(valido){
					var error_input;
					var error_msg = '';

					var ant=eval('document.form1.Ant_'+TScodigo);					
					var pass =eval('document.form1.pass_'+TScodigo);
					var pass2=eval('document.form1.pass2_'+TScodigo);
					if (ant.value =="") {
						error_msg += "\n - Debe digitar Password actual para el servicio MAIL.";
					}
					if (pass.value =="") {
						error_msg += "\n - Debe digitar un nuevo Password para el servicio ACCS.";
					}
					if (pass2.value =="") {
						error_msg += "\n - Debe digitar la Confirmación del Password para el servicio ACCS.";
					}
					if (pass.value != pass2.value) {
						pass.value = "";
						pass2.value = "";
						error_msg += "\n - Los Password digitados son diferentes para el servicio "+TScodigo+".";
					}
					<!--- Validacion terminada --->
					if (error_msg.length != "") {
						alert("Atención:"+error_msg);
						if (error_input && error_input.focus) error_input.focus();
						return false;
					}
					return true;
				}else return false;
			}
		}
		
		function validarPassGlobal(formulario) {
			var valido = true;
			if (document.form1.SLpassword != undefined){
				valido = validarPasswordSLpassword();	<!---funcion que se encuentra en el tag de password--->
				valido = validarPasswordSLpassword2();	<!---funcion que se encuentra en el tag de password--->
			}
			if(valido){
				var error_input;
				var error_msg = '';
				if (document.form1.SLpassword.value =="") {
					error_msg += "\n - Debe digitar el nuevo Password.";
				}
				if (document.form1.SLpassword2.value =="") {
					error_msg += "\n - Debe digitar la Confirmación del Password.";
				}
				if (document.form1.SLpassword.value != document.form1.SLpassword2.value) {
					document.form1.SLpassword.value = "";
					document.form1.SLpassword2.value = "";
					error_msg += "\n - Los Password digitados son diferentes.";
				}
				<!--- Validacion terminada --->
				if (error_msg.length != "") {
					alert("Atención:"+error_msg);
					if (error_input && error_input.focus) error_input.focus();
					return false;
				}
				return true;
			}else return false;
		}
	//-->
	</script>

</cfoutput>