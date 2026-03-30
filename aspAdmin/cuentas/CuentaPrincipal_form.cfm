<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select cce.TIcodigo
			, cce.identificacion
			, cce.nombre
			, cce.razon_social
			, u.Usucuenta
			, cce.cache_empresarial
			, cce.Ppais
			, cce.logo
			, ambitoLogin
			, cce.Icodigo
			, direccion
			, ciudad
			, telefono
			, provincia
			, fax
			, codPostal
			, email
			, web
			, alias_login
		from Usuario u, CuentaClienteEmpresarial cce
		where cce.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
		  and cce.Usucodigo = u.Usucodigo
		  and cce.Ulocalizacion = u.Ulocalizacion
	</cfquery>
	<cfset session.CCE.Ppais = rsForm.Ppais>
	<cfset session.CCE.Icodigo = rsForm.Icodigo>
</cfif>

<cfquery name="rsPais" datasource="#session.DSN#">
	select Ppais, Pnombre 
	from Pais
	order by Pnombre
</cfquery>

<cfquery name="rsIdioma" datasource="#session.DSN#">
	select Icodigo, Descripcion
	from Idioma
	where Iactivo = 1
</cfquery>

<cfquery name="rsIdentificacion" datasource="#session.DSN#">
	select TIcodigo, TInombre 
	from TipoIdentificacion
</cfquery>

<cfoutput>

<script language="JavaScript1.2" type="text/javascript">
	function buscar(){
		document.form1.action = "CuentaPrincipal_tabs.cfm";
		<cfif isdefined("form.cliente_empresarial") >
			document.form1.cliente_empresarial.value = '';
		</cfif>		
		document.form1.submit();

	}
</script>

<!--- <cfdump var="#form#"> --->
	
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">
<form name="form1" action="CuentaPrincipal_sql.cfm" method="post" enctype="multipart/form-data" onSubmit="javascript: habAmbito();">
	<table width="10%" cellpadding="0" cellspacing="0" border="0" align="center">
      <cfif modo EQ "ALTA">
        <tr class="itemtit">
          <td colspan="5"><font size="2"><b>Nueva 
            Cuenta Empresarial</b></font></td>
        </tr>
        <tr> 
          <td colspan="5">&nbsp;</td>
        </tr>
      </cfif>
      <tr> 
        <td align="right" nowrap>Identificacion:&nbsp; </td>
        <td colspan="3" nowrap> <select name="TIcodigo" id="TIcodigo">
            <cfloop query="rsIdentificacion">
              <option value="#rsIdentificacion.TIcodigo#" <cfif modo neq 'ALTA' and  rsForm.TIcodigo eq rsIdentificacion.TIcodigo or modo EQ 'ALTA' and rsIdentificacion.TIcodigo EQ 'JUR'>selected</cfif> >#rsIdentificacion.TInombre#</option>
            </cfloop>
          </select> 
		  <input name="identificacion" type="text" value="<cfif modo neq 'ALTA'>#rsForm.identificacion#</cfif>" size="20" maxlength="60" onFocus="this.select()">
        </td>
        <td nowrap><strong>
          <cfif modo NEQ 'ALTA'>
            Cuenta: #rsForm.Usucuenta#
          </cfif>
          </strong></td>
      </tr>
      <tr> 
        <td width="40%" align="right" nowrap>Nombre:&nbsp;</td>
        <td colspan="4"><input type="text" name="nombre" size="60" maxlength="30" value="<cfif modo neq 'ALTA' >#trim(rsForm.nombre)#</cfif>" onfocus="this.select();" onblur="javascript: if (this.form.razon_social.value == '') this.form.razon_social.value=this.value;"></td>
      </tr>
      <tr> 
        <td width="40%" align="right" nowrap>Raz&oacute;n Social:&nbsp;</td>
        <td colspan="4"><input type="text" name="razon_social" size="60" maxlength="60" value="<cfif modo neq 'ALTA' >#trim(rsForm.razon_social)#</cfif>" onfocus="this.select();" ></td>
      </tr>
      <tr> 
        <td width="40%" align="right" nowrap>Logo:&nbsp;</td>
        <td colspan="4"><input type="file" name="logo">
          &nbsp;&nbsp;&nbsp;&nbsp;</td>
      </tr>
      <tr>
        <td align="right">Ambito login:&nbsp;</td>
        <td colspan="4"><select name="ambitoLogin" id="select" <cfif modo neq 'ALTA'> disabled</cfif>>
            <option value="C" <cfif modo NEQ 'ALTA' and rsForm.ambitoLogin EQ 'C'> selected</cfif>>ASP 
            de Cliente 
<option value="P" <cfif modo NEQ 'ALTA' and rsForm.ambitoLogin EQ 'P'> selected</cfif>>ASP 
            de Portal </select>
          &nbsp;&nbsp;&nbsp;&nbsp;Alias para login: 
          <input type="text" name="alias_login" size="20" maxlength="20" value="<cfif modo neq 'ALTA' >#trim(rsForm.alias_login)#</cfif>" onFocus="this.select();"
		onBlur="this.value = this.value.toLowerCase();" 
		onkeypress1="javascript:if ((event.keyCode) && (event.keyCode == 32)) event.keyCode = 0;"
		onKeyPress="javascript:fnMinusculasSinEspacios(event);"
		></td>
      </tr>
      <tr> 
        <td>&nbsp;</td>
        <td colspan="4"> <input type="checkbox" name="cache_empresarial" <cfif modo neq 'ALTA' and rsForm.cache_empresarial eq 1>checked</cfif> >
          Base de Datos dedicada s&oacute;lo para las empresas del cliente</td>
      </tr>
      <tr> 
        <td colspan="5">&nbsp;</td>
      </tr>
      <tr> 
        <td align="right" nowrap>Pa&iacute;s:&nbsp;</td>
        <td> <select name="Ppais" onChange="javascript:fnLocaleCambioPais(this.value);">
            <option value="CR">Costa Rica</option>
            <cfloop query="rsPais">
              <option value="#rsPais.Ppais#" <cfif modo neq 'ALTA' and  rsPais.Ppais EQ rsForm.Ppais>selected</cfif>>#rsPais.Pnombre#</option>
            </cfloop>
          </select></td>
        <td>&nbsp;</td>
        <td align="right">Idioma:&nbsp;</td>
        <td> <input type="hidden" name="DIAid"> <select name="Icodigo" id="Icodigo">
            <cfloop query="rsIdioma">
              <option value="#rsIdioma.Icodigo#" <cfif modo neq 'ALTA' and  rsIdioma.Icodigo eq rsForm.Icodigo> selected</cfif> >#rsIdioma.Descripcion#</option>
            </cfloop>
          </select></td>
      </tr>
      <tr> 
        <td align="right" valign="top" nowrap>Direcci&oacute;n:&nbsp; </td>
        <td colspan="4"><textarea name="direccion" cols="50" rows="3" class="" id="direccion"><cfif modo NEQ 'ALTA'>#rsForm.direccion#</cfif></textarea></td>
      </tr>
      <tr> 
        <td align="right" nowrap>Ciudad:&nbsp; </td>
        <td><input name="ciudad" type="text" id="ciudad" maxlength="255" value="<cfif modo NEQ 'ALTA' >#trim(rsForm.ciudad)#</cfif>"></td>
        <td>&nbsp;</td>
        <td align="right">Tel&eacute;fono:&nbsp;</td>
        <td><input name="telefono" type="text" id="telefono" size="30" maxlength="30" value="<cfif modo NEQ 'ALTA' >#trim(rsForm.telefono)#</cfif>">
        </td>
      </tr>
      <tr> 
		<cfset LvarProvincia = "">
		<cfset LvarPpais = "">
		<cfif modo NEQ 'ALTA'><cfset LvarProvincia = trim(rsForm.provincia)><cfset LvarPpais = trim(rsForm.Ppais)></cfif>
        <td align="right" nowrap>
			<cf_LocaleConceptLabel Name="provincia" Default="Provincia/Estado"><span id="locDsp__provincia">:&nbsp;</span>
        </td>
        <td>
			<cf_LocaleConcept Name="provincia" Value="#LvarProvincia#" Concepto="PROVINCIA" Pais="#LvarPpais#" Obligatorio="true" ConCambio="true"> 
        </td>
        <td>&nbsp;</td>
        <td align="right">Fax:&nbsp;</td>
        <td><input name="fax" type="text" id="fax" size="30" maxlength="30" value="<cfif modo NEQ 'ALTA' >#trim(rsForm.fax)#</cfif>"></td>
      </tr>
      <tr> 
        <td align="right" nowrap>C&oacute;digo Postal:&nbsp;</td>
        <td><input name="codPostal" type="text" id="codPostal" maxlength="60" value="<cfif modo NEQ 'ALTA' >#trim(rsForm.codPostal)#</cfif>"></td>
        <td>&nbsp;</td>
        <td align="right">email:&nbsp;</td>
        <td><input name="email" type="text" id="email" value="<cfif modo NEQ 'ALTA' >#trim(rsForm.email)#</cfif>" maxlength="60"></td>
      </tr>
      <tr> 
        <td align="right">P&aacute;gina Web:&nbsp;</td>
        <td colspan="4"><input name="web" type="text" id="web" value="<cfif modo NEQ 'ALTA' >#trim(rsForm.web)#</cfif>" size="60" maxlength="60"></td>
      </tr>
      <cfif modo EQ 'ALTA'>
        <tr> 
          <td align="right" nowrap>Email 
            Administrador:&nbsp;</td>
          <td colspan="4"><input name="EmailAdmin" type="text" id="EmailAdmin" size="60" maxlength="60"></td>
        </tr>
      </cfif>
      <tr>
        <td colspan="5">&nbsp;</td>
      </tr>
      <tr> 
        <td  colspan="5" align="center" valign="top" nowrap> <link href="/cfmx/sif/css/estilos.css" rel="stylesheet" type="text/css"> 
          <script language="JavaScript" type="text/javascript">
								// Funciones para Manejo de Botones
								botonActual = "";
							
								function setBtn(obj) {
									botonActual = obj.name;
								}
								function btnSelected(name, f) {
									if (f != null) {
										return (f["botonSel"].value == name)
									}
									else {
										return (botonActual == name)
									}
								}
							</script> <input type="hidden" name="botonSel" value="">
          <input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
          <cfif session.tipoRolAdmin NEQ "sys.adminCuenta">
            <cfif modo EQ "ALTA">
              <input type="submit" name="AltaE" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
              <input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
              <input type="button" name="Buscar" value="Ir a lista" onClick="javascript: this.form.botonSel.value = this.name; buscar();">
              <cfelse>
              <input type="submit" name="CambioE" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); ">
              <input type="submit" name="BajaE" value="Desactivar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea desactivar la Cuenta Empresarial?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
              <input type="submit" name="NuevoE" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion();">
              <input type="button" name="Buscar" value="Ir a lista" onClick="javascript: this.form.botonSel.value = this.name; buscar();">
            </cfif>
          </cfif> </td>
      </tr>
    </table>

	<!--- Ocultos --->
	<cfif isdefined("form.cliente_empresarial") >
		<input type="hidden" name="cliente_empresarial" value="#form.cliente_empresarial#" >
	</cfif>
	
	<cfif isdefined("url.pagenum_lista") and not isdefined("form.pagenum")>
		<input type="hidden" name="pagina" value="#url.pagenum_lista#" >
	<cfelseif isdefined("form.pagenum")>
		<input type="hidden" name="pagina" value="#form.pagenum#" >
	<cfelseif isdefined("form.pagina")>
		<input type="hidden" name="pagina" value="#form.pagina#" >
	<cfelse>
		<input type="hidden" name="pagina" value="" >
	</cfif>
</form>
</cfoutput>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	function habAmbito(){
		document.form1.ambitoLogin.disabled=false;
	}
//--------------------------------------------------------------------
	function deshabilitarValidacion(){
		objForm.nombre.required = false;
		objForm.nombre.required    = false;
		objForm.razon_social.required    = false;
		objForm.identificacion.required    = false;
		<cfif modo eq 'ALTA'>
			objForm.EmailAdmin.required    = false;
		</cfif>				
	}
//--------------------------------------------------------------------	
	function habilitarValidacion(){
		objForm.nombre.required = true;
		objForm.nombre.required    = true;
		objForm.razon_social.required    = true;
		objForm.identificacion.required    = true;
		<cfif modo eq 'ALTA'>
			objForm.EmailAdmin.required    = true;
		</cfif>		
	}
//--------------------------------------------------------------------	
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
//------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
//------------------------------------------------------------
	objForm.TIcodigo.required    = true;
	objForm.TIcodigo.description = "Tipo de Identificacion";	
	objForm.identificacion.required    = true;
	objForm.identificacion.description = "Número de Identificación";	
	objForm.nombre.required    = true;
	objForm.nombre.description = "Nombre";
	objForm.razon_social.required    = true;
	objForm.razon_social.description = "Razón Social";
	<cfif modo eq 'ALTA'>
		objForm.EmailAdmin.required    = true;
		objForm.EmailAdmin.description = "Email del administrador";	
	</cfif>		

function fnMinusculasSinEspacios(evento)
{
	var version4 = window.Event ? true : false;
	if (version4) { // Navigator 4.0x 
		var whichCode = evento.which;
		var whichObj  = evento.currentTarget;
	} else {// Internet Explorer 4.0x
		var whichCode = evento.keyCode;
		var whichObj  = evento.srcElement;
	}

	if (whichCode == '32')
		whichCode = 0;
	else
		whichCode = String.fromCharCode(whichCode).toLowerCase().charCodeAt(0);

	if (version4) { // Navigator 4.0x 
		evento.which = whichCode;
	} else {
		evento.keyCode = whichCode;
	}
}
</script>
