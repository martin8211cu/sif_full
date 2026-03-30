<html>
<head>
<title>Usuarios</title>

<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/framework/css/sif.css" rel="stylesheet" type="text/css">

</head>
<body>

	<cfif isdefined("url.ecodigo2") and not isdefined("form.ecodigo2")>
		<cfset form.ecodigo2 = url.ecodigo2 >
	</cfif>

	<cfif isdefined("form.cerrar")>
		<script type="text/javascript" language="javascript1.2">
			if ( !window.opener.closed ){
				window.opener.document.lista.ECODIGO2.value = '<cfoutput>#form.ecodigo2#</cfoutput>';
				window.opener.document.lista.submit();
			}
			window.close();
		</script>
	</cfif>

	<cfoutput>
	<form name="filtro" style="margin:0;" action="conlisUsuarios.cfm" method="post">
		<input type="hidden" name="ecodigo2" value="#form.ecodigo2#">
		<table width="100%" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
			<tr>
				<td align="right" nowrap><b>Nombre:&nbsp;</b></td>
				<td><input name="fNombre" type="text" size="20" maxlength="30" value="<cfif isdefined("form.fNombre") and len(trim(form.fNombre)) gt 0>#form.fNombre#</cfif>" ></td>
				<td align="right" nowrap><b>Login:&nbsp;</b></td>
				<td><input name="fLogin" type="text" size="20" maxlength="30" value="<cfif isdefined("form.fLogin") and len(trim(form.fLogin)) gt 0>#form.fLogin#</cfif>" ></td>
				<td align="right" nowrap><b>Cuenta:&nbsp;</b></td>
				<td><input name="fCuenta" type="text" size="10" maxlength="10" value="<cfif isdefined("form.fCuenta") and len(trim(form.fCuenta)) gt 0>#form.fCuenta#</cfif>" ></td>
				<td><input type="submit" name="Filtrar" value="Filtrar"></td>
				<td><input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();"></td>
			</tr>
		</table>
	</form>
	</cfoutput>
	
	<cfset select = " case u.Usutemporal when 0 then u.Usulogin else '-' end as Usulogin,
					  ((case when (ue.Papellido1 is not null) and (rtrim(ue.Papellido1) != '') then ue.Papellido1 + ' '	else null end) +
					   (case when (ue.Papellido2 is not null) and (rtrim(ue.Papellido2) != '') then ue.Papellido2 + ' ' else null end) +
					   (case  when (ue.Pnombre is not null) and (rtrim(ue.Pnombre) != '') then ue.Pnombre + ' ' else null end)) as nombre,
					  u.Usucuenta, ue.Usucodigo, ue.Ulocalizacion, #form.ecodigo2# as ecodigo2 " >

	<cfset from = " UsuarioEmpresarial ue, Usuario u, Empresa e " >

	<cfset where = " ue.Usucodigo = u.Usucodigo
				 and ue.Ulocalizacion = u.Ulocalizacion
				 and ue.cliente_empresarial = e.cliente_empresarial
				 and e.Ecodigo = #form.ecodigo2#
				 and not exists (select Usucodigo from UsuarioEmpresa uemp
				                 where uemp.Usucodigo = ue.Usucodigo
				 				   and uemp.Ulocalizacion = ue.Ulocalizacion
				 				   and uemp.cliente_empresarial = ue.cliente_empresarial
				 				   and uemp.Ecodigo = e.Ecodigo)" >

	<cfif isdefined("form.Filtrar") and isdefined("form.fNombre") and len(trim(form.fNombre)) gt 0>
		<cfset where = where & " and upper(ue.Pnombre) like upper('%#form.fNombre#%')" >
	</cfif> 
	
	<cfif isdefined("form.Filtrar") and isdefined("form.fLogin") and len(trim(form.fLogin)) gt 0>
		<cfset where = where & " and upper(u.Usulogin) like upper('%#form.fLogin#%')" >
	</cfif> 
	
	<cfif isdefined("form.Filtrar") and isdefined("form.fCuenta") and len(trim(form.fCuenta)) gt 0>
		<cfset where = where & " and upper(u.Usucuenta) like upper('%#form.fCuenta#%')" >
	</cfif> 

	<cfset where = where & " order by upper((case when (ue.Papellido1 is not null) and (rtrim(ue.Papellido1) != '') then ue.Papellido1 + ' ' else null end) +
										    (case when (ue.Papellido2 is not null) and (rtrim(ue.Papellido2) != '') then ue.Papellido2 + ' ' else null end) +
										    (case when (ue.Pnombre is not null) and (rtrim(ue.Pnombre) != '') then ue.Pnombre + ' ' else null end)) ">

	<cfinvoke 
	 component="sif.Componentes.pListas"
	 method="pLista"
	 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="#from#"/>
		<cfinvokeargument name="columnas" value="#select#"/>
		<cfinvokeargument name="desplegar" value="nombre,Usulogin,Usucuenta"/>
		<cfinvokeargument name="etiquetas" value="Nombre,Login,Cuenta"/>
		<cfinvokeargument name="formatos" value="V,V,V"/>
		<cfinvokeargument name="filtro" value="#where#"/>
		<cfinvokeargument name="align" value="left,left,left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="irA" value="SQLUsuarios.cfm"/>
		<cfinvokeargument name="Conexion" value="sdc"/>
		<cfinvokeargument name="MaxRows" value="20"/>
		<cfinvokeargument name="keys" value="Usucodigo,Ulocalizacion"/>
		<cfinvokeargument name="navegacion" value="botonSel=Buscar"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/> 
		<cfinvokeargument name="showLink" value="false"/>
		<cfinvokeargument name="botones" value="Agregar,Cerrar"/>
		<cfinvokeargument name="checkboxes" value="S"/>
	</cfinvoke>

	<script type="text/javascript">
		function funcAgregar() {
			if (checkeados()) {
				document.lista.ECODIGO2.value = '<cfoutput>#form.ecodigo2#</cfoutput>';
				document.lista.action = 'SQLUsuarios.cfm';
				document.lista.submit();
				return true;
			}
			else{
				alert('No hay usuarios seleccionados para el proceso.');
				return false;
			}
		}
		
		function funcCerrar() {
			if ( !window.opener.closed ){
				window.opener.location.reload();
			}
			window.close();
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

		function limpiar(){
			document.filtro.fNombre.value  = "";
			document.filtro.fLogin.value = "";
			document.filtro.fCuenta.value  = "";
		}

	</script>

</body>
</html>

