
<cfif isdefined("form.ID_GrupoPadre") and len(trim(form.ID_GrupoPadre))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select
			a.Ecodigo,
			a.ID_GrupoPadre,
			a.ID_Estr,
			a.EPGcodigo,
			a.EPGdescripcion,
			a.EPCPcodigoref,
			a.EPCPnota,
            a.EPTipoAplica,
			a.ID_Grupo_Ref GrupoRef,
			<!---  EPCPcodigoref, EPCPnota, --->
            a.ts_rversion
		from CGGrupoPadreCtas a
			where a.Ecodigo = #session.Ecodigo#
			and  a.ID_GrupoPadre = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_GrupoPadre#">
			and  a.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_Estr#">
	</cfquery>
	<cfset modoCP = "CAMBIO">
<cfelse>
	<cfset modoCP = "ALTA">
</cfif>

<cfset LB_Titulo = t.Translate('LB_Titulo','Grupo de Cuentas de Mayor')>
<cfset LB_Codigo = t.Translate('LB_Codigo','C&oacute;digo')>
<cfset LB_TipoAplica = t.Translate('LB_TipoAplica','Aplica para')>
<cfset LB_Descripcion = t.Translate('LB_Descripcion','Descripci&oacute;n')>
<cfset LB_CuentasMayor = t.Translate('LB_CuentasMayor','Grupos Cuentas de Mayor')>
<cfset LB_Clasificadores = t.Translate('LB_Clasificadores','Grupos Clasificadores de Cuentas')>
<cfset LB_Grupos = t.Translate('LB_Grupos','Grupos de Grupo')>
<cfset LB_Nota = t.Translate('LB_Nota','Nota')>
<cfset LB_Grupo = t.Translate('LB_Grupo','Grupo Padre')>
<cfset LB_ReferenciaNota = t.Translate('LB_ReferenciaNota','Referencia Nota')>
<cfset LB_GrupoCuentasNinguno = t.Translate('LB_GrupoCuentasNinguno','Ninguno')>

<cfoutput>
	<fieldset>
	<legend><strong>#LB_Titulo#</strong>&nbsp;</legend>
		<form action="CatGrupoPadreCtas_SQL.cfm" method="post" name="form5"
        onSubmit="document.form5.EPGcodigo.disabled = false; return true;">

			<table width="80%" align="center" border="0" >
				<tr>
					<td align="left"><strong>#LB_Codigo#:</strong></td>
					<td colspan="2">
                <input name="EPGcodigo" <cfif modoCP NEQ "ALTA"> class="cajasinbordeb" readonly tabindex="-1" <cfelse>
						tabindex="1"</cfif> type="text" value="<cfif modoCP NEQ "ALTA">#rsForm.EPGcodigo#<cfelseif isdefined('rsForm.EPGcodigo')>#rsForm.EPGcodigo#</cfif>"
						size="5" maxlength="5" />
					</td>
                    <td align="left"><strong>#LB_TipoAplica#:</strong></td>
                    <td>
                    	<cfset Form.Tipoaplica = 1>
						<cfset Form.Grupoaplica = -1>
                    	<cfif modoCP NEQ "ALTA">
                        	<cfset Form.Tipoaplica = #rsForm.EPTipoAplica#>
							<cfset Form.Grupoaplica = #rsForm.GrupoRef#>
                    	</cfif>
                        <select name="Tipoaplica" id="Tipoaplica" tabindex="1">
							<cfif modoCP NEQ "ALTA">
								<cfif Form.Tipoaplica neq 3>
		                        	<option value="1" <cfif Form.Tipoaplica eq 1>selected</cfif>>#LB_CuentasMayor#</option>
		                        	<option value="2" <cfif Form.Tipoaplica eq 2>selected</cfif>>#LB_Clasificadores#</option>
	                        	<cfelse>
	                        		<option value="3" <cfif Form.Tipoaplica eq 3>selected</cfif>>#LB_Grupos#</option>
	                        	</cfif>
	                        <cfelse>
                        		<option value="3" selected >#LB_Grupos#</option>
								<option value="1">#LB_CuentasMayor#</option>
		                        <option value="2">#LB_Clasificadores#</option>
							</cfif>
                        </select>
                    </td>
					<td align="left"><strong>#LB_Grupo#:</strong></td>
					<td align="left">
						<cfquery name="rsGruposPadres" datasource="#session.dsn#">
							select ID_GrupoPadre, EPGcodigo, EPGdescripcion
							from CGGrupoPadreCtas
							where 1=1
								and EPTipoAplica = 3
								and ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fID_Estr#">
								<cfif modoCP NEQ 'ALTA'>
									and ID_GrupoPadre <> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_GrupoPadre#">
									and (ID_Grupo_Ref is null or ID_Grupo_Ref <> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_GrupoPadre#">)
									or (EPTipoAplica = 3
										and ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fID_Estr#">
										and ID_GrupoPadre <> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_GrupoPadre#">
										and ID_Grupo_Ref <> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_GrupoPadre#">
										)
									or (EPTipoAplica = #Form.Tipoaplica#
										and ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fID_Estr#">
										and ID_GrupoPadre <> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_GrupoPadre#">
										and (ID_Grupo_Ref is null or ID_Grupo_Ref <> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_GrupoPadre#">)
										)
								</cfif>
							order by EPGcodigo
						</cfquery>
<!---						 <cfdump var="#rsGruposPadres#">--->

                        <select name="selgrupo" id="selgrupo" tabindex="2">
							<option value="" >#LB_GrupoCuentasNinguno#</option>
							<cfloop query="rsGruposPadres">
								<option value="#ID_GrupoPadre#" <cfif Form.Grupoaplica eq #ID_GrupoPadre#>selected</cfif>>#EPGcodigo# #EPGdescripcion#</option>
							</cfloop>
                        </select>&nbsp
                    </td>
				</tr>
				<tr>
					<td align="left"><strong>#LB_Descripcion#:</strong></td>
					<td colspan="6">
					<input type="text" name="EPGdescripcion" maxlength="130" size="130" id="EPGdescripcion" tabindex="1" style="border-spacing:inherit" value="<cfif modoCP NEQ 'ALTA'>#trim(rsForm.EPGdescripcion)#</cfif>" />
					</td>
				</tr>
				<tr>
                    <td><strong>#LB_ReferenciaNota#:</strong></td>
                	<td>
					<input type="text" name="EPCPcodigoref" maxlength="5" size="5" id="EPCPcodigoref" tabindex="2" style="border-spacing:inherit" value="<cfif modoCP NEQ 'ALTA'>#trim(rsForm.EPCPcodigoref)#</cfif>"/>
                    </td>
<!---				</tr>
                <tr>
--->
					<td align="left"><strong>#LB_Nota#:</strong></td>
					<td colspan="4">
					<input type="text" name="EPCPnota" maxlength="250" size="100" id="EPCPnota" tabindex="3" style="border-spacing:inherit" value="<cfif modoCP NEQ 'ALTA'>#trim(rsForm.EPCPnota)#</cfif>"/>
                    </td>
                </tr>
				<tr valign="baseline">
					<td colspan="6" align="center" nowrap>
						<cfif isdefined("form.EPGcodigo")>
							<cf_botones modo="#modoCP#" tabindex="7">
						<cfelse>
							<cf_botones modo="#modoCP#" tabindex="7">
						</cfif>
					</td>
				</tr>
			</table>

			<cfset ts = "">
            <cfif modoCP NEQ "ALTA">
                <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
                </cfinvoke>
                <input type="hidden" name="ID_Grupo" value="#rsForm.ID_GrupoPadre#" >
				<input type="hidden" name="ID_Estr" value="#rsForm.ID_Estr#">
                <input type="hidden" name="ts_rversion" value="#ts#" >
			<cfelseif modoCP EQ "ALTA">
				<input type="hidden" name="ID_Estr" value="#rsTiposRep.ID_Estr#">
            </cfif>
		</form>
	</fieldset>
</cfoutput>

<cfoutput>
	<!---<cf_qforms form="form4">--->
	<cf_qforms form="form5">
	<script language="javascript1" type="text/javascript">
		objForm.EPGdescripcion.description = "#LB_Descripcion#";
		objForm.EPGdescripcion.required = true;

		<cfif modo NEQ 'ALTA'>
			objForm.EPGcodigo.required      = false;
		<cfelse>
			objForm.EPGcodigo.required      = true;
		</cfif>

		<!---<cfif modoCP NEQ 'ALTA'>
			document.form5.EPGdescripcion.focus();
		<cfelse>
			document.form5.EPGcodigo.focus();
			objForm.EPGcodigo.description   = "Código";
			objForm.EPGcodigo.required      = true;
		</cfif>--->
	</script>
</cfoutput>