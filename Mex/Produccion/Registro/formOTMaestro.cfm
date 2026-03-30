
<!--- Establecimiento del modo --->
<cfif isdefined("Form.Alta")>
	<cfset modo="ALTA">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="CAMBIO">
	<cfelseif Form.modo EQ "ALTA">
		<cfset modo="ALTA">
	<cfelse>
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<!---<cfquery name="rsProdOTcodigo" datasource="#session.DSN#">
    select OTcodigo
    from Prod_OT
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
    order by OTcodigo
</cfquery>
--->
<cfif isdefined("Session.Ecodigo") AND isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0 >
	<cfquery name="rsProdOTDatos" datasource="#Session.DSN#">
		select OTcodigo, SNcodigo, OTdescripcion, OTfechaRegistro, OTfechaCompromiso, OTobservacion, OTstatus, ts_rversion  
		from Prod_OT 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">
	</cfquery>
<!---Primera vez--->
	<cfif rsProdOTDatos.recordCount EQ 0 >
        <cfset modo="ALTA">
    </cfif>    
</cfif>

<cfoutput>
<form method="post" name="form1" action="SQLOrdenTr1.cfm" <cfif isdefined("form.OTcodigo")>onSubmit="javascript: return valida(this)"</cfif>>
	<input name="tab" type="hidden" value="area" >
	<table align="center"  cellpadding="1" <!--- cellspacing="0" border="1" bordercolor="red"--->>
		<tr> 
			<td nowrap align="right"><strong>Orden de Trabajo :&nbsp;</strong></td>
            <td  nowrap="nowrap">
				<cfif modo EQ "ALTA">
                    <input name="OTcodigo" tabindex="1" type="text" size="14" maxlength="12" 
                    onfocus="javascript:this.select();"
                    value="<cfif isdefined("form.OTcodigo")>#form.OTcodigo#</cfif>"
                    onchange="document.location.href='RegOrdenTr.cfm?OTcodigo='+this.value;">
                <cfelse>
                    <input name="OTcodigo" tabindex="1" type="text" size="14" maxlength="12" 
                    onfocus="javascript:this.select();" readonly="readonly"
                    value="<cfif isdefined("form.OTcodigo")>#form.OTcodigo#</cfif>"
                    onblur="document.location.href='RegOrdenTr.cfm?OTcodigo='+this.value;">
                    
                
<!---                        <select name="OTcodigo" id="Empresa" tabindex="1" 
                        onblur="document.location.href='RegOrdenTr.cfm?OTcodigo='+this.value;">
                            <cfloop query="rsProdOTcodigo">
                            	<cfif isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0 >
                                	<option value="#rsProdOTcodigo.OTcodigo#"<cfif rsProdOTcodigo.OTcodigo EQ #form.OTcodigo#>selected</cfif>>#rsProdOTcodigo.OTcodigo# </option>
                                <cfelse>
                                	<option value="#rsProdOTcodigo.OTcodigo#"<cfif rsProdOTcodigo.OTcodigo EQ #rsProdOTcodigo.OTcodigo#>selected</cfif>>#rsProdOTcodigo.OTcodigo# </option>
                                </cfif>
                            </cfloop>
                        </select>
--->                
				</cfif>
            </td>
            <td  nowrap align="right"><strong>Fecha:&nbsp;</strong></td>
            <td  nowrap>
				<cfif modo NEQ "ALTA" AND isdefined("form.OTcodigo")><cfset fecha = #LSDateFormat(rsProdOTDatos.OTfechaRegistro,'dd/mm/yyyy')#><cfelse>
				<cfset fecha = "#LSDateFormat(Now(),'dd/mm/yyyy')#"></cfif>
                <cf_sifcalendario name="OTfechaReg"  value = "#fecha#" tabindex="2">
            </td>
   		</tr>
		<tr>
			<td nowrap align="right"><strong>Cliente:&nbsp;</strong></td>
            <td  nowrap>
				<cfif modo neq 'ALTA' AND isdefined("form.OTcodigo")>
					<cf_sifsociosnegocios2 idquery="#rsProdOTDatos.SNcodigo#">
				<cfelse>
					<cf_sifsociosnegocios2>
				</cfif>
        	</td>
            <td  nowrap align="right"><strong>Fecha Compromiso:&nbsp;</strong></td>
            <td  nowrap>
				<cfif modo NEQ "ALTA" AND isdefined("form.OTcodigo")><cfset fecha = #LSDateFormat(rsProdOTDatos.OTfechaCompromiso,'dd/mm/yyyy')#><cfelse>
				<cfset fechaC = "#LSDateFormat(Now(),'dd/mm/yyyy')#"></cfif>
                <cf_sifcalendario name="OTfechaComp"  value = "#fecha#" tabindex="3">
            </td>
   		</tr>
		<tr>
			<td nowrap align="right"><strong>Descripci&oacute;n OT:&nbsp;</strong></td>
			<td  nowrap colspan="3">
                <input name="OTdescripcion" tabindex="5" type="text" value="<cfif modo NEQ "ALTA" AND isdefined("form.OTcodigo")>#HTMLEditFormat(trim(rsProdOTDatos.OTdescripcion))#</cfif>" size="90" maxlength="100" onfocus="javascript:this.select();">
            </td>
        </tr>
		<tr>
			<td align="right"><strong>Observaciones:&nbsp;</strong></td>
			<td  nowrap colspan="3">
                    <textarea name="OTObs" tabindex="5" rows="6" cols="90" onfocus="javascript:this.select();"><cfif modo NEQ "ALTA" AND isdefined("form.OTcodigo")>#HTMLEditFormat( trim(rsProdOTDatos.OTobservacion))#</cfif></textarea>
            </td>
			<td  align="center" nowrap>
				<cfset ts = "">
                <cfif modo NEQ "ALTA" AND isdefined("form.OTcodigo")>
                    <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsProdOTDatos.ts_rversion#" returnvariable="ts"></cfinvoke>
                </cfif>		  
                <input  tabindex="-1" type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">	  
                <cfset tabindex= 2 >
                <cfinclude template="../../../sif/portlets/pBotones.cfm">
			</td>
		</tr>
	</table>
</form>
</cfoutput>
<!----*************************************************************--->
<script language="JavaScript1.2" type="text/javascript">
	document.form1.Baja.value="Cancelar"

	function valida(formulario){
		var error = false;
		var mensaje = "Se presentaron los siguientes errores:\n";
		if (formulario.OTcodigo.value == "" ){
			error = true;
			mensaje += " - El campo Orden de Trabajo es requerido.\n";
		}
		if (formulario.OTdescripcion.value == "" ){
			error = true;
			mensaje += " - El campo Descripción OT es requerido.\n";
		}
		if ( error ){
			alert(mensaje);
			return false;
		}else{
			return true;
		}
	}
</script>