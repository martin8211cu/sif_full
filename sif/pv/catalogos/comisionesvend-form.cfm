<cfset modoCV= 'ALTA'>
<cfif  isdefined('form.FAM22RVI') and len(trim(form.FAM22RVI))
	and isdefined('form.FAX04CVD') and len(trim(form.FAX04CVD))>
    <cfset modoCV = 'CAMBIO'>
</cfif>

<cfif modoCV eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select *
		from FAM022
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and FAX04CVD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAX04CVD#">
		  and FAM22RVI = <cfqueryparam cfsqltype="cf_sql_money" value="#form.FAM22RVI#">
	</cfquery>
</cfif>

<!-- SE UTILIZA PARA DESPLEGAR ---> 
<cfoutput>
<form name="formCV" method="post" action="comisionesvend-sql.cfm">
	<cfif isdefined('form.FAX04CVD') and len(trim(form.FAX04CVD))>
		<input type="hidden" name="FAX04CVD" value="#form.FAX04CVD#">
	</cfif>
	<cfif isdefined("Form.FAM21CED_F") and Len(Trim(Form.FAM21CED_F)) NEQ 0>
		<input type="hidden" name="FAM21CED_F" value="#form.FAM21CED_F#">
	</cfif>	
	<cfif isdefined("Form.FAM21NOM_F") and Len(Trim(Form.FAM21NOM_F)) NEQ 0>
		<input type="hidden" name="FAM21NOM_F" value="#form.FAM21NOM_F#">
	</cfif>
	
	<table width="100%" cellpadding="3" cellspacing="0">
		<tr>
		  <td width="30%" align="right" nowrap><strong>Rango de Venta Inferior</strong></td>
		  <td width="25%" align="right"><input type="text"  name="FAM22RVI" size="15" maxlength="8" <cfif modoCV NEQ 'ALTA'>readonly=true</cfif> value="<cfif modoCV neq 'ALTA'>#data.FAM22RVI#<cfelse>0.00</cfif>" style="text-align: right" tabindex="2" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>	
		  <td width="26%" align="right" nowrap><strong>Rango de Venta Superior</strong></td>			
		  <td width="19%"><input type="text"  name="FAM22RVS" size="15" maxlength="8" value="<cfif modoCV neq 'ALTA'>#data.FAM22RVS#<cfelse>0.00</cfif>" style="text-align: right" tabindex="2" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
			</td>
		</tr>	 
		<tr>
		  <td align="right" nowrap><strong>Porcentaje de Comisi&oacute;n</strong></td>
		  <td align="right"><input type="text" name="FAM22PCO" size="15" maxlength="8" value="<cfif modoCV neq 'ALTA'>#data.FAM22PCO#</cfif>" tabindex="2" style="text-align: right" onKeyPress="if (event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;"></td>	
			<td align="right" nowrap><strong>Monto Tracto</strong></td>
			<td><input type="text" name="FAM22MON" size="15" maxlength="40" value="<cfif modoCV neq 'ALTA'>#data.FAM22MON#<cfelse>0.00</cfif>" style="text-align: right" tabindex="2" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
			</td>
		</tr>	 
		<tr>
		  <td>&nbsp;</td>
		  <td>&nbsp;</td>
	    <td>&nbsp;</td></tr>
		<tr>
			<td colspan="6" align="center">
				<cf_botones formName='formCV' modo='#modoCV#' sufijo='D' tabindex="2">
			</td>
		</tr>
	</table>
	
	<cfif modoCV neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
</form>

<!-- MANEJA LOS ERRORES--->

<cf_qforms form="formCV" objForm="objFormCV">
<script language="javascript">
	objFormCV.FAM22RVI.required = true;
	objFormCV.FAM22RVI.description = "Rango de Venta Inferior";
	
	objFormCV.FAM22RVS.required = true;
	objFormCV.FAM22RVS.description = "Rango de Venta Superior";
	
	objFormCV.FAM22PCO.required = true;
	objFormCV.FAM22PCO.description = "Porcentaje de Comision";
	
	objFormCV.FAM22MON.required = true;
	objFormCV.FAM22MON.description = "Monto Tracto";
</script>
</cfoutput>