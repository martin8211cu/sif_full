<cfif isDefined("Url.ID_Evento") and not isDefined("form.ID_Evento")>
  <cfset form.ID_Evento = Url.EVcodigo>
</cfif>

<cfif isDefined("Url.OperacionCodigo") and not isDefined("form.OperacionCodigo")>
  <cfset form.OperacionCodigo = Url.OperacionCodigo>
</cfif>

<cfif isDefined("Url.Transaccion")>
  <cfset form.Transaccion = Url.Transaccion>
</cfif>

<cfoutput>
<cfquery name="rsEvento" datasource="#Session.DSN#">
    select 
        a.EVcodigo,
        a.EVdescripcion,
        a.EVComplemento
    from EEvento a
        where a.Ecodigo = #session.Ecodigo# 
        and  a.ID_Evento = #form.ID_Evento#
</cfquery>
</cfoutput>
<cfquery name="rsOrigenes" datasource="#Session.DSN#">
	select Oorigen,Cdescripcion
	from ConceptoContable
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfif isdefined("form.ID_Operacion") and len(trim(form.ID_Operacion))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 
			a.ID_Evento,
			a.ID_Operacion,
			a.OperacionCodigo,
            a.Oorigen,
            cc.Cdescripcion,
            a.Transaccion,
            a.Complemento,
            a.ComplementoActivo,
            a.GeneraEvento,
            a.ts_rversion           
		from DEvento a
        inner join ConceptoContable cc on cc.Oorigen=a.Oorigen and cc.Ecodigo=#session.Ecodigo# 
        where a.ID_Evento = #form.ID_Evento#
            and a.ID_Operacion = #form.ID_Operacion#
	</cfquery>	
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfoutput>
	<fieldset>
	<legend><strong>Configuración Evento</strong>&nbsp;</legend>
		<form name="form1" method="post" action="DEvento_SQL.cfm" onSubmit="return valida();"> 
        <input type="hidden" name="ID_Evento" value="#form.ID_Evento#" >
			<table width="80%" align="center" border="0" >
				<tr>
					<td align="left"><strong>Identificador:</strong></td>
					<td colspan="2">
                	<input name="OperacionCodigo" <cfif modo NEQ "ALTA"> class="cajasinbordeb" readonly tabindex="-1" <cfelse> 
						tabindex="1"</cfif> type="text" value="<cfif modo NEQ "ALTA">#rsForm.OperacionCodigo#<cfelseif isdefined('form.OperacionCodigo')>#form.OperacionCodigo#</cfif>" 
						size="5" maxlength="5" />
					</td>
				</tr>	
				<tr>
					<td align="left"><strong>Origen:</strong></td>
					<td colspan="2">
                        <select name="Oorigen" tabindex="2" 
                  		onChange="javascript:this.form.action='ConfiguraEvento.cfm?ID_Event=#form.ID_Evento#';this.form.submit();">
                        	<option value="XXXX" selected="selected">Seleccionar Origen</option>
                            <cfloop query="rsOrigenes"> 
                                <option value="#rsOrigenes.Oorigen#"
                                    <cfif modo NEQ "ALTA" or isdefined("form.Oorigen")> 
                                            <cfif (rsOrigenes.Oorigen EQ form.Oorigen)>
                                                selected
                                            </cfif>
                                    </cfif>>
                                    #rsOrigenes.Oorigen#:#rsOrigenes.Cdescripcion#
                                </option>
                            </cfloop> 
                        </select>                    
					</td>
				</tr>
                <cfif isdefined('form.Oorigen')and len(trim(form.Oorigen)) and trim(form.Oorigen) neq "XXXX">	
				<tr>
                	<td align="left"><strong>Transacción:</strong></td>
                        <cfquery name="rsTabla" datasource="#Session.DSN#">
                            select Otabla, Ocampo, Odescripcion,Otransaccion
                            from OrigenTransaccion
                                where upper(Oorigen) like upper('%#form.Oorigen#%')
                        </cfquery> 
                        
                        <cfif rsTabla.recordCount GT 0>
                        	<cfif not len(trim(rsTabla.Otransaccion))>
                                <cfquery name="rsTrans" datasource="#Session.DSN#"> 
                                    select #rsTabla.Ocampo# as campo, #rsTabla.Odescripcion# as descripcion
                                    from  #rsTabla.Otabla#
                                    where Ecodigo = #session.Ecodigo#
                                </cfquery>  
                            </cfif>
                        </cfif>  
                                                           
                        <td colspan="2">
							<cfif rsTabla.recordCount GT 0>    
                        		<cfif not len(trim(rsTabla.Otransaccion))>
                                    <select name="Transaccion" tabindex="3" id="Transaccion"> 
                                    <option value="XXXX" selected="selected">Seleccionar Transacción</option>
                                    <cfloop query="rsTrans"> 
                                        <option value="#rsTrans.campo#"
                                            <cfif modo NEQ "ALTA" or isdefined("form.Transaccion")> 
                                                    <cfif (rsTrans.campo EQ form.Transaccion)>
                                                        selected
                                                    </cfif>
                                            </cfif>>
                                            #rsTrans.campo#:#rsTrans.descripcion#
                                        </option>
                                    </cfloop> 
                                    </select>
                                <cfelse>
                                    #rsTabla.Otransaccion#
                                    <input type="hidden" name="Transaccion" value="#rsTabla.Otransaccion#" >
								</cfif>
                        	<cfelse>
                                <select name="Transaccion" tabindex="3" id="Transaccion"> 
                                <option value="XXXX" selected="selected">Seleccionar Transacción</option>
                                </select>
                            	El origen contable no tiene transacciones
                            </cfif>    
                        </td>
                    
                </tr>
                
				<tr>
					<td colspan="2">
                        <input 	type="checkbox" name="ComplementoActivo" tabindex="5"  value="1"
                        onclick="javascript: ActualizaComplemento(this.form);"
						<cfif (modo NEQ "ALTA" and #rsForm.ComplementoActivo# EQ 1)>checked</cfif> >
						<strong>Usar Complemento</strong>						
                    </td>
                </tr> 
                <cfif (modo NEQ "ALTA" and #rsForm.ComplementoActivo# EQ 1)>
                	<tr id="bloqueComplemento" style="">
                <cfelse>
                <tr id="bloqueComplemento" style="display:none">
                </cfif>
                    <cfquery name="rsTabla" datasource="#Session.DSN#">
                        select OtablaC, OcampoC, OdescripcionC
                        from OrigenTransaccion
                            where upper(Oorigen) like upper('%#form.Oorigen#%')
                    </cfquery> 
                    <td><strong>Complemento:</strong></td>
                    <cfif #rsTabla.OtablaC# neq "" and #rsTabla.OcampoC# neq "" and #rsTabla.OdescripcionC# neq "">
                        <cfif rsTabla.recordCount GT 0>
                            <cfquery name="rsTrans" datasource="#Session.DSN#"> 
                                select #rsTabla.OcampoC# as campo, #rsTabla.OdescripcionC# as descripcion
                                from  #rsTabla.OtablaC#
                                where Ecodigo = #session.Ecodigo#                                 
                            </cfquery>
                        </cfif>
                        <td colspan="2">
                            <cfif rsTabla.recordCount GT 0>                        	
                                <select name="Complemento" tabindex="3"> 
                                <option value="XXXX" selected="selected">Seleccionar Complemento</option>
                                <cfloop query="rsTrans"> 
                                    <option value="#rsTrans.campo#"
                                        <cfif modo NEQ "ALTA" or isdefined("form.Complemento")> 
                                                <cfif (rsTrans.campo EQ form.Complemento)>
                                                    selected
                                                </cfif>
                                        </cfif>>
                                        #rsTrans.campo#:#rsTrans.descripcion#
                                    </option>
                                </cfloop> 
                                </select>
                            <cfelse>
                                El origen contable no tiene transacciones
                            </cfif>    
                        </td>
                    <cfelse>
                        <td  colspan="2">
                            <select name="Complemento" tabindex="3" id="Complemento"> 
                            <option value="XXXX" selected="selected">Seleccionar Complemento</option>
                            </select>
                        	El origen contable no tiene complementos registrados
                        </td>
                    </cfif>
                </tr>  
                </cfif>             
				<tr>
					<td colspan="2">
                        <input 	type="checkbox" name="GeneraEvento" tabindex="5" value="1" 
                        <cfif modo NEQ "ALTA" and isdefined("rsForm.GeneraEvento") and #rsForm.GeneraEvento# EQ 1> checked </cfif>><strong>Genera Evento</strong>
                    </td>
				</tr>	
				<tr><td colspan="4"></td></tr>
                
				<tr valign="baseline"> 
					<td colspan="3" align="center" nowrap>
						<cfif isdefined("form.OperacionCodigo")> 
							<cf_botones modo="#modo#" exclude = "baja" tabindex="7">
						<cfelse>
							<cf_botones modo="#modo#" tabindex="7">
						</cfif> 
					</td>
				</tr>
                <cfif isDefined("Url.Error")>
                <tr>
                	<cfif #Url.Error# eq 1>
                    	<cfset Mens="Las configuraciones que generan evento deben tener el mismo origen">
                    </cfif>
                	<cfif #Url.Error# eq 2>
                    	<cfset Mens="Existe una combinación Origen transacion que generan evento">
                    </cfif>
                    
                	<td colspan="2"><strong>#Mens#</strong></td>
                </tr>
				</cfif>
			</table>
			<cfset ts = "">
            <cfif modo NEQ "ALTA">
                <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts">        
                </cfinvoke>
                <input type="hidden" name="ID_Operacion"    value="#rsForm.ID_Operacion#" >
                <input type="hidden" name="ts_rversion" value="#ts#" >
            </cfif>
		</form>
	</fieldset>
    
<script language="JavaScript1.2" type="text/javascript">
	function ActualizaComplemento(f){
		var p4 = document.getElementById("bloqueComplemento");
		if (f.ComplementoActivo.checked) {
			p4.style.display = "";
		}
		else{
			p4.style.display = "none";
		}
	}
	
	function valida(){
		if (document.form1.Oorigen.value == "XXXX"){
			alert('Debe seleccionar un origen.');
			return false;
		}
		if ( document.form1.Transaccion.value == "XXXX" ){
			alert('Debe seleccionar un transacción.');
			return false;
		}
		if (document.form1.ComplementoActivo.checked) {
			if ( document.form1.Complemento.value == "XXXX" ){
				alert('Debe seleccionar un complemento.');
				return false;
			}
		}
		return true;
	}
</script>
</cfoutput>