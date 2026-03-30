
<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.tramites.dsn#">
		select id_tramite, codigo_tramite,descripcion_tramite,nombre_tramite, id_tipotramite, id_inst, ts_rversion, id_documento_generado 
		from TPTramite
		where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
	</cfquery>
</cfif>

<cfquery name="rsCodigos" datasource="#session.tramites.dsn#">
	select codigo_tramite 
	from TPTramite
	<cfif modo neq 'ALTA'>
		where id_tramite <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
	</cfif>
</cfquery>

<cfquery name="tipoiden" datasource="#session.tramites.dsn#">
	select a.id_tipoident, a.codigo_tipoident,a.nombre_tipoident,
		case when b.id_tipoident is null then 0 else 1 end as existe
	from TPTipoIdent a
	
	
	left outer join TPTipoIdentTramite b
	on a.id_tipoident =  b.id_tipoident
	<cfif modo NEQ "ALTA">
		and  b.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tramite#">
	<cfelse>
		and  b.id_tramite = -1
	</cfif>
	
	order by a.codigo_tipoident
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
		objForm.codigo_tramite.required = false;
		objForm.nombre_tramite.required = false;
		objForm.id_documento.required = false;

	}
	
</script>
<cfoutput>
<form method="post" name="form1" action="tramites-sql.cfm" >
<table width="100%" cellpadding="0" cellspacing="0"  border="0">
	<tr>
		<td width="45%" valign="top">
			<table width="100%" align="center" border="0" cellpadding="2" cellspacing="0">
				<tr><td bgcolor="##ECE9D8" style="padding:3px;" colspan="2"><font size="1"><cfif modo neq 'ALTA'>Modificar<cfelse>Agregar</cfif>&nbsp;Tr&aacute;mite</font></td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr valign="baseline">
					<td width="15%" align="right" nowrap>C&oacute;digo:&nbsp;</td>
					<td ><input type="text" name="codigo_tramite" style="text-transform:uppercase;" value="<cfif modo NEQ 'ALTA'><cfoutput>#trim(rsForm.codigo_tramite)#</cfoutput></cfif>" size="15" maxlength="15" onFocus="this.select();"></td>
				</tr>
				<tr valign="baseline">
					<td nowrap align="right">Nombre:&nbsp;</td>
					<td><input type="text" name="nombre_tramite" 
						value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.nombre_tramite#</cfoutput></cfif>" 
						size="60" maxlength="100" onFocus="this.select();"  ></td>
				</tr>
				<cfquery name="tipos" datasource="#session.tramites.dsn#">
					select id_tipotramite, codigo_tipotramite, nombre_tipotramite 
					from TPTipoTramite
					order by 2, 3
				</cfquery>
				<tr valign="baseline">
					<td nowrap align="right">Tipo:&nbsp;</td>
					<td>
						<select name="id_tipotramite">
							<option value="">- seleccionar -</option>
							<cfloop query="tipos">
								<option value="#tipos.id_tipotramite#" <cfif modo neq 'ALTA' and rsForm.id_tipotramite eq tipos.id_tipotramite>selected</cfif> >#trim(tipos.codigo_tipotramite)# - #trim(tipos.nombre_tipotramite)#</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<cfquery name="inst" datasource="#session.tramites.dsn#">
					select id_inst, codigo_inst, nombre_inst 
					from TPInstitucion
					order by 2, 3
				</cfquery>
				<tr valign="baseline">
					<td nowrap align="right">Instituci&oacute;n:&nbsp;</td>
					<td>
						<select name="id_inst">
							<option value="">- seleccionar -</option>
							<cfloop query="inst">
								<option value="#inst.id_inst#" <cfif modo neq 'ALTA' and rsForm.id_inst eq inst.id_inst>selected</cfif> >#trim(inst.codigo_inst)# - #trim(inst.nombre_inst)#</option>
							</cfloop>
						</select>
					</td>
				</tr>


				<tr valign="baseline">
					<td nowrap align="right">&nbsp;</td>
					<td  nowrap align="left">Documento que se entrega cuando se realiza el tr&aacute;mite</td>
				</tr>	
				<tr valign="baseline">
					<td nowrap align="right">&nbsp;</td>
					<td>
						<table>
							<tr>
							<td>
						<cfset values = "">
						<cfif modo NEQ 'ALTA' and LEN(TRIM(rsForm.id_documento_generado))>
							<cfquery name="rsDoc" datasource="#session.tramites.dsn#">
								select *
								from TPDocumento
								where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.id_documento_generado#">
							</cfquery>
							<cfset values = "#rsForm.id_documento_generado#,#rsDoc.codigo_documento#,#rsDoc.nombre_documento#">
						</cfif>

						<cf_conlis title="Lista de Documentos"
							campos = "id_documento,codigo_documento, nombre_documento" 
							desplegables = "N,S,S" 
							size = "0,10,50"
							values="#values#"
							tabla="TPDocumento"
							columnas="id_documento,codigo_documento, nombre_documento"
							filtro=""
							desplegar="codigo_documento, nombre_documento"
							etiquetas="C&oacute;digo, Nombre"
							formatos="S,S"
							align="left,left"
							conexion="#session.tramites.dsn#"
							form = "form1">
							</td>
							<td>
							 <img src="../images/Borrar01_S.gif" onClick="javascript:limpiar();" style="cursor:pointer;" alt="Limpiar Documento Generado" >
							</td>
							</tr>

							</table> 
					</td>
				</tr>

			</table>	
		</td>
		<td width="55%" valign="top">
			<table align="center" width="100%" cellpadding="0" cellspacing="0">
				<tr><td bgcolor="##ECE9D8" style="padding:3px;" colspan="2"><font size="1">Este trámite se puede realizar para los siguientes tipos de identificación</font></td></tr>
				<tr><td>&nbsp;</td></tr>				
				<tr>
					<td style="padding:0;"></td>
					<td style="padding:0;">
						<table width="100%" cellpadding="0" cellspacing="0">
						<cfset ubica = 0>
						<cfloop query="tipoiden">
							<cfif ubica EQ 0>	
								<tr>
								<td nowrap><input  type="checkbox"  <cfif tipoiden.existe eq 1>checked</cfif> value="#tipoiden.id_tipoident#" name="tipoiden" id="#tipoiden.id_tipoident#"></td>					
								<td align="left" nowrap><label for="#tipoiden.id_tipoident#">#tipoiden.nombre_tipoident#&nbsp;</label></td>
								<cfset ubica = 1>
							<cfelse>
								<td nowrap><input  type="checkbox"  <cfif tipoiden.existe eq 1>checked</cfif>  value="#tipoiden.id_tipoident#" name="tipoiden" id="#tipoiden.id_tipoident#"></td>					
								<td align="left" nowrap><label for="#tipoiden.id_tipoident#">#tipoiden.nombre_tipoident#&nbsp;</label></td>
								</tr>
								<cfset ubica = 0>
							</cfif>
						</cfloop>
						<cfif ubica EQ 1>
							</tr>
						</cfif>
						</table>
					</td>
				</tr>
			</table>
		</td>	
	</tr>	
	<tr><td colspan="2" align="center">&nbsp;</td></tr>
	<tr><td colspan="2" align="center">
		<cfif modo neq 'ALTA'>
			<input type="submit" name="Modificar" value="Modificar" >
			<input type="submit" name="Eliminar" value="Eliminar" onClick="javascript: if ( confirm('Desea eliminar el registro?') ){  deshabilitarValidacion(); return true;} return false;">
			<input type="button" name="Nuevo" value="Nuevo" onClick="javascript:location.href='tramites.cfm?tab=1';">
		<cfelse>
			<input type="submit" name="Agregar" value="Agregar" >
		</cfif>
		<input type="button" name="Lista" value="Ir a lista" onClick="javascript:location.href='tramitesList.cfm';">

	</td></tr>
</table>
</cfoutput>

	<cfset ts = "">
	<cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts"></cfinvoke>
		<input type="hidden" name="id_tramite" value="<cfoutput>#rsForm.id_tramite#</cfoutput>">
	</cfif>
	<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
</form>
<script language="JavaScript">
	function limpiar(){
		document.form1.id_documento.value = '';
		document.form1.codigo_documento.value = '';
		document.form1.nombre_documento.value = '';
	}


	function __CodeExists(){
		<cfoutput query="rsCodigos">
			var valor = "#Trim(rsCodigos.codigo_tramite)#".toUpperCase( );
			if ( valor == trim(this.value.toUpperCase( ))
			<cfif modo neq "ALTA">
				&& "#Trim(rsForm.codigo_tramite)#".toUpperCase( ) != trim(this.value.toUpperCase( ))
			</cfif>
			) {
				this.error = "El código que intenta insertar ya existe";
			}
		</cfoutput>
	}
	_addValidator("isCodeExists", __CodeExists);

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.codigo_tramite.required = true;
	objForm.codigo_tramite.validateCodeExists();
	objForm.codigo_tramite.validate = true;
	objForm.codigo_tramite.description="Código de Trámite";
	objForm.nombre_tramite.required = true;
	objForm.nombre_tramite.description="Descripción";
	objForm.id_tipotramite.required = true;
	objForm.id_tipotramite.description="Tipo de Trámite";
	objForm.id_inst.required = true;
	<!---
	objForm.id_inst.description="Institución";
	objForm.id_documento.required = true;
	objForm.id_documento.description="Documento que se entrega";
	--->
	
</script>