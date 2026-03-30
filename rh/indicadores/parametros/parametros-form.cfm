<cfset modo = 'ALTA'>
<cfif isdefined("form.RHIcodigo") and len(trim(form.RHIcodigo))>
	<cfset modo = 'CAMBIO'>

	<cfquery name="rs_data" datasource="#session.DSN#">
		select RHIcodigo, RHIvalor, RHIdescripcion
		from RHIndicadores
		where RHIcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHIcodigo#">
	</cfquery>

<cfelse>
	<cfquery name="rs_codigo" datasource="#session.DSN#">
		select coalesce(max(RHIcodigo), 0)+5 as RHIcodigo
		from RHIndicadores
	</cfquery>
</cfif>

<cfoutput>
<form name="form1" method="post" action="parametros-sql.cfm" style="margin:0;">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td><strong>#LB_CODIGO#:&nbsp;</strong></td>
			<td><cfif modo eq 'ALTA'>#rs_codigo.RHIcodigo#<cfelse>#rs_data.RHIcodigo#</cfif><input type="hidden" name="RHIcodigo" value="<cfif modo neq 'ALTA' >#rs_data.RHIcodigo#<cfelse>#rs_codigo.RHIcodigo#</cfif>"></td>
		</tr>
		<tr>
			<td><strong>#LB_VALOR#:&nbsp;</strong></td>
			<td><input type="text" name="RHIvalor" value="<cfif modo neq 'ALTA' >#rs_data.RHIvalor#</cfif>" size="10" maxlength="50" onfocus="javascript:this.select();" ></td>
		</tr>
		<tr>
			<td><strong>#LB_DESCRIPCION#:&nbsp;</strong></td>
			<td><input type="text" name="RHIdescripcion" value="<cfif modo neq 'ALTA' >#rs_data.RHIdescripcion#</cfif>" size="30" maxlength="100" onfocus="javascript:this.select();" ></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><cf_botones modo="#modo#"></td>
		</tr>
	
	</table>
</form>
</cfoutput>

<br />
<cfif modo neq 'ALTA'>
	<table width="97%" align="center" cellpadding="4" cellspacing="0" style="border: 1px solid gray;" >
		<tr><td style="padding:3px;" bgcolor="#CCCCCC"><strong>Acciones y/o Conceptos asociados al Indicador</strong></td></tr>
		<tr>
			<td>
				<cfinclude template="parametros-detalle-form.cfm">
			</td>
		</tr>
	</table>
</cfif>

<cf_qforms>
<script type="text/javascript" language="javascript1.2">
	<cfoutput>
		objForm.RHIvalor.required = true;
		objForm.RHIvalor.description = "#LB_VALOR#";
		objForm.RHIdescripcion.required = true;
		objForm.RHIvalor.description = "#LB_DESCRIPCION#";
	</cfoutput>
</script>