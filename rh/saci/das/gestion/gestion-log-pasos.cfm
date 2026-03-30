<cfoutput>
	<!--- consultas--->
	<cfif not ExisteLog>
		<cfthrow message="Error: el id del Login esta indefinido.">
	</cfif>
	
	<cfquery datasource="#session.DSN#" name="rsNomLogin">				<!---Obtiene el nombre del user(login) para el id de login--->	
		select 	LGlogin from ISBlogin 
		where 	LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LGnumero#"> 
	</cfquery>
	<cfset user = rsNomLogin.LGlogin>

	<cfset LoginBloqueado = false>
	<cfset LoginSinServicios = false>
	<cfset LoginInactivo = false>
	<cfset ExisteMail = true>
	<cfset ExisteACCS = true>
	<cfset permiteTel = false>
	
	<cfif isdefined("form.lpaso") and form.lpaso EQ 2>
		<cfquery name="rsVerifPermTel" datasource="#session.DSN#">
			select p.PQtelefono
			from ISBpaquete p
				inner join ISBproducto a
					on a.PQcodigo=p.PQcodigo
						and a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#"> 
						and a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#"> 
		
				inner join  ISBlogin b
					on b.Contratoid = b.Contratoid
					and b.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LGnumero#"> 
					and b.Habilitado=1	
			where p.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">							
		</cfquery>
		
		<cfif isdefined('rsVerifPermTel') and rsVerifPermTel.recordCount GT 0 and rsVerifPermTel.PQtelefono EQ 1>
			<cfset permiteTel = true>
		</cfif>
	</cfif>
	
	<cfquery name="rsLogActivo" datasource="#session.DSN#">				<!---Revisa que el login este activo--->
		select LGnumero
		from ISBlogin
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LGnumero#">
		and Habilitado=1
	</cfquery>
	<cfif rsLogActivo.recordCount EQ 0>
		<cfset LoginInactivo = True>
	</cfif>
	
	<cfquery datasource="#session.DSN#" name="rsEstadoLogin">			<!---Revisa si el login esta bloqueado--->
		select 	count(1) as bloqueado from 	ISBlogin 
		where 	LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LGnumero#"> 
				and LGbloqueado = 1
	</cfquery>
	<cfif rsEstadoLogin.bloqueado GT 0>
		<cfset LoginBloqueado = true>
	</cfif>
	
	<cfif not LoginBloqueado>
		<cfquery name="rsServicios" datasource="#session.DSN#">			<!---Revisa que el login posea servicios asociados--->
			select distinct  c.LGnumero,c.TScodigo   
			from ISBserviciosLogin c
			where	
				c.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LGnumero#">
				and c.Habilitado=1
		</cfquery>
		
		<cfif rsServicios.recordCount EQ 0>
			<cfset LoginSinServicios = true>
		<cfelse>
			<cfset lisServ = valueList(rsServicios.TScodigo)>						
			<cfif listFind(lisServ,"MAIL",',') EQ 0>	<!---Valida si el login posee un servicio MAIL--->
				<cfset ExisteMail = false>
			</cfif>	
			<cfif listFind(lisServ,"ACCS",',') EQ 0>	<!---Valida si el login posee un servicio ACCS--->	
				<cfset ExisteACCS = false>
			</cfif>
		</cfif>
	</cfif>
	
	<!---asigna el nombre del archivo apply segun el paso--->
	<cfset validar = "">
	<cfset Titulo = "">
	<cfif isdefined("form.lpaso") and form.lpaso EQ 0>
		<cfset validar = "return validarLogin(this);">
		<cfset Titulo = "Datos">
	
	<cfelseif isdefined("form.lpaso") and form.lpaso EQ 1>
		<cfset validar = "return validarLogin(this);">
		<cfset Titulo = "Cambio de Login">
		
	<cfelseif isdefined("form.lpaso") and form.lpaso EQ 2>
		<cfset validar = "return validarTel(this);">
		<cfset Titulo = "Cambio de Telefono">
	
	<cfelseif isdefined("form.lpaso") and form.lpaso EQ 3>
		<cfset validar = "return validarRealName(this);">
		<cfset Titulo = "Cambio de Real Name">
	
	<cfelseif isdefined("form.lpaso") and form.lpaso EQ 4>
		<cfif form.rol NEQ 'DAS'><cfset validar = "return validarPass(this);"> <cfelse> <cfset validar = "return validarPassConfirm();"> </cfif>
		<cfset Titulo = "Cambio de Password por Servicio">
	
	<cfelseif isdefined("form.lpaso") and form.lpaso EQ 5>
		<cfif form.rol NEQ 'DAS'><cfset validar = "return validarPassGlobal(this);"> <cfelse> <cfset validar = "return validarPassGlobalConfirm();"> </cfif>
		<cfset Titulo = "Cambio de Password Global">
	
	<cfelseif isdefined("form.lpaso") and form.lpaso EQ 6>
		<cfset validar = "return validarFowarding(this);">
		<cfset Titulo = "Cambio de Forwarding">
	
	<cfelseif isdefined("form.lpaso") and form.lpaso EQ 7>
		<cfset validar = "return validarPassSobre();">
		<cfset Titulo = "Cambio de Password por Sobre">
	
	<cfelseif isdefined("form.lpaso") and form.lpaso EQ 8>
		<cfset validar = "">
		<cfset Titulo = "Bloqueo de Login">
	
	<cfelseif isdefined("form.lpaso") and form.lpaso EQ 9>
		<cfquery name="rsTareaVerif" datasource="#session.DSN#">
			select count(1) as cantTareas
			from ISBtareaProgramada 
			where 	Contratoid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
					and CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
					and LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LGnumero#">
					and TPestado = 'P'
					and TPtipo = 'RL'
		</cfquery>			
		<cfset validar = "return validarRetiro(this);">
		<cfset Titulo = "Retiro de Login">
	<cfelseif isdefined("form.lpaso") and form.lpaso EQ 10>
		<cfset validar = "">
		<cfset Titulo = "Gestiones Realizadas del Login">
	</cfif>
	
	<cf_web_portlet_start titulo="#Titulo#">
		<form name="form1" action="gestion-login-apply.cfm" method="post" style="margin:0" onsubmit="#validar#">
			<cfinclude template="gestion-hiddens.cfm">
			
			<cfset mens = ""> <!---cuando vienen mensajes de error o de exito del apply de password y password Global--->
			<cfif isdefined("url.mensCod") and len(trim(url.mensCod))>
				<cfset mens = url.mensCod>
			</cfif>
			
			<cfset clav = ""> <!---en caso de Reset de clave se muestra la nueva clave--->
			<cfif isdefined("url.cl") and len(trim(url.cl))>
				<cfset clav = url.cl>
			</cfif>
			
			<cf_gestion-login
				idcuenta="#form.CTid#"
				idcontrato="#form.Contratoid#"
				idlogin="#form.LGnumero#"
				user="#user#"
				idpersona="#form.cliente#"
				paso="#form.lpaso#"
				rol="#form.rol#"
				mens="#mens#"
				forwardIra="gestion-login-forwarding-apply.cfm"
				cl="#clav#"
				permiteTel="#permiteTel#"
			>
			
			<cfset boton="Cambiar">
			<cfif form.rol EQ "DAS">
				<cfif isdefined("form.lpaso") and form.lpaso EQ 4 or form.lpaso EQ 5>
					<cfset boton="Restablecer">
				<cfelseif isdefined("form.lpaso") and form.lpaso EQ 9>
					<cfset boton="Retirar,Eliminar">
				<cfelse>
					&nbsp;
				</cfif>
			</cfif>	
			<cfif not LoginInactivo and form.lpaso NEQ 0 and isdefined("form.pintaBotones") and form.pintaBotones EQ 1>
				<cfif isdefined("form.lpaso") and form.lpaso NEQ 6 and form.lpaso NEQ 8>
					<cfif not LoginSinServicios>
						
						<cfif form.lpaso EQ 3>
							<cfif  ExisteMail>
								<cf_botones names="#boton#" values="#boton#" tabindex="1">
							</cfif>	
						<cfelseif form.lpaso EQ 2>
							<cfif  ExisteACCS and permiteTel>
								<cf_botones names="#boton#" values="#boton#" tabindex="1">
							</cfif>
						<cfelse>
							<cf_botones names="#boton#" values="#boton#" tabindex="1">
						</cfif>
					
					<cfelseif form.lpaso NEQ 4 and form.lpaso NEQ 5>
						
						<cfif form.lpaso EQ 3>
							<cfif  ExisteMail>
								<cf_botones names="#boton#" values="#boton#" tabindex="1">
							</cfif>	
						<cfelseif form.lpaso EQ 2>
							<cfif  ExisteACCS and permiteTel>
								<cf_botones names="#boton#" values="#boton#" tabindex="1">
							</cfif>
						<cfelse>
							<cf_botones names="#boton#" values="#boton#" tabindex="1">
						</cfif>
						
					</cfif>	
				</cfif>
			</cfif>
			
		</form>
	<cf_web_portlet_end> 
	
	<script type="text/javascript">
	<!--
		function funcEliminar()
		{	
			if (confirm("¿Desea Eliminar la Tarea Programada?")){
				document.form1.botonSel.value="Eliminar";
				return true;
			}
			else return false;
		}
		function validarRetiro(formulario) {
			var numTarProgr = 0;
			<cfif isdefined('rsTareaVerif')>
				numTarProgr = new Number('#rsTareaVerif.cantTareas#');			
			</cfif>
			
			if (document.form1.botonSel.value != "Eliminar"){
				var error_input;
				var error_msg = '';
				
				if (document.form1.radio == false) {
					error_msg += "\n - Debe seleccionar si desea realizar el retiro en este momento ó en un fecha determinada.";
					error_input = document.form1.MRid;
				}
				
				if (document.form1.MRid.value =="") {
					error_msg += "\n - Debe seleccionar un motivo de retiro.";
					error_input = document.form1.MRid;
				}

				if (document.form1.fretiro.value =="") {
					error_msg += "\n - Debe seleccionar una fecha para la ejecución de la tarea.";
					error_input = document.form1.fretiro;
				}

				<!--- Validacion terminada --->
				if (error_msg.length != "") {
					alert("Por favor revise los siguiente datos:"+error_msg);
					if (error_input && error_input.focus) error_input.focus();
					return false;
				}
				else{
				<!--- Verificacion de si tiene o no tareas programadas --->
					if(numTarProgr > 0 && document.form1.radio[1].checked){
						if(confirm("¿El login actual posee tareas programadas asociadas, aún así desea retirarlo ?"))
							return true;				
						else 
							return false;							
					}else{
						if(confirm("¿Esta seguro que desea retirar el login actual?"))
							return true;				
						else 
							return false;					
					}
				}					
			}else 
				return true;
		}
		
		function validarLogin(formulario) {
			var error_input;
			var error_msg = '';
			
			if (document.form1.Login2.value =="") {
				error_msg += "\n - Debe digitar el nuevo login.";
				error_input = document.form1.Login2;
			}
			else {
				if (validarLogines() == false)
				error_msg += "\n - Debe validar el login antes de continuar.";
			}
			
			<!--- Validacion terminada --->
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;
			}
			else{
				if(confirm("¿Esta seguro que desea cambiar el login actual?")){
					return true;				
				}else return false;
			}	
		}
		
		function validarLogines() {
			var iok = true;
			if (document.getElementById("img_login_ok2").style.display == 'none') 
			{	iok = false; }
			return iok;
		}
		
		
		function validarTel(formulario) {
			var error_input;
			var error_msg = '';
			var telf = document.form1.nuevoLGtelefono.value;
			if (document.form1.nuevoLGtelefono.value =="" || document.form1.nuevoLGtelefono.value =="0" || telf.length < 7)
			{
				error_msg += "\n - Debe digitar un nuevo número de teléfono.";
			}
			<!--- Validacion terminada --->
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;
			}
			else{
				if(confirm("¿Esta seguro que desea cambiar el teléfono actual?")){
					return true;				
				}else return false;
			}	
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
			else{
				if(confirm("¿Esta seguro que desea cambiar el Real Name actual?")){
					return true;				
				}else return false;
			}	
		}
		
		
	function validarFowarding(formulario) 
	{
		var error_input;
		var error_msg = '';
		
		if(!validateEmail(document.form1.LGmailFor))
		{
			error_msg += "\n- Dirección Electrónica no corresponde a un formato de e-mail válido.";
		}		
				
		<!--- Validacion terminada --->
		if (error_msg.length != "") 
		{
			alert("Por favor revise los siguiente datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}
	}
		
		function validarPassConfirm() {
			if(confirm("¿Esta seguro que desea cambiar el password actual?")){
				return true;				
			}else return false;	
		}
		
		function validarPass(formulario) {
			var error_input;
			var error_msg = '';
			
			if (document.form1.TScodigo != undefined){
				
				var TScodigo=document.form1.TScodigo.value;
				var ant=eval('document.form1.Ant_'+TScodigo);					
				var pass =eval('document.form1.pass_'+TScodigo);
				var pass2=eval('document.form1.pass2_'+TScodigo);
				
				if (ant.value =="")
					error_msg += "\n - Debe digitar contrase\u00f1a Anterior.";
			
				if (pass.value =="")
					error_msg += "\n - Debe digitar la nueva contrase\u00f1a.";
				
				if (pass2.value =="")
					error_msg += "\n - Debe digitar la Confirmación de la nueva contrase\u00f1a.";
				
				if (eval('document.form1.img_pass_ok_Ant_'+TScodigo+'.style.display') == 'none')
					error_msg += "\n - La contrase\u00f1a Anterior es inválida";
				
				if (eval('document.form1.img_pass_ok_pass_'+TScodigo+'.style.display')== 'none')
					error_msg += "\n - La contrase\u00f1a Nueva es inválida";
					
				if (eval('document.form1.img_pass_ok_pass2_'+TScodigo+'.style.display')== 'none')
					error_msg += "\n - La Confirmación de contrase\u00f1a es inválida";
	
				if (pass.value != pass2.value) {
					pass.value = ""; pass2.value = "";
					error_msg += "\n - Las contrase\u00f1as digitadas son diferentes.";
				}
				
				<!--- Validacion terminada --->
				if (error_msg != "") {
					alert("Atención:"+error_msg);
					if (error_input && error_input.focus) error_input.focus();
					return false;
				}
				else{
					if(confirm("¿Esta seguro que desea cambiar el password actual?")){
						return true;				
					}else return false;	
				}
			}
		}
		
		function validarPassGlobalConfirm() {
			if(confirm("¿Esta seguro que desea cambiar el password actual?")){
				return true;				
			}else return false;	
		}
		function validarPassGlobal(formulario) {
			var error_input;
			var error_msg = '';
			
			var p=document.form1.SLpassword;
			var p2=document.form1.SLpassword2;
			
			if (document.form1.img_pass_ok_SLpassword.style.display == 'none')
				error_msg += "\n - La contrase\u00f1a es inválida";
			
			if (document.form1.img_pass_ok_SLpassword2.style.display == 'none')
				error_msg += "\n - La confirmación de contrase\u00f1a es inválida";
			
			if (p.value =="")
				error_msg += "\n - La contrase\u00f1a no puede quedar en blanco.";
			
			if (p2.value =="")
				error_msg += "\n - La confirmación de contrase\u00f1a no puede quedar en blanco.";
			
			if (p.value != p2.value)
				error_msg += "\n - Las contrase\u00f1as son diferentes.";
				
			<!--- Validacion terminada --->
			if (error_msg.length != ""){
				alert("Por favor revise los siguiente datos:"+error_msg);
				return false;
			}
			else{
				if(confirm("¿Esta seguro que desea cambiar el password actual?")){
					return true;				
				}else return false;
			}	
		}
		
		function validarPassSobre()
		{
			var error_input;
			var error_msg = '';
			if (document.form1.Snumero.value == "")
				error_msg += "Debe elegir un nuevo sobre.";
			
			if (error_msg != ""){
				alert(error_msg);
				return false;
			}
			else{
				if(confirm("¿Esta seguro que desea cambiar el sobre actual?")){
					return true;				
				}else return false;
			}	
			
		}
	//-->
	</script>
</cfoutput>

