<cfif isdefined('url.FAM16NUM') and not isdefined('form.FAM16NUM')>
  	<cfparam name="form.FAM16NUM" default="#url.FAM16NUM#">
</cfif>

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<cfset modo = 'ALTA'>
<cfif  isdefined('url.Bid') and len(trim(url.Bid)) and not isdefined('form.Bid')>
	<cfset form.Bid = url.Bid>
</cfif>
<cfif  isdefined('url.FAM16NUM') and len(trim(url.FAM16NUM)) and not isdefined("form.FAM16NUM")>
	<cfset form.FAM16NUM = url.FAM16NUM>
</cfif>
<cfif  isdefined('form.Bid') and len(trim(form.Bid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>

	<cfquery name="data" datasource="#session.DSN#">
		select A.*, B.Bdescripcion
		from FAM016 A, Bancos B
		where A.Bid = B.Bid
		  and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and A.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
		  and A.FAM16NUM = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAM16NUM#">
		order by A.FAM16NUM
	</cfquery>
	
	<cfquery name="rsBancos" datasource="#Session.DSN#">
		select Bid, Bdescripcion
		from Bancos
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and Bid=<cfqueryparam cfsqltype="cf_sql_integer" value="#data.Bid#">
	</cfquery>	

</cfif>


<!-- SE UTILIZA PARA DESPLEGAR ---> 
<cfoutput>
<form name="form1" method="post" action="PagoChequesAut-sql.cfm">	
	<table width="100%" cellpadding="3" cellspacing="0">
		
		<cfif isdefined('form.FAM16NUM_F') and len(trim(form.FAM16NUM_F))>
        	<input type="hidden" name="FAM16NUM_F" value="#form.FAM16NUM_F#">
     	</cfif>
		
		<tr>	
			<td align="right"><strong>Cuenta</strong></td>				
			<td>
				<input type="text" <cfif modo neq 'ALTA'>readonly</cfif> name="FAM16NUM" size="20" maxlength="15" value="<cfif modo neq 'ALTA'>#data.FAM16NUM#</cfif>">
			</td>
		</tr>
		<tr>	
			<td align="right"><strong>Banco</strong></td>				
			<td>
			<cfif modo NEQ "ALTA">		        
				<cf_pvmbancos idquery="#rsBancos.Bid#" PBid="#data.Bid#"> 
			<cfelse> 
				 <cf_pvmbancos>
			</cfif>			
			</td>
		</tr>		
		<tr>			
			<td align="right" width="23%"><strong>Autorizada</strong></td>			
			<td width="77%"><input type="checkbox" name="FAM16AUT" <cfif isdefined("data.FAM16AUT") and data.FAM16AUT eq 1>checked</cfif> value="<cfif modo neq 'ALTA'>#data.FAM16AUT#</cfif>"></td>
		</tr>		
		<tr>
			<td align="right" nowrap><strong>Monto Máximo</strong></td>
			<td>
				<input name="FAM16MAX" type="text" id="FAM16MAX" <cfif modo neq 'Alta'>value="#data.FAM16MAX#"</cfif> style="text-align: right" value="0.00" size="20" maxlength="18" tabindex="1" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">			    
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

	objForm.FAM16NUM.required = true;
	objForm.FAM16NUM.description = "Cuenta Bancaria";
	objForm.Bid.required = true;
	objForm.Bid.description = "Banco";
	objForm.FAM16MAX.required = true;
	objForm.FAM16MAX.description = "Monto Máximo";	
</script>