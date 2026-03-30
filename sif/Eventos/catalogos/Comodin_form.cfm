<cfif isDefined("Url.ECcomodin") and not isDefined("form.ECcomodin")>
  <cfset form.ECcomodin = Url.ECcomodin>
</cfif>

<cfif isDefined("Url.ECRef")>
  <cfset form.ECRef = Url.ECRef>
</cfif>

<cfif isdefined("form.ECcomodin") and len(trim(form.ECcomodin))>
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select 
        	a.ID_Comodin,
			a.ECcomodin,
			a.ECReferencia,
			a.ECReferenciaOtro,            
			a.ECtipoDato,
            a.ECformato,            
            a.ECactivo,
            a.ts_rversion
		from ComodinEvento a
			where a.ECcomodin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.ECcomodin)#">
	</cfquery>	
	<cfset modo = "CAMBIO">
    
    <cfif rsForm.RecordCount eq 0>
		<cfset modo = "ALTA">
    </cfif>
    
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfoutput>
	<fieldset>
	<legend><strong>Formato</strong>&nbsp;</legend>
		<form action="Comodin_SQL.cfm" method="post" name="form1" 
        onSubmit="javascript: document.form1.ECcomodin.disabled = false; return true;"> 
        
			<table width="80%" align="center" border="0" >
				<tr>
					<td align="left"><strong>Formato:</strong></td>
					<td colspan="2">
                        <input name="ECcomodin" type="text"  id="ECcomodin"
                        <cfif modo NEQ "ALTA"> 
                            class="cajasinbordeb" readonly tabindex="-1" 
                        <cfelse> 
                            tabindex="1"
                        </cfif> 
                        <cfif modo NEQ "ALTA"> value="#rsForm.ECcomodin#"
                        <cfelseif isdefined('Form.ECcomodin')>
                                 value="#Form.ECcomodin#"  
                        </cfif>"
                        size="5" maxlength="5" />
					</td>
				</tr>	
				<tr>
					<td align="left"><strong>Referencia:</strong></td>
					<td colspan="2">
                        <select name="ECReferencia" 
                         onChange=
                       <cfif modo NEQ "ALTA">                                            "javascript:this.form.action='Comodin.cfm?ECcomodin=#form.ECcomodin#&ECRef=#form.ECReferencia#';this.form.submit();" 												<cfelse>
                  		"javascript:this.form.action='Comodin.cfm?ECRef=  ';this.form.submit();"
                        
                        </cfif>
                        tabindex="4" >
                          <option value="0" selected> Elegir Referencia </option>
                          <option value="1" <cfif (isDefined("Form.ECReferencia") AND "1" EQ Form.ECReferencia)>selected</cfif>>Periodo</option>
                          <option value="2" <cfif (isDefined("Form.ECReferencia") AND "2" EQ Form.ECReferencia)>selected</cfif>>Mes</option>
                          <option value="3" <cfif (isDefined("Form.ECReferencia") AND "3" EQ Form.ECReferencia)>selected</cfif>>Consecutivo</option>
                          <option value="4" <cfif (isDefined("Form.ECReferencia") AND "4" EQ Form.ECReferencia)>selected</cfif>>Origen</option>
                          <option value="5" <cfif (isDefined("Form.ECReferencia") AND "5" EQ Form.ECReferencia)>selected</cfif>>Transacci&oacute;n</option>
                          <option value="6" <cfif (isDefined("Form.ECReferencia") AND "6" EQ Form.ECReferencia)>selected</cfif>>Complemento</option>
                          <option value="7" <cfif (isDefined("Form.ECReferencia") AND "7" EQ Form.ECReferencia)>selected</cfif>>Otro</option>
                        </select>
					</td>
				</tr>	
				<tr>
                
                	<td align="left"><strong>Otro:</strong></td>
					<td colspan="2">
                    	<cfif (isDefined("Form.ECReferencia") AND "7" EQ Form.ECReferencia)>
                        <input type="text" name="ECReferenciaOtro" maxlength="40" size="40" id="ECReferenciaOtro" tabindex="3" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.ECReferenciaOtro)#</cfif>" />
                        <cfelse>
                        <input type="hidden" name="ECReferenciaOtro"    value="" >
                        </cfif>
                    </td>
                    
                </tr>
				<tr>
                	<td align="left"><strong>Tipo Dato:</strong></td>
					<td colspan="2">
                        <select name="ECtipoDato" onChange="javascript:chngtextREF(this);" tabindex="4" >
                          <option value="I" <cfif (isDefined("rsForm.ECtipoDato") AND "1" EQ rsForm.ECtipoDato)>selected</cfif>>Integer</option>
                          <option value="S" <cfif (isDefined("rsForm.ECtipoDato") AND "2" EQ rsForm.ECtipoDato)>selected</cfif>>String</option>
                        </select>
					</td> 
				</tr>                                       
				<tr>
					<td>
                        <input 	type="checkbox" name="ECactivo" tabindex="5" value="1" 
                        <cfif modo NEQ "ALTA" and isdefined("rsForm.ECactivo") and #rsForm.ECactivo# EQ 1> checked </cfif>><strong>Activo</strong>
                    </td>
					<td>
                        <input 	type="checkbox" name="ECformato" tabindex="6" alt="rigth" value="1"
                        <cfif modo NEQ "ALTA" and isdefined("rsForm.ECformato") and #rsForm.ECformato# EQ 'S'> checked </cfif>> <strong>Mantener Formato</strong>
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
			</table>
			<cfset ts = "">
            <cfif modo NEQ "ALTA">
                <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts">        
                </cfinvoke>
                <input type="hidden" name="ID_Comodin" value="#rsForm.ID_Comodin#" >
                <input type="hidden" name="ts_rversion" value="#ts#" >
            </cfif>
		</form>
	</fieldset>
</cfoutput>

<cfoutput>
	<cf_qforms form="form1">
	<script language="javascript1" type="text/javascript">
		objForm.ECcomodin.description = "Comod&iacute;n";
			
		objForm.ECcomodin.required = true;
		objForm.ECReferencia.required     = true;
			
		<cfif modo NEQ 'ALTA'>
			document.form1.ECcomodin.focus();
		<cfelse>
			document.form1.ECReferencia.focus();
			objForm.ECReferencia.description   = "Referencia";
			objForm.ECReferencia.required      = true;
		</cfif>
			
	</script>
</cfoutput>