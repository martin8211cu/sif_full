
<cfif isdefined("form.ID_Grupo") and form.ID_Grupo NEQ "">
	<cfquery name="rsFormGrupo" datasource="#session.dsn#">
		select
			a.Ecodigo,
			a.ID_Grupo,
			a.ID_Estr,
			a.EPGcodigo,
			a.EPGdescripcion,
            a.EPTipoAplica,
            EPCPcodigoref, EPCPnota,
            a.ts_rversion,
			a.ID_GrupoPadre
		from CGGrupoCtasMayor a
			where a.Ecodigo = #session.Ecodigo#
			and  a.ID_Grupo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_Grupo#">
			and  a.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_Estr#">
	</cfquery>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfset LB_Titulo = t.Translate('LB_Titulo','Grupo de Cuentas de Mayor')>
<cfset LB_Codigo = t.Translate('LB_Codigo','C&oacute;digo')>
<cfset LB_TipoAplica = t.Translate('LB_TipoAplica','Aplica para')>
<cfset LB_GrupoAplica = t.Translate('LB_GrupoAplica','Grupo padre')>
<cfset LB_Descripcion = t.Translate('LB_Descripcion','Descripci&oacute;n')>
<cfset LB_CuentasMayor = t.Translate('LB_CuentasMayor','Cuentas de Mayor')>
<cfset LB_Clasificadores = t.Translate('LB_Clasificadores','Clasificadores de Cuentas')>
<cfset LB_GrupoCuentasNinguno = t.Translate('LB_GrupoCuentasNinguno','Ninguno')>
<cfset LB_GrupoCuentasMayor = t.Translate('LB_GrupoCuentasMayor','Grupo Cuentas de Mayor')>
<cfset LB_GrupoClasificadores = t.Translate('LB_GrupoClasificadores','Grupo Clasificadores de Cuentas')>
<cfset LB_Nota = t.Translate('LB_Nota','Nota')>
<cfset LB_ReferenciaNota = t.Translate('LB_ReferenciaNota','Referencia Nota')>

<cfoutput>
	<fieldset>
	<legend><strong>#LB_Titulo#</strong>&nbsp;</legend>
		<form action="CatGrupoCtasMayor_SQL.cfm" method="post" name="formCM5"
        onSubmit="javascript: document.formCM5.EPGcodigo.disabled = false; return true;">

			<table width="80%" align="center" border="0" >
				<tr>
					<td align="left"><strong>#LB_Codigo#:</strong></td>
					<td>
                <input name="EPGcodigo"
					<cfif modo NEQ "ALTA"> class="cajasinbordeb" readonly tabindex="-1"
					<cfelse>
						tabindex="1"</cfif> type="text" value="<cfif modo NEQ "ALTA">#rsFormGrupo.EPGcodigo#<cfelseif isdefined('rsFormGrupo.EPGcodigo')>#rsFormGrupo.EPGcodigo#
					</cfif>"
						size="5" maxlength="5" />
					</td>
                    <td align="left"><strong>#LB_TipoAplica#:</strong></td>
                    <td>
                    	<cfset Form.Tipoaplica = 1>
                    	<cfif modo NEQ "ALTA">
                        	<cfset Form.Tipoaplica = #rsFormGrupo.EPTipoAplica#>
                    	</cfif>
                        <select name="Tipoaplica" id="Tipoaplica" onChange="javascript: changeTipoAplica(this);" tabindex="1">
                        	<option value="1" <cfif Form.Tipoaplica eq 1>selected</cfif>>#LB_CuentasMayor#</option>
                        	<option value="2" <cfif Form.Tipoaplica eq 2>selected</cfif>>#LB_Clasificadores#</option>
                        </select>
                    </td>
					<td align="right"><strong>#LB_GrupoAplica#:</strong></td>
					<cfquery name="rsMayor" datasource="#session.dsn#">
						select ID_GrupoPadre,EPGcodigo,EPGdescripcion
						from CGGrupoPadreCtas
						where EPTipoAplica = 1
							and Ecodigo = #session.Ecodigo#
							and ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fID_Estr#">
						order by EPGcodigo
					</cfquery>
					<cfquery name="rsClasificadores" datasource="#session.dsn#">
						select ID_GrupoPadre,EPGcodigo,EPGdescripcion
						from CGGrupoPadreCtas
						where EPTipoAplica = 2
							and Ecodigo = #session.Ecodigo#
							and ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fID_Estr#">
						order by EPGcodigo
					</cfquery>
					<td>
                    	<cfset Form.Grupoaplica = "">
                    	<cfif modo NEQ "ALTA">
                        	<cfset Form.Grupoaplica = #rsFormGrupo.ID_GrupoPadre#>
                    	</cfif>
                         <select name="GrupoAplica1" id="GrupoAplica1"
							<cfif modo EQ "ALTA" or Form.Tipoaplica eq 1>
								style="display: ";
							<cfelse>
								style="display: none";
	                        </cfif>
						>
							<option value="" >#LB_GrupoCuentasNinguno#</option>
                        	<cfloop query="rsMayor">
								<option value="#ID_GrupoPadre#" <cfif Form.Grupoaplica eq #ID_GrupoPadre#>selected</cfif>>#EPGcodigo# #EPGdescripcion#</option>
							</cfloop>
						</select>
						 <select name="GrupoAplica2" id="GrupoAplica2"
							<cfif modo NEQ "ALTA" and Form.Tipoaplica eq 2>
								style="display: ";
							<cfelse>
								style="display: none";
	                        </cfif>
						>
							<option value="" >#LB_GrupoCuentasNinguno#</option>
                        	<cfloop query="rsClasificadores">
								<option value="#ID_GrupoPadre#" <cfif Form.Grupoaplica eq #ID_GrupoPadre#>selected</cfif>>#EPGcodigo# #EPGdescripcion#</option>
							</cfloop>
                        </select>
                    </td>
				</tr>
				<tr>
					<td align="left"><strong>#LB_Descripcion#:</strong></td>
					<td colspan="6">
					<input type="text" name="EPGdescripcion" maxlength="130" size="130" id="EPGdescripcion" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsFormGrupo.EPGdescripcion)#</cfif>" />
					</td>
				</tr>
				<tr>
                    <td><strong>#LB_ReferenciaNota#:</strong></td>
                	<td>
					<input type="text" name="EPCPcodigoref" maxlength="5" size="5" id="EPCPcodigoref" tabindex="2" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsFormGrupo.EPCPcodigoref)#</cfif>"/>
                    </td>
<!---				</tr>
                <tr>
--->
					<td align="left"><strong>#LB_Nota#:</strong></td>
					<td colspan="5">
					<input type="text" name="EPCPnota" maxlength="250" size="100" id="EPCPnota" tabindex="3" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsFormGrupo.EPCPnota)#</cfif>"/>
                    </td>
                </tr>
				<tr valign="baseline">
					<td colspan="4" align="center" nowrap>
						<cfif isdefined("form.EPGcodigo")>
							<cf_botones modo="#modo#" tabindex="7">
						<cfelse>
							<cf_botones modo="#modo#" tabindex="7">
						</cfif>
					</td>
				</tr>
			</table>

			<cfset ts = "">
            <cfif modo NEQ "ALTA">
                <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsFormGrupo.ts_rversion#" returnvariable="ts">
                </cfinvoke>
                <input type="hidden" name="ID_Grupo" value="#rsFormGrupo.ID_Grupo#" >
				<input type="hidden" name="ID_Estr" value="#rsFormGrupo.ID_Estr#">
                <input type="hidden" name="ts_rversion" value="#ts#" >
			<cfelseif modo EQ "ALTA">
				<input type="hidden" name="ID_Estr" value="#rsTiposRep.ID_Estr#">
            </cfif>
		</form>
	</fieldset>
</cfoutput>

<cfoutput>
	<!---<cf_qforms form="form4">--->
	<cf_qforms form="formCM5">
	<script language="javascript1" type="text/javascript">
		<!--- objForm.EPGdescripcion.description = "#LB_Descripcion#";
		objForm.EPGdescripcion.required = true; --->
		document.formCM5.EPGdescripcion.required = true;
		<cfif modo NEQ 'ALTA'>
			document.formCM5.EPGcodigo.required = false;
		<cfelse>
			document.formCM5.EPGcodigo.required = true;
		</cfif>

		function changeTipoAplica(ctl) {
			if(ctl.value==1){
				document.getElementById("GrupoAplica1").style.display='';
				document.getElementById("GrupoAplica2").style.display='none';
				document.getElementById("GrupoAplica2").value='';
			}else{
				document.getElementById("GrupoAplica2").style.display='';
				document.getElementById("GrupoAplica1").style.display='none';
				document.getElementById("GrupoAplica1").value='';
			}

		}

		<!---<cfif modo NEQ 'ALTA'>
			document.formCM5.EPGdescripcion.focus();
		<cfelse>
			document.formCM5.EPGcodigo.focus();
			objForm.EPGcodigo.description   = "Código";
			objForm.EPGcodigo.required      = true;
		</cfif>--->
	</script>
</cfoutput>