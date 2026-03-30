<html>
<head>
<title>Reciclar Modulos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<!---<body onUnload="javascript:window.opener.document.location.reload();">--->
<body onUnload="javascript:cerrar();" >

<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.form1.fNombre.value    = "";
		document.form1.fApellido1.value = "";
		document.form1.fApellido2.value = "";
		document.form1.fLogin.value     = "";
		document.form1.fCuenta.value    = "";
	}
</script>

<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">

	<cfif isdefined("url.cliente_empresarial") and not isdefined("form.cliente_empresarial") >
		<cfset form.cliente_empresarial = url.cliente_empresarial >
	</cfif>
	<cfif isdefined("url.ppTipo") and not isdefined("form.ppTipo") >
		<cfset form.ppTipo = url.ppTipo >
	</cfif>	
	<cfif isdefined("url.Filtrar") and not isdefined("form.Filtrar")>
		<cfset form.Filtrar = url.Filtrar >
	</cfif>
	
	<cfif isdefined("form.Filtrar") and isdefined("url.fNombre") and not isdefined("form.fNombre") >
		<cfset form.fNombre = url.fNombre >
	</cfif>

	<cfif isdefined("form.Filtrar") and isdefined("url.fApellido1") and not isdefined("form.fApellido1") >
		<cfset form.fApellido1 = url.fApellido1 >
	</cfif>

	<cfif isdefined("form.Filtrar") and isdefined("url.fApellido2") and not isdefined("form.fApellido2") >
		<cfset form.fApellido2 = url.fApellido2 >
	</cfif>

	<cfif isdefined("form.Filtrar") and isdefined("url.fLogin") and not isdefined("form.fLogin") >
		<cfset form.fLogin = url.fLogin >
	</cfif>

	<cfif isdefined("form.Filtrar") and isdefined("url.fCuenta") and not isdefined("form.fCuenta") >
		<cfset form.fCuenta = url.fCuenta >
	</cfif>

	<cfset where      = "" >
	<cfset navegacion = "" >
	<cfif isdefined("form.ppTipo") and form.ppTipo EQ 'A'>
		<cfset where = where & " and ue.admin = 1" >		
	</cfif>	
	<cfif isdefined("form.Filtrar")>
		<cfset navegacion = "&Filtrar=Filtrar">
		<cfif isdefined("form.Filtrar") and isdefined("form.fNombre") and len(trim(form.fNombre)) gt 0>
			<cfset where = where & " and upper(case when (ue.Pnombre is not null) and (rtrim(ue.Pnombre) != '') then ue.Pnombre + ' ' else null end) like upper('%#form.fNombre#%')" >
			<cfset navegacion = navegacion &  "&fNombre=#form.fNombre#" >
		</cfif> 
	
		<cfif isdefined("form.Filtrar") and isdefined("form.fApellido1") and len(trim(form.fApellido1)) gt 0>
			<cfset where = where & " and upper((case when (ue.Papellido1 is not null) and (rtrim(ue.Papellido1) != '') then ue.Papellido1 + ' ' else null end)) like upper('%#form.fApellido1#%')" >
			<cfset navegacion = navegacion & "&fApellido1=#form.fApellido1#" >
		</cfif> 
	
		<cfif isdefined("form.Filtrar") and isdefined("form.fApellido2") and len(trim(form.fApellido2)) gt 0>
			<cfset where = where & " and upper((case when (ue.Papellido2 is not null) and (rtrim(ue.Papellido2) != '') then ue.Papellido2 + ' ' else null end)) like upper('%#form.fApellido2#%')" >
			<cfset navegacion = navegacion & "&fApellido2=#form.fApellido2#" >
		</cfif> 
	
		<cfif isdefined("form.Filtrar") and isdefined("form.fLogin") and len(trim(form.fLogin)) gt 0>
			<cfset where = where & " and upper(u.Usulogin) like upper('%#form.fLogin#%')" >
			<cfset navegacion = navegacion & "&fLogin=#form.fLogin#" >
		</cfif> 
	
		<cfif isdefined("form.Filtrar") and isdefined("form.fCuenta") and len(trim(form.fCuenta)) gt 0>
			<cfset where = where & " and upper(u.Usucuenta) like upper('%#form.fCuenta#%')" >
			<cfset navegacion = navegacion & "&fCuenta=#form.fCuenta#" >
		</cfif> 
		
		
	
	</cfif>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr class="itemtit"><td colspan="2"><font size="2"><b>Lista de Usuarios Empresariales Inactivos</b></font></td></tr>
	
	<tr><td colspan="2">&nbsp;</td></tr>

	<tr>				
		<td valign="top">
			<cfoutput>
			<form name="form1" style="margin:0;" action="UsuariosRecycle.cfm" method="post">
				<input type="hidden" name="cliente_empresarial" value="#form.cliente_empresarial#" >
				<input type="hidden" name="ppTipo" value="<cfif isdefined('form.ppTipo')>#form.ppTipo#</cfif>" >				
				<table width="100%" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
					<tr>
						<td align="right"><b>Nombre:&nbsp;</b></td>
						<td><input name="fNombre" type="text" size="25" maxlength="255" value="<cfif isdefined("form.fNombre") and len(trim(form.fNombre)) gt 0>#form.fNombre#</cfif>" ></td>
						<td align="right"><b>Apellidos:&nbsp;</b></td>
						<td width="1%"><input name="fApellido1" type="text" size="25" maxlength="255" value="<cfif isdefined("form.fApellido1") and len(trim(form.fApellido1)) gt 0>#form.fApellido1#</cfif>" ></td>
						<td width="1%"><input name="fApellido2" type="text" size="25" maxlength="255" value="<cfif isdefined("form.fApellido2") and len(trim(form.fApellido2)) gt 0>#form.fApellido2#</cfif>" ></td>
					</tr>

					<tr>
						<td align="right"><b>Login:&nbsp;</b></td>
						<td><input name="fLogin" type="text" size="25" maxlength="20" value="<cfif isdefined("form.fLogin") and len(trim(form.fLogin)) gt 0>#form.fLogin#</cfif>" ></td>
						<td align="right"><b>Cuenta:&nbsp;</b></td>
						<td><input name="fCuenta" type="text" size="25" maxlength="20" value="<cfif isdefined("form.fCuenta") and len(trim(form.fCuenta)) gt 0>#form.fCuenta#</cfif>" ></td>
						<td align="right">
							<input type="submit" name="Filtrar" value="Filtrar">
							<input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();">
						</td>
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
				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pLista"
				 returnvariable="pListaEmpl">
					<cfinvokeargument name="tabla" value="UsuarioEmpresarial ue, Usuario u, CuentaClienteEmpresarial cce"/>
					<cfinvokeargument name="columnas" value=" ue.Usucodigo, ue.Ulocalizacion, u.Usucuenta, ue.cliente_empresarial, 
															  cce.nombre as nombre_cuenta, case u.Usutemporal when 0 then u.Usulogin else '-' end as Usulogin,
															  ((case when (ue.Papellido1 is not null) and (rtrim(ue.Papellido1) != '') then ue.Papellido1 + ' ' else null end) +
															   (case when (ue.Papellido2 is not null) and (rtrim(ue.Papellido2) != '') then ue.Papellido2 + ' ' else null end) +
															   (case when (ue.Pnombre is not null) and (rtrim(ue.Pnombre) != '') then ue.Pnombre + ' ' else null end)) as nombre"/>
					<cfinvokeargument name="desplegar" value="nombre,nombre_cuenta,Usulogin,Usucuenta"/>
					<cfinvokeargument name="etiquetas" value="Nombre, Cuenta Empresarial,Login, Cuenta"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value=" ue.Usucodigo = u.Usucodigo
															and ue.Ulocalizacion = u.Ulocalizacion
															and ue.cliente_empresarial = cce.cliente_empresarial
															and ue.activo = 0
															and cce.activo = 1
															and (cce.agente = #Session.Usucodigo#
																and cce.agente_loc = '#Session.Ulocalizacion#'
																or exists (select id from UsuarioPermiso
																where rol = 'sys.pso'
																and Usucodigo = #Session.Usucodigo#
																and Ulocalizacion ='#Session.Ulocalizacion#'))
																#where#
																order by  upper((case
																				when (ue.Papellido1 is not null) and (rtrim(ue.Papellido1) != '') then ue.Papellido1 + ' '
																				else null
																				end) +
																			   (case
																				when (ue.Papellido2 is not null) and (rtrim(ue.Papellido2) != '') then ue.Papellido2 + ' '
																				else null
																				end) +
																			  (case
																			   when (ue.Pnombre is not null) and (rtrim(ue.Pnombre) != '') then ue.Pnombre + ' '
																			   else null
																			   end))"/>
					<cfinvokeargument name="align" value="left,left,left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>						
					<cfinvokeargument name="irA" value="UsuarioEmpresarial_SQL.cfm"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="Conexion" value="#session.DSN#"/>						
					<cfinvokeargument name="botones" value="Activar,Eliminar"/>
					<cfinvokeargument name="checkboxes" value="S"/>
					<cfinvokeargument name="keys" value="Usucodigo,Ulocalizacion,cliente_empresarial"/>
					<cfinvokeargument name="MaxRows" value="30"/>
					<cfinvokeargument name="showLink" value="false"/>					
				</cfinvoke>
		</td>
	</tr>
</table>

<script language="JavaScript1.2" type="text/javascript">

	function funcActivar(){
		if ( checkeados() ){
			if ( confirm('Va a activar a los usuarios seleccionados. Desde continuar?' ) ){
				document.lista.CLIENTE_EMPRESARIAL.value ='<cfoutput>#form.cliente_empresarial#</cfoutput>';
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
			if ( confirm('Va a eliminar permanentemente a los usuarios seleccionados. Desde continuar?' ) ){
				document.lista.submit();
				return true;
			}
		}
		else{
			alert('No hay Sistemas seleccionados para el proceso.');
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

	function cerrar(){
		<cfif isdefined("form.update")>
			if ( (window.event.clientY < 0 ) || ( window.event.clientX < 0 ) ){
				if ( !window.opener.closed ){
					window.opener.document.form1.submit();
					return;
				}
			}
		</cfif>
	}

</script>

</body>
</html>