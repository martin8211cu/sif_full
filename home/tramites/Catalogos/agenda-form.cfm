<cfset modo = 'ALTA'>
<cfif isdefined("form.id_agenda") and len(trim(form.id_agenda))>
	<cfset modo = 'CAMBIO' >
	
	<cfquery name="data" datasource="#session.tramites.dsn#">
		select id_inst, id_agenda, codigo_agenda, nombre_agenda, ubicacion, ts_rversion
		from TPAgenda
		where id_agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_agenda#">
	</cfquery>
</cfif>

<cfquery name="rsCodigos" datasource="#session.tramites.dsn#">
	select codigo_agenda
	from TPAgenda
	<cfif modo neq 'ALTA'>
		where id_agenda <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_agenda#">
	</cfif>
</cfquery>

<cfoutput>
<form name="form1" method="post" action="agenda-sql.cfm" onSubmit="return validar(this);">
	<input type="hidden" name="id_inst" value="#form.id_inst#">
	<input type="hidden" name="id_tiposerv" value="#form.id_tiposerv#">
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="id_agenda" value="#data.id_agenda#">
	</cfif>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr><td colspan="2" class="tituloMantenimiento"><font size="1"><cfif modo neq 'ALTA'>Modificar<cfelse>Agregar</cfif> Agenda</font></td></tr>
		<tr>
			<td align="right">C&oacute;digo:&nbsp;</td>
			<td><input type="text" size="10" maxlength="10" onBlur="javascript: return !codigo_existe();" style="text-transform:uppercase;" name="codigo_agenda" value="<cfif modo neq 'ALTA'>#trim(data.codigo_agenda)#</cfif>"></td>
		</tr> 
		<tr>
			<td align="right">Nombre:&nbsp;</td>
			<td><input type="text" size="30" maxlength="30" name="nombre_agenda" value="<cfif modo neq 'ALTA'>#trim(data.nombre_agenda)#</cfif>"></td>
		</tr>
		<tr>
			<td align="right">Ubicaci&oacute;n:&nbsp;</td>
			<td><input type="text" size="30" maxlength="30" name="ubicacion" value="<cfif modo neq 'ALTA'>#trim(data.ubicacion)#</cfif>"></td>
		</tr>

		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'>
					<input type="submit" name="Modificar" value="Modificar" >
					<input type="submit" name="Eliminar" value="Eliminar" onClick=" return confirm('Desea eliminar el registro?');" >
					<input type="button" name="Nuevo" value="Nuevo" onClick="javascript: location.href='agenda.cfm?id_inst=#form.id_inst#&id_tiposerv=#form.id_tiposerv#'" >
				<cfelse>
					<input type="submit" name="Agregar" value="Agregar" >
				</cfif>
				<!---<input type="button" name="Regresar" value="Regresar" onClick="javascript: location.href='/cfmx/home/tramites/Catalogos/Tp_Institucion.cfm?id_inst=#form.id_inst#'" >--->
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
	<cfinclude template="horario.cfm">
</cfif>

<script type="text/javascript" language="javascript1.2">
	function validar(f){
		var msj = '';
		
		if ( f.codigo_agenda.value == '' ){
			msj = msj + ' - El campo Código es requerido.\n';
		}

		if ( f.nombre_agenda.value == '' ){
			msj = msj + ' - El campo Nombre es requerido.\n';
		}

		if ( f.ubicacion.value == '' ){
			msj = msj + ' - El campo Ubicación es requerido.\n';
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

	function codigo_existe(){
		<cfoutput query="rsCodigos">
			var valor = "#Trim(rsCodigos.codigo_agenda)#".toUpperCase( );
			if ( valor == trim(document.form1.codigo_agenda.value.toUpperCase( ))){
				alert("El código que intenta insertar ya existe");
				document.form1.codigo_agenda.value = '';
				document.form1.codigo_agenda.focus();
				return true;
			}
		</cfoutput>
		
		return false;
	}

</script>