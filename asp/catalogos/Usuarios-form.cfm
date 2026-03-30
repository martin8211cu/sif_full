<cfset modo = "ALTA">
<cfif isdefined("Form.Usucodigo") and Len(Trim(Form.Usucodigo)) NEQ 0>
	<cfset modo = "CAMBIO">
</cfif>
<cfinvoke component="home.Componentes.Politicas" method="trae_parametros_cuenta" returnvariable="dataPoliticas" CEcodigo="#session.CEcodigo#"/>

<!--- Datos de la Cuenta Empresarial Utilizada --->
<cfquery name="rsCuenta" datasource="asp">
	select CEcodigo, 
		   id_direccion, 
		   Mcodigo, 
		   rtrim(LOCIdioma) as LOCIdioma, 
		   CEnombre, 
		   CEcuenta, 
		   CEtelefono1, 
		   CEtelefono2, 
		   CEfax, 
		   CEcontrato
	from CuentaEmpresarial
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
</cfquery>

<!--- Idiomas --->
<cfquery name="rsIdiomas" datasource="sifcontrol">
	select rtrim(Icodigo) as LOCIdioma, Descripcion as LOCIdescripcion
	from Idiomas
	order by 1, 2
</cfquery>

<!--- Login --->
<cfquery name="rsLogin" datasource="asp">
	select Usulogin 
	from Usuario 
	where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
</cfquery>

<cfif modo EQ "CAMBIO">
	<cfquery name="rsData" datasource="asp">
		select a.id_direccion,
			   a.datos_personales,
			   Ufhasta,
			   a.Uestado,
			   rtrim(a.LOCIdioma) as LOCIdioma,
			   a.Usulogin,
			   (case 
				   when a.Uestado = 0 then 'Inactivo' 
				   when a.Uestado = 1 and a.Utemporal = 1 then 'Temporal' 
				   when a.Uestado = 1 and a.Utemporal = 0 then 'Activo' 
				   else '' 
			   end) as estado
		from Usuario a
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
		and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
	</cfquery>
	
	<cfquery name="rsUsuarios1" datasource="asp">
		select count(1) as cant from UsuarioRol
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
	</cfquery>

	<cfquery name="rsUsuarios2" datasource="asp">
		select count(1) as cant from UsuarioProceso
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
	</cfquery>

	<cfquery name="rsUsuarios3" datasource="asp">
		select count(1) as cant from UsuarioReferencia
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
	</cfquery>

	<cfquery name="rsUsuarios4" datasource="asp">
		select count(1) as cant from UsuarioSustituto
		where Usucodigo1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
		or Usucodigo2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
	</cfquery>
</cfif>

<cfif modo EQ "ALTA">
	<cfinvoke component="home.Componentes.ValidarPassword" method="javascript" data="#dataPoliticas#"/>
</cfif>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>

<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function funcGuardarContinuar() {
		if (objForm.validate()) {
			document.frmUsuarios.ACCION.value = "1";
			document.frmUsuarios.submit();
		}	
	}

	function funcGuardarNuevo() {
		<cfif modo EQ 'ALTA'>
		login(document.frmUsuarios);
		</cfif>

		if (objForm.validate()) {
			<cfif modo EQ 'ALTA'>
			if ( login(document.frmUsuarios) ) {
			</cfif>
				document.frmUsuarios.ACCION.value = "2";
				document.frmUsuarios.submit();
			<cfif modo EQ 'ALTA'>
			}	
			</cfif>
		}
	}
	
	<cfif modo EQ "CAMBIO">
	function funcEliminar() {
		<cfif Form.Usucodigo EQ 1>
			alert('Este usuario es interno del sistema y no puede ser eliminado');
			return false;
		<cfelse>
			<!--- Validar que el usuario puede ser eliminado --->
			<cfoutput>
			if (#rsUsuarios1.cant# > 0 || #rsUsuarios2.cant# > 0 || #rsUsuarios3.cant# > 0 || #rsUsuarios4.cant# > 0) {
				alert('Este usuario no puede ser eliminado porque tiene roles y procesos asociados o porque ya fue activado');
				return false;
			}
			</cfoutput>
		
			if (confirm('¿Está seguro de que desea eliminar este usuario?')) {
				deshabilitarValidacion();
				document.frmUsuarios.ACCION.value = "3";
				document.frmUsuarios.submit();
			}
		</cfif>
		
	}
	
	function funcActivar() {
		if (confirm('¿Está seguro de que desea activar este usuario?')) {
			deshabilitarValidacion();
			document.frmUsuarios.ACCION.value = "4";
		} else {
			return false;
		}
	}
	
	function funcDesactivar() {
		<cfif Form.Usucodigo EQ 1>
			alert('Este usuario es interno del sistema y no puede ser inactivado');
			return false;
		<cfelse>
			if (confirm('¿Está seguro de que desea desactivar este usuario?')) {
				deshabilitarValidacion();
				document.frmUsuarios.ACCION.value = "5";
			} else {
				return false;
			}
		</cfif>
	}
	
	</cfif>

	function funcCancelar() {
		location.href = '/cfmx/asp/index.cfm';
	}
	
	<cfif modo EQ "ALTA">
	function showLogin(yn) {
		var a = document.getElementById("trLogin");
		var b = document.getElementById("trContrasena");
		var c = document.getElementById("trContrasena2");
		if (yn == 1) 
		{
			a.style.display = 'none';
			b.style.display = 'none';
			c.style.display = 'none';
			validateUid(false);
			validatePwd(false);
			validarEmail(true);
		}
		else if (yn == 2) 
		{
			a.style.display = '';
			b.style.display = '';
			c.style.display = '';
			validateUid(true);
			validatePwd(true);
			validarEmail(false);
		}
		else 
		{
			a.style.display = '';
			b.style.display = 'none';
			c.style.display = 'none';
			validateUid(true);
			validatePwd(false);
			validarEmail(true);
		}
		return true;
	}
	</cfif>

	function obid(s) {
		return document.all ? document.all[s] : document.getElementById(s);
	}
	
	function valid_password(u, p, p2) {
		var div = obid('div_test_msg');
		if (!document.origMsg) {
			document.origMsg = div.innerHTML;
		}
		var valida = validarPassword(u, p);
		obid('img_user_ok').style.display = !valida.erruser.length ? '' : 'none';
		obid('img_user_mal').style.display = valida.erruser.length ? '' : 'none';

		obid('img_pass_ok').style.display = !valida.errpass.length ? '' : 'none';
		obid('img_pass_mal').style.display = valida.errpass.length ? '' : 'none';
		if(p != p2) valida.errpass.push("La contrase\u00f1a debe coincidir en ambas casillas.");
		obid('img_pass2_ok').style.display = !(valida.errpass.length  || p!=p2) ? '' : 'none';
		obid('img_pass2_mal').style.display = (valida.errpass.length || p!=p2) ? '' : 'none';
		if ( valida.erruser.length == 0 &&  valida.errpass.length == 0)
			div.innerHTML = 'Datos aceptados:<ul><li>Usuario y contrase\u00f1a v\u00e1lidos</li></ul>';
		else
			div.innerHTML = 'Se detectaron los siguientes errores:<ul style="color:red"><li>' + valida.erruser.concat(valida.errpass).join('<li>') + '</li></ul>';
	}	
</script>

<cfoutput>
<form name="frmUsuarios" action="Usuarios-sql.cfm" enctype="multipart/form-data" method="post">
<input name="modo" type="hidden" value="<cfoutput>#modo#</cfoutput>">
<input name="ACCION" type="hidden" value="0">
<cfif modo neq 'ALTA'>
	<input name="id_direccion" type="hidden" value="<cfoutput>#rsData.id_direccion#</cfoutput>">
	<input name="datos_personales" type="hidden" value="<cfoutput>#rsData.datos_personales#</cfoutput>">
	<input name="Usucodigo" type="hidden" value="<cfoutput>#Form.Usucodigo#</cfoutput>">
</cfif>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td colspan="3" bgcolor="##A0BAD3">
		<cfinclude template="frame-botones.cfm">
	</td>
  </tr>
  <tr>
  	<td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td class="textoAyuda" width="20%" valign="top">
		<cfif modo EQ "ALTA">
			Para crear un nuevo <strong>usuario</strong> por favor complete el siguiente formulario.<br><br>
			Después de haber llenado el formulario, haga click en <font color="##0000FF">Guardar y Continuar</font> para ir al siguiente paso.<br><br>
			Si desea continuar agregando más usuarios haga click en <font color="##0000FF">Guardar y Agregar Otro</font>.<br><br>
			Si desea trabajar con un usuario diferente al actual, haga click en la opción de <font color="##0000FF">Seleccionar Usuario</font> en el cuadro de <strong>Opciones</strong>.<br><br>
			Haga click en <font color="##0000FF">Cancelar</font> si desea salir al menu principal.
		<cfelse>
			Usted puede cambiar cualquier dato del usuario y hacer click en <font color="##0000FF">Guardar y Continuar</font> para ir al siguiente paso.<br><br>
			Si desea continuar agregando más usuarios haga click en <font color="##0000FF">Guardar y Agregar Otro</font>.<br><br>
			Si desea trabajar con un usuario diferente al actual, haga click en la opción de <font color="##0000FF">Seleccionar Usuario</font> en el cuadro de <strong>Opciones</strong>.<br><br>
			Haga click en <font color="##0000FF">Cancelar</font> si desea salir al menu principal.
		</cfif><br /><br />
		<div id="div_test_msg" class="textoAyuda">
		Si digita usted mismo el usuario y contraseña, aténgase a las siguiente reglas:
<cfinvoke component="home.Componentes.ValidarPassword" method="reglas" data="#dataPoliticas#" returnvariable="reglas"/>
	<cfif ArrayLen(reglas.erruser)>
	<ul>
	<li class="textoAyuda" style="border:none"><cfoutput>#ArrayToList( reglas.erruser, '</li><li class="textoAyuda" style="border:none">')#</cfoutput></li>
	</ul>
	</cfif>
	<cfif ArrayLen(reglas.errpass)>
	<ul>
	<li class="textoAyuda" style="border:none"><cfoutput>#ArrayToList( reglas.errpass, '</li><li class="textoAyuda" style="border:none">')#</cfoutput></li>
	</ul>
	</cfif>
		</div>
	</td>
    <td style="padding-left: 5px; padding-right: 5px;" valign="top" align="center">
		<table border="0" cellspacing="0" cellpadding="2" align="center">
		  <tr>
		    <td colspan="2" align="left" nowrap>
				<cfif modo neq 'ALTA'>
					<cf_datospersonales form="frmUsuarios" action="input" key="#rsData.datos_personales#">
				<cfelse>	
					<cf_datospersonales form="frmUsuarios" action="input">
				</cfif>
			</td>
		  </tr>
		  <cfif modo EQ "ALTA">
		  <tr>
		    <td class="tituloListas" colspan="2" align="center" nowrap>
				Tipo de Creación de Usuario (Login y Contraseña)
			</td>
		  </tr>
		  <tr>
		    <td align="left" nowrap colspan="2">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="rdGen" id="rdGen1" type="radio" value="1" style="border: none;" onClick="javascript: showLogin(1);" <cfif not (isdefined("Form.rdGen") and Form.rdGen EQ '2')> checked</cfif>><label for="rdGen1">Generar Login y Contraseña, y enviar por correo</label><BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="rdGen" id="rdGen3" type="radio" value="3" style="border: none;" onClick="javascript: showLogin(3);" <cfif isdefined("Form.rdGen") and Form.rdGen EQ '3'> checked</cfif>><label for="rdGen3">Especificar Login, Generar Contrase&ntilde;a, y enviar por correo</label><BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input name="rdGen" id="rdGen2" type="radio" value="2" style="border: none;" onClick="javascript: showLogin(2);" <cfif isdefined("Form.rdGen") and Form.rdGen EQ '2'> checked</cfif>><label for="rdGen2">Especificar Login y Contrase&ntilde;a</label>
			</td>
		  </tr>
		  <tr id="trLogin" style="display: none; ">
		    <td align="right" nowrap class="etiquetaCampo">Login:&nbsp;</td>
		    <td align="left" nowrap>
				<input name="username" type="text" id="username" size="30" maxlength="100" value="" onFocus="javascript: this.select();" onBlur="javascript:login(this.form);"  onkeyup="valid_password( this.form.username.value, this.form.password.value, this.form.password2.value)" />
			<img src="/cfmx/asp/admin/politicas/global/aceptado.gif" alt="ok" name="img_user_ok" width="13" height="12" id="img_user_ok" longdesc="Usuario aceptado" style="display:none" />
			<img src="/cfmx/asp/admin/politicas/global/rechazado.gif" alt="ok" name="img_user_mal" width="13" height="12" id="img_user_mal" longdesc="Usuario rechazado" />
			</td>
		  </tr>
		  <tr id="trContrasena" style="display: none; ">
		    <td align="right" nowrap class="etiquetaCampo">Contrase&ntilde;a:&nbsp;</td>
		    <td align="left" nowrap>
				<input name="password" type="password" id="password" size="30" maxlength="30" value="" onFocus="javascript: this.select();"  onBlur="javascript:login(this.form);" onkeyup="valid_password( this.form.username.value, this.form.password.value, this.form.password2.value)" />
			<img src="/cfmx/asp/admin/politicas/global/aceptado.gif" alt="ok" name="img_pass_ok" width="13" height="12" id="img_pass_ok" longdesc="Contraseña aceptada" style="display:none" />
			<img src="/cfmx/asp/admin/politicas/global/rechazado.gif" alt="ok" name="img_pass_mal" width="13" height="12" id="img_pass_mal" longdesc="Contraseña rechazada" />
			</td>
		  </tr>
		  <tr id="trContrasena2" style="display: none; ">
		    <td align="right" nowrap class="etiquetaCampo">Confirmar Contrase&ntilde;a:&nbsp;</td>
		    <td align="left" nowrap>
				<input name="password2" type="password" id="password2" size="30" maxlength="30" value="" onFocus="javascript: this.select();"  onkeyup="valid_password( this.form.username.value, this.form.password.value, this.form.password2.value)" />
	  		<img src="/cfmx/asp/admin/politicas/global/aceptado.gif" alt="ok" name="img_pass2_ok" width="13" height="12" id="img_pass2_ok" longdesc="Contraseña aceptada" style="display:none" />
			<img src="/cfmx/asp/admin/politicas/global/rechazado.gif" alt="ok" name="img_pass2_mal" width="13" height="12" id="img_pass2_mal" longdesc="Contraseña rechazada" />
			</td>
		  </tr>
		  <tr>
		    <td class="tituloListas" colspan="2" align="center" nowrap>
				Datos Adicionales
			</td>
		  </tr>
		  <cfelse>
		  <tr>
		    <td class="tituloListas" colspan="2" align="center" nowrap>
				Datos Adicionales
			</td>
		  </tr>
		  <tr>
		    <td align="right" nowrap class="etiquetaCampo">Login:&nbsp;</td>
		    <td align="left" nowrap>
				#rsData.Usulogin#
			</td>
		  </tr>
		  </cfif>
		  <tr>
		    <td align="right" nowrap class="etiquetaCampo">Idioma:&nbsp;</td>
		    <td align="left" nowrap>
			  <select name="LOCIdioma">
				<cfloop query="rsIdiomas">
				  <option value="#rsIdiomas.LOCIdioma#"<cfif (modo EQ 'ALTA' and rsCuenta.LOCIdioma EQ rsIdiomas.LOCIdioma) or (modo EQ 'CAMBIO' and rsData.LOCIdioma EQ rsIdiomas.LOCIdioma)> selected</cfif>>#rsIdiomas.LOCIdescripcion#</option>
				</cfloop>
			  </select>
			</td>
		    </tr>
		  <tr>
		    <td width="35%" align="right" nowrap class="etiquetaCampo">Fecha Expiraci&oacute;n:&nbsp;</td>
		    <td align="left" nowrap>
				<cfif modo EQ "CAMBIO">
					<cfif len(trim(rsData.Ufhasta))>
						<cfset fechaExpira = LSDateFormat(rsData.Ufhasta,'dd/mm/yyyy')>
					<cfelse>
						<cfset fechaExpira = '' >
					</cfif>
				<cfelse>
					<cfset fechaExpira = "01/01/6100">
				</cfif>
				<cf_sifcalendario form="frmUsuarios" value="#fechaExpira#" name="Ufhasta">
			</td>
		  </tr>
		  <cfif modo EQ "CAMBIO">
		  <tr>
		    <td width="35%" align="right" nowrap class="etiquetaCampo">Estado:&nbsp;</td>
		    <td align="left">#rsData.estado#</td>
		  </tr>
		  </cfif>
		  <tr>
		    <td colspan="2" align="left" nowrap>
				<cfif modo neq 'ALTA'>
					<cf_direccion action="input" key="#rsData.id_direccion#" form="frmUsuarios">
				<cfelse>	
					<cfquery name="rsCuentaPais" datasource="asp">
						select Ppais
						from CuentaEmpresarial a, Direcciones b
						where a.id_direccion=b.id_direccion
						and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
					</cfquery>
					<cfset data.atencion = '' >	
					<cfset data.direccion1 = '' >	
					<cfset data.direccion2 = '' >	
					<cfset data.ciudad = '' >	
					<cfset data.estado = '' >	
					<cfset data.codpostal = '' >
					<cfset data.pais = rsCuentaPais.Ppais >
					<cf_direccion action="input" data="#data#" form="frmUsuarios">
				</cfif>
			</td>
		  </tr>
		  <tr>
		    <td colspan="2" align="center" nowrap>
				<cfif modo EQ "CAMBIO">
					<cfif rsData.Uestado EQ 0>
						<input type="submit" name="btnActivar" value="Activar Usuario" onmouseover="javascript: this.className='botonDown2';" onmouseout="javascript: this.className='botonUp2';" onClick="javascript: return funcActivar();">
					<cfelse>
						<input type="submit" name="btnDesactivar" value="Desactivar Usuario" onmouseover="javascript: this.className='botonDown2';" onmouseout="javascript: this.className='botonUp2';" onClick="javascript: return funcDesactivar();">
					</cfif>
				</cfif>
			</td>
		  </tr>
		</table>
	</td>
    <td width="1%" valign="top">
		<cfinclude template="frame-Progreso.cfm">
		<br>
		<cfinclude template="frame-Proceso.cfm">
	</td>
  </tr>

  <tr><td>&nbsp;</td></tr>
  
  <tr>
  	<td colspan="3" bgcolor="##A0BAD3">
		<cfinclude template="frame-botones.cfm">
	</td>
  </tr>
  
</table>
<iframe  name="ilogin" id="ilogin" width="0" height="0" frameborder="0" style="display:none;"></iframe>

</form>

<form name="form_valida_login" action="iframe-login.cfm" method="get" target="ilogin">
	<input type="hidden" name="username" /> 
	<input type="hidden" name="password" /> 
</form> 


</cfoutput>

<script language="javascript" type="text/javascript">
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
	
	function __isContrasena() {
		if (this.required) {
			var valida = validarPassword(this.obj.form.username.value, this.obj.form.password.value);
			if (valida.erruser.length || valida.errpass.length) {
				this.error = valida.erruser.concat(valida.errpass).join('\n - ');
			} else if (this.value != this.obj.form.password.value) {
				this.error = "La confirmación del password es diferente al password";
			}
		}
	}
	
	function __isLogin(){
		if (this.required){
			var f = document.frmUsuarios;
			var obj = f.username;
			<!---
			este era el codigo anterior.  no es necesario, porque se usa iframe-login.cfm
			if ( (f.rdGen[1].checked)  && (trim(f.username.value) != '') ){
				<cfoutput query="rsLogin">
					var login = '#trim(rsLogin.Usulogin)#'
					if ( login == trim(obj.value) ){
						this.error = "El login que desea asignar ya existe.";
					}
				</cfoutput>
			}
			--->
		}	
	}
	
	function deshabilitarValidacion() {
		objForm.id.required = false;
		objForm.nombre.required = false;
		objForm.email1.required = false;
	}

	<cfif modo EQ "ALTA">
		function validarEmail(yn) {
			objForm.email1.required = yn;
		}
	
		function validatePwd(yn) {
			objForm.password.required = yn;
			objForm.password2.required = yn;
		}
		function validateUid(yn) {
			objForm.username.required = yn;
		}
	</cfif>

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("frmUsuarios");
	_addValidator("isContrasena", __isContrasena);
	_addValidator("isLogin", __isLogin);
	
	objForm.id.required = true;
	objForm.id.description = "Identificación";
	objForm.nombre.required = true;
	objForm.nombre.description = "Nombre";

	<cfif modo EQ "ALTA">
		objForm.email1.required = true;
		objForm.email1.description = "Email";
		objForm.email1.validateEmail();
		objForm.username.required = false;
		objForm.username.description = "Login";
		objForm.username.validateLogin();
		objForm.password.required = false;
		objForm.password.description = "Password";
		objForm.password2.required = false;
		objForm.password2.description = "Confirmación del Password";
		objForm.password2.validateContrasena();
	</cfif>
	
	function login(f){
		document.form_valida_login.username.value = f.username.value;
		document.form_valida_login.password.value = f.password.value;		
		document.form_valida_login.submit();
		//document.getElementById('ilogin').src = 'iframe-login.cfm?username=' + escape(f.username.value) + '&password=' + f.password.value;
		return true;
	}
	
	
</script>