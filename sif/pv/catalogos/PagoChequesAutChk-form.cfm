<cfif isdefined('url.CDCcodigo') and not isdefined('form.CDCcodigo')>
	<cfparam name="form.CDCcodigo" default="#url.CDCcodigo#">
</cfif>


<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<cfset modo = 'ALTA'>
<cfif  isdefined('url.CDCcodigo') and len(trim(url.CDCcodigo)) and not isdefined("form.CDCcodigo")>
	<cfset form.CDCcodigo = url.CDCcodigo>
</cfif>
<cfif  isdefined('form.CDCcodigo') and len(trim(form.CDCcodigo))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>

	<cfquery name="data" datasource="#session.DSN#">
		select A.CDCcodigo, A.FAM15AUT, A.FAM15MAX, B.CDCnombre,A.ts_rversion
		from FAM015 A, ClientesDetallistasCorp B
		where A.CDCcodigo = B.CDCcodigo
		  and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and A.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">
		order by A.CDCcodigo
	</cfquery>
	
	<cfif len(trim(data.CDCcodigo))>
	
		<cfquery name="rsClientes" datasource="#Session.DSN#" >
		select CDCcodigo, CDCidentificacion, CDCnombre
		from ClientesDetallistasCorp
		where CEcodigo = <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_numeric">
		  and CDCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CDCcodigo#">		
		</cfquery>
	
	</cfif>	
</cfif>

<!-- SE UTILIZA PARA DESPLEGAR ---> 
<cfoutput>
<form name="form1" method="post" action="PagoChequesAutChk-sql.cfm" >

	<table width="100%" cellpadding="3" cellspacing="0">
		<cfif isdefined('form.CDCcodigo_F') and len(trim(form.CDCcodigo_F))>
        	<input type="hidden" name="CDCcodigo_F" value="#form.CDCcodigo_F#">
     	</cfif>
		
		<tr>	
			<td align="right" nowrap><strong>Cliente Detallista</strong></td>				
			<td>
				<cfif modo neq 'ALTA'  >
					<cf_sifClienteDetCorp modificable='false' form="form1" modo='CAMBIO' idquery="#rsClientes.CDCcodigo#">
				<cfelse>
					<cf_sifClienteDetCorp  form="form1" modo='ALTA'>
				</cfif>				
			</td>
		</tr>
		<tr>			
			<td align="right" width="23%"><strong>Autorizado</strong></td>			
			<td width="77%"><input name="FAM15AUT" type="checkbox" value="1" <cfif modo NEQ "ALTA" and data.FAM15AUT eq 1> checked</cfif>></td></td>
	
		
		</tr>		
		<tr>
			<td align="right" nowrap><strong>Monto Máximo</strong></td>
			<td>
				<input name="FAM15MAX" type="text" id="FAM15MAX" value="<cfif modo neq 'ALTA'>#data.FAM15MAX#<cfelse>0.00</cfif>" style="text-align: right" size="20" maxlength="18" tabindex="1" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">			    
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'  >
					<cf_botones modo='CAMBIO'>
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
		</tr>

	</table>
	
	<cfif modo neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		
	</cfif>
	
</form>
</cfoutput>



<!-- MANEJA LOS ERRORES--->

<cf_qforms>
<script language="javascript">

	objForm.CDCcodigo.required = true;
	objForm.CDCcodigo.description = "Cliente Detallista";
	objForm.FAM15MAX.required = true;
	objForm.FAM15MAX.description = "Monto Máximo";	
</script>