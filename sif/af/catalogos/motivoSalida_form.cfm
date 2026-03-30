<cfif isdefined("form.AFMScodigo") and len(trim(form.AFMScodigo))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select
			a.Ecodigo,
			a.AFMSid,
			a.AFMScodigo,
			a.AFMSdescripcion,
            a.ts_rversion
		from AFMotivosSalida a
			where a.Ecodigo = #session.Ecodigo#
			and  a.AFMScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFMScodigo#">
	</cfquery>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfoutput>
	<fieldset>
	<legend><strong>Motivo de Salida</strong>&nbsp;</legend>
		<form action="motivoSalida_SQL.cfm" method="post" name="form1"
        onSubmit="javascript: document.form1.AFMScodigo.disabled = false; return true;">

			<table width="80%" align="center" border="0" >
				<tr>
					<td align="left"><strong>C&oacute;digo:</strong></td>
					<td colspan="2">
                <input name="AFMScodigo" <cfif modo NEQ "ALTA"> class="cajasinbordeb" readonly tabindex="-1" <cfelse>
						tabindex="1"</cfif> type="text" value="<cfif modo NEQ "ALTA">#rsForm.AFMScodigo#<cfelseif isdefined('rsForm.AFMScodigo')>#rsForm.AFMScodigo#</cfif>"
						size="5" maxlength="5" />
					</td>
				</tr>
				<tr>
					<td align="left"><strong>Descripci&oacute;n:</strong></td>
					<td colspan="2">
					<input type="text" name="AFMSdescripcion" maxlength="100" size="50" id="AFMSdescripcion" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.AFMSdescripcion)#</cfif>" />
					</td>
				</tr>
				<tr valign="baseline">
					<td colspan="3" align="center" nowrap>
						<cfif isdefined("form.AFMScodigo")>
							<cf_botones modo="#modo#" exclude = "baja" tabindex="7">
						<cfelse>
							<cf_botones modo="#modo#" tabindex="7">
						</cfif>
					</td>
				</tr>
			</table>
			<cfset ts = "">
            <cfif modo NEQ "ALTA">
                <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
                </cfinvoke>
                <input type="hidden" name="AFMSid" value="#rsForm.AFMSid#" >
                <input type="hidden" name="ts_rversion" value="#ts#" >
            </cfif>
		</form>
	</fieldset>
</cfoutput>

<cfoutput>
	<cf_qforms form="form1">
	<script language="javascript1" type="text/javascript">
		objForm.AFMSdescripcion.description = "Descripción";

		objForm.AFMSdescripcion.required = true;

		<cfif modo EQ 'ALTA'>
			objForm.AFMScodigo.required      = true;
		</cfif>

	</script>
</cfoutput>