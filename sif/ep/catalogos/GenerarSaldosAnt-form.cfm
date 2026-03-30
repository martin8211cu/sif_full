
<cfif isdefined("form.ID_Saldo") and len(trim(form.ID_Saldo))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select ID_Saldo
		      ,ID_Estr
		      ,Descripcion
		      ,BMUsucodigo
		      ,ts_rversion
		      ,TipoAplica
		      ,Cant
       from CGEstrProgConfigSaldo
			where ID_Saldo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_Saldo#">
			and  ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_Estr#">
	</cfquery>

	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfset LB_Titulo = t.Translate('LB_Titulo','Generar saldos anteriores')>
<cfset LB_Codigo = t.Translate('LB_Codigo','C&oacute;digo')>
<cfset LB_TipoAplica = t.Translate('LB_TipoAplica','Aplica para')>
<cfset LB_Descripcion = t.Translate('LB_Descripcion','Descripci&oacute;n')>
<cfset LB_Meses = t.Translate('LB_Meses','Mes anterior')>
<cfset LB_Cierres = t.Translate('LB_Cierres','Mes cierre año anterior')>
<cfset LB_Grupos = t.Translate('LB_Grupos','Grupos de Grupo')>
<cfset LB_Nota = t.Translate('LB_Nota','Nota')>
<cfset LB_Grupo = t.Translate('LB_Grupo','Grupo Padre')>
<cfset LB_ReferenciaNota = t.Translate('LB_ReferenciaNota','Referencia Nota')>
<cfset LB_GrupoCuentasNinguno = t.Translate('LB_GrupoCuentasNinguno','Ninguno')>

<cfoutput>
	<fieldset>
	<legend><strong>#LB_Titulo#</strong>&nbsp;</legend>
		<form action="GenerarSaldosAnt-sql.cfm" method="post" name="form5">

			<table width="80%" align="center" border="0" >
				<tr>
					<td align="left"><strong>#LB_TipoAplica#:</strong></td>
                    <td>
                    	<cfset Form.Tipoaplica = 1>
						<cfset Form.Grupoaplica = -1>
                    	<cfif modo NEQ "ALTA">
                        	<cfset Form.Tipoaplica = #rsForm.TipoAplica#>
						</cfif>
                        <select name="Tipoaplica" id="Tipoaplica" tabindex="1">
							<option value="1" <cfif Form.Tipoaplica eq 1>selected</cfif>>#LB_Meses#  </option>
		                    <option value="2" <cfif Form.Tipoaplica eq 2>selected</cfif>>#LB_Cierres#</option>
						</select>
						<cfif modo NEQ "ALTA">
							<cf_inputNumber  name="numMeses" value="#rsForm.Cant#" enteros = "2" size="5" decimales = "0">
						<cfelse>
							<cf_inputNumber  name="numMeses" value="1" enteros = "2" size="5" decimales = "0">
						</cfif>

                    </td>
				</tr>
				<tr>
					<td align="left"><strong>#LB_Descripcion#:</strong></td>
					<td colspan="2">
					<input type="text" name="EPGdescripcion" maxlength="130" size="130" id="EPGdescripcion" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.Descripcion)#</cfif>" />
					</td>
				</tr>
				<tr valign="baseline">
					<td colspan="2" align="center" nowrap>
						<cfif isdefined("form.ID_Saldo")>
							<cf_botones modo="#modo#" tabindex="7">
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
                <input type="hidden" name="ID_Saldo" value="#rsForm.ID_Saldo#" >
				<input type="hidden" name="ID_Estr" value="#rsForm.ID_Estr#">
                <input type="hidden" name="ts_rversion" value="#ts#" >
			<cfelseif modo EQ "ALTA">
				<input type="hidden" name="ID_Estr" value="#rsTiposRep.ID_Estr#">
            </cfif>
		</form>
	</fieldset>
</cfoutput>

<cfoutput>
	<!---<cf_qforms form="form4">--->
	<!--- <cf_qforms form="form5">
	<script language="javascript1" type="text/javascript">
		objForm.EPGdescripcion.description = "#LB_Descripcion#";
		objForm.EPGdescripcion.required = true;
		objForm.numMeses.required = true;


		<!---<cfif modo NEQ 'ALTA'>
			document.form5.EPGdescripcion.focus();
		<cfelse>
			document.form5.EPGcodigo.focus();
			objForm.EPGcodigo.description   = "Código";
			objForm.EPGcodigo.required      = true;
		</cfif>--->
	</script> --->
</cfoutput>