<cfset modo = 'ALTA'>
<cfif isdefined("form.id_grupo") and len(trim(form.id_grupo))>
	<cfset modo = 'CAMBIO' >
	
	<cfquery name="data" datasource="#session.tramites.dsn#">
		select id_inst, id_grupo, codigo_grupo, nombre_grupo, ts_rversion
		from TPGrupo
		where id_grupo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_grupo#">
	</cfquery>
</cfif>

<cfquery name="rsCodigos" datasource="#session.tramites.dsn#">
	select codigo_grupo
	from TPGrupo
	where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
	<cfif modo neq 'ALTA'>
		and id_grupo <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_grupo#">
	</cfif>
</cfquery>

<cfoutput>
<form name="formg" method="post" action="grupo-sql.cfm" onSubmit="return validargrupo(this);">
	<input type="hidden" name="id_inst" value="#form.id_inst#">
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="id_grupo" value="#data.id_grupo#">
	</cfif>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr><td colspan="2" class="tituloMantenimiento"><font size="1">Funciones</font></td></tr>
		<tr>
			<td align="right">C&oacute;digo:&nbsp;</td>
			<td><input type="text" size="10" maxlength="10" onBlur="javascript: return !grupocodigo_existe();" style="text-transform:uppercase;" name="codigo_grupo" value="<cfif modo neq 'ALTA'>#trim(data.codigo_grupo)#</cfif>"></td>
		</tr> 
		<tr>
			<td align="right">Nombre:&nbsp;</td>
			<td><input type="text" size="60" maxlength="100" name="nombre_grupo" value="<cfif modo neq 'ALTA'>#trim(data.nombre_grupo)#</cfif>"></td>
		</tr>

		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'>
					<input type="submit" name="Modificar" value="Modificar" >
					<input type="submit" name="Eliminar" value="Eliminar" onClick=" return confirm('Desea eliminar el registro?');" >
					<input type="button" name="Nuevo" value="Nuevo" onClick="javascript: location.href='instituciones.cfm?id_inst=#form.id_inst#&tab=3'" >
				<cfelse>
					<input type="submit" name="Agregar" value="Agregar" >
				</cfif>
			</td>
		</tr>
	</table>

	<cfset ts = "">
	<cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#data.ts_rversion#" returnvariable="ts"></cfinvoke>
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
	</cfif>
</form>
</cfoutput>

<cfif modo neq 'ALTA'>
	<cfinclude template="funcionarios-grupo.cfm"> 
</cfif>

<script type="text/javascript" language="javascript1.2">
	function validargrupo(f){
		var msj = '';
		
		if ( f.codigo_grupo.value == '' ){
			msj = msj + ' - El campo Código es requerido.\n';
		}

		if ( f.nombre_grupo.value == '' ){
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

	function grupocodigo_existe(){
		<cfoutput query="rsCodigos">
			var valor = "#Trim(rsCodigos.codigo_grupo)#".toUpperCase( );
			if ( valor == trim(document.formg.codigo_grupo.value.toUpperCase( ))){
				alert("El código que intenta insertar ya existe");
				document.formg.codigo_grupo.value = '';
				document.formg.codigo_grupo.focus();
				return true;
			}
		</cfoutput>
		
		return false;
	}
</script>