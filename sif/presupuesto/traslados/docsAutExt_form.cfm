<cfif isdefined ('form.CPDAEid') AND form.CPDAEid NEQ "">
	<cfset modo='CAMBIO'>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 
			CPDAEid,
			Ecodigo, 
			CPDAEcodigo,
			CPDAEdescripcion,
			CPTAEid,
			case CPDAEestado
				when 0 then 	'Inactivo: El documento no se puede utilizar'
				when 1 then 	'Abierto: Se pueden asignar traslados'
				when 2 then 	'Pausa: No permite nuevos traslados'
				when 3 then 	'Cerrado: No permite aprobar traslados'
				when 10 then 	'APLICADO PARCIALMENTE'
				when 11 then 	'APLICADO'
				when 12 then 	'RECHAZADO'
			end as estado,
			CPDAEmontoCF,
			BMUsucodigo 
		from CPDocumentoAE
		where Ecodigo=#session.Ecodigo# 
		and CPDAEid=#form.CPDAEid#
	</cfquery>
<cfelse>
	<cfset modo='ALTA'>
</cfif>

<cfquery name="rsTipos" datasource="#session.dsn#">
	select 
		CPTAEid,
		CPTAEcodigo,
		CPTAEdescripcion
	from CPtipoAutExterna
	where Ecodigo=#session.Ecodigo# 
</cfquery>

<form name="form1" action="docsAutExt_sql.cfm" method="post" onSubmit="return validar(this);">
<cfif modo eq 'CAMBIO'>
	<cfoutput><input type="hidden" name="CPDAEid" value="#rsForm.CPDAEid#"></cfoutput>
</cfif>
<table align="center">
<cfoutput>
	<tr>
		<td align="right">
			<strong>Estado:</strong>
		</td>
		<td align="left">
			<cfif modo EQ 'CAMBIO'>
				<strong>#rsForm.Estado#</strong>
			<cfelse>
				<strong>Nuevo</strong>
			</cfif>
		</td>
	</tr>
	<tr>
		<td align="right">
			<strong>Num.Documento:</strong>
		</td>
		<td align="left">
			<cfif modo eq 'ALTA'>
				<input type="text" name="CPDAEcodigo" size="12" maxlength="10">
			<cfelse>
				<input type="text" name="CPDAEcodigo" size="12" maxlength="10" value="#trim(rsForm.CPDAEcodigo)#">
			</cfif>
		</td>
	</tr>
	<tr>
		<td align="right">
			<strong>Descripción:</strong>
		</td>
		<td align="left">
			<cfif modo eq 'ALTA'>
				<input type="text" name="CPDAEdescripcion" size="50" maxlength="50">
			<cfelse>
				<input type="text" name="CPDAEdescripcion" size="50" maxlength="50" value="#trim(rsForm.CPDAEdescripcion)#">
			</cfif>
		</td>
	</tr>
	<tr>
		<td align="right">
			<strong>Tipo&nbsp;Autorización:</strong>
		</td>
		<td align="left">
			<select name="CPTAEid">
			<cfloop query="rsTipos">
				<option value="#rsTipos.CPTAEid#" <cfif modo EQ 'CAMBIO' and rsTipos.CPTAEid EQ rsForm.CPTAEid>selected</cfif>>#rsTipos.CPTAEcodigo# - #rsTipos.CPTAEdescripcion#</option>
			</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td align="right">
			<strong>Monto por Centro Funcional:</strong>
		</td>
		<td align="left">
			<cfset LvarValor = "0.00">
			<cfif modo EQ 'CAMBIO'>
				<cfset LvarValor = rsForm.CPDAEmontoCF>
			</cfif>
			<cf_monto value="#LvarValor#" name="CPDAEmontoCF" size="20" decimales="2">
		</td>
	</tr>
	<tr>
		<td nowrap="nowrap" colspan="4">
		<cfif modo eq 'ALTA'>
				<cf_botones modo='ALTA' include="Ir_a_Lista">
		<cfelse>
				<cf_botones modo='CAMBIO' include="Ir_a_Lista">
		</cfif>
		</td>
	</tr>
</cfoutput>
</table>
</form>
<cf_qforms form="form1">
	<cf_qformsRequiredField name="CPDAEcodigo" description="Numero de Documento">
	<cf_qformsRequiredField name="CPDAEdescripcion" description="Descripción">
	<cf_qformsRequiredField name="CPTAEid" description="Tipo Autorización">
</cf_qforms>
<script>
	function funcIr_a_Lista()
	{
		deshabilitarValidacion();
	}
</script>