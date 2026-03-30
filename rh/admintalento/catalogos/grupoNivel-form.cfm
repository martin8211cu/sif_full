<cfset modo = 'ALTA'>

<cfif isdefined("form.RHGNid") and len(trim(form.RHGNid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo neq 'ALTA' >
	<cfquery name="rs_data" datasource="#session.DSN#">
		select a.RHGNid, a.RHGNcodigo, a.RHGNdescripcion, a.ts_rversion
		from RHGrupoNivel a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.RHGNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGNid#">
	</cfquery>
</cfif>

<cfoutput>
<form name="form1" method="post" action="grupoNivel-sql.cfm" style="margin:0;">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td>#LB_codigo#:</td>
		<td><input type="text" tabindex="1" name="RHGNcodigo" value="<cfif modo neq 'ALTA'>#trim(rs_data.RHGNcodigo)#</cfif>" size="12" maxlength="10" onclick="javascript: this.select();" /></td>
	</tr>
	<tr>
		<td>#LB_descripcion#:</td>
		<td><input type="text" tabindex="2" name="RHGNdescripcion" value="<cfif modo neq 'ALTA'>#trim(rs_data.RHGNdescripcion)#</cfif>" size="50" maxlength="60" onclick="javascript: this.select();" /></td>
	</tr>
	
	<tr><td colspan="2"><cf_botones modo="#modo#" tabindex="3"></td></tr>

	<cfif modo neq 'ALTA'>
		<input type="hidden" name="RHGNid" value="#rs_data.RHGNid#" />
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rs_data.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>

</table>
</cfoutput>
</form>


<cfif modo neq 'ALTA'>
	<br />
	<cfinclude template="grupoNivelDetalle-form.cfm">
	<br />	
</cfif>

<cf_qforms>

<cfoutput>
<script>
	objForm.RHGNcodigo.required = true;
	objForm.RHGNcodigo.description = '#LB_codigo#';
	objForm.RHGNdescripcion.required = true;
	objForm.RHGNdescripcion.description = '#LB_descripcion#';
	
	function habilitarValidacion(){
		objForm.RHGNcodigo.required = true;
		objForm.RHGNdescripcion.required = true;
	}
	
	function deshabilitarValidacion(){
		objForm.RHGNcodigo.required = false;
		objForm.RHGNdescripcion.required = false;
	}
	
</script>
</cfoutput>