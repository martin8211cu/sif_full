<cfif isDefined("URL.cedula")>
	<cfinvoke component="cmMisFunciones" method="tmp_MostrarTabla" returnvariable="rs2" 
		CEDULA="#URL.cedula#"/>
</cfif>

<cfif isDefined("FORM.miModo")>
	<cfswitch expression="#FORM.miModo#">
		<!--- Inserta el registro --->
		<cfcase value="I">
			<cfinvoke component="cmMisFunciones" method="tmp_InsertarTabla" returnvariable="rError"
				cedula="#FORM.txtId#"	
				nombre="#FORM.txtNombre#" 
				apellidos="#FORM.txtApellidos#" 
				direccion="#FORM.txtDireccion#" 
				telefono="#FORM.txtTelefono#"
				nacionalidad="#FORM.cboNacionalidad#" />

				<cflocation url="basura.cfm">
		</cfcase>
		<!--- Actualiza el registro --->
		<cfcase value="U">
			<cfinvoke component="cmMisFunciones" method="tmp_ActualizarTabla" returnvariable="rError"
				cedula="#FORM.txtId#"	
				nombre="#FORM.txtNombre#" 
				apellidos="#FORM.txtApellidos#" 
				direccion="#FORM.txtDireccion#" 
				telefono="#FORM.txtTelefono#"
				nacionalidad="#FORM.cboNacionalidad#" />
		
				<cflocation url="basura.cfm">
		</cfcase>
		<!--- Borra el registro --->
		<cfcase value="D">
			<cfinvoke component="cmMisFunciones" method="tmp_BorrarEnTabla" returnvariable="rError"
				cedula="#FORM.txtId#" />
				
				<cflocation url="basura.cfm">
		</cfcase>
	</cfswitch>
</cfif>

<form name="fForm" id="fForm" method="post">
	<cf_web_portlet border="true" titulo="MANTENIMIENTO" skin="info1" width="300">  
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="28%">Id:</td>
        <td width="71%"><input name="txtId" type="text" readonly="true"
				onFocus="this.select()"
				value="<cfif isDefined("URL.cedula")><cfoutput>#rs2.cedula#</cfoutput></cfif>"></td>
      </tr>
      <tr>
        <td>Nombre:</td>
        <td><input name="txtNombre" type="text"
			onFocus="this.select()"
			value="<cfif isDefined("URL.nombre")><cfoutput>#rs2.nombre#</cfoutput></cfif>"></td>
      </tr>
      <tr>
        <td>Apellidos</td>
        <td><input name="txtApellidos" type="text"
			onFocus="this.select()"
			value="<cfif isDefined("URL.apellidos")><cfoutput>#rs2.apellidos#</cfoutput></cfif>"></td>
      </tr>
      <tr>
        <td>Direcci&oacute;n:</td>
        <td><input name="txtDireccion" type="text"
			onFocus="this.select()"
			value="<cfif isDefined("URL.direccion")><cfoutput>#rs2.direccion#</cfoutput></cfif>"></td>
      </tr>
      <tr>
        <td>Tel&eacute;fono:</td>
        <td><input name="txtTelefono" type="text"
			onFocus="this.select()"
			value="<cfif isDefined("URL.telefono")><cfoutput>#rs2.telefono#</cfoutput></cfif>"></td>
      </tr>
      <tr>
        <td>Nacionalidad:</td>
        <td>
			<select name="cboNacionalidad">
				<cfloop query="session.qNacionalidad">
					<option value="<cfoutput>#codigo#</cfoutput>"
						<cfif isDefined("URL.nacionalidad")>
							<cfif #rs2.nacionalidad# eq #codigo#>
								selected
							</cfif>>
						<cfelse>>
						</cfif>
						<cfoutput>#nombre#</cfoutput></option>
				</cfloop>
			</select>
        </td>
      </tr>
      <tr>
        <td><input name="miModo" type="hidden"></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td colspan="2"><input name="btnGuardar" type="button" value="Guardar"
			onClick="javascript:fnGuardar()">
            <input name="btnInsertar" type="button" value="Insertar" 
				onClick="javascript:fnInsertar()">
            <input name="btnBorrar" type="button"
				onClick="javascript:fnBorrar()" value="Borrar">
            <input name="btnCancelar" type="button" value="Cancelar"
				onClick="javascript:fnCancelar()"></td>
      </tr>
    </table>
	</cf_web_portlet>
<p>&nbsp;</p>
</form>

<script language="javascript1.2" src="validaciones.js"></script>
<script language="javascript1.2" type="text/javascript">

	function fnInsertar() {
		var f = document.fForm;
		f.miModo.value = 'I';
		f.txtNombre.value = '';
		f.txtApellidos.value = '';
		f.txtDireccion.value = '';
		f.txtTelefono.value = '';

		//Obtiene el consecutivo.
		<cfinvoke component="cmMisFunciones" method="tmp_DemeConsecutivo" returnvariable="i" />
		var j = <cfoutput>#i#</cfoutput>;
		f.txtId.value = j;
		f.txtNombre.focus();
		f.btnInsertar.disabled=true;
		f.btnBorrar.disabled=true;
	}
	
	function fnGuardar() {
		var f = document.fForm;	
		if (fnValido(f.elements)) {
			if (f.miModo.value != 'I') {
				f.miModo.value = 'U';
			}
			document.fForm.submit();
		}
	}
	
	function fnBorrar() {
		var f = document.fForm;
		var c = confirm('Desea borrar el registro');
		if (c == true) {
			f.miModo.value = 'D';	
			document.fForm.submit();
		}
	}

	function fnCancelar() {
		var f = document.fForm;
		f.miModo.value = 'C';
		f.btnInsertar.disabled=false;
		f.btnBorrar.disabled=false;
	}
</script>

<cfif isDefined("btnNuevo")>
	<script language="javascript1.2" type="text/javascript">
		fnInsertar();
	</script>
</cfif>