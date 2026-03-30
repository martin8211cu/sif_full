<cfif isdefined("form.EPcodigo") and len(trim(form.EPcodigo))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select
			a.Ecodigo,
			a.ID_Estr,
			a.EPcodigo,
			a.EPdescripcion,
            a.ts_rversion
		from CGEstrProg a
			where a.Ecodigo = #session.Ecodigo#
			and  a.EPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EPcodigo#">
	</cfquery>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfoutput>
	<fieldset>
	<legend><strong>Estructura Programática</strong>&nbsp;</legend>
		<form action="EstructuraP_SQL.cfm" method="post" name="form1"
        onSubmit="javascript: document.form1.EPcodigo.disabled = false; return true;">

			<table width="80%" align="center" border="0" >
				<tr>
					<td align="left"><strong>C&oacute;digo:</strong></td>
					<td colspan="2">
                <input name="EPcodigo" <cfif modo NEQ "ALTA"> class="cajasinbordeb" readonly tabindex="-1" <cfelse>
						tabindex="1"</cfif> type="text" value="<cfif modo NEQ "ALTA">#rsForm.EPcodigo#<cfelseif isdefined('rsForm.EPcodigo')>#rsForm.EPcodigo#</cfif>"
						size="5" maxlength="5" />
					</td>
				</tr>
				<tr>
					<td align="left"><strong>Descripci&oacute;n:</strong></td>
					<td colspan="2">
					<input type="text" name="EPdescripcion" maxlength="100" size="50" id="EPdescripcion" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.EPdescripcion)#</cfif>" />
					</td>
				</tr>
				<tr valign="baseline">
					<td colspan="3" align="center" nowrap>
						<cfif isdefined("form.EPcodigo")>
							<cf_botones modo="#modo#" exclude = "baja" tabindex="7">
						<cfelse>
							<cf_botones modo="#modo#" tabindex="7">
						</cfif>
					</td>
				</tr>

                <cfif isdefined("form.EPcodigo")>
                    <tr>
						<td>&nbsp</td>
                        <td align="center" nowrap>
                        <input type="button" name="BTN_Configurar"  value="Configurar Cuentas" tabindex="1"
                        onclick="javascript: location.href='CuentasEstrProg.cfm?fID_Estr=#rsForm.ID_Estr#';">
						</td>
						<td align="center" nowrap>
                        <input type="button" name="BTN_Caracteristicas"  value="Caracteristicas Especiales" tabindex="1"
                        onclick="javascript: location.href='ConfigEstrProg.cfm?fID_Estr=#rsForm.ID_Estr#';">
						</td>
                    </tr>
                </cfif>
			</table>
			<cfset ts = "">
            <cfif modo NEQ "ALTA">
                <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
                </cfinvoke>
                <input type="hidden" name="ID_Estr" value="#rsForm.ID_Estr#" >
                <input type="hidden" name="ts_rversion" value="#ts#" >
            </cfif>
		</form>
	</fieldset>
</cfoutput>

<cfoutput>
	<cf_qforms form="form1">
	<script language="javascript1" type="text/javascript">
		objForm.EPdescripcion.description = "Descripción";

		objForm.EPdescripcion.required = true;

	<!---	<cfif modo NEQ 'ALTA'>
			document.form1.EPdescripcion.focus();
		<cfelse>
			document.form1.EPcodigo.focus();
			objForm.EPcodigo.description   = "Código";
			objForm.EPcodigo.required      = true;
		</cfif>--->

	</script>
</cfoutput>