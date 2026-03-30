<cfif isdefined("form.EVcodigo") and len(trim(form.EVcodigo))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 
			a.Ecodigo,
			a.ID_Evento,
			a.EVcodigo,
			a.EVdescripcion,
            a.EVformato,
            a.EVComplemento,
			a.EVactivo,
            a.EVtipoConsecutivo,            
            a.AgregaOperacion,
            a.ts_rversion
		from EEvento a
			where a.Ecodigo = #session.Ecodigo# 
			and  a.EVcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EVcodigo#">
	</cfquery>	
    
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfquery name="rsComodin" datasource="#Session.DSN#">
    select 
        a.ECcomodin,
        case                     
        when a.ECReferencia=1 then 'Periodo'
        when a.ECReferencia=2 then 'Mes'
        when a.ECReferencia=3 then 'Consecutivo'
        when a.ECReferencia=4 then 'Origen'
        when a.ECReferencia=5 then 'Transacción'
        when a.ECReferencia=6 then 'Complemento'
        when a.ECReferencia=7 then 'Otro' 
        end as defECReferencia,
        a.ECReferenciaOtro
    from ComodinEvento a
</cfquery>

<cfoutput>
	<fieldset>
	<legend><strong>Evento</strong>&nbsp;</legend>
		<form action="Evento_SQL.cfm" method="post" name="form1" 
        onSubmit="javascript: document.form1.EVcodigo.disabled = false; return true;"> 
        
			<table width="80%" align="center" border="0" >
				<tr>
					<td align="left"><strong>C&oacute;digo:</strong></td>
					<td colspan="2">
                <input name="EVcodigo" <cfif modo NEQ "ALTA"> class="cajasinbordeb" readonly tabindex="-1" <cfelse> 
						tabindex="1"</cfif> type="text" value="<cfif modo NEQ "ALTA">#rsForm.EVcodigo#<cfelseif isdefined('rsForm.EVcodigo')>#rsForm.EVcodigo#</cfif>" 
						size="5" maxlength="5" />
					</td>
				</tr>	
				<tr>
					<td align="left"><strong>Descripci&oacute;n:</strong></td>
					<td colspan="2">
					<input type="text" name="EVdescripcion" maxlength="40" size="40" id="EVdescripcion" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.EVdescripcion)#</cfif>" />
				</td>
				</tr>	
				<tr>
                	<td align="left"><strong>Formato Cadena:</strong></td>
					<td colspan="2">
					<input type="text" name="EVformato" maxlength="40" size="40" id="EVformato" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.EVformato)#</cfif>" />
                    </td>
                </tr>
                    <cfloop query="rsComodin">
                    <tr>
                        <td>&nbsp;</td>
                        <cfif #rsComodin.defECReferencia# eq "Otro">
                        <td colspan="2">#rsComodin.ECcomodin#-#rsComodin.ECReferenciaOtro#</td>
                        <cfelse>
                        <td colspan="2">#rsComodin.ECcomodin#-#rsComodin.defECReferencia#</td>
                        </cfif>
                    </tr>
                </cfloop>
				<tr>
                	<td align="left"><strong>Tipo Consecutivo:</strong></td>
					<td colspan="2">
                        <select name="ETipoConsecutivo" onChange="javascript:chngtextREF(this);" tabindex="1" >
                          <option value="1" <cfif (isDefined("rsForm.EVtipoConsecutivo") AND "1" EQ rsForm.EVtipoConsecutivo)>selected</cfif>>Mensual</option>
                          <option value="2" <cfif (isDefined("rsForm.EVtipoConsecutivo") AND "2" EQ rsForm.EVtipoConsecutivo)>selected</cfif>>Anual</option>
                          <option value="3" <cfif (isDefined("rsForm.EVtipoConsecutivo") AND "3" EQ rsForm.EVtipoConsecutivo)>selected</cfif>>Perpetuo</option>
                        </select>
					</td> 
				</tr>
				<tr>
					<td colspan="2">
                        <input 	type="checkbox" name="EVComplemento" tabindex="1" value="1" 
                        <cfif modo NEQ "ALTA" and isdefined("rsForm.EVComplemento") and #rsForm.EVComplemento# EQ 1> checked </cfif>><strong>Genera Evento por Periodo</strong>
                    </td>
                </tr>
				<tr>
					<td>
                        <input 	type="checkbox" name="EVactivo" tabindex="1" value="1" 
                        <cfif modo NEQ "ALTA" and isdefined("rsForm.EVactivo") and #rsForm.EVactivo# EQ 1> checked </cfif>><strong>Activo</strong>
                    </td>
					<td>
                        <input 	type="checkbox" name="AgregaOperacion" tabindex="1" alt="rigth" value="1"
                        <cfif modo NEQ "ALTA" and isdefined("rsForm.AgregaOperacion") and #rsForm.AgregaOperacion# EQ 1> checked </cfif>> <strong>Agrega Id.Operación</strong>
                    </td>
				</tr>	
				<tr><td colspan="3"></td></tr>
                
				<tr valign="baseline"> 
					<td colspan="3" align="center" nowrap>
						<cfif isdefined("form.EVcodigo")> 
							<cf_botones modo="#modo#" exclude = "baja" tabindex="7">
						<cfelse>
							<cf_botones modo="#modo#" tabindex="7">
						</cfif> 
					</td>
				</tr>
                
                <cfif isdefined("form.EVcodigo")>
                    <tr>
                        <td colspan="3" align="center" nowrap>
                        <input type="button" name="BTN_Configurar"  value="Definir Operaciones" tabindex="1"
                        onclick="javascript: location.href='ConfiguraEvento.cfm?ID_Evento=#rsForm.ID_Evento#';"> 
						</td>
                    </tr>
                </cfif>
			</table>
			<cfset ts = "">
            <cfif modo NEQ "ALTA">
                <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts">        
                </cfinvoke>
                <input type="hidden" name="ID_Evento" value="#rsForm.ID_Evento#" >
                <input type="hidden" name="ts_rversion" value="#ts#" >
            </cfif>
		</form>
	</fieldset>
</cfoutput>

<cfoutput>
	<cf_qforms form="form1">
	<script language="javascript1" type="text/javascript">
		objForm.EVdescripcion.description = "Descripción";
		objForm.EVformato.description     = "Formato Cadena";
			
		objForm.EVdescripcion.required = true;
		objForm.EVformato.required     = true;
			
		<cfif modo NEQ 'ALTA'>
			document.form1.EVdescripcion.focus();
		<cfelse>
			document.form1.EVcodigo.focus();
			objForm.EVcodigo.description   = "Código";
			objForm.EVcodigo.required      = true;
		</cfif>
			
	</script>
</cfoutput>