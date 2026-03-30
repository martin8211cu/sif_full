<cfif isdefined('url.CDCcodigo') and not isdefined('form.CDCcodigo')>
	<cfparam name="form.CDCcodigo" default="#url.CDCcodigo#">
</cfif>


<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<cfset modo = 'ALTA'>
<cfif  isdefined('url.Bid') and len(trim(url.Bid)) and not isdefined("form.Bid")>
	<cfset form.Bid = url.Bid>
</cfif>
<cfif  isdefined('url.FAM16NUM') and len(trim(url.FAM16NUM)) and not isdefined("form.FAM16NUM")>
	<cfset form.FAM16NUM = url.FAM16NUM>
</cfif>
<cfif  isdefined('url.FAM16NUM') and len(trim(url.FAM16NUM)) and not isdefined("form.FAM16NUM")>
	<cfset form.FAM16NUM = url.FAM16NUM>
</cfif>
<cfif  isdefined('form.Bid') and len(trim(form.Bid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>

	<cfquery name="data" datasource="#session.DSN#">
		select A.*, B.CDCnombre, C.Bdescripcion
		from FAM017 A, ClientesDetallistasCorp B, Bancos C
		where A.CDCcodigo = B.CDCcodigo 
		  and A.Bid = C.Bid
		  and A.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and A.FAM16NUM = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.FAM16NUM#">
		  order by FAM16NUM		
	</cfquery>

	<!--- QUERY PARA el tag de Clientes --->
	<cfif len(trim(data.CDCcodigo))>
	
		<cfquery name="rsClientes" datasource="#Session.DSN#" >
		select CDCcodigo, CDCidentificacion, CDCnombre
		from ClientesDetallistasCorp
		where CEcodigo = <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_numeric">
		  and CDCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CDCcodigo#">		
		</cfquery>
	
	</cfif>
	
	<cfquery name="rsBancos" datasource="#Session.DSN#">
		select Bid, Bdescripcion
		from Bancos
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and Bid=<cfqueryparam cfsqltype="cf_sql_integer" value="#data.Bid#">
	</cfquery>	
	
</cfif>

<cfquery name="rsBancos" datasource="#session.dsn#">
	select Bid, Bdescripcion
	from Bancos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by 1      
</cfquery>


<!-- SE UTILIZA PARA DESPLEGAR ---> 
<cfoutput>
<form name="form1" method="post" action="PagoCheques-sql.cfm">
	<!--- 
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="Bid" value="#data.Bid#">
	</cfif> --->
	<table width="100%" cellpadding="3" cellspacing="0">
		<cfif isdefined('form.FAM16NUM_F') and len(trim(form.FAM16NUM_F))>
        	<input type="hidden" name="FAM16NUM_F" value="#form.FAM16NUM_F#">
     	</cfif>
		
		<cfif isdefined('form.CDCcodigo_F') and len(trim(form.CDCcodigo_F))>
        	<input type="hidden" name="CDCcodigo_F" value="#form.CDCcodigo_F#">
     	</cfif>
				
		
		<tr>	
			<td align="right"><strong>Cuenta</strong></td>				
			<td>
				<input type="text" <cfif modo neq 'ALTA'>readonly</cfif> name="FAM16NUM" size="40" maxlength="15" value="<cfif modo neq 'ALTA'>#data.FAM16NUM#</cfif>">
			</td>
		</tr>
		<tr>	
			<td align="right"><strong>Banco</strong></td>				
			<td>
			<cfif isdefined("Bid")>
				<cfset CBid = #Bid#>
			</cfif>			
			<cfif modo NEQ "ALTA">
		        <cf_pvmbancos idquery="#rsBancos.Bid#" PBid="#data.Bid#"> 
			<cfelse>
				 <cf_pvmbancos>
			</cfif>
		</tr>		
		<tr>			
			<td align="right" width="23%"><strong>Cliente</strong></td>			
			<td width="77%">
				<cfif modo neq 'ALTA'  >
					<cf_sifClienteDetCorp modificable='false' modo='CAMBIO' idquery="#rsClientes.CDCcodigo#">
				<cfelse>
					<cf_sifClienteDetCorp modo='ALTA'>
				</cfif>		
												
			</td>				
		</tr>		
		<tr>
			<td align="right"><strong>Monto Máximo</strong></td>
			<td>
				<input name="FAM17MAX" type="text" id="FAM17MAX" <cfif modo neq 'Alta'>value="#data.FAM17MAX#"</cfif> style="text-align: right" value="0.00" size="20" maxlength="18" tabindex="1" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">			    
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
	objForm.CDCcodigo.required = true;
	objForm.CDCcodigo.description = "Cliente Corporativo";	
	objForm.FAM17MAX.required = true;
	objForm.FAM17MAX.description = "Monto Máximo";	
</script>