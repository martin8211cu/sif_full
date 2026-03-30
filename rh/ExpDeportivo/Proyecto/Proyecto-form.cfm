
<cfparam name="modo" default="ALTA">
<cfif isdefined("Session.Progreso.CEcodigo") and Len(Trim(Session.Progreso.CEcodigo)) NEQ 0>
	<cfset modo = 'CAMBIO'>
</cfif>
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


<cfoutput> <!--- enctype="multipart/form-data" --->

<form  enctype="multipart/form-data" name="form1" method="post" action="Proyecto-sql.cfm" >
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
				Para crear una nueva <strong>instituci&oacute;n</strong> por favor complete el siguiente formulario.<br><br>
				Después de haber llenado el formulario, haga click en <font color="##0000FF">Guardar y Continuar</font> para ir al siguiente paso.<br><br>
				Si desea continuar agregando más instituciones haga click en <font color="##0000FF">Guardar y Agregar Otro</font>.<br><br>
				Si desea trabajar con una instituci&oacute;n diferente a la actual, haga click en la opción de <font color="##0000FF">Seleccionar Instituci&oacute;n</font> en el cuadro de <strong>Opciones</strong>.<br><br>
				Haga click en <font color="##0000FF">Cancelar</font> si desea salir al menu principal.
			<cfelse>
				A partir del <strong>no. de instituci&oacute;n</strong> (generado por el sistema) se asignarán los servicios que los jugadores de su equipo utilizarán dentro de la instituci&oacute;n.<br><br>
				Usted puede cambiar cualquier dato de la instituci&oacute;n y hacer click en <font color="##0000FF">Guardar y Continuar</font> para ir al siguiente paso.<br><br>
				Si desea continuar agregando más instituciones haga click en <font color="##0000FF">Guardar y Agregar Otro</font>.<br><br>
				Si desea trabajar con una instituci&oacute;n diferente al actual, haga click en la opción de <font color="##0000FF">Seleccionar Proyecto</font> en el cuadro de <strong>Opciones</strong>.<br><br>
				Haga click en <font color="##0000FF">Cancelar</font> si desea salir al menu principal.
			</cfif>
		</td>
		<td style="padding-left: 5px; padding-right: 5px;" valign="top">
			<table border="0" cellpadding="2" cellspacing="0" align="center">
				<cfif modo neq 'ALTA'>
					<tr>
						<td class="etiquetaCampo" align="right" nowrap><b><cf_translate  key="LB_ID_Proyecto">ID. Proyecto</cf_translate>:&nbsp;</b></td>
						<td colspan="3" nowrap><b>#rsData.CEcuenta#</b></td>
					</tr>
				</cfif>
		
				<tr>
					<td class="etiquetaCampo" align="right" nowrap><cf_translate  key="LB_Nombre">Nombre</cf_translate>:&nbsp;</td>
					<td colspan="3" align="left" nowrap>
						<input type="text" name="CEnombre" size="60" maxlength="100" value="<cfif modo neq 'ALTA'>#rsData.CEnombre#</cfif>" onFocus="this.select(); this.style.backgroundColor='##FFFFFF';"> 
						
					</td>
					
		
						
					</tr>

				<tr>
					<td class="etiquetaCampo" align="right" nowrap><cf_translate  key="LB_Telefono_1">Telef&oacute;no 1</cf_translate>:&nbsp;</td>
					<td align="left" nowrap><input type="text" name="CEtelefono1" size="15" maxlength="30" value="<cfif modo neq 'ALTA'>#rsData.CEtelefono1#</cfif>" onFocus="this.select();" ></td>
					<td class="etiquetaCampo" align="right" nowrap><cf_translate  key="LB_Telefono_2">Telef&oacute;no 2</cf_translate>:&nbsp;</td>
					<td align="left" nowrap><input type="text" name="CEtelefono2" size="15" maxlength="30" value="<cfif modo neq 'ALTA'>#rsData.CEtelefono2#</cfif>" onFocus="this.select();" ></td>
					
				</tr>
		
				
				<tr>
				  <td class="etiquetaCampo" align="right" nowrap><cf_translate  key="LB_Fax">Fax</cf_translate>:&nbsp;</td>
				  <td align="left" nowrap><input type="text" name="CEfax" size="15" maxlength="30" value="<cfif modo neq 'ALTA'>#rsData.CEfax#</cfif>" onFocus="this.select();" ></td>
				  <td class="etiquetaCampo" align="right" nowrap><cf_translate  key="LB_Logo">Logo</cf_translate>:&nbsp;</td>
				  <td align="left" nowrap><input type="file" name="logo" ></td>
			  </tr>
				<tr>
				  <td class="etiquetaCampo" align="right" nowrap><cf_translate  key="LB_Alias_de_la_Institucion">Alias de la Instituci&oacute;n</cf_translate>:&nbsp;</td>
				  <td align="left" nowrap valign="top"><input type="text" name="CEaliaslogin" size="15" maxlength="30" value="<cfif modo neq 'ALTA'>#rsData.CEaliaslogin#</cfif>" onFocus="this.select();" ></td>
				  <td colspan="2" align="left" nowrap><cf_translate  key="LB_Campo_del_proyecto_en_pantalla_de_login_Debe_ser_unico_por_cada_proyecto">Campo del proyecto en pantalla de login. <br>Debe ser &uacute;nico por cada proyecto</cf_translate></td>
		
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
	<input name="ACCION" type="hidden" value="0">
	<input name="modo" type="hidden" value="<cfoutput>#modo#</cfoutput>">
	<cfif modo neq 'ALTA'>
		<input name="id_direccion" type="hidden" value="<cfoutput>#rsData.id_direccion#</cfoutput>">
		<input name="CEcodigo" type="hidden" value="<cfoutput>#rsData.CEcodigo#</cfoutput>">
	</cfif>	
</form>
</cfoutput>

<!--- ===================================================== --->
<!--- 						JS							--->
<!--- ===================================================== --->
 <cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_El_campo_nombre_es_requerido"
Default="El campo nombre es requerido"
returnvariable="LB_El_campo_nombre_es_requerido"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Se_presentaron_los_siguientes_errores"
Default="Se presentaron los siguientes errores"
returnvariable="LB_Se_presentaron_los_siguientes_errores"/> 


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Se_presentaron_los_siguientes_errores"
Default="Se presentaron los siguientes errores" 
returnvariable="LB_Se_presentaron_los_siguientes_errores"/>

<script language="javascript" type="text/javascript">
	 function validar(){
		var error='';
		if ( document.form1.CEnombre.value == ''){
			error = ' - <cfoutput>#LB_El_campo_nombre_es_requerido#</cfoutput>.';
			document.form1.CEnombre.focus();
		}
		if (error != '' ){
			alert( '<cfoutput>#LB_Se_presentaron_los_siguientes_errores#</cfoutput>:\n' + error )
			return false;
		}
		
		return true;
	}

	function funcGuardarContinuar() {
		if(	validar()) {
			document.form1.ACCION.value = "1";
			document.form1.submit();
		}	
	}

	function funcGuardarNuevo() {
		if(	validar()) {
			document.form1.ACCION.value = "2";
			document.form1.submit();
		}	
	}

	<cfif modo EQ "CAMBIO">
	function funcEliminar() {
		<!--- Validar que la cuenta empresarial puede ser eliminada --->
		<cfoutput>
		if (#rsEmpresas.cant# > 0) {
			alert('Este proyecto no puede ser eliminada porque tiene equipos asociados');
			return false;
		}
		if (#rsUsuarios.cant# > 0) {
			alert('Este proyecto  no puede ser eliminada porque tiene jugadores asociados');
			return false;
		}
		</cfoutput>
		if (confirm('¿Está seguro de que desea eliminar este proyecto?')) {
			document.form1.ACCION.value = "3";
			document.form1.submit();
		}
	}
	</cfif>

	function funcCancelar() {
		location.href = 'index.cfm';
	} 
</script>
