<cfset modo = 'ALTA'>
<cfif isdefined("form.fecha") and len(trim(form.fecha))>
	<cfset modo = 'CAMBIO'>
	
	<cfquery name="data" datasource="#session.tramites.dsn#">
		select fecha, descripcion
		from TPFeriados
		where fecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fecha#">
	</cfquery>
</cfif>

<cfoutput>
<form method="post" action="feriados-sql.cfm" name="form1" onSubmit="return validar();">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td align="right">Fecha:&nbsp;</td>
			<td>
				<cfif modo neq 'ALTA'>
					#LSDateFormat(data.fecha,'dd/mm/yyyy')#	
					<input type="hidden" name="fecha" value="#data.fecha#">
				<cfelse>
					<cf_sifcalendario>
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right">Descripci&oacute;n:&nbsp;</td>
			<td><input type="text" size="30" maxlength="30" name="descripcion" value="<cfif modo neq 'ALTA'>#data.descripcion#</cfif>"></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo eq 'ALTA'>
					<input type="submit" name="Agregar" value="Agregar">
				<cfelse>
					<input type="submit" name="Modificar" value="Modificar">
					<input type="submit" name="Eliminar" value="Eliminar" onClick="return confirm('Desea eliminar el registro?');">
					<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: location.href='/cfmx/home/tramites/Catalogos/feriados.cfm';">
				</cfif>
			</td>
		</tr>
	</table>
</form>
</cfoutput>

<script language="javascript1.2" type="text/javascript">
	function validar(){
		var msj = '';
		
		if ( document.form1.fecha.value == '' ){
			msj += ' - El campo Fecha es requerido.\n';
		}
		
		if ( document.form1.descripcion.value == '' ){
			msj += ' - El campo Descripción es requerido.\n';
		}
		
		if ( msj != '' ){
			alert('Se presentaron los siguientes errores:\n' + msj)
			return false;
		}
		return true;
	}
</script>