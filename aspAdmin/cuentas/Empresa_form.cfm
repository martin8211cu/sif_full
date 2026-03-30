<!--- Establecimiento del modo --->
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
		select e.TIcodigo
			, e.identificacion
			, e.nombre_comercial
			, e.razon_social
			, u.Usucuenta
			, e.Ppais
			, e.logo
			, e.Icodigo
			, e.direccion
			, e.ciudad
			, e.telefono
			, e.provincia
			, e.fax
			, e.codPostal
			, e.email
			, e.web
		from Usuario u, Empresa e
		where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo2#">
		  and e.Usucodigo = u.Usucodigo
		  and e.Ulocalizacion = u.Ulocalizacion
	</cfquery>
</cfif>
 
<cfif modo NEQ 'ALTA'>
	<cfset LvarPpais = rsForm.Ppais>
<cfelse>
	<cfif isdefined("session.CCE")>
		<cfset LvarPpais = session.CCE.Ppais>
	<cfelse>
		<cfset LvarPpais = 'CR'>
	</cfif>
</cfif>
<cfquery name="rsPais" datasource="#session.DSN#">
	select Ppais, Pnombre 
	from Pais
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

<script language="JavaScript1.2" type="text/javascript">
	function frame(){
		// limpia el frame de administradores
	}	

	function buscar(){
		// limpia el frame de administradores
		document.formEmpresas.Ecodigo2.value = "";
		document.formEmpresas.action = "CuentaPrincipal_tabs.cfm";
		document.formEmpresas.submit();
	}
</script>

<cfoutput>
	<style  type="text/css" >
	iframe.marco {
		width: 100%;
		border: 1px;
		margin: 0px 0px 0px 0px;
		padding: 0px 0px 0px 0px;
	}
	</style>
<link href="/cfmx/aspAdmin/css/sif.css" rel="stylesheet" type="text/css">
<link href="/cfmx/aspAdmin/css/sec.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/css/web_portlet.css" rel="stylesheet" type="text/css">
<form name="formEmpresas" action="Empresa_SQL.cfm" method="post" enctype="multipart/form-data">
		<input type="hidden" name="cliente_empresarial" value="#form.cliente_empresarial#">
		<input type="hidden" name="Ecodigo2" value="#form.Ecodigo2#">
	
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<cfif modo EQ "ALTA">
		<tr class="itemtit"><td colspan="5"><font size="2"><b>Nueva Empresa</b></font></td></tr>
		<tr><td colspan="5">&nbsp;</td></tr>
	</cfif>
      <tr> 
        <td width="40%" align="left" valign="top"> 
		  <table width="100%" cellpadding="0" cellspacing="0" align="center" border="0" >
            <tr> 
              <td align="right" nowrap>Identificacion:&nbsp; </td>
              <td colspan="3" nowrap> <select name="TIcodigo" id="TIcodigo">
                  <cfloop query="rsIdentificacion">
                    <option value="#rsIdentificacion.TIcodigo#" <cfif modo neq 'ALTA' and  rsForm.TIcodigo eq rsIdentificacion.TIcodigo or modo EQ 'ALTA' and rsIdentificacion.TIcodigo EQ 'JUR'>selected</cfif> >#rsIdentificacion.TInombre#</option>
                  </cfloop>
                </select> <input name="identificacion" type="text" value="<cfif modo neq 'ALTA'>#rsForm.identificacion#</cfif>" size="20" maxlength="60" onFocus="this.select()" > 
                
			  </td>
              <td nowrap><cfif modo NEQ 'ALTA'>
              </cfif> </td>
            </tr>
            <tr> 
              <td width="40%" align="right" nowrap>Nombre:&nbsp;</td>
              <td colspan="4"><input type="text" name="nombre_comercial" size="60" maxlength="30" value="<cfif modo neq 'ALTA' >#trim(rsForm.nombre_comercial)#</cfif>" onfocus="this.select();" onblur="javascript: if (this.form.razon_social.value == '') this.form.razon_social.value=this.value;"></td>
            </tr>
            <tr> 
              <td width="40%" align="right" nowrap>Raz&oacute;n Social:&nbsp;</td>
              <td colspan="4"><input type="text" name="razon_social" size="60" maxlength="60" value="<cfif modo neq 'ALTA' >#trim(rsForm.razon_social)#</cfif>" onfocus="this.select();" ></td>
            </tr>
            <tr> 
              <td width="40%" align="right" nowrap>Logo:&nbsp;</td>
              <td colspan="4"><input type="file" name="logo"></td>
            </tr>
            <tr> 
              <td colspan="5">&nbsp;</td>
            </tr>
            <tr> 
              <td align="right" nowrap>Pa&iacute;s:&nbsp;</td>
              <td>
			  	<select name="Ppais" onChange="javascript:fnLocaleCambioPais(this.value);">
                  <cfloop query="rsPais">
                    <option value="#rsPais.Ppais#" <cfif rsPais.Ppais EQ LvarPpais>selected</cfif>>#rsPais.Pnombre#</option>
                  </cfloop>
                </select></td>
              <td>&nbsp;</td>
              <td align="right">Idioma:&nbsp;</td>
              <td> 
			  	<select name="Icodigo" id="Icodigo">
                  <cfloop query="rsIdioma">
                    <option value="#rsIdioma.Icodigo#" <cfif modo neq 'ALTA' and  rsIdioma.Icodigo eq rsForm.Icodigo OR modo EQ 'ALTA' AND isdefined("session.CCE") AND session.CCE.Icodigo eq rsIdioma.Icodigo> selected</cfif> >#rsIdioma.Descripcion#</option>
                  </cfloop>
                </select>
			  </td>
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
				<td align="right" nowrap>
					<cf_LocaleConceptLabel Name="provincia" Default="Provincia/Estado"><span id="locDsp__provincia">:&nbsp;</span>
				</td>
				<td>
			  		<cfif modo NEQ 'ALTA'><cfset LvarProvincia=trim(rsForm.provincia)><cfelse><cfset LvarProvincia=""></cfif>
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
          </table>
		</td>
      </tr>
      <tr>
		<td>&nbsp;
		
		</td>
      </tr>
      <tr>
		<td align="center" valign="top" nowrap>
			    <link href="/cfmx/sif/css/estilos.css" rel="stylesheet" type="text/css"> 
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
                <cfif modo EQ "ALTA">
                  <input type="submit" name="AltaE" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
                  <input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
                  <input type="button" name="Buscar" value="Ir a lista" onClick="javascript: this.form.botonSel.value = this.name; buscar();">
                  <cfelse>
                  <input type="submit" name="CambioE" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); ">
                  <input type="submit" name="BajaE" value="Desactivar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea desactivar la Cuenta Empresarial?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
                  <input type="submit" name="NuevoE" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); frame();">
                  <input type="button" name="Buscar" value="Ir a lista" onClick="javascript: this.form.botonSel.value = this.name; buscar();">
                </cfif> </td>
      </tr>
    </table>

	<!--- Ocultos --->
	<cfif isdefined("url.pagenum_lista") and not isdefined("form.pagenum")>
		<input type="hidden" name="pagina" value="#url.pagenum_lista#" >
	<cfelseif isdefined("form.pagenum")>
		<input type="hidden" name="pagina" value="#form.pagenum#" >
	<cfelseif isdefined("form.pagina")>
		<input type="hidden" name="pagina" value="#form.pagina#" >
	<cfelse>
		<input type="hidden" name="pagina" value="" >
	</cfif>
</cfoutput>
<br>
</form>
	
<script src="/cfmx/aspAdmin/js/qForms/qforms.js"></script>
<script src="/cfmx/aspAdmin/empresas/masks.js"></script>
<script language="JavaScript1.2" type="text/javascript">
//----------------------------------------------------------------------------------------------------
	function habilitarValidacion(){
		objForm.nombre_comercial.required  	= true;
		objForm.TIcodigo.required 			= true;
		objForm.identificacion.required     = true;
		objForm.razon_social.required      	= true;		
	}
//--------------------------------------------------
	function deshabilitarValidacion(){
		objForm.nombre_comercial.required  	= false;
		objForm.TIcodigo.required 			= false;
		objForm.identificacion.required     = false;
		objForm.razon_social.required      	= false;		
	}
//--------------------------------------------------	
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/aspAdmin/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formEmpresas");
//--------------------------------------------------------------
	objForm.nombre_comercial.required    = true;
	objForm.nombre_comercial.description = "Nombre";
	objForm.TIcodigo.required    = true;
	objForm.TIcodigo.description = "Tipo de Identificación";
	objForm.identificacion.required    = true;
	objForm.identificacion.description = "Identificación";
	objForm.razon_social.required    = true;
	objForm.razon_social.description = "Razón Social";
</script>