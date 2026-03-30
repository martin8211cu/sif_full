<cfset modo = 'ALTA'>
<cfif isdefined("url.id_tiposerv") and Len("url.id_tiposerv") gt 0 >
	<cfset form.id_tiposerv = url.id_tiposerv >
</cfif>
<cfif isdefined("url.id_tiposerv") and len(trim(id_tiposerv))>
	<cfset modo = 'CAMBIO' >
	
	<cfquery name="data" datasource="#session.tramites.dsn#">
		select id_inst, id_tiposerv, codigo_tiposerv, nombre_tiposerv, descripcion_tiposerv, ts_rversion, id_tiposervg 
		from TPTipoServicio
		where id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tiposerv#">
	</cfquery>
</cfif>

<cfquery name="rsCodigos" datasource="#session.tramites.dsn#">
	select codigo_tiposerv
	from TPTipoServicio
	<cfif modo neq 'ALTA'>
		where id_tiposerv <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiposerv#">
	</cfif>
</cfquery>

<cfoutput>
<form name="formts" method="get" action="tipo_servicio-sql.cfm" onSubmit="return validarservicio(this);">
	<input type="hidden" name="id_inst" value="#url.id_inst#">
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="id_tiposerv" value="#data.id_tiposerv#">
	</cfif>
	<table width="100%" cellpadding="2" cellspacing="0">
		<cfquery name="tipo" datasource="#session.tramites.dsn#">
			select id_tiposervg, codigo_tiposervg, nombre_tiposervg
			from TPTipoServGlobal
			order by 2
		</cfquery>

		<tr>
			<td align="right">Tipo:&nbsp;</td>
			<td>
				<select name="id_tiposervg">
					<option value="" >-seleccionar-</option>
					<cfloop query="tipo">
						<option value="#tipo.id_tiposervg#" <cfif modo neq 'ALTA' and tipo.id_tiposervg eq data.id_tiposervg>selected</cfif> >#trim(tipo.codigo_tiposervg)#-#trim(tipo.nombre_tiposervg)#</option>
					</cfloop>
				</select>
			</td>
		</tr>

		<tr>
			<td align="right">C&oacute;digo:&nbsp;</td>
			<td><input type="text" size="10" maxlength="10" onBlur="javascript: return !serviciocodigo_existe();" style="text-transform:uppercase;" name="codigo_tiposerv" value="<cfif modo neq 'ALTA'>#trim(data.codigo_tiposerv)#</cfif>"></td>
		</tr> 
		<tr>
			<td align="right">Nombre:&nbsp;</td>
			<td><input type="text" size="60" maxlength="100" name="nombre_tiposerv" value="<cfif modo neq 'ALTA'>#trim(data.nombre_tiposerv)#</cfif>"></td>
		</tr>
		<tr>
			<td align="right" valign="top">Descripci&oacute;n:&nbsp;</td>
			<td><textarea name="descripcion_tiposerv" rows="4" cols="45"><cfif modo neq 'ALTA' >#trim(data.descripcion_tiposerv)#</cfif></textarea></td>
		</tr>

		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'>
					<input type="submit" name="Modificar" value="Modificar" >
					<input type="submit" name="Eliminar" value="Eliminar" onClick=" return confirm('Desea eliminar el registro?');" >
					<input type="button" name="Nuevo" value="Nuevo" onClick="javascript: location.href='instituciones.cfm?id_inst=#url.id_inst#&tab=5'" >
				<cfelse>
					<input type="submit" name="Agregar" value="Agregar" >
				</cfif>
			</td>
		</tr>
	</table>
</form>
</cfoutput>

<script type="text/javascript" language="javascript1.2">
	function validarservicio(f){
		var msj = '';
		
		if ( f.codigo_tiposerv.value == '' ){
			msj = msj + ' - El campo Código es requerido.\n';
		}

		if ( f.nombre_tiposerv.value == '' ){
			msj = msj + ' - El campo Nombre es requerido.\n';
		}

		if ( msj != ''){
			msj = 'Se presentaron los siguientes errores:\n' + msj
			alert(msj);
			return false;
		}
		return true;
	}
	
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function serviciocodigo_existe(){
		<cfoutput query="rsCodigos">
			var valor = "#Trim(rsCodigos.codigo_tiposerv)#".toUpperCase( );
			if ( valor == trim(document.formts.codigo_tiposerv.value.toUpperCase( ))){
				alert("El código que intenta insertar ya existe");
				document.formts.codigo_tiposerv.value = '';
				document.formts.codigo_tiposerv.focus();
				return true;
			}
		</cfoutput>
		
		return false;
	}

</script>