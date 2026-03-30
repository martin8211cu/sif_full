<cfset vmodo="ALTA">
<cfif isdefined("form.id_ventanilla") and len(trim(form.id_ventanilla))>
	<cfset vmodo = 'CAMBIO'>
</cfif>

<cfif isdefined("url.id_sucursal") and Len("url.id_sucursal") gt 0 >
	<cfset form.id_sucursal = url.id_sucursal >
</cfif>

<cfif isdefined("url.id_ventanilla") and Len("url.id_ventanilla") gt 0 >
	<cfset form.id_ventanilla = url.id_ventanilla >
</cfif>


<cfif isdefined("Form.id_sucursal") AND Len(Trim(Form.id_sucursal)) GT 0 and isdefined("Form.id_ventanilla") AND Len(Trim(Form.id_ventanilla)) GT 0 >
	<cfset vmodo="CAMBIO">
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		SELECT *
		FROM TPVentanilla 
		WHERE id_sucursal    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_sucursal#">
		and   id_ventanilla  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_ventanilla#">
	</cfquery>
</cfif>

<cfoutput>
<form method="post" name="vform" action="sucursal-ventanilla-sql.cfm">
	<table align="center" width="100%" cellpadding="2" cellspacing="0">
		<tr><td class="tituloMantenimiento" colspan="2"><font size="1">Ventanillas</font></td></tr>
		<tr valign="baseline"> 
			<td nowrap align="left">C&oacute;digo:</td>
			<td>
				<input type="text" name="codigo_ventanilla" 
				value="<cfif vmodo NEQ "ALTA">#rsDatos.codigo_ventanilla#</cfif>" 
				size="10" maxlength="10" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="left">Ventanilla:</td>
			<td>
				<input type="text" name="nombre_ventanilla" 
				value="<cfif vmodo NEQ "ALTA">#rsDatos.nombre_ventanilla#</cfif>" 
				size="30" maxlength="30" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td colspan="2" align="center" nowrap>
				<input type="hidden" name="botonSel" value="">
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
				<cfif vmodo neq 'ALTA'>
					<input type="submit" name="Cambio" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; ">
					<input type="submit" name="Baja" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Está seguro(a) de que desea eliminar el registro?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
					<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
				<cfelse>
					<input type="submit" name="Alta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline"> 
			<cfset ts = "">
			<cfif vmodo NEQ "ALTA">
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDatos.ts_rversion#" returnvariable="ts">
				</cfinvoke>
			</cfif>
			<input type="hidden" name="ts_rversion" value="<cfif vmodo NEQ "ALTA">#ts#</cfif>">
			<input type="hidden" name="id_ventanilla" value="<cfif vmodo NEQ "ALTA">#rsDatos.id_ventanilla#</cfif>">
			<input type="hidden" name="id_inst" value="#Form.id_inst#">
			<input type="hidden" name="id_sucursal" value="#Form.id_sucursal#">
		</tr>
	</table>
</form>
</cfoutput>
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	vobjForm = new qForm("vform");
	
	vobjForm.codigo_ventanilla.required = true;
	vobjForm.codigo_ventanilla.description="Código";				
	vobjForm.nombre_ventanilla.required = true;
	vobjForm.nombre_ventanilla.description="Descripción";		

	function deshabilitarValidacion(){
		vobjForm.codigo_ventanilla.required = false;
		vobjForm.nombre_ventanilla.required = false;
	}
</SCRIPT>

