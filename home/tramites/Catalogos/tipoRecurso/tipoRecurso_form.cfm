<cfif isdefined("url.id_tiporecurso") and len(trim(url.id_tiporecurso)) and  not isdefined("form.id_tiporecurso")>
	<cfset form.id_tiporecurso = url.id_tiporecurso>
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined("form.id_tiporecurso") and len(trim(form.id_tiporecurso))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif isdefined("form.id_tiporecurso")	 and len(trim(form.id_tiporecurso))>
	<cfquery name="data" datasource="#session.tramites.dsn#">
		Select id_tiporecurso
			, Codigo_Recurso as codigo
			, Nombre_Recurso as nombre
			, ts_rversion
		from TPTipoRecurso
		where id_tiporecurso=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiporecurso#">
	</cfquery>
</cfif>

<cfoutput>
<form method="post" action="tipoRecurso_sql.cfm" name="form1" onSubmit="return validar();">
	<input type="hidden" name="id_tiporecurso" value="<cfif isdefined("form.id_tiporecurso") and len(trim(form.id_tiporecurso))>#data.id_tiporecurso#</cfif>">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td align="right"><strong>C&oacute;digo:&nbsp;</strong></td>
			<td>
				<input type="text" name="Codigo_Recurso" size="10" maxlength="10" value="<cfif modo neq 'ALTA'>#trim(data.codigo)#</cfif>">
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Nombre:&nbsp;</strong></td>
			<td><input type="text" size="60" maxlength="100" name="Nombre_Recurso" value="<cfif modo neq 'ALTA'>#trim(data.nombre)#</cfif>"></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
			<cfif modo neq "ALTA">
				<cfset ts = "">
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#data.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#">
			</cfif>
				<cf_botones modo=#modo#>
			</td>
		</tr>
	</table>
</form>
</cfoutput>

<script language="javascript1.2" type="text/javascript">
	function validar(){
		var msj = '';
		
		if ( document.form1.Codigo_Recurso.value == '' ){
			msj += ' - El campo Código es requerido.\n';
		}
		
		if ( document.form1.Nombre_Recurso.value == '' ){
			msj += ' - El campo Nombre es requerido.\n';
		}
		
		if ( msj != '' ){
			alert('Se presentaron los siguientes errores:\n' + msj)
			return false;
		}
		return true;
	}
</script>