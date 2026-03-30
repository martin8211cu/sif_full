
<cfif isdefined("url.rol") and not isdefined("form.rol")>
	<cfset form.rol = url.rol >
</cfif>

<script type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	function doConlis() {
		var top = (screen.height - 700) / 2;
		var left = (screen.width - 600) / 2;

		var rol = '';
		<cfif isdefined('form.rol')>
			rol = '<cfoutput>#form.rol#</cfoutput>';
		</cfif>

		window.open('conlisRIUsuarios.cfm?rol=' + rol, 'Usuarios','menu=no,scrollbars=yes,top='+top+',left='+left+',width=700,height=650');
	}
</script>	

<!--- Consulta de roles internos --->
<cfquery name="dataRoles" datasource="sdc">
	select rtrim(rol) as rol, nombre from Rol
	where interno = convert(bit,1)
	  and empresarial = convert(bit,0)
	  and rol != 'sys.public'
	  and activo = 1
	order by upper(nombre)
</cfquery>

<!--- Consulta de usuarios --->
<cfoutput>
<table class="contenido" cellpadding="0" cellspacing="0">

	<form style="margin:0" name="formRol" action="" method="post">
		<tr class="itemtit">
			<td width="1%">&nbsp;</td>
			<td width="1%">Rol:&nbsp;</td>
			<td align="left">
			<select name="rol" onChange="javascript:cargarRol(this.value)">
				<option value="" <cfif not isdefined("form.rol")>selected</cfif>>Seleccione un rol...</option>
				<cfloop query="dataRoles">
				<option value="#dataRoles.rol#"	<cfif isdefined("form.rol") and form.rol eq dataRoles.rol>selected</cfif>>#dataRoles.nombre# (#dataRoles.rol#)</option>
				</cfloop>
			</select>
			</td>
		</tr>
	</form>

	<cfif isdefined("form.rol") >
		<tr class="itemtit"><td colspan="3"><hr/></td></tr>

		<tr>
			<td colspan="3">
				<form style="margin:0" name="filtro" action="" method="post">
					<table width="100%" border="0" cellpadding="0" cellspacing="0" class="areaFiltro">
						<tr>
							<td width="10%" align="right">Nombre:&nbsp;</td>
							<td><input type="text" name="fNombre" size="50" maxlength="120" value="<cfif isdefined('form.btnFiltrar') and isdefined('form.fNombre')>#trim(form.fNombre)#</cfif>" onFocus="this.select()"></td>
							<td width="18%" align="right">Login:&nbsp;</td>
							<td><input type="text" name="fLogin" value="<cfif isdefined('form.btnFiltrar') and isdefined('form.fLogin')>#trim(form.fLogin)#</cfif>" onFocus="this.select()"></td>
							<td width="1%">Cuenta:&nbsp;</td>
							<td><input type="text" name="fCuenta" value="<cfif isdefined('form.btnFiltrar') and isdefined('form.fCuenta')>#trim(form.fCuenta)#</cfif>" onFocus="this.select()"></td>
							<td>
								<input type="button" name="btnLimpiar" value="Limpiar" onClick="javascript:limpiar();">
								<input type="submit" name="btnFiltrar" value="Filtrar">
								<input type="hidden" name="rol" value="#form.rol#">
							</td>
						</tr>
					</table>
				</form>
			</td>
		</tr>

		<tr>
			<td colspan="3">
				<table width="100%">
					<tr>
						<td width="1%"><input type="checkbox" name="chkall" value="T" onClick="javascript:check_all( this );"></td>
						<td valign="middle"><b>Seleccionar Todo</b></td>
					</tr>	
				</table>
			
				<cfset select = " case u.Usutemporal when 0 then u.Usulogin else '-' end as Usulogin,
								((case when (u.Papellido1 is not null) and (rtrim(u.Papellido1) != '') then u.Papellido1 + ' ' else null end) +
								 (case when (u.Papellido2 is not null) and (rtrim(u.Papellido2) != '') then u.Papellido2 + ' ' else null end) +
								 (case when (u.Pnombre is not null) and (rtrim(u.Pnombre) != '') then u.Pnombre + ' ' else null end)) as nombre,
								u.Usucuenta, u.Usucodigo, u.Ulocalizacion, '#form.rol#' as rol, '' as blanco " >
								
				<cfset from = " Usuario u, UsuarioPermiso up " >

				<cfset where = " u.Usucodigo = up.Usucodigo
							 and u.Ulocalizacion = up.Ulocalizacion
							 and up.cliente_empresarial is null and up.Ecodigo is null
							 and up.rol = '#form.rol#'
							 and up.activo = 1
							 and u.activo = 1 " >

				<cfif isdefined('form.btnFiltrar') and isdefined('form.fNombre') and len(trim(form.fNombre)) gt 0 >
					<cfset where = where & " and upper(((case when (u.Papellido1 is not null) and (rtrim(u.Papellido1) != '') then u.Papellido1 + ' ' else null end) +
								 				  (case when (u.Papellido2 is not null) and (rtrim(u.Papellido2) != '') then u.Papellido2 + ' ' else null end) +
								 				  (case when (u.Pnombre is not null) and (rtrim(u.Pnombre) != '') then u.Pnombre + ' ' else null end))) like upper('%#form.fNombre#%') ">
				</cfif>
				
				<cfif isdefined('form.btnFiltrar') and isdefined('form.fLogin') and len(trim(form.fLogin)) gt 0 >
					<cfset where = where & " and Usulogin = '#form.fLogin#' ">
				</cfif>

				<cfif isdefined('form.btnFiltrar') and isdefined('form.fCuenta') and len(trim(form.fCuenta)) gt 0 >
					<cfset where = where & " and u.Usucuenta = '#form.fCuenta#' ">
				</cfif>

				<cfset where = where & " order by ((case when (u.Papellido1 is not null) and (rtrim(u.Papellido1) != '') then u.Papellido1 + ' '	else null end) +
									       (case when (u.Papellido2 is not null) and (rtrim(u.Papellido2) != '') then u.Papellido2 + ' '	else null end) +
									       (case when (u.Pnombre is not null) and (rtrim(u.Pnombre) != '') then u.Pnombre + ' ' else null end)) " >		
				
				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pLista"
				 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="#from#"/>
					<cfinvokeargument name="columnas" value="#select#"/>
					<cfinvokeargument name="desplegar" value="nombre,Usulogin,Usucuenta,blanco"/>
					<cfinvokeargument name="etiquetas" value="Nombre,Login,Cuenta,&nbsp;"/>
					<cfinvokeargument name="formatos" value="V,V,V,V"/>
					<cfinvokeargument name="filtro" value="#where#"/>
					<cfinvokeargument name="align" value="left,left,left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="RolesInternos.cfm"/>
					<cfinvokeargument name="Conexion" value="sdc"/>
					<cfinvokeargument name="MaxRows" value="30"/>
					<cfinvokeargument name="keys" value="Usucodigo"/>
					<cfinvokeargument name="navegacion" value="&rol=#form.rol#"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="botones" value="Agregar,Eliminar"/>
					<cfinvokeargument name="checkboxes" value="S"/>
				</cfinvoke>
			</td>
		</tr>
	<cfelse>
		<tr><td>&nbsp;</td></tr>
	</cfif>
</table>
</cfoutput>

<script type="text/javascript">

	function cargarRol(codigo) {
		if (codigo != ""){
			document.formRol.submit();
		}
	}
	
	function funcAgregar(){
		doConlis()
		return false;
	}

	function funcEliminar(){
		if ( checkeados() ){
			if ( confirm('Va a eliminar el rol a los usuarios seleccionados. Desde continuar?' ) ){
				document.lista.action = 'SQLRolesInternos.cfm';
				<cfif isdefined('form.rol')>
					document.lista.ROL.value = '<cfoutput>#form.rol#</cfoutput>'
				</cfif>
				document.lista.submit();
				return true;
			}
		}
		else{
			alert('No hay usuarios seleccionados para el proceso.');
		}	

		return false;
	}
	
	function limpiar(){
		document.filtro.fNombre.value = '';
		document.filtro.fLogin.value  = '';
		document.filtro.fCuenta.value = '';
	}
</script>