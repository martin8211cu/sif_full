<cfif isdefined("form.update")>
	<script type="text/javascript" language="javascript1.2">
		window.opener.document.formRol.submit();
		window.close();	
	</script>
</cfif>

<cfif isdefined("url.rol") and not isdefined("form.rol")>
	<cfset form.rol = url.rol >
</cfif>

<html>
<head>
<title>Usuarios</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../../css/sif.css">
<script type="text/javascript" src="checks.js"></script>
</head>
<!---<body onUnload="javascript:window.opener.document.location.reload();">--->
<body>

<cfoutput>
<table width="100%" class="contenido" cellpadding="0" cellspacing="0">
	<cfif isdefined("form.rol") >

		<tr>
			<td colspan="3">
				<form style="margin:0" name="filtro" action="" method="post">
					<table width="100%" border="0" cellpadding="0" cellspacing="0" class="areaFiltro">

						<tr>
							<td >Nombre</td>
							<td >Login</td>
							<td >Cuenta</td>
						</tr>

						<tr>
							<td><input type="text" name="fNombre" size="50" maxlength="120" value="<cfif isdefined('form.btnFiltrar') and isdefined('form.fNombre')>#trim(form.fNombre)#</cfif>" onFocus="this.select()"></td>
							<td><input type="text" name="fLogin" value="<cfif isdefined('form.btnFiltrar') and isdefined('form.fLogin')>#trim(form.fLogin)#</cfif>" onFocus="this.select()"></td>
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
			<td>
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
				<cfset from = " Usuario u " >

				<cfset where = " u.activo = 1
							 and u.Usutemporal = convert(bit,0)
							and not exists ( select id 
											 from UsuarioPermiso
											 where Usucodigo = u.Usucodigo and Ulocalizacion = u.Ulocalizacion
											 and rol = '#form.rol#' ) ">

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

				<cfset where = where & " order by upper((case when (u.Papellido1 is not null) and (rtrim(u.Papellido1) != '') then u.Papellido1 + ' ' else null end) +
									                    (case when (u.Papellido2 is not null) and (rtrim(u.Papellido2) != '') then u.Papellido2 + ' ' else null end) +
														(case when (u.Pnombre is not null) and (rtrim(u.Pnombre) != '') then u.Pnombre + ' ' else null end)) ">
					
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
					<cfinvokeargument name="irA" value="SQLRolesInternos.cfm"/>
					<cfinvokeargument name="Conexion" value="sdc"/>
					<cfinvokeargument name="MaxRows" value="22"/>
					<cfinvokeargument name="keys" value="Usucodigo"/>
					<cfinvokeargument name="navegacion" value="&rol=#form.rol#"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="botones" value="Agregar"/>
				</cfinvoke>
			</td></tr></cfif>
		
	

</table>
</cfoutput>

<script type="text/javascript">

	function limpiar(){
		document.filtro.fNombre.value = '';
		document.filtro.fLogin.value  = '';
		document.filtro.fCuenta.value = '';
	}
	
	function funcAgregar(){
		if ( !checkeados() ){
			alert('No hay usuarios seleccionados para el proceso.');
			return false;
		}	

		document.lista.ROL.value = '<cfoutput>#form.rol#</cfoutput>'

		return true;
	}
</script>

</body>
</html>