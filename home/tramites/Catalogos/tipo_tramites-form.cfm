<cfif isdefined("Form.Cambio")>  
  <cfset modo="CAMBIO">
<cfelse>  
  <cfif not isdefined("Form.modo")>    
    <cfset modo="ALTA">
  <cfelseif Form.modo EQ "CAMBIO">
    <cfset modo="CAMBIO">
  <cfelse>
    <cfset modo="ALTA">
  </cfif>  
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.tramites.dsn#">
		select id_tipotramite, codigo_tipotramite, nombre_tipotramite, ts_rversion 
		from TPTipoTramite
		where id_tipotramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipotramite#">
	</cfquery>
</cfif>

<cfquery name="rsCodigos" datasource="#session.tramites.dsn#">
	select codigo_tipotramite 
	from TPTipoTramite
	<cfif modo neq 'ALTA'>
		where id_tipotramite <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipotramite#">
	</cfif>
</cfquery>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
	
	function deshabilitarValidacion(){
		objForm.codigo_tipotramite.required = false;
		objForm.nombre_tipotramite.required = false;
	}
	
</script>

<form method="post" name="form1" action="tipo_tramite-sql.cfm" >
	<table width="100%" align="center" border="0" cellpadding="2" cellspacing="0">
		<tr><td class="tituloMantenimiento" colspan="2"><font size="1"><cfif modo neq 'ALTA'>Modificar<cfelse>Agregar</cfif> Tipo de Tr&aacute;mite</font></td></tr>
		<tr valign="baseline">
			<td width="30%" align="right" nowrap>C&oacute;digo:&nbsp;</td>
			<td ><input type="text" name="codigo_tipotramite" style="text-transform:uppercase;"  value="<cfif modo NEQ 'ALTA'><cfoutput>#trim(rsForm.codigo_tipotramite)#</cfoutput></cfif>" size="10" maxlength="10" onFocus="this.select();"></td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Descripci&oacute;n:&nbsp;</td>
			<td><input type="text" name="nombre_tipotramite" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.nombre_tipotramite#</cfoutput></cfif>" size="60" maxlength="100" onFocus="this.select();"  ></td>
		</tr>
		<tr><td colspan="2" align="center">
			<cfif modo neq 'ALTA'>
				<input type="submit" name="Modificar" value="Modificar" >
				<input type="submit" name="Eliminar" value="Eliminar" onClick="javascript: if ( confirm('Desea eliminar el registro?') ){  deshabilitarValidacion(); return true;} return false;">
				<input type="button" name="Nuevo" value="Nuevo" onClick="javascript:location.href='tipo_tramites.cfm';">
			<cfelse>
				<input type="submit" name="Agregar" value="Agregar" >
			</cfif>
		</td></tr>
	</table>

	<cfset ts = "">
	<cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts"></cfinvoke>
		<input type="hidden" name="id_tipotramite" value="<cfoutput>#rsForm.id_tipotramite#</cfoutput>">
	</cfif>
	<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
	
</form>

<script language="JavaScript">
	function __CodeExists(){
		<cfoutput query="rsCodigos">
			var valor = "#Trim(rsCodigos.codigo_tipotramite)#".toUpperCase( );
			if ( valor == trim(this.value.toUpperCase( ))
			<cfif modo neq "ALTA">
				&& "#Trim(rsForm.codigo_tipotramite)#".toUpperCase( ) != trim(this.value.toUpperCase( ))
			</cfif>
			) {
				this.error = "El código que intenta insertar ya existe";
			}
		</cfoutput>
	}
	_addValidator("isCodeExists", __CodeExists);

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.codigo_tipotramite.required = true;
	objForm.codigo_tipotramite.validateCodeExists();
	objForm.codigo_tipotramite.validate = true;
	objForm.codigo_tipotramite.description="Código de Trámite";
	objForm.nombre_tipotramite.required = true;
	objForm.nombre_tipotramite.description="Descripción";
</script>