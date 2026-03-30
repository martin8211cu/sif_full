<cfif isdefined("url.cliente_empresarial") and not isdefined("form.cliente_empresarial") >
	<cfset form.cliente_empresarial = url.cliente_empresarial >
</cfif>

<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">

<table width="100%" cellpadding="0" cellspacing="0">
	<tr class="itemtit"><td colspan="2"><font size="2"><b>Lista de Usuarios Administradores Inhabilitados</b></font></td></tr>
	
	<tr><td colspan="2">&nbsp;</td></tr>
	
	<tr>				
		<td valign="top">
			<cfoutput>
			<form name="form1" style="margin:0;" action="listaAdmin.cfm" method="post">
				<table width="100%" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
					<tr>
						<td align="right"><b>Nombre:&nbsp;</b></td>
						<td><input name="fNombre" type="text" size="40" maxlength="30" value="<cfif isdefined("form.fNombre") and len(trim(form.fNombre)) gt 0>#form.fNombre#</cfif>" ></td>
						<td align="right"><b>Login:&nbsp;</b></td>
						<td><input name="fLogin" type="text" size="40" maxlength="30" value="<cfif isdefined("form.fLogin") and len(trim(form.fLogin)) gt 0>#form.fNombre#</cfif>" ></td>
						<td align="right"><b>Cuenta:&nbsp;</b></td>
						<td><input name="fCuenta" type="text" size="10" maxlength="10" value="<cfif isdefined("form.fCuenta") and len(trim(form.fCuenta)) gt 0>#form.fCuenta#</cfif>" ></td>
						<td><input type="submit" name="Filtrar" value="Filtrar"></td>
						<td>
							<input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();">
							<input type="hidden" name="cliente_empresarial" value="<cfoutput>#form.cliente_empresarial#</cfoutput>" >
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
		
			<cfset select = "convert(varchar, ue.Usucodigo) as Usucodigo, ue.Ulocalizacion, u.Usucuenta,
					         convert(varchar, ue.cliente_empresarial) as cliente_empresarial, cce.nombre as nombre_cuenta,
					         case u.Usutemporal when 0 then u.Usulogin else '-' end as Usulogin,
					         ( 	(case when (ue.Papellido1 is not null) and (rtrim(ue.Papellido1) != '') then ue.Papellido1 + ' ' else null end) +
					   			(case when (ue.Papellido2 is not null) and (rtrim(ue.Papellido2) != '') then ue.Papellido2 + ' ' else null end) +
					  			(case when (ue.Pnombre is not null) and (rtrim(ue.Pnombre) != '') then ue.Pnombre + ' ' else null end)) as nombre" >

			<cfset from   = "UsuarioEmpresarial ue, Usuario u, CuentaClienteEmpresarial cce" >
			
			<cfset where  = " ue.Usucodigo = u.Usucodigo
					  		  and ue.Ulocalizacion = u.Ulocalizacion
					  		  and ue.cliente_empresarial = cce.cliente_empresarial
					  		  and ue.cliente_empresarial = #form.cliente_empresarial#
					  		  and ue.admin = 1
					  		  and ue.activo = 0">

			<cfif isdefined("form.Filtrar") and isdefined("form.fNombre") and len(trim(form.fNombre)) gt 0>
				<cfset where = where & " and upper( (case when (ue.Papellido1 is not null) and (rtrim(ue.Papellido1) != '') then ue.Papellido1 + ' ' else null	end) +
					                                (case when (ue.Papellido2 is not null) and (rtrim(ue.Papellido2) != '') then ue.Papellido2 + ' ' else null	end) +
					                                (case when (ue.Pnombre is not null) and (rtrim(ue.Pnombre) != '') then ue.Pnombre + ' ' else null end)) like upper('%#form.fNombre#%') " >
			</cfif> 

 			<cfif isdefined("form.Filtrar") and isdefined("form.fCuenta") and len(trim(form.fCuenta)) gt 0>
				<cfset where = where & " and upper(u.Usucuenta) like upper('%#form.fCuenta#%')" >
			</cfif> 

 			<cfif isdefined("form.Filtrar") and isdefined("form.fLogin") and len(trim(form.fLogin)) gt 0>
				<cfset where = where & " and upper(u.Usulogin) like upper('%#form.fLogin#%')" >
			</cfif> 

			<cfset where = where & " order by upper( (case when (ue.Papellido1 is not null) and (rtrim(ue.Papellido1) != '') then ue.Papellido1 + ' ' else null	end) +
					   		 				  		 (case when (ue.Papellido2 is not null) and (rtrim(ue.Papellido2) != '') then ue.Papellido2 + ' ' else null	end) +
					  		 				  		 (case when (ue.Pnombre is not null) and (rtrim(ue.Pnombre) != '') then ue.Pnombre + ' ' else null end))" >
			

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
				<cfinvokeargument name="irA" value="SQLUsuario.cfm"/>
				<cfinvokeargument name="Conexion" value="sdc"/>
				<cfinvokeargument name="MaxRows" value="35"/>
				<cfinvokeargument name="checkboxes" value="S"/>
				<cfinvokeargument name="botones" value="Activar,Eliminar"/> 
				<cfinvokeargument name="navegacion" value="botonSel=Buscar&cliente_empresarial=#form.cliente_empresarial#"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="Usucodigo,Ulocalizacion"/>
				<cfinvokeargument name="showLink" value="false"/>
			</cfinvoke>
		</td>
	</tr>
</table>

<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.form1.fNombre.value = "";
		document.form1.fLogin.value = "";
		document.form1.fCuenta.value = "";
	}

	function funcActivar(){
		if ( checkeados() ){
			if ( confirm('Va a activar a los usuarios seleccionados. Desde continuar?' ) ){
				document.lista.CLIENTE_EMPRESARIAL.value = '<cfoutput>#form.cliente_empresarial#</cfoutput>';
				document.lista.action = 'SQLUsuario.cfm';
				document.lista.submit();
				return true;
			}
		}
		else{
			alert('No hay usuarios seleccionados para el proceso.');
		}	

		return false;	
	}

	function funcEliminar(){
		if ( checkeados() ){
			if ( confirm('Va a eliminar permanentemente a los usuarios seleccionados. Desde continuar?' ) ){
				document.lista.CLIENTE_EMPRESARIAL.value = '<cfoutput>#form.cliente_empresarial#</cfoutput>';
				document.lista.action = 'SQLUsuario.cfm';
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