<!--- <cfdump var="#form#"> --->

<!--- ===================================================== --->
<!--- 						Modo							--->
<!--- ===================================================== --->
<cfparam name="modo" default="ALTA">
<cfif isdefined("Session.Progreso.CEcodigo") and Len(Trim(Session.Progreso.CEcodigo)) NEQ 0>
	<cfset modo = 'CAMBIO'>
</cfif>
<!--- ===================================================== --->

<!--- ===================================================== --->
<!--- 						Querys							--->
<!--- ===================================================== --->

<!--- 1. Monedas--->
<cfquery name="rsMonedas" datasource="asp">
	select Mcodigo, Mnombre
	from Moneda	
	order by Mnombre
</cfquery>

<!--- Idiomas --->
<cfquery name="rsIdiomas" datasource="sifcontrol">
	select rtrim(Icodigo) as LOCIdioma, Descripcion as LOCIdescripcion
	from Idiomas
	order by 1, 2
</cfquery>

<!--- 2. Datos de la Cuenta Empresarial --->
<cfif modo neq 'ALTA'>
	<cfquery name="rsData" datasource="asp">
		select CEcodigo, id_direccion,
		       Mcodigo, CEnombre, CEcuenta, CEtelefono1, CEtelefono2,
			   CEfax, rtrim(LOCIdioma) as LOCIdioma, CEaliaslogin
		from CuentaEmpresarial
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
	</cfquery>
	
	<cfquery name="rsEmpresas" datasource="asp">
		select count(1) as cant from Empresa
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
	</cfquery>

	<cfquery name="rsUsuarios" datasource="asp">
		select count(1) as cant from Usuario
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
	</cfquery>
</cfif>
<!--- ===================================================== --->

<!--- ===================================================== --->
<!--- 						JS							--->
<!--- ===================================================== --->
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script type="text/javascript" language="javascript1.2">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<script language="javascript" type="text/javascript">
	function funcGuardarContinuar() {
		if (objForm.validate()) {
			document.form1.ACCION.value = "1";
			document.form1.submit();
		}	
	}

	function funcGuardarNuevo() {
		if (objForm.validate()){
			document.form1.ACCION.value = "2";
			document.form1.submit();
		}
	}

	<cfif modo EQ "CAMBIO">
	function funcEliminar() {
		<cfif Session.Progreso.CEcodigo EQ 1>
			alert('Este cuenta empresarial es interna del sistema y no puede ser eliminada');
			return false;
		<cfelse>
			<!--- Validar que la cuenta empresarial puede ser eliminada --->
			<cfoutput>
			if (#rsEmpresas.cant# > 0) {
				alert('Esta cuenta empresarial no puede ser eliminada porque tiene empresas asociadas');
				return false;
			}
			if (#rsUsuarios.cant# > 0) {
				alert('Esta cuenta empresarial no puede ser eliminada porque tiene usuarios asociados');
				return false;
			}
			</cfoutput>
		
			if (confirm('¿Está seguro de que desea eliminar esta cuenta empresarial?')) {
				deshabilitarValidacion()
				document.form1.ACCION.value = "3";
				document.form1.submit();
			}
		</cfif>
	}
	</cfif>

	function funcCancelar() {
		location.href = '/cfmx/asp/index.cfm';
	}
</script>

<!--- ===================================================== --->


<cfoutput>
<form enctype="multipart/form-data" name="form1" method="post" action="Cuentas-sql.cfm" style="margin:0;" onSubmit=" return true;">
	<input name="ACCION" type="hidden" value="0">
	<input name="modo" type="hidden" value="<cfoutput>#modo#</cfoutput>">
	<cfif modo neq 'ALTA'>
		<input name="id_direccion" type="hidden" value="<cfoutput>#rsData.id_direccion#</cfoutput>">
		<input name="CEcodigo" type="hidden" value="<cfoutput>#rsData.CEcodigo#</cfoutput>">
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
    <td width="20%" valign="top" class="textoAyuda">
		<cfif modo EQ "ALTA">
			Para crear una nueva <strong>cuenta empresarial</strong> por favor complete el siguiente formulario.<br><br>
			Después de haber llenado el formulario, haga click en <font color="##0000FF">Guardar y Continuar</font> para ir al siguiente paso.<br><br>
			Si desea continuar agregando más cuentas empresariales haga click en <font color="##0000FF">Guardar y Agregar Otro</font>.<br><br>
			Si desea trabajar con una cuenta empresarial diferente a la actual, haga click en la opción de <font color="##0000FF">Seleccionar Cuenta</font> en el cuadro de <strong>Opciones</strong>.<br><br>
			Haga click en <font color="##0000FF">Cancelar</font> si desea salir al menu principal.
		<cfelse>
			A partir del <strong>no. de cuenta</strong> (generado por el sistema) se asignarán los servicios que los miembros de su empresa utilizarán dentro del portal.<br><br>
			Usted puede cambiar cualquier dato de la cuenta empresarial y hacer click en <font color="##0000FF">Guardar y Continuar</font> para ir al siguiente paso.<br><br>
			Si desea continuar agregando más cuentas empresariales haga click en <font color="##0000FF">Guardar y Agregar Otro</font>.<br><br>
			Si desea trabajar con una cuenta empresarial diferente a la actual, haga click en la opción de <font color="##0000FF">Seleccionar Cuenta</font> en el cuadro de <strong>Opciones</strong>.<br><br>
			Haga click en <font color="##0000FF">Cancelar</font> si desea salir al menu principal.
		</cfif>
	</td>
    <td style="padding-left: 5px; padding-right: 5px;" valign="top">
		<table border="0" cellpadding="2" cellspacing="0" align="center">
			<cfif modo neq 'ALTA'>
				<tr>
					<td class="etiquetaCampo" align="right" nowrap><b>No. Cuenta:&nbsp;</b></td>
					<td colspan="3" nowrap><b>#rsData.CEcuenta#</b></td>
				</tr>
			</cfif>
	
			<tr>
				<td class="etiquetaCampo" align="right" nowrap>Nombre:&nbsp;</td>
				<td colspan="3" align="left" nowrap>
					<input type="text" name="CEnombre" size="60" maxlength="100" value="<cfif modo neq 'ALTA'>#rsData.CEnombre#</cfif>" onFocus="this.select(); this.style.backgroundColor='##FFFFFF';">
				</td>
			</tr>
	
			<tr>
				<td class="etiquetaCampo" align="right" nowrap>Telef&oacute;no 1:&nbsp;</td>
				<td align="left" nowrap><input type="text" name="CEtelefono1" size="15" maxlength="30" value="<cfif modo neq 'ALTA'>#rsData.CEtelefono1#</cfif>" onFocus="this.select();" ></td>
				<td class="etiquetaCampo" align="right" nowrap>Moneda:&nbsp;</td>
				<td align="left" nowrap>
					<select name="Mcodigo" >
						<cfloop query="rsMonedas">
							<option value="#rsMonedas.Mcodigo#" <cfif modo neq 'ALTA' and rsData.Mcodigo eq rsMonedas.Mcodigo >selected</cfif>  >#rsMonedas.Mnombre#</option>
						</cfloop>
					</select>		  
				</td>
			</tr>
	
			<tr>
				<td class="etiquetaCampo" align="right" nowrap>Telef&oacute;no 2:&nbsp;</td>
				<td align="left" nowrap><input type="text" name="CEtelefono2" size="15" maxlength="30" value="<cfif modo neq 'ALTA'>#rsData.CEtelefono2#</cfif>" onFocus="this.select();" ></td>
				<td class="etiquetaCampo" align="right" nowrap>Idioma:&nbsp;</td>
				<td align="left" nowrap>
                  <select name="LOCIdioma">
                    <cfloop query="rsIdiomas">
                      <option value="#rsIdiomas.LOCIdioma#" <cfif modo neq 'ALTA' and rsData.LOCIdioma eq rsIdiomas.LOCIdioma> selected</cfif>>#rsIdiomas.LOCIdescripcion#</option>
                    </cfloop>
                  </select>
                </td>
			</tr>
			
			<tr>
			  <td class="etiquetaCampo" align="right" nowrap>Fax:&nbsp;</td>
			  <td align="left" nowrap><input type="text" name="CEfax" size="15" maxlength="30" value="<cfif modo neq 'ALTA'>#rsData.CEfax#</cfif>" onFocus="this.select();" ></td>
			  <td class="etiquetaCampo" align="right" nowrap>Logo:&nbsp;</td>
			  <td align="left" nowrap><input type="file" name="logo" ></td>
		  </tr>
			<tr>
			  <td class="etiquetaCampo" align="right" nowrap>Alias de Cuenta:&nbsp;</td>
			  <td align="left" nowrap valign="top"><input type="text" name="CEaliaslogin" size="15" maxlength="30" value="<cfif modo neq 'ALTA'>#rsData.CEaliaslogin#</cfif>" onFocus="this.select();" ></td>
			  <td colspan="2" align="left" nowrap>Campo empresa en pantalla de login. <br>Debe ser &uacute;nico por cada cuenta empresarial.</td>
		  </tr>

			<tr>
				<td colspan="4">
					<cfif modo neq 'ALTA'>
						<cf_direccion action="input" key="#rsData.id_direccion#" >
					<cfelse>	
						<cf_direccion action="input">
					</cfif>
				</td>
			</tr>
			
			<tr><td colspan="4">&nbsp;</td></tr>
	  </table>
	</td>
    <td width="1%" valign="top">
		<cfinclude template="frame-Progreso.cfm">
		<br>
		<cfinclude template="frame-Proceso.cfm">
	</td>
  </tr>

</table>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.CEnombre.required = true;
	objForm.CEnombre.description="Nombre";
	objForm.codpostal.required = true;
	objForm.codpostal.description = "Código Postal";
	
	function deshabilitarValidacion(){
		objForm.CEnombre.required = false;
	}
	
</script>

</form>
