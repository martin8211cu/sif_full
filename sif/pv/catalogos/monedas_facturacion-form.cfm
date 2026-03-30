<cfset modo = 'ALTA'>

<cfif isdefined('url.FAP02CON') and not isdefined('form.FAP02CON')>
	<cfparam name="form.FAP02CON" default="#url.FAP02CON#">
</cfif>

<cfif isdefined('form.FAP02CON') and len(trim(form.FAP02CON))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select FAP02CON, Mcodigo, FAP02FAC, FAP02COB, ts_rversion
		from FAP002
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and  FAP02CON = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAP02CON#">
	</cfquery>
	
<!--- query de lista  monedas --->
	<cfquery name="rsMonedas" datasource="#Session.DSN#" >
		Select Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Mcodigo#">		  
			order by Mnombre
	</cfquery>
</cfif> 

<!---  DESACTIVA LAS MONEDAS QUE YA HAN SIDO AGREGADAS--->
<cfquery name="rsMonQuitar" dbtype="query">
	Select Mcodigo,Mnombre
	from lista
	<cfif modo eq 'CAMBIO'>
		where Mcodigo not in (#data.Mcodigo#)
	</cfif>
</cfquery>

<cfoutput>
<form name="form1" method="post" action="monedas_facturacion-sql.cfm">
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="FAP02CON" value="#data.FAP02CON#">
	</cfif>
	<table width="100%" cellpadding="3" cellspacing="0">
		<tr>
			<td width="50%" align="right"><strong>Monedas</strong></td>
			<td width="50%">
			    <cfif modo NEQ "ALTA">
					<cfif isdefined('rsMonQuitar') and rsMonQuitar.recordCount GT 0>
						<cf_sifmonedas query="#rsMonedas#" quitar="#ValueList(rsMonQuitar.Mcodigo)#"> 
					<cfelse>
						<cf_sifmonedas query="#rsMonedas#"> 					
					</cfif>				
				<cfelse>
 					<cfif isdefined('rsMonQuitar') and rsMonQuitar.recordCount GT 0>
						<cf_sifmonedas quitar="#ValueList(rsMonQuitar.Mcodigo)#">
					<cfelse>
						<cf_sifmonedas>
					</cfif>
				</cfif> 		
		    </td>
		</tr>
		<tr>
		    <td align="right"><strong>Factura</strong></td>
				
			<td>
		       <input type="checkbox" name="FAP02FAC" VALUE "S" <cfif modo NEQ "ALTA" and data.FAP02FAC eq "1"> checked</cfif>>	 		
			</td>
		</tr>
		
		<tr>
		    <td align="right"><strong>Cobro</strong></td>
			<td>
		       <input type="checkbox" name="FAP02COB" Value "S" <cfif modo NEQ "ALTA" and data.FAP02COB eq "1">checked</cfif>>	
			</td>
		</tr>
		
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

<!-- MANEJA LOS ERRORES--->
<cf_qforms>
<script language="javascript">
<!--//
	objForm.Mcodigo.description = "Código de Moneda";
	
	function habilitarValidacion(){
		objForm.Mcodigo.required = true;
	}
	function deshabilitarValidacion(){
		objForm.Mcodigo.required = false;
	}
	habilitarValidacion();
//-->
</script>
</cfoutput>



