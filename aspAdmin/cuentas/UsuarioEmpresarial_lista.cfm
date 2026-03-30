<cfif isdefined("url.cliente_empresarial") and not isdefined("form.cliente_empresarial") >
	<cfset form.cliente_empresarial = url.cliente_empresarial >
</cfif>

<cfparam name="form.Usucodigo" default="">
<cfif form.Usucodigo NEQ "" OR isdefined("form.modo") AND form.modo EQ "ALTA">
	<cfif not isdefined("form.modo")>
		<cfset form.modo = "CAMBIO">
	</cfif>
	<cfinclude template="UsuarioEmpresarial_form.cfm">
	<cfexit> 
</cfif>

<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">

<cfparam name="url.ppTipo" default="U">
<cfparam name="url.ppInactivo" default="0">
<cfparam name="url.ppCliente_empresarial" default="0">
<cfparam name="form.ppTipo" default="#url.ppTipo#">
<cfparam name="form.ppInactivo" default="#url.ppInactivo#">
<cfparam name="form.cliente_empresarial" default="#url.ppCliente_empresarial#">

<cfif mid(form.ppTipo,1,2) EQ 'CL'>
<head>
<title>Lista de Usuarios</title>
</head>
</cfif>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr class="itemtit"><td colspan="2">
	  <font size="2"><b>
	  <cfif form.ppTipo EQ "A">
	  Lista de Usuarios Administradores de la Cuenta Empresarial
	  <cfelseif form.ppTipo EQ "C">
	  Lista de Contactos Empresariales
	  <cfelse>
	  Lista de Usuarios Empresariales
	  </cfif>
	  </b></font></td></tr>
	
	<tr><td colspan="2">&nbsp;</td></tr>
	
	<tr>				
		<td valign="top">
			<cfoutput>
			<form name="form1" style="margin:0;" action="CuentaPrincipal_tabs.cfm" method="post">
				<input type="hidden" name="cliente_empresarial" value="#form.cliente_empresarial#" >
				<input type="hidden" name="ppTipo" value="#form.ppTipo#">
				<input type="hidden" name="ppInactivo" value="#form.ppInactivo#">
				<table width="100%" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
					<tr>
					  	<td>&nbsp;</td>
              			<td><b>Nombre:</b></td>
					<cfif form.ppTipo EQ "C">
						<td><b>Tipo Contacto:&nbsp;</b></td>
					<cfelse>
						<td><b>Login:&nbsp;</b></td>
					</cfif>
					  <td colspan="4">&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td><input name="fNombre" type="text" size="40" maxlength="30" value="<cfif isdefined("form.fNombre") and len(trim(form.fNombre)) gt 0>#form.fNombre#</cfif>" ></td>
					<cfif form.ppTipo EQ "C">
						<td><input name="fContacto" type="text" size="40" maxlength="30" value="<cfif isdefined("form.fContacto") and len(trim(form.fContacto)) gt 0>#form.fContacto#</cfif>" >
							<input name="fLogin" type="hidden">
							<input name="fCuenta" type="hidden">
						</td>
					<cfelse>
						<td><input name="fLogin" type="text" size="40" maxlength="30" value="<cfif isdefined("form.fLogin") and len(trim(form.fLogin)) gt 0>#form.fLogin#</cfif>" ></td>
							<input name="fCuenta" type="hidden" size="10" maxlength="10" value="<cfif isdefined("form.fCuenta") and len(trim(form.fCuenta)) gt 0>#form.fCuenta#</cfif>">
							<input name="fContacto" type="hidden">
						</td>
					</cfif>
					  	<td>&nbsp;</td>
						<td><input type="submit" name="Filtrar" value="Filtrar"></td>
						<td>
							<input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();">
						</td>
						<td>&nbsp;</td>
					</tr>
				</table>
			</form>
			</cfoutput>
			<cfif mid(form.ppTipo,1,2) NEQ 'CL'>			
						<table width="100%">
							<tr>
								<td width="1%"><input type="checkbox" name="chkall" value="T" onClick="javascript:check_all( this );"></td>
								<td valign="middle"><b>Seleccionar Todo</b></td>
							</tr>	
						</table>
			</cfif>

			<cfset select = "convert(varchar, ue.Usucodigo) as Usucodigo, ue.Ulocalizacion, u.Usucuenta,
					         convert(varchar, ue.cliente_empresarial) as cliente_empresarial, cce.nombre as nombre_cuenta,
					         case u.Usutemporal when 0 then u.Usulogin else '-' end as Usulogin,
					         ( 	(case when (ue.Papellido1 is not null) and (rtrim(ue.Papellido1) != '') then ue.Papellido1 + ' ' else null end) +
					   			(case when (ue.Papellido2 is not null) and (rtrim(ue.Papellido2) != '') then ue.Papellido2 + ' ' else null end) +
					  			(case when (ue.Pnombre is not null) and (rtrim(ue.Pnombre) != '') then ue.Pnombre + ' ' else null end)) as nombre,
							  case ue.admin when 1 then '<img src=''../imagenes/checkMark.gif'' border=0>' end as admin,	
							  isnull(tf.TFdescripcion,'-') as contac,
							  '#form.ppTipo#' as ppTipo, '#form.ppInactivo#' as ppInactivo">

			<cfset from   = "UsuarioEmpresarial ue, Usuario u, CuentaClienteEmpresarial cce, TipoFuncionario tf" >
			
			<cfset where  = " ue.Usucodigo = u.Usucodigo
					  		  and ue.Ulocalizacion = u.Ulocalizacion
					  		  and ue.cliente_empresarial = cce.cliente_empresarial
					  		  and ue.cliente_empresarial = #form.cliente_empresarial#">

			<cfif form.ppTipo EQ "A">
				<cfset where  = where & "
					  		  and ue.admin = 1
							  and ue.TFcodigo *= tf.TFcodigo">
			<cfelseif form.ppTipo EQ "C">
				<cfset where  = where & "
					  		  and ue.TFcodigo is not null
							  and ue.TFcodigo = tf.TFcodigo">
			<cfelseif form.ppTipo EQ "CL-A">
				<cfset where  = where & "
					  		  and ue.admin = 0
							  and ue.TFcodigo *= tf.TFcodigo">
			<cfelseif form.ppTipo EQ "CL-C">
				<cfset where  = where & "
					  		  and ue.TFcodigo is null
							  and ue.TFcodigo *= tf.TFcodigo">
			<cfelse>
				<cfset where  = where & "
							  and ue.TFcodigo *= tf.TFcodigo">
			</cfif>

			<cfif form.ppInactivo EQ "1">
				<cfset where  = where & "
					  		  and ue.activo = 0">
			<cfelse>
				<cfset where  = where & "
					  		  and ue.activo = 1">
			</cfif>

			<cfif isdefined("form.Filtrar") and isdefined("form.fNombre") and len(trim(form.fNombre)) gt 0>
				<cfset where = where & " and upper( (case when (ue.Papellido1 is not null) and (rtrim(ue.Papellido1) != '') then ue.Papellido1 + ' ' else null	end) +
					                                (case when (ue.Papellido2 is not null) and (rtrim(ue.Papellido2) != '') then ue.Papellido2 + ' ' else null	end) +
					                                (case when (ue.Pnombre is not null) and (rtrim(ue.Pnombre) != '') then ue.Pnombre + ' ' else null end)) like upper('%#form.fNombre#%') " >
			</cfif> 

			<cfif isdefined("form.Filtrar") and isdefined("form.fContacto") and len(trim(form.fContacto)) gt 0>
				<cfset where = where & " and upper(tf.TFdescripcion) like upper('%#form.fContacto#%') " >
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
			 component="aspAdmin.Componentes.pListasASP"
			 method="pLista"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="#from#"/>
				<cfinvokeargument name="columnas" value="#select#"/>
	<cfif form.ppTipo EQ "C">
				<cfinvokeargument name="desplegar" value="nombre,contac"/>
				<cfinvokeargument name="etiquetas" value="Nombre,Contacto"/>
				<cfinvokeargument name="formatos" value="V,C"/>
				<cfinvokeargument name="align" value="left,center"/>
	<cfelse>
				<cfinvokeargument name="desplegar" value="nombre,Usulogin,admin,contac"/>
				<cfinvokeargument name="etiquetas" value="Nombre,Login,Admin,Contacto"/>
				<cfinvokeargument name="formatos" value="V,V,C,C"/>
				<cfinvokeargument name="align" value="left,left,center,center"/>
	</cfif>			
				<cfinvokeargument name="filtro" value="#where#"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="Conexion" value="#session.DSN#"/>
				<cfinvokeargument name="MaxRows" value="30"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="navegacion" value="botonSel=Buscar&cliente_empresarial=#form.cliente_empresarial#"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="Usucodigo,Ulocalizacion"/>
				<cfif mid(form.ppTipo,1,2) EQ 'CL'>
					<cfinvokeargument name="funcion" value="fnConLisEscoger"/>
					<cfinvokeargument name="fparams" value="Usucodigo,Ulocalizacion"/>
				<cfelseif form.ppTipo EQ "U">
					<cfinvokeargument name="irA" value="CuentaPrincipal_tabs.cfm"/>
					<cfinvokeargument name="checkboxes" value="S"/>
					<cfinvokeargument name="botones" value="Agregar,Desactivar,Reafiliar"/> 
				<cfelse>
					<cfinvokeargument name="irA" value="CuentaPrincipal_tabs.cfm"/>
					<cfinvokeargument name="checkboxes" value="S"/>
					<cfinvokeargument name="botones" value="Agregar,Desactivar"/> 
				</cfif>
			</cfinvoke>
		</td>
	</tr>
</table>

<script language="JavaScript1.2" type="text/javascript">
<cfif mid(form.ppTipo,1,2) EQ 'CL'>
	function fnConLisEscoger(pUsucodigo, pUlocalizacion){
		window.opener.document.form1.Usucodigo.value = pUsucodigo;
		window.opener.document.form1.Ulocalizacion.value = pUlocalizacion;
		window.opener.document.form1.modo.value = "CAMBIO";
		window.opener.document.form1.action = "CuentaPrincipal_tabs.cfm";
		window.opener.document.form1.submit();
		window.close();
	}
</cfif>
	function limpiar(){
		document.form1.fNombre.value = "";
		document.form1.fLogin.value = "";
		document.form1.fCuenta.value = "";
		document.form1.fContacto.value = "";
	}

	function funcAgregar(){
		document.lista.CLIENTE_EMPRESARIAL.value = '<cfoutput>#form.cliente_empresarial#</cfoutput>';
		document.lista.PPTIPO.value = '<cfoutput>#form.ppTipo#</cfoutput>';
		document.lista.PPINACTIVO.value = '<cfoutput>#form.ppInactivo#</cfoutput>';
		document.lista.action = 'CuentaPrincipal_tabs.cfm';
		//document.lista.submit();
	}

	function funcDesactivar(){
		if ( checkeados("") ){
			if ( confirm('Va deshabilitar a los usuarios seleccionados. Desde continuar?' ) ){
				document.lista.CLIENTE_EMPRESARIAL.value = '<cfoutput>#form.cliente_empresarial#</cfoutput>';
				document.lista.PPTIPO.value = '<cfoutput>#form.ppTipo#</cfoutput>';
				document.lista.PPINACTIVO.value = '<cfoutput>#form.ppInactivo#</cfoutput>';
				document.lista.action = 'UsuarioEmpresarial_SQL.cfm';				
				//document.lista.submit();
				return true;
			}
		}
		else{
			alert('No hay usuarios seleccionados para el proceso.');
		}
		
		return false;
	}

	function funcReafiliar(){
		if ( checkeados("-") ){
			if ( confirm('Va a Reafiliar a los usuarios seleccionados que no tengan login. Desde continuar?' ) ){
				document.lista.CLIENTE_EMPRESARIAL.value = '<cfoutput>#form.cliente_empresarial#</cfoutput>';
				document.lista.PPTIPO.value = '<cfoutput>#form.ppTipo#</cfoutput>';
				document.lista.PPINACTIVO.value = '<cfoutput>#form.ppInactivo#</cfoutput>';
				document.lista.action = 'UsuarioEmpresarial_SQL.cfm';
				//document.lista.submit();
				return true;
			}
		}
		else{
			alert('No hay usuarios seleccionados para el proceso.');
		}
		
		return false;
	}

	function funcReimprimir(){
		if ( checkeados("T") ){
			if ( confirm('Va a reimprimir la afiliación de los usuarios seleccionados que tengan un login temporal. Desde continuar?' ) ){
				document.lista.CLIENTE_EMPRESARIAL.value = '<cfoutput>#form.cliente_empresarial#</cfoutput>';
				document.lista.PPTIPO.value = '<cfoutput>#form.ppTipo#</cfoutput>';
				document.lista.PPINACTIVO.value = '<cfoutput>#form.ppInactivo#</cfoutput>';
				document.lista.action = 'CuentaPrincipal_tabs.cfm';
				//document.lista.submit();
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

	function checkeados(pTipo){
		var form = eval('lista');
		
		if (existe(form, "chk")){
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked)
					{
						if (pTipo == "")
							return true;
						else if (pTipo == "-" && eval("form.USULOGIN_"+(i+1)+".value") == "-")
							return true;
						else if (pTipo != "-" && eval("form.USULOGIN_"+(i+1)+".value") != "-")
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

	function frame(){
		// limpia el frame de administradores
		open('about:blank', 'admin');
	}	

	function buscar(){
		// limpia el frame de administradores
		frame();

		document.form2.action = "listaCuentas.cfm";
		document.form2.submit();
	}

</script>