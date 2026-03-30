<cfif isdefined ('form.CPTAEid') AND form.CPTAEid NEQ "">
	<cfset modo='CAMBIO'>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 
			CPTAEid,
			Ecodigo, 
			CPTAEcodigo,
			CPTAEdescripcion,
			BMUsucodigo 
		from CPtipoAutExterna
		where Ecodigo=#session.Ecodigo# 
		and CPTAEid=#form.CPTAEid#
	</cfquery>
<cfelse>
	<cfset modo='ALTA'>
</cfif>

<form name="form1" action="tiposAutExt_sql.cfm" method="post" onSubmit="return validar(this);">
<cfif modo eq 'CAMBIO'>
	<cfoutput><input type="hidden" name="CPTAEid" value="#rsForm.CPTAEid#"></cfoutput>
</cfif>
<table width="50%" align="right">
<cfoutput>
	<tr>
		<td align="right">
			<strong>Codigo:</strong>
		</td>
		<td align="left">
			<cfif modo eq 'ALTA'>
				<input type="text" name="CPTAEcodigo" size="12" maxlength="10">
			<cfelse>
				<input type="text" name="CPTAEcodigo" size="12" maxlength="10" value="#rsForm.CPTAEcodigo#">
			</cfif>
		</td>
	</tr>
	<tr>
		<td align="right">
			<strong>Descripción:</strong>
		</td>
		<td align="left">
			<cfif modo eq 'ALTA'>
				<input type="text" name="CPTAEdescripcion" size="50" maxlength="50">
			<cfelse>
				<input type="text" name="CPTAEdescripcion" size="50" maxlength="50" value="#rsForm.CPTAEdescripcion#">
			</cfif>
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" colspan="4">
		<cfif modo eq 'ALTA'>
				<cf_botones modo='ALTA'>
		<cfelse>
				<cf_botones modo='CAMBIO'>
		</cfif>
		</td>
	</tr>
</cfoutput>
</table>
</form>
<cf_qforms form="form1">
	<cf_qformsRequiredField name="CPTAEcodigo" description="Código">
	<cf_qformsRequiredField name="CPTAEdescripcion" description="Descripción">
</cf_qforms>
