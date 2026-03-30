<cfset modo = "ALTA">
<cfif isdefined("form.RHGMid") and len(trim(form.RHGMid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select RHGMid, RHGMcodigo, Descripcion, ts_rversion
		from RHGrupoMaterias
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMid#">
	</cfquery>
</cfif>

<cfoutput>
<form name="formEducacion" action="educacion-sql.cfm" method="post">
	<input type="hidden" name="DEid" value="#form.DEid#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td align="right"><strong>C&oacute;digo:&nbsp;</strong></td>
			<td><input type="text" name="RHGMcodigo" size="10" maxlength="15" value="<cfif modo neq 'ALTA'>#trim(data.RHGMcodigo)#</cfif>" onfocus="this.select();" ></td><!----<cfif modo neq 'ALTA'>readonly</cfif>---->
		</tr>
		<tr>
			<td align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td><input type="text" name="Descripcion" size="60" maxlength="80" value="<cfif modo neq 'ALTA'>#trim(data.Descripcion)#</cfif>" onfocus="this.select();"></td>
		</tr>
		
		<!--- Botones --->
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" align="center">
		<cfif modo eq 'ALTA'>
			<input type="submit" name="Alta" value="Agregar" onClick="javascript: habilitarValidacion();">
			<input type="reset" name="Limpiar" value="Limpiar">
		<cfelse>
			<input type="submit" name="Cambio" value="Modificar" onClick="habilitarValidacion();">
			<input type="submit" name="Baja" value="Eliminar" onClick="if ( confirm('Desea eliminar el registro?') ){deshabilitarValidacion(); return true;} return false;">
			<input type="submit" name="Nuevo" value="Nuevo" onClick="deshabilitarValidacion();">
		</cfif>
		</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>

	</table>

	<cfif modo neq 'ALTA'>
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="RHGMid" value="#trim(data.RHGMid)#">
	</cfif>
</form>
</cfoutput>

<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.RHGMcodigo.required = true;
	objForm.RHGMcodigo.description="Código";				
	objForm.Descripcion.required= true;
	objForm.Descripcion.description="Descripción";	

	<cfoutput>
		objForm.RHGMcodigo.description="#JSStringFormat('Código')#";
		objForm.Descripcion.description="#JSStringFormat('Descripción')#";
	</cfoutput>
	
	function habilitarValidacion(){
		objForm.RHGMcodigo.required = true;
		objForm.Descripcion.required = true;
	}

	function deshabilitarValidacion(){
		objForm.RHGMcodigo.required = false;
		objForm.Descripcion.required = false;
	}
	
</script>
