<html>
<head>
<title>Activar Cuentas Personales</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body >

<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.filtro.fNombre.value = "";
		document.filtro.fLogin.value  = "";
		document.filtro.fCuenta.value = "";
	}
</script>

<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">

<table width="100%" cellpadding="0" cellspacing="0">
	<tr class="itemtit"><td colspan="2"><font size="2"><b>Lista de Cuentas Personales Inactivas</b></font></td></tr>
	
	<tr><td colspan="2">&nbsp;</td></tr>

	<tr>				
		<td valign="top">
			<cfoutput>
			<form name="filtro" style="margin:0;" action="CuentaPersonalRecycle.cfm" method="post">
				<table width="100%" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
					<tr>
						<td align="right"><b>Nombre:&nbsp;</b></td>
						<td><input name="fNombre" type="text" size="40" maxlength="255" value="<cfif isdefined("form.fNombre") and len(trim(form.fNombre)) gt 0>#form.fNombre#</cfif>" ></td>
						<td align="right"><b>Login:&nbsp;</b></td>
						<td><input name="fLogin" type="text" size="20" maxlength="20" value="<cfif isdefined("form.fLogin") and len(trim(form.fLogin)) gt 0>#form.fLogin#</cfif>" ></td>
						<td align="right"><b>Cuenta:&nbsp;</b></td>
						<td><input name="fCuenta" type="text" size="20" maxlength="20" value="<cfif isdefined("form.fCuenta") and len(trim(form.fCuenta)) gt 0>#form.fCuenta#</cfif>" ></td>
						<td><input type="submit" name="Filtrar" value="Filtrar"></td>
						<td><input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();"></td>
					</tr>
				</table>
			</form>
			</cfoutput>

			<table width="100%">
				<tr>
					<td width="1%"><input type="checkbox" name="chkall" value="T" onClick="javascript:check_all( this );"></td>
				 	<td valign="middle"><b>Seleccionar Todo</b></td>
				</tr>	
			</table>

			<cfset select = " convert(varchar, u.Usucodigo) as Usucodigo, u.Ulocalizacion, u.Usucuenta,
	       					  case u.Usutemporal when 0 then u.Usulogin else '-' end as Usulogin,
							  ((case when (u.Papellido1 is not null) and (rtrim(u.Papellido1) != '') then u.Papellido1 + ' ' else null end) +
							  (case when (u.Papellido2 is not null) and (rtrim(u.Papellido2) != '') then u.Papellido2 + ' ' else null end) +
							  (case when (u.Pnombre is not null) and (rtrim(u.Pnombre) != '') then u.Pnombre + ' ' else null end)) as nombre, 
							  '-1' as Accion " >

			<cfset from = " Usuario u " >

			<cfset where = " u.activo = 0
						     and not exists ( select Usucodigo from UsuarioEmpresarial
						                      where Usucodigo = u.Usucodigo and Ulocalizacion = u.Ulocalizacion)
						                       and (u.agente = #session.Usucodigo#
						                       and u.agente_loc = '#session.Ulocalizacion#'
						                      or exists ( select id from UsuarioPermiso
						                                  where rol = 'sys.pso'
						                                    and Usucodigo = #session.Usucodigo#
						                                    and Ulocalizacion = '#session.Ulocalizacion#'))" >
															
			<cfif isdefined("form.Filtrar") and isdefined("form.fNombre") and len(trim(form.fNombre)) gt 0>
				<cfset where = where & " and upper((case when (u.Papellido1 is not null) and (rtrim(u.Papellido1) != '') then u.Papellido1 + ' ' else null end) +
	        										(case when (u.Papellido2 is not null) and (rtrim(u.Papellido2) != '') then u.Papellido2 + ' ' else null end) +
	        										(case when (u.Pnombre is not null) and (rtrim(u.Pnombre) != '') then u.Pnombre + ' ' else null end)) like upper('%#form.fNombre#%')" >
			</cfif> 

			<cfif isdefined("form.Filtrar") and isdefined("form.fLogin") and len(trim(form.fLogin)) gt 0>
				<cfset where = where & " and upper(u.Usulogin) like upper('%#form.fLogin#%')" >
			</cfif> 

			<cfif isdefined("form.Filtrar") and isdefined("form.fCuenta") and len(trim(form.fCuenta)) gt 0>
				<cfset where = where & " and upper(u.Usucuenta) like upper('%#form.fCuenta#%')" >
			</cfif> 

			<cfset where = where & " order by upper((case when (u.Papellido1 is not null) and (rtrim(u.Papellido1) != '') then u.Papellido1 + ' ' else null end) +
	        										(case when (u.Papellido2 is not null) and (rtrim(u.Papellido2) != '') then u.Papellido2 + ' ' else null end) +
	        										(case when (u.Pnombre is not null) and (rtrim(u.Pnombre) != '') then u.Pnombre + ' ' else null end)) " >															

			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pLista"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="#from#"/>
				<cfinvokeargument name="columnas" value="#select#"/>
				<cfinvokeargument name="desplegar" value="Nombre, Usulogin, Usucuenta"/>
				<cfinvokeargument name="etiquetas" value="Nombre,Login,Cuenta"/>
				<cfinvokeargument name="formatos" value="V,V,V"/>
				<cfinvokeargument name="filtro" value="#where#"/>
				<cfinvokeargument name="align" value="left,left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="SQLCuentaPersonal.cfm"/>
				<cfinvokeargument name="Conexion" value="sdc"/>
				<cfinvokeargument name="MaxRows" value="30"/>
				<cfinvokeargument name="navegacion" value="botonSel=Buscar"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="botones" value="Activar,Eliminar"/>
				<cfinvokeargument name="keys" value="Usucodigo"/>
				<cfinvokeargument name="checkboxes" value="S"/>
			</cfinvoke>
		</td>
	</tr>
</table>

<script language="JavaScript1.2" type="text/javascript">

	function funcActivar(){
		if ( checkeados() ){
			if ( confirm('Va a activar a los usuarios seleccionados. Desde continuar?' ) ){
				document.lista.submit();
				return true;
			}
		}
		else{
			alert('No hay Sistemas seleccionados para el proceso.');
		}	

		return false;	
	}

	function funcEliminar(){
		if ( checkeados() ){
			if ( confirm('Va a eliminar permanentemente los usuarios seleccionados. Desde continuar?' ) ){
				document.lista.submit();
				return true;
			}
		}
		else{
			alert('No hay usuarios seleccionados para el proceso.');
		}	

		return false;
	}

	function existe(form, name){
	// RESULTADO
	// Valida la existencia de un objecto en el form
	
		if (form[name] != undefined) {
			return true
		}
		else{
			return false
		}
	}

	function check_all(obj){
		var form = eval('lista');
		
		if (existe(form, "chk")){
			if (obj.checked){
				if (form.chk.length){
					for (var i=0; i<form.chk.length; i++){
						form.chk[i].checked = "checked";
					}
				}
				else{
					form.chk.checked = "checked";
				}
			}	
		}
	}

	function checkeados(){
		var form = eval('lista');
		
		if (existe(form, "chk")){
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked){
						return true;
					}
				}
				return false;
			}
			else{
				if (form.chk.checked){
					return true;
				}
				else{	
					return false;
				}	
			}
		}
	}
</script>

</body>
</html>