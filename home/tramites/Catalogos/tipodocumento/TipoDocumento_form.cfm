<!--- 
	Creado por Gustavo Fonseca Hernández
		Fecha: 12-8-2005.
		Motivo: Nuevo mantenimiento de la tabla: TPTipoDocumento.
 --->

<cfif isdefined("url.id_tipodoc") and len(trim(url.id_tipodoc)) and  not isdefined("form.id_tipodoc")>
	<cfset form.id_tipodoc = url.id_tipodoc>
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined("form.id_tipodoc") and len(trim(form.id_tipodoc))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif isdefined("form.id_tipodoc")	 and len(trim(form.id_tipodoc))>
	<cfquery name="data" datasource="#session.tramites.dsn#">
		select 
			id_tipodoc, 
			codigo_tipodoc as codigo, 
			nombre_tipodoc as nombre,
			ts_rversion
		from TPTipoDocumento
		where id_tipodoc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipodoc#">
		order by codigo_tipodoc 
	</cfquery>
</cfif>
<!---<cfdump var="#form#">
<cfdump var="#url#">
 <cfdump var="#data#">
<cfdump var="#modo#"> --->

<script language="javascript" type="text/javascript">
	function funcBaja()
	{
		return confirm('Desea eliminar el registro?');
	}

</script>



<cfoutput>
<form method="post" action="TipoDocumento_sql.cfm" name="form1" onSubmit="return validar();">
	<input type="hidden" name="id_tipodoc" value="<cfif isdefined("form.id_tipodoc") and len(trim(form.id_tipodoc))>#data.id_tipodoc#</cfif>">
	<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td class="tituloMantenimiento" colspan="2"><font size="1">Tipo de Documento</font></td>
	</tr>
		<tr>
			<td align="right"><strong>C&oacute;digo:&nbsp;</strong></td>
			<td>
				<input type="text" name="codigo_tipodoc" size="10" maxlength="10" value="<cfif modo neq 'ALTA'>#data.codigo#</cfif>">
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Nombre:&nbsp;</strong></td>
			<td><input type="text" size="60" maxlength="100" name="nombre_tipodoc" value="<cfif modo neq 'ALTA'>#data.nombre#</cfif>"></td>
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
		
		if ( document.form1.codigo_tipodoc.value == '' ){
			msj += ' - El campo Código es requerido.\n';
		}
		
		if ( document.form1.nombre_tipodoc.value == '' ){
			msj += ' - El campo Nombre es requerido.\n';
		}
		
		if ( msj != '' ){
			alert('Se presentaron los siguientes errores:\n' + msj)
			return false;
		}
		return true;
	}
</script>